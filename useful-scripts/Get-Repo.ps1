<#
.SYNOPSIS
This script downloads a GitHub repository as a zipball archive and extracts it to a specified destination folder while excluding specific files and folders.

.DESCRIPTION
This script takes a GitHub repository URL, a branch name, a list of files/folders to exclude, and a destination folder as input parameters. It then checks the validity of the URL, downloads the repository as a zipball archive, and extracts it to the destination folder. It excludes files and folders specified in the 'toExclude' parameter. The script ensures that the destination folder is empty before proceeding.

.PARAMETER githubRepoURL
The URL of the GitHub repository to download. It should be in the format 'https://github.com/owner/repository'.

.PARAMETER branch
The name of the branch to download from the GitHub repository.

.PARAMETER toExclude
An array of file/folder names to exclude from the extracted content.

.PARAMETER destinationFolder
The folder where the repository will be extracted.

.EXAMPLE
Get-Repo.ps1 -githubRepoURL "https://github.com/example/repo" -branch "main" -toExclude @("config.ini", "docs") -destinationFolder "C:\Projects\MyRepo"

This example downloads the 'main' branch of the 'example/repo' repository, excludes 'config.ini' and 'docs', and extracts it to 'C:\Projects\MyRepo'.

.EXAMPLE
Get-Repo.ps1 -githubRepoURL "https://github.com/chakri68/webpack-babel-template" -branch "with-typescript" -destinationFolder "./webpack-template"

.NOTES
File Name      : Get-Repo.ps1
Author         : chakri68
#>

param(
  [string]$githubRepoURL,
  [string]$branch,
  [string[]]$toExclude,
  [string]$destinationFolder
)

# Function to write colored text
function Write-ColoredText {
  param(
    [string]$text,
    [System.ConsoleColor]$color
  )

  $originalColor = $Host.UI.RawUI.ForegroundColor
  $Host.UI.RawUI.ForegroundColor = $color
  Write-Host $text
  $Host.UI.RawUI.ForegroundColor = $originalColor
}

# Remove trailing slashes from the GitHub repository URL, if any
$githubRepoURL = $githubRepoURL.TrimEnd('/')

# Check if the URL is in the expected format
if ($githubRepoURL -notmatch '^https://github.com/\S+/\S+$') {
  Write-ColoredText "ERROR: Invalid GitHub repository URL format. Please provide a valid URL in the format 'https://github.com/owner/repository'." Red
  exit
}

# Generate the URL for the zipball archive
$zipballURL = "$githubRepoURL/zipball/$branch"

# Create the destination folder if it doesn't exist
if (-not (Test-Path -Path $destinationFolder)) {
  New-Item -ItemType Directory -Force -Path $destinationFolder
  Write-ColoredText "Created destination folder: $destinationFolder" Green
}

# Check if the destination folder is empty
if ((Get-ChildItem -Path $destinationFolder | Measure-Object).Count -gt 0) {
  Write-ColoredText "ERROR: Destination folder is not empty. Aborting. Please choose an empty destination folder or provide a different folder." Red
  exit
}

try {
  # Downloading the zipball archive
  Write-ColoredText "Downloading the GitHub repository as a zipball archive..." Yellow
  Invoke-WebRequest -Uri $zipballURL -OutFile "githubrepo.zip" -ErrorAction Stop
  Write-ColoredText "Download completed." Green

  # Extracting the zip archive into a temporary folder
  $extractedTempFolder = Join-Path -Path $env:TEMP -ChildPath "githubrepo_temp"
  Expand-Archive -Path "githubrepo.zip" -DestinationPath $extractedTempFolder
  Write-ColoredText "Extracted zip archive to temporary folder." Green

  # Get the root folder name created by GitHub (usually contains a hash)
  $rootFolderName = (Get-ChildItem -Path $extractedTempFolder | Select-Object -First 1).Name

  # Move the contents of the root folder to the destination folder, excluding specified files and folders
  $sourcePath = Join-Path -Path $extractedTempFolder -ChildPath $rootFolderName
  $destinationPath = $destinationFolder

  Write-ColoredText "Moving files and folders to the destination folder..." Yellow
  $totalFilesCount = 0
  $totalSize = 0
  Get-ChildItem -Path $sourcePath | ForEach-Object {
    $item = $_
    $itemName = $item.Name

    # Check if the item should be excluded
    if ($itemName -in $toExclude) {
      Write-ColoredText "Excluding: $itemName" Yellow
    }
    else {
      Move-Item -Path $item.FullName -Destination $destinationPath -Force
      $totalFilesCount++
      $totalSize += $item.Length
    }
  }

  # Remove the temporary folder
  Remove-Item -Path $extractedTempFolder -Recurse -Force
  Write-ColoredText "Removed temporary folder." Green

  # Remove the downloaded zip archive
  Remove-Item -Path "githubrepo.zip" -Force
  Write-ColoredText "Removed downloaded zip archive." Green

  # Display completion message
  Write-ColoredText "GitHub repository extraction completed successfully." Green
  Write-ColoredText "Total files extracted: $totalFilesCount" Green
  Write-ColoredText "Total size: $totalSize bytes" Green
}
catch {
  # Handle errors
  Write-ColoredText "ERROR: An error occurred: $_" Red
  Write-ColoredText "GitHub repository extraction failed." Red
}
