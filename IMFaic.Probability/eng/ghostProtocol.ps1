#requires -version 5

[cmdletbinding()]
param()

git config user.name "Francis de la Cerna"
git config user.email "imfrancisd@users.noreply.github.com"

if (@(git remote) -notcontains "faic") {
    git remote add "faic" "https://github.com/ericlippert/probability"
}

git fetch --all --quiet

$faicBranches = @(git for-each-ref --format="%(refname:lstrip=3)" "refs/remotes/faic")
$localBranches = @(git for-each-ref --format="%(refname:lstrip=2)" "refs/heads/")
$originBranches = @(git for-each-ref --format="%(refname:lstrip=3)" "refs/remotes/origin")
$diffBranches = @(
    $faicBranches |
        Where-Object {$originBranches -cnotcontains $_} |
        Sort-Object {$_.Replace("episode", "") -as [double]}, {$_}
)

foreach ($branch in $diffBranches) {
    if ($localBranches -ccontains $branch) {
        throw "New branch `"$branch`" in remotes/faic/ exists locally."
    }

    #TODO: Push new branches to origin.
    #TODO: Will assume branches not in origin have not yet been merged to origin.

    git merge "faic/$branch" --quiet

    $episodeNumber = $branch.Replace("episode", "") -as [double]

    if ($null -ne $episodeNumber) {
        $srcFile = Join-Path $PSScriptRoot "..\src\Episodes\IMFaic.Probability.Episode$($episodeNumber).cs"

        if (-not (Test-Path $srcFile)) {
            Write-Verbose "Creating $srcFile"
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
            ) | Out-File -FilePath $srcFile -Encoding utf8 -Force

            #TODO: Commit and push new file.
        }
    }
}
