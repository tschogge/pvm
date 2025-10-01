$ErrorActionPreference = 'Stop'
$toolName = 'pvm'
$userDataPath = [Environment]::GetFolderPath('UserProfile')
$targetPath = "$userDataPath\.$toolName\bin"
$url64 = 'https://github.com/hjbdev/pvm/releases/download/1.2.0/pvm.exe'
$checksum64 = 'A764F8C2EE58EE4A5B026EEEDEFC044F1C4E3802CA96E4E8D00AF3E6504E831F'


if (!(Test-Path $targetPath)) {
  New-Item -ItemType Directory -Path $targetPath -Force
  Write-Host "Created directory $targetPath"
}

Install-ChocolateyPath -Path $targetPath -PathType 'Machine'
Write-Host "Added $targetPath to the system PATH"

$tempFile = "$env:TEMP\pvm.exe"
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64bit       = $url64
  softwareName   = "$toolName*"
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  file           = $tempFile
}

Get-ChocolateyWebFile @packageArgs

Copy-Item -Path $tempFile -Destination "$targetPath\$toolName.exe" -Force
Write-Host "Copied $toolName.exe to $targetPath"

if (!(Test-Path "$targetPath\$toolName.exe")) {
    Write-Error "Failed to copy pvm.exe to $targetPath"
    exit 1
}