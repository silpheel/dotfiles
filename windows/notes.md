# Docs

## Structure

This repo includes both a Unix part, starting at the root, and a Windows part, housed in subfolder `windows`.

Unix part 99% from Dane MacMillan's dotfiles.
Windows part inspired by, and contains code from, Jay Harris's dotfiles for Windows.

## Installation, in short

PowerShell one-liner to clone the report under the user profile folder:
**REQUIRES ADMIN PRIVILEGES**
```posh
(New-Object Net.WebClient).DownloadFile("https://github.com/silpheel/dotfiles/archive/master.zip","$env:TEMP\dotfiles.zip");(new-object -com shell.application).namespace($env:USERPROFILE).CopyHere((new-object -com shell.application).namespace("$env:TEMP\dotfiles.zip").Items(),16);Rename-Item $env:USERPROFILE\dotfiles-master $env:USERPROFILE\.dotfiles;Set-ExecutionPolicy Unrestricted -Force;. $env:USERPROFILE/.dotfiles/windows/setup/install.ps1
```

This will among other things symlink the windows folder to the locations PowerShell and Windows PowerShell, add Environment Variables.

The Profiles in the Windows folder are also just one, symlinked, so **do not delete** `Microsoft.PowerShell_profile.ps1`

## Installation in detail

The "one-liner" does the following:
1. Download the repo's master branch in a zip file
1. Extract the files to the User Profile folder in `.dotfiles`. Note: this folder must not exist beforehand.
1. Set ExecutionPolicy to Unrestricted. This will be reverted in `windows.ps1`
1. Start install.ps1

### install.ps1

- Set up colors in the environment variables
- Symlink the `.dotfiles/windows` folder to `PowerShell` and `WindowsPowerShell`
- Restart PowerShell
- An environment variable will cause the profile loaded to pick up with `software.ps1`, `windows.ps1`, `symbolic.ps1`

### software.ps1

- Update Help
- Add nuget as package provider
- Install Posh-Git and PSWindowsUpdate
- Install Chocolatey and most of the preferred software, including node.js and atom
- Install npm packages
- Install atom packages
- Download and try to install some software not included in package managers via installers

### windows.ps1

- Change computer name
- Enable developer mode
- Install Windows Subsystem for Linux and Ubuntu
- Change privacy and feature registry keys, add new preferences
- Remove unwanted packed-in software
- Restore ExecutionPolicy to Restricted

### symbolic.ps1

- Setup dotfiles in the WSL Ubuntu installation
- Symlink configuration files for supported software

## PowerShell



## Jarvis

Jarvis assists in setting up PowerShell and changing settings for Dotfiles. It is an experiment that may be expanded or not depending on how often I prefer to use it and how hard it is to maintain.

To use, make sure that Jarvis.ps1 is loaded from the functions folder, and start from the Jarvis command. The whole point is for Jarvis to assist at run time so I am not going into detail here, at least for now, except a list of general features it has.

- Color personalization  
```posh
Jarvis set <identifier> color <foreground> <background>

Jarvis show colors
```
