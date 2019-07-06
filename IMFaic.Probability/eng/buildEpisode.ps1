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

foreach ($directory in @($objLibNetstandardDir)) {
    if (Test-Path $directory) {
        Remove-Item $directory -Recurse -Force
    }

    New-Item $directory -ItemType "Directory" | Out-Null
}



Write-Verbose "Compiling Probability.dll"

$compilerArgs = @(&{
    "-debug:pdbonly"
    "-deterministic"
    "-noconfig"
    "-nologo"
    "-nostdlib"
    "-optimize"
    "-out:$(Join-Path $objLibNetstandardDir "Probability.dll")"
    "-pdb:$(Join-Path $objLibNetstandardDir "Probability.pdb")"
    "-recurse:$(Join-Path $PSScriptRoot "../../Probability/*.cs")"
    "-recurse:$(Join-Path $PSScriptRoot "../prb/*.cs")"
    "-reference:$(Join-Path $tools.net "netstandard.dll")"
    "-target:library"
})
& $tools.csc @compilerArgs



Write-Verbose "Compiling IMFaic.Probability.dll"

$compilerArgs = @(&{
    "-debug:pdbonly"
    "-deterministic"
    "-noconfig"
    "-nologo"
    "-nostdlib"
    "-optimize"
    "-out:$(Join-Path $objLibNetstandardDir "IMFaic.Probability.dll")"
    "-pdb:$(Join-Path $objLibNetstandardDir "IMFaic.Probability.pdb")"
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
    $pkgToolsNetcoreappDir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).1.0/tools/netcoreapp2.0"

    foreach ($directory in @($pkgLibNetstandardDir, $pkgToolsNetstandardDir, $pkgToolsNetcoreappDir)) {
        if (Test-Path $directory) {
            Remove-Item $directory -Recurse -Force
        }

        New-Item $directory -ItemType "Directory" | Out-Null
    }



    Write-Verbose "Compiling $($pkgToolsNetstandardDir)."

    Copy-Item $(Join-Path $objLibNetstandardDir "*") -Destination $pkgLibNetstandardDir
    Copy-Item $(Join-Path $objLibNetstandardDir "*") -Destination $pkgToolsNetstandardDir

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

    #Rename Program.exe to IMFaic.Probability.exe instead of compiling as IMFaic.Probability.exe
    #to avoid TypeLoadException and MissingMethodException at runtime.
    Move-Item $(Join-Path $pkgToolsNetstandardDir "Program.exe") $(Join-Path $pkgToolsNetstandardDir "IMFaic.Probability.exe")

    if ($episodeId -eq "25") {
        Copy-Item (Join-Path $PSScriptRoot "../src/Episodes/shakespeare.txt") -Destination $pkgToolsNetstandardDir
    }

    Remove-Item $programcs -Force



    Write-Verbose "Compiling $($pkgToolsNetcoreappDir)."
    Copy-Item $(Join-Path $pkgToolsNetstandardDir "*") -Destination $pkgToolsNetcoreappDir -Recurse
    Move-Item $(Join-Path $pkgToolsNetcoreappDir "IMFaic.Probability.exe") -Destination $(Join-Path $pkgToolsNetcoreappDir "IMFaic.Probability.exe.dll")

    @(
        "{",
        "  `"runtimeOptions`": {",
        "    `"framework`": {",
        "      `"name`": `"Microsoft.NETCore.App`",",
        "      `"version`": `"2.0.0`"",
        "    }",
        "  }",
        "}"
    ) | Out-File -FilePath (Join-Path $pkgToolsNetcoreappDir "IMFaic.Probability.exe.runtimeconfig.json") -Encoding ascii -Force

    @(
        "{"
        "  `"runtimeTarget`": {"
        "    `"name`": `".NETCoreApp,Version=v2.0`""
        "  },"
        "  `"targets`": {"
        "    `".NETCoreApp,Version=v2.0`": {"
        "      `"IMFaic.Probability.exe`": {"
        "        `"runtime`": {"
        "          `"IMFaic.Probability.exe.dll`": {}"
        "        }"
        "      },"
        "      `"Probability`": {"
        "        `"runtime`": {"
        "          `"Probability.dll`": {}"
        "        }"
        "      },"
        "      `"IMFaic.Probability`": {"
        "        `"runtime`": {"
        "          `"IMFaic.Probability.dll`": {}"
        "        }"
        "      }"
        "    }"
        "  },"
        "  `"libraries`": {"
        "    `"IMFaic.Probability.exe`": {"
        "      `"type`": `"project`","
        "      `"serviceable`": false,"
        "      `"sha512`": `"`""
        "    },"
        "    `"Probability`": {"
        "      `"type`": `"project`","
        "      `"serviceable`": false,"
        "      `"sha512`": `"`""
        "    },"
        "    `"IMFaic.Probability`": {"
        "      `"type`": `"project`","
        "      `"serviceable`": false,"
        "      `"sha512`": `"`""
        "    }"
        "  }"
        "}"
    ) | Out-File -FilePath (Join-Path $pkgToolsNetcoreappDir "IMFaic.Probability.exe.deps.json") -Encoding ascii -Force
}
