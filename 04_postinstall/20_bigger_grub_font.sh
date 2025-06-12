#!/usr/bin/env sh

FONT_SIZE="20"
FONT_NAME="DejaVuSansMono$FONT_SIZE"
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
TTF_PATH="$USER_HOME/.local/share/fonts/dejavu/DejaVuSansMono.ttf"
GRUB_FONT="/boot/grub/fonts/${FONT_NAME}.pf2"
GRUB_CFG="/etc/default/grub"
BACKUP_DIR="$HOME/grub-backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/grub-${TIMESTAMP}.cfg.bak"

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Backup GRUB config
echo "Backing up GRUB config to $BACKUP_FILE"
cp "$GRUB_CFG" "$BACKUP_FILE" || {
  echo "Backup failed. Aborting."
  exit 1
}

# Create GRUB font
echo "Generating GRUB font..."
grub-mkfont -s "$FONT_SIZE" -o "$GRUB_FONT" "$TTF_PATH" || {
  echo "Failed to generate GRUB font. Aborting."
  exit 1
}

# Set GRUB font if not already set
if ! grep -q "^GRUB_FONT=" "$GRUB_CFG"; then
  echo "Setting GRUB_FONT in $GRUB_CFG"
  printf '\nGRUB_FONT=%s\n' "$GRUB_FONT" >>"$GRUB_CFG"
else
  echo "Updating existing GRUB_FONT line"
  sed -i "s|^GRUB_FONT=.*|GRUB_FONT=${GRUB_FONT}|" "$GRUB_CFG"
fi

# Update GRUB
echo "Updating GRUB configuration..."
grub-mkconfig -o /boot/grub/grub.cfg || {
  echo "grub-mkconfig failed. You may need to restore from backup."
  exit 1
}

echo "Done. GRUB will use the new font on next boot. Delete ~/grub-backups if everything works fine."
