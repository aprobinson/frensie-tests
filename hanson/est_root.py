#! /usr/bin/env python
import argparse as ap
import xml.etree.ElementTree as ET
from ElementTree_pretty import prettify

# Set up the argument parser
description = "This script allows one to write the est.xml file for FACEMC."

root = ET.Element("ParameterList", name="Estimators")

parameter_1 = ET.SubElement(root, "ParameterList", name="Transmission Current")

ET.SubElement(parameter_1, "Parameter", name="Id", type="unsigned int", value="1")
ET.SubElement(parameter_1, "Parameter", name="Type", type="string", value="Cell Pulse Height")
ET.SubElement(parameter_1, "Parameter", name="Particle Type", type="string", value="Electron")
ET.SubElement(parameter_1, "Parameter", name="Cells", type="Array", value="{2}")

sub_list_1 = ET.SubElement(parameter_1, "ParameterList", name="Bins")
ET.SubElement(sub_list_1, "Parameter", name="Cosine Bins", type="Array", value="{\
-1.0,\
 0.0,\
 0.939692620785908,\
 0.965925826289068,\
 0.984807753012208,\
 0.990268068741570,\
 0.994521895368273,\
 0.995396198367179,\
 0.996194698091746,\
 0.996917333733128,\
 0.997564050259824,\
 0.998134798421867,\
 0.998629534754574,\
 0.999048221581858,\
 0.999390827019096,\
 0.999657324975557,\
 0.999847695156391,\
 0.999961923064171,\
 1.0}")

parameter_2 = ET.SubElement(root, "ParameterList", name="Reflection Current")

ET.SubElement(parameter_2, "Parameter", name="Id", type="unsigned int", value="2")
ET.SubElement(parameter_2, "Parameter", name="Type", type="string", value="Cell Pulse Height")
ET.SubElement(parameter_2, "Parameter", name="Particle Type", type="string", value="Electron")
ET.SubElement(parameter_2, "Parameter", name="Cells", type="Array", value="{3}")

sub_list_2 = ET.SubElement(parameter_2, "ParameterList", name="Bins")
ET.SubElement(sub_list_2, "Parameter", name="Cosine Bins", type="Array", value="{-1.0, -0.999999, 1.0}")


parameter_3 = ET.SubElement(root, "ParameterList", name="Cell Track Length Flux Estimator")

ET.SubElement(parameter_3, "Parameter", name="Id", type="unsigned int", value="3")
ET.SubElement(parameter_3, "Parameter", name="Type", type="string", value="Cell Track-Length Flux")
ET.SubElement(parameter_3, "Parameter", name="Particle Type", type="string", value="Electron")
ET.SubElement(parameter_3, "Parameter", name="Cells", type="Array", value="{1}")

sub_list_3 = ET.SubElement(parameter_3, "ParameterList", name="Bins")
ET.SubElement(sub_list_3, "Parameter", name="Energy Bins", type="Array", value="{1.5e-5, 99l, 15.7")


prettify(root,"est.xml")

