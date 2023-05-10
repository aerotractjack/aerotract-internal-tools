#!/bin/bash

# setup GDAL for GIS software
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal

# terraform autocomplete
terraform -install-autocomplete 2> /dev/null
