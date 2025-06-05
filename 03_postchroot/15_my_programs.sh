#!/usr/bin/env sh

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
