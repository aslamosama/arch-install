#!/usr/bin/env sh

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for colored output
info()    { printf "${BLUE}INFO:${NC} %s\n" "$1"; }
success() { printf "${GREEN}SUCCESS:${NC} %s\n" "$1"; }
warn()    { printf "${YELLOW}WARNING:${NC} %s\n" "$1"; }
error()   { printf "${RED}ERROR:${NC} %s\n" "$1"; exit 1; }

# --------------------------------------------
# Dependency Check
# --------------------------------------------

REQUIRED_TOOLS="git lazygit nvim zip rsync pcshare find tar"

missing_tools=""

for tool in $REQUIRED_TOOLS; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    missing_tools="$missing_tools $tool"
  fi
done

if [ -n "$missing_tools" ]; then
  warn "Missing required tools:$missing_tools"
  warn "Please install them before running this script."
  exit 1
fi


# --------------------------------------------
# 1. Commit and Push Dotfiles via lazygit
# --------------------------------------------

info "Opening lazygit to commit and push dotfiles..."
sleep 1
cd "$HOME/dotfiles" || error "Could not cd into '~/dotfiles'."

# Function to check if dotfiles repo is clean
is_repo_clean() {
  [ -z "$(git ls-files --others --exclude-standard)" ] && \
  [ -z "$(git diff --name-only)" ] && \
  [ -z "$(git diff --cached --name-only)" ] && \
  [ -z "$(git rev-list @{u}..HEAD 2>/dev/null)" ]
}

# Loop until repo is clean and pushed
while true; do
  lazygit
  if is_repo_clean; then
    success "dotfiles repo is clean and fully pushed."
    break
  else
    warn "dotfiles repo still has pending changes."
    read -r -p "Reopen lazygit? [Y/n] " choice
    case "$choice" in
      [nN]*) break ;;
      *) continue ;;
    esac
  fi
done

# If clean, copy dotfiles to backup
if is_repo_clean; then
  DOTFILES_BACKUP="$HOME/backup/dotfiles"
  info "Backing up clean dotfiles repo to '$DOTFILES_BACKUP'..."
  mkdir -p "$DOTFILES_BACKUP"
  rsync -a --exclude='.git' ./ "$DOTFILES_BACKUP/"
  if [ $? -eq 0 ]; then
    success "dotfiles copied to '$DOTFILES_BACKUP'."
  else
    warn "Failed to copy dotfiles."
  fi
fi

cd "$HOME" || error "Could not return to home directory."

# --------------------------------------------
# 2. Backup and Edit /etc/fstab
# --------------------------------------------
info "Backing up '/etc/fstab' to '~/backup/fstab.bak'..."
sleep 1

# Ensure backup directory exists
mkdir -p "$HOME/backup" || error "Failed to create '$HOME/backup'."
cp -iv /etc/fstab "$HOME/backup/fstab.bak" || error "Failed to copy /etc/fstab."

if [ -f "$HOME/backup/fstab.bak" ]; then
  success "fstab backed up as '$HOME/backup/fstab.bak'."
else
  error "Backup file '$HOME/backup/fstab.bak' was not found."
fi

warn "Next step: Remove NTFS mounting entries from /etc/fstab."
info "Opening '/etc/fstab' in sudo nvim..."
sleep 2
sudo nvim /etc/fstab || warn "Exited editor; ensure /etc/fstab was edited."

# --------------------------------------------
# 3. Backup Fonts
# --------------------------------------------
info "Backing up fonts from '~/.local/share/fonts'..."
sleep 1

FONT_DIR="$HOME/.local/share/fonts"
FONT_BACKUP="$HOME/backup/font_backup.zip"

if [ ! -d "$FONT_DIR" ]; then
  warn "Fonts directory '$FONT_DIR' not found; skipping font backup."
else
  cd "$FONT_DIR" || error "Failed to cd into '$FONT_DIR'."
  # Create a zip of all files and directories under ~/.local/share/fonts
  find . -type f -o -type d | zip -@ "font_backup.zip" >/dev/null 2>&1
  if [ -f "font_backup.zip" ]; then
    mv -iv "font_backup.zip" "$FONT_BACKUP" || error "Failed to move font_backup.zip."
    success "Fonts backed up to '$FONT_BACKUP'."
  else
    error "font_backup.zip was not created."
  fi
  cd "$HOME" || error "Failed to return to home directory."
