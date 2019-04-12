#requires -version 5

[cmdletbinding()]
param(
    [parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $false)]
    [string]
    $OutputDirectory
)

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{'Disabled' = $true}
$tools = @{}



#Create packages directory
#
if (-not (Test-Path $OutputDirectory)) {
    mkdir $OutputDirectory
}



Write-Verbose "Get nuget.exe (see https://www.nuget.org/downloads)."

$tools.nuget = Join-Path $OutputDirectory "nuget.exe"
$nugetSha256 = "CB139D855D06D07E7DA892E8558FE16DCAA65CB381175C506F5ED0A759EAF8F6"

if (-not (Test-Path $tools.nuget) -or (Get-FileHash $tools.nuget -Algorithm SHA256).Hash -ne $nugetSha256) {
    Invoke-WebRequest `
    -OutFile $tools.nuget `
    -Uri "https://dist.nuget.org/win-x86-commandline/v4.9.4/nuget.exe"
}

if (-not (Test-Path $tools.nuget) -or (Get-FileHash $tools.nuget -Algorithm SHA256).Hash -ne $nugetSha256) {
    throw "Could not get nuget.exe"
}



Write-Verbose "Get compilers (see https://www.nuget.org/packages/microsoft.net.compilers.toolset)."

$pkgName = "microsoft.net.compilers.toolset"
$pkgVersion ="3.1.0-beta1-final"

$tools.csc = Join-Path $OutputDirectory "$pkgName.$pkgVersion\tasks\net472\csc.exe"
$tools.csi = Join-Path $OutputDirectory "$pkgName.$pkgVersion\tasks\net472\csi.exe"
$tools.vbc = Join-Path $OutputDirectory "$pkgName.$pkgVersion\tasks\net472\vbc.exe"

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.csi) -and (Test-Path $tools.vbc))) {

    $(Join-Path $OutputDirectory "$pkgName.$pkgVersion") |
        Where-Object {Test-Path $_} |
        ForEach-Object {rmdir $_ -Recurse -Force}

    & $tools.nuget install `
    $pkgName `
    -OutputDirectory $OutputDirectory `
    -Source "https://api.nuget.org/v3/index.json" `
    -Verbosity "$(if ($VerbosePreference -eq "SilentlyContinue") {"quiet"} else {"normal"})" `
    -Version $pkgVersion |
    ForEach-Object {Write-Verbose $_}
}

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.csi) -and (Test-Path $tools.vbc))) {
    throw "Could not get compilers (nuget package $pkgName)"
}



 #Return tools in a hashtable containing their full path
 #
 $tools
