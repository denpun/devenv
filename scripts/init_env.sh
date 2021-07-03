#!/bin/zsh

if [ ! -d "${HOME}" ]; then
	echo "${HOME} does not exist!"
	exit 1
fi

if [ ! -f "${HOME}/.env_ready" ]; then
	echo "Welcome! Setting up your development environment..."
	
	echo "source ~/.config/zsh/.zshenv" > ~/.zshenv
	export ZDOTDIR=~/.config/zsh
	mkdir -p $ZDOTDIR
	echo "export ZDOTDIR=~/.config/zsh" > $ZDOTDIR/.zshenv

	/bin/zsh

	/home/scripts/oh_my_zsh_install.sh --unattended

	mv ~/.zshrc $ZDOTDIR/.
	ln -s $ZDOTDIR/.zshrc ~/.zshrc

	sed -i 's/robbyrussell/agnoster/g;s/# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/g' ${ZDOTDIR}/.zshrc

	cp -f /home/scripts/agnoster.zsh-theme ~/.oh-my-zsh/themes/agnoster.zsh-theme
	echo 'bindkey "^[[1~" beginning-of-line' >> ${ZDOTDIR}/.zshrc
	echo 'bindkey "^[[4~" end-of-line' >> ${ZDOTDIR}/.zshrc
	echo 'bindkey "^[[3~" delete-char' >> ${ZDOTDIR}/.zshrc
	echo "alias rm='rm -i'" >> ${ZDOTDIR}/.zshrc
	echo "alias cp='cp -i'" >> ${ZDOTDIR}/.zshrc
	echo "alias mv='mv -i'" >> ${ZDOTDIR}/.zshrc
	echo "export LESS='--quit-if-one-screen -R'" >> ${ZDOTDIR}/.zshrc

	mkdir -p ~/.bin
	echo "export PATH=$PATH:~/.bin" >> ${ZDOTDIR}/.zshrc

	/home/scripts/nvm_install.sh

	source ~/.zshrc
	nvm install 14.17.0

	touch ${HOME}/.env_ready
fi

if [ -x ${HOME}/my_init_env.sh ]; then
	${HOME}/my_init_env.sh
fi

echo "Welcome! Your development environment is ready for use!"
echo "Current working dir: $PWD"
$@

