# Pi Config                     

This repo contains config files and (for me personal) useful information about configurations and setups.
After a long time and hours of work, I finally have been able to put all the parts together[^1], so that I have managed to get the raspberry pi running according to my ideas

**My goal: use the pi as a smart mirror, NAS and smart home network and much more**

important ports:

    openmediavault  -> 80
    magicmirror     -> 8080
    homeassistant   -> 8123
    portainer       -> 9000
    pihole          -> tba

## TODO
- [ ] Add docker containers to script
    - [ ] Add HomeAssistant docker image
    - [ ] Add PiHole docker image
    - [ ] Add RaspAP docker image
- [ ] Test install script
- [ ] Add configs of PiHole; MagicMirror; OMV setup and storage settings

## Basic setup
1. install Raspberry Pi OS lite (32-bit)
2. install script for MagicMirror for raspbian lite (https://github.com/pureartisan/magic-mirror-raspbian-lite)
```
bash -c "$(curl -sL https://raw.githubusercontent.com/pureartisan/magic-mirror-raspbian-lite/master/install.sh?$(date +%s))"
```

3. install script for OpenMediaVault to skip network setup
```
wget https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install
chmod +x install
sudo ./install -n
```

=> accessible under https://[pi-ip]:80

(FIX DNS: add wlan under network -> interfaces wlan + dns)

### Addons and Plugins
4. in omv install docker + portainer
5. open webinterface of portainer -> https://[pi-ip]:9000

## Add HomeAssistant to Portainer
1. in local     -> container->add container
2. set name     -> **HomeAssistant**
3. set image    -> **homeassistant/home-assistant**
4. volumes

    **/home/pi/HomeAssistant/config** -> bind
        -> **/config**
        
    **/etc/localtime** -> bind
        -> **/etc/localtime**
        
5. network->**network set host**
6. restart policy set **unless stopped**
7. click deploy container
-> see logs if running correctly
=> accessible under https://[pi-ip]:8123


## Add PiHole to Portainer
(❌not testet yet)
1. in local     -> container->add container
2. set name     -> **PiHole**
3. set image    -> **pihole/pihole**
4. volumes

    **/home/pi/HomeAssistant/config** -> bind
        -> **/config**
5. network->**network set host**
6. restart policy set **unless stopped**
7. click deploy container
-> see logs if running correctly
=> accessible under https://[pi-ip]:tba


[^1]: Diffulties: MagicMirror is based on Raspian OS **with desktop enviroment**, but OpenMediaVault is designed to run on a lite Raspbain version (so for a beginner like me a broad task)
