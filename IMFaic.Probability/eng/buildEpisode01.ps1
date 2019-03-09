#requires -version 5

$ErrorActionPreference = "Stop"



#Get build tools.
#
$tools = & "$PSScriptRoot\buildTools.ps1"



#Create output directory.
#
$binDirEpisode01 = Join-Path $PSScriptRoot "\..\bin\IMFaic.Probability\1.0.0"

if (Test-Path $binDirEpisode01) {
    rmdir -Recurse -Force $binDirEpisode01
}

mkdir $binDirEpisode01



#Compile *.cs files.
#Compile all *.cs files inside
#
#    Probability\
#    IMFaic.Probability\src\
#
#and all of their subfolders.
#
& $tools.csc `
-main:"IMFaic.Probability.Episode01" `
-nologo `
-out:"$(Join-Path $binDirEpisode01 "IMFaic.Probability.exe")" `
-recurse:"$(Join-Path $PSScriptRoot "..\..\Probability\*.cs")" `
-recurse:"$(Join-Path $PSScriptRoot "..\src\*.cs")" `
-target:"exe"
