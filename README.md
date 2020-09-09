Bragi:  The god of poetry

Standardizes all of our projects linting.

To add linting to your new or existing project add this as a submodule at the root of your project under the .github/linters folder:
`git submodule add git@github.com:BigVikingGames/Bragi.git .github/linters`

Then run the script located at `.github/linters/setup/github-lint.sh` and commit the generated yml workflow file.
This will automatically setup a github action to run the linter on any changed files in all pull requests.

Finally optionally run the script located at `.github/linters/setup/local-lint.sh`
This will install any necessary linters and then set it up to aytomatically run the linter on any commits you make.
You can use git commit `-n` flag to skip linting on any commits.