fi

# --------------------------------------------
# 4. Backup Firefox Bookmarks & History
# --------------------------------------------
info "Backing up Firefox bookmarks and history..."
sleep 1

PROFILE_DIR="$HOME/.mozilla/firefox"
BACKUP_DIR="$HOME/backup/firefox_places"
mkdir -p "$BACKUP_DIR" || error "Failed to create '$BACKUP_DIR'."

for PROFILE_NAME in "default-release" "olddefault"; do
  PROFILE_PATH=$(find "$PROFILE_DIR" -maxdepth 1 -type d -name "*$PROFILE_NAME*" | head -n 1)
  if [ -d "$PROFILE_PATH" ]; then
    SRC="$PROFILE_PATH/places.sqlite"
    DEST="$BACKUP_DIR/places_${PROFILE_NAME}.sqlite"
    if [ -f "$SRC" ]; then
      cp -iv "$SRC" "$DEST" || warn "Failed to copy '$SRC'."
      if [ -f "$DEST" ]; then
        success "Backed up '$SRC' to '$DEST'."
      else
        warn "Backup '$DEST' not found after copy."
      fi
    else
      warn "File '$SRC' not found for profile '$PROFILE_NAME'."
    fi
  else
    warn "Profile directory matching '*$PROFILE_NAME*' not found."
  fi
done

# --------------------------------------------
# 5. Backup Newsboat URLs
# --------------------------------------------
info "Backing up Newsboat URLs..."
sleep 1

NEWSBOAT_SRC="$HOME/.config/newsboat/urls"
NEWSBOAT_DEST="$HOME/backup/newsboat-urls"

if [ -f "$NEWSBOAT_SRC" ]; then
  cp -iv "$NEWSBOAT_SRC" "$NEWSBOAT_DEST" || warn "Failed to copy Newsboat URLs."
  if [ -f "$NEWSBOAT_DEST" ]; then
    success "Newsboat URLs backed up to '$NEWSBOAT_DEST'."
  else
    warn "Backup file '$NEWSBOAT_DEST' not found."
  fi
else
  warn "Newsboat URL file '$NEWSBOAT_SRC' does not exist; skipping."
fi

# --------------------------------------------
# 6. Backup SSH Keys
# --------------------------------------------
info "Backing up SSH keys..."
sleep 1

SSH_DIR="$HOME/.ssh"
SSH_ARCHIVE="$HOME/backup/ssh_backup.tar.gz"

if [ -d "$SSH_DIR" ]; then
  tar -czvf "$SSH_ARCHIVE" -C "$HOME" .ssh >/dev/null 2>&1
  if [ -f "$SSH_ARCHIVE" ]; then
    success "SSH keys archived to '$SSH_ARCHIVE'."
  else
    error "Failed to create SSH backup archive."
  fi
else
  warn "SSH directory '$SSH_DIR' not found; skipping SSH backup."
fi

# --------------------------------------------
# 7. Zip Entire Backup Directory
# --------------------------------------------
info "Zipping the entire backup directory..."
sleep 1

BACKUP_ZIP="$HOME/backup.zip"
zip -r "$BACKUP_ZIP" "$HOME/backup" >/dev/null 2>&1
if [ -f "$BACKUP_ZIP" ]; then
  success "Backup directory zipped into '$BACKUP_ZIP'."
else
  error "Failed to create '$BACKUP_ZIP'."
fi

# --------------------------------------------
# 8. Share Backup (pcshare)
# --------------------------------------------
info "Preparing to share backup. Ensure mobile and PC are on the same network."
sleep 1

if command -v pcshare >/dev/null 2>&1; then
  info "Launching 'pcshare' to serve '$BACKUP_ZIP'..."
  info "Download file path should be Downloads/backup.zip"
  pcshare "$BACKUP_ZIP"
  if [ $? -eq 0 ]; then
    success "pcshare exited. Ensure you downloaded 'backup.zip' on your mobile device."
  else
    warn "pcshare encountered an error or was closed unexpectedly."
  fi
else
  warn "'pcshare' command not found; cannot share backup automatically."
  info "Manually copy '$BACKUP_ZIP' to your mobile device."
fi

# --------------------------------------------
# Done
# --------------------------------------------
success "Backup script completed."
