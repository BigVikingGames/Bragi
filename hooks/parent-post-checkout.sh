#!/bin/sh

if [[ git diff --name-only --ignore-submodules=dirty | grep "\.github/linters" ]]; then
    .github/linters/setup/update-all.sh
fi;
