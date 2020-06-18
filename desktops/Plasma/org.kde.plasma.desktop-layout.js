// Default Plasma layout for OpenMandriva
// Author: Tomasz Paweł Gajc (tpgxyz@gmail.com) 2013, 2014, 2015, 2016
// Licensed under GPL

print("Starting OpenMandriva Plasma configuration")
loadTemplate("org.openmandriva.plasma.desktop.defaultPanel")

var desktopsArray = desktopsForActivity(currentActivity());
for( var j = 0; j < desktopsArray.length; j++) {
	desktopsArray[j].wallpaperPlugin = 'org.kde.image';
	desktopsArray[j].wallpaperMode = 'SingleImage';
	desktopsArray[j].currentConfigGroup = new Array("General")
	desktopsArray[j].writeConfig("pressToMove",true)
	desktopsArray[j].writeConfig("showToolbox",false)
	desktopsArray[j].writeConfig("toolTips", true)
	desktopsArray[j].writeConfig("selectionMarkers",false)
	desktopsArray[j].writeConfig("arrangement","1")
	desktopsArray[j].writeConfig("iconSize","4")
	desktopsArray[j].currentConfigGroup = new Array("Wallpaper", "org.kde.image", "General")
	desktopsArray[j].writeConfig("Image", "file:///usr/share/mdk/backgrounds/default.png")
	desktopsArray[j].writeConfig("FillMode","2")
}

sleep(0.5)
// lock desktop
locked = false;
