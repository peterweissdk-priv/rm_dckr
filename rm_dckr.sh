#!/bin/bash
# ----------------------------------------------------------------------------
# Script Name: rm_dckr.sh
# Description: Tool designed to help you clean up Docker resources
# Author: peterweissdk
# Email: peterweissdk@flems.dk
# Date: 2025-01-06
# Version: v1.1.0
# Usage: Run script, follow instructions or -h for help
# ----------------------------------------------------------------------------

VERSION="1.1.0"
SCRIPT_NAME="rm_dckr"
SCRIPT_URL="https://raw.githubusercontent.com/peterweissdk-priv/rm_dckr/main/rm_dckr.sh"

# Function to display help
show_help() {
    echo ""
    echo "Usage: ${SCRIPT_NAME} [OPTIONS]"
    echo ""
    echo "Tool designed to help you clean up Docker resources"
    echo ""
    echo "Options:"
    echo "  -h, --help      Display this help message"
    echo "  -v, --version   Display the current version"
    echo "  -u, --update    Update ${SCRIPT_NAME} to the latest version"
    echo ""
    echo "Without options, the script will interactively prompt to remove:"
    echo "  - All Docker containers"
    echo "  - All Docker images"
    echo "  - All Docker networks"
    echo "  - All Docker volumes"
    echo ""
}

# Function to display version
show_version() {
    echo "${SCRIPT_NAME} version ${VERSION}"
}

# Function to update the script
update_script() {
    echo "🔍 Checking for updates..."
    
    # Get remote version
    remote_version=$(curl -fsSL "$SCRIPT_URL" 2>/dev/null | grep -m1 '^VERSION=' | cut -d'"' -f2)
    
    if [ -z "$remote_version" ]; then
        echo "⛔ Failed to check for updates"
        exit 1
    fi
    
    if [ "$remote_version" = "$VERSION" ]; then
        echo "✅ You are already running the latest version (${VERSION})"
        exit 0
    fi
    
    echo "📦 New version available: ${remote_version} (current: ${VERSION})"
    echo "📥 Downloading update..."
    
    # Create temp file
    tmp_file=$(mktemp)
    trap "rm -f $tmp_file" EXIT
    
    if ! curl -fsSL "$SCRIPT_URL" -o "$tmp_file"; then
        echo "⛔ Failed to download update"
        exit 1
    fi
    
    # Get the path of the current script
    script_path=$(realpath "$0")
    
    echo "⚙️  Installing update..."
    if [ -w "$script_path" ]; then
        if cp "$tmp_file" "$script_path" && chmod 755 "$script_path"; then
            echo "✅ Updated successfully to version ${remote_version}"
        else
            echo "⛔ Failed to install update"
            exit 1
        fi
    elif sudo -n true 2>/dev/null; then
        if sudo cp "$tmp_file" "$script_path" && sudo chmod 755 "$script_path"; then
            echo "✅ Updated successfully to version ${remote_version}"
        else
            echo "⛔ Failed to install update"
            exit 1
        fi
    else
        echo "You need root privileges to update the script."
        if sudo cp "$tmp_file" "$script_path" && sudo chmod 755 "$script_path"; then
            echo "✅ Updated successfully to version ${remote_version}"
        else
            echo "⛔ Failed to install update"
            exit 1
        fi
    fi
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        -u|--update)
            update_script
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
    shift
done

# Function to prompt for user confirmation with a default of 'y'
confirm() {
    read -p "$1 (y/n, default is y): " -r
    REPLY=${REPLY:-y}  # Set REPLY to 'y' if it's empty
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0  # User accepted
    else
        return 1  # User declined
    fi
}

# Prompt to remove all Docker containers
if confirm "Are you sure you want to remove all Docker containers, including those that are currently running?"; then
    # Remove all Docker containers
    docker rm -vf $(docker ps -aq)
    echo "All Docker containers have been removed."
else
    echo "Skipping removal of Docker containers."
fi

# Prompt to remove all Docker images
if confirm "Are you sure you want to remove all Docker images from your local Docker environment?"; then
    # Remove all Docker images
    docker rmi -f $(docker images -aq)
    echo "All Docker images have been removed."
else
    echo "Skipping removal of Docker images."
fi

# Prompt to remove all Docker networks
if confirm "Are you sure you want to remove all Docker networks?"; then
    # Remove all Docker networks
    docker network prune -f
    echo "All Docker networks have been removed."
else
    echo "Skipping removal of Docker networks."
fi

# Prompt to remove all Docker volumes
if confirm "Are you sure you want to remove all Docker volumes?"; then
    # Remove all Docker volumes
    docker volume prune -f
    echo "All Docker volumes have been removed."
else
    echo "Skipping removal of Docker volumes."
fi

