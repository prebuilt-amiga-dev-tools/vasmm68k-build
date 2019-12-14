#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 VASM_URL VASM_DOC_URL VASM_VERSION"
  exit 1
fi

echo "" > Config.mk
echo "VASM_URL = \"$1\"" >> Config.mk
echo "VASM_DOC_URL = \"$2\"" >> Config.mk
echo "VASM_VERSION = \"$3\"" >> Config.mk
