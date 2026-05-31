#!/bin/bash

set -e

# Detect package manager
detect_package_manager() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    elif command -v apk &>/dev/null; then
        echo "apk"
    else
        echo "unknown"
    fi
}

# Install dependencies
install_dependencies() {
    local pkg_manager=$1
    echo "==> Detected package manager: $pkg_manager"
    echo "==> Installing dependencies..."
    
    case $pkg_manager in
        pacman)
            sudo pacman -S --needed curl jq qt6-tools kconfig
            ;;
        apt)
            sudo apt update
            sudo apt install -y curl jq qdbus-qt6 kf6-kconfig-bin
            ;;
        dnf|yum)
            sudo $pkg_manager install -y curl jq qt6-qttools kf6-kconfig
            ;;
        zypper)
            sudo zypper install -y curl jq qt6-tools-qdbus kf6-kconfig
            ;;
        apk)
            sudo apk add curl jq qt6-qdbus
            ;;
        *)
            echo "Warning: Unable to automatically install dependencies. Please install manually: curl, jq, qdbus6, kwriteconfig6"
            read -p "Press Enter to continue, or Ctrl+C to exit..." 
            ;;
    esac
}

# Main installation process
main() {
    echo "==> Bing Wallpaper Auto-Updater Installation Script"
    echo "==> Supports: Arch, Debian/Ubuntu, Fedora/RHEL, openSUSE, Alpine"
    echo
    
    # Detect package manager and install dependencies
    PM=$(detect_package_manager)
    install_dependencies $PM
    
    echo "==> Creating directories..."
    mkdir -p "$HOME/bin"
    mkdir -p "$HOME/Pictures/BingWallpapers"
    mkdir -p "$HOME/.config/systemd/user"
    
    # Check if script source file exists
    if [ ! -f "bing-wallpaper.sh" ]; then
        echo "Error: bing-wallpaper.sh not found"
        echo "Please ensure this installation script is in the same directory as bing-wallpaper.sh"
        exit 1
    fi
    
    echo "==> Copying wallpaper script..."
    cp bing-wallpaper.sh "$HOME/bin/bing-wallpaper.sh"
    chmod +x "$HOME/bin/bing-wallpaper.sh"
    
    echo "==> Creating systemd user service..."
    cat > "$HOME/.config/systemd/user/bing-wallpaper.service" <<'EOF'
[Unit]
Description=Bing Daily Wallpaper

[Service]
Type=oneshot
ExecStart=%h/bin/bing-wallpaper.sh
EOF
    
    cat > "$HOME/.config/systemd/user/bing-wallpaper.timer" <<'EOF'
[Unit]
Description=Bing Daily Wallpaper Timer

[Timer]
OnBootSec=1min
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF
    
    echo "==> Enabling timer..."
    systemctl --user daemon-reload
    systemctl --user enable --now bing-wallpaper.timer
    
    echo "==> First run test..."
    "$HOME/bin/bing-wallpaper.sh"
    
    echo
    echo "==================================="
    echo "Installation Complete"
    echo "==================================="
    echo
    echo "Check status:"
    systemctl --user --no-pager status bing-wallpaper.timer || true
    echo
    echo "Next run time:"
    systemctl --user list-timers bing-wallpaper.timer
}

# Run main function
main
