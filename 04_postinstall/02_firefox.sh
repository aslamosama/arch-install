#!/usr/bin/env sh

PROFILE_DIR="$HOME/.mozilla/firefox"
BACKUP_DIR="$HOME/backup/firefox_places"
USER_JS_URL="https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
pkill firefox
sleep 2
restore_profile() {
  PROFILE_NAME="$1"
  BACKUP_FILE="$BACKUP_DIR/places_${PROFILE_NAME}.sqlite"
  PROFILE_PATH=$(find "$PROFILE_DIR" -maxdepth 1 -type d -name "*$PROFILE_NAME*" | head -n 1)
  if [ -d "$PROFILE_PATH" ]; then
    cp -iv "$BACKUP_FILE" "$PROFILE_PATH/places.sqlite"
    chmod 600 "$PROFILE_PATH/places.sqlite"
    chown $USER:$USER "$PROFILE_PATH/places.sqlite"
    curl -sSL "$USER_JS_URL" -o "$PROFILE_PATH/user.js"
    chmod 644 "$PROFILE_PATH/user.js"
  fi
}
firefox --CreateProfile "olddefault" >/dev/null
restore_profile "default-release"
restore_profile "olddefault"
echo "Set engine to duckduckgo for both profiles"
echo "press Enter once done"
read ENTER
echo "Set compact mode for both profiles"
echo "press Enter once done"
read ENTER
echo "about:config browser.tabs.closeWindowWithLastTab for both profiles"
echo "press Enter once done"
read ENTER
echo "Extensions-default: bitwarden, sponsorblock, ublock origin, scihub, turbo download manager, voilentmonkey"
echo "press Enter once done"
read ENTER
echo "Extensions-olddefault: bitwarden, turbo download manager, ublock origin, windscribe"
echo "press Enter once done"
read ENTER
echo "https://github.com/yokoffing/filterlists#guidelines for both profiles"
echo "press Enter once done"
read ENTER
echo "Disble PiP popup for both profiles"
echo "press Enter once done"
read ENTER
echo "Ctrl+H sort by last visited for both profiles"
echo "press Enter once done"
read ENTER
echo "Defult homepage and newtab page to blank for both profiles"
echo "press Enter once done"
read ENTER
echo "play with mpv userjs + mpv-handler for main profile"
echo "press Enter once done"
read ENTER
