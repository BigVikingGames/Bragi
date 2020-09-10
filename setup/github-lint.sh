#!/bin/sh

echo "Updating github linting.";

# Move to the root of the project
original_pwd=$(pwd);
cd $(dirname $0);
cd ../../..;

mkdir -p .github/workflows
cp .github/linters/linter-workflow.yml .github/workflows/linter-workflow.yml
echo $(pwd);
git add ./.github

# Setup the post merge hooks
rm .git/modules/.github/linters/hooks/post-merge;
ln -s ../../../../../.github/linters/hooks/local-post-merge.sh .git/modules/.github/linters/hooks/post-merge;
chmod 777 .git/modules/.github/linters/hooks/post-merge;

rm .git/hooks/post-merge;
ln -s ../../.github/linters/hooks/parent-post-merge.sh .git/hooks/post-merge;
chmod 777 .git/hooks/post-merge;

# Restore working directory
cd $original_pwd;
