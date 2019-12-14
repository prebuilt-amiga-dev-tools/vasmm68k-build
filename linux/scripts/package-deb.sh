#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VASM_VERSION DISTRIBUTION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VASM_VERSION="$2"
DISTRIBUTION="$3"

(cd linux && sudo DEBUILD_DPKG_BUILDPACKAGE_OPTS="-r'fakeroot --faked faked-tcp' -us -uc" DEBUILD_LINTIAN_OPTS="-i -I --show-overrides" debuild --no-conf -us -uc)
mkdir -p "${BUILD_RESULTS_DIR}"
cp vasmm68k_"${VASM_VERSION}_amd64.deb" "${BUILD_RESULTS_DIR}/vasmm68k_${VASM_VERSION}_amd64.${DISTRIBUTION}.deb"
rm -f vasmm68k_*
