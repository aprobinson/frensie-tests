#!/bin/sh
# This file is named run_facemc_mpi.sh
#SBATCH --partition=pre
#SBATCH --time=1-00:00:00
#SBATCH --nodes=5
#SBATCH --ntasks-per-node=16
#SBATCH --mem-per-cpu=4000

##---------------------------------------------------------------------------##
## ---------------------------- FACEMC test runner --------------------------##
##---------------------------------------------------------------------------##
## Validation runs comparing FRENSIE and MCNP.
## The electron albedo is found for a semi-infinite aluminum slab. Since the
## electron albedo requires a surface current, DagMC will be used and not Root.
## FRENSIE will be run with three variations. 1. Using ACE data, which should
## match MCNP almost exactly. 2. Using the Native data in analog mode, whcih 
## uses a different interpolation scheme than MCNP. 3. Using Native data in 
## moment preserving mode, which should give a less acurate answer while
## decreasing run time.

##---------------------------------------------------------------------------##
## ------------------------------- COMMANDS ---------------------------------##
##---------------------------------------------------------------------------##

# Set cross_section.xml directory path.
EXTRA_ARGS=$@
CROSS_SECTION_XML_PATH=/home/ecmartin3/software/mcnpdata/
FRENSIE=/home/lkersting/frensie

INPUT="1"
if [ "$#" -eq 1 ];
then
    # Set the file type (1 = ACE, 2 = Native, 3 = Moment Preserving)
    INPUT="$1"
fi

# Changing variables
ENERGY=".015"
THREADS="80"
ELEMENT="Al"


ENERGY_EV=$(echo $ENERGY*1000000 |bc)
ENERGY_EV=${ENERGY_EV%.*}
NAME="ace"

if [ ${INPUT} -eq 1 ]
then
    # Use ACE data
    NAME="ace"
    python mat.py -n ${ELEMENT} -t ${NAME}
    python sim_info.py -e ${ENERGY} -c 1.0
    echo "Using ACE data!"
elif [ ${INPUT} -eq 2 ]
then
    # Use Native analog data
    NAME="native"
    python mat.py -n ${ELEMENT} -t ${NAME}
    python sim_info.py -e ${ENERGY} -c 1.0
    echo "Using Native analog data!"
elif [ ${INPUT} -eq 3 ]
then
    # Use Native Moment Preserving data
    NAME="moments"
    python mat.py -n ${ELEMENT} -t "native"
    python sim_info.py -e ${ENERGY} -c 0.9
    echo "Using Native Moment Preserving data!"
else
    # Default to ACE data
    echo "Input not valid, ACE data will be used!"
    python mat.py -n ${ELEMENT} -t ${NAME}
    python sim_info.py -e ${ENERGY} -c 1.0
fi

# .xml file paths.
python ../est.py -e ${ENERGY}
python source.py -e ${ENERGY}
MAT="mat.xml"
INFO="sim_info.xml"
GEOM="geom.xml"
SOURCE="source.xml"
RSP="../rsp_fn.xml"
EST="../est.xml"
NAME="al_${NAME}_${ENERGY_EV}"

# Make directory for the test results
TODAY=$(date +%Y-%m-%d)
DIR="results/${TODAY}"
mkdir -p $DIR

echo "Running Facemc with ${THREADS} threads:"
RUN="mpiexec -n ${THREADS} ${FRENSIE}/bin/facemc-mpi --sim_info=${INFO} --geom_def=${GEOM} --mat_def=${MAT} --resp_def=${RSP} --est_def=${EST} --src_def=${SOURCE} --cross_sec_dir=${CROSS_SECTION_XML_PATH} --simulation_name=${NAME}"
echo ${RUN}
${RUN} > ${DIR}/${NAME}.txt 2>&1

echo "Running Facemc with ${THREADS} threads:"
echo ${RUN}
${RUN} > ${DIR}/${NAME}.txt 2>&1
echo "Moving the results:"

# Move file to the test results folder
H5=${NAME}.h5
NEW_NAME="${DIR}/${H5}"
NEW_RUN_INFO="${DIR}/continue_run_${NAME}.xml"

mv ${H5} ${NEW_NAME}
mv continue_run.xml ${NEW_RUN_INFO}

echo "Results will be in ./${DIR}"
