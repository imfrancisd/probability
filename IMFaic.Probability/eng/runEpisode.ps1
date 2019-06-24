#requires -version 5

[Cmdletbinding()]
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



$runner = if ($Framework -eq "Mono") {"mono"} elseif ($Framework -eq "Core") {"dotnet"} else {"&"}
foreach ($episodeId in $Episode) {
    $dir = Join-Path $PSScriptRoot "..\bin\IMFaic.Probability\$($episodeId).*.*"
    $exe = @(dir -Path $dir -Filter "IMFaic.Probability.exe" -Recurse | Sort-Object "FullName")
    foreach ($item in $exe) {
        $cmd = [scriptblock]::Create("`"`" | $($runner) $($item.FullName)")
        Write-Verbose $cmd.ToString()
        pushd (Split-Path $item.FullName -Parent)
        try {& $cmd}
        finally {popd}
    }
}
