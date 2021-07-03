FROM ubuntu:hirsute
LABEL maintainer="Dennis Mohan Punjabi <dennis@dmp.bz>"

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential meson ninja-build locales zsh vim git tig fonts-powerline curl wget docker.io sudo gosu byobu screen \
	iputils-ping traceroute python3-pip && \
	locale-gen en_US.UTF-8

COPY scripts/fixup_tasks.sh scripts/my_fixup_tasks.s[h] scripts/init_env.sh /home/scripts/

ARG HOST_UID
ARG HOST_GID
ARG HOST_DOCKER_GID
ARG CONTAINER_USER

# Add container user and group '$CONTAINER_USER'
RUN	groupadd -r $CONTAINER_USER --gid=$HOST_GID && useradd -r -g $CONTAINER_USER -s /bin/zsh --uid=$HOST_UID $CONTAINER_USER && echo "$CONTAINER_USER:$CONTAINER_USER" | chpasswd

#add $CONTAINER_USER to sudo and docker group
RUN	usermod -a -G sudo $CONTAINER_USER && usermod -a -G docker $CONTAINER_USER

RUN	/home/scripts/fixup_tasks.sh
		

USER $CONTAINER_USER	

ENV TERM xterm
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

ENTRYPOINT ["/home/scripts/init_env.sh"]
WORKDIR /home/$CONTAINER_USER

