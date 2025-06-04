#!/usr/bin/env sh

cd ~/.config/lf/lf-file-handler || exit 1
bear -- make
sudo make install
cd
