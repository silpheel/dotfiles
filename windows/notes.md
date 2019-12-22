# Docs

## Structure

This repo includes both a Unix part, starting at the root, and a Windows part, housed in subfolder `windows`.

Unix part 99% from Dane MacMillan's dotfiles.
Windows part inspired by, and contains code from, Jay Harris's dotfiles for Windows.

## Installation

PowerShell one-liner to clone the report under the user profile folder:
```posh
(New-Object Net.WebClient).DownloadFile("https://github.com/silpheel/dotfiles/archive/master.zip","$env:TEMP\dotfiles.zip");(new-object -com shell.application).namespace($env:USERPROFILE).CopyHere((new-object -com shell.application).namespace("$env:TEMP\dotfiles.zip").Items(),16);Rename-Item $env:USERPROFILE\dotfiles-master $env:USERPROFILE\.dotfiles;Set-ExecutionPolicy Unrestricted -Force;. $env:userprofile/.dotfiles/windows/setup/install.ps1
```

This will among other things symlink the windows folder to the locations PowerShell and Windows PowerShell, add Environment Variables.

The Profiles in the Windows folder are also just one, symlinked, so **do not delete** `Microsoft.PowerShell_profile.ps1`

Currently, after installation you'll need to restart the shell, also to use Alacritty instead of PowerShell.

## PowerShell



## Jarvis

Jarvis assists in setting up PowerShell and changing settings for Dotfiles. It is an experiment that may be expanded or not depending on how often I prefer to use it and how hard it is to maintain.

To use, make sure that Jarvis.ps1 is loaded from the functions folder, and start from the Jarvis command. The whole point is for Jarvis to assist at run time so I am not going into detail here, at least for now, except a list of general features it has.

- Color personalization  
```posh
Jarvis set <identifier> color <foreground> <background>

Jarvis show colors
```
