# Unblock scripts in the dotfiles folder

Get-ChildItem $env:userprofile\.dotfiles\*.ps1 -Recurse | Unblock-File

# REGISTRY KEYS FOR CONFIG

$RegSettings = @{
    'DOTFILES_FORMAT_REGULAR'= 'White/Black';
    'DOTFILES_FORMAT_REGULAR_HIGHLIGHT'= 'Yellow/Black';
    'DOTFILES_FORMAT_FEEDBACK'= 'Black/Magenta';
    'DOTFILES_FORMAT_FEEDBACK_HIGHLIGHT'= 'Yellow/Magenta';
    'DOTFILES_FORMAT_ERROR'= 'Black/Red';
    'DOTFILES_FORMAT_ERROR_HIGHLIGHT'= 'White/Red';
    'DOTFILES_FORMAT_SUCCESS'= 'Black/Green';
    'DOTFILES_FORMAT_SUCCESS_HIGHLIGHT'= 'White/Green';
    'DOTFILES_SHOW_FEEDBACK' = '1';
}

$counter = 0
$RegSettings.Keys | ForEach-Object -process {
    $perc = [math]::Round($counter * 100/$RegSettings.count)
    $counter = $counter + 1
    Write-Progress -Activity "Environment variables" -Status "$perc% Complete:" -PercentComplete $perc -CurrentOperation $_
    [Environment]::SetEnvironmentVariable($_, $RegSettings[$_], "User")
}

Write-Progress -Completed

$colorRegular = @{
  'ForegroundColor'= "White";
  'BackgroundColor'= "Black";
}
$colorRegularHighlight = @{
  'ForegroundColor'= "Yellow";
  'BackgroundColor'= "Black";
}
$colorFeedback = @{
  'ForegroundColor'= "Black";
  'BackgroundColor'= "Magenta";
}
$colorFeedbackHighlight = @{
  'ForegroundColor'= "Yellow";
  'BackgroundColor'= "Magenta";
}
$colorError = @{
  'ForegroundColor'= "Black";
  'BackgroundColor'= "Red";
}
$colorErrorHighlight = @{
  'ForegroundColor'= "White";
  'BackgroundColor'= "Red";
}
$colorSuccess = @{
  'ForegroundColor'= "Black";
  'BackgroundColor'= "Green";
}
$colorSuccessHighlight = @{
  'ForegroundColor'= "White";
  'BackgroundColor'= "Green";
}

Invoke-Expression ". ./software.ps1"
Invoke-Expression ". ./symbolic.ps1"
Invoke-Expression ". ./windows.ps1"

Write-Host "Initial setup is complete"
Start-Process alacritty -Verb RunAs
exit
