#! /usr/bin/env python
import argparse as ap
import xml.etree.ElementTree as ET
from ElementTree_pretty import prettify


# Set up the argument parser
description = "This script allows one to write the mat.xml file for FACEMC. "\
              "The input parameter is the source energy."

parser = ap.ArgumentParser(description=description)

element_msg = "the elemental symbol (ie: H, He, Al, Pb ). Must be properly capitalized (ie: Al not al or AL"
parser.add_argument('-n', help=element_msg, required=True)

file_type_msg = "the file type (ace, native, linlin )"
parser.add_argument('-t', help=file_type_msg, required=True)


# Parse the user's arguments
user_args = parser.parse_args()
element_symbol = user_args.n
file_type = user_args.t

filename = "{" + element_symbol

if file_type == "ace":
  filename += "}"
elif file_type == "native":
  filename += "-Native}"
elif file_type == "linlin":
  filename += "-LinLin}"

root = ET.Element("ParameterList", name="Materials")

parameter_1 = ET.SubElement(root, "ParameterList", name=element_symbol)

ET.SubElement(parameter_1, "Parameter", name="Id", type="unsigned int", value="1")

ET.SubElement(parameter_1, "Parameter", name="Fractions", type="Array", value="{1.0}")

ET.SubElement(parameter_1, "Parameter", name="Isotopes", type="Array(string)", value=filename)

if file_type == "ace":
  prettify(root,"mat_ace.xml")
elif file_type == "native":
  prettify(root,"mat.xml")
elif file_type == "linlin":
  prettify(root,"mat_lin.xml")
