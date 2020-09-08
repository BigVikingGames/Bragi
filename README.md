Bragi:  The god of poetry

Standardizes all of our projects linting.

To add linting to your new or existing project add this as a submodule at the root of your project under the .github name:
`git submodule add git@github.com:BigVikingGames/gjoll-app-stream.git .github`

This will automatically setup a github action to run the linter on any changed files in all pull requests.

For anybody that wants the linter to automatically run on any commit they make they need to run the .github/hooks/setup.sh file which will automatically set it up.