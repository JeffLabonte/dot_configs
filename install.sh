#!/bin/bash

NVIM_PATH="${HOME}/.config/nvim"

mkdir ${HOME}/tree.nvim && cd ${HOME}/tree.nvim && \ 
sh -c "$(wget -O- https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)" && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)"

if [ ! -d "${NVIM_PATH}" ]; then
    mkdir "${NVIM_PATH}"
fi

cp dot_config/nvim/* "${NVIM_PATH}"

# Install Packages

nvim +PlugInstall +q
