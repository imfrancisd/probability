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



Write-Verbose "Download nuget.exe (see https://www.nuget.org/downloads)."

$tools.nuget = Join-Path $OutputDirectory "nuget.exe"

if (-not (Test-Path $tools.nuget) -or (Get-FileHash $tools.nuget -Algorithm SHA256).Hash -ne '1051f2053643a9fb5d8bf9ba7cf638164a3118541e90a671442cf3499c9606ef') {
    Invoke-WebRequest `
    -OutFile $tools.nuget `
    -Uri "https://dist.nuget.org/win-x86-commandline/v4.9.3/nuget.exe"
}

if (-not (Test-Path $tools.nuget) -or (Get-FileHash $tools.nuget -Algorithm SHA256).Hash -ne '1051f2053643a9fb5d8bf9ba7cf638164a3118541e90a671442cf3499c9606ef') {
    throw "Could not download nuget.exe"
}



Write-Verbose "Download compilers (see https://www.nuget.org/packages/Microsoft.Net.Compilers)"

$tools.csc = Join-Path $OutputDirectory "microsoft.net.compilers.2.10.0\tools\csc.exe"
$tools.csi = Join-Path $OutputDirectory "microsoft.net.compilers.2.10.0\tools\csi.exe"
$tools.vbc = Join-Path $OutputDirectory "microsoft.net.compilers.2.10.0\tools\vbc.exe"

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.csi) -and (Test-Path $tools.vbc))) {

    $(Join-Path $outputdirectory "microsoft.net.compilers.2.10.0") |
        Where-Object {Test-Path $_} |
        ForEach-Object {rmdir $_ -Recurse -Force}

    & $tools.nuget install `
    "microsoft.net.compilers" `
    -OutputDirectory $OutputDirectory `
    -Source "https://api.nuget.org/v3/index.json" `
    -Verbosity "$(if ($VerbosePreference -eq "SilentlyContinue") {"quiet"} else {"normal"})" `
    -Version "2.10.0" |
    ForEach-Object {Write-Verbose $_}
}

if (-not ((Test-Path $tools.csc) -and (Test-Path $tools.csi) -and (Test-Path $tools.vbc))) {
    throw "Could not get compilers from https://www.nuget.org/packages/Microsoft.Net.Compilers/2.10.0"
}



 #Return tools in a hashtable containing their full path
 #
 $tools