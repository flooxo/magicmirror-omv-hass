#!/bin/bash

bash -c "$(curl -sL https://raw.githubusercontent.com/pureartisan/magic-mirror-raspbian-lite/master/install.sh?$(date +%s))"

wget https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install
chmod +x install
sudo ./install -n

# end of the script