$downloadDir = "$env:userprofile/Downloads"

function ManualDLInstall
{
    Param(
        [Parameter(Mandatory=$true)][string] $url,
        [Parameter(Mandatory=$true)][string] $filename,
        [Parameter(Mandatory=$false)][string] $argString = ""
	)
    $target = [IO.Path]::Combine($downloadDir, $filename)
    Write-Host $target @colorFeedback
    Write-Host "Downloading " @colorFeedback -nonewline
    (New-Object Net.WebClient).DownloadFile($url, $target);
    Write-Host "ok" @colorSuccess
    Write-Host "Installing " @colorFeedback -nonewline
    Start-Process -Wait -ArgumentList $argString $target
    if ($?){
		Write-Host "ok" @colorSuccess
        Write-Host " " @colorRegular
	} else {
		Write-Host "error" @colorFailure
        Write-Host " " @colorRegular
	}
}

# PowerShell Core Preview (current stable does not accept arguments)
$metadata = Invoke-RestMethod https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json
$release = $metadata.PreviewReleaseTag -replace '^v'
$architecture = "x64"
$packageName = "PowerShell-${release}-win-${architecture}.msi"
$downloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v${release}/${packageName}"
ManualDLInstall $downloadUrl "powershell-core-${release}.msi" "/passive /norestart"

### Not in choco
# ManualDLInstall "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP" "battle.net installer.exe"
ManualDLInstall "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe" "Rockstar Games Launcher installer.exe"
ManualDLInstall "https://download.info.apple.com/Mac_OS_X/041-0257.20120611.MkI85/AirPortSetup.exe" "Apple AirPortSetup.exe" "/passive /norestart"

### Not working in choco
# Karen
# Ultracopier

### Latest in Choco is unstable
ManualDLInstallExe "https://download.kde.org/stable/digikam/6.4.0/digiKam-6.4.0-Win64.exe" "digiKam 6.4.0 installer.exe"
