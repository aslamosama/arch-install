#!/usr/bin/env sh

for program in dmenu dwm dwmblocks st slock; do
  cd ~/.config/suckless/$program && lazygit && sudo make install
done
