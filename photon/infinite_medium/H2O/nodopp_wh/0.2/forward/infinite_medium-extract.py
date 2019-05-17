#!/usr/bin/python
import sys, os
from optparse import *
sys.path.append(os.path.join(os.path.dirname(__file__), '../../..'))
from infinite_medium_extract_estimator import extractEstimatorData

if __name__ == "__main__":

    # Parse the command line arguments
    parser = OptionParser()
    parser.add_option("--rendezvous_file", type="string", dest="rendezvous_file",
                      help="the rendezvous file to load")
    parser.add_option("--estimator_id", type="int", dest="estimator_id",
                      help="the estimator id to use")
    parser.add_option("--entity_id", type="int", dest="entity_id",
                      help="the entity id to use")
    parser.add_option("--adjoint", action="store_true", dest="is_adjoint", default=False,
                      help="the data was generated in an adjoint simulation")
    options,args = parser.parse_args()

    # Extract the estimator data
    extractEstimatorData( options.rendezvous_file,
                          options.estimator_id,
                          options.entity_id,
                          options.is_adjoint )