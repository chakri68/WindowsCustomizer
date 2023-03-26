<#
.SYNOPSIS
Prints the input text in a figlet font (Requires node figlet-cli).

.DESCRIPTION
The Write-Figlet cmdlet generates ASCII art text in a specified figlet font. By default, the cmdlet randomly selects a font from the available figlet fonts if a font is not specified.

.PARAMETER text
The text to print the figlet of.

.PARAMETER font
The figlet font name to use. If no font is specified, the cmdlet randomly selects a font from the available figlet fonts.

.PARAMETER fontname
Switch to print the font name.

.EXAMPLE
Write-Figlet -text "Hello, World!" -font Cursive -fontname
Prints the ASCII art of "Hello, World!" in the Cursive font with the font name at the end.

.INPUTS
None.

.OUTPUTS
The ASCII art text in the specified figlet font.

.NOTES
Requires node figlet-cli. 

#>

param(
  [string]$text = "flyingdelta",
  [string]$font = '',
  [switch]$help = $false,
  [switch]$fontname = $false
)

if ($help) { return Get-Help Write-Figlet }

if ($font -eq '') {
  $fonts = @(figlet -l)
  $randomIndex = Get-Random -Minimum 0 -Maximum $fonts.Length
  $font = $fonts[$randomIndex]
}

$figletOutput = (figlet -f $font $text) -join "`n"

Write-FormattedText -text $figletOutput -align center -textAlign left
if ($fontname) {
  Write-FormattedText -text "~$font" -align right
}
