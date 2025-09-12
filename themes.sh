#!/bin/bash

set -e

sudo cp -fr ./themes /usr/share/themes/
sudo cp -fr ./cursors /usr/share/icons/
sudo cp -fr ./fish ~/.config/

sudo cp -f ./.face ~/
sudo cp -f ./.xprofile ~/

echo "Hoàn tất copy!"
