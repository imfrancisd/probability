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



$libDir = Join-Path $PSScriptRoot "../obj/lib"

if (Test-Path $libDir) {
    Remove-Item $libDir -Recurse -Force
}

New-Item $libDir -ItemType "Directory" | Out-Null



Write-Verbose "Compiling Probability.dll"

$compilerArgs = @(&{
    "-deterministic"
    "-noconfig"
    "-nologo"
    "-nostdlib"
    "-optimize"
    "-out:$(Join-Path $libDir "Probability.dll")"
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
    "-out:$(Join-Path $libDir "IMFaic.Probability.dll")"
    "-recurse:$(Join-Path $PSScriptRoot "../src/*.cs")"
    "-reference:$(Join-Path $libDir "Probability.dll")"
    "-reference:$(Join-Path $tools.net "netstandard.dll")"
    "-target:library"
})
& $tools.csc @compilerArgs



foreach ($episodeId in $Episode) {

    Write-Verbose "Build Episode$($episodeId)."

    $binDir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).1.0"
    $objDir = Join-Path $PSScriptRoot "../obj/IMFaic.Probability/$($episodeId).1.0"

    foreach ($directory in @($binDir, $objDir)) {
        if (Test-Path $directory) {
            Remove-Item $directory -Recurse -Force
        }

        New-Item $directory -ItemType "Directory" | Out-Null
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

    $compilerArgs = @(&{
        "-deterministic"
        "-noconfig"
        "-nologo"
        "-nostdlib"
        "-optimize"
        "-out:$(Join-Path $binDir "Program.$(if ($framework -eq "Core") {"dll"} else {"exe"})")"
        "-reference:$(Join-Path $binDir "IMFaic.Probability.dll")"
        "-reference:$(Join-Path $tools.net "netstandard.dll")"
        "-target:$(if ($Framework -eq "Core") {"library"} else {"exe"})"
        $programcs
    })
    & $tools.csc @compilerArgs

    if ($framework -ne "Core") {
        Move-Item $(Join-Path $binDir "Program.exe") $(Join-Path $binDir "IMFaic.Probability.exe")
    }

    if ($episodeId -eq "25") {
        Copy-Item (Join-Path $PSScriptRoot "../src/Episodes/shakespeare.txt") -Destination $binDir
    }
}
