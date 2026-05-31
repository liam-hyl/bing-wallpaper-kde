#!/bin/bash

set -e

DIR="$HOME/Pictures/BingWallpapers"
mkdir -p "$DIR"

URL=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN" \
    | jq -r '.images[0].url')

FILE="$DIR/bing-$(date +%F).jpg"

if [ ! -f "$FILE" ]; then
    curl -L -o "$FILE" "https://www.bing.com$URL"
fi

# KDE Plasma 6 desktop wallpaper
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
for (const desktop of desktops()) {
    desktop.wallpaperPlugin = 'org.kde.image';
    desktop.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    desktop.writeConfig('Image', 'file://$FILE');
}
"

# KDE Plasma 6 lockscreen wallpaper
kwriteconfig6 \
    --file "$HOME/.config/kscreenlockerrc" \
    --group Greeter \
    --group Wallpaper \
    --group org.kde.image \
    --group General \
    --key Image \
    "$FILE"

kwriteconfig6 \
    --file "$HOME/.config/kscreenlockerrc" \
    --group Greeter \
    --group Wallpaper \
    --group org.kde.image \
    --group General \
    --key PreviewImage \
    "$FILE"

# Delete wallpapers older than 60 days
find "$DIR" -type f -mtime +60 -delete
