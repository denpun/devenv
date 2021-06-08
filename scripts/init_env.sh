#!/bin/sh

if [ ! -d "${HOME}" ]; then
	echo "${HOME} does not exist!"
	exit 1
fi

if [ ! -f "${HOME}/.env_ready" ]; then
	echo "Welcome! Setting up your development environment..."
	cp /etc/skel/.* ${HOME}/.
	
	/home/scripts/oh_my_zsh_install.sh --unattended && sed -i 's/robbyrussell/agnoster/g' ${HOME}/.zshrc
	
	/home/scripts/nvm_install.sh
	echo "export NVM_DIR=~/.nvm" >> ~/.zshrc
	echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> ~/.zshrc
	source .zshrc
	nvm install 14.17.0

	


	touch ${HOME}/.env_ready
fi

echo "Welcome! Your development environment is ready for use!"
echo "Current working dir: $PWD"
$@

