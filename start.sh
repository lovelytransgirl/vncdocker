#!/bin/bash

# Start a virtual framebuffer
Xvfb :1 -screen 0 1024x768x24 &
sleep 2  # Give Xvfb time to start

# Start a lightweight window manager
DISPLAY=:1 fluxbox &
sleep 2  # Give Fluxbox time to start

# Display the image using feh
DISPLAY=:1 feh --bg-scale /root/lol.png &

# Start VNC server in view-only mode (no password)
x11vnc -display :1 -forever -nopw -rfbport 5900 -viewonly
