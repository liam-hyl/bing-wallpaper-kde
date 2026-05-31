#!/bin/bash

set -e

echo "==> Stopping and disabling old services and timers..."
systemctl --user stop bing-wallpaper.timer 2>/dev/null || true
systemctl --user disable bing-wallpaper.timer 2>/dev/null || true
systemctl --user stop bing-wallpaper.service 2>/dev/null || true
systemctl --user disable bing-wallpaper.service 2>/dev/null || true

echo "==> Deleting systemd user files..."
rm -f ~/.config/systemd/user/bing-wallpaper.service
rm -f ~/.config/systemd/user/bing-wallpaper.timer
systemctl --user daemon-reload

echo "==> Deleting old script..."
rm -f ~/bin/bing-wallpaper.sh

echo
echo "Old version completely removed."
echo
echo "If you also want to clean up wallpaper images, run:"
echo "  rm -rf ~/Pictures/BingWallpapers"
