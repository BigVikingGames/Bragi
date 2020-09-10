Bragi:  The god of poetry

Standardizes all of our projects linting.

To add linting to your new or existing project add this as a submodule at the root of your project under the .github/linters folder:
`git submodule add git@github.com:BigVikingGames/Bragi.git .github/linters`

Then run the script (on mac or wsl) located at `.github/linters/setup/update-all.sh` and commit the generated yml workflow file.
This will automatically setup a github action to run the linter on any changed files in all pull requests.

You can also optionally run the script located at `.github/linters/setup/local-lint.sh`.
This will install any necessary linters and then set it up to automatically run the linter on any commits you make.
You can use git commit `-n` flag to skip linting on any commits.

On updating this submodule both the github action and git commit hook will be automatically updated if you have run the setup scripts.


If the linting submodule already exists in your project and you want to add local linting on your own commits you should instead run `git submodule update --init` and then run the two scripts mentioned above.
