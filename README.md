Bragi:  The god of poetry

Standardizes all of our projects linting.  This repository must be public for all of our other projects to be able to access it without having to each contain a key for access.

Setup:

1. If linting has not yet been added to your project then add Bragi as a submodule from root of your project under the .github/linters folder:
`git submodule add --force https://github.com/BigVikingGames/Bragi.git .github/linters`  Make sure you use https and not ssh!

2.  Then pull the current version of Bragi:
`git submodule update --init .github/linters`

3. Then run the script (on either bash(macOS) or wsl[windows subsystem for linux]) located at `.github/linters/scripts/setup-all.sh` and commit the generated linter-workflow.yml file if it was added or changed with something like `git add .github`.  This will set up two automatic things:
    a. A github action to run the linter on any changed files in all pull requests.
    b. A set of hooks to automatically update the linter setup whenever your Bragi submodule changes.

4. Optionally run the script located at `.github/linters/scripts/setup-local-lint.sh` to steup pre-commit linting.  This will automatically:
    a. Install any necessary linters to your system 
    b. A hook to automatically run the linter on any changed files in commits you make.  After installing use the `git commit -n` flag to skip linting.


Updating Bragi:
After changing the submodule commit pointer for Bragi then the linter-workflow.yml file may also be automatically updated.  Make sure you commit both the submodule and the workflow file when that happens.
