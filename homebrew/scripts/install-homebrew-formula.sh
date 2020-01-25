#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo 1>&2 "Usage: $0 BUILD_TYPE"
    exit 1
fi

BUILD_TYPE="$1"

FORMULA=vasmm68k

if [[ ${BUILD_TYPE} == "RELEASE" ]]; then
    INSTALL_OPTIONS=""
elif [[ ${BUILD_TYPE} == "NIGHTLY" ]]; then
    INSTALL_OPTIONS="--HEAD"
else
    echo 1>&2 "BUILD_TYPE must be set to RELEASE or NIGHTLY"
    exit 1
fi

brew install ${FORMULA} ${INSTALL_OPTIONS}
