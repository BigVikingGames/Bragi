#!/bin/sh

echo "Updating github linting.";

# Move to the root of Bragi
original_pwd=$(pwd);
cd $(dirname $0);

echo $(pwd);

setup/github-lint.sh

# Only update the local linter if the user has it turned on by running local-lint.sh at least once
if test -h ../../../.git/hooks/pre-commit; then
    setup/local-lint.sh
fi;

# Restore working directory
cd $original_pwd;
