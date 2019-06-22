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



echo "Get build tools."

PKGDIR="${SCRIPTROOT}/../packages"
mkdir -p "${PKGDIR}"



echo "Check if  mono is installed."

mono --version &>/dev/null

if [ $? -ne 0 ]
then
    echo "Requires Mono version 5.0.0 or higher."
    exit 1
fi



echo "Get compilers (see https://www.nuget.org/packages/microsoft.net.compilers.toolset)."

PKGNAME="microsoft.net.compilers.toolset"
PKGVERSION="3.1.0"
PKGSHA512="80031aac4e6174a978135cc89030f59a914618e75053c48893087809311106747e4eb6921c62ae093e0c12603851a72a4e59277c7f3c956c314c7cfc7b66c762"

CSCEXE="${PKGDIR}/${PKGNAME}/${PKGVERSION}/tasks/net472/csc.exe"

if [ ! -f "${CSCEXE}" ]
then
    rm -rf "${PKGDIR}/${PKGNAME}/${PKGVERSION}"
    mkdir -p "${PKGDIR}/${PKGNAME}/${PKGVERSION}"
    wget -O "${PKGDIR}/${PKGNAME}/${PKGVERSION}/${PKGNAME}.${PKGVERSION}.nupkg" "https://www.nuget.org/api/v2/package/Microsoft.Net.Compilers.Toolset/3.1.0"

    if [ "${PKGSHA512}" != "$(sha512sum "${PKGDIR}/${PKGNAME}/${PKGVERSION}/${PKGNAME}.${PKGVERSION}.nupkg" | cut -d " " -f 1)" ]
    then
        echo "Could not get compilers (nuget package ${PKGNAME}.${PKGVERSION}.nupkg does not have expected SHA512 sum)."
        exit 1
    fi

    unzip "${PKGDIR}/${PKGNAME}/${PKGVERSION}/${PKGNAME}.${PKGVERSION}.nupkg" -d "${PKGDIR}/${PKGNAME}/${PKGVERSION}"

    if [ ! -f "${CSCEXE}" ]
    then
        echo "Could not get compilers (nuget package ${PKGNAME}.${PKGVERSION}.nupkg does not have expected folder structure)."
        exit 1
    fi
fi



for EPISODENUMBER in "${EPISODE[@]}"
do

    echo "Build Episode${EPISODENUMBER}"

    BINDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0"
    OBJDIR="${SCRIPTROOT}/../obj/IMFaic.Probability/${EPISODENUMBER}.1.0"

    rm -rf "${BINDIR}" "${OBJDIR}"
    mkdir -p "${BINDIR}" "${OBJDIR}"



    echo "Compiling Probability.dll"

    mono "${CSCEXE}" \
    -nologo \
    -out:"${BINDIR}/Probability.dll" \
    -recurse:"${SCRIPTROOT}/../../Probability/*.cs" \
    -recurse:"${SCRIPTROOT}/../prb/*.cs" \
    -target:"library"



    echo "Compiling IMFaic.Probability.dll"

    mono "${CSCEXE}" \
    -nologo \
    -out:"${BINDIR}/IMFaic.Probability.dll" \
    -recurse:"${SCRIPTROOT}/../src/*.cs" \
    -reference:"${BINDIR}/Probability.dll" \
    -target:"library"



    echo "Generating Source"

    #Generate a file that will run the episode in IMFaic.Probability
    #
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
    -nologo \
    -out:"${BINDIR}/Program.exe" \
    -reference:"${BINDIR}/IMFaic.Probability.dll" \
    -target:"exe" \
    "${PROGRAMCS}"

    mv "${BINDIR}/Program.exe" "${BINDIR}/IMFaic.Probability.exe"

    if [ "${EPISODENUMBER}" == "25" ]
    then
        cp "${SCRIPTROOT}/../src/Episodes/shakespeare.txt" "${BINDIR}/"
    fi
    
done

