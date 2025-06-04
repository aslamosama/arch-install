#!/usr/bin/env sh

# Configure git
git config --global user.name "aslamosama"
git config --global user.email "90507714+aslamosama@users.noreply.github.com"
git config init.defaultBranch main
git config --global pull.rebase false
mkdir -p ~/.config/git
mv "~/.gitconfig" "~/.config/git/config"
