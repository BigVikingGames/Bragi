#!/bin/sh

echo "Updating github linting.";

# Move to the root of the project
original_pwd=$(pwd);
cd $(dirname $0);
cd ../../..;

mkdir -p .github/workflows
cp .github/linters/linter-workflow.yml .github/workflows/linter-workflow.yml
git add .github

# Setup the pre commit hook
if ! test -h .git/modules/.github/linters/hooks/post-merge; then
    ln -s ../../../../../.github/linters/hooks/local-post-merge.sh .git/modules/.github/linters/hooks/post-merge;
    chmod 777 .git/modules/.github/linters/hooks/post-merge;
fi;

# Restore working directory
cd $original_pwd;
