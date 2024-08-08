FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Update the package list and install LXDE, VNC server, curl, and other common tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    lxde \
    tigervnc-standalone-server \
    tigervnc-common \
    curl \
    wget \
    vim \
    gnupg \
    ca-certificates \
    software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Spotify Client
RUN curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list && \
    apt-get update && \
    apt-get install -y spotify-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a startup script for VNC server
RUN mkdir -p ~/.vnc && \
    echo "#!/bin/bash\n\
          xrdb $HOME/.Xresources\n\
          startlxde &" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

EXPOSE 5901

CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-xstartup", "/home/root/.vnc/xstartup"]
