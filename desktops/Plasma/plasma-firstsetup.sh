#!/bin/sh

if [ -n "$(command -v kreadconfig5)" ]; then # Check if Plasma is installed, otherwise do nothing
    FIRSTRUN=$(kreadconfig5 --group "OpenMandriva" --key "FirstRun" --default "true")

    if [ "$FIRSTRUN" = 'true' ]; then
# (tpg) enable xscreensaver
	if [ ! -f "~/.config/autostart/xscreensaver.desktop" -a -x "$(command -v xscreensaver)" ]; then
	    mkdir -p "~/.config/autostart"
	    cat > "~/.config/autostart/xscreensaver.desktop" << "EOF"
[Desktop Entry]
Name=XScreenSaver
Exec=xscreensaver -nosplash
Icon=xscreensaver
Terminal=False
Type=Application
X-KDE-StartupNotify=False
OnlyShowIn=KDE;
EOF
	fi

# (tpg) add special icons on DESKTOP
	USER_DESKTOP="$(xdg-user-dir DESKTOP)"
	for i in om-welcome join donate calamares; do
	    if [ ! -e "$USER_DESKTOP"/$i.desktop ] && [ -e /usr/share/applications/$i.desktop ]; then
		cp -f /usr/share/applications/$i.desktop "$USER_DESKTOP" 2> /dev/null
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
