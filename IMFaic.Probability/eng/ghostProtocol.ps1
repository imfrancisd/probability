#requires -version 5

[CmdletBinding()]
param(
    [string]
    $Name = "",

    [string]
    $Email = "",

    [string]
    $OriginUrl = "https://github.com/imfrancisd/probability.git",

    [string]
    $FaicUrl = "https://github.com/ericlippert/probability.git",

    [switch]
    $PushChanges,

    [ValidateSet("Core", "Mono", "Net")]
    [string]
    $Framework = "Net"
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
    throw "git remote get-url `"origin`" is not `"$($OriginUrl)`"."
}

if ((git remote get-url "faic") -ne $FaicUrl) {
    throw "git remote get-url `"faic`" is not `"$($FaicUrl)`"."
}



git fetch --all --quiet

$faicBranches = @(
    git for-each-ref --format="%(refname:lstrip=3)" "refs/remotes/faic" |
        Sort-Object {$_ -match "^episode"}, {($_ -replace "^episode", "") -as [decimal]}, {$_}
)



foreach ($branch in $faicBranches) {
    <####################################
    branch           episode   episode id
    ------           -------   ----------
    master                               
    bonus01                              
    episode09        09                 9
    episode10        10                10
    episode0         0                  0
    episode0.0       0.0                0
    episode3         3                  3
    episode03        03                 3
    episode030       030               30
    episode3.14      3.14            3.14
    episode03.14     03.14           3.14
    episode03.1400   03.1400         3.14
    episodealpha0    alpha0        alpha0
    episodealpha0.0  alpha0.0    alpha0.0
    episodeepisode00 episode00  episode00
    ####################################>

    if ($branch -notmatch "^episode") {
        Write-Verbose "Skipping branch `"faic/$($branch)`" since it is not an episode."
        continue
    }

    $episode = ($branch -replace "^episode", "")
    $episodeId = $episode -as [double]
    if ($null -eq $episodeId) {
        $episodeId = $episode
    }

    $srcFile = Join-Path $PSScriptRoot "../src/Episodes/IMFaic.Probability.Episode$($episodeId).cs"

    if (-not (Test-Path $srcFile)) {
        #Assume that faic/$branch is not merged if IMFaic.Probability.Episode$($episodeId).cs does not exist.

        Write-Verbose "Merging `"faic/$($branch)`"."
        git merge "faic/$($branch)" --quiet

        Write-Verbose "Creating `"$($srcFile)`"."

        $hasEpisodeExample = & {
            #FORESHADOW:
            #Check if all of the following exists:
            #    public static void DoIt() in
            #    public|protected static class Episode$($episode) in
            #    namespace Probability in
            #    Probability/Episode$($episode).cs

            $filePath = Join-Path $PSScriptRoot "../../Probability/Episode$($episode).cs"
            if (-not (Test-Path $filePath)) {
                return $false
            }

            Add-Type -Path $(Join-Path $PSScriptRoot "../packages/microsoft.net.compilers.toolset/3.2.0-beta3-final/tasks/net472/Microsoft.CodeAnalysis.dll")
            Add-Type -Path $(Join-Path $PSScriptRoot "../packages/microsoft.net.compilers.toolset/3.2.0-beta3-final/tasks/net472/Microsoft.CodeAnalysis.CSharp.dll")

            $namespace = [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText((Get-Content $filePath)).GetRoot().Members.FirstOrDefault()
            if (-not ($namespace -is [Microsoft.CodeAnalysis.CSharp.Syntax.NamespaceDeclarationSyntax])) {
                return $false
            }

            if (-not ($namespace.Name.Identifier.Text -ceq "Probability")) {
                return $false
            }

            $class = $namespace.Members.FirstOrDefault()
            if (-not ($class.Identifier.Text -ceq "Episode$($episode)")) {
                return $false
            }

            $classModifiers = @($class.Modifiers | ForEach-Object {$_.Text})
            if (-not ($classModifiers -ccontains "static")) {
                return $false
            }
            if (($classModifiers -ccontains "private") -or ($classModifiers -ccontains "internal")) {
                return $false
            }

            return $true
        }

        @(
            "using System;"
            "using Probability;"
            
            if ($hasEpisodeExample) {
                "using ProbabilityEp$($episodeId) = Probability.Episode$($episode);"
            }

            ""
            "namespace IMFaic.Probability"
            "{"
            "    public static class Episode$($episodeId)"
            "    {"
            "        public static void Run(string[] args)"
            "        {"
            "            RunProbability();"
            "        }"
            ""
            "        public static void RunProbability()"
            "        {"
            "            Console.WriteLine(`"Probability`");"

            if ($hasEpisodeExample) {
                "            ProbabilityEp$($episodeId).DoIt();"
            }

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

        Write-Verbose "Commiting changes."
        git add $srcFile
        git commit -m "Add IMFaic.Probability.Episode$($episodeId)." --quiet
    }
}

if ($PushChanges) {
    #Assume git is already configured to push to origin.
    $currentBranch = git rev-parse --abbrev-ref "HEAD"
    Write-Verbose "Pushing changes from branch `"$($currentBranch)`""
    git push origin $currentBranch --quiet
}