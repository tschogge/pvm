Import-Module Chocolatey-AU

Write-Host "Current directory: $(Get-Location)"
Write-Host "Files in directory: $(Get-ChildItem)"
Write-Host "Nuspec file exists: $(Test-Path .\php-pvm.nuspec)"

function global:au_BeforeUpdate {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

function global:au_GetLatest {
    $latestRelease = Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/hjbdev/pvm/releases/latest'
    
    return @{
        URL64          = $latestRelease.assets.browser_download_url
        Version        = $latestRelease.tag_name
        ChecksumType64 = 'sha256'
        Description    = 'A PHP version manager to simply install different PHP versions and easily switch between them. Similar to nvm. Use pvm in the terminal after installation to get started. Repo: https://github.com/hjbdev/pvm'
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }

        ".\php-pvm.nuspec"                = @{
            "(\<version\>).*?(\</version\>)" = "`${1}$($Latest.Version)`$2"
        }

    }
}

function global:au_AfterUpdate ($Package) {
    choco push $Package.NuspecPath --api-key=$Env:CHOCO_API_KEY
}

update -ChecksumFor none -NoReadme