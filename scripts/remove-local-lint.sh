#!/bin/sh

echo "Removing local linting.";

# Move to the root of Bragi
original_pwd=$(pwd);
cd $(dirname $0);

rm ../../../.git/hooks/pre-commit

# Restore working directory
cd $original_pwd;
