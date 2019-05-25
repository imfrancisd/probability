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



# Run all episodes if none are specified
#
if (($null) -eq $Episode -or (0 -eq $Episode.Length)) {
    $Episode = @(
        dir (Join-Path $PSScriptRoot "..\src\Episodes") -Filter "IMFaic.Probability.Episode*.cs" |
            ForEach-Object {[System.IO.Path]::GetFileNameWithoutExtension($_.FullName)} |
            ForEach-Object {$_ -replace "IMFaic.Probability.Episode", ""} |
            Sort-Object {$_ -as [double]}, {$_}
    )
}



foreach ($episodeId in $Episode) {
    $dir = Join-Path $PSScriptRoot "..\bin\IMFaic.Probability\$($episodeId).*.*"
    $exe = @(dir -Path $dir -Filter "IMFaic.Probability.exe" -Recurse | Sort-Object "FullName")

    foreach ($item in $exe) {
        Write-Verbose $("& " + $item.FullName)
        pushd (Split-Path $item.FullName -Parent)
        try {"" | & $item.FullName}
        finally {popd}
    }
}
