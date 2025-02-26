# Defina um mirror do CRAN
options(repos = c(CRAN = "https://cran.r-project.org"))

install.packages(c(
    'BiocManager',
    'rpostgis',
    'gamlss',
    'gamlss.dist',
    'gamlss.add',
    'gamlss.lasso',
    'rminer'
    ), dependencies = TRUE);
BiocManager::install(version = '3.18')