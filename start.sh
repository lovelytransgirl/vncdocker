#!/bin/bash

# Check if port is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <port>"
    exit 1
fi

VNC_PORT=$1

# Configuration
INTERVAL_MINUTES=1
IMAGE_DIR="/home/vncuser/images"   # Directory containing images
FLASH_DURATION=2
MAIN_IMAGE="/home/vncuser/images/lol.png"  # Main image to display

# Function to get random image from directory (excluding lol.png)
get_random_image() {
    local dir="$1"
    local images=($(find "$dir" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) ! -name "lol.png"))
    if [ ${#images[@]} -eq 0 ]; then
        echo "No images found in $dir (excluding lol.png)"
        exit 1
    fi
    echo "${images[$RANDOM % ${#images[@]}]}"
}

# Function to flash an image
flash_image() {
    local image="$1"
    DISPLAY=:1 feh --bg-scale "$image" &
    sleep "$FLASH_DURATION"
}

# Start a virtual framebuffer
Xvfb :1 -screen 0 1024x768x24 &
sleep 2  # Give Xvfb time to start

# Start a lightweight window manager
DISPLAY=:1 fluxbox &
sleep 2  # Give Fluxbox time to start

# Start VNC server in view-only mode (no password)
x11vnc -display :1 -forever -nopw -rfbport $VNC_PORT -viewonly -shared -xkb &

# Display main image initially
DISPLAY=:1 feh --bg-scale "$MAIN_IMAGE" &

# Main loop to flash images
while true; do
    # Wait for the specified interval before next flash
    sleep $((INTERVAL_MINUTES * 60))
    
    # Get and display a random image
    random_image=$(get_random_image "$IMAGE_DIR")
    flash_image "$random_image"
    
    # Return to main image
    DISPLAY=:1 feh --bg-scale "$MAIN_IMAGE" &
done
