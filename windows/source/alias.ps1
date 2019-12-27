try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/function.ps1" }
DotfileLoaded

# Easier Navigation: .., ..., ...., ....., and ~
${Function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${Function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${Function:...} =    { Set-Location ..\.. }
${Function:....} =   { Set-Location ..\..\.. }
${Function:.....} =  { Set-Location ..\..\..\.. }
${Function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${Function:.drop} = { Set-Location ~\Documents\Dropbox }
${Function:.dt} = { Set-Location ~\Desktop }
${Function:.win} = { Set-Location ~\.dotfiles\windows }
${Function:.dotfiles} = { Set-Location ~\.dotfiles }
${Function:.docs} = { Set-Location ~\Documents }
${Function:.dl} = { Set-Location ~\Downloads }
${Function:.local} = { Set-Location ~\AppData\Local }
${Function:.locallow} = { Set-Location ~\AppData\LocalLow }
${Function:.roaming} = { Set-Location ~\AppData\Roaming }
${Function:.posh} = { Set-Location (Split-Path -Parent $profile) }
${Function:.temp} = { Set-Location $env:TEMP }

# Used by Jarvis
$Global:JarvisShortcuts = @{
  "Dropbox" = ".drop";
  "Desktop" = ".dt";
  "Windows_dotfiles" = ".win";
  "Dotfiles_root" = ".root";
  "Documents" = ".docs";
  "Downloads" = ".dl";
  "LocalData" = ".local";
  "LocalLowData" = ".locallow";
  "RoamingData" = ".roaming";
  "PowerShellProfile" = ".posh";
  "User_profile" = "~";
  "Temp" = ".temp";
}

# quick close
${Function:Get-Out} = { exit }; Set-Alias "x" Get-Out

try { if (Get-Command "Test-RegistryValue" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/registry.ps1" }

# Windows Subsystem for Linux
$RegWindowsCV = 'HKCU:\Software\Microsoft\Windows\CurrentVersion'
if ((Test-Path "$RegWindowsCV\Lxss") -and (Test-RegistryValue "$RegWindowsCV\Lxss" "DefaultDistribution")) {
  $WSLDistro = (Get-ItemProperty -Path "$RegWindowsCV\Lxss" -Name 'DefaultDistribution').DefaultDistribution
  $WSLRootFS = (Get-ItemProperty -Path "$RegWindowsCV\Lxss\$WSLDistro" -Name 'BasePath').BasePath
  ${Function:wsl} = {
    Set-Location $WSLRootFS
  }
}

# boostrap and reload
${Function:dotfiles} = {
  Set-Location ~/.dotfiles
  . .\bootstrap.ps1
  . $profile
}

# Missing Bash aliases
Set-Alias time Measure-Command

# Correct PowerShell Aliases if tools are available (aliases win if set)
# WGet: Use `wget.exe` if available
if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:wget -ErrorAction SilentlyContinue
}

$LS_DEFAULTS = "-lAhviNp"
$LS_IGNORES = "--ignore=.DS_Store --ignore='Icon'$'\r' --ignore=.CFUserTextEncoding --ignore=.localized --ignore=.Trash --ignore=.Trashes --ignore=.Spotlight-V100 --ignore=.fseventsd"
${Function:ll} = { ls $LS_DEFAULTS $LS_IGNORES }
${Function:lll} = { ls $LS_DEFAULTS $LS_IGNORES | Out-Host -Paging }

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:curl -ErrorAction SilentlyContinue
  ${Function:curl} = { curl.exe @args }
  ${Function:gurl} = { curl --compressed @args }
} else {
  ${Function:gurl} = { curl -TransferEncoding GZip }
}

# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Empty the Recycle Bin on all drives
Set-Alias emptytrash Empty-RecycleBin

# Cleanup old files all drives
Set-Alias cleandisks Clean-Disks

# Reload the shell
Set-Alias reload Reload-Powershell

# http://xkcd.com/530/
Set-Alias mute Set-SoundMute
Set-Alias unmute Set-SoundUnmute

Set-Alias mkd CreateAndSet-Directory

Set-Alias vi vim
