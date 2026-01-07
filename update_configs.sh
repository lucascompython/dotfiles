#!/usr/bin/env bash


echo "Copying hyprland config..."
cp -a ~/.config/hypr/. ./config/hypr/

echo "Copying waybar config..."
cp -a ~/.config/waybar/. ./config/waybar/

echo "Copying zsh config..."
cp ~/.zshrc .zshrc

echo "Copying nvim config..."
cp -a ~/.config/nvim/. ./config/nvim/


# echo "Copying emacs config..."
# cp -a ~/.doom.d/. ./emacs.d/

# echo "Copying neovim config..."
# cp ~/.config/nvim/{config.lua,modules.lua} ./config/nvim/

# echo "Copying zsh config..."
# cp ~/.zshrc ./config/.zshrc

# echo "Copying awesomewm config..."
# cp ~/.config/awesome/rc.lua ./config/awesome/
