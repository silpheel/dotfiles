try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

$npmPackageList =
"gulp",
"mocha",
"node-inspector",
"yo"
