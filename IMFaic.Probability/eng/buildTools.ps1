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

    if (-not (Test-Path $pkgDir)) {
        New-Item $pkgDir -ItemType "Directory" -Force | Out-Null
        Expand-Archive $pkgZip -DestinationPath $pkgDir
    }
}



Write-Verbose "Get Roslyn C# and VB compilers."
getNugetPackage -Name "microsoft.net.compilers.toolset" -Version "3.3.0-beta1-final" -Sha512 "08472200e524952672f8d8ac7969071a1f09c0e2db6eca5b43955178154cb6e4290157a619e20a3cd5b020bb1dfbeaa0d2ff97222c4c3936cd2eb8b5eece0727"

if ($Framework -eq "Core") {
    $tools.roslyn = (Resolve-Path (Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.3.0-beta1-final/tasks/netcoreapp2.1/bincore")).Path
    $tools.csc = [scriptblock]::Create("dotnet $(Join-Path $tools.roslyn "csc.dll") `$args")
    $tools.vbc = [scriptblock]::Create("dotnet $(Join-Path $tools.roslyn "vbc.dll") `$args")
}
elseif ($Framework -eq "Mono") {
    $tools.roslyn = (Resolve-Path (Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.3.0-beta1-final/tasks/net472")).Path
    $tools.csc = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "csc.exe") `$args")
    $tools.csi = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "csi.exe") `$args")
    $tools.vbc = [scriptblock]::Create("mono $(Join-Path $tools.roslyn "vbc.exe") `$args")
}
else {
    $tools.roslyn = (Resolve-Path (Join-Path $OutputDirectory "microsoft.net.compilers.toolset/3.3.0-beta1-final/tasks/net472")).Path
    $tools.csc = [scriptblock]::Create("& $(Join-Path $tools.roslyn "csc.exe") `$args")
    $tools.csi = [scriptblock]::Create("& $(Join-Path $tools.roslyn "csi.exe") `$args")
    $tools.vbc = [scriptblock]::Create("& $(Join-Path $tools.roslyn "vbc.exe") `$args")
}



Write-Verbose "Get .NET Standard reference assemblies."
getNugetPackage -Name "netstandard.library" -Version "2.0.3" -Sha512 "e78f0cea69c14895b1b089644077dbce8631a626055d96522f4d29e061d8bfc3e48aa1419e74faf265b998612c03f721f5f0cef4690f824150a5689764dee601"

$tools.netstandard = (Resolve-Path (Join-Path $OutputDirectory "netstandard.library/2.0.3/build/netstandard2.0/ref")).Path
$tools.net = $tools.netstandard



$tools
