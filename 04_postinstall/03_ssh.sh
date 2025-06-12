#!/usr/bin/env sh

# Restore ssh keys
mkdir -p "$HOME/.ssh"
tar -xzvf "$HOME/backup/ssh_backup.tar.gz" -C "$HOME"
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/"id_* 2>/dev/null
chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null
chown -R "$USER:$USER" "$HOME/.ssh"

if [ ! -f "$HOME"/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "90507714+aslamosama@users.noreply.github.com"
  echo "Paste public key github profile ssh settings. Here it is:"
  sleep 3
  cat ~/.ssh/id_ed25519.pub
  echo -e "\npress ENTER when done"
  read ENTER
fi

echo "Testing github now,"
ssh -T git@github.com
