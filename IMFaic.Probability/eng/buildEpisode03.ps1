#requires -version 5

$ErrorActionPreference = "Stop"



#Get build tools.
#
$tools = & "$PSScriptRoot\buildTools.ps1"



#Create output directory.
#
$binDir = Join-Path $PSScriptRoot "..\bin\IMFaic.Probability\3.0.0"
$objDir = Join-Path $PSScriptRoot "..\obj\IMFaic.Probability\3.0.0"

foreach ($directory in @($binDir, $objDir)) {
    if (Test-Path $directory) {
        rmdir -Recurse -Force $directory
    }

    mkdir $directory | out-null
}



#Compile all *.cs files inside Probability\
#
& $tools.csc `
-nologo `
-out:"$(Join-Path $binDir "Probability.dll")" `
-recurse:"$(Join-Path $PSScriptRoot "..\..\Probability\*.cs")" `
-target:"library" `
$(&{
    #Generate a temporary *.cs file that will make
    #IMFaic.Probability a friend to Probability
    #
    $tmp = Join-Path $objDir "ProbabilityFriends.cs"
    @(
        "using System.Reflection;",
        "using System.Runtime.CompilerServices;",
        "",
        "[assembly:InternalsVisibleTo(`"IMFaic.Probability`")]"
    ) | Out-File -FilePath $tmp -Encoding utf8 -Force
    $tmp
})



#Compile all *.cs files inside IMFaic.Probability\src\
#
& $tools.csc `
-main:"IMFaic.Probability.Episode03" `
-nologo `
-out:"$(Join-Path $binDir "IMFaic.Probability.exe")" `
-recurse:"$(Join-Path $PSScriptRoot "..\src\*.cs")" `
-reference:"$(Join-Path $binDir "Probability.dll")" `
-target:"exe"
