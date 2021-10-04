SHELL := /bin/bash

configs:
	./install.sh

copy_config:
	@mkdir -p dot_config/nvim
	@cp -rf ~/.config/nvim/* dot_config/nvim

