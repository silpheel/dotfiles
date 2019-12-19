# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/functions/common.ps1"}
DotfileLoaded

$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$locations =
"functions/console",
"functions/coreaudio",
"functions/export",
"functions/jarvis",
"functions/registry",
"functions/wsl",
"../source/alias_windows"

Push-Location ~\.dotfiles\windows
$locations | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location

Set-PSReadlineKeyHandler -Key Tab -Function Complete
