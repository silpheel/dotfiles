# Unblock scripts in the dotfiles folder. This prevents having to authorize
# every script to run it.
Get-ChildItem $env:USERPROFILE\.dotfiles\*.ps1 -Recurse | Unblock-File

# REGISTRY KEYS FOR CONFIG
# I wanted to have custom colors for command feedback and to store the values in
# the environment variables.
$RegSettings = @{
  'DOTFILES_FORMAT_REGULAR' = 'White/Black';
  'DOTFILES_FORMAT_REGULAR_HIGHLIGHT' = 'Yellow/Black';
  'DOTFILES_FORMAT_FEEDBACK' = 'Black/Magenta';
  'DOTFILES_FORMAT_FEEDBACK_HIGHLIGHT' = 'Yellow/Magenta';
  'DOTFILES_FORMAT_ERROR' = 'Black/Red';
  'DOTFILES_FORMAT_ERROR_HIGHLIGHT' = 'White/Red';
  'DOTFILES_FORMAT_SUCCESS' = 'Black/Green';
  'DOTFILES_FORMAT_SUCCESS_HIGHLIGHT' = 'White/Green';
  'DOTFILES_SHOW_FEEDBACK' = '1';
  'DOTFILES_INSTALLED' = '0';
  'VIRTUAL_ENV_DISABLE_PROMPT' = "1";
}
$counter = 0
$RegSettings.Keys | ForEach-Object -Process {
  $perc = [math]::Round($counter * 100 / $RegSettings.Count)
  $counter = $counter + 1
  Write-Progress -Activity "Environment variables" -Status "$perc% Complete:" -PercentComplete $perc -CurrentOperation $_
  [Environment]::SetEnvironmentVariable($_,$RegSettings[$_],"User")
}
Write-Progress -Activity "Environment variables" -Completed

# Symlinks powershell dir
$profileDir = Split-Path -Parent $profile
$commonParentDir = Split-Path -Parent $profileDir
"WindowsPowerShell","PowerShell" | ForEach-Object -Process {
  Remove-Item $commonParentDir\$_ -Force -Recurse | Out-Null
  New-Item -Value $env:USERPROFILE\.dotfiles\windows -Path $commonParentDir\$_ -ItemType Junction | Out-Null
}

# try to restart the shell in admin mode. The profile should resume installation
# Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/function.ps1"
try { Start-Process PowerShell -Verb RunAs -ErrorAction Stop }
catch { exit }
Write-Output "Restart the shell in Admin mode to continue."
