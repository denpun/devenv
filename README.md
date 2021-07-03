# Docker based - Quick setup Development Environment
### _Recreate your development environment anywhere, with just a few commands._ 
###### (Anywhere = any machine with an internet connection)
<br>

### TLDR - Skip to the [Steps - How to setup dev env](#steps) directly
<br>

### Problems
- Need to recreate dev env everytime computer dies (rare)
- Need to recreate dev env on second/other computer (rare)
- Need to share devenv with someone else for whatever reason (common)
- Need to recreate dev env quickly (common)
<br>

### Solution
- This set of scripts to build your own dev env quickly
- Fork and clone this repo
- Customize and commit your changes
- run ```./scripts/build_env.sh```
- Profit :moneybag::moneybag:
- More details below. :smiley::smiley:
<br>

### What this is not
- Super secure container setup instructions. This is merely a build env. We assume that the user is one with privileges prior to using the dev env. Thus we do not need to focus on securing the container itself even though it would be nice.
- Docker/containers tutorial, even though it may seem like one.
- The perfect way to do what it does. There may be other solutions to the problems lsited above and/or better ways to go about doing some things that are done here. There may be reasons that are not mentioned or that are not obvious for some design decisions.
<br>

### Overview
![image](https://user-images.githubusercontent.com/3298500/124357869-4818a080-dc50-11eb-86c5-173d536dbbcb.png)
<br><br>
Okay. So the main objective is to be able to quickly and easily re-create an environment that is ready-to-go for all my development tasks. The way in which I have chosen to go about achieving this goal is by using Docker.

Essentially, we will be setting up an environment that is actually a Docker container. The Docker container can be non-persistent and we don't care if the the image that is used to create the container is re-built. As in, a re-build of the image should have no effect on our dev env unless that is the intention, i.e. we want to add something new to our dev env or we want to trim the dev env by removing soemthing no longer needed/wanted.

The reason for using a container is that we can easily destroy and re-create the container and thus our dev env.

Our ideal dev env should contain all the packages we need to do our daily tasks.
It should be easy to add/remove new packages/tools.
<br>

#### Terms
1. Host: The host machine that will be running docker
2. Dev env: Our development environment
3. Dev env container: The container that will run our dev env
<br>

#### Requirements
1. Host machine running linux OS of your choice. Preferably an updated release
1. Docker daemon must be installed on host
1. Docker-compose must be installed on host
1. Host machine user account must be able to use docker, i.e. be in docker group on host
1. Docker usage experience will be useful
<br>

#### Summary of dev env build
1. Create a docker image that will contain all packages that we will need in our dev env. See [Dockerfile](Dockerfile)
2. Create a container based on that image. See [docker-compose.yml](docker-compose.yml)
3. Use scripts to automate the process so it is easy to re-create. See [scripts](scripts)
<br>

### How does this actually happen?

**1** - We first call on [scripts/build_env.sh](scripts/build_env.sh) to start our dev env.

This script setups any environment vars that will be needed in next steps and then calls ```docker compose up```
<p align="center"><img src="https://user-images.githubusercontent.com/3298500/124361367-70f56180-dc61-11eb-8f70-3ebdbbad2224.png"></p>

**2** - ```docker compose up``` uses the [docker-compose.yml](docker-compose.yml) file to setup the env.

If called for the first time, it builds an image based on [Dockerfile](Dockerfile).

The [Dockerfile](Dockerfile) will make use of the scripts in [scripts](scripts) as part of the image building process.

After the image is built, the configurations in the generated .env file and the [docker-compose.yml](docker-compose.yml) file are used to create a container based on the image.

The container is then started.

<p align="center"><img src="https://user-images.githubusercontent.com/3298500/124361367-70f56180-dc61-11eb-8f70-3ebdbbad2224.png"></p>

**3** - After the container is started, one can simply run ```docker exec -it <project_name>_devenv_1 /bin/zsh``` to start a shell in your new dev env! We highly recommend you run Screen or Byobu inside your container after starting a new shell.

<p align="center"><img src="https://user-images.githubusercontent.com/3298500/124361367-70f56180-dc61-11eb-8f70-3ebdbbad2224.png"></p>

**4** - One can now work in their customized dev environment! Voila!
<p align="center"><img src="https://user-images.githubusercontent.com/3298500/124361367-70f56180-dc61-11eb-8f70-3ebdbbad2224.png"></p>

**5** - The [scripts/build_env.sh](scripts/build_env.sh) command will run in the foreground. To stop your env, simply do a **ctrl+c**. It will stop any running containers.
<p align="center"><img src="https://user-images.githubusercontent.com/3298500/124361367-70f56180-dc61-11eb-8f70-3ebdbbad2224.png"></p>

**6** - To return to your dev env, simple run [scripts/build_env.sh](scripts/build_env.sh) again followed by ```docker exec -it <project_name>_devenv_1 /bin/zsh``` to start a new shell at anytime!
<br>
<br>


<a name="steps"></a>
### Steps - How to setup dev env

#### Super condensed How to
```sh
git clone git@github.com:denpun/devenv.git
cp devenv.env.example devenv.env
vi devenv.env
mkdir /path/to/my/datadir
./scripts/build_env.sh
docker exec -it <project_name>_devenv_1 /bin/zsh
```
<br>

#### Well explained (sort of) How to
##### Step #1
Fork/Clone this repo
```sh
git clone git@github.com:denpun/devenv.git
```
>Try not to put too much else in the directory that the repo was cloned into. The reason being that it will be passed on to docker while setting up a "build context". The more files/dirs in the directory, the longer it will take to build your env. If you do insist on adding other files/dirs, try using the .dockerignore to ignore them and speed up any builds.

<br>

##### Step #2
Take quick **look** at [scripts/build_env.sh](scripts/build_env.sh). This is the script that will start it all. It is the Orchestrator script!

We will need to run this script to start everything. **DON'T** run it now but do take a gander.

The first time the script is run, it will create a new docker image.

If not run for the first time, it will simply start your dev env container that has already previously been built.

<br>

##### Step #3
Create a devenv.env file in the root of the project. Look at devenv.env.example

```sh
cp devenv.env.example devenv.env
```
Edit the file and update these variables

```sh
COMPOSE_PROJECT_NAME=<Your env name or project name>
```
> It is used by docker-compose and could be considered to be somewhat like a name-space name. Is is used to isolate a directories's containers, networks, and volumes from another's.

```sh
CONTAINER_USER=<username of user in container>
```
>Set this to whatever you want the username of the user inside the container to be. Essentially, the user of the env.

```sh
CONTAINER_USER_HOMEDIR_MOUNT_PATH=<data dir path>
```
>The path of a directory on the host that will be used to store all persistent data. Ideally, should be a new directory created on the host. You can copy data into it later on. The data dir will be the homedir of $CONTAINER_USER inside the container.

The [scripts/build_env.sh](scripts/build_env.sh) script will generate a **.env** file based on your **devenv.env** file.

The **.env** file will be used by the ```docker compose up``` command that is called by the [scripts/build_env.sh](scripts/build_env.sh) script.

<br>

##### Step #4 (optional)
The ```docker compose up``` command will need to process the [docker-compose.yml](docker-compose.yml) to start things off.

Do take a look at [docker-compose.yml](docker-compose.yml) if need be. You won't need to change anything in this file but feel free to do so if you think you should!

One idea of what we can do is edit the file to add a bind mount for host user's .ssh dir to be user as the container user's ssh dir? Maybe I will do this in a future version myself.

<br>

##### Step #5
The ```docker compose up``` command will use the [Dockerfile](Dockerfile#L4) file to build the dev env image the first time we run [scripts/build_env.sh](scripts/build_env.sh).

The [Dockerfile](Dockerfile#L4) basially controls what our image will look like, i.e. what packages will be installed in our dev env.

Look at the list of default packages that will be built/installed in the image [Dockerfile](Dockerfile#L4). Since we are using a debian based distro, it uses apt-get for package installation. Edit this to suit your needs.

As you work, you may find that you need to add or remove packages to suit your tasks at that point in time. Edit accordingly.

If you are familiar with Dockerfiles, you will also notice some "ARG"s. This is injected via the **.env** file and the ```docker compose up``` command. You can do the same if you need other information or directly inject in next step.

<br>

##### Step #6
During the image building process, the **scripts/fixup_tasks.sh** script will be run as **root** inside the container. This script is called only once during the image building process.
The script is generated from [scripts/fixup_tasks.sh.src](scripts/fixup_tasks.sh .src) here [scripts/build_env.sh#L27](scripts/build_env.sh#L27).
> The purpose for "generating" this script is to be able to inject any variables or other information from the host into this file. Currently, we dont do any such injection but it would be possible to do so. Example: Originally, I injected the host user's UID here and changed the container user's UID based on that. I no longed do it that way.

This script does some fixup tasks like:
- ensure the container user has r/w permissions to the mounted home dir. How do we do this? Make sure the container user's UID/GID are same as that of the host user's UID/GID.
- ensure that the container docker GID is same as that of the host docker GID.
- ensure container user is part of docker group

Feel free to add any "fix-up" tasks here that need to be run as root. Maybe you need to install a custom/non-standard package as root?

**scripts/fixup_tasks.sh** will also call **scripts/my_fixup_tasks.sh** if it exists. You may also create that file and add your commands there.

<br>

##### Step #7
The last step in the build process is to call [scripts/init_env.sh](scripts/init_env.sh). This script will be run inside the container and run as the **container user**. This script is called only once during the image building process.

The purpose of this script is to run any user based init tasks such as
- Setup zsh shell correctly
- Installing oh-my-zsh
- Setting up of the zsh theme used
- Installing nvm locally for the user

It contains logic to run some parts only once no matter how many times you re-build your dev env.
i.e. ```if [ ! -f "${HOME}/.env_ready" ];``` and ```touch ${HOME}/.env_ready```.
This way, you can re-build you env as many times as you want. 

The purpose is to help in user env initlization. Since it writes to the persistent home dir, we need to be careful what we write/over-write. Thus we have the run-once protection.

It also calls scripts/my_init_env.sh if it exists. You may create this file and add your commands. It will always call this script during a re-build, so be careful what you put in it.

Other things you may want to put in these init_env scripts.
- Automatically download/init git config. Saved in a git repo?
- Automatically download/init vim config. Saved in a git repo?
- Download data from secure locations. Saved in some secure cloud host? Maybe use injected vars for passwords? Maybe use [docker-compose.yml](docker-compose.yml) to expose ARGs.? Just some ideas. Use at your own risk! Think about security ramifications.
- Basically you can use this script to add anything to init your env.
- Auto setup ssh keys? PGP keys?

<br>

##### Step #8
After looking at or editing all the above files, it is now time to call [scripts/build_env.sh](scripts/build_env.sh).
```sh
scripts/build_env.sh
```
> For the first time, you may call as above.
or
```sh
scripts/build_env.sh -b
```
> If you already have a running container and make changes to any of the files above, you may call it as above to force a re-build of your image.

The [scripts/build_env.sh](scripts/build_env.sh) script builds an image and then starts a container. It runs in the foreground and will keep running.

You may do a **ctrl + c** to stop the dev env at any time.

<br>

##### Step #9
Once your dev env container is running, you may run
```docker exec -it <project_name>_devenv_1 /bin/zsh```
to start a shell in your dev env.

We highly recommend using **screen** or **byobu** in your dev env.

<br>

##### Step #10
After computer restarts, you can simply once again goto step 8. This time, it will not rebuild (unless you use **-b**).
The container will start very quickly and then you may use your dev env.

<br>

##### Step #11
Commit your repo somewhere public. Ensure no private data, secrets or passwords are part of the scripts.

If you do this, you can setup your dev env anywhere with an internet connection!! :)



### Notes

1. Container user env uses zsh as default shell.
2. Container user env zsh uses a customized [agnoster-zsh-theme](scripts/agnoster.zsh-theme). It is customized to display timestamps and to speed up the prompt when traversing a git repo dir. Basically, I removed the repo-dirty tracking which is very slow on large repos.

### Happy Forking. Good luck.

---
MIT License

Copyright (c) [2021] [Dennis Mohan Punjabi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.





   





