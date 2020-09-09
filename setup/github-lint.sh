#!/bin/sh

echo "Setting up github linting.";

# Move to the root of the project
original_pwd=$(pwd);
cd $(dirname $0);
cd ../../..;

if ! test -h .git/hooks/pre-commit; then
    .github/linters/setup/local-lint.sh
fi;

mkdir -p .github/workflows
cp .github/linters/linter-workflow.yml .github/workflows/linter-workflow.yml
git add .github

# Setup the pre commit hook
if ! test -h .git/modules/.github/linters/hooks/post-update; then
    ln -s ../../.github/hooks/local-post-update.sh .git/modules/.github/linters/hooks/post-update;
    chmod 777 .git/modules/.github/linters/hooks/post-update;
fi;

# Restore working directory
cd $original_pwd;
