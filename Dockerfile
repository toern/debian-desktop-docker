FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PASSWORD=myvncpassword


ENV USER=root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    lxde \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-tools \
    curl \
    wget \
    vim \
    gnupg \
    ca-certificates \
    software-properties-common

RUN curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg && \
    echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list && \
    apt-get update && apt-get install -y spotify-client
    
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

#RUN echo "#!/bin/bash\n\
#          xrdb $HOME/.Xresources\n\
#          startlxde &" > /root/.vnc/xstartup && \
#    chmod +x /root/.vnc/xstartup

EXPOSE 5901

CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-SecurityTypes", "None"]
