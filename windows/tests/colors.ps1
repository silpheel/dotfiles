$colors =
"Black",
"DarkBlue",
"DarkGreen",
"DarkCyan",
"DarkRed",
"DarkMagenta",
"DarkYellow",
"Gray",
"DarkGray",
"Blue",
"Green",
"Cyan",
"Red",
"Magenta",
"Yellow",
"White"

$colors | ForEach-Object -process {
		$row = $_
		$colors | ForEach-Object -process {
				Write-Host $_ -ForegroundColor $_ -BackgroundColor $row -nonewline
		}
		Write-Host
	}
