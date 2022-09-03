#!/bin/sh

if [ -n "$(command -v kreadconfig5)" ]; then # Check if Plasma is installed, otherwise do nothing
    FIRSTRUN=$(kreadconfig5 --group "OpenMandriva" --key "FirstRun" --default "true")

    if [ "$FIRSTRUN" = 'true' ]; then
# (tpg) add special icons on DESKTOP
	USER_DESKTOP="$(xdg-user-dir DESKTOP)"
	for i in om-welcome join donate calamares; do
	    if [ ! -e "$USER_DESKTOP"/$i.desktop ] && [ -e /usr/share/applications/$i.desktop ]; then
		cp -f /usr/share/applications/$i.desktop "$USER_DESKTOP"/$i.desktop 2> /dev/null
		chmod +x "$USER_DESKTOP"/$i.desktop ||:
	    fi
	done

	kwriteconfig5 --group "OpenMandriva" --key "FirstRun" --type "bool" "false"
	fi

fi

if [ -e "~/.face.icon" ]; then
    chmod 0644 "~/.face.icon"
fi
#end of kde check
