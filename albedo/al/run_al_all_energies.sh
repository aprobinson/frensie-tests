#!/bin/bash
##---------------------------------------------------------------------------##
## FACEMC multiple mpi tests runner
##---------------------------------------------------------------------------##
## Validation runs comparing FRENSIE and MCNP.
## This script will run the run_al_mpi.sh script at several different energies:
## .005 .0093 .01 .011 .0134 .015 .0173 .02 .0252 .03 .04 .0415 .05 .06 .0621
## .0818 and .102 MeV
##---------------------------------------------------------------------------##

# file type (1 = Native, 2 = ACE EPR14, 3 = ACE EPR12)
file_type=1
# Material element
element="Al"

if [ "${element}" == "Al" ]; then
    # Source energies for Al (MeV)
    energies=( .005 .0093 .01 .011 .0134 .015 .0173 .02 .0252 .03 .04 .0415 .05 .06 .0621 .0818 .102 )
else
    echo "Error: Element \"${element}\" is currently not supported!"
fi

# loop through energies and run mpi script
for i in "${energies[@]}"
do
    command=s/ENERGY=.*/ENERGY=\"$i\"/
    sed -i $command run_al_mpi.sh
    echo -e "\nRunning Al Albedo Test at an Energy of "$i" MeV!"
    sbatch run_al_mpi.sh $file_type
done
