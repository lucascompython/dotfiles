# dotfiles

Just my dotfiles

## Distro

On my main desktop im on [Arco Linux](https://arcolinux.com) with [Awesomewm](https://awesomewm.org) with the Multicolor theme and on my main laptop I got [ArchCraft](https://archcraft.io) with [i3wm](https://i3wm.org) when I'm with Xorg and when I'm playing with Wayland I usually go with [Hyprland](https://hyprland.org).  

On my "test" laptop I am dual booting Linux with Windows using [Bedrock Linux](https://bedrocklinux.org) with [Regolith](https://regolith-desktop.com) Ubuntu hijacked and Windows 11. I might also experiment with [FreeBsd](https://www.freebsd.org).

The awesomewm config is just a [ArcoLinux](https://github.com/arcolinux/arcolinux-awesome) config with some changes on [rc.lua](awesome/rc.lua).

## Shell && Terminal

I mostly use [Zsh](https://www.zsh.org) with [Oh My Zsh](https://ohmyz.sh) and [Starship](https://starship.rs) on [Alacritty](https://github.com/alacritty/alacritty).

## Editors

I use Neovim and Emacs for my text editing needs. I use a customized version of [doom-nvim](https://github.com/doom-neovim/doom-nvim) for my Neovim config and a customized version of [doom-emacs](https://github.com/doomemacs/doomemacs) for my Emacs config.  
Don't forget to configure Github Copilot [on Emacs](https://github.com/zerolfx/copilot.el) and [on Neovim](https://github.com/github/copilot.vim).

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
