#!/usr/bin/env sh

# Install picom
cd ~/.local/src
git clone https://github.com/pijulius/picom.git
cd picom
git checkout -b implement-window-animations origin/implement-window-animations
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install
cd
