loadTemplate("org.om.plasma6.desktop.defaultPanel")

var desktopsArray = desktopsForActivity(currentActivity());
for( var j = 0; j < desktopsArray.length; j++) {
    desktopsArray[j].wallpaperPlugin = 'org.kde.image';
    desktopsArray[j].currentConfigGroup = new Array("General")
    desktopsArray[j].writeConfig("pressToMove",true)
    desktopsArray[j].writeConfig("showToolbox",false)
    desktopsArray[j].writeConfig("toolTips", true)
    desktopsArray[j].writeConfig("selectionMarkers",false)
    desktopsArray[j].currentConfigGroup = new Array("Wallpaper", "org.kde.image", "General")
    desktopsArray[j].writeConfig("Image", "file:///usr/share/mdk/backgrounds/default.png")
    desktopsArray[j].writeConfig("FillMode","2")
}
