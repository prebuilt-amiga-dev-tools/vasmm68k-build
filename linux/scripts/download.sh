#!/bin/bash

if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 VASM_URL VASM_DOC_URL"
  exit 1
fi

VASM_URL="$1"
VASM_DOC_URL="$2"

wget -O vasm.tar.gz "${VASM_URL}"
tar -xvf vasm.tar.gz
rm vasm.tar.gz

wget -O vasm/vasm.pdf "${VASM_DOC_URL}"

