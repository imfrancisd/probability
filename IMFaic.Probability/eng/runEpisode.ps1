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



# Run all episodes if none are specified
#
if (($null) -eq $Episode -or (0 -eq $Episode.Length)) {
    $Episode = @(
        Get-ChildItem (Join-Path $PSScriptRoot "../src/Episodes") -Filter "IMFaic.Probability.Episode*.cs" |
            ForEach-Object {[System.IO.Path]::GetFileNameWithoutExtension($_.FullName)} |
            ForEach-Object {$_ -replace "IMFaic.Probability.Episode", ""} |
            Sort-Object {$_ -as [decimal]}, {$_}
    )
}



$runner = if ($Framework -eq "Mono") {"mono"} elseif ($Framework -eq "Core") {"dotnet"} else {"&"}

foreach ($episodeId in $Episode) {
    if ($Framework -eq "Core") {
        $dir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).*.*/tools/netcoreapp2.1"
        $exe = @(Get-ChildItem -Path $dir -Filter "app.dll" -Recurse | Sort-Object "FullName")
    }
    else {
        $dir = Join-Path $PSScriptRoot "../bin/IMFaic.Probability/$($episodeId).*.*/tools/netstandard2.0"
        $exe = @(Get-ChildItem -Path $dir -Filter "IMFaic.Probability.exe" -Recurse | Sort-Object "FullName")
    }
    foreach ($item in $exe) {
        $cmd = [scriptblock]::Create("`"`" | $($runner) $($item.FullName)")

        Write-Verbose "$("=" * [System.Math]::Max(0, $Host.UI.RawUI.BufferSize.Width - "VERBOSE: ".Length - 1))"
        Write-Verbose $cmd.ToString()
        Write-Verbose "$("=" * [System.Math]::Max(0, $Host.UI.RawUI.BufferSize.Width - "VERBOSE: ".Length - 1))"

        pushd (Split-Path $item.FullName -Parent)
        try {& $cmd}
        finally {popd}
    }
}
