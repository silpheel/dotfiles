try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/function.ps1" }
DotfileLoaded

try { if (Get-Command "wsl" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/alias.ps1" }

### SCRIPT START

Write-Host "Setting up symlinks" @colorFeedback
# Junction this directory to PowerShell script
$profileDir = Split-Path -Parent $profile
$commonParentDir = Split-Path -Parent $profileDir
"WindowsPowerShell","PowerShell" | ForEach-Object -Process {
  Remove-Item $commonParentDir\$_ -Force -Recurse | Out-Null
  New-Item -Value $env:USERPROFILE\.dotfiles\windows -Path $commonParentDir\$_ -ItemType Junction | Out-Null
}

$repo = "$env:USERPROFILE\.dotfiles\home\.config"

# PowerShell
Symlink $env:USERPROFILE\.dotfiles\windows\Microsoft.PowerShell_profile.ps1 $env:USERPROFILE\.dotfiles\windows\Microsoft.PowerShellISE_profile.ps1

# Windows Subsystem for Linux
if (-not $WSLRootFS) {
  Write-Host "No distibutions found in Windows Subsystem for Linux." @colorError
} else {
  $WSLHome = (Get-ChildItem $WSLRootFS\home)[0].FullName
  Symlink $env:USERPROFILE\.dotfiles\home\.bashrc $WSLHome\.bashrc
  Symlink $env:USERPROFILE\.dotfiles\home\.bash_profile $WSLHome\.bash_profile
  # TODO: dynamic link
  # this requires UNIX password
  bash /mnt/c/Users/silph/.dotfiles/windows/setup/bash_setup_folders
  Symlink $env:USERPROFILE\.dotfiles\source\alias $WSLHome\.dotfiles\source\alias
  Symlink $env:USERPROFILE\.dotfiles\source\bootstrap $WSLHome\.dotfiles\source\bootstrap
  Symlink $env:USERPROFILE\.dotfiles\source\function $WSLHome\.dotfiles\source\function
  Symlink $env:USERPROFILE\.dotfiles\source\local_config_templates $WSLHome\.dotfiles\source\local_config_templates
  Symlink $env:USERPROFILE\.dotfiles\source\path $WSLHome\.dotfiles\source\path
  Symlink $env:USERPROFILE\.dotfiles\source\prompt_string $WSLHome\.dotfiles\source\prompt_string
  Symlink $env:USERPROFILE\.dotfiles\source\ui_ux $WSLHome\.dotfiles\source\ui_ux
  Symlink $env:USERPROFILE\.dotfiles\source\xdg_base_directory_specification $WSLHome\.dotfiles\source\xdg_base_directory_specification
  # TODO: dynamic link
  # this requires UNIX password... again
  bash /mnt/c/Users/silph/.dotfiles/windows/setup/bash_setup_chmod
}

function CreateDirIfNotExists
{
  param(
    [Parameter(Mandatory = $true)] [string]$path,
    [Parameter(Mandatory = $true)] [string]$name
  )
  if (!(Test-Path ([IO.Path]::Combine($path,$name)))) { New-Item -ItemType Directory -Path $path -Name $name | Out-Null }
}

# Alacritty
CreateDirIfNotExists $env:appdata alacritty
Symlink $repo\alacritty\alacritty_windows.yml $env:appdata\alacritty\alacritty.yml

# Atom
Symlink $repo\atom\config.cson $env:USERPROFILE\.atom\config.cson
Symlink $repo\atom\keymap.cson $env:USERPROFILE\.atom\keymap.cson
Symlink $repo\atom\snippets.cson $env:USERPROFILE\.atom\snippets.cson
Symlink $repo\atom\init.coffee $env:USERPROFILE\.atom\init.coffee
Symlink $repo\atom\styles.less $env:USERPROFILE\.atom\styles.less

# Everything
CreateDirIfNotExists $env:appdata everything
Symlink $repo\everything\everything.ini $env:appdata\everything\everything.ini

# FreeCommander
CreateDirIfNotExists $env:localappdata FreeCommanderXE
CreateDirIfNotExists $env:localappdata\FreeCommanderXE Settings
Symlink $repo\FreeCommander\FreeCommander.ini $env:appdata\FreeCommander\Settings\FreeCommander.ini
Symlink $repo\FreeCommander\FreeCommander.views.ini $env:appdata\FreeCommander\Settings\FreeCommander.views.ini
Symlink $repo\FreeCommander\FreeCommander.wcx.ini $env:appdata\FreeCommander\Settings\FreeCommander.wcx.ini

# Karen's Replicator
CreateDirIfNotExists $env:localappdata "Karen's Power Tools"
CreateDirIfNotExists "$env:localappdata\Karen's Power Tools" Replicator
Symlink $repo\karen\replicator\Exclusions.txt "$env:localappdata\Karen's Power Tools\replicator\Exclusions.txt"
Symlink $repo\karen\replicator\FileFilters.txt "$env:localappdata\Karen's Power Tools\replicator\FileFilters.txt"
Symlink $repo\karen\replicator\Jobs.txt "$env:localappdata\Karen's Power Tools\replicator\Jobs.txt"

# ShareX
$documentsFolder = [Environment]::GetFolderPath("mydocuments")
Symlink $repo\sharex\ApplicationConfig.json $documentsFolder\ShareX\ApplicationConfig.json
Symlink $repo\sharex\HotkeysConfig.json $documentsFolder\ShareX\HotkeysConfig.json
Symlink $repo\sharex\UploadersConfig.json $documentsFolder\ShareX\UploadersConfig.json

# Switcheroo - folder has version number and probably will change eventually
CreateDirIfNotExists $env:localappdata switcheroo
$switcherooFolder = Get-ChildItem $env:localappdata\switcheroo | Get-ChildItem
Symlink $repo\switcheroo\user.config $switcherooFolder\user.config

# Vim
Symlink $repo\vim\vimrc $env:USERPROFILE\_vimrc

# Wox
CreateDirIfNotExists $env:appdata wox
CreateDirIfNotExists $env:appdata\wox settings
Symlink $repo\wox\Settings.json $env:appdata\wox\settings\Settings.json
