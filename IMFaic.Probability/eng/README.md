# Engineering

This contains all the build scripts and tools necessary to build the project.



# Build

Build the episodes with buildEpisode.ps1 for powershell.exe and buildEpisode.sh for bash.

**Build all episodes quietly**
```
#From powershell.exe
.\buildEpisode.ps1
```

**Build all episodes verbosely**
```
#From powershell.exe
.\buildEpisode.ps1 -Verbose
```

```
#From bash
./buildEpisode.sh
```


**Build some episodes quietly**
```
#From powershell.exe
.\buildEpisode.ps1 -Episode 1, 2, 3
```

**Build some episodes verbosely**
```
#From powershell.exe
.\buildEpisode.ps1 -Episode 1, 2, 3 -Verbose
```

```
#From bash
./buildEpisode.sh 1 2 3
```



# Run

Run the episodes with runEpisode.ps1 for powershell.exe. The script runEpisode.ps1 is used for the automated build, but you can use it as well.

You can see the automated build output in the following link:

**Mission Impossible Build**

https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible



# Create

Create episodes with ghostProtocol.ps1 for powershell.exe by merging episode branches from [ericlippert/probability](https://github.com/ericlippert/probability) and creating their corresponding source files. The script ghostProtocol.ps1 is used for the automated build, but you can use it as well.

You can see the automated build output in the following link:

**Ghost Protocol Build**

https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol



# Automated Build


**.NET**

|                  | **mission-impossible**  | **ghost-protocol**               |
| ---------------- | ----------------------- | -------------------------------- |
| **Status**       | [![Build status](https://ci.appveyor.com/api/projects/status/ykhusk01vlg1ea0l/branch/imfrancisd/mission-impossible?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible) | [![Build status](https://ci.appveyor.com/api/projects/status/h8voysbh93asgajq/branch/imfrancisd/mission-impossible-ghost-protocol?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol) |
| **Schedule**     | Monday-Friday 20:00 UTC | Monday-Friday 20:00 UTC          |
| **Description**  | Build and run episodes. | Create, build, and run episodes. |
| **OS**           | Windows                 | Windows                          |
| **Shell**        | powershell              | powershell                       |
| **Links**        | [build](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible), [artifacts](https://ci.appveyor.com/project/imfrancisd/probability/build/artifacts) | [build](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol), [artifacts](https://ci.appveyor.com/project/imfrancisd/probability-62n01/build/artifacts) |


**Mono**

|                  | **mission-impossible**  | **mission-impossible**  |
| ---------------- | ----------------------- | ----------------------- |
| **Status**       | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/mission-impossible-ubuntu1604-bash?branchName=imfrancisd/mission-impossible)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=1&branchName=imfrancisd/mission-impossible) | [![Build Status](https://dev.azure.com/imfrancisd/IMFaic.Probability/_apis/build/status/mission-impossible-ubuntu1604-powershell-mono?branchName=imfrancisd/mission-impossible)](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=2&branchName=imfrancisd/mission-impossible) |
| **Schedule**     | Monday-Friday 20:00 UTC | Monday-Friday 20:00 UTC |
| **Description**  | Build and run episodes. | Build and run episodes. |
| **OS**           | Ubuntu                  | Ubuntu                  |
| **Shell**        | bash                    | pwsh                    |
| **Links**        | [build and artifacts](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=1&branchName=imfrancisd/mission-impossible) | [build and artifacts](https://dev.azure.com/imfrancisd/IMFaic.Probability/_build/latest?definitionId=2&branchName=imfrancisd/mission-impossible) |
