#requires -version 5

[cmdletbinding()]
param(
    [string]
    $Name = "",

    [string]
    $Email = "",

    [string]
    $OriginUrl = "https://github.com/imfrancisd/probability.git",

    [string]
    $FaicUrl = "https://github.com/ericlippert/probability.git"
)



$ErrorActionPreference = "Stop"
$PSDefaultParameterValues = @{"Disabled" = $true}



if (@(Get-Command "git" -ErrorAction SilentlyContinue).Count -eq 0) {
    throw "Install git version control (see https://git-scm.com/)."
}

if ([string]::IsNullOrWhiteSpace((git config user.name))) {
    if ([string]::IsNullOrWhiteSpace($Name)) {
        throw "Configure git user.name (git config user.name `"Francis de la Cerna`")."
    }
    git config user.name $Name
}

if ([string]::IsNullOrWhiteSpace((git config user.email))) {
    if ([string]::IsNullOrWhiteSpace($Email)) {
        throw "Configure git user.email (git config user.email `"imfrancisd@users.noreply.github.com`")."
    }
    git config user.email $Email
}

if (@(git remote) -notcontains "origin") {
    git remote add "origin" $OriginUrl
}

if (@(git remote) -notcontains "faic") {
    git remote add "faic" $FaicUrl
}

if ((git remote get-url "origin") -ne $OriginUrl) {
    throw "git remote get-url `"origin`" is not `"$OriginUrl`"."
}

if ((git remote get-url "faic") -ne $FaicUrl) {
    throw "git remote get-url `"faic`" is not `"$FaicUrl`"."
}



git fetch --all --quiet

$localBranches = @(git for-each-ref --format="%(refname:lstrip=2)" "refs/heads/")
$originBranches = @(git for-each-ref --format="%(refname:lstrip=3)" "refs/remotes/origin")
$faicBranches = @(git for-each-ref --format="%(refname:lstrip=3)" "refs/remotes/faic")



Write-Verbose "Checking out `"ci/mission-impossible-ghost-protocol`" from `"origin/imfrancisd/mission-impossible-ghost-protocol`"."
git checkout -B "ci/mission-impossible-ghost-protocol" "origin/imfrancisd/mission-impossible-ghost-protocol" --quiet

foreach ($branch in $faicBranches) {
    $episodeNumber = ($branch -replace "^episode", "") -as [double]

    if ($null -eq $episodeNumber) {
        Write-Verbose "Skipping branch `"$branch`" since it is not an episode."
        continue
    }

    $srcFile = Join-Path $PSScriptRoot "..\src\Episodes\IMFaic.Probability.Episode$($episodeNumber).cs"

    if (-not (Test-Path $srcFile)) {

        #Assume that faic/$branch episode is not merged
        #if IMFaic.Probability.Episode$($episodeNumber).cs does not exist.

        Write-Verbose "Merging `"faic/$branch`"."
        git merge "faic/$branch" --quiet

        Write-Verbose "Creating `"$srcFile`"."
        @(
            "using System;"
            "using Probability;"
            "using ProbabilityEp$($episodeNumber) = Probability.Episode$($episodeNumber);"
            ""
            "namespace IMFaic.Probability"
            "{"
            "    public static class Episode$($episodeNumber)"
            "    {"
            "        public static void Run(string[] args)"
            "        {"
            "            RunProbability();"
            "        }"
            ""
            "        public static void RunProbability()"
            "        {"
            "            Console.WriteLine(`"Probability`");"
            "            ProbabilityEp$($episodeNumber).DoIt();"
            "            Console.WriteLine(`"Press Enter to finish`");"
            "            Console.ReadLine();"
            "        }"
            ""
            "        public static void RunIMFaicProbability()"
            "        {"
            "            Console.WriteLine(`"IMFaic.Probability`");"
            "            Console.WriteLine(`"Press Enter to finish`");"
            "            Console.ReadLine();"
            "        }"
            "    }"
            "}"
        ) | Out-File -FilePath "$srcFile" -Encoding utf8 -Force

        Write-Verbose "Commiting changes."
        git add "$srcFile"
        git commit -m "Add IMFaic.Probability.Episode$($episodeNumber)." --quiet
    }
}

#TODO: Push changes to origin?
#TODO: Delete git config and secure environment variables?
