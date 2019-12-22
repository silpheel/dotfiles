# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~/.dotfiles/windows/source/function.ps1"}
DotfileLoaded

$installComplete = $env:DOTFILES_INSTALLED
if ($installComplete -eq "0") {
  Write-Host "Dotfiles installation" @colorFeedback
  Invoke-Expression ". ./software.ps1"
  Invoke-Expression ". ./symbolic.ps1"
  Invoke-Expression ". ./windows.ps1"
  [Environment]::SetEnvironmentVariable("DOTFILES_INSTALLED", "1", "User")
  # at this point alacritty should be ready to take over
  # Shell-ReloadAdminAdmin
  echo "we would exit here"
  break
}

# support for unicode if not envabled by default
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$locations =
"source/alias",     # shorthand and alternatives
"source/console",   # console behavior changes
"source/coreaudio", # audio related functions (valume, mute...)
"source/export",    # session environment variables
"source/jarvis",    # experiment in organizing the dotfile options
"source/registry",  # registry manipulation functions
"source/wsl"        # Windows Subsystem for Linux tweaks

Push-Location ~\.dotfiles\windows
$locations | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location

# change tab completion behavior
Set-PSReadlineKeyHandler -Key Tab -Function Complete

Append-EnvPath $env:USERPROFILE\.dotfiles\home\.local\bin
