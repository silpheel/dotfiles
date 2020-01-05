# requires -Version 2 -Modules posh-git
function Reset-CursorPosition {
    $postion = $host.UI.RawUI.CursorPosition
    $postion.X = 0
    $host.UI.RawUI.CursorPosition = $postion
}

$rightPos = -1
$leftBg = "WHITE"
$rightBg = "WHITE"
$escapeChar = [char]27

function Write-Theme
{
  param(
    [bool] $lastCommandFailed,
    [string] $with
  )
	$date = Get-Date -UFormat %d-%m-%Y
	$timeStamp = Get-Date -UFormat %R
	$user = $sl.CurrentUser
	$computer = [System.Environment]::MachineName
	$path = (Get-FullPath -dir $pwd)

	$script:rightPos = -1

	$space = ""
	$bk = "$space$($sl.PromptSymbols.SegmentBackwardSymbol)"
	$fw = "$($sl.PromptSymbols.SegmentForwardSymbol)$space"
	$bkSep = "$space$($sl.PromptSymbols.SegmentSeparatorBackwardSymbol)"
	$fwSep = "$($sl.PromptSymbols.SegmentSeparatorForwardSymbol)$space"

	# LEFT SIDE
	$script:leftBg = $sl.Colors.DriveBackgroundColor
	Push-LeftLabel "$path$space" -ForegroundColor $sl.Colors.DriveForegroundColor
	$status = Get-VCSStatus
	if ($status) {
			$themeInfo = Get-VcsInfo -status ($status)
			Set-LeftLabel -Object $fw -BackgroundColor $themeInfo.BackgroundColor
			Push-LeftLabel -Object "$space$($themeInfo.VcInfo)$space" -ForegroundColor $sl.Colors.GitForegroundColor
	}

	if ($with) {
		Set-LeftLabel $fw -BackgroundColor $sl.Colors.WithBackgroundColor
		Push-LeftLabel -Object "$space$($with.ToUpper())$space" -ForegroundColor $sl.Colors.WithForegroundColor
	}
	$position = $host.UI.RawUI.CursorPosition

	# RIGHT SIDE
	$script:rightBg = "WHITE"
	# Push-RightLabel -Object "$space$date" -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
	# Push-RightLabel -Object "$bkSep" -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
	Push-RightLabel -Object "$space$timeStamp" -ForegroundColor $sl.Colors.SessionInfoForegroundColor
	Set-RightLabel -Object "$bk" -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

	if (Test-NotDefaultUser($user)) {$text = "$space$user@$computer"} else { $text = "$space"}
	Push-RightLabel -Object $text -ForegroundColor $sl.Colors.SessionInfoForegroundColor

	if (Test-VirtualEnv) {
		Set-RightLabel -Object $bk -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
		Push-RightLabel -Object "$space$($sl.PromptSymbols.VirtualEnvSymbol)$(Get-VirtualEnvName)" -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
	}

	Set-RightLabel -Object "$bk" -BackgroundColor $sl.Colors.PromptBackgroundColor

	# PROMPT
	$host.UI.RawUI.CursorPosition = $position
	$goToNewLine = $false
	if ($goToNewLine) {
		Set-LeftLabel -Object $fw -BackgroundColor $sl.Colors.PromptBackgroundColor
		Set-Newline
		$script:leftBg = $sl.Colors.SessionInfoBackgroundColor
	} else {
		Set-LeftLabel -Object $fw -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
	}

	If ($lastCommandFailed) {
		Push-LeftLabel -Object "$($sl.PromptSymbols.FailedCommandSymbol)$space" -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
	}
	If (Test-Administrator) {$text = $sl.PromptSymbols.ElevatedSymbol} else {$text = "R"}
	Push-LeftLabel -Object "$text" -ForegroundColor $sl.Colors.AdminIconForegroundColor
	Push-LeftLabel -Object "$space$($sl.PromptSymbols.StartSymbol)$space" -ForegroundColor $sl.Colors.PromptForegroundColor
	Set-LeftLabel -Object $fw -BackgroundColor $sl.Colors.PromptBackgroundColor
	$prompt = ""
	$global:Error.Clear()
	$prompt
}

