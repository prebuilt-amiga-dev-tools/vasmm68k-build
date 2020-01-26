#!/bin/bash

if [ $# -ne 2 ]; then
 echo 1>&2 "Usage: $0 VASM_RELEASE_URL VASM_RELEASE_VERSION"
 exit 1
fi

VASM_RELEASE_URL="$1"
VASM_RELEASE_VERSION="$2"

git fetch

# Disallow config update if there are any local changes

if [[ `git status --porcelain` ]]; then
    echo "There are local changes. Cannot update config."
    exit 1
fi

# Disallow config update if the tag exists either locally or remotely

if [[ `git tag -l releases/${VASM_RELEASE_VERSION}` ]]; then
    echo "The releases/${VASM_RELEASE_VERSION} tag already exists locally. Cannot update config."
    exit 1
fi

if [[ `git ls-remote origin refs/tags/releases/${VASM_RELEASE_VERSION}` ]]; then
    echo "The releases/${VASM_RELEASE_VERSION} tag already exists in origin. Cannot update config."
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

sed "s/^VASM_RELEASE_URL = \(.*\)/VASM_RELEASE_URL = ${VASM_RELEASE_URL}/; s/^VASM_RELEASE_VERSION = \(.*\)/VASM_RELEASE_VERSION = ${VASM_RELEASE_VERSION}/" < Config.mk > Config.mk2
cp Config.mk2 Config.mk
rm Config.mk2

git add .
git commit -m "Updated config.mk to version ${VASM_RELEASE_VERSION}"
git push
