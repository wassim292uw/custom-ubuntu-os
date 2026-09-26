#!/bin/bash

# Script: customize-desktop.sh
# Purpose: customize Ubuntu GNOME desktop with bottom taskbar and wallpaper

set -e

CURRENT_USER="${SUDO_USER:-$USER}"
HOME_DIR="/home/$CURRENT_USER"

if [ ! -d "$HOME_DIR" ]; then
  echo "User home not found: $HOME_DIR"
  exit 1
fi

echo "Customizing GNOME desktop..."

# Ensure dconf tools are installed
apt-get install -y dconf-cli

# Set dark theme
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'"

# Set wallpaper (if available)
if [ -f "wallpapers/default-wallpaper.png" ]; then
  WALLPAPER="file://$(pwd)/wallpapers/default-wallpaper.png"
  su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-uri '$WALLPAPER'"
  su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-uri-dark '$WALLPAPER'"
fi

# Bottom panel/taskbar behavior
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false"

# Enable animations
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface enable-animations true"

# Favorite apps
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Calendar.desktop']""

# Show apps on dock
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true"

# Set font
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'"

# Turn on hot corners
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface enable-hot-corners true"

echo "Desktop customization completed."
