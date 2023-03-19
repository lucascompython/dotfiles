#!/usr/bin/env bash

echo "Copying emacs config..."
cp -a ~/.doom.d/. ./emacs.d/

echo "Copying neovim config..."
cp ~/.config/nvim/{config.lua,modules.lua} ./config/nvim/

echo "Copying zsh config..."
cp ~/.zshrc ./config/.zshrc

echo "Copying awesomewm config..."
cp ~/.config/awesome/rc.lua ./config/awesome/


