#!/bin/sh
if [ ! -e ~/.config/kdeglobals ]; then
    cp -f /etc/xdg/kdeglobals ~/.config/kdeglobals
fi

if [ ! -e ~/.config/plasma-org.kde.plasma.desktop-appletsrc ]; then
    cp -f /etc/xdg/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc
fi
