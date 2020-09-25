#!/bin/sh
default_branch="$1";
submodule_branch="master";#"$2";

if [ "$default_branch" == "" ]; then
    echo "Missing argument 1: Default branch name for this repo.";
    exit 1;
fi;

if ! git status; then
    echo "Must be called from within a git repo.";
    exit 1;
fi;

linter_branch_prefix="PTR-linter-";

# store old the existing branch, index and working tree
diff_files=$(git diff --name-only --ignore-submodules);
diff_all=$(git diff --name-only --ignore-submodules=dirty);
if [ "$diff_files" != "$diff_all" ]; then
    echo "All submodules must be be added to the index before commiting when local linting is enabled."
    exit 1;
fi;
now=$(date);
git stash push --all --keep-index -m "working_tree_$now" > /dev/null;
git stash push --all --keep-index -m "index_$now" > /dev/null;
git reset > /dev/null;
git checkout .;
git clean -f -d;
old_branch=$(git branch --show-current);
git checkout $default_branch;

# create or update the branch with any new Bragi updates
git fetch;
git config pull.rebase false;
linter_branch="$linter_branch_prefix$default_branch";
git checkout "$linter_branch" --;
git checkout -b "$linter_branch";
git checkout "$linter_branch" --;
check_branch=$(git branch --show-current);
if [ "$check_branch" == "$linter_branch" ]; then
    untracked_files=$(git ls-files --others --exclude-standard | grep .github/linters);
    if [ "$untracked_files" != "" ]; then
        # need to manually remove this since the bragi submodule cannot be stashed which may leads to conflicts later when merging in master.
        rm -rf .github/linters;
    fi;
    git checkout .;
    git pull;
    if git merge "origin/$default_branch" -m "merge from origin/$default_branch"; then
        git add .github/linters;
        git commit -n -m "merge from $default_branch";
        git submodule add --force https://github.com/BigVikingGames/Bragi.git .github/linters;
        git submodule update --init .github/linters;
        (
            cd .github/linters || exit 1;
            git fetch;
            git checkout "$submodule_branch";
            git config pull.rebase false;
            git pull;
        )
        .github/linters/scripts/setup-all.sh;
        .github/linters/scripts/setup-local-lint.sh;
        git add .github/linters .github/workflows/linter-workflow.yml;
        git commit -n -m "update the bragi linter submodule";
        git push --set-upstream origin "$linter_branch";
    fi;
fi;

# restore your old original branch, index and working tree
git reset > /dev/null;
git checkout .;
git checkout "$old_branch";
working_tree_stash_num=$(git stash list | grep "working_tree_$now" | sed 's/stash@{\(.*\)}.*/\1/')
if [ -n "$working_tree_stash_num" ]; then
    git checkout "stash@{$working_tree_stash_num}" .;
    git stash drop "stash@{$working_tree_stash_num}" > /dev/null;
fi;
git reset > /dev/null;
index_stash_num=$(git stash list | grep "index_$now" | sed 's/stash@{\(.*\)}.*/\1/')
if [ -n "$index_stash_num" ]; then
    git reset "stash@{$index_stash_num}" > /dev/null; 
    git stash drop "stash@{$index_stash_num}" > /dev/null;
    git reset --soft HEAD~1;
fi;
