#!/bin/sh
. $KAMION_BASE/util/functions.sh

mkdir update
cd update
git init
git config --global pull.rebase false
git config --global user.name Kamion
git config --global user.email kamion@tttie.local
git remote add origin $CURRENT_REPO
git remote add upstream $UPSTREAM_REPO

git fetch upstream
git fetch origin

export UPSTREAM_REF=$(git rev-parse upstream/$UPDATE_BRANCH)
export CURRENT_REF=$(git rev-parse origin/$OUTPUT_BRANCH)

if [[ $UPSTREAM_REF == $CURRENT_REF ]]; then
    echo "Branches are up to date; exiting!"
    exit 0
fi


git pull origin $CURRENT_BRANCH

if [[ -n $UPDATE_BRANCH ]]; then
    UPDATE_BRANCH=$CURRENT_BRANCH
fi

ARGS=""

if [[ $UPDATE_METHOD == "rebase" ]]; then 
    ARGS="--rebase"
fi

git pull $ARGS upstream $UPDATE_BRANCH

git push -u origin $OUTPUT_BRANCH

OUTPUT_SCRIPT="$KAMION_BASE/outputs/$KAMION_OUTPUT.sh"
IS_VALID_DIRECTORY=$(test_directory $OUTPUT_SCRIPT "$KAMION_BASE/outputs")

if [[ $IS_VALID_DIRECTORY == 0 ]]; then
    . $OUTPUT_SCRIPT
fi

