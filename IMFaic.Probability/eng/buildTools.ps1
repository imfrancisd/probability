#requires -version 5

$ErrorActionPreference = "Stop"



#Create packages directory
#
$pkgDir = Join-Path $PSScriptRoot "..\packages"

if (-not (Test-Path $pkgDir)) {
    mkdir $pkgDir
}



#Download nuget.exe
#Download links can be found at https://www.nuget.org/downloads
#
$nuget = Join-Path $pkgDir "nuget.exe"

if (-not (Test-Path $nuget)) {
    Invoke-WebRequest `
    -OutFile $nuget `
    -Uri "https://dist.nuget.org/win-x86-commandline/v4.9.3/nuget.exe" `
    -Verbose

    if (-not (Test-Path $nuget)) {
        throw "Could not get nuget.exe from https://dist.nuget.org/win-x86-commandline/v4.9.3/nuget.exe"
    }
}



#Download csc.exe
#Download links can be found at https://www.nuget.org/packages/Microsoft.Net.Compilers
#
$csc = Join-Path $pkgDir "microsoft.net.compilers.2.10.0\tools\csc.exe"
$csi = Join-Path $pkgDir "microsoft.net.compilers.2.10.0\tools\csi.exe"
$vbc = Join-Path $pkgDir "microsoft.net.compilers.2.10.0\tools\vbc.exe"

if (-not (Test-Path $csc)) {
    & $nuget install `
    "microsoft.net.compilers" `
    -OutputDirectory $pkgDir `
    -Source "https://api.nuget.org/v3/index.json" `
    -Verbosity "normal" `
    -Version "2.10.0"

    if (-not (Test-Path $csc)) {
        throw "Could not get csc.exe from https://www.nuget.org/packages/Microsoft.Net.Compilers/2.10.0"
    }
}



#Return tools in a hashtable containing their full path
#
@{
    "nuget" = $nuget
    "csc" = $csc
    "csi" = $csi
    "vbc" = $vbc
}
