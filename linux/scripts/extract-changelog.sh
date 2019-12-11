#!/bin/bash

VASM_VERSION=$1

# Extract changelog as text file
cp vasm/history build_results/changelog.txt
awk "/- ${VASM_VERSION}/{flag=1} /^- /{flag=0} flag" vasm/history > build_results/changelog-for-version.txt

# Convert changelog to markdown
sed "s/^- /# /g; s/^o /* /g; s/\\\\/\\\\\\\\/g; s/_/\\\\_/g; s/</\\\\</g; s/>/\\\\>/g; s/[/\\\\[/g; s/]/\\\\]/g" build_results/changelog.txt > build_results/changelog.md
sed "s/^- /# /g; s/^o /* /g; s/\\\\/\\\\\\\\/g; s/_/\\\\_/g; s/</\\\\</g; s/>/\\\\>/g; s/[/\\\\[/g; s/]/\\\\]/g" build_results/changelog-for-version.txt > build_results/changelog-for-version.md
