#!/bin/sh
# This file is named lockwood.sh
#SBATCH --partition=pre
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=40
#SBATCH --cpus-per-task=4

##----------------------------------------------------------------------------##
## ---------------------------- FACEMC test runner ---------------------------##
##----------------------------------------------------------------------------##
## FRENSIE benchmark test: Lockwood dose depth data.
## The dose depth for several ranges and material is calculated by dividing the
## energy deposition by the calorimeter thickness (g/cm^2).
##----------------------------------------------------------------------------##
EXTRA_ARGS=$@

# Set the number of histories
HISTORIES=1000000
# Set the max runtime (in minutes, 1 day = 1440 )
TIME=1400

# These parameters can be set if the cluster is not used
# SLURM_CPUS_PER_TASK=4
# SLURM_NTASKS=1

# Run from the rendezvous
if [ "$#" -eq 1 ]; then
  # Set the rendezvous
  RENDEZVOUS="$1"

  # Restart the simulation
  echo "Restarting Facemc Lockwood test for ${HISTORIES} particles with ${SLURM_NTASKS} MPI processes with ${SLURM_CPUS_PER_TASK} OpenMP threads each!"
  mpiexec -n ${SLURM_NTASKS} python -c "import lockwood; lockwood.runSimulationFromRendezvous(${SLURM_CPUS_PER_TASK}, ${HISTORIES}, ${TIME}, \"${RENDEZVOUS}\" )"

# Run new simulation
else

  # Set the test energy
  ENERGY=0.314

  # Set the data file type (ACE Native)
  FILE_TYPE=Native

  # Set the bivariate interpolation ( LOGLOGLOG LINLINLIN LINLINLOG )
  INTERP=LOGLOGLOG

  # Set the bivariate Grid Policy ( UNIT_BASE_CORRELATED CORRELATED UNIT_BASE )
  GRID_POLICY=UNIT_BASE_CORRELATED

  # Set the elastic distribution mode ( DECOUPLED COUPLED HYBRID )
  MODE=COUPLED

  # Set the elastic coupled sampling method ( ONE_D TWO_D MODIFIED_TWO_D )
  METHOD=MODIFIED_TWO_D

  # Set the material element and zaid
  ELEMENT="Al"; ZAID=13000

  # Set the test number
  TEST_NUMBER=11

  # Set the calorimeter thickness (g/cm2)
  CALORIMETER_THICKNESS=5.050E-03

  # Set the range (g/cm2)
  RANGE=0.0993

  ##--------------------------------------------------------------------------##
  ## ------------------------------- COMMANDS --------------------------------##
  ##--------------------------------------------------------------------------##

  # Create a unique python script and change the parameters
  python_script="lockwood_${SLURM_JOB_ID}"
  cp lockwood.py ${python_script}.py

  # Change the python_script parameters

  # Set the element
  command=s/atom=.*/atom=Data.${ELEMENT}_ATOM\;\ element=\"${ELEMENT}\"\;\ zaid=${ZAID}/
  sed -i "${command}" ${python_script}.py

  # Set the calorimeter thickness
  command=s/calorimeter_thickness=.*/calorimeter_thickness=${CALORIMETER_THICKNESS}/
  sed -i "${command}" ${python_script}.py

  # Set the ranges
  command=s/test_range=.*/test_range=${RANGE}/
  sed -i "${command}" ${python_script}.py

  # Set the energy
  command=s/energy=.*/energy=${ENERGY}/
  sed -i "${command}" ${python_script}.py

  # Set the file type
  command=s/file_type=Data.ElectroatomicDataProperties.*/file_type=Data.ElectroatomicDataProperties.${FILE_TYPE}_EPR_FILE/
  sed -i "${command}" ${python_script}.py

  # Set the interp
  command=s/interpolation=MonteCarlo.*/interpolation=MonteCarlo.${INTERP}_INTERPOLATION/
  sed -i "${command}" ${python_script}.py

  # Set 2D grid policy
  command=s/grid_policy=MonteCarlo.*/grid_policy=MonteCarlo.${GRID_POLICY}_GRID/
  sed -i "${command}" ${python_script}.py

  # Set the elastic distribution mode
  command=s/mode=MonteCarlo.*/mode=MonteCarlo.${MODE}_DISTRIBUTION/
  sed -i "${command}" ${python_script}.py

  # Set the elastic coupled sampling method
  command=s/method=MonteCarlo.*/method=MonteCarlo.${METHOD}_UNION/
  sed -i "${command}" ${python_script}.py

  # Set the test number
  command=s/test_number=.*/test_number=${TEST_NUMBER}/
  sed -i "${command}" ${python_script}.py

  # Create the results directory
  directory=$(python -c "import ${python_script}; ${python_script}.createResultsDirectory()" 2>&1)

  # Get the simulation name
  name=$(python -c "import ${python_script}; name = ${python_script}.getSimulationName(); print name" 2>&1)

  RENDEZVOUS="${name}_rendezvous_0.xml"

  # Run the simulation from the last rendezvous
  if [ -f ${RENDEZVOUS} ]; then

    # Get the last rendezvous
    i=0
    while [ -f "${name}_rendezvous_${i}.xml" ]; do
      RENDEZVOUS="${name}_rendezvous_${i}.xml"
      i=$[$i+1]
    done

    # Run the simulation from the last rendezvous
    echo "Running Facemc Lockwood test with ${HISTORIES} particles with ${SLURM_NTASKS} MPI processes with ${SLURM_CPUS_PER_TASK} OpenMP threads each from the rendezvous '${RENDEZVOUS}'!"
    mpiexec -n ${SLURM_NTASKS} python -c "import ${python_script}; ${python_script}.runSimulationFromRendezvous(${SLURM_CPUS_PER_TASK}, ${HISTORIES}, ${TIME}, '${RENDEZVOUS}' )"
  else
    # Run the simulation from the start
    echo "Running Facemc Lockwood test with ${HISTORIES} particles with ${SLURM_NTASKS} MPI processes with ${SLURM_CPUS_PER_TASK} OpenMP threads each!"
    mpiexec -n ${SLURM_NTASKS} python -c "import ${python_script}; ${python_script}.runSimulation(${SLURM_CPUS_PER_TASK}, ${HISTORIES}, ${TIME})"
  fi

  # Remove the temperary python script
  rm ${python_script}.py*
fi

  # Move the slurm file to the results directory
  mv slurm-${SLURM_JOB_ID}.out ./${directory}