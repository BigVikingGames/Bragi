#!/bin/sh

echo "merge or checkout $0";
if git diff --name-only --ignore-submodules=dirty | grep "\.github/linters"; then
    git submodule update .github/linters
    .github/linters/setup/update-all.sh
fi;
