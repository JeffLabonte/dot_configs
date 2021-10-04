#!/bin/bash

fn backup () {
    cp -rf $1 $1.back
}

NVIM_PATH="${HOME}/.config/nvim"
TREE_VIM_PATH="${HOME}/tree.nvim"

backup $NVIM_PATH
backup $TREE_VIM_PATH

mkdir ${TREE_VIM_PATH} && \ 
    cd ${TREE_VIM_PATH} && sh $(wget -O- https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)  && \
    cd ${TREE_VIM_PATH} && sh $(curl -fsSL https://raw.githubusercontent.com/zgpio/tree.nvim/master/install.sh)

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

nvim +PlugInstall +q
