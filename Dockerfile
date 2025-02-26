# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=quay.io/jupyter/datascience-notebook:2025-01-28



FROM $BASE_CONTAINER
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PROJ_LIB='/opt/conda/share/proj' \
    LOCALTILESERVER_CLIENT_PREFIX='proxy/{port}' \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 
#ENV NUMEXPR_MAX_THREADS=10
LABEL maintainer="Jairo Matos da Rocha <devjairomr@gmail.com>"



# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root 
# Ensure the ssh directory exists


RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    libspatialindex-dev \
    libpq-dev \
    libpoppler-cpp-dev \
    librsvg2-dev \
    screen \
    postgis \
    figlet \
    libxmlsec1-dev \
    libfreetype-dev \
    libcairo2-dev \
    libtiff-dev \
    libjpeg-dev \
    libpng-dev \
    libharfbuzz-dev \
    openmpi-bin \
    libopenmpi-dev \
    libicu-dev \
    rclone \
    iputils-ping htop \
    libhdf5-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libxt-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    gawk \
    libssh2-1-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libsasl2-dev \
    libglpk40 \
    libgdal-dev \
    libgeos++-dev \
    libudunits2-dev \
    libproj-dev \
    libx11-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libfreetype6-dev \
    libxt-dev \
    libfftw3-dev \
    libmagick++-dev \
    cargo \
    libsqlite3-dev \
    openjdk-11-jdk \
    libtiff5-dev \
    parallel \
    curl   &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*


USER ${NB_UID}


RUN mamba install --quiet --yes \
    jedi \
    localtileserver \
    osmnx \
    gdal \
    minio \
    polars \
    geopandas \
    cartopy \
    xarray \
    rasterio \
    pyproj \
    pystac-client \
    pydantic \
    motor \
    Rtree  \
    pytz \
    dynaconf \
    python-dotenv \ 
    geemap \
    pygis \
    imageio \
    hvplot \
    jupyter-server-proxy \
    plotly \
    networkx \
    ipympl \
    dask \
    bokeh \
    polars \
    localtileserver \
    keplergl \ 
    pydeck \ 
    loguru \
    pyarrow \
    psycopg2 \
    geoalchemy2 \
    leafmap \
    qgrid \
    ipyleaflet \
    xarray_leaflet \
    unidecode \
    rich \
    bertopic \
    nltk \
    contextily \
    wordcloud \
    jupyter-server-proxy \
    jupyter-resource-usage \
    duckdb \
    spacy \
    nltk \
    beautifulsoup4 \
    scikit-learn \
    ijson
    
RUN pip install pyalex \
    jupyter-server-proxy \
    jupyterlab_sublime \
    jupyterlab-s3-browser \
    jupyterlab-lsp \
    python-lsp-server \
    graphviz \
    python-geohash \
    jupyterlab-git \
    jupyterthemes  \
    ipympl \
    jupyterlab-fasta \
    jupyterlab-geojson \
    jupyterlab-katex \
    jupyterlab-mathjax2 \
    jupyterlab-vega3 \
    jupyterlab-latex \
    pylsp-mypy \
    pylsp-rope \
    jupyter_contrib_nbextensions \
    poetry
    
    
RUN   mamba install -c conda-forge --yes \
    udunits2 \
    leafmap \
    r-sf \
    r-geojsonio  \
    r-lidr \
    r-magick \
    imagemagick \
    udunits2 \
    r-units \
    r-terra \
    r-summarytools \
    r-rlas \
    r-rcppeigen \
    r-stars  \
    r-rnaturalearth \
    r-foreign \
    r-workflowr \
    r-coin \
    r-rmarkdown \
    r-mgcv  \
    r-mongolite \
    r-viridislite \
    r-tidyverse \
    r-ranger \
    r-tuneranger \
    r-mlr \
    r-cowplot \
    r-car \
    r-fitdistrplus \   
    r-pacman \
    r-corrplot \
    r-mice \
    r-missForest \
    r-gridExtra \
    r-hrbrthemes \
    r-gt \
    r-brms


ENV UDUNITS2_INCLUDE=/usr/include/ \
    UDUNITS2_LIB=/usr/lib/x86_64-linux-gnu \
    PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/include/glib-2.0:/opt/conda/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/opt/conda/lib/pkgconfig/:/usr/include/x86_64-linux-gnu/:/usr/include/librsvg-2.0/:/usr/include/x86_64-linux-gnu/bits" \ 
    DOWNLOAD_STATIC_LIBV8=1 \
    LD_LIBRARY_PATH=/usr/lib/jvm/java-1.11.0-openjdk-amd64/lib/server:$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/include/glib-2.0:/opt/conda/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/opt/conda/lib/pkgconfig/:/usr/include/x86_64-linux-gnu/:/usr/include/librsvg-2.0/:/usr/include/x86_64-linux-gnu/bits \
    PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/include/glib-2.0:/opt/conda/lib/pkgconfig/:/usr/include/openssl/:/usr/include/librsvg-2.0/:/usr/include/x86_64-linux-gnu/:/usr/include/x86_64-linux-gnu/bits:/usr/include:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/include/ImageMagick-6:/usr/local/bin:/opt/conda/lib/pkgconfig/:${PATH}" 
USER root


RUN apt-get update --yes && apt-get upgrade --yes && \
    apt-get install --yes --reinstall \
    build-essential \
    libc6-dev  && \
    apt-get install --yes --no-install-recommends \
    nodejs npm default-jre default-jdk libv8-dev libnode-dev libssl-dev libsasl2-dev
USER ${NB_UID}

COPY --chown=${NB_UID}:${NB_GID} install.R /tmp/install.R
RUN R CMD javareconf

RUN Rscript /tmp/install.R



RUN mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" &&\
    pip install ipyleaflet \
    folium solara \
    catppuccin-jupyterlab \
    jupyterlab-fonts \
    ipywidgets \
    jupyterlab_widgets && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager  &&\
    jupyter labextension install @shahinrostami/theme-purple-please &&\
    jupyter lab clean && \
    jupyter lab build

USER root


# Instalar dependências para baixar e descompactar o Nerd Fonts
RUN apt-get update && apt-get install -y \
    fontconfig
# Definir o diretório onde as fontes serão instaladas
RUN mkdir -p /usr/share/fonts/nerd-fonts

# Baixar e extrair a Nerd Font
RUN curl -fLo /tmp/nerd-fonts.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/BigBlueTerminal.zip \
    && unzip /tmp/nerd-fonts.zip -d /tmp \
    && mv /tmp/*.ttf /usr/share/fonts/nerd-fonts/ \
    && fc-cache -fv \
    && rm -rf /tmp/*

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    apt-transport-https ca-certificates gnupg &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg &&\
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    google-cloud-cli




RUN chown -R ${NB_UID}:${NB_GID} /home/${NB_USER}/work
RUN    apt-get clean && \
    rm -rf /tmp/* 

USER ${NB_UID}
