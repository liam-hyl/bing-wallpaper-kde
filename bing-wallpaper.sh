#!/bin/bash

set -e

RETENTION_DAYS=60

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

# Delete wallpapers older than some days
if [ "$RETENTION_DAYS" -gt 0 ]; then
    find "$DIR" -type f -mtime +"$RETENTION_DAYS" -delete
fi
