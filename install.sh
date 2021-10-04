#!/bin/bash

NVIM_PATH="${HOME}/.config/nvim"
TREE_VIM_PATH="${HOME}/tree.nvim"

mkdir ${TREE_VIM_PATH} && \ 
    cd ${TREE_VIM_PATH} && sh $(wget -O- https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)  && \
    cd ${TREE_VIM_PATH} && sh $(curl -fsSL https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)

if [ ! -d "${NVIM_PATH}" ]; then
    mkdir "${NVIM_PATH}"
fi

cp dot_config/nvim/* "${NVIM_PATH}"

pipx install 'python-lsp-server[all]'
npm i -g pyright

nvim +PlugInstall +q
