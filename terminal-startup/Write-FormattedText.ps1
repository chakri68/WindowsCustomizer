
<#
.SYNOPSIS
Prints text in the console window with various alignments.

.DESCRIPTION
The Write-FormattedText function aligns the input text, change the text alignment and prints it. 

.PARAMETER text
The text to format. Use @""@ for multiline strings.

.PARAMETER align
The horizontal alignment of the text. Valid values are left, center, and right. Default is center.
For left alignment, text is aligned to the left edge of the console window.
For center alignment, text is centered in the console window.
For right alignment, text is aligned to the right edge of the console window.

.PARAMETER textAlign
The text alignment within each line. Valid values are left, center, and right. Default is left.
For left text alignment, each line is aligned to the left edge of the text block.
For center text alignment, each line is centered in the text block.
For right text alignment, each line is aligned to the right edge of the text block.

.EXAMPLE
Write-FormattedText -text "This is centered text" -align center -textAlign center

This example prints the text "This is centered text" in the center of the console window with center alignment and center text alignment.

.NOTES
Author: delta
Version: 1.0
#>

param(
  [Parameter(Position = 0)]
  [string]$text,

  [Parameter(Position = 1)]
  [ValidateSet('left', 'center', 'right')]
  [string]$align = "center",

  [Parameter(Position = 2)]
  [ValidateSet('left', 'center', 'right')]
  [string]$textAlign = "left",

  [switch]$help = $false
)

function Get-Left-Offset {
  param(
    $stringLength,
    $longestLineLength
    )

  $textOffset = 0
  $charOffset = 0

  switch ($align) {
    left {
      $textOffset = 0
    }
    center { 
      $textOffset = [Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($longestLineLength / 2)
    }
    right {
      $textOffset = [Math]::Max(0, $Host.UI.RawUI.BufferSize.Width) - $longestLineLength
    }
  }
  
  switch ($textAlign) {
    left {
      $charOffset = 0
    }
    center {
      $charOffset = [Math]::Floor(($longestLineLength - $stringLength) / 2)
    }
    right {
      $charOffset = $longestLineLength - $stringLength
    }
  }

  return $textOffset + $charOffset
  
}

function Write-Host-Ultra-Wrapper { 
  param($Message)
  $longestLineLength = -1
  foreach ($line in $Message -split '\r?\n') {
    if ($line.length -gt $longestLineLength) {
      $longestLineLength = $line.length
    }
  }
  foreach ($line in $Message -split '\r?\n') {
    Write-Host ("{0}{1}" -f (' ' * (Get-Left-Offset $line.Length $longestLineLength)), $line)
  }
}

if ($help) {
  Get-Help Write-FormattedText
  Write-Host @"
  Print text in the center using Write-Host-Center


  text: The text to format (use @""@ for multiline strings)


  align: left | center | right:
  div {
    width: fit-content;
    position: absolute;
    left: 0 | 50% | 100%;
    transform: translateX(0%) | translateX(-50%) | translateX(-100%);
  }


  textalign: left | center | right: 
  div {
    text-align: left | center | right;
   }
   default: align: center; textalign: left;
"@
  exit
}

Write-Host-Ultra-Wrapper $text
