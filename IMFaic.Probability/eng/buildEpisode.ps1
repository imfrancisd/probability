#requires -version 5

[cmdletbinding()]
param(
    #Episode to build.
    [parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $false)]
    [string[]]
    $Episode
)

$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{'Disabled' = $true}



# Build all episodes if none are specified
#
if (($null) -eq $Episode -or (0 -eq $Episode.Length)) {
    $Episode = @(
        dir (Join-Path $PSScriptRoot "..\src\Episodes") -Filter IMFaic.Probability.Episode*.cs |
            ForEach-Object {[System.IO.Path]::GetFileNameWithoutExtension($_.fullname)} |
            ForEach-Object {$_ -replace "IMFaic.Probability.Episode", ""}
    )
}



Write-Verbose "Get build tools."

$tools = & $(Join-Path $PSScriptRoot "buildTools.ps1") $(Join-Path $PSScriptRoot "..\packages")



foreach ($episodeNumber in $Episode) {

    Write-Verbose "Build Episode$episodeNumber."

    $binDir = Join-Path $PSScriptRoot "..\bin\IMFaic.Probability\$episodeNumber.1.0"
    $objDir = Join-Path $PSScriptRoot "..\obj\IMFaic.Probability\$episodeNumber.1.0"

    foreach ($directory in @($binDir, $objDir)) {
        if (Test-Path $directory) {
            rmdir -Recurse -Force $directory
        }

        mkdir $directory | out-null
    }



    Write-Verbose "Compiling Probability.dll"

    & $tools.csc `
    -nologo `
    -out:"$(Join-Path $binDir "Probability.dll")" `
    -recurse:"$(Join-Path $PSScriptRoot "..\..\Probability\*.cs")" `
    -recurse:"$(Join-Path $PSScriptRoot "..\prb\*.cs")" `
    -target:"library"



    Write-Verbose "Compiling IMFaic.Probability.dll"

    & $tools.csc `
    -nologo `
    -out:"$(Join-Path $binDir "IMFaic.Probability.dll")" `
    -recurse:"$(Join-Path $PSScriptRoot "..\src\*.cs")" `
    -reference:"$(Join-Path $binDir "Probability.dll")" `
    -target:"library"



    Write-Verbose "Generating Source."

    $programcs = Join-Path $objDir "Program.cs"
    @(
        "public class Program",
        "{",
        "    public static void Main(string[] args)",
        "    {",
        "        IMFaic.Probability.Episode$episodeNumber.Run(args);",
        "    }",
        "}"
    ) | Out-File -FilePath $programcs -Encoding utf8 -Force



    Write-Verbose "Compiling IMFaic.Probability.exe"

    & $tools.csc `
    -nologo `
    -out:"$(Join-Path $binDir "Program.exe")" `
    -reference:"$(Join-Path $binDir "IMFaic.Probability.dll")" `
    -target:"exe" `
    $programcs

    Move-Item $(Join-Path $binDir "Program.exe") $(Join-Path $binDir "IMFaic.Probability.exe")

    if ($episodeNumber -eq "25") {
        Copy-Item (Join-Path $PSScriptRoot "..\src\Episodes\shakespeare.txt") -Destination $binDir
    }
}
