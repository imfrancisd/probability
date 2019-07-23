#!/usr/bin/env bash

set -u
unalias -a
SCRIPTROOT="$( dirname "${BASH_SOURCE[0]}" )"



#Build all episodes if none are specified.
#
if [ "$#" -ne 0 ]
then
    IFS=" " read -ra EPISODE <<< "$@"
else
    IFS=" " read -ra EPISODE <<< "$(
        for F in $( find "${SCRIPTROOT}/../src/Episodes/" -name "*.cs" )
        do
            F="$( basename "${F%.*}" )"
            echo -n "${F/IMFaic\.Probability\.Episode/} "
        done
    )"
fi



echo "Check if  mono is installed."

mono --version 2>&1

if [ $? -ne 0 ]
then
    echo "Requires Mono version 5.0.0 or higher."
    exit 1
fi



echo "Get build tools."

#Uncomment to clear cached downloads.
#rm -rf "${SCRIPTROOT}/../packages"

function getNugetPackage {
    mkdir -p "${SCRIPTROOT}/../packages"

    echo "Get package \"${1}\" version \"${2}\" from \"https://www.nuget.org/\"."

    PKGURI="https://www.nuget.org/api/v2/package/${1}/${2}"
    PKGDIR="${SCRIPTROOT}/../packages/${1}/${2}"
    PKGZIP="${SCRIPTROOT}/../packages/${1}.${2}.nupkg.zip"

    if [[ (! -f ${PKGZIP}) || ( "${3}" != "$(sha512sum "${PKGZIP}" | cut -d " " -f 1)" ) ]]
    then
        wget -O "${PKGZIP}" "${PKGURI}" 2>&1
    fi

    if [ "${3}" != "$(sha512sum "${PKGZIP}" | cut -d " " -f 1)" ]
    then
        echo "Could not get package \"${1}\" version \"${2}\" (downloaded file does not have the expected sha512 sum)."
        exit 1
    fi

    if [ -f ${PKGDIR} ]
    then
        rm -rf ${PKGDIR}
    fi

    mkdir -p ${PKGDIR}
    unzip "${PKGZIP}" -d "${PKGDIR}" 2>&1
}



echo "Get Roslyn C# and VB compilers."

getNugetPackage "microsoft.net.compilers.toolset" "3.2.0-beta4-final" "96da0a7dd10ac8209b759a331aa10edbb38fe4cd6695ad5c7203f1d9221f9e9137ca282033e780722f53a655c849ce26805319353d6daf3ee485d32e87a4a576"
CSCEXE="${SCRIPTROOT}/../packages/microsoft.net.compilers.toolset/3.2.0-beta4-final/tasks/net472/csc.exe"



echo "Get .NET Standard reference assemblies."

getNugetPackage "netstandard.library" "2.0.3" "e78f0cea69c14895b1b089644077dbce8631a626055d96522f4d29e061d8bfc3e48aa1419e74faf265b998612c03f721f5f0cef4690f824150a5689764dee601"
NETSTANDARD="${SCRIPTROOT}/../packages/netstandard.library/2.0.3/build/netstandard2.0/ref"



OBJLIBNETSTANDARDDIR="${SCRIPTROOT}/../obj/lib/netstandard2.0"

rm -rf "${OBJLIBNETSTANDARDDIR}"
mkdir -p "${OBJLIBNETSTANDARDDIR}"



echo "Compiling Probability.dll."

mono "${CSCEXE}" \
-debug:pdbonly \
-deterministic \
-noconfig \
-nologo \
-nostdlib \
-optimize \
-out:"${OBJLIBNETSTANDARDDIR}/Probability.dll" \
-pdb:"${OBJLIBNETSTANDARDDIR}/Probability.pdb" \
-recurse:"${SCRIPTROOT}/../../Probability/*.cs" \
-recurse:"${SCRIPTROOT}/../prb/*.cs" \
-reference:"${NETSTANDARD}/netstandard.dll" \
-target:"library" \
-warn:4 \
-warnaserror



echo "Compiling IMFaic.Probability.dll."

mono "${CSCEXE}" \
-debug:pdbonly \
-deterministic \
-noconfig \
-nologo \
-nostdlib \
-optimize \
-out:"${OBJLIBNETSTANDARDDIR}/IMFaic.Probability.dll" \
-pdb:"${OBJLIBNETSTANDARDDIR}/IMFaic.Probability.pdb" \
-recurse:"${SCRIPTROOT}/../src/*.cs" \
-reference:"${OBJLIBNETSTANDARDDIR}/Probability.dll" \
-reference:"${NETSTANDARD}/netstandard.dll" \
-target:"library" \
-warn:4 \
-warnaserror



