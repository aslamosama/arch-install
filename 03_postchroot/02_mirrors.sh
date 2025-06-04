#!/usr/bin/env sh

set -euo pipefail

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()    { printf "${BLUE}INFO:${NC} %s\n" "$1"; }
success() { printf "${GREEN}SUCCESS:${NC} %s\n" "$1"; }
warn()    { printf "${YELLOW}WARNING:${NC} %s\n" "$1"; }
error()   { printf "${RED}ERROR:${NC} %s\n" "$1"; exit 1; }

# File paths
MIRRORLIST="/etc/pacman.d/mirrorlist"
BACKUP="/etc/pacman.d/mirrorlist.bak.$(date +%F-%H%M%S)"

# Check for reflector
if ! command -v reflector >/dev/null 2>&1; then
  info "Installing reflector..."
  sudo pacman -S --noconfirm reflector || {
    error "Failed to install reflector."
  }
fi

# Backup existing mirrorlist
info "Backing up current mirrorlist to $BACKUP"
sudo cp "$MIRRORLIST" "$BACKUP" || {
  error "Backup failed"
}

# Run reflector
info "Ranking and updating mirrors..."
if sudo reflector -f 30 -l 30 --number 10 --download-timeout 30 --verbose --save "$MIRRORLIST"; then
  success "Mirrorlist successfully updated."
else
  warn "Reflector failed to update mirrorlist. Restoring backup..."
  sudo cp "$BACKUP" "$MIRRORLIST"
  error "Restored the previous mirrorlist."
fi
