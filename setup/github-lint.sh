#!/bin/sh

echo "Updating github linting.";

# Move to the root of the project
original_pwd=$(pwd);
cd $(dirname $0);
cd ../../..;

# Ensure the github action workflow file is up to date
mkdir -p .github/workflows
cp .github/linters/linter-workflow.yml .github/workflows/linter-workflow.yml
git add ./.github

# Setup the post merge hooks to automatically update
rm .git/modules/.github/linters/hooks/post-merge;
ln -s ../../../../../.github/linters/hooks/local-post-merge.sh .git/modules/.github/linters/hooks/post-merge;
chmod 777 .git/modules/.github/linters/hooks/post-merge;

rm .git/hooks/post-merge;
ln -s ../../.github/linters/hooks/parent-post-merge.sh .git/hooks/post-merge;
chmod 777 .git/hooks/post-merge;

# Setup the post checkout hooks to automatically update
rm .git/modules/.github/linters/hooks/post-checkout;
ln -s ../../../../../.github/linters/hooks/local-post-checkout.sh .git/modules/.github/linters/hooks/post-checkout;
chmod 777 .git/modules/.github/linters/hooks/post-checkout;

rm .git/hooks/post-checkout;
ln -s ../../.github/linters/hooks/parent-post-checkout.sh .git/hooks/post-checkout;
chmod 777 .git/hooks/post-checkout;

# Restore working directory
cd $original_pwd;
