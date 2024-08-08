FROM ghcr.io/toern/debian-desktop-docker/debian-desktop-base:latest

ENV DISPLAY=:1
ENV VNC_PASSWORD=myvncpassword

ENV USER=root

RUN mkdir -p /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd
EXPOSE 5901
ENV RESOLUTION=1920x1080
RUN touch /root/.Xauthority

COPY start.sh start.sh
RUN chmod +x start.sh
#RUN echo "#!/bin/bash\n\
#          xrdb $HOME/.Xresources\n\
#          startlxde &" > /root/.vnc/xstartup && \
#    chmod +x /root/.vnc/xstartup


CMD ["start.sh"]
#CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-SecurityTypes", "None"]
#CMD ["sh", "-c", "vncserver :1 -geometry 1280x800 -depth 24 -fg"]
