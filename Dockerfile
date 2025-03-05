FROM ubuntu:latest

# Install required packages
RUN apt update && apt install -y \
    x11vnc \
    xvfb \
    fluxbox \
    feh \
    && rm -rf /var/lib/apt/lists/*

# Create directory for images
RUN mkdir -p /root/images

# Configure Fluxbox to hide workspace indicator
RUN mkdir -p /root/.fluxbox && \
    echo "session.screen0.toolbar.visible: false" > /root/.fluxbox/init && \
    echo "session.screen0.toolbar.autoHide: true" >> /root/.fluxbox/init && \
    echo "session.screen0.toolbar.placement: Bottom" >> /root/.fluxbox/init && \
    echo "session.screen0.toolbar.widthPercent: 100" >> /root/.fluxbox/init && \
    echo "session.screen0.toolbar.height: 0" >> /root/.fluxbox/init

# Copy image files (add your images to the images/ directory)
COPY images/*.png /root/images/
COPY images/*.jpg /root/images/
COPY images/*.jpeg /root/images/
RUN chmod 644 /root/images/*

# Copy the start script
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

# Expose VNC port
EXPOSE 5900

# Run startup script
CMD ["/root/start.sh"]
