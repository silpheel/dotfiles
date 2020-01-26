try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression "$env:USERPROFILE/.dotfiles/windows/source/function.ps1" }
DotfileLoaded

try { if (Get-Command "Verify-Elevated" -ErrorAction stop) {} }
catch { Invoke-Expression "$env:USERPROFILE/.dotfiles/windows/source/console.ps1" }

# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
  Write-Host "You need to start the shell as Administrator mode for this." @colorError -NoNewline
  Write-Host "" @colorRegular
  break
}

### Update Help for Modules
Write-Host "Updating Help..." @colorFeedback
Update-Help -Force

### Chocolatey
if (which choco) {
  choco upgrade all
}

### Atom Packages
if (which apm) {
  Invoke-Expression "$env:USERPROFILE\.dotfiles\windows\setup\packageLists\atom.ps1"
  Command-ManagerLoop -Command "upgrade" -packageList $atomPackageList -manager "apm"
}
