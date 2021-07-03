#!/bin/bash

BUILD=""

while getopts ":hb" opt; do
    case ${opt} in
	b )
	    read -n1 -p "Forcefully re-build image? This will overwrite any local changes in your image. Press y/Y to confirm. " answer
		if [ "$answer" != "${answer#[Yy]}" ] ;then
		    BUILD="--build"
		fi
		echo ""
	;;
	h )
		echo "Usage: cmd [-bh]"
		exit 0
	;;
	\? )
	;;
    esac
done



#Fixup tasks - A container script run during image building. Is run as root. Can be used to fix up env/permissions/etc.
#src file editing/parsing can be done here to insert any variables or env info
cp scripts/fixup_tasks.sh.src scripts/fixup_tasks.sh
chmod 755 scripts/fixup_tasks.sh


#setup env vars
[[ ! -f devenv.env ]] && echo "devenv.env file not found" && exit -1
cp devenv.env .env
echo "HOST_UID=$UID" >> .env
echo "HOST_GID=$UID" >> .env
echo "HOST_DOCKER_GID=$(getent group docker | cut -d":" -f3)" >> .env
echo "SCRIPTS_DIR=$(readlink -f ./scripts)" >> .env

while read assignment; do
    [[ ! -z $assignment ]] && export "$assignment"
done < .env

[[ -z "$COMPOSE_PROJECT_NAME" ]] && echo "Project name not set" && exit -1
[[ -z "$CONTAINER_USER" ]] && echo "Container user name not set" && exit -1
[[ -z "$CONTAINER_USER_HOMEDIR_MOUNT_PATH" ]] && echo "Homedir mount from path not set" && exit -1
[[ ! -d "$CONTAINER_USER_HOMEDIR_MOUNT_PATH" ]] && echo "Homedir mount path is not a valid dir or does not exist" && exit -1
[[ -z "$HOST_UID" ]] && echo "UID not set" && exit -1
[[ -z "$HOST_GID" ]] && echo "GID not set" && exit -1
[[ -z "$HOST_DOCKER_GID" ]] && echo "Docker GID not set" && exit -1

mkdir -p $CONTAINER_USER_HOMEDIR_MOUNT_PATH/.opt/

#build dev env image and run container
docker-compose up ${BUILD} 
