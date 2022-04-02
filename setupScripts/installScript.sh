#!/bin/bash

#shoutout to PureArtisan (https://github.com/pureartisan/magic-mirror-raspbian-lite)

# stop on error
set -e

cd ~/
HOME_DIR=$(pwd)

MM_RASP_LITE="magic-mirror-raspbian-lite"
MAGIC_MIRROR_RASP_LITE_DIR="$HOME_DIR/$MM_RASP_LITE"

MAGIC_MIRROR_NAME="magic-mirror"
MAGIC_MIRROR_DIR="$HOME_DIR/$MAGIC_MIRROR_NAME"

MAGIC_MIRROR_APP_DIR="$HOME_DIR/magic-mirror-app"

MAGIC_MIRROR_SETUP=true
MAGIC_MIRROR_HOST="localhost"
MAGIC_MIRROR_PORT="8080"

MAGIC_MIRROR_RASP_LITE_GIT='https://github.com/pureartisan/magic-mirror-raspbian-lite.git'
MAGIC_MIRROR_GIT='https://github.com/MichMich/MagicMirror'

REGEX_NUMERIC_ONLY='^[0-9]+$'

# show installer splash
clear

echo -e "\e[33m"
echo '$$\      $$\                     $$\           $$\      $$\ $$\                                          $$$$$$\  '
echo '$$$\    $$$ |                    \__|          $$$\    $$$ |\__|                                        $$  __$$\ '
echo '$$$$\  $$$$ | $$$$$$\   $$$$$$\  $$\  $$$$$$$\ $$$$\  $$$$ |$$\  $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\  \__/  $$ |'
echo '$$\$$\$$ $$ | \____$$\ $$  __$$\ $$ |$$  _____|$$\$$\$$ $$ |$$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\  $$$$$$  |'
echo '$$ \$$$  $$ | $$$$$$$ |$$ /  $$ |$$ |$$ /      $$ \$$$  $$ |$$ |$$ |  \__|$$ |  \__|$$ /  $$ |$$ |  \__|$$  ____/ '
echo '$$ |\$  /$$ |$$  __$$ |$$ |  $$ |$$ |$$ |      $$ |\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |$$ |      $$ |      '
echo '$$ | \_/ $$ |\$$$$$$$ |\$$$$$$$ |$$ |\$$$$$$$\ $$ | \_/ $$ |$$ |$$ |      $$ |      \$$$$$$  |$$ |      $$$$$$$$\ '
echo '\__|     \__| \_______| \____$$ |\__| \_______|\__|     \__|\__|\__|      \__|       \______/ \__|      \________|'
echo '                       $$\   $$ |                                                                                 '
echo '                       \$$$$$$  |                                                                                 '
echo '                        \______/                                                                                  '
echo -e "\e[1;32m"
echo '                                                                                                                  '
echo '$$$$$$$\                                $$\       $$\                           $$\       $$\   $$\               '
echo '$$  __$$\                               $$ |      \__|                          $$ |      \__|  $$ |              '
echo '$$ |  $$ | $$$$$$\   $$$$$$$\  $$$$$$\  $$$$$$$\  $$\  $$$$$$\  $$$$$$$\        $$ |      $$\ $$$$$$\    $$$$$$\  '
echo '$$$$$$$  | \____$$\ $$  _____|$$  __$$\ $$  __$$\ $$ | \____$$\ $$  __$$\       $$ |      $$ |\_$$  _|  $$  __$$\ '
echo '$$  __$$<  $$$$$$$ |\$$$$$$\  $$ /  $$ |$$ |  $$ |$$ | $$$$$$$ |$$ |  $$ |      $$ |      $$ |  $$ |    $$$$$$$$ |'
echo '$$ |  $$ |$$  __$$ | \____$$\ $$ |  $$ |$$ |  $$ |$$ |$$  __$$ |$$ |  $$ |      $$ |      $$ |  $$ |$$\ $$   ____|'
echo '$$ |  $$ |\$$$$$$$ |$$$$$$$  |$$$$$$$  |$$$$$$$  |$$ |\$$$$$$$ |$$ |  $$ |      $$$$$$$$\ $$ |  \$$$$  |\$$$$$$$\ '
echo '\__|  \__| \_______|\_______/ $$  ____/ \_______/ \__| \_______|\__|  \__|      \________|\__|   \____/  \_______|'
echo '                              $$ |                                                                                '
echo '                              $$ |                                                                                '
echo '                              \__|                                                                                '
echo -e "\e[0m"

