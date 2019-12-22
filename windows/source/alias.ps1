$Time = [System.Diagnostics.Stopwatch]::StartNew()
try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~.dotfileswindowssourceunction.ps1"}

# Easier Navigation: .., ..., ...., ....., and ~
${Function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${Function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${Function:...} =    { Set-Location ..\.. }
${Function:....} =   { Set-Location ..\..\.. }
${Function:.....} =  { Set-Location ..\..\..\.. }
${Function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${Function:drop} =     { Set-Location ~\Documents\Dropbox }
${Function:dt} =       { Set-Location ~\Desktop }
${Function:docs} =     { Set-Location ~\Documents }
${Function:dl} =       { Set-Location ~\Downloads }
${Function:local} =    { Set-Location ~\AppData\Local }
${Function:locallow} = { Set-Location ~\AppData\LocalLow }
${Function:roaming} =  { Set-Location ~\AppData\Roaming }
${Function:posh} =     { Set-Location (Split-Path -parent $profile)}
# for some reason atm ls does not work in subfolders of wsl is not in bash
# Will only work for Ubuntu installation
$WSLRoot = "$((Get-ChildItem ~\AppData\Local\Packages\CanonicalGroupLimited*)[0].FullName)\LocalState\rootfs"
${Function:wsl} = {
  Set-Location $WSLRoot
}
# quick close
${Function:Get-Out} = { exit }; Set-Alias "x" Get-Out

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
  rm alias:wget -ErrorAction SilentlyContinue
}

$LS_DEFAULTS="-lAhviNp"
$LS_IGNORES="--ignore=.DS_Store --ignore='Icon'$'\r' --ignore=.CFUserTextEncoding --ignore=.localized --ignore=.Trash --ignore=.Trashes --ignore=.Spotlight-V100 --ignore=.fseventsd"
${Function:ll} = { ls $LS_DEFAULTS $LS_IGNORES }
${Function:lll} = { ls $LS_DEFAULTS $LS_IGNORES | Out-Host -paging}

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:curl -ErrorAction SilentlyContinue
    # Set `ls` to call `ls.exe` and always use --color
    ${Function:curl} = { curl.exe @args }
    # Gzip-enabled `curl`
    ${Function:gurl} = { curl --compressed @args }
} else {
    # Gzip-enabled `curl`
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

DotfileLoaded
