#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VASM_VERSION DISTRIBUTION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VASM_VERSION="$2"
DISTRIBUTION="$3"

sudo dpkg -i "${BUILD_RESULTS_DIR}/vasmm68k_${VASM_VERSION}_amd64.${DISTRIBUTION}.deb"

mkdir -p "${BUILD_RESULTS_DIR}/temp"

vasmm68k_mot -Fhunk -o "${BUILD_RESULTS_DIR}/temp/test_mot.o" tests/test_mot.s && cmp tests/test_mot.o.expected "${BUILD_RESULTS_DIR}/temp/test_mot.o" || exit 1
vasmm68k_std -Fhunk -o "${BUILD_RESULTS_DIR}/temp/test_std.o" tests/test_std.s && cmp tests/test_std.o.expected "${BUILD_RESULTS_DIR}/temp/test_std.o" || exit 1
vobjdump tests/test_vobjdump.o > "${BUILD_RESULTS_DIR}/temp/test_vobjdump.dis" && cmp tests/test_vobjdump.dis.expected "${BUILD_RESULTS_DIR}/temp/test_vobjdump.dis" || exit 1

rm -rf "${BUILD_RESULTS_DIR}/temp"

sudo dpkg -r vasmm68k

