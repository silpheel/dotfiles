$downloadDir = "$env:USERPROFILE/Downloads"

function ManualDLInstall
{
  param(
    [Parameter(Mandatory = $true)] [string]$url,
    [Parameter(Mandatory = $true)] [string]$filename,
    [Parameter(Mandatory = $false)] [string]$argString = " ",
    [Parameter(Mandatory = $false)] [switch]$noWait = $false
  )
  $target = [IO.Path]::Combine($downloadDir,$filename)
  Write-Host $target @colorFeedback
  Write-Host "Downloading " @colorFeedback -NoNewline
  (New-Object Net.WebClient).DownloadFile($url,$target);
  Write-Host "ok" @colorSuccess
  Write-Host "Installing " @colorFeedback -NoNewline
  if ($noWait) {
    Start-Process -ArgumentList $argString -Path $target
  } else {
    Start-Process -Wait -ArgumentList $argString -Path $target
    if ($?) {
      Write-Host "ok" @colorSuccess
      Write-Host " " @colorRegular
    } else {
      Write-Host "error" @colorFailure
      Write-Host " " @colorRegular
    }
  }
}

# PowerShell Core Preview (current stable does not accept arguments)
$metadata = Invoke-RestMethod https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json
$release = $metadata.PreviewReleaseTag -replace '^v'
$architecture = "x64"
$packageName = "PowerShell-${release}-win-${architecture}.msi"
$downloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v${release}/${packageName}"
ManualDLInstall -url $downloadUrl -FileName "powershell-core-${release}.msi" -argString "/passive /norestart"

### Not in choco
# ManualDLInstall "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP" "battle.net installer.exe"
ManualDLInstall -url "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe" -FileName "Rockstar Games Launcher installer.exe" -NoWait
ManualDLInstall -url "https://download.info.apple.com/Mac_OS_X/041-0257.20120611.MkI85/AirPortSetup.exe" -FileName "Apple AirPortSetup.exe" -argString "/passive /norestart"

### Not working in choco
# Karen
# Ultracopier

### Latest in Choco is unstable
ManualDLInstall -url "https://download.kde.org/stable/digikam/6.4.0/digiKam-6.4.0-Win64.exe" -FileName "digiKam 6.4.0 installer.exe"
