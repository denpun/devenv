FROM ubuntu:hirsute
LABEL maintainer="Dennis Mohan Punjabi <dennis@dmp.bz>"

COPY  scripts /home/scripts

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential locales zsh vim git fonts-powerline curl wget docker.io && \
	locale-gen en_US.UTF-8 && \
	useradd -s /bin/zsh devuser && \
	usermod -a -G docker devuser && \
	echo 'devuser:devuser' | chpasswd && \
	mkdir -p /home/devuser && chmod 777 /home/devuser && \
	/home/scripts/fixup_tasks.sh
		

USER devuser	

ENV TERM xterm
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

ENTRYPOINT ["/home/scripts/init_env.sh"]
WORKDIR /home/devuser

