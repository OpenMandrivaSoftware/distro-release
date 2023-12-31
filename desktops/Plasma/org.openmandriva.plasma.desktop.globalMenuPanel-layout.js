// Plasma panel for global menu configurations for OpenMandriva
// Author: Bernhard Rosenkränzer <bero@lindev.ch>, (C) 2020
// Licensed under GPLv3+
// Partially based on default panel config
// 2023-09-14 (rugyada)

print("Loading OpenMandriva Plasma panel configuration")

// start new panel
var panel = new Panel
panel.location = "top";
// let's calculate desired panel height based on screen's DPI
panel.height = gridUnit*1.5
panel.alignment = "left"
panel.hiding = "none"

// by default kicker is used, options are kickoff and kickerdash
var launcher = panel.addWidget("org.kde.plasma.kicker")
launcher.currentConfigGroup = ["Shortcuts"]
launcher.writeConfig("global", "Alt+F1")
launcher.writeConfig("favoriteSystemActions", "logout")
launcher.currentConfigGroup = ["General"]
launcher.writeConfig("favoriteApps", "preferred://browser,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.konsole.desktop")
launcher.writeConfig("limitDepth", "false")
launcher.writeConfig("useExtraRunners", "true")

panel.addWidget("org.kde.plasma.appmenu")
panel.addWidget("org.kde.plasma.panelspacer")

var langIds = ["as",    // Assamese
               "bn",    // Bengali
               "bo",    // Tibetan
               "brx",   // Bodo
               "doi",   // Dogri
               "gu",    // Gujarati
               "hi",    // Hindi
               "ja",    // Japanese
               "kn",    // Kannada
               "ko",    // Korean
               "kok",   // Konkani
               "ks",    // Kashmiri
               "lep",   // Lepcha
               "mai",   // Maithili
               "ml",    // Malayalam
               "mni",   // Manipuri
               "mr",    // Marathi
               "ne",    // Nepali
               "or",    // Odia
               "pa",    // Punjabi
               "sa",    // Sanskrit
               "sat",   // Santali
               "sd",    // Sindhi
               "si",    // Sinhala
               "ta",    // Tamil
               "te",    // Telugu
               "th",    // Thai
               "ur",    // Urdu
               "vi",    // Vietnamese
               "zh_CN", // Simplified Chinese
               "zh_TW"] // Traditional Chinese

if (langIds.indexOf(languageId) != -1) {
    panel.addWidget("org.kde.plasma.kimpanel");
}

var systray = panel.addWidget("org.kde.plasma.systemtray")
systray.currentConfigGroup = ["General"]
systray.writeConfig("communicationsShow", "true")
systray.writeConfig("applicationStatusShown","true")
systray.writeConfig("ShowCommunications","true")
systray.writeConfig("systemServicesShown","true")
systray.writeConfig("hardwareControlShown","true")
systray.writeConfig("miscellaneousShown","true")
systray.writeConfig("extraItems", "org.kde.plasma.devicenotifier,org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement,org.kde.plasma.clipboard")
systray.writeConfig("hiddenItems", "hp-systray,python3.4m")
systray.writeConfig("knownItems", "org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier,org.kde.plasma.clipboard")

var clock = panel.addWidget("org.kde.plasma.digitalclock")
clock.currentConfigGroup = ["Appearance"]
clock.writeConfig("showDate","false")
clock.writeConfig("showWeekNumbers","false")
clock.writeConfig("dateFormat", "isoDate")
clock.writeConfig("use24hFormat", "2")
clock.reloadConfig()

sleep(0.5)
panel.reloadConfig()
// if set to true it is not possible to remove panel :)
panel.locked = false;
