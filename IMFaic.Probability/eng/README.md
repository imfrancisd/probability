# Engineering

This contains all the build scripts and tools necessary to build the project.


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



# Build Status

|                 | **mission-impossible**  | **ghost-protocol**               |
| --------------- | ----------------------- | -------------------------------- |
| **Status**      | [![Build status](https://ci.appveyor.com/api/projects/status/ykhusk01vlg1ea0l/branch/imfrancisd/mission-impossible?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible) | [![Build status](https://ci.appveyor.com/api/projects/status/h8voysbh93asgajq/branch/imfrancisd/mission-impossible-ghost-protocol?svg=true)](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol) |
| **Schedule**    | Monday-Friday 17:00 UTC | Monday-Friday 17:00 UTC          |
| **Description** | Build and run episodes. | Create, build, and run episodes. |
| **Links**       | [repo](https://github.com/imfrancisd/probability/tree/imfrancisd/mission-impossible), [build](https://ci.appveyor.com/project/imfrancisd/probability/branch/imfrancisd/mission-impossible), [zip](https://ci.appveyor.com/project/imfrancisd/probability/build/artifacts) | [repo](https://github.com/imfrancisd/probability/tree/imfrancisd/mission-impossible-ghost-protocol), [build](https://ci.appveyor.com/project/imfrancisd/probability-62n01/branch/imfrancisd/mission-impossible-ghost-protocol), [zip](https://ci.appveyor.com/project/imfrancisd/probability-62n01/build/artifacts) |