function drawLine() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

function info() {
    echo -e "\e[1;45m$1\e[0m"
    drawLine
}

function success() {
    echo -e "\e[1;32m$1\e[0m"
}

function error() {
    echo -e "\e[1;91m$1\e[0m"
}

# draw line before asking questions
drawLine

echo "Magic Mirror server will be installed on this Raspberry Pi."
echo "However, you can use setup and/or connect to another Magic Mirror server via the network."

echo "Would you like to setup the Magic Mirror server on this Raspberry Pi? [Y/n]"
while true; do
    read input
    case $input in
        ""|[Yy]* )
            MAGIC_MIRROR_SETUP=true
            break;;
        [Nn]* )
            MAGIC_MIRROR_SETUP=false
            break;;
        * ) echo "Please answer y(es) or n(o).";;
    esac
done

if ! $MAGIC_MIRROR_SETUP; then

    echo "What is the HOST for the Magic Mirror server? Enter IP address (or hostname)."
    while true; do
        read input
        if [ -z "$input" ]
        then
            echo "Please enter a valid host."
        else
            MAGIC_MIRROR_HOST=$input
            break;
        fi
    done

    echo "What is the PORT for the Magic Mirror server? Enter server port."
    while true; do
        read input
        if ! [[ $input =~ $REGEX_NUMERIC_ONLY ]]
        then
            echo "Please enter a valid port."
        else
            MAGIC_MIRROR_PORT=$input
            break;
        fi
    done

fi

drawLine
success "The rest will be automatic, so sit back and relax..."
echo ""
echo ""
drawLine

# Updating package managers
info 'Updating Pi - this may take a while...'
sudo apt-get -y update
info 'Upgrading Pi - this may take a while too...'
sudo apt-get -y upgrade
sudo apt-get -y upgrade --fix-missing

info 'Installing git'
sudo apt install -y git

info 'Cloning "Magic Mirror"'
if [ -d "$MAGIC_MIRROR_DIR" ]; then
    success "Magic Mirror already exists, pulling latest"
    cd "$MAGIC_MIRROR_DIR" > /dev/null
    git reset --hard
    git pull origin
    cd > /dev/null
else
    git clone "$MAGIC_MIRROR_GIT" "$MAGIC_MIRROR_NAME"
fi

info 'Cloning "Magic Mirror for Raspbian Lite"'
if [ -d "$MAGIC_MIRROR_RASP_LITE_DIR" ]; then
    success "Magic Mirror for Raspbian Lite already exists, pulling latest"
    cd "$MAGIC_MIRROR_RASP_LITE_DIR" > /dev/null
    git reset --hard
    git pull origin
    cd > /dev/null
else
    git clone "$MAGIC_MIRROR_RASP_LITE_GIT" "$MM_RASP_LITE"
fi

info 'Creating app directory'
# remove if it already exists
sudo rm -rf "$MAGIC_MIRROR_APP_DIR"
# create app dir
mkdir -p "$MAGIC_MIRROR_APP_DIR"
# list the directory
cd "$MAGIC_MIRROR_APP_DIR" > /dev/null
cd .. > /dev/null
ls -la
cd ~/ > /dev/null

# export so the child scripts can access them
export HOME_DIR
export MAGIC_MIRROR_RASP_LITE_DIR
export MAGIC_MIRROR_DIR
export MAGIC_MIRROR_APP_DIR
export MAGIC_MIRROR_SETUP
export MAGIC_MIRROR_HOST
export MAGIC_MIRROR_PORT

# start the proper setup
. $MAGIC_MIRROR_RASP_LITE_DIR/setup/run.sh
. $MAGIC_MIRROR_RASP_LITE_DIR/setup/cleanup.sh


# install OpenMediaVault script
cd ~/
wget https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install
chmod +x install
sudo ./install -n
sudo rm -rf install

# install docker and docker-compose
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker ${USER}

# install docker-compose
sudo apt-get install libffi-dev libssl-dev
sudo apt install -y python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose

info 'Rebooting now...'
sudo reboot

# end of the script