for EPISODENUMBER in "${EPISODE[@]}"
do

    echo "Build Episode${EPISODENUMBER}."

    PKGLIBNETSTANDARDDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0/lib/netstandard2.0"
    PKGTOOLSNETSTANDARDDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0/tools/netstandard2.0"
    PKGTOOLSNETCOREAPPDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0/tools/netcoreapp2.0"

    rm -rf "${PKGLIBNETSTANDARDDIR}" "${PKGTOOLSNETSTANDARDDIR}" "${PKGTOOLSNETCOREAPPDIR}"
    mkdir -p "${PKGLIBNETSTANDARDDIR}" "${PKGTOOLSNETSTANDARDDIR}" "${PKGTOOLSNETCOREAPPDIR}"



    echo "Compiling ${PKGLIBNETSTANDARDDIR}."
    cp "${OBJLIBNETSTANDARDDIR}/"* "${PKGLIBNETSTANDARDDIR}/"



    echo "Compiling ${PKGTOOLSNETSTANDARDDIR}."
    cp "${OBJLIBNETSTANDARDDIR}/"* "${PKGTOOLSNETSTANDARDDIR}/"

    PROGRAMCS="${PKGTOOLSNETSTANDARDDIR}/Program.cs"
    echo "
    public class Program
    {
        public static void Main(string[] args)
        {
            IMFaic.Probability.Episode${EPISODENUMBER}.Run(args);
        }
    }
    " > "${PROGRAMCS}"

    mono "${CSCEXE}" \
    -deterministic \
    -noconfig \
    -nologo \
    -nostdlib \
    -optimize \
    -out:"${PKGTOOLSNETSTANDARDDIR}/Program.exe" \
    -reference:"${PKGTOOLSNETSTANDARDDIR}/IMFaic.Probability.dll" \
    -reference:"${NETSTANDARD}/netstandard.dll" \
    -target:"exe" \
    -warn:4 \
    -warnaserror \
    "${PROGRAMCS}"

    #Rename Program.exe to IMFaic.Probability.exe instead of compiling as IMFaic.Probability.exe
    #to avoid TypeLoadException and MissingMethodException at runtime.
    mv "${PKGTOOLSNETSTANDARDDIR}/Program.exe" "${PKGTOOLSNETSTANDARDDIR}/IMFaic.Probability.exe"

    if [ "${EPISODENUMBER}" == "25" ]
    then
        cp "${SCRIPTROOT}/../src/Episodes/shakespeare.txt" "${PKGTOOLSNETSTANDARDDIR}/"
    fi

    rm -rf "${PROGRAMCS}"



    echo "Compiling ${PKGTOOLSNETCOREAPPDIR}."
    cp "${PKGTOOLSNETSTANDARDDIR}/"* "${PKGTOOLSNETCOREAPPDIR}/"
    mv "${PKGTOOLSNETCOREAPPDIR}/IMFaic.Probability.exe" "${PKGTOOLSNETCOREAPPDIR}/IMFaic.Probability.exe.dll"

    echo "
    {
      \"runtimeOptions\": {
        \"framework\": {
          \"name\": \"Microsoft.NETCore.App\",
          \"version\": \"2.0.0\"
        }
      }
    }
    " > "${PKGTOOLSNETCOREAPPDIR}/IMFaic.Probability.exe.runtimeconfig.json"

    echo "
    {
      \"runtimeTarget\": {
        \"name\": \".NETCoreApp,Version=v2.0\"
      },
      \"targets\": {
        \".NETCoreApp,Version=v2.0\": {
          \"IMFaic.Probability.exe\": {
            \"runtime\": {
              \"IMFaic.Probability.exe.dll\": {}
            }
          },
          \"Probability\": {
            \"runtime\": {
              \"Probability.dll\": {}
            }
          },
          \"IMFaic.Probability\": {
            \"runtime\": {
              \"IMFaic.Probability.dll\": {}
            }
          }
        }
      },
      \"libraries\": {
        \"IMFaic.Probability.exe\": {
          \"type\": \"project\",
          \"serviceable\": false,
          \"sha512\": \"\"
        },
        \"Probability\": {
          \"type\": \"project\",
          \"serviceable\": false,
          \"sha512\": \"\"
        },
        \"IMFaic.Probability\": {
          \"type\": \"project\",
          \"serviceable\": false,
          \"sha512\": \"\"
        }
      }
    }
    " > "${PKGTOOLSNETCOREAPPDIR}/IMFaic.Probability.exe.deps.json"

done
