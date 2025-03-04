FROM ubuntu:latest

# Install required packages
RUN apt update && apt install -y \
    x11vnc xvfb fluxbox feh \
    && rm -rf /var/lib/apt/lists/*

# Copy the image file
COPY lol.png /root/lol.png
RUN chmod 644 /root/lol.png

# Copy the start script
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

# Run startup script
CMD ["/root/start.sh"]
