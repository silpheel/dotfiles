# Read Color schemes from environment variables
# Splatting function results, or array sub indexes, does not work.
# For the time being, in order to have custom colors, it needs to be with vars.
# Sample use: Write-Host "abcd" @colorRegular
# To change settings, edit environment variables DOTFILES_FORMAT_*, restart
# the shell and reload this script.
# If the local variable does not exist, it will use default without error.
# If the variable regex is not recognized, it will default to white on black.
# If the environment variable does not exist, it will default to white on black.

function extractColorInfo
{
  param(
    [Parameter(Mandatory = $true)] [string]$raw
  )
  $colors = [regex]::Match($raw,$regexPattern).Groups
  if ($colors.Groups[1]) {
    $foreColor = $colors.Groups[1].ToString()
  } else {
    $foreColor = "White"
  }
  if ($colors.Groups[2]) {
    $backColor = $colors.Groups[2].ToString()
  } else {
    $backColor = "Black"
  }
  return @{
    'ForegroundColor' = $foreColor;
    'BackgroundColor' = $backColor;
  }
}

function getColor
{
  param(
    [Parameter(Mandatory = $true)] [string]$name
  )
  $key = "DOTFILES_FORMAT_$name"
  if ([Environment]::GetEnvironmentVariable($key,'User')) {
    $regexPattern = "([a-zA-Z]*)[^a-zA-Z]([a-zA-Z]*)"
    $raw = [System.Environment]::GetEnvironmentVariable($key,'User')
    return extractColorInfo $raw
  } else {
    Write-Host "Color key $key not found."
    return @{
      'ForegroundColor' = "White";
      'BackgroundColor' = "Black";
    }
  }
}

$Global:colorRegular = getColor ("REGULAR")
$Global:colorRegularHighlight = getColor ("REGULAR_HIGHLIGHT")
$Global:colorFeedback = getColor ("FEEDBACK")
$Global:colorFeedbackHighlight = getColor ("FEEDBACK_HIGHLIGHT")
$Global:colorError = getColor ("ERROR")
$Global:colorErrorHighlight = getColor ("ERROR_HIGHLIGHT")
$Global:colorSuccess = getColor ("SUCCESS")
$Global:colorSuccessHighlight = getColor ("SUCCESS_HIGHLIGHT")

$ScriptsRoot = "$env:USERPROFILE\.dotfiles\windows\"
# Stores in an array the list of loaded scripts
function DotfileLoaded
{
  if (!(Test-Path variable:Global:LoadedScripts)) {
    $Global:LoadedScripts = [system.collections.arraylist]@()
  }
  $myCommandDefinition = $MyInvocation.ScriptName.Replace($ScriptsRoot,"")
  if (!($Global:LoadedScripts.Contains($myCommandDefinition))) {
    $Global:LoadedScripts.Add($myCommandDefinition) | Out-Null
  }
}

function Show-LoadedScripts
{
  Write-Host "Loaded scripts:" @colorFeedbackHighlight
  foreach ($item in $Global:LoadedScripts) {
    Write-Host $item @colorFeedback
  }
  Write-Host " " @colorRegular
}

# Feedback of which file is loading.
# In this case we want to load colors first.
# For all other files, place these 3 lines at the top:
try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE\.dotfiles\windows\source\function.ps1" }
DotfileLoaded

# Basic commands
function Append-EnvPath ([string]$path) { $env:PATH = $env:PATH + ";$path" }
function Append-EnvPathIfExists ([string]$path) { if (Test-Path $path) { Append-EnvPath $path } }

function which ($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch ($file) { "" | Out-File $file -Encoding ASCII }
function Restart-AdminShell
{
  try { Start-Process alacritty -Verb RunAs -ErrorAction Stop }
  catch { return }
  exit
}
# Common Editing needs
function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
function sudo () {
  if ($args.Length -eq 1) {
    Start-Process $args[0] -Verb "runAs"
  }
  if ($args.Length -gt 1) {
    Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb "runAs"
  }
}

# System Update - Update RubyGems, NPM, and their installed packages
function System-Update () {
  Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
  Update-Module
  Update-Help -Force
  gem update --system
  gem update
  npm install npm -g
  npm update -g
  choco upgrade all
}

# Reload the Shell
# DOES NOT WORK AS EXPECTED WITH PWSH/ALACRITTY
function Reload-Powershell {
  $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = "-nologo";
  [System.Diagnostics.Process]::Start($newProcess);
  exit
}

# Download a file into a temporary folder
function curlex ($url) {
  $uri = New-Object system.uri $url
  $filename = $name = $uri.segments | Select-Object -Last 1
  $path = Join-Path $env:Temp $filename
  if (Test-Path $path) { rm -Force $path }

  (New-Object net.webclient).DownloadFile($url,$path)

  return New-Object io.fileinfo $path
}

# Empty the Recycle Bin on all drives
function Empty-RecycleBin {
  $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
  $RecBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Confirm:$false }
}

