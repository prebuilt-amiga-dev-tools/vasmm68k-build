#!/bin/bash

# Example commandlines:
# ./linux/scripts/create-global-environment-variables-script.sh build_results refs/heads/feature-branch prebuilt-amiga-dev-tools/vasmm68k false
# ./linux/scripts/create-global-environment-variables-script.sh build_results refs/tags/releases/1.8f prebuilt-amiga-dev-tools/vasmm68k true

if [ $# -ne 4 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR GITHUB_REF GITHUB_REPOSITORY IS_RELEASE"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
GITHUB_REF="$2"
GITHUB_REPOSITORY="$3"
IS_RELEASE="$4"

OUTPUT_FILE_SHELL="${BUILD_RESULTS_DIR}/global-environment-variables.sh"
OUTPUT_FILE_POWERSHELL="${BUILD_RESULTS_DIR}/global-environment-variables.ps1"

mkdir -p "${BUILD_RESULTS_DIR}"

echo "" > ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=SOURCE_NAME::${GITHUB_REF#refs/*/}" >> ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=SOURCE_BRANCH::${GITHUB_REF#refs/heads/}" >> ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=SOURCE_TAG::${GITHUB_REF#refs/tags/}" >> ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=SOURCE_VERSION::${GITHUB_REF#refs/tags/releases/}" >> ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=SOURCE_ORGANIZATION::$(echo ${GITHUB_REPOSITORY} | cut -d / -f 1)" >> ${OUTPUT_FILE_SHELL}
echo "echo ::set-output name=BUILD_TYPE::$( if [[ ${IS_RELEASE} != 'false' ]]; then echo 'RELEASE'; else echo 'NIGHTLY'; fi)" >> ${OUTPUT_FILE_SHELL}
chmod ugo+x ${OUTPUT_FILE_SHELL}
cp ${OUTPUT_FILE_SHELL} ${OUTPUT_FILE_POWERSHELL}
