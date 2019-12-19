try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/functions/common.ps1"}
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

Symlink $env:userprofile\.dotfiles\windows\Microsoft.PowerShell_profile.ps1 $env:userprofile\.dotfiles\windows\Microsoft.PowerShellISE_profile.ps1
symlink $env:userprofile\.dotfiles\home\.config\alacritty\alacritty_windows.yml $env:appdata\alacritty\alacritty.yml
symlink $env:userprofile\.dotfiles\home\atom\config.cson ~\.atom\config.cson
symlink $env:userprofile\.dotfiles\home\atom\keymap.cson ~\.atom\keymap.cson

$myCommandDefinition = $MyInvocation.MyCommand.Definition.Replace($env:userprofile + "\.dotfiles\windows\", "")
Write-Host "Loaded " -nonewline @colorFeedback
Write-Host "$myCommandDefinition" -nonewline @colorFeedbackHighlight
Write-Host "`n" @colorRegular
