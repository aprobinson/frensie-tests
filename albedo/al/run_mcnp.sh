#!/bin/bash
##---------------------------------------------------------------------------##
## MCNP6 test runner
##---------------------------------------------------------------------------##

# Set cross_section.xml directory path.
EXTRA_ARGS=$@
MCNP6=/home/software/mcnp6.1.1/bin/mcnp611_linux_x86_64_omp
CROSS_SECTION_XML_PATH=/home/software/mcnpdata/
TODAY=$(date +%Y-%m-%d)
OUTPUT_DIR="./results/${TODAY}/"

THREADS="8"
if [ "$#" -eq 1 ];
then
    # Set the number of threads used
    THREADS="$1"
fi

# Set the input file name
ENERGY="10000" #source energy in eV
NAME="mcnp.in"
OUTPUT="mcnp_${ENERGY}"

mkdir -p $OUTPUT_DIR

echo "Running MCNP6:"
echo "${MCNP6} i=${NAME} n=${OUTPUT}. tasks ${THREADS}"
${MCNP6} i=${NAME} n=${OUTPUT}. tasks ${THREADS}

NEW_NAME=${OUTPUT_DIR}${OUTPUT}

# Move output files to test directory
mkdir -p $OUTPUT_DIR
mv ${OUTPUT}.o ${NEW_NAME}.o
mv ${OUTPUT}.r ${NEW_NAME}.r
mv ${OUTPUT}.m ${NEW_NAME}.m


# Move to output directory
cd ${OUTPUT_DIR}

echo "Processing the results:"
python ../../../mcnp_data_processor.py -f ${OUTPUT}
echo "The processed data is located at: ${OUTPUT_DIR}"
