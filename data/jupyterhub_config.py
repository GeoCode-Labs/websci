from loguru import logger
from oauthenticator.google import GoogleOAuthenticator
from pymongo import MongoClient
import os

logger.add("/logs/log.log")

# Conectar ao MongoDB
# Conectar ao MongoDB usando as credenciais do .env
mongo_client = MongoClient(
    host=os.getenv("MONGO_HOST", "mongo"),
    port=int(os.getenv("MONGO_PORT", 27017)),
    username=os.getenv("MONGO_USER", "admin"),
    password=os.getenv("MONGO_PASSWORD", "strongpassword"),
    authSource=os.getenv("MONGO_DB", "jupyterhub")
)

db = mongo_client[os.getenv("MONGO_DB", "jupyterhub")]
users_collection = db["users"]

docker_default = {
    "image": os.getenv("DOCKER_IMAGE", "quay.io/jupyter/datascience-notebook:2025-01-28"),
    "mem_limit": os.getenv("DOCKER_MEM_LIMIT", "8G"),
    "cpu_limit": int(os.getenv("DOCKER_CPU_LIMIT", 4)),
    "network_name": os.getenv("DOCKER_NETWORK_NAME", "geocodelab"),
    "volumes": {
        '/docker/storage/jupyter/user/{username}': '/home/jovyan/work',
        '/docker/storage/jupyter/user/{username}/.ssh': '/home/jovyan/.ssh',
        '/docker/storage/jupyter/user/{username}/.jupyter': '/home/jovyan/.jupyter',
        '/docker/storage/jupyter/shared': '/home/jovyan/work/shared',
    }
}

# Buscar usuários no MongoDB
users_data = users_collection.find({})
allowed_users = []
admin_users = []

for user in users_data:
    username = user["_id"]
    allowed_users.append(username)
    if user.get("admin", False):
        admin_users.append(username)

logger.info(f"Usuários permitidos: {allowed_users}")
logger.info(f"Administradores: {admin_users}")


# Aplicar configurações do usuário no DockerSpawner
def user_docker_config(spawner):
    logger.info(f"Configurando o usuário: {spawner.user.name}")

    user_config = users_collection.find_one({"_id": spawner.user.name}) or {}

    spawner.notebook_dir = "/home/jovyan/work"
    spawner.image = user_config.get("image", docker_default["image"])
    spawner.network_name = user_config.get("network_name", docker_default["network_name"])
    spawner.mem_limit = user_config.get("mem_limit", docker_default["mem_limit"])
    spawner.cpu_limit = user_config.get("cpu_limit", docker_default["cpu_limit"])

    user_volumes = user_config.get("volumes", {})
    spawner.volumes = {**docker_default["volumes"], **user_volumes} if isinstance(user_volumes, dict) else \
    docker_default["volumes"]


c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.JupyterHub.hub_ip = "0.0.0.0"
c.JupyterHub.hub_connect_url = "http://jupyterhub:8081/hub/api"
c.JupyterHub.ssl_cert = "/ssl/certe.crt"
c.JupyterHub.ssl_key = "/ssl/key.key"
c.JupyterHub.port = 443
c.JupyterHub.bind_url = "https://0.0.0.0:443"

c.DockerSpawner.remove_containers = True
c.DockerSpawner.debug = True
c.Spawner.pre_spawn_hook = user_docker_config

c.JupyterHub.authenticator_class = GoogleOAuthenticator
c.GoogleOAuthenticator.client_id = os.getenv("GOOGLE_CLIENT_ID")
c.GoogleOAuthenticator.client_secret = os.getenv("GOOGLE_CLIENT_SECRET")
c.GoogleOAuthenticator.oauth_callback_url = os.getenv("GOOGLE_OAUTH_CALLBACK_URL")
c.GoogleOAuthenticator.hosted_domain = os.getenv("GOOGLE_HOSTED_DOMAIN", "geocodelabs.com")

c.Authenticator.allowed_users = set(allowed_users)
c.Authenticator.admin_users = set(admin_users)
c.DockerSpawner.notebook_dir = '/home/jovyan/work'
