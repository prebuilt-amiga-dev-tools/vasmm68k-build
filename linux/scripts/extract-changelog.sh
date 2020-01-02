#!/bin/bash

if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 BUILD_RESULTS_DIR VASM_VERSION"
  exit 1
fi

BUILD_RESULTS_DIR="$1"
VASM_VERSION="$2"

######################################################################################

function convert_multiline_paragraphs_to_single_line_paragraphs() {

# Converts a section like this:
#
#   o This is the 1st paragraph.
#   o This is the 2nd paragraph. It
#     uses 2 spaces indentation to
#     differentiate from the start
#     of the next paragraph.
#   o This is the 3rd paragraph.
#
# Into this:
#
#   o This is the 1st paragraph.
#   o This is the 2nd paragraph. It uses 2 spaces indentation to differentiate from the start of the next paragraph.
#   o This is the 3rd paragraph.

    tr "\n" "\377"                  | # Translate all newlines to \xff; this turns the entire document to a single-line string
    sed "s/\xff  / /g"              | # Translate all \xff followed by spaces to a single space; this converts what used to be multi-line paragraphs into single-line paragraphs
    sed "s/\xff/\n/g"                 # Translate all \xff to newlines; this turns the document back to multi-line format
}

######################################################################################

function convert-text-to-markdown() {

# Converts a section like this:
#
# - 1.8f (2019.02.14)
# o The latest version [v1.8f] marks the 10 year anniversary \o/
# o It is a a <<< very >>> marked improvement
#
# Into this:
#
# # 1.8f (2019.02.14)
# * The latest version \[v1.8f\] marks the 10 year anniversary \\o/
# * It is a a \<\<\< very \>\>\> marked improvement

    sed "s/^- /# /g"                | # Translate dashes to heading markers
    sed "s/^o /* /g"                | # Translate 'o' into bullet markers
    sed "s/\\\\/\\\\\\\\/g"         | # Escape backslashes
    sed "s/_/\\\\_/g"               | # Escape underscores
    sed "s/</\\\\</g"               | # Escape left arrows
    sed "s/>/\\\\>/g"               | # Escape right arrows
    sed "s/\\[/\\\\[/g"             | # Escape opening brackets
    sed "s/\\]/\\\\]/g"               # Escape closing brackets
}

######################################################################################

mkdir -p "${BUILD_RESULTS_DIR}"

# Extract changelog as text file
cp vasm/history ${BUILD_RESULTS_DIR}/changelog.txt
awk "/^- ${VASM_VERSION}/{flag=1; next} /^$/{flag=0} flag" vasm/history > ${BUILD_RESULTS_DIR}/changelog-for-version.txt

# Convert changelog to markdown
cat ${BUILD_RESULTS_DIR}/changelog.txt | convert_multiline_paragraphs_to_single_line_paragraphs | convert-text-to-markdown > ${BUILD_RESULTS_DIR}/changelog.md
cat ${BUILD_RESULTS_DIR}/changelog-for-version.txt | convert_multiline_paragraphs_to_single_line_paragraphs | convert-text-to-markdown > ${BUILD_RESULTS_DIR}/changelog-for-version.md