# Sound Volume
function Get-SoundVolume {
<#
    .SYNOPSIS
    Get audio output volume.

    .DESCRIPTION
    The Get-SoundVolume cmdlet gets the current master volume of the default audio output device. The returned value is an integer between 0 and 100.

    .LINK
    Set-SoundVolume

    .LINK
    Set-SoundMute

    .LINK
    Set-SoundUnmute

    .LINK
    https://github.com/silpheel/dotfiles-windows/
#>
  [math]::Round([Audio]::Volume * 100)
}

function Set-SoundVolume ([Parameter(Mandatory = $true)] [int32]$Volume) {
<#
    .SYNOPSIS
    Set audio output volume.

    .DESCRIPTION
    The Set-SoundVolume cmdlet sets the current master volume of the default audio output device to a value between 0 and 100.

    .PARAMETER Volume
    An integer between 0 and 100.

    .EXAMPLE
    Set-SoundVolume 65
    Sets the master volume to 65%.

    .EXAMPLE
    Set-SoundVolume -Volume 100
    Sets the master volume to a maximum 100%.

    .LINK
    Get-SoundVolume

    .LINK
    Set-SoundMute

    .LINK
    Set-SoundUnmute

    .LINK
    https://github.com/silpheel/dotfiles-windows/
#>
  [Audio]::Volume = ($Volume / 100)
}

function Set-SoundMute {
<#
    .SYNOPSIS
    Mute audio output.

    .DESCRIPTION
    The Set-SoundMute cmdlet mutes the default audio output device.

    .LINK
    Get-SoundVolume

    .LINK
    Set-SoundVolume

    .LINK
    Set-SoundUnmute

    .LINK
    https://github.com/silpheel/dotfiles-windows/
#>
  [Audio]::Mute = $true
}

function Set-SoundUnmute {
<#
    .SYNOPSIS
    Unmute audio output.

    .DESCRIPTION
    The Set-SoundUnmute cmdlet unmutes the default audio output device.

    .LINK
    Get-SoundVolume

    .LINK
    Set-SoundVolume

    .LINK
    Set-SoundMute

    .LINK
    https://github.com/silpheel/dotfiles-windows/
#>
  [Audio]::Mute = $false
}

### File System functions
### ----------------------------
# Create a new directory and enter it
function CreateAndSet-Directory ([string]$path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path }

# Determine size of a file or total size of a directory
function Get-DiskUsage ([string]$path = (Get-Location).Path) {
  Convert-ToDiskSize `
     (`
       Get-ChildItem .\ -Recurse -ErrorAction SilentlyContinue `
       | Measure-Object -Property length -Sum -ErrorAction SilentlyContinue
  ).Sum `
     1
}

# Cleanup all disks (Based on Registry Settings in `windows.ps1`)
function Clean-Disks {
  Start-Process "$(Join-Path $env:WinDir 'system32\cleanmgr.exe')" -ArgumentList "/sagerun:6174" -Verb "runAs"
}

### Environment functions
### ----------------------------

