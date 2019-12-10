#!/bin/bash

VASM_VERSION=$1

cp vasm/history build_results/changelog
awk "/^- /{flag=0} /- ${VASM_VERSION}/{flag=1} flag" vasm/history > build_results/changelog-for-version
