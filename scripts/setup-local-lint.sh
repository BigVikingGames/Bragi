#!/bin/sh

echo "Updating local linting."

# Move to the root of the project
original_pwd=$(pwd);
cd "$(dirname "$0")" || exit 1;
cd ../../.. || exit 1;

command_exists () {
    type "$1" > /dev/null 2> /dev/null; 
}

ensure_package_exists () {
    mkdir -p ~/bragi_linter_packages;
    (
        cd ~/bragi_linter_packages || exit 1;
        if ! npm list --depth 1 "$1" > /dev/null 2> /dev/null; then
            npm i --save-dev "$1";
        fi;
    )
}

ensure_global_package_exists () {
    if ! command_exists "$1"; then
        npm i -g "$1";
    fi;
}

# CHECKSTYLE
if ! command_exists checkstyle; then
    brew install checkstyle || apt-get -y install checkstyle;
fi;

# PHP CODE SNIFFER
if ! command_exists phpcs; then
    curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
    chmod 777 phpcs.phar
    mv phpcs.phar /usr/local/bin/phpcs
fi;

if ! command_exists phpcbf; then
    curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
    chmod 777 phpcbf.phar
    mv phpcbf.phar /usr/local/bin/phpcbf
fi;

if ! command_exists php; then
    brew install php || apt-get -y install php;
    apt-get -y install php-xml;
    apt-get -y install php-xmlwriter;
fi;

# NPM
if ! command_exists npm; then
    brew install npm || (apt-get -y install npm && npm install -g npm@latest);
fi;

# ESLINT
ensure_package_exists eslint;
ensure_package_exists eslint-plugin-import;
ensure_package_exists eslint-plugin-jsx-a11y;
ensure_package_exists typescript;
ensure_package_exists @typescript-eslint/parser;
ensure_package_exists @typescript-eslint/eslint-plugin;

# Style Lint
ensure_package_exists stylelint;
ensure_package_exists stylelint-config-standard;

# JSON Lint
ensure_global_package_exists jsonlint;

# HTML Hint
ensure_global_package_exists htmlhint;

# YAML Lint
if ! command_exists yamllint; then
    brew install yamllint || apt-get -y install yamllint;
fi;

# Setup the pre commit hook
rm .git/hooks/pre-commit 2> /dev/null;
cp .github/linters/hooks/parent-pre-commit.sh .git/hooks/pre-commit;
chmod 777 .git/hooks/pre-commit;

# Restore working directory
cd "$original_pwd" || exit 1;
