$downloadDir = "~/Downloads"

$client = new-object System.Net.WebClient

function dl($url, $filename, $args){
    $target = [IO.Path]::Combine($downloadDir, $filename)
    Write-Host $target @colorFeedback
    Write-Host "Downloading" @colorFeedback
    Invoke-WebRequest -Uri $url -OutFile $target
    $command = Resolve-Path $target
    $command = '"' + $command + '" ' + $args
    Write-Host "Waiting for installer to finish" @colorFeedback
    iex "& $command"
    $name = $filename -replace ".exe"
    Wait-Process -Name "$name"
}

### Not in choco
# dl "https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP" "battle.net installer.exe"
dl "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe" "Rockstar Games Launcher installer.exe"
dl "https://download.info.apple.com/Mac_OS_X/041-0257.20120611.MkI85/AirPortSetup.exe" "Apple AirPortSetup.exe" "/passive /norestart"

### Not working in choco
# Karen
# Seer
# Ultracopier

### Latest in Choco is unstable
dl "https://download.kde.org/stable/digikam/6.4.0/digiKam-6.4.0-Win64.exe" "digiKam 6.4.0 installer.exe"
