#!/usr/bin/env sh

for program in dmenu dwm dwmblocks st slock; do
  cd ~/.config/suckless/$program
  git config merge.ours.driver true
  lazygit
  sudo make install
done
