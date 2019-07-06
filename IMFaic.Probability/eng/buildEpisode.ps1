#requires -version 5

[CmdletBinding()]
param(
    #Episode to build.
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $false)]
    [string[]]
    $Episode,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $false)]
    [ValidateSet("Core", "Mono", "Net")]
    [string]
    $Framework = "Net"
)

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{"Disabled" = $true}



# Build all episodes if none are specified
#
if (($null) -eq $Episode -or (0 -eq $Episode.Length)) {
    $Episode = @(
        Get-ChildItem (Join-Path $PSScriptRoot "../src/Episodes") -Filter "IMFaic.Probability.Episode*.cs" |
            ForEach-Object {[System.IO.Path]::GetFileNameWithoutExtension($_.FullName)} |
            ForEach-Object {$_ -replace "IMFaic.Probability.Episode", ""} |
            Sort-Object {$_ -as [decimal]}, {$_}
    )
}



Write-Verbose "Get build tools."

$tools = & $(Join-Path $PSScriptRoot "buildTools.ps1") $(Join-Path $PSScriptRoot "../packages") -Framework $Framework



$objLibNetstandardDir = Join-Path $PSScriptRoot "../obj/lib/netstandard2.0"

if (Test-Path $objLibNetstandardDir) {
    Remove-Item $objLibNetstandardDir -Recurse -Force
}

New-Item $objLibNetstandardDir -ItemType "Directory" | Out-Null



Write-Verbose "Compiling Probability.dll"

$compilerArgs = @(&{
    "-deterministic"
    "-noconfig"
    "-nologo"
    "-nostdlib"
    "-optimize"
    "-out:$(Join-Path $objLibNetstandardDir "Probability.dll")"
    "-recurse:$(Join-Path $PSScriptRoot "../../Probability/*.cs")"
    "-recurse:$(Join-Path $PSScriptRoot "../prb/*.cs")"
    "-reference:$(Join-Path $tools.net "netstandard.dll")"
    "-target:library"
})
& $tools.csc @compilerArgs



Write-Verbose "Compiling IMFaic.Probability.dll"

$compilerArgs = @(&{
    "-deterministic"
    "-noconfig"
    "-nologo"
    "-nostdlib"
    "-optimize"
    "-out:$(Join-Path $objLibNetstandardDir "IMFaic.Probability.dll")"
    "-recurse:$(Join-Path $PSScriptRoot "../src/*.cs")"
    "-reference:$(Join-Path $objLibNetstandardDir "Probability.dll")"
    "-reference:$(Join-Path $tools.net "netstandard.dll")"
    "-target:library"
})
& $tools.csc @compilerArgs



foreach ($episodeId in $Episode) {

    Write-Verbose "Build Episode$($episodeId)."

    $pkgLibNetstandardDir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).1.0/lib/netstandard2.0"
    $pkgToolsNetstandardDir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).1.0/tools/netstandard2.0"
    $pkgToolsNetcoreappDir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).1.0/tools/netcoreapp2.1"

    foreach ($directory in @($pkgToolsNetcoreappDir, $pkgToolsNetstandardDir, $pkgLibNetstandardDir)) {
        if (Test-Path $directory) {
            Remove-Item $directory -Recurse -Force
        }

        New-Item $directory -ItemType "Directory" | Out-Null
    }

    Copy-Item $(Join-Path $objLibNetstandardDir "*.dll") -Destination $pkgLibNetstandardDir
    Copy-Item $(Join-Path $objLibNetstandardDir "*.dll") -Destination $pkgToolsNetstandardDir
    Copy-Item $(Join-Path $PSScriptRoot "*.json") -Destination $pkgToolsNetcoreappDir



    Write-Verbose "Compiling netstandard IMFaic.Probability.exe"

    $programcs = Join-Path $pkgToolsNetstandardDir "Program.cs"
    @(
        "public class Program",
        "{",
        "    public static void Main(string[] args)",
        "    {",
        "        IMFaic.Probability.Episode$($episodeId).Run(args);",
        "    }",
        "}"
    ) | Out-File -FilePath $programcs -Encoding utf8 -Force

    $compilerArgs = @(&{
        "-deterministic"
        "-noconfig"
        "-nologo"
        "-nostdlib"
        "-optimize"
        "-out:$(Join-Path $pkgToolsNetstandardDir "Program.exe")"
        "-reference:$(Join-Path $pkgToolsNetstandardDir "IMFaic.Probability.dll")"
        "-reference:$(Join-Path $tools.net "netstandard.dll")"
        "-target:exe"
        $programcs
    })
    & $tools.csc @compilerArgs

    Move-Item $(Join-Path $pkgToolsNetstandardDir "Program.exe") $(Join-Path $pkgToolsNetstandardDir "IMFaic.Probability.exe")

    Remove-Item $programcs -Force



    Write-Verbose "Compiling netcoreapp Program.dll"

    $programcs = Join-Path $pkgToolsNetcoreappDir "Program.cs"
    @(
        "public class Program",
        "{",
        "    public static void Main(string[] args)",
        "    {",
        "        System.Console.WriteLine(`"Hello World!`");",
        "    }",
        "}"
    ) | Out-File -FilePath $programcs -Encoding utf8 -Force

    $compilerArgs = @(&{
        "-deterministic"
        "-noconfig"
        "-nologo"
        "-nostdlib"
        "-optimize"
        "-out:$(Join-Path $pkgToolsNetcoreappDir "Program.exe")"
        "-reference:$(Join-Path $tools.net "netstandard.dll")"
        "-target:exe"
        $programcs
    })
    & $tools.csc @compilerArgs

    Move-Item $(Join-Path $pkgToolsNetcoreappDir "Program.exe") $(Join-Path $pkgToolsNetcoreappDir "Program.dll")

    Remove-Item $programcs -Force



    if ($episodeId -eq "25") {
        Copy-Item (Join-Path $PSScriptRoot "../src/Episodes/shakespeare.txt") -Destination $pkgToolsNetstandardDir
        Copy-Item (Join-Path $PSScriptRoot "../src/Episodes/shakespeare.txt") -Destination $pkgToolsNetcoreappDir
    }
}
