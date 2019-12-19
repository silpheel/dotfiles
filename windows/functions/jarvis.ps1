try {if(Get-Command "DotfileLoaded" -ErrorAction stop){}}
Catch {Invoke-Expression ". ~\.dotfiles\windows\functions\common.ps1"}
DotfileLoaded

function Jarvis-ListOptions
{
	Param(
		[Parameter(Mandatory=$true)][array] $Options
	)
	White-Host
	$Options | ForEach-Object -process {Write-Host $_ @colorRegular}
  # CODE
}

$JarvisSupportedColors = "Red", "Green", "Blue", "Cyan", "Magenta", "Yellow", "Gray", "Black", "White"
$JarvisColorIdentifiers = "Regular" ,"RegularHighlight", "Error", "ErrorHighlight", "Feedback", "FeedbackHighlight"

function Jarvis-SetColor
{
	Param(
		[Parameter(Mandatory=$true)][string] $key,
		[Parameter(Mandatory=$true)][string] $fore,
		[Parameter(Mandatory=$false)][string] $back
	)
	$keyMap = @{
		'Regular' = 'REGULAR';
		'RegularHighlight' = 'REGULAR_HIGHLIGHT';
		'Error' = 'ERROR';
		'ErrorHighlight' = 'ERROR_HIGHLIGHT';
		'Feedback' = 'FEEDBACK';
		'FeedbackHighlight' = 'FEEDBACK_HIGHLIGHT';
	}
	if (-Not $keyMap[$key]) {
			$available
			Write-Host "Identifier not found: " @colorFeedback -nonewline
			Write-Host "$key" @colorFeedbackHighlight -nonewline
			Write-Host ". Valid values:" @colorFeedback
			Write-Host $keyMap.Keys @colorFeedbackHighlight
		}
	if ($back.Length -ne 0) {
		$fore = "$fore $back"
	}
	$envKey = "DOTFILES_FORMAT_" + $keyMap[$key]
	[Environment]::SetEnvironmentVariable($envKey, $fore, "User")
}

function Jarvis-GetColors
{
	Write-Host "regular message with " -nonewline @colorRegular
	Write-Host "highlight " -nonewline @colorRegularHighlight
	Write-Host "portion" @colorRegular

	Write-Host "error message with " -nonewline @colorError
	Write-Host "highlight " -nonewline @colorErrorHighlight
	Write-Host "portion" -nonewline @colorError
	Write-Host "" @colorRegular

	Write-Host "feedback message with " -nonewline @colorFeedback
	Write-Host "highlight " -nonewline @colorFeedbackHighlight
	Write-Host "portion" @colorFeedback -nonewline
	Write-Host "" @colorRegular

    Write-Host "success message with " -nonewline @colorSuccess
	Write-Host "highlight " -nonewline @colorSuccessHighlight
	Write-Host "portion" @colorSuccess -nonewline
	Write-Host "`n" @colorRegular
}

function Jarvis-Upgrade
{
    Invoke-Expression ". ~/.dotfiles/windows/setup/upgrade.ps1"
}

function Jarvis-Help
{
	if ($args.Count -ge 1 -and $args[0] -ieq "color") {
		Write-Host "Jarvis set <identifier> color [<foreground/background>|<foreground> <background>]" @colorFeedback
		Write-Host "Identifiers: $JarvisColorIdentifiers" @colorFeedback
		Write-Host "Colors: $JarvisSupportedColors. All except Black and White can have the Dark prefix." @colorFeedback -nonewline
		write-Host "`nExamples:`nJarvis set regular color White Black`nJarvis set regular color White/Black" @colorFeedback -nonewline
		Write-Host "`n" @colorRegular
		break
	}
 	Write-Host "Jarvis command assistant" @colorFeedback -nonewline
	Write-Host "`n" @colorRegular
	Write-Host "Supported commands:" @colorFeedback
    Write-Host "Jarvis set <identifier> color [<foreground/background>|<foreground> <background>]" @colorFeedback -nonewline
    Write-Host "Jarvis upgrade" @colorFeedback -nonewline
	Write-Host "`n" @colorRegular
}

function Jarvis
{
	<#
  .SYNOPSIS
  Jarvis assistant.
  .DESCRIPTION
  Jarvis helps you set up PowerShell and use dotfiles.
  .PARAMETER Volume
  An integer between 0 and 100.
  .EXAMPLE
  Jarvis set regular color White/Black
	Jarvis set regular color White Black
  Sets the color for regular messages to White on Black.
  .EXAMPLE
  Jarvis show colors
  Shows examples of the currently set up colors
#>
	if ($args.Count -ge 1 -and $args[0] -ieq "set") {
		if ($args.Count -ge 3 -and $args[2] -ieq "color") {
			if ($args.count -ge 5) {
				Jarvis-SetColor $args[1] $args[3] $args[4]
				break
			} elseif ($args.count -ge 4) {
				Jarvis-SetColor $args[1] $args[3]
				break
			} else {
				Jarvis-Help "color"
				break
			}
		}
	} elseif ($args[0] -ieq "show" -and $args[1] -eq "colors") {
		Jarvis-GetColors
		break
	} elseif ($args[0] -ieq "upgrade" -or $args[0] -ieq "update") {
        Jarvis-Upgrade
        break
    }
	Jarvis-Help
}
