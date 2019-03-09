#requires -version 5

$ErrorActionPreference = "Stop"



#Get build tools.
#
$tools = & "$PSScriptRoot\buildTools.ps1"



#Create output directory.
#
$binDirEpisode02 = Join-Path $PSScriptRoot "\..\bin\IMFaic.Probability\2.0.1"

if (Test-Path $binDirEpisode02) {
    rmdir -Recurse -Force $binDirEpisode02
}

mkdir $binDirEpisode02



#Compile *.cs files.
#Compile all *.cs files inside
#
#    Probability\
#    IMFaic.Probability\src\
#
#and all of their subfolders.
#
& $tools.csc `
-main:"IMFaic.Probability.Episode02" `
-nologo `
-out:"$(Join-Path $binDirEpisode02 "IMFaic.Probability.exe")" `
-recurse:"$(Join-Path $PSScriptRoot "..\..\Probability\*.cs")" `
-recurse:"$(Join-Path $PSScriptRoot "..\src\*.cs")" `
-target:"exe"
