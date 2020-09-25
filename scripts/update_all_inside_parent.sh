#!/bin/sh
git_dir="";
auto_clone='false';
verbose='false';
filter='.*';

print_usage() {
    printf "Usage:  -c to specify that missing repos are to be automatically cloned (default: false)
        -v verbose (default: false)
        -f {filter_expression} regular expression for which repositories to update (default: .*)";
}

while getopts 'cvf:' flag; do
    case "${flag}" in
        c) auto_clone='true' ;;
        f) filter="${OPTARG}" ;;
        *) print_usage
            exit 1 ;;
    esac
done


RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YWLLOW='\033[1;33m'
NC='\033[0m' # No Color

update_script="../Bragi/scripts/update_inside_parent.sh";

cd "$(dirname "$0")" || exit 1;
cd ../.. || exit 1;

update () {
    repo_branch="$1";
    bragi_branch="$2";
    all_repos="$3";
    filtered_repos=$(echo "$3" | xargs -n 1 | grep "$filter");
    for repo in $filtered_repos; do
        (
            echo "Updating branch PTR-linter-$repo_branch for $repo.";
            if [ ! -d "$repo" ]; then
                if "$auto_clone"; then
                    echo "- Status: Cloning missing repo.";
                    git clone "git@github.com:BigVikingGames/$repo.git" > /dev/null;
                else
                    echo "- Status:$YELLOW Missing repo.  Use -c to automatically clone it.$NC";
                fi;
            fi;

            if cd "$repo" > /dev/null 2> /dev/null; then
                $update_script "$repo_branch" "$bragi_branch" > /dev/null 2> /dev/null;
                changed=$(git diff "origin/$repo_branch" "origin/PTR-linter-$repo_branch" --name-only 2> /dev/null);
                unexpected_changed=$(echo "$changed" | grep -vwE "(\.github/linters|\.github/workflows/linter-workflow.yml|\.gitmodules)");
                if [ "$unexpected_changes" == "" ]; then
                    if [ "$changed" != "" ]; then
                        echo "- Status:$ORANGE Needs PR created and/or merged.$NC";
                    else
                        echo "- Status:$GREEN Already up to date.$NC";
                    fi;
                else
                    echo "- Status:$RED Accidentally committed incorrect files.  Need manual fix!$NC";
                fi;
                cd ..;
            fi;
        )
    done;
}

#update parent_base_branch bragi_branch repo_list
update master master "
    gjoll-elli gjoll-relay-server gjoll-app-stream
    Tarnhelm swftool bvg-unity-commons BAM BAM-Unity hermod
    Bragi Nidavellir tools-analytics PTR-Tools-Server WorldsElectron VirtualVikoins Task-Scheduler
    devops Jenkins embla norns-ptr environment-config-ptr
    Flamingo pryor-prototype
    Fish-World Fish-World-Tools norns-fw environment-config-fishworld
    yoworld-cli YoWoMo YoWorld-Forums norns-yw environment-config-yoworld
    Norns tyr Kella bvg-commons Yggdrasil Jormungand
";
update unstable master "YoWorld";
update "norns_2.0" master "Norns";
