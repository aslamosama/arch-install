#!/usr/bin/env sh

# ============================================
# Auto-tweak pacman.conf for better UX
# ============================================

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

PACMAN_CONF="/etc/pacman.conf"
BACKUP_CONF="/etc/pacman.conf.bak"

# --------------------------------------------
# Backup original config
# --------------------------------------------
if [ ! -f "$BACKUP_CONF" ]; then
  sudo cp "$PACMAN_CONF" "$BACKUP_CONF"
  success "Backup created at $BACKUP_CONF"
else
  info "Backup already exists at $BACKUP_CONF"
fi

# --------------------------------------------
# Temp file for changes
# --------------------------------------------
TMP_CONF=$(mktemp)

# --------------------------------------------
# Process config line-by-line
# --------------------------------------------
while IFS= read -r line; do
  # Trim leading spaces
  trimmed="$(printf "%s" "$line" | sed 's/^[[:space:]]*//')"

  case "$trimmed" in
    "Color"|"#Color")
      echo "Color" >>"$TMP_CONF"
      info "'Color' enabled"
      if ! grep -q '^ILoveCandy' "$PACMAN_CONF"; then
        echo "ILoveCandy" >>"$TMP_CONF"
        info "'ILoveCandy' enabled"
      fi
      ;;
    "VerbosePkgLists"|"#VerbosePkgLists")
      echo "VerbosePkgLists" >>"$TMP_CONF"
      info "'VerbosePkgLists' enabled"
      ;;
    "ParallelDownloads"*|"#ParallelDownloads"*)
      echo "ParallelDownloads = 5" >>"$TMP_CONF"
      info "'ParallelDownloads = 5' set"
      ;;
    *)
      echo "$line" >>"$TMP_CONF"
      ;;
  esac
done <"$PACMAN_CONF"

# --------------------------------------------
# Replace config safely
# --------------------------------------------
sudo mv "$TMP_CONF" "$PACMAN_CONF"
sudo chmod 644 "$PACMAN_CONF"

success "Successfully updated $PACMAN_CONF."
info "Showing differences:"
diff --color=always -u "$BACKUP_CONF" "$PACMAN_CONF" || true