# Reload the $env object from the registry
function Refresh-Environment {
  $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
  'HKCU:\Environment'

  $locations | ForEach-Object {
    $k = Get-Item $_
    $k.GetValueNames() | ForEach-Object {
      $name = $_
      $value = $k.GetValue($_)
      Set-Item -Path Env:\$name -Value $value
    }
  }

  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment ([string]$variable,[string]$value) {
  Set-ItemProperty "HKCU:\Environment" $variable $value
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
  Invoke-Expression "`$env:${variable} = `"$value`""
}

# Add a folder to $env:Path
function Prepend-EnvPath ([string]$path) { $env:PATH = $env:PATH + ";$path" }
function Prepend-EnvPathIfExists ([string]$path) { if (Test-Path $path) { Prepend-EnvPath $path } }
function Append-EnvPath ([string]$path) { $env:PATH = $env:PATH + ";$path" }
function Append-EnvPathIfExists ([string]$path) { if (Test-Path $path) { Append-EnvPath $path } }


### Utilities
### ----------------------------

# Convert a number to a disk size (12.4K or 5M)
function Convert-ToDiskSize {
  param($bytes,$precision = '0')
  foreach ($size in ("B","K","M","G","T")) {
    if (($bytes -lt 1000) -or ($size -eq "T")) {
      $bytes = ($bytes).ToString("F0" + "$precision")
      return "${bytes}${size}"
    }
    else { $bytes /= 1KB }
  }
}

# Start IIS Express Server with an optional path and port
function Start-IISExpress {
  [CmdletBinding()]
  param(
    [string]$path = (Get-Location).Path,
    [int32]$port = 3000
  )

  if ((Test-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe") -or (Test-Path "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe")) {
    $iisExpress = Resolve-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe" -ErrorAction SilentlyContinue
    if ($iisExpress -eq $null) { $iisExpress = Get-Item "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe" }

    & $iisExpress @("/path:${path}") /port:$port
  } else { Write-Warning "Unable to find iisexpress.exe" }
}

# Extract a .zip file
function Unzip-File {
<#
    .SYNOPSIS
       Extracts the contents of a zip file.

    .DESCRIPTION
       Extracts the contents of a zip file specified via the -File parameter to the
    location specified via the -Destination parameter.

    .PARAMETER File
        The zip file to extract. This can be an absolute or relative path.

    .PARAMETER Destination
        The destination folder to extract the contents of the zip file to.

    .PARAMETER ForceCOM
        Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.

    .EXAMPLE
       Unzip-File -File archive.zip -Destination .\d

    .EXAMPLE
       'archive.zip' | Unzip-File

    .EXAMPLE
        Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}

    .INPUTS
       String

    .OUTPUTS
       None

    .NOTES
       Inspired by:  Mike F Robbins, @mikefrobbins

       This function first checks to see if the .NET Framework 4.5 is installed and uses it for the unzipping process, otherwise COM is used.
    #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
    [string]$File,

    [ValidateNotNullOrEmpty()]
    [string]$Destination = (Get-Location).Path
  )

  $filePath = Resolve-Path $File
  $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

  if (($PSVersionTable.PSVersion.Major -ge 3) -and
    ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.5*" -or
      (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.5*")) {

    try {
      [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
      [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath","$destinationPath")
    } catch {
      Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
    }
  } else {
    try {
      $shell = New-Object -ComObject Shell.Application
      $shell.Namespace($destinationPath).copyhere(($shell.Namespace($filePath)).Items())
    } catch {
      Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
    }
  }
}

function CheckBox
{
  param(
    [Parameter(Mandatory = $true)] [string]$content,
    [Parameter(Mandatory = $true)] [string]$ForegroundColor,
    [Parameter(Mandatory = $true)] [string]$BackgroundColor
  )
  Write-Host "[" -NoNewline @colorRegular
  Write-Host $content -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
  Write-Host "]" -NoNewline @colorRegular
}

function Symlink
{
  param(
    [Parameter(Mandatory = $true)] [string]$source,
    [Parameter(Mandatory = $true)] [string]$dest,
    [Parameter(Mandatory = $false)] [bool]$isFolder = $false
  )
  if (Test-Path $dest) {
    if ($isFolder) {
      if ((Get-Item $dest).Attributes.ToString().Contains("ReparsePoint")) {
        CheckBox "U" @colorSuccess
      } else {
        CheckBox "A" @colorError
      }
    }
    if ((Get-Item $dest).LinkType -ne "HardLink") {
      CheckBox "U" @colorError
    } else {
      CheckBox "A" @colorSuccess
    }
    Remove-Item $dest | Out-Null
  } else {
    CheckBox "R" @colorFeedback
  }
  if ($isFolder) {
    New-Item -Value $source -ItemType Junction -Path $dest | Out-Null
  } else {
    New-Item -Value $source -ItemType HardLink -Path $dest | Out-Null
  }
  Write-Host "$dest" @colorRegular
}

# revised from https://devblogs.microsoft.com/scripting/use-a-powershell-function-to-see-if-a-command-exists/
function Test-CommandExists
{
  param($command)
  try { if (Get-Command $command -ErrorAction stop) { return $true } }
  catch { return $false }
}

function Command-ManagerLoop
{
  param(
    [Parameter(Mandatory = $true)] [array]$packageList,
    [Parameter(Mandatory = $true)] [string]$command,
    [Parameter(Mandatory = $true)] [string]$manager
  )
  Write-Host "$manager package $command" @colorFeedback -NoNewline
  Write-Host " " @colorRegular
  $packageList | ForEach-Object -Process {
    Write-Host "$_ ..." -NoNewline @colorRegular
    Invoke-Expression "$manager $command $_" | Out-Null
    if ($?) {
      Write-Host "ok" @colorSuccess -NoNewline
      Write-Host " " @colorRegular
    } else {
      Write-Host "error" @colorFailure -NoNewline
      Write-Host " " @colorRegular
    }
  }
}
