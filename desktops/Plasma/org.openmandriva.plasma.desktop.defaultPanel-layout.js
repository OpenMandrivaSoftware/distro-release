// Default Plasma panel for OpenMandriva
// Author: Tomasz Paweł Gajc (tpgxyz@gmail.com) 2013, 2014, 2015, 2016
// Bernhard Rosenkränzer <bero@lindev.ch> 2020
// Licensed under GPLv2+

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
if (panelIds.length == 1) {
	// we are the only panel, so set the location for the user
	panel.location = "bottom";
}

// let's calculate desired panel height based on scren's DPI
panel.height = gridUnit * 3
panel.alignment = "left";
panel.hiding = "none";

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

var tasks = panel.addWidget("org.kde.plasma.taskmanager")
tasks.currentConfigGroup = ["General"]
tasks.writeConfig("forceStripes","true")
tasks.writeConfig("middleClickAction", "Close")
tasks.writeConfig("onlyGroupWhenFull","true")
tasks.writeConfig("groupingStrategy","1")
tasks.writeConfig("highlightWindows","false")
tasks.writeConfig("maxStripes","2")
tasks.writeConfig("showOnlyCurrentDesktop","true")
tasks.writeConfig("showOnlyCurrentScreen","false")
tasks.writeConfig("showOnlyMinimized","false")
tasks.writeConfig("showToolTips","true")
tasks.writeConfig("sortingStrategy","2")

var pager = panel.addWidget("org.kde.plasma.pager")
pager.currentConfigGroup = ["General"]
pager.writeConfig("showWindowIcons","true")
pager.writeConfig("displayedText", "Number")

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
clock.writeConfig("showDate","true")
clock.writeConfig("showWeekNumbers","true")
clock.writeConfig("dateFormat", "isoDate")
clock.writeConfig("use24hFormat", "2")
clock.reloadConfig()

panel.addWidget("org.kde.plasma.trash")

sleep(0.5)
panel.reloadConfig()
// if set to true it is not possible to remove panel :)
panel.locked = false;
