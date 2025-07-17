#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/tekluna/hyprtekdots"
REPO_NAME="hyprtekdots"


is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

echo "HI TEKKI AGAIN! I'm going to install your Hyprland dotfiles, please wait a moment..."
sleep 2

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
 git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME/dotfiles"
  stow -t ~/ btop
  stow -t ~/ eww
  stow -t ~/ hypr
  stow -t ~/ kitty
  stow -t ~/ nvim
  stow -t ~/ oh-my-posh
  stow -t ~/ rofi
  stow -t ~/ tmux
  stow -t ~/ waybar
else
  echo -t ~/ "Woops: Failed to clone the repository."
  exit 1
fi
echo "ALL DONE! All your dotfiles should not be installed, please check them out!"
