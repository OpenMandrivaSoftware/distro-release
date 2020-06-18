// Plasma panel for global menu configurations for OpenMandriva
// Author: Bernhard Rosenkränzer <bero@lindev.ch>, (C) 2020
// Licensed under GPLv3+
// Partially based on default panel config

print("Loading OpenMandriva Plasma panel configuration")

// remove already existing old panels
function removeOldPanels()
{
	while(panelIds.length)
		panelById(panelIds[0]).remove()
}

// remove already existing other panels
removeOldPanels()

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
launcher.currentConfigGroup = ["General"]
launcher.writeConfig("favorites", "preferred://browser,org.kde.kmail.desktop,org.kde.konversation.desktop,kcm_kdeconnect.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop,org.kde.konsole.desktop,systemsettings.desktop")
launcher.writeConfig("limitDepth", false)
launcher.writeConfig("useExtraRunners", true)
launcher.writeConfig("alignResultsToBottom", true)
launcher.writeConfig("appNameFormat", "3")
launcher.writeConfig("showRecentContacts", "true")
launcher.writeConfig("showRecentApps", "true")
launcher.writeConfig("showRecentDocs", "true")
launcher.writeConfig("appNameFormat", "0")

panel.addWidget("org.kde.plasma.appmenu")
panel.addWidget("org.kde.plasma.panelspacer")

/* Next up is determining whether to add the Input Method Panel
 * widget to the panel or not. This is done based on whether
 * the system locale's language id is a member of the following
 * white list of languages which are known to pull in one of
 * our supported IME backends when chosen during installation
 * of common distributions. */

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
systray.writeConfig("extraItems", "org.kde.plasma.devicenotifier,org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement,org.kde.muonnotifier,org.kde.plasma.clipboard")
systray.writeConfig("hiddenItems", "hp-systray,python3.4m")
systray.writeConfig("knownItems", "org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement,org.kde.plasma.mediacontroller,org.kde.muonnotifier,org.kde.plasma.devicenotifier,org.kde.plasma.clipboard")

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
