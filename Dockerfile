FROM ubuntu:latest

# Install required packages
RUN apt update && apt install -y \
    x11vnc \
    xvfb \
    fluxbox \
    feh \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash vncuser

# Create directory for images in user's home
RUN mkdir -p /home/vncuser/images

# Configure Fluxbox to hide workspace indicator
RUN mkdir -p /home/vncuser/.fluxbox && \
    echo "session.screen0.toolbar.visible: false" > /home/vncuser/.fluxbox/init && \
    echo "session.screen0.toolbar.autoHide: true" >> /home/vncuser/.fluxbox/init && \
    echo "session.screen0.toolbar.placement: Bottom" >> /home/vncuser/.fluxbox/init && \
    echo "session.screen0.toolbar.widthPercent: 100" >> /home/vncuser/.fluxbox/init && \
    echo "session.screen0.toolbar.height: 0" >> /home/vncuser/.fluxbox/init

# Copy image files (add your images to the images/ directory)
COPY images/*.png /home/vncuser/images/
RUN chown -R vncuser:vncuser /home/vncuser/images && \
    chmod 644 /home/vncuser/images/*

# Copy the start script
COPY start.sh /home/vncuser/start.sh
RUN chown vncuser:vncuser /home/vncuser/start.sh && \
    chmod +x /home/vncuser/start.sh

# Switch to non-root user
USER vncuser

# Expose VNC port
EXPOSE 5900

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ps aux | grep x11vnc || exit 1

# Run startup script
CMD ["/home/vncuser/start.sh"]
