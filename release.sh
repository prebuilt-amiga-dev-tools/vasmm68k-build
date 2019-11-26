#!/bin/bash

VASM_VERSION=$1

git fetch

# Disallow release creation if there are any local changes

if [[ `git status --porcelain` ]]; then
    echo "There are local changes. Cannot create release."
    exit 1
fi

# Disallow release creation if the tag exists either locally or remotely

if [[ `git tag -l releases/${VASM_VERSION}` ]]; then
    echo "The releases/${VASM_VERSION} tag already exists locally. Cannot create release."
    exit 1
fi

if [[ `git ls-remote origin refs/tags/releases/${VASM_VERSION}` ]]; then
    echo "The releases/${VASM_VERSION} tag already exists in origin. Cannot create release."
    exit 1
fi

# Disallow release creation if local & remote branches are not in sync
# Lifted from http://www.devquestions.com/bash-check-if-pull-needed-in-git

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [[ ${LOCAL} == ${REMOTE} ]]; then
#    echo "Local and remote are in sync, release allowed."
elif [[ ${LOCAL} = ${BASE} ]]; then
    echo "There are incoming changes. Cannot create release."
    exit 1
elif [[ ${REMOTE} = ${BASE} ]]; then
    echo "There are outgoing changes. Please push first, then create release."
    exit 1
else
    echo "Local and remote branches have diverged. Cannot create release."
    exit 1
fi

# Create release

git tag releases/${VASM_VERSION}
git push origin releases/${VASM_VERSION}
