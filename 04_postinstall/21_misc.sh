#!/usr/bin/env sh

# Clone voidrice
git clone https://github.com/lukesmithxyz/voidrice.git ~/.local/src/voidrice

# Clone bookmarks
if [ -d "$HOME/.local/src/bookmarks/.git" ]; then
  git -C "$HOME/.local/src/bookmarks" pull --rebase
else
  git clone https://github.com/fmhy/bookmarks.git "$HOME/.local/src/bookmarks"
fi

# Make soft links
ln -s /mnt/d/Music ~/Music
ln -s /mnt/e/me ~/Me

echo "Add music folder to cmus and set theme to night"
sleep 3
cmus

mkdir -p ~/Downloads/Images/Screenshots
mkdir -p ~/Downloads/Videos/Recordings

USERNAME=$(whoami)
MARKS_FILE="$HOME/.local/share/lf/marks"
mkdir -p "$(dirname "$MARKS_FILE")"
cat <<EOF > "$MARKS_FILE"
c:/mnt/c
d:/mnt/d
e:/mnt/e
r:/home/$USERNAME/Downloads/Videos/Recordings
s:/home/$USERNAME/Downloads/Images/Screenshots
w:/home/$USERNAME/.config/x11/themeconf
EOF

cd ~/.config/suckless
echo "checkout main branches of suckless tools"
echo "add remotes"
echo "https://github.com/bakkeby/dmenu-flexipatch.git"
echo "https://github.com/bakkeby/dwm-flexipatch.git"
echo "https://github.com/bakkeby/st-flexipatch.git"
echo "https://github.com/bakkeby/slock-flexipatch.git"
sleep 3
lazygit

# tldr
tldr --update

# Qalc config change
echo 'calculate_as_you_type=1' >>~/.config/qalculate/qalc.cfg
