<#
.SYNOPSIS
This script reads quotes from a JSON file and displays a random quote with a customizable greeting text.

.DESCRIPTION
This PowerShell script reads quotes from a JSON file and displays a random quote. The JSON file should contain an array of objects, each having 'text' and 'author' properties.

.PARAMETER jsonFilePath
The path to the JSON file containing the quotes. If not provided, the script will attempt to locate a file named "quotes.json" in the current directory.

.NOTES
File Name      : Display-Quote.ps1
Prerequisite   : PowerShell 5.1 or later
Copyright 2023 - chakri68
Version        : 1.0

.EXAMPLE
Display-Quote.ps1 -jsonFilePath "C:\Path\to\quotes.json" -greetingText "Hello!"
This example runs the script with a specific JSON file and greeting text.

.EXAMPLE
Display-Quote.ps1
This example runs the script with the default JSON file name ("quotes.json") and the default greeting text ("Hola!").

#>

param (
  [string]$jsonFilePath = ""
)

if ($jsonFilePath -eq "") {
  $jsonFilePath = where.exe "quotes.json"
}

function Read-QuotesFromFile {
  try {
    if (Test-Path $jsonFilePath) {
      $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json
      if ($jsonContent -is [System.Array]) {
        return $jsonContent | Where-Object { $_.text -and $_.author }
      }
      else {
        throw "Invalid JSON format: The JSON file should contain an array of objects with 'text' and 'author' properties."
      }
    }
    else {
      throw "The JSON file does not exist at path: $jsonFilePath"
    }
  }
  catch {
    Write-Host "Error: $_"
    exit 1
  }
}

function Get-RandomQuote {
  $quotes = Read-QuotesFromFile
  if ($quotes.Count -gt 0) {
    return $quotes | Get-Random
  }
  else {
    throw "No valid quotes found in the JSON file."
  }
}

function Display-Quote {
  $quoteData = Get-RandomQuote

  Write-Host
  Write-Host
  Write-FormattedText -text $quoteData.text -align center
  Write-Host
  Write-FormattedText -text "~ $($quoteData.author)" -align right
  Write-Host
}

Display-Quote
