FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

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
    software-properties-common

RUN curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
RUN echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
RUN apt-get update
    
RUN apt-get install -y spotify-client
    
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a startup script for VNC server
RUN mkdir -p ~/.vnc && \
    echo "#!/bin/bash\n\
          xrdb $HOME/.Xresources\n\
          startlxde &" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

EXPOSE 5901

CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-xstartup", "/home/root/.vnc/xstartup"]
