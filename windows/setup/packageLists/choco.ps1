try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/functions/common.ps1"}
DotfileLoaded

$chocoPackageList =
# system and cli
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

# fonts
"sourcecodepro",

# browsers,
# "GoogleChrome",
# "GoogleChrome.Canary",
"Firefox",
#"Opera",

# dev tools and frameworks
"atom",
"Fiddler",
"vim",
"winmerge",
"notepadplusplus.install",
"hxd",

# system functionality extenders
"7zip",
"autohotkey.portable",
"Everything",
"icloud",
"nircmd",
"procexp",
"revo-uninstaller",
"sharex",
"switcheroo",
"switcheroo.install",
"sysinternals",
"wiztree",
"freecommander-xe.install",
"k-litecodecpackfull",

# consoles
"alacritty",
"Cmder",
"microsoft-windows-terminal",

# readers
"calibre",
"fsviewer",
"sumatrapdf",
"mediamonkey",

# gaming
"epicgameslauncher",
"goggalaxy",
"itch",
"origin",
"steam",
"twitch",
"uplay",
"nvidia-display-drivers",

# other
"audacity",
"Franz",
"gimp",
"mkvtoolnix",
"qbittorrent",
"vlc"
