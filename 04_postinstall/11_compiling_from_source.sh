#!/usr/bin/env sh

cd ~/.local/src
git clone https://github.com/pijulius/picom.git
cd picom
git checkout -b implement-window-animations origin/implement-window-animations
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install
cd

cd ~/.local/src/lf-file-handler || exit 1
bear -- make
sudo make install
cd

cd ~/.local/src/fetch || exit 1
sudo make install
cd

cd ~/.local/src/fast-files || exit 1
sudo make install
cd
