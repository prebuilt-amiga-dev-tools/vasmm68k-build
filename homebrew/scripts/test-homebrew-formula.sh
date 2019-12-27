#!/bin/bash

set -e

if [ $# -ne 0 ]; then
 echo 1>&2 "Usage: $0"
 exit 1
fi

FORMULA=vasmm68k

brew audit ${FORMULA}
brew install ${FORMULA}
brew test ${FORMULA}
brew uninstall ${FORMULA}
