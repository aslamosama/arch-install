#!/usr/bin/env sh

FONT_NAME="iso01-12x22"
FONT_PATH="/usr/share/kbd/consolefonts/${FONT_NAME}.psfu.gz"
VCONSOLE_CONF="/etc/vconsole.conf"
BACKUP_CONF="/etc/vconsole.conf.bak.$(date +%s)"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Check if font file exists
if [[ ! -f "$FONT_PATH" ]]; then
  echo "Font file not found: $FONT_PATH"
  exit 1
fi

# Backup current config
echo "Backing up $VCONSOLE_CONF to $BACKUP_CONF"
cp "$VCONSOLE_CONF" "$BACKUP_CONF"

# Update or insert FONT line
if grep -q "^FONT=" "$VCONSOLE_CONF"; then
  sed -i "s/^FONT=.*/FONT=${FONT_NAME}/" "$VCONSOLE_CONF"
else
  echo "FONT=${FONT_NAME}" >>"$VCONSOLE_CONF"
fi

echo "Font set to '$FONT_NAME'. Reboot or switch TTY to verify. Ctrl+Alt+Fn. Also pacman -S linux to rebuild the kernel"
