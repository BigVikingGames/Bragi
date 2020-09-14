#!/bin/sh

if git diff --name-only --ignore-submodules=dirty | grep "\.github/linters"; then
    git submodule update .github/linters
    .github/linters/setup/update-all.sh
fi;
