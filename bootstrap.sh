#!/bin/bash

# https://www.google.com/linuxrepositories/
# https://www.microsoft.com/net/core#linuxubuntu
# https://code.visualstudio.com/docs/setup/linux
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# https://yarnpkg.com/lang/en/docs/install/
# https://golang.org/doc/install#tarball

echo "Update and upgrade all the things..."

sudo apt-get update -y

echo "Some essentials..."
sudo apt-get install -y curl wget git xclip vim zsh \
  apt-transport-https ca-certificates gnupg-agent build-essential software-properties-common

# Chrome setup
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install

# Brave setup
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Chromium  setup
sudo apt-get install chromium-browser

# Seamonkey apt install (3rd party repo)
cat <<EOF | sudo tee /etc/apt/sources.list.d/mozilla.list
deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main
EOF
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2667CA5C
sudo apt-get update
sudo apt-get install seamonkey-mozilla-build

# DBeaver setup
sudo apt -y install default-jdk
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install dbeaver-ce

# Random AV stuff
sudo apt-get -y install audacity vlc ffmpeg gimp

# Install Blender
export BLENDER_MAJOR="3.0"
export BLENDER_VERSION="3.0.0"
export BLENDER_TAR_URL="https://download.blender.org/release/Blender${BLENDER_MAJOR}/blender-${BLENDER_VERSION}-linux64.tar.xz"
sudo mkdir /usr/local/blender && \
	wget --quiet ${BLENDER_TAR_URL} -O blender.tar.xz && \
	tar -xvf blender.tar.xz -C /usr/local/blender --strip-components=1 && \
	rm blender.tar.xz 

# Install OBS Studio
sudo apt -y install v4l2loopback-dkms
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install -y obs-studio

# Docker setup - https://docs.docker.com/install/linux/docker-ce/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose - https://docs.docker.com/compose/install/#install-compose-on-linux-systems
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# ASP.net setup - https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update -y
sudo apt-get install -y apt-transport-https
sudo apt-get update -y
sudo apt-get install -y dotnet-sdk-3.1

# VS Code setup - https://code.visualstudio.com/docs/setup/linux
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt-get -y install code

# Node setup - https://github.com/nodesource/distributions/blob/master/README.md
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# build tools
sudo apt-get install -y gcc g++ make

# Yarn setup - https://yarnpkg.com/lang/en/docs/install/#debian-stable
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update -y
sudo apt install yarn -y

# Python 3 (ignoring version 2)
sudo apt install -y python3 python3-pip
echo 'alias python=python3
' >> ~/.bash_aliases

sudo apt install -y build-essential libssl-dev libffi-dev python-dev

# Go
VERSION=1.17
OS=linux
ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz -O /tmp/go$VERSION.$OS-$ARCH.tar.gz
sudo tar -C /usr/local -xzf /tmp/go$VERSION.$OS-$ARCH.tar.gz

# Using "~" in sudo context will get "/root" so wild guess the profile path:
USERS_PROFILE_FILENAME=~/.profile
if grep -Fq "/usr/local/go/bin" $USERS_PROFILE_FILENAME
then
    echo "GO path found in $USERS_PROFILE_FILENAME"
else
    echo '
export PATH=$PATH:/usr/local/go/bin
' >> $USERS_PROFILE_FILENAME
fi

# adds the cuurent user who is sudo'ing to a docker group:
sudo groupadd docker
sudo usermod -aG docker $SUDO_USER
sudo service docker restart
# note that typically you still need a logout/login for docker to work...

sudo apt autoremove -y


cat << EOF

# now....

code --install-extension ms-dotnettools.csharp
code --install-extension golang.go
code --install-extension dbaeumer.vscode-eslint
code --install-extension HookyQR.beautify
code --list-extensions

# git setup:

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

ssh-keygen -t rsa -b 4096 -C "you@example.com"

eval "\$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

# also check docker... you may need to login again for groups to sort out
# try >> docker run hello-world

# To use GO straight up, get the path:
source ~/.profile

EOF

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
