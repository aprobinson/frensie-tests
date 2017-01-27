#!/bin/bash
##---------------------------------------------------------------------------##
## FACEMC test runner
##---------------------------------------------------------------------------##
## Validation runs comparing FRENSIE and MCNP.
## The electron angular distribution for a thin gold foil of .0009658 cm.
## The # of particles per steradian for scattering angle is found by dividing
## the surface current by 2pi * ( \mu_{i} - \mu_{i-1} ) where \mu_{0} is the
## lowest cosine bin (ie: -1). Surface current is needed so DagMC will be used.
## The #/steradians can be changed to #/square degree by multiplying by
## (pi/180)^2.
## FRENSIE will be run with three variations.
## 1. Using ACE data, which should match MCNP almost exactly.
## 2. Using the Native data in analog mode, whcih uses a different interpolation
## scheme than MCNP.
## 3. Using Native data in moment preserving mode, which should give a less
## acurate answer while decreasing run time.
##---------------------------------------------------------------------------##

# Set cross_section.xml directory path.
EXTRA_ARGS=$@
CROSS_SECTION_XML_PATH=/home/software/mcnpdata/
FRENSIE=/home/lkersting/research/frensie-repos/lkersting
#FRENSIE=/home/lkersting/frensie

THREADS="12"
if [ "$#" -eq 1 ];
then
    # Set the number of threads used
    THREADS="$1"
fi

# Changing variables
ELEMENT="Au"
# Number of histories 1e6
HISTORIES="10"

ENERGY="15.7"
NAME="ace"

echo -n "Enter the desired data type (1 = ACE, 2 = Native, 3 = Moment Preserving) > "
read INPUT
if [ ${INPUT} -eq 1 ]
then
    # Use ACE data
    NAME="ace"
    python sim_info.py -n ${HISTORIES} -c 1.0
    python mat.py -n ${ELEMENT} -t ${NAME}
    MAT="mat_ace.xml"
    echo "Using ACE data!"
elif [ ${INPUT} -eq 2 ]
then
    # Use Native analog data
    NAME="native"
    python sim_info.py -n ${HISTORIES} -c 1.0
    python mat.py -n ${ELEMENT} -t "linlin"
    MAT="mat.xml"
    echo "Using Native analog data!"
elif [ ${INPUT} -eq 3 ]
then
    # Use Native Moment Preserving data
    NAME="moments"
    python sim_info.py -n ${HISTORIES} -c 0.9
    python mat.py -n ${ELEMENT} -t "linlin"
    MAT="mat.xml"
    echo "Using Native Moment Preserving data!"
else
    # Default to ACE data
    python sim_info.py -n ${HISTORIES} -c 1.0
    python mat.py -n ${ELEMENT} -t ${NAME}
    MAT="mat_ace.xml"
    echo "Input not valid, ACE data will be used!"
fi

# .xml file paths.
python geom.py -t DagMC
python est.py
python source.py
EST="est.xml"
SOURCE="source.xml"
INFO="sim_info.xml"
GEOM="geom.xml"
SOURCE="source.xml"
RSP="../rsp_fn.xml"
NAME="hanson_lin_${NAME}"

# Make directory for the test results
TODAY=$(date +%Y-%m-%d)
DIR="results/${TODAY}"
mkdir -p $DIR

echo "Running Facemc Hanson test with ${THREADS} threads:"
RUN="${FRENSIE}/bin/facemc --sim_info=${INFO} --geom_def=${GEOM} --mat_def=${MAT} --resp_def=${RSP} --est_def=${EST} --src_def=${SOURCE} --cross_sec_dir=${CROSS_SECTION_XML_PATH} --simulation_name=${NAME} --threads=${THREADS}"
echo ${RUN}
${RUN} > ${DIR}/${NAME}.txt 2>&1

echo "Processing the results:"

H5=${NAME}.h5
NEW_NAME="${DIR}/${H5}"
NEW_RUN_INFO="${DIR}/continue_run_${NAME}.xml"
mv ${H5} ${NEW_NAME}
mv continue_run.xml ${NEW_RUN_INFO}

cd ${DIR}

bash ../../data_processor.sh ${NAME}
echo "Results will be in ./${DIR}"

