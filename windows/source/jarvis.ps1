try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE\.dotfiles\windows\source\function.ps1" }
DotfileLoaded

try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE\.dotfiles\windows\source\function.ps1" }

if (!(Get-Variable JarvisShortcuts -ErrorAction SilentlyContinue)){
  Invoke-Expression "$env:USERPROFILE\.dotfiles\windows\source\alias.ps1"
}

$JarvisSupportedColors =
"Red",
"Green",
"Blue",
"Cyan",
"Magenta",
"Yellow",
"Gray",
"Black",
"White"
$JarvisColorIdentifiers = @{
  "Regular" = "REGULAR";
  "RegularHighlight" = "REGULAR_HIGHLIGHT";
  "Error" = "ERROR";
  "ErrorHighlight" = "ERROR_HIGHLIGHT";
  "Feedback" = "FEEDBACK";
  "FeedbackHighlight" = "FEEDBACK_HIGHLIGHT";
  "Success" = "SUCCESS";
  "SuccessHighlight" = "SUCCESS_HIGHLIGHT";
}

function Set-Color
{
  param(
    [Parameter(Mandatory = $true)] [string]$key,
    [Parameter(Mandatory = $true)] [string]$fore,
    [Parameter(Mandatory = $true)] [string]$back
  )
  if (-not $JarvisColorIdentifiers[$key]) {
    $available
    Write-Host "Identifier not found: " @colorFeedback -NoNewline
    Write-Host "$key" @colorFeedbackHighlight -NoNewline
    Write-Host ". Valid values:" @colorFeedback
    Write-Host $JarvisColorIdentifiers.Keys @colorFeedbackHighlight
  }
  $combo = "$fore $back"
  $envKey = "DOTFILES_FORMAT_" + $JarvisColorIdentifiers[$key]
  [Environment]::SetEnvironmentVariable($envKey,$combo,"User")
  Write-Host "$key $fore $back"
  Set-Variable -Scope Global "color$key" @{
    'ForegroundColor' = $fore;
    'BackgroundColor' = $back;
  }
  Show-Colors
}

function Show-Colors
{
  Write-Host "regular message with " -NoNewline @colorRegular
  Write-Host "highlight " -NoNewline @colorRegularHighlight
  Write-Host "portion" @colorRegular

  Write-Host "error message with " -NoNewline @colorError
  Write-Host "highlight " -NoNewline @colorErrorHighlight
  Write-Host "portion" -NoNewline @colorError
  Write-Host "" @colorRegular

  Write-Host "feedback message with " -NoNewline @colorFeedback
  Write-Host "highlight " -NoNewline @colorFeedbackHighlight
  Write-Host "portion" @colorFeedback -NoNewline
  Write-Host "" @colorRegular

  Write-Host "success message with " -NoNewline @colorSuccess
  Write-Host "highlight " -NoNewline @colorSuccessHighlight
  Write-Host "portion" @colorSuccess -NoNewline
  Write-Host "`n" @colorRegular
}

function Update-All
{
  Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/setup/upgrade.ps1"
}

function Help-Jarvis
{
  if ($args.Count -ge 1 -and $args[0] -ieq "color") {
    Write-Host "Jarvis set <identifier> color [<foreground/background>|<foreground> <background>]" @colorFeedback
    Write-Host "Identifiers: $JarvisColorIdentifiers" @colorFeedback
    Write-Host "Colors: $JarvisSupportedColors. All except Black and White can have the Dark prefix." @colorFeedback -NoNewline
    Write-Host "`nExamples:`nJarvis set regular color White Black`nJarvis set regular color White/Black" @colorFeedback -NoNewline
    Write-Host "`n" @colorRegular
    break
  }
  Write-Host "Jarvis command assistant" @colorFeedback -NoNewline
  Write-Host "`n" @colorRegular
  Write-Host "Supported commands:" @colorFeedback
  Write-Host "Jarvis set <identifier> color [<foreground/background>|<foreground> <background>]" @colorFeedback -NoNewline
  Write-Host "Jarvis upgrade" @colorFeedback -NoNewline
  Write-Host "`n" @colorRegular
}

function Global:Jarvis
{
[CmdletBinding()]
param()
DynamicParam {
  $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary  # Create the dictionary

  $ParameterNameSetColor = 'setColor'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Color"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = $JarvisColorIdentifiers.Keys
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameSetColor, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameSetColor, $RuntimeParameter)

  $ParameterNameForeground = 'foreground'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Color"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = $JarvisSupportedColors
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameForeground, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameForeground, $RuntimeParameter)

  $ParameterNameBackground = 'background'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Color"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = $JarvisSupportedColors
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameBackground, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameBackground, $RuntimeParameter)

  $ParameterNameShow = 'show'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Show"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = 'colors', 'help'
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameShow, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameShow, $RuntimeParameter)

  $ParameterNameUpdate = 'update'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Update"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = "all","choco","atom"
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameUpdate, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameUpdate, $RuntimeParameter)

  $ParameterNameGo = 'go'  # Set the dynamic parameters' name
  $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]  # Create the collection of attributes
  $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
  $ParameterAttribute.ParameterSetName = "Go"
  $AttributeCollection.Add($ParameterAttribute)
  $arrSet = $Global:JarvisShortcuts.Keys
  $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
  $AttributeCollection.Add($ValidateSetAttribute)
  $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameGo, [string], $AttributeCollection)
  $RuntimeParameterDictionary.Add($ParameterNameGo, $RuntimeParameter)

  return $RuntimeParameterDictionary
}
  begin {}
  process {
    if ($PsBoundParameters.ContainsKey($ParameterNameSetColor)) {$setColor = $PsBoundParameters[$ParameterNameSetColor]}
    if ($PsBoundParameters.ContainsKey($ParameterNameShow)) {$show = $PsBoundParameters[$ParameterNameShow]}
    if ($PsBoundParameters.ContainsKey($ParameterNameUpdate)) {$update = $PsBoundParameters[$ParameterNameUpdate]}
    if ($PSBoundParameters.ContainsKey($ParameterNameForeground)) {$foreground = $PsBoundParameters[$ParameterNameForeground]}
    if ($PSBoundParameters.ContainsKey($ParameterNameBackground)) {$background = $PsBoundParameters[$ParameterNameBackground]}
    if ($PSBoundParameters.ContainsKey($ParameterNameGo)) {$go = $PsBoundParameters[$ParameterNameGo]}

    if ($PSBoundParameters.ContainsKey($ParameterNameUpdate)) {
      switch ($update) {
        all { Update-All }
        choco { choco upgrade all }
        atom { Write-Host 'Not yet implemented' @colorFeedback }
      }
    }
    if ($PSBoundParameters.ContainsKey($ParameterNameSetColor)) {
      Set-Color $setColor $foreground $background
    }
    if ($PSBoundParameters.ContainsKey($ParameterNameGo)) {
      $target = $Global:JarvisShortcuts[$go]
      Invoke-Expression $target
      Write-Host "Used alias: " @colorFeedback -NoNewline
      Write-Host $target @colorFeedbackHighlight -NoNewline
    }
    if ($PSBoundParameters.ContainsKey($ParameterNameShow)) {
      switch ($show)
      {
        help { Jarvis-Help }
        colors { Show-Colors }
      }
    }
  }
  end {}
}

Set-Alias -Name Please -Value Jarvis
