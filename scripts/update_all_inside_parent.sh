#!/bin/sh
git_dir="$1";
auto_clone=true;

if [ "$git_dir" == "" ]; then
    echo "Missing argument 1: Path to your parent git folder.";
    exit 1;
fi;

original_pwd=$(pwd);
update_script="../Bragi/scripts/update_inside_parent.sh";

update () {
    repo_branch="$1";
    bragi_branch="$2";
    repos="$3";
    for repo in $repos; do
        (
            if $auto_clone; then
                if ! cd "$git_dir/$repo" > /dev/null 2> /dev/null; then
                    cd "$git_dir" || exit 1;
                    git clone "git@github.com:BigVikingGames/$repo.git";
                fi;
            fi;

            if cd "$git_dir/$repo" > /dev/null 2> /dev/null; then
                echo "Updating branch for $repo.";
                $update_script "$repo_branch" "$bragi_branch" > /dev/null 2> /dev/null;
                changed=$(git diff "origin/$repo_branch" "origin/PTR-linter-$repo_branch" --name-only 2> /dev/null);
                unexpected_changed=$(echo "$changed" | grep -vwE "(\.github/linters|\.github/workflows/linter-workflow.yml|\.gitmodules)");
                if [ "$unexpected_changes" == "" ]; then
                    if [ "$changed" != "" ]; then
                        echo "- Status: Needs PR";
                    fi;
                else
                    echo "- Status: Accidentally committed incorrect files.  Need manual fix";
                fi;
            else
                echo "Skipping $repo since it could not be found inside $git_dir."
            fi;
        )
    done;
}

update master master "
    gjoll-elli gjoll-relay-server gjoll-app-stream Tarnhelm swftool bvg-unity-commons norns-ptr environment-config-ptr
    Bragi Nidavellir tools-analytics PTR-Tools-Server BAM BAM-Unity WorldsElectron VirtualVikoins
";
#YoWorld Fish-World Fish-World-Tools Kella Yggdrasil
