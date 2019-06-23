#requires -version 5

[cmdletbinding()]
param(
    #Episode to build.
    [parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $false)]
    [string[]]
    $Episode
)

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{"Disabled" = $true}



# Build all episodes if none are specified
#
if (($null) -eq $Episode -or (0 -eq $Episode.Length)) {
    $Episode = @(
        dir (Join-Path $PSScriptRoot "..\src\Episodes") -Filter "IMFaic.Probability.Episode*.cs" |
            ForEach-Object {[System.IO.Path]::GetFileNameWithoutExtension($_.FullName)} |
            ForEach-Object {$_ -replace "IMFaic.Probability.Episode", ""} |
            Sort-Object {$_ -as [double]}, {$_}
    )
}



Write-Verbose "Get build tools."

$tools = & $(Join-Path $PSScriptRoot "buildTools.ps1") $(Join-Path $PSScriptRoot "..\packages")



$libDir = Join-Path $PSScriptRoot "..\obj\lib"

if (Test-Path $libDir) {
    rmdir -Recurse -Force $libDir
}

mkdir $libDir | out-null



Write-Verbose "Compiling Probability.dll"

& $tools.csc `
-deterministic `
-nologo `
-optimize `
-out:"$(Join-Path $libDir "Probability.dll")" `
-recurse:"$(Join-Path $PSScriptRoot "..\..\Probability\*.cs")" `
-recurse:"$(Join-Path $PSScriptRoot "..\prb\*.cs")" `
-target:"library"



Write-Verbose "Compiling IMFaic.Probability.dll"

& $tools.csc `
-deterministic `
-nologo `
-optimize `
-out:"$(Join-Path $libDir "IMFaic.Probability.dll")" `
-recurse:"$(Join-Path $PSScriptRoot "..\src\*.cs")" `
-reference:"$(Join-Path $libDir "Probability.dll")" `
-target:"library"



foreach ($episodeId in $Episode) {

    Write-Verbose "Build Episode$($episodeId)."

    $binDir = Join-Path $PSScriptRoot "..\bin\IMFaic.Probability\$($episodeId).1.0"
    $objDir = Join-Path $PSScriptRoot "..\obj\IMFaic.Probability\$($episodeId).1.0"

    foreach ($directory in @($binDir, $objDir)) {
        if (Test-Path $directory) {
            rmdir -Recurse -Force $directory
        }

        mkdir $directory | out-null
    }

    Copy-Item $(Join-Path $libDir "*.dll") -Destination $binDir

    $programcs = Join-Path $objDir "Program.cs"
    @(
        "public class Program",
        "{",
        "    public static void Main(string[] args)",
        "    {",
        "        IMFaic.Probability.Episode$($episodeId).Run(args);",
        "    }",
        "}"
    ) | Out-File -FilePath $programcs -Encoding utf8 -Force



    Write-Verbose "Compiling IMFaic.Probability.exe"

    & $tools.csc `
    -deterministic `
    -nologo `
    -optimize `
    -out:"$(Join-Path $binDir "Program.exe")" `
    -reference:"$(Join-Path $binDir "IMFaic.Probability.dll")" `
    -target:"exe" `
    $programcs

    Move-Item $(Join-Path $binDir "Program.exe") $(Join-Path $binDir "IMFaic.Probability.exe")

    if ($episodeId -eq "25") {
        Copy-Item (Join-Path $PSScriptRoot "..\src\Episodes\shakespeare.txt") -Destination $binDir
    }
}
