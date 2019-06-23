#requires -version 5

[Cmdletbinding()]
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
$tools = @{}



#Create packages directory
#
if (-not (Test-Path $OutputDirectory)) {
    New-Item $OutputDirectory -ItemType "Directory" -Force | Out-Null
}



Write-Verbose "Get compilers (see https://www.nuget.org/packages/microsoft.net.compilers.toolset)."

$pkgName = "microsoft.net.compilers.toolset"
$pkgVersion = "3.1.0"
$pkgUri = "https://www.nuget.org/packages/$($pkgName)/$($pkgVersion)"
$pkgDir = Join-Path $OutputDirectory "$($pkgName)/$($pkgVersion)"
$pkgZip = Join-Path $OutputDirectory "$($pkgName).$($pkgVersion).nupkg.zip"
$pkgZipSha512 = "80031aac4e6174a978135cc89030f59a914618e75053c48893087809311106747e4eb6921c62ae093e0c12603851a72a4e59277c7f3c956c314c7cfc7b66c762"

$tools.csc = Join-Path $pkgDir "tasks/$(if ($Framework -eq "Core") {"netcoreapp2.1/bincore/"} else {"net472"})/csc.$(if ($Framework -eq "Core") {"dll"} else {"exe"})"
$tools.vbc = Join-Path $pkgDir "tasks/$(if ($Framework -eq "Core") {"netcoreapp2.1/bincore/"} else {"net472"})/vbc.$(if ($Framework -eq "Core") {"dll"} else {"exe"})"

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.vbc))) {
    Invoke-WebRequest $pkgUri -OutFile $pkgZip
    if ($pkgZipSha512 -ne (Get-FileHash $pkgZip -Algorithm SHA512).Hash) {
        throw "Could not get compilers (nuget package $($pkgName).$($pkgVersion).nupkg.zip does not have expected sha512 sum)."
    }

    if (Test-Path $pkgDir) {
        Remove-Item $pkgDir -Recurse -Force
    }
    New-Item $pkgDir -ItemType "Directory" -Force | Out-Null
    Expand-Archive $pkgZip -DestinationPath $pkgDir
}

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.vbc))) {
    throw "Could not get compilers (nuget package $($pkgName).$($pkgVersion).nupkg.zip does not have expected folder structure)."
}



#Return tools in a hashtable containing script blocks that will invoke those tools.
#
$runner = if ($Framework -eq "Mono") {"mono"} elseif ($Framework -eq "Core") {"dotnet"} else {"&"}
foreach ($key in @($tools.Keys)) {
    $tools[$key] = [scriptblock]::Create("$($runner) $($tools[$key]) `$args")
}
$tools
