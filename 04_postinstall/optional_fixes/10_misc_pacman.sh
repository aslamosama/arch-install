#!/usr/bin/env sh

sudo rm /var/lib/pacman/db.lck
sudo pacman -Rns $(pacman -Qtdq)
