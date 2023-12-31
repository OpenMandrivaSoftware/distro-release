#!/bin/sh
if [ ! -e ~/.config/kdeglobals ]; then
    cp -f /etc/xdg/kdeglobals ~/.config/kdeglobals
fi

if [ ! -e ~/.config/startupconfigkeys ]; then
    cp -f /etc/xdg/startupconfigkeys ~/.config/startupconfigkeys
fi

LIB="lib$(if uname -m |grep -q 64; then printf '%s\n' '64'; fi)"
export QT_PLUGIN_PATH=/usr/$LIB/qt5/plugins:/usr/$LIB/qt5/plugins/kcms
