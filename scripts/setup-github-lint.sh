#!/bin/sh

echo "Updating github linting."

# Move to the root of the project
original_pwd=$(pwd)
cd "$(dirname "$0")" || exit 1
cd ../../.. || exit 1

# Ensure the github action workflow file is up to date
mkdir -p .github/workflows
cp .github/linters/linter-workflow.yml .github/workflows/linter-workflow.yml

# Setup the post merge hooks to automatically update
rm .git/modules/.github/linters/hooks/post-merge 2>/dev/null
cp .github/linters/hooks/local-post-change.sh .git/modules/.github/linters/hooks/post-merge
chmod 777 .git/modules/.github/linters/hooks/post-merge

rm .git/hooks/post-merge 2>/dev/null
cp .github/linters/hooks/parent-post-change.sh .git/hooks/post-merge
chmod 777 .git/hooks/post-merge

# Setup the post checkout hooks to automatically update
rm .git/modules/.github/linters/hooks/post-checkout 2>/dev/null
cp .github/linters/hooks/local-post-change.sh .git/modules/.github/linters/hooks/post-checkout
chmod 777 .git/modules/.github/linters/hooks/post-checkout

rm .git/hooks/post-checkout 2>/dev/null
cp .github/linters/hooks/parent-post-change.sh .git/hooks/post-checkout
chmod 777 .git/hooks/post-checkout

# Restore working directory
cd "$original_pwd" || exit 1
