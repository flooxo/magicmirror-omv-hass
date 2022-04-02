#!/bin/bash

THEME_NAME='MagicMirror'
PLYMOUTH_THEME_DIR=/usr/share/plymouth/themes
THEME_DIR=$PLYMOUTH_THEME_DIR/$THEME_NAME

info 'Setting up Magic Mirror splash screen'
sudo mkdir -p "$THEME_DIR"
sudo cp $MAGIC_MIRROR_DIR/splashscreen/* $THEME_DIR

info 'Enable Magic Mirror splash screen'
if sudo plymouth-set-default-theme -R "$THEME_NAME"; then
    success "Splashscreen: Changed theme to MagicMirror successfully."
else
    error "Splashscreen: Couldn't change theme to MagicMirror!"
fi