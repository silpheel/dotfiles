try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". $env:userprofile/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

try {if(Get-Command "Verify-Elevated" -ErrorAction stop){}}
Catch {Invoke-Expression ". $env:userprofile/.dotfiles/windows/source/console.ps1"}

# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
    Write-Host "You need to start the shell as Administrator mode for this." @colorError
    break
}

### Update Help for Modules
Write-Host "Updating Help..." @colorFeedback
Update-Help -Force

### Package Providers
Write-Host "Installing Package Providers..." @colorFeedback
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted

### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." @colorFeedback
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force

### Chocolatey
Write-Host "Installing Desktop Utilities..." @colorFeedbackHighlight
if ((which cinst) -eq $null) {
    Invoke-Expression (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

if (which cinst) {
    Invoke-Expression ". $env:userprofile\.dotfiles\windows\setup\packageLists\choco.ps1"
    Command-ManagerLoop -Command "install" -packageList $chocoPackageList -manager "choco"
    Refresh-Environment
    $nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
}

### Node
Refresh-Environment

if (which nvm) {
    nvm install $nodeLtsVersion
    nvm use $nodeLtsVersion
} else {
    Write-Host "NVM is not available" @colorError
}

### Ruby
if (which gem) {
    gem pristine --all --env-shebang
} else {
    Write-Host "gem is not available" @colorError
}


### Node Packages
if (which npm) {
    Invoke-Expression ". $env:userprofile\.dotfiles\windows\setup\packageLists\npm.ps1"
    npm update npm
    Command-ManagerLoop -Command "install" -packageList $npmPackageList -manager "npm"
} else {
    Write-Host "NPM is not available" @colorError
}

### Atom Packages
if (which apm) {
    Invoke-Expression ". $env:userprofile\.dotfiles\windows\setup\packageLists\atom.ps1"
    Command-ManagerLoop -Command "install" -packageList $atomPackageList -manager "apm"
} else {
    Write-Host "apm is not available" @colorError
}

### Manual/Semimanual Installers
Invoke-Expression ". $env:userprofile\.dotfiles\windows\setup\packageLists\installers.ps1"
