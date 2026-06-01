# Bing Wallpaper for KDE Plasma 6

Automatically download and set the daily Bing wallpaper as both your desktop and lock screen wallpaper on KDE Plasma 6.

## Features

- Daily Bing wallpaper download
- KDE Plasma 6 desktop wallpaper update
- KDE Plasma 6 lock screen wallpaper update
- Systemd timer automation
- Automatic cleanup of wallpapers older than 60 days(To change retention days, edit ~/bin/bing-wallpaper.sh and set RETENTION_DAYS (0 = keep forever))
- Prevents duplicate downloads

## Requirements

- KDE Plasma 6
- systemd
- Internet connection

## Installation

```bash
git clone https://github.com/liam-hyl/bing-wallpaper-kde.git
cd bing-wallpaper-kde
chmod +x install.sh
./install.sh
