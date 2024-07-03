#!/bin/sh
sudo apt-get update
sudo apt-get install -y git ca-certificates openssl curl

pip install --upgrade pip
pip install numpy pandas scipy matplotlib seaborn scikit-learn torch requests plotly jupyterlab_git certifi setuptools wheel keplergl
jupyter labextension install @jupyter-widgets/jupyterlab-manager keplergl-jupyter

HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4)}')
ARCH=ARM64
wget -O ${HUGO_VERSION}.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-${ARCH}.tar.gz && \
    tar xf ${HUGO_VERSION}.tar.gz && \
    sudo mv hugo /usr/bin/hugo && \
    rm xf ${HUGO_VERSION}.tar.gz hugo
