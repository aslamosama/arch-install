#!/usr/bin/env sh

# Clone dotfiles and stow
cd
git clone git@github.com:aslamosama/dotfiles.git --depth=1 --recursive
mkdir -p ~/.config/{dunst,gtk-2.0,gtk-3.0,kitty,mpv,newsboat,shell,x11,zsh/completions}
mkdir -p ~/.local/bin
cd ~/dotfiles/scripts/.local/bin
chmod +x stower unstower
./stower
cd
