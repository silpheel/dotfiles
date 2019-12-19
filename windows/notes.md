# Docs

## Structure

This repo includes both a Unix part, starting at the root, and a Windows part, housed in subfolder `windows`.

Unix part 99% from Dane MacMillan's dotfiles.
Windows part inspired by, and contains code from, Jay Harris's dotfiles for Windows.

## Installation

Clone the full repository into the %userprofile% directory. It typically is C:\Users\<username>

There, run `windows\setup\install.ps1`.

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
