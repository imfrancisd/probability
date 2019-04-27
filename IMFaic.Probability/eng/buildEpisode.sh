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



csc -version &>/dev/null

if [ $? -ne 0 ]
then
    echo "Requires C# compiler (csc)."
    echo "Install Mono version 5.0.0 or higher."
    exit 1
fi    



for EPISODENUMBER in "${EPISODE[@]}"
do

    echo "Build Episode${EPISODENUMBER}"

    BINDIR="${SCRIPTROOT}/../bin/IMFaic.Probability/${EPISODENUMBER}.1.0"
    OBJDIR="${SCRIPTROOT}/../obj/IMFaic.Probability/${EPISODENUMBER}.1.0"

    rm -rf "${BINDIR}" "${OBJDIR}"
    mkdir -p "${BINDIR}" "${OBJDIR}"



    echo "Compiling Probability.dll"

    csc \
    -nologo \
    -out:"${BINDIR}/Probability.dll" \
    -recurse:"${SCRIPTROOT}/../../Probability/*.cs" \
    -recurse:"${SCRIPTROOT}/../prb/*.cs" \
    -target:"library"



    echo "Compiling IMFaic.Probability.dll"

    csc \
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

    csc \
    -nologo \
    -out:"${BINDIR}/Program.exe" \
    -reference:"${BINDIR}/IMFaic.Probability.dll" \
    -target:"exe" \
    "${PROGRAMCS}"

    mv "${BINDIR}/Program.exe" "${BINDIR}/IMFaic.Probability.exe"

    if [ "${EPISODENUMBER}" -eq "25" ]
    then
        cp "${SCRIPTROOT}/../src/Episodes/shakespeare.txt" "${BINDIR}/"
    fi
    
done

