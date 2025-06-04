#!/usr/bin/env sh

# Define color codes
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info(){ printf "${BLUE}INFO:${NC} %s\n" "$1"; }

# Install yay
info "Installing yay-bin from AUR"
mkdir -p ~/.local/src
cd ~/.local/src
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
cd

info "Installing packages from AUR"
yay -S --needed ani-cli ctpv-git dict-wn dragon-drop gopeed-bin gowall iwe-bin mangal-bin networkmanager-dmenu-git pandoc-bin pandoc-crossref-bin phinger-cursors qogir-gtk-theme task-spooler vscode-langservers-extracted
