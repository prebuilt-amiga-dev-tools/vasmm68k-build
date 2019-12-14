#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VASM_VERSION DISTRIBUTION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VASM_VERSION="$2"
DISTRIBUTION="$3"

sudo dpkg -i "${BUILD_RESULTS_DIR}/vasmm68k_${VASM_VERSION}_amd64.${DISTRIBUTION}.deb"
