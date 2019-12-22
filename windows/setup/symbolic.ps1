try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

### SCRIPT START

Write-Host "Setting up symlinks" @colorFeedback
# Junction this directory to PowerShell script
$profileDir = Split-Path -parent $profile
if ((Get-Item $profileDir).Attributes.ToString().Contains("ReparsePoint"))  # Already a Junction
{
	Remove-Item $profileDir
}
New-Item -Value $env:userprofile\.dotfiles\windows -Path $profileDir\ -ItemType Junction
Write-Host "$dest" @colorRegular

$repo = $env:userprofile\.dotfiles\home\.config

# PowerShell
Symlink $env:userprofile\.dotfiles\windows\Microsoft.PowerShell_profile.ps1 $env:userprofile\.dotfiles\windows\Microsoft.PowerShellISE_profile.ps1

# Alacritty
symlink $repo\alacritty\alacritty_windows.yml $env:appdata\alacritty\alacritty.yml

# Atom
symlink $base\atom\config.cson ~\.atom\config.cson
symlink $repo\atom\keymap.cson ~\.atom\keymap.cson
symlink $repo\atom\snippets.cson ~\.atom\snippets.cson
symlink $repo\atom\init.coffee ~\.atom\init.coffee
symlink $repo\atom\styles.less ~\.atom\styles.less

# ShareX
$documentsFolder = [environment]::getfolderpath("mydocuments")
symlink $repo\sharex\ApplicationConfig.json $documentsFolder\ShareX\ApplicationConfig.json
symlink $repo\sharex\HotkeysConfig.json $documentsFolder\ShareX\HotkeysConfig.json
symlink $repo\sharex\UploadersConfig.json $documentsFolder\ShareX\UploadersConfig.json

# Switcheroo - folder has version number and probably will change eventually
$switcherooFolder = gci $env:localappdata\switcheroo | gci
symlink $repo\switcheroo\user.config $switcherooFolder\user.config

# Wox
symlink $repo\wox\Settings.json $env:appdata\wox\Settings.json