$sl = $global:ThemeSettings  # local settings
$sl.GitSymbols = @{
	AfterStashSymbol              = '}'
	BeforeIndexSymbol             = [char]0x222b  # ∫
  BeforeWorkingSymbol           = [char]0x03c9  # ω
	BeforeStashSymbol             = '{'
	BranchAheadStatusSymbol       = [char]0x2191  # ↑
	BranchBehindStatusSymbol      = [char]0x2193  # ↓
	BranchIdenticalStatusToSymbol = [char]0x2261  # ≡
	BranchSymbol                  = [char]0xE0A0  # 
	BranchUntrackedSymbol         = [char]0x203c  # ‼
  DelimSymbol                   = '|'
	LocalDefaultStatusSymbol      = [char]0x2615  # ☕
	LocalStagedStatusSymbol       = '~'
  LocalWorkingStatusSymbol      = '!'
  OriginSymbols                 = @{
		Bitbucket = "g"
    Github    = "G"
		GitLab    = "b"
  }
}
$sl.PromptSymbols = @{
	ElevatedSymbol                 = [char]0x21D1  # ⇑
	FailedCommandSymbol            = [char]0x00D7  # × (multiplication)
	HomeSymbol                     = '~'
	PathSeparator                  = [System.IO.Path]::DirectorySeparatorChar
	PromptIndicator                = [char]0x25b6  # ▶
	RegularSymbol                  = [char]0xE0A2  #  (lock)
	SegmentBackwardSymbol          = [char]0xE0B2  # 
	SegmentForwardSymbol           = [char]0xE0B0  # 
	SegmentSeparatorBackwardSymbol = [char]0xE0B3  # 
	SegmentSeparatorForwardSymbol  = [char]0xE0B1  # 
  StartSymbol                    = ' '
  TruncatedFolderSymbol          = '..'
  VirtualEnvSymbol               = [char]0x221A  # √
}
$sl.Colors = @{
	AdminIconForegroundColor                = [ConsoleColor]::DarkYellow
	CommandFailedIconForegroundColor        = [ConsoleColor]::DarkRed
	DriveForegroundColor                    = [ConsoleColor]::Black
	DriveBackgroundColor                    = [ConsoleColor]::DarkBlue
  GitDefaultColor                         = [ConsoleColor]::DarkGreen
	GitForegroundColor                      = [ConsoleColor]::Black
  GitLocalChangesColor                    = [ConsoleColor]::DarkYellow
	GitNoLocalChangesAndAheadAndBehindColor = [ConsoleColor]::DarkRed
  GitNoLocalChangesAndAheadColor          = [ConsoleColor]::DarkMagenta
  GitNoLocalChangesAndBehindColor         = [ConsoleColor]::DarkRed
	PromptBackgroundColor                   = [ConsoleColor]::Black
  PromptForegroundColor                   = [ConsoleColor]::White
  PromptHighlightColor                    = [ConsoleColor]::Magenta
  PromptSymbolColor                       = [ConsoleColor]::Black
  SessionInfoBackgroundColor              = [ConsoleColor]::Magenta
  SessionInfoForegroundColor              = [ConsoleColor]::Black
	VirtualEnvBackgroundColor               = [ConsoleColor]::Red
	VirtualEnvForegroundColor               = [ConsoleColor]::Black
  WithBackgroundColor                     = [ConsoleColor]::DarkRed
  WithForegroundColor                     = [ConsoleColor]::Black
}
$sl.Options = @{
  ConsoleTitle = $true
  OriginSymbols = $false
}

# [char]0x2610  # ☐
# [char]0x2611  # ☑
# [char]0x2713  # ✓
# [char]0x203D  # ‽

function Push-RightLabel
{
	param(
    [string] $Object,
		[Parameter(Mandatory = $false)] [string] $ForegroundColor="WHITE"
  )
	if ($script:rightBg -eq "") {$script:rightBg = Get-DiffColor "" ""}
	$script:rightPos += $Object.Length
	Set-CursorForRightBlockWrite -textLength $script:rightPos
	Write-Prompt -Object $Object -ForegroundColor $ForegroundColor -BackgroundColor $script:rightBg
}

function Push-LeftLabel
{
	param(
    [string] $Object,
		[Parameter(Mandatory = $false)] [string] $ForegroundColor="WHITE"
  )
	if ($script:leftBg -eq "") {$script:leftBg = Get-DiffColor "" ""}
	Write-Prompt -Object $Object -ForegroundColor $ForegroundColor -BackgroundColor $script:leftBg
}

function Get-DiffColor
{
	param(
		[string] $oldColor,
		[string] $newColor
  )
	if ($script:oldColor -eq $newColor) {
		if ($oldColor -eq "BLACK") {
			return "WHITE"
		} else {
			return "BLACK"
		}
	} else {
		return $oldColor
	}
}

function Set-LeftLabel
{
	param(
		[string] $Object,
		[string] $BackgroundColor
  )
	$color = Get-DiffColor $script:leftBg $BackgroundColor
	Write-Prompt -Object $Object -ForegroundColor $color -BackgroundColor $BackgroundColor
	$script:leftBg = $BackgroundColor
}

function Set-RightLabel
{
	param(
		[string] $Object,
		[string] $BackgroundColor
  )
		$color = Get-DiffColor $script:rightBg $BackgroundColor
		$script:rightBg = $BackgroundColor
		Push-RightLabel -Object $Object -ForegroundColor $color
}
