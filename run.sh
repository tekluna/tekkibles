#!/bin/bash

print_logo() {
    cat << "EOF"
████████╗███████╗██╗░░██╗██████╗░░█████╗░████████╗░██████╗
╚══██╔══╝██╔════╝██║░██╔╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
░░░██║░░░█████╗░░█████╔╝░██║░░██║██║░░██║░░░██║░░░╚█████╗░ hyprland dot files instalation
░░░██║░░░██╔══╝░░██╔═██╗░██║░░██║██║░░██║░░░██║░░░░╚═══██╗ by: tekluna (and Typecraft)
░░░██║░░░███████╗██║░░██╗██████╔╝╚█████╔╝░░░██║░░░██████╔╝
░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═════╝░░╚════╝░░░░╚═╝░░░╚═════╝░
EOF
}

# Parse command line arguments
DEV_ONLY=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dev-only) DEV_ONLY=true; shift ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

clear
print_logo

set -e

source utils.sh

if [ ! -f "packages.conf" ]; then
  echo "Woops: packages.conf was not found make sure it is in the same directory as this script..."
  exit 1
fi

source packages.conf

if [[ "$DEV_ONLY" == true ]]; then
  echo "Ok I'm going to start development-only setup..."
else
  echo "Ok I'm going to start full setup..."
fi

echo "I'm now going to update the system take care of yay AUR helper..."
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  if [[ ! -d "yay" ]]; then
    echo "Cloning yay repository..."
  else
    echo "You already have yay cloned, removing it..."
    rm -rf yay
  fi

  git clone https://aur.archlinux.org/yay.git

  cd yay
  echo "Nice! building yay..."
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay already installed, I'm gonna skip this step..."
fi

# Install packages by category
if [[ "$DEV_ONLY" == true ]]; then
  # Only install essential development packages
  echo "Now installing system utilities..."
  install_packages "${SYSTEM_UTILS[@]}"
  
  echo "Next I'll take care of installing development tools..."
  install_packages "${DEV_TOOLS[@]}"
else
  # Install all packages
  echo "Now installing system utilities..."
  install_packages "${SYSTEM_UTILS[@]}"
  
  echo "Next I'll take care of installing development tools..."
  install_packages "${DEV_TOOLS[@]}"
  
  echo "System maintenance tools..."
  install_packages "${MAINTENANCE[@]}"
  
  echo "Installing desktop environment..."
  install_packages "${DESKTOP[@]}"
  
  echo "More desktop environment stuff..."
  install_packages "${OFFICE[@]}"
 
  echo "This is taking a while Isn't it? Don't worry, I'm just installing some media packages..."
  sleep 2
  install_packages "${MEDIA[@]}"
  
  echo "Finaly, I'm going to install some fonts..."
  install_packages "${FONTS[@]}"
  
  echo "All done with the packages! Hang in there.."
  sleep 2

  # Enable services
  echo "Just configuring some services..."
  for service in "${SERVICES[@]}"; do
    if ! systemctl is-enabled "$service" &> /dev/null; then
      echo "Enabling $service..."
      sudo systemctl enable "$service"
    else
      echo "$service is already enabled"
    fi
  done
  
 echo "ALMOST DONE!!! Let me just install flatpaks"
  . install-flatpaks.sh
fi

  echo "SIKE! Not quite done yet, still need to stow the dotfiles..."
  . dotfiles-setup.sh 

echo "Setup complete! You may want to reboot your system."
end_logo (){
  cat << "EOF"
⠀⠀⠀⠀⠀⠀⠀⢀⣤⠖⠛⠉⠉⠛⠶⣄⡤⠞⠻⠫⠙⠳⢤⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⠟⠁⠀⠀⠀⠀⠀⠀⠈⠀⢰⡆⠀⠀⠐⡄⠻⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠦⠤⣤⣇⢀⢷⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢳⠀ ALL DONE!!!⠀⣿⡀⢈⡼⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⣆⢰⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⣼⠃⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⣎⢳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠃⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣝⠳⣄⡀⠀⠀⠀⠀⠀⢀⡴⠟⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢮⣉⣒⣖⣠⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣀⣴⠶⠶⢦⣀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⢀⣠⣤⣤⣀⠀⠀⠀
⠀⢀⡾⠋⠀⠀⠀⠀⠉⠧⠶⠒⠛⠛⠛⠛⠓⠲⢤⣴⡟⠅⠀⠀⠈⠙⣦⠀
⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⣠⡄⠀⠀⠀⣀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠸⣇
⠀⣿⡀⠀⠀⠀⠀⠀⢀⡟⢁⣿⠀⢠⠎⢙⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽
⠀⠈⢻⡇⠀⠀⠀⠀⣾⣧⣾⡃⠀⣾⣦⣾⠇⠀⠀⠀⠀⠀⠀⠀⠰⠀⣼⠇
⠀⢰⡟⠀⡤⠴⠦⣬⣿⣿⡏⠀⢰⣿⣿⡿⢀⡄⠤⣀⡀⠀⠀⠀⠰⢿⡁⠀
⠀⡞⠀⢸⣇⣄⣤⡏⠙⠛⢁⣴⡈⠻⠿⠃⢚⡀⠀⣨⣿⠀⠀⠀⠀⢸⡇⠀
⢰⡇⠀⠀⠈⠉⠁⠀⠀⠀⠀⠙⠁⠀⠀⠀⠈⠓⠲⠟⠋⠀⠀⠀⠀⢀⡇⠀
⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠇⠀
⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡄⠀
⠀⠀⠻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⠋⣷⠀
⠀⠀⢰⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠃⠀⣿⡇
⠀⠀⢸⡯⠈⠛⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠾⠋⠂⠀⠀⣿⠃
⠀⠀⠈⣷⣄⡛⢠⣈⠉⠛⠶⢶⣶⠶⠶⢶⡶⠾⠛⠉⠀⠀⠀⠁⢠⣠⡏⠀
⠀⠀⠀⠈⠳⣅⡺⠟⠀⣀⡶⠟⠁⠀⠀⠘⢷⡄⠀⠛⠻⠦⡄⢀⣒⡿⠀⠀
⠀⠀⠀⠀⠀⠈⠉⠉⠛⠁⠀⠀⠀⠀⠒⠂⠀⠙⠶⢬⣀⣀⣤⡶⠟⠁⠀⠀
RESTART YOUR SYSTEM JUST TO BE SURE
EOF
}
