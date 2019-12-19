try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/functions/common.ps1"}
DotfileLoaded

$npmPackageList =
"gulp",
"mocha",
"node-inspector",
"yo"
