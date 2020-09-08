# Move to the root of the project
original_pwd=$(pwd);
cd $(dirname $0);
cd ../..;

function command_exists {
    type "$1" &> /dev/null;
}

function ensure_package_exists {
    if ! npm list --depth 1 "$1" > /dev/null 2>&1; then
        npm i --save-dev "$1";
    fi;
}

# CHECKSTYLE
if ! command_exists checkstyle; then
    brew install checkstyle;
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

# ESLINT
if ! command_exists npm; then
    brew install npm;
fi;
ensure_package_exists eslint;
ensure_package_exists eslint-plugin-import;
ensure_package_exists eslint-plugin-jsx-a11y;
ensure_package_exists eslint-plugin-node;
ensure_package_exists eslint-plugin-react;
ensure_package_exists babel-eslint;
ensure_package_exists typescript;
ensure_package_exists @typescript-eslint/parser;
ensure_package_exists @typescript-eslint/eslint-plugin;

# JSON Lint
ensure_package_exists jsonlint;

# Style Lint
ensure_package_exists stylelint;
ensure_package_exists stylelint-config-standard;

# HTML Hint
ensure_package_exists htmlhint;

# YAML Lint
if ! command_exists yamllint; then
    brew install yamllint;
fi;

# Setup the pre commit hook
if ! test -h .git/hooks/pre-commit; then
    ln -s ../../.github/hooks/pre-commit.sh .git/hooks/pre-commit;
    chmod 777 .git/hooks/pre-commit;
fi;

# Restore working directory
cd $original_pwd;
