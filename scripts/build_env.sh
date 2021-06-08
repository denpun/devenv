#!/bin/bash

BUILD=""
HOMEDIR=${DEVUSER_HOMEDIR-""}

while getopts ":hb" opt; do
    case ${opt} in
	b )
	    read -n1 -p "Forcefully re-build image? This will overwrite any local changes in your image. Press y/Y to confirm." answer
		if [ "$answer" != "${answer#[Yy]}" ] ;then
		    BUILD="--build"
		fi
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
DOCKER_GROUP=$(getent group docker | cut -d":" -f3)
sed  "s/HOST_DOCKER_GROUP/${DOCKER_GROUP}/g" scripts/fixup_tasks.sh.src > scripts/fixup_tasks.sh
chmod 755 scripts/fixup_tasks.sh


#Get homdir to mount as volume
if [ "${HOMEDIR}" = "" ]; then
	read -p "DEVUSER_HOMEDIR not set. Enter devuser's homedir path to mount as volume in container: " HOMEDIR
fi





#build dev env image and run container
docker-compose up ${BUILD}
