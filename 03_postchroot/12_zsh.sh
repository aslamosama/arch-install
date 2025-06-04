#!/usr/bin/env sh

mkdir -p "$HOME/.cache/zsh"
touch "$HOME/.cache/zsh/history"

ZSH_PATH="/usr/bin/zsh"

if [ -z "$ZSH_PATH" ]; then
  echo "❌ zsh not found. Please install it first."
  exit 1
fi
if [ "$SHELL" = "$ZSH_PATH" ]; then
  echo "✅ zsh is already your login shell."
  exit 0
fi
if chsh -s "$ZSH_PATH"; then
  echo "✔️ Changed login shell to: $ZSH_PATH"
else
  echo "❌ Failed to change login shell. Try running with sudo or check /etc/shells."
  exit 1
fi

zsh_updater

gowall completion zsh > ~/.config/zsh/completions/_gowall
