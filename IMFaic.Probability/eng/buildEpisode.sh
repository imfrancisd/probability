#!/usr/bin/env bash

set -u

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

function getNugetPackage {
    echo "Get package \"${1}\" version \"${2}\" from \"https://www.nuget.org/\"."

    PKGURI="https://www.nuget.org/api/v2/package/${1}/${2}"
    PKGDIR="${SCRIPTROOT}/../packages/${1}/${2}"
    PKGZIP="${SCRIPTROOT}/../packages/${1}.${2}.nupkg.zip"

    if [ ! -f ${PKGZIP} ] || [ "${3}" != "$(sha512sum "${PKGZIP}" | cut -d " " -f 1)" ]
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

getNugetPackage "microsoft.net.compilers.toolset" "3.1.0" "80031aac4e6174a978135cc89030f59a914618e75053c48893087809311106747e4eb6921c62ae093e0c12603851a72a4e59277c7f3c956c314c7cfc7b66c762"
CSCEXE="${SCRIPTROOT}/../packages/microsoft.net.compilers.toolset/3.1.0/tasks/net472/csc.exe"

echo "Get .NET Standard reference assemblies."

getNugetPackage "netstandard.library" "2.0.3" "e78f0cea69c14895b1b089644077dbce8631a626055d96522f4d29e061d8bfc3e48aa1419e74faf265b998612c03f721f5f0cef4690f824150a5689764dee601"
NETSTANDARD="${SCRIPTROOT}/../packages/netstandard.library/2.0.3/build/netstandard2.0/ref"



LIBDIR="${SCRIPTROOT}/../obj/lib"

rm -rf "${LIBDIR}"
mkdir -p "${LIBDIR}"



echo "Compiling Probability.dll"

mono "${CSCEXE}" \
-deterministic \
-noconfig \
-nologo \
-nostdlib \
-optimize \
-out:"${LIBDIR}/Probability.dll" \
-recurse:"${SCRIPTROOT}/../../Probability/*.cs" \
-recurse:"${SCRIPTROOT}/../prb/*.cs" \
-reference:"${NETSTANDARD}/netstandard.dll" \
-target:"library"



echo "Compiling IMFaic.Probability.dll"

mono "${CSCEXE}" \
-deterministic \
-noconfig \
-nologo \
-nostdlib \
-optimize \
-out:"${LIBDIR}/IMFaic.Probability.dll" \
-recurse:"${SCRIPTROOT}/../src/*.cs" \
-reference:"${LIBDIR}/Probability.dll" \
-reference:"${NETSTANDARD}/netstandard.dll" \
-target:"library"



for EPISODENUMBER in "${EPISODE[@]}"
do

    echo "Build Episode${EPISODENUMBER}"

    BINDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0"
    OBJDIR="${SCRIPTROOT}/../obj/IMFaic.Probability/${EPISODENUMBER}.1.0"

    rm -rf "${BINDIR}" "${OBJDIR}"
    mkdir -p "${BINDIR}" "${OBJDIR}"

    cp "${LIBDIR}/"*.dll "${BINDIR}/"

    PROGRAMCS="${OBJDIR}/Program.cs"
    echo "
    public class Program
    {
        public static void Main(string[] args)
        {
            IMFaic.Probability.Episode${EPISODENUMBER}.Run(args);
        }
    }
    " > "${PROGRAMCS}"



    echo "Compiling IMFaic.Probability.exe"

    mono "${CSCEXE}" \
    -deterministic \
    -noconfig \
    -nologo \
    -nostdlib \
    -optimize \
    -out:"${BINDIR}/Program.exe" \
    -reference:"${BINDIR}/IMFaic.Probability.dll" \
    -reference:"${NETSTANDARD}/netstandard.dll" \
    -target:"exe" \
    "${PROGRAMCS}"

    mv "${BINDIR}/Program.exe" "${BINDIR}/IMFaic.Probability.exe"

    if [ "${EPISODENUMBER}" == "25" ]
    then
        cp "${SCRIPTROOT}/../src/Episodes/shakespeare.txt" "${BINDIR}/"
    fi

done
