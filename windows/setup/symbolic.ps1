try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". $env:userprofile/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

try {if(Get-Command "wsl" -ErrorAction stop){}}
Catch {Invoke-Expression ". $env:userprofile/.dotfiles/source/alias.ps1"}

### SCRIPT START

Write-Host "Setting up symlinks" @colorFeedback
# Junction this directory to PowerShell script
$profileDir = Split-Path -parent $profile
$commonParentDir = Split-Path -parent $profileDir
"WindowsPowerShell", "PowerShell" | ForEach-Object -process {
  Remove-Item $commonParentDir\$_ -Force -Recurse | Out-Null
  New-Item -Value $env:userprofile\.dotfiles\windows -Path $commonParentDir\$_ -ItemType Junction | Out-Null
}

$repo = "$env:userprofile\.dotfiles\home\.config"

# PowerShell
Symlink $env:userprofile\.dotfiles\windows\Microsoft.PowerShell_profile.ps1 $env:userprofile\.dotfiles\windows\Microsoft.PowerShellISE_profile.ps1

# Windows Subsystem for Linux
$WSLHome = (Get-ChildItem $WSLRootFS\home)[0].FullName
symlink $env:userprofile\.dotfiles\home\.bashrc $WSLHome\.bashrc
symlink $env:userprofile\.dotfiles\home\.bash_profile $WSLHome\.bash_profile
# TODO: dynamic link
# this requires UNIX password
bash /mnt/c/Users/silph/.dotfiles/windows/setup/bash_setup_folders
symlink $env:userprofile\.dotfiles\source\alias $WSLHome\.dotfiles\source\alias
symlink $env:userprofile\.dotfiles\source\bootstrap $WSLHome\.dotfiles\source\bootstrap
symlink $env:userprofile\.dotfiles\source\function $WSLHome\.dotfiles\source\function
symlink $env:userprofile\.dotfiles\source\local_config_templates $WSLHome\.dotfiles\source\local_config_templates
symlink $env:userprofile\.dotfiles\source\path $WSLHome\.dotfiles\source\path
symlink $env:userprofile\.dotfiles\source\prompt_string $WSLHome\.dotfiles\source\prompt_string
symlink $env:userprofile\.dotfiles\source\ui_ux $WSLHome\.dotfiles\source\ui_ux
symlink $env:userprofile\.dotfiles\source\xdg_base_directory_specification $WSLHome\.dotfiles\source\xdg_base_directory_specification
# TODO: dynamic link
# this requires UNIX password... again
bash /mnt/c/Users/silph/.dotfiles/windows/setup/bash_setup_chmod

# Alacritty
symlink $repo\alacritty\alacritty_windows.yml $env:appdata\alacritty\alacritty.yml

# Atom
symlink $base\atom\config.cson ~\.atom\config.cson
symlink $repo\atom\keymap.cson ~\.atom\keymap.cson
symlink $repo\atom\snippets.cson ~\.atom\snippets.cson
symlink $repo\atom\init.coffee ~\.atom\init.coffee
symlink $repo\atom\styles.less ~\.atom\styles.less

# ShareX
$documentsFolder = [Environment]::GetFolderPath("mydocuments")
symlink $repo\sharex\ApplicationConfig.json $documentsFolder\ShareX\ApplicationConfig.json
symlink $repo\sharex\HotkeysConfig.json $documentsFolder\ShareX\HotkeysConfig.json
symlink $repo\sharex\UploadersConfig.json $documentsFolder\ShareX\UploadersConfig.json

# Switcheroo - folder has version number and probably will change eventually
$switcherooFolder = Get-ChildItem $env:localappdata\switcheroo | Get-ChildItem
symlink $repo\switcheroo\user.config $switcherooFolder\user.config

# Wox
symlink $repo\wox\Settings.json $env:appdata\wox\Settings.json
