# dotfiles

Just my dotfiles

## Distro

Im on [Arco Linux](https://arcolinux.com) with [Awesomewm](https://awesomewm.org) with the Multicolor theme.  

The awesomewm config is just a [ArcoLinux](https://github.com/arcolinux/arcolinux-awesome) config with some changes on [rc.lua](awesome/rc.lua).

## Editors
Neovim and Emacs. I use a customized version of [doom-nvim](https://github.com/doom-neovim/doom-nvim) for my Neovim config and a customized version of [doom-emacs](https://github.com/doomemacs/doomemacs) for my Emacs config.  

## Install

### Emacs

Install [doom-emacs](https://github.com/doomemacs/doomemacs#install) and then:

```bash
git clone https://lucascompython/dotfiles.git
cp -a ./dotfiles/emacs.d/. ~/.doom.d/
```

### Neovim

Install [doom-nvim](https://github.com/doom-neovim/doom-nvim#install) and then:

```bash
mv ./dotfiles/config/nvim/lsp_init.lua ~/.config/nvim/lua/doom/modules/features/lsp/init.lua # for github copilot tab completions
cp -rf ./dotfiles/config/nvim/ ~/.config/nvim/
```
