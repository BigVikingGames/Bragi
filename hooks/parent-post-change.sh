#!/bin/sh

if git diff --name-only --ignore-submodules=dirty | grep "\.github/linters"; then
    if [[ "$1" != "$2" ]]; then
        git submodule update .github/linters;
    fi;
    bash -c ".github/linters/scripts/setup-all.sh";
    exit $?;
fi;
