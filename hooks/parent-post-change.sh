#!/bin/sh

echo "merge or checkout $0 upstream: $1 current: $2";
if git diff --name-only --ignore-submodules=dirty | grep "\.github/linters"; then
    if [[ "$1" -ne "$2" ]]; then
        git submodule update .github/linters
    fi;
    .github/linters/setup/update-all.sh
fi;
