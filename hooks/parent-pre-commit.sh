#!/bin/sh

# keep track of both the working tree and index
git stash save --keep-index "working_tree" > /dev/null;
git stash save --keep-index "index" > /dev/null;

# runs a custom lint function aginst a set of files
# $1 - regex for the file extensions used for this linter pass
# $2 - custom lint command
linter_exit_code=0;
function lint {
    git diff-index --cached HEAD 2>&1 | sed $'s/^:.*\t//' | grep [.]$1$ | uniq | xargs $2;
    linter_exit_code=$(($linter_exit_code + $?));
}

# runs a custom linter fix function aginst a set of files
# $1 - regex for the file extensions used for this linter pass
# $2 - custom linter fix command
function fix {
    git diff-index --cached HEAD 2>&1 | sed $'s/^:.*\t//' | grep [.]$1$ | uniq | xargs $2 &> /dev/null;
}

# java lint
lint java 'checkstyle -c .github/linters/sun_checks.xml';

# javascript + typescript lint
lint '(jsx?)|(tsx?)' 'npx eslint -c .github/linters/.eslintrc.yml';

# php lint
lint php 'phpcs -standard=.github/linters/phpcs.xml';

# json lint
lint json 'npx jsonlint -q';

# css lint
lint css 'npx stylelint --config .github/linters/.stylelintrc.json';

# html lint
lint html 'npx htmlhint --config .github/linters/.htmlhintrc';

# ansible lint
lint yml 'yamllint -c .github/linters/.yaml-lint.yml'

# restore both the working tree and index
git reset > /dev/null;
git checkout .;
git checkout stash@{1} .;
git reset > /dev/null;
git reset stash@{0} > /dev/null;
git reset --soft HEAD~1;
git stash drop > /dev/null;
git stash drop > /dev/null;

# Automatically fix the files in our working tree
# no automatic java fix
# javascript + typescript fix
fix '(jsx?)|(tsx?)' 'npx eslint -c .github/linters/.eslintrc.yml --fix';
# php fix
fix php 'phpcbf -standard=.github/linters/phpcs.xml';
# json fix
fix json 'npx jsonlint -i';
# no automatic css fix
# no automatic html fix
# no automatic yml fix

# any accumulated non zero exit codes means at least one linter failed
if (($linter_exit_code > 0)); then
    exit 1;
fi
