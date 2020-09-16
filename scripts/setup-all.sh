#!/bin/sh

# Move to the setup folder of Bragi
original_pwd=$(pwd);
cd $(dirname $0);

./setup-github-lint.sh

# Only update the local linter if the user has it turned on by running local-lint.sh at least once
if test -e ../../../.git/hooks/pre-commit; then
    ./setup-local-lint.sh
fi;

# Restore working directory
cd $original_pwd;
