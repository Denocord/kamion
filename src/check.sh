#!/bin/sh
. $KAMION_BASE/util/functions.sh

echo "Initializing git repository"
git config --global pull.rebase false
git config --global user.name Kamion
git config --global user.email kamion@tttie.local

echo "Cloning upstream repo..."
git clone -b $OUTPUT_BRANCH $CURRENT_REPO update
cd update
git remote add upstream $UPSTREAM_REPO

echo "Fetching new commits..."
git fetch upstream

export UPSTREAM_REF=$(git rev-parse upstream/$UPDATE_BRANCH)
export CURRENT_REF=$(git rev-parse origin/$OUTPUT_BRANCH)

if [[ $UPSTREAM_REF == $CURRENT_REF ]]; then
    echo "Branches are up to date; exiting!"
    exit 0
fi

if [[ -z $UPDATE_BRANCH ]]; then
    UPDATE_BRANCH=$OUTPUT_BRANCH
fi

ARGS=""

if [[ $UPDATE_METHOD == "rebase" ]]; then 
    ARGS="--rebase"
fi

echo "Pulling in the updates from $UPDATE_BRANCH at $UPSTREAM_REPO..."
git pull $ARGS upstream $UPDATE_BRANCH

echo "Pushing the new commits to $CURRENT_REPO..."
git push # >/dev/null 2>&1

echo "Push done!"

if [[ -n $KAMION_OUTPUT ]]; then
    OUTPUT_SCRIPT="$KAMION_BASE/outputs/$KAMION_OUTPUT.sh"

    test_directory $OUTPUT_SCRIPT "$KAMION_BASE/outputs"
    if [[ $? == 0 ]]; then
        echo "Running the $KAMION_OUTPUT output script..."
        . $OUTPUT_SCRIPT
    fi
fi