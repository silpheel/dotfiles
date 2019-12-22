try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

$chocoPackageList =
## SYSTEM AND CLI
"curl",
"nuget.commandline",
"webpi",
"git.install",
"nvm.portable",
"python3",
"ruby",
"php",
"github-Desktop",
"windows-sdk-10-version-1903-all",
"seer",
"vscode",
## FONTS
"sourcecodepro",
## BROWSERS
# "GoogleChrome",
"Firefox",
## DEV TOOLS AND FRAMEWORKS
"atom",                     # hackable editor and tools
"Fiddler",                  # web debugging
"vim",                      # console version
"winmerge",                 # merge or compare files
"notepadplusplus.install",  # simplistic editor, replaces notepad
"hxd",                      # hex editor
## SYSTEM FUNCTIONALITY
"7zip",                     # compression
"autohotkey.portable",      # portable/compiled scripts
"Everything",               # search anywhere, interacts with Wox
"icloud",                   # iCloud sync
"nircmd",                   # advanced command line utils
"procexp",                  # better task manager
"revo-uninstaller",         # better uninstaller
"sharex",                   # easy screen cap
"switcheroo",               # switch windows
"sysinternals",             # command line utils
"wiztree",                  # analyze disk usage, replaces windirstat
"freecommander-xe.install", # file manager alternative
"k-litecodecpackfull",      # video codec pack
## CONSOLES
"alacritty",
"Cmder",
"microsoft-windows-terminal",
## READERS
"aimp",       # music
"calibre",    # ebook manager
"fsviewer",   # images
"sumatrapdf", # pdf
"vlc",        # video
## GAMING CRAZYNESS
"epicgameslauncher",      # Epic Games
"goggalaxy",              # CD Projekt Red
"itch",                   # Indie
"origin",                 # EA
"steam",                  # Valve
"twitch",                 # Amazon
"uplay",                  # Ubisoft
"nvidia-display-drivers", # video drivers
## OTHER
"audacity",     # audio edit
"Franz",        # chat
"gimp",         # image edit
"mkvtoolnix",   # matroska video
"qbittorrent"  # bittorrent
