#!/bin/bash

function backup () {
    cp -rf $1 $1.back
}

APT_INSTALLER=$(which apt)

if [[ -f "${APT_INSTALLER}" ]]; then
    sudo apt install pipx python3-dev python3-venv python-is-python3
fi

npm install -g npm

NVIM_PATH="${HOME}/.config/nvim"
TREE_VIM_PATH="${HOME}/tree.nvim"

backup "${NVIM_PATH}"
backup "${TREE_VIM_PATH}"

if [ ! -d "${TREE_VIM_PATH}" ]; then
    mkdir "${TREE_VIM_PATH}"
    cd ${TREE_VIM_PATH} && sh $(wget -O- https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)  && \
    cd ${TREE_VIM_PATH} && sh $(curl -fsSL https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)
fi

if [ ! -d "${NVIM_PATH}" ]; then
    mkdir "${NVIM_PATH}"
fi

cp -rf dot_config/nvim/ "${NVIM_PATH}"

pipx install 'python-lsp-server[all]'
npm i -g pyright

if [ ! -d ${HOME}/n ]; then
    curl -L https://git.io/n-install | bash
    source ~/.zshrc
    n lts
fi

nvim +PlugInstall
