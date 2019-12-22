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
dotnet tool install --global PowerShell

### Chocolatey
Write-Host "Installing Desktop Utilities..." @colorFeedbackHighlight
if ((which cinst) -eq $null) {
    Invoke-Expression ". ~\.dotfiles\windows\setup\packageLists\choco.ps1"
    Invoke-Expression (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
    Command-ManagerLoop -Command "install" -packageList $chocoPackageList -manager "choco"
}

### Node
Refresh-Environment

$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion

### Ruby
gem pristine --all --env-shebang

### Node Packages
if (which npm) {
    Invoke-Expression ". ~\.dotfiles\windows\setup\packageLists\npm.ps1"
    npm update npm
    Command-ManagerLoop -Command "install" -packageList $npmPackageList -manager "npm"
} else {
    Write-Host "NPM is not available" @colorError
}

### Atom Packages
Invoke-Expression ". ~\.dotfiles\windows\setup\packageLists\atom.ps1"
Command-ManagerLoop -Command "install" -packageList $atomPackageList -manager "apm"

### Manual/Semimanual Installers
Invoke-Expression ". ~\.dotfiles\windows\setup\packageLists\installers.ps1"
