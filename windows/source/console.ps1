try { if (Get-Command "DotfileLoaded" -ErrorAction stop) {} }
catch { Invoke-Expression ". $env:USERPROFILE/.dotfiles/windows/source/function.ps1" }
DotfileLoaded

function Verify-Elevated {
  # Get the ID and security principal of the current user account
  $myIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $myPrincipal = New-Object System.Security.Principal.WindowsPrincipal ($myIdentity)
  # Check to see if we are currently running "as Administrator"
  return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Convert-ConsoleColor {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
    [string]$rgb
  )

  if ($rgb -notmatch '^#[\da-f]{6}$') {
    Write-Error "Invalid color '$rgb' should be in RGB hex format, e.g. #000000"
    return
  }
  $num = [Convert]::ToInt32($rgb.substring(1,6),16)
  $bytes = [BitConverter]::GetBytes($num)
  [array]::Reverse($bytes,0,3)
  return [BitConverter]::ToInt32($bytes,0)
}

# More bash-like tab completion
Set-PSReadLineKeyHandler -Key Tab -Function Complete

# Git info in prompt
if (((Get-Command git -ErrorAction SilentlyContinue) -ne $null) -and ((Get-Module -ListAvailable Posh-Git -ErrorAction SilentlyContinue) -ne $null)) {
  Import-Module Posh-Git
  $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
  $GitPromptSettings.AfterText += "`n"
  $GitPromptSettings.AdminTitlePrefixText = "A|"
}
# Add A| in front if admin session or R| if regular
function prompt {
  if (Verify-Elevated) {
    $prompt = Write-Prompt "A|" -ForegroundColor Red
  } else {
    $prompt = Write-Prompt "R|" -ForegroundColor White
  }
  $prompt += & $GitPromptScriptBlock
  if ($prompt) { $prompt } else { " " }
}
