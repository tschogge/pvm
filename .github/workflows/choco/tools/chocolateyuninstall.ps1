$ErrorActionPreference = 'Stop'
$toolName = "pvm"
$userDataPath = [Environment]::GetFolderPath('UserProfile')
$targetPath = "$userDataPath\.$toolName"

if (Test-Path $targetPath) {
    Remove-Item $targetPath -Force -Recurse
    Write-Host "Removed the directory and all its contents from $targetPath"
}

Uninstall-ChocolateyPath -Path "$targetPath\bin" -PathType "Machine"
Write-Host "Removed $targetPath\bin from the system PATH"

if (Test-Path "$targetPath\$toolName.exe") {
  Write-Host "Failed to remove $targetPath\$toolName.exe"
  exit 1
}