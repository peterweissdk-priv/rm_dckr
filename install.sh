#!/bin/bash
# ----------------------------------------------------------------------------
# Script Name: install.sh
# Description: Install rm_dckr (Docker cleanup tool) script
# Author: peterweissdk
# Usage: curl -fsSL https://raw.githubusercontent.com/peterweissdk-priv/rm_dckr/main/install.sh | bash
# ----------------------------------------------------------------------------

SCRIPT_NAME="rm_dckr"
SCRIPT_URL="https://raw.githubusercontent.com/peterweissdk-priv/rm_dckr/main/rm_dckr.sh"
DEFAULT_PATH="/usr/local/bin"

echo ""
echo "📦 Installing ${SCRIPT_NAME}..."

# Prompt for install path (read from tty to work with pipe)
if [ -t 0 ]; then
    # Interactive mode
    read -p "📁 Install path [${DEFAULT_PATH}]: " install_path
else
    # Piped mode - read from tty
    read -p "📁 Install path [${DEFAULT_PATH}]: " install_path </dev/tty
fi
install_path="${install_path:-$DEFAULT_PATH}"

# Create temp file
tmp_file=$(mktemp)
trap "rm -f $tmp_file" EXIT

# Download the script
echo "📥 Downloading ${SCRIPT_NAME}..."
if ! curl -fsSL "$SCRIPT_URL" -o "$tmp_file"; then
    echo "⛔ Failed to download ${SCRIPT_NAME}"
    exit 1
fi

# Install the script
echo "⚙️  Installing to ${install_path}/${SCRIPT_NAME}..."
if [ -w "$install_path" ]; then
    # User has write access
    if cp "$tmp_file" "$install_path/$SCRIPT_NAME" && chmod 755 "$install_path/$SCRIPT_NAME"; then
        echo "✅ Script installed successfully to ${install_path}/${SCRIPT_NAME}"
    else
        echo "⛔ Failed to install script"
        exit 1
    fi
elif sudo -n true 2>/dev/null; then
    # User has passwordless sudo
    if sudo cp "$tmp_file" "$install_path/$SCRIPT_NAME" && sudo chmod 755 "$install_path/$SCRIPT_NAME" && sudo chown root:root "$install_path/$SCRIPT_NAME"; then
        echo "✅ Script installed successfully to ${install_path}/${SCRIPT_NAME}"
    else
        echo "⛔ Failed to install script"
        exit 1
    fi
else
    # User needs to enter password for sudo
    echo "You need root privileges to install the script in ${install_path}."
    if sudo cp "$tmp_file" "$install_path/$SCRIPT_NAME" && sudo chmod 755 "$install_path/$SCRIPT_NAME" && sudo chown root:root "$install_path/$SCRIPT_NAME"; then
        echo "✅ Script installed successfully to ${install_path}/${SCRIPT_NAME}"
    else
        echo "⛔ Failed to install script"
        exit 1
    fi
fi

echo ""
echo "🚀 Run '${SCRIPT_NAME}' to clean up Docker resources (containers, images, networks, volumes)."
echo ""
