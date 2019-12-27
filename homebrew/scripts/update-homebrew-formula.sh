#!/bin/bash

set -e

if [ $# -ne 3 ]; then
 echo 1>&2 "Usage: $0 VASM_URL VASM_VERSION SHOULD_COMMIT"
 exit 1
fi

FORMULA=vasmm68k

VASM_URL="$1"
VASM_VERSION="$2"
SHOULD_COMMIT="$3"

if [[ "${VASM_URL}" == "" ]]; then
 echo 1>&2 "VASM_URL must be set"
 exit 1
fi

if [[ "${VASM_VERSION}" == "" ]]; then
 echo 1>&2 "VASM_VERSION must be set"
 exit 1
fi

if [[ "${SHOULD_COMMIT}" == "false" ]]; then
  BUMP_ARGS="--dry-run --write"
elif [[ "${SHOULD_COMMIT}" == "true" ]]; then
  BUMP_ARGS=""
else
 echo 1>&2 "SHOULD_COMMIT must be set to either 'true' or 'false'"
 exit 1
fi

echo "====================== .profile ========================="
test -r ~/.profile && echo ~/.profile

echo "====================== .bash_profile ========================="
test -r ~/.bash_profile && echo ~/.bash_profile

echo "====================== .bashrc ========================="
test -r ~/.bashrc && echo ~/.bashrc

echo "====================== path ========================="
echo $PATH


# Retrieve formula version as a string without surrounding quotes
CURRENT_FORMULA_VERSION=`brew info "${FORMULA}" --json | jq ".[0].versions.stable" | sed "s/\"//g"`

# Only bump formula version, URL & (computed) hash if the formula version differs
#   brew bump-formula-pr only supports bumping when increasing the version number
#
# This will fail when trying to downgrade the vasm version
if [[ "${CURRENT_FORMULA_VERSION}" != "${VASM_VERSION}" ]]; then
    brew bump-formula-pr "--url=${VASM_URL}" "--version=${VASM_VERSION}" ${BUMP_ARGS} "${FORMULA}"
fi
