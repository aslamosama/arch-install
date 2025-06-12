#!/usr/bin/env sh

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

# Fix touchpad
if ! ls /etc/X11/xorg.conf.d/*touchpad.conf* 1>/dev/null 2>&1; then
  info "No touchpad conf found. Creating a new one in /etc/X11/xorg.conf.d"
  LAST_PREFIX=$(ls "$CONFIG_DIR" | grep -E '^[0-9]{2}-' | cut -d'-' -f1 | sort -n | tail -n 1)
  if [[ -z "$LAST_PREFIX" ]]; then
    NEW_PREFIX="00"
  else
    NEW_PREFIX=$(printf "%02d" $((10 + LAST_PREFIX)))
  fi
  mkdir -p /etc/X11/xorg.conf.d
  cat <<EOF >/etc/X11/xorg.conf.d/"${NEW_PREFIX}"-touchpad.conf
Section "InputClass"
  Identifier "touchpad"
  Driver "libinput"
  MatchIsTouchpad "on"
  Option "tapping" "on"
  Option "AccelProfile" "adaptive"
  Option "TappingButtonMap" "lrm"
EndSection
EOF
  success "New touchpad conf created..."
else
  warn "touchpad conf already exists. Exiting"
  exit 0
fi
