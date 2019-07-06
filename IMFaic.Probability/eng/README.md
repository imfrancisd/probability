# Engineering

This contains all the build scripts and tools necessary to build the project.



# Build

Build the episodes with buildEpisode.ps1 for powershell.exe and buildEpisode.sh for bash.

**Build all episodes**
```
#From pwsh or powershell with .NET
.\buildEpisode.ps1 -Verbose
```

```
#From pwsh or powershell with Mono
./buildEpisode.ps1 -Framework Mono -Verbose
```

```
#From bash with Mono
./buildEpisode.sh
```


**Build some episodes**
```
#From pwsh or powershell with .NET
.\buildEpisode.ps1 -Episode 1, 2, 3 -Verbose
```

```
#From pwsh or powershell with Mono
./buildEpisode.ps1 -Framework Mono -Episode 1, 2, 3 -Verbose
```

```
#From bash with Mono
./buildEpisode.sh 1 2 3
```



# Run

Run the episodes with runEpisode.ps1 in pwsh or powershell. The script runEpisode.ps1 is used for the automated build, but you can use it as well.

You can see the automated build output in the following link:

**Mission Impossible Build**

https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible



# Create

Create episodes with ghostProtocol.ps1 in pwsh or powershell by merging episode branches from [ericlippert/probability](https://github.com/ericlippert/probability) and creating their corresponding source files. The script ghostProtocol.ps1 is used for the automated build, but you can use it as well.

You can see the automated build output in the following link:

**Ghost Protocol Build**

https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol



# Automated Build


**.NET**

|                  | **mission-impossible**  | **ghost-protocol**               |
| ---------------- | ----------------------- | -------------------------------- |
| **Status**       | [![Build status](https://ci.appveyor.com/api/projects/status/ykhusk01vlg1ea0l/branch/imfrancisd/mission-impossible?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible) | [![Build status](https://ci.appveyor.com/api/projects/status/h8voysbh93asgajq/branch/imfrancisd/mission-impossible-ghost-protocol?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol) |
| **Schedule**     | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC                |
| **Description**  | Build, Run              | Create, Build, Run               |
| **OS**           | Windows                 | Windows                          |
| **Shell**        | powershell              | powershell                       |
| **Links**        | [build](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible), [artifacts](https://ci.appveyor.com/project/imfrancisd/probability/build/artifacts) | [build](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol), [artifacts](https://ci.appveyor.com/project/imfrancisd/probability-62n01/build/artifacts) |


**Mono**

|                  | **mission-impossible**  | **ghost-protocol**      | **mission-impossible**  | **ghost-protocol**      |
| ---------------- | ----------------------- | ----------------------- | ----------------------- | ----------------------- |
| **Status**       | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/mission-impossible-ubuntu1604-bash?branchName=imfrancisd/mission-impossible)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=1&branchName=imfrancisd/mission-impossible) | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-ubuntu-pwsh-mono?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=2&branchName=imfrancisd/mission-impossible-ghost-protocol) | pc load letter | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-macos-pwsh-mono?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=4&branchName=imfrancisd/mission-impossible-ghost-protocol) |
| **Schedule**     | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       |
| **Description**  | Build, Run              | Create, Build, Run      | Build, Run              | Create, Build, Run      |
| **OS**           | Ubuntu                  | Ubuntu                  | macOS                   | macOS                   |
| **Shell**        | bash                    | pwsh                    | bash                    | pwsh                    |
| **Links**        | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=1&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=2&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=3&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=4&_a=summary) |


**.NET Core**

|                  | **ghost-protocol**      | **ghost-protocol**      | **ghost-protocol**      | **ghost-protocol**      |
| ---------------- | ----------------------- | ----------------------- | ----------------------- | ----------------------- |
| **Status**       | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-windows-powershell-netcore?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=5&branchName=imfrancisd/mission-impossible-ghost-protocol) | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-windows-pwsh-netcore?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=6&branchName=imfrancisd/mission-impossible-ghost-protocol) | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-ubuntu-pwsh-netcore?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=7&branchName=imfrancisd/mission-impossible-ghost-protocol) | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/ghost-protocol-macos-pwsh-netcore?branchName=imfrancisd/mission-impossible-ghost-protocol)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=8&branchName=imfrancisd/mission-impossible-ghost-protocol) |
| **Schedule**     | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       | Mon-Fri 20:00 UTC       |
| **Description**  | Create, Build, Run      | Create, Build, Run      | Create, Build, Run      | Create, Build, Run      |
| **OS**           | Windows                 | Windows                 | Ubuntu                  | macOS                   |
| **Shell**        | powershell              | pwsh                    | pwsh                    | pwsh                    |
| **Links**        | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=5&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=6&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=7&_a=summary) | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=8&_a=summary) |

**Reconnaissance**

|                  | **dotnet-reconnaissance** |
| ---------------- | ------------------------- |
| **Status**       | complete                  |
| **Schedule**     | never                     |
| **Description**  | get dotnet build output   |
| **OS**           | Ubuntu                    |
| **Shell**        | bash                      |
| **Links**        | [build](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build?definitionId=9&_a=summary) |
