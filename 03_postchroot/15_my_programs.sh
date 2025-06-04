#!/usr/bin/env sh

cd ~/.config/lf/lf-file-handler || exit 1
bear -- make
sudo make install
cd

cd ~/.config/fetch || exit 1
sudo make install
cd
