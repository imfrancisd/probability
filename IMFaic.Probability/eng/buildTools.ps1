#requires -version 5

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $false)]
    [string]
    $OutputDirectory,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $false)]
    [ValidateSet("Core", "Mono", "Net")]
    [string]
    $Framework = "Net"
)

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{"Disabled" = $true}



#Uncomment to clear cached downloads.
#if (Test-Path $OutputDirectory) {Remove-Item $OutputDirectory -Recurse -Force}



if (-not (Test-Path $OutputDirectory)) {
    New-Item $OutputDirectory -ItemType "Directory" -Force | Out-Null
}

$tools = @{}



function getNugetPackage
{
    [CmdletBinding()]
    param(
        [string]
        $Name,
        
        [string]
        $Version,
        
        [string]
        $Sha512
    )

    Write-Verbose "Get package `"$($Name)`" version `"$($Version)`" from `"https://www.nuget.org/`"."

    $pkgUri = "https://www.nuget.org/api/v2/package/$($Name)/$($Version)"
    $pkgDir = Join-Path $OutputDirectory "$($Name)/$($Version)"
    $pkgZip = Join-Path $OutputDirectory "$($Name).$($Version).nupkg.zip"

    if (-not (Test-Path $pkgZip) -or ($Sha512 -ne (Get-FileHash $pkgZip -Algorithm "SHA512").Hash)) {
        Invoke-WebRequest $pkgUri -OutFile $pkgZip
    }

    if ($Sha512 -ne (Get-FileHash $pkgZip -Algorithm "SHA512").Hash) {
        throw "Could not get package `"$($Name)`" version `"$($Version)`" (downloaded file does not have the expected sha512 sum)."
    }

    if (Test-Path $pkgDir) {
        Remove-Item $pkgDir -Recurse -Force
    }

    New-Item $pkgDir -ItemType "Directory" -Force | Out-Null
    Expand-Archive $pkgZip -DestinationPath $pkgDir
}



Write-Verbose "Get Roslyn C# and VB compilers."
getNugetPackage -Name "microsoft.net.compilers.toolset" -Version "3.2.0-beta3-final" -Sha512 "5dc70327f192c76a40d65e68e95cc0057fcc29a3817c939c38118584295c0f3a1120ef0ee12873265721348dfd4aecaa7ea0e72968aaa1f09dde15f9dd11da92"

if ($Framework -eq "Core") {
    $tools.roslyn = Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.2.0-beta3-final/tasks/netcoreapp2.1/bincore"
    $tools.csc = [scriptblock]::Create("dotnet $(Join-Path $tools.roslyn "csc.dll") `$args")
    $tools.vbc = [scriptblock]::Create("dotnet $(Join-Path $tools.roslyn "vbc.dll") `$args")
}
elseif ($Framework -eq "Mono") {
    $tools.roslyn = Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.2.0-beta3-final/tasks/net472"
    $tools.csc = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "csc.exe") `$args")
    $tools.csi = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "csi.exe") `$args")
    $tools.vbc = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "vbc.exe") `$args")
}
else {
    $tools.roslyn = Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.2.0-beta3-final/tasks/net472"
    $tools.csc = [scriptblock]::Create("& $(Join-Path $tools.roslyn "csc.exe") `$args")
    $tools.csi = [scriptblock]::Create("& $(Join-Path $tools.roslyn "csi.exe") `$args")
    $tools.vbc = [scriptblock]::Create("& $(Join-Path $tools.roslyn "vbc.exe") `$args")
}



Write-Verbose "Get .NET Standard reference assemblies."
getNugetPackage -Name "netstandard.library" -Version "2.0.3" -Sha512 "e78f0cea69c14895b1b089644077dbce8631a626055d96522f4d29e061d8bfc3e48aa1419e74faf265b998612c03f721f5f0cef4690f824150a5689764dee601"

$tools.netstandard = Join-Path $OutputDirectory "netstandard.library/2.0.3/build/netstandard2.0/ref"
$tools.net = $tools.netstandard



$tools
