// Plasma panel for OpenMandriva Plasma6
// 2023-09-14 (rugyada)

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
	// set the location for the user
	panel.location = "bottom";
}

// panel height based on scren's DPI
// panel.height = gridUnit * 3
panel.height = 2 * Math.floor(gridUnit * 2.5 / 2)
panel.alignment = "center";
panel.hiding = "none";

// by default kicker is used, options are kickoff and kickerdash
var launcher = panel.addWidget("org.kde.plasma.kicker")
launcher.currentConfigGroup = ["Shortcuts"]
launcher.writeConfig("global", "Alt+F1")
launcher.writeConfig("favoriteSystemActions", "logout")
launcher.currentConfigGroup = ["General"]
launcher.writeConfig("favoriteApps", "applications:chromium-browser.desktop,applications:systemsettings.desktop,applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop")
launcher.writeConfig("limitDepth", "false")
launcher.writeConfig("useExtraRunners", "true")

panel.addWidget("org.kde.plasma.icontasks")

var pager = panel.addWidget("org.kde.plasma.pager")
pager.currentConfigGroup = ["General"]
pager.writeConfig("showWindowIcons","true")

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
systray.writeConfig("hiddenItems", "hp-systray,python3.11")
systray.writeConfig("knownItems", "org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.battery,org.kde.plasma.volume,org.kde.plasma.networkmanagement,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier,org.kde.plasma.clipboard")

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

