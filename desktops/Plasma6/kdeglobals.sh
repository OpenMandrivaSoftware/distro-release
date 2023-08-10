#!/bin/sh
if [ ! -e ~/.config/kdeglobals ]; then
    cp -f /etc/xdg/kdeglobals ~/.config/kdeglobals
fi
