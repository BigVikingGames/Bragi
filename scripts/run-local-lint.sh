#!/bin/sh

# keep track of both the working tree and index
diff_files=$(git diff --name-only --ignore-submodules);
diff_all=$(git diff --name-only --ignore-submodules=dirty);
if [ "$diff_files" != "$diff_all" ]; then
	echo "All submodules must be be added to the index before commiting when local linting is enabled."
	exit 1;
fi;

now=$(date);
git stash push --keep-index -m "working_tree_$now" > /dev/null;
git stash push --keep-index -m "index_$now" > /dev/null;

# OSX and GNU xargs behave different by default
xargs_command="xargs";
if echo check | xargs --no-run-if-empty > /dev/null 2> /dev/null; then
	xargs_command="$xargs_command  --no-run-if-empty";
fi;

# runs a custom lint function aginst a set of files
# $1 - regex for the file extensions used for this linter pass
# $2 - custom lint command
# $3 - working directory wile linting
linter_exit_code=0;
lint () {
	cwd=$(pwd);

	cd "$3" || exit 1;
	xargs_lint_command="$xargs_command $2";
	git diff-index --cached HEAD 2>&1 | sed "s/^:.*	//" | grep "[.]$1$" | uniq | sed "s@^@$cwd/@" | $xargs_lint_command;
	linter_exit_code=$((linter_exit_code + $?));

	cd "$cwd" || exit 1;
}

# runs a custom linter fix function aginst a set of files
# $1 - regex for the file extensions used for this linter pass
# $2 - custom linter fix command
# $3 - working directory wile linting
fix () {
	cwd=$(pwd);

	cd "$3" || exit 1;
	xargs_fix_command="$xargs_command $2";
	git diff-index --cached HEAD 2>&1 | sed "s/^:.*	//" | grep "[.]$1$" | uniq | sed "s@^@$cwd/@" | $xargs_fix_command > /dev/null 2> /dev/null;

	cd "$cwd" || exit 1;
}

# java lint
lint java 'checkstyle -c .github/linters/sun_checks.xml' .;

# javascript + typescript lint
lint '(jsx?)|(tsx?)' 'npx eslint -c .github/linters/.eslintrc.yml' ~/bragi_linter_packages;

# php lint
lint php 'phpcs --standard=.github/linters/phpcs.xml' .;

# json lint
lint json 'jsonlint -q' .;

# css lint
lint css 'npx stylelint --config .github/linters/.stylelintrc.json' ~/bragi_linter_packages;

# html lint
lint html 'htmlhint --config .github/linters/.htmlhintrc' .;

# ansible lint
lint yml 'yamllint -c .github/linters/.yaml-lint.yml' .

# restore both the working tree and index
git reset > /dev/null;
git checkout .;
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

# Automatically fix the files in our working tree
# no automatic java fix
# javascript + typescript fix
fix '(jsx?)|(tsx?)' 'npx eslint -c .github/linters/.eslintrc.yml --fix' ~/bragi_linter_packages;
# php fix
fix php 'phpcbf --standard=.github/linters/phpcs.xml' .;
# json fix
fix json 'npx jsonlint -i' .;
# no automatic css fix
# no automatic html fix
# no automatic yml fix

# any accumulated non zero exit codes means at least one linter failed
if [ "$linter_exit_code" -gt "0" ]; then
	exit 1;
fi
