#!/bin/bash

if [ $# -ne 3 ]; then
 echo 1>&2 "Usage: $0 VASM_URL VASM_DOC_URL VASM_VERSION"
 exit 1
fi

VASM_URL="$1"
VASM_DOC_URL="$2"
VASM_VERSION="$3"

git fetch

# Disallow config update if there are any local changes

if [[ `git status --porcelain` ]]; then
    echo "There are local changes. Cannot update config."
    exit 1
fi

# Disallow config update if the tag exists either locally or remotely

if [[ `git tag -l releases/${VASM_VERSION}` ]]; then
    echo "The releases/${VASM_VERSION} tag already exists locally. Cannot update config."
    exit 1
fi

if [[ `git ls-remote origin refs/tags/releases/${VASM_VERSION}` ]]; then
    echo "The releases/${VASM_VERSION} tag already exists in origin. Cannot update config."
    exit 1
fi

# Disallow config update if local & remote branches are not in sync
# Lifted from http://www.devquestions.com/bash-check-if-pull-needed-in-git

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [[ ${LOCAL} == ${REMOTE} ]]; then
#    echo "Local and remote are in sync, config update allowed."
    :
elif [[ ${LOCAL} = ${BASE} ]]; then
    echo "There are incoming changes. Cannot update config."
    exit 1
elif [[ ${REMOTE} = ${BASE} ]]; then
    echo "There are outgoing changes. Please push first, then update config."
    exit 1
else
    echo "Local and remote branches have diverged. Cannot update config."
    exit 1
fi

echo "" > Config.mk
echo "VASM_URL = ${VASM_URL}" >> Config.mk
echo "VASM_DOC_URL = ${VASM_DOC_URL}" >> Config.mk
echo "VASM_VERSION = ${VASM_VERSION}" >> Config.mk

git add .
git commit -m "Updated config.mk to version ${VASM_VERSION}"
git push
