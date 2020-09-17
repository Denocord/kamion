#!/bin/sh
CURL_ARGS="-fsSL -H 'Authorization: Bearer $GITHUB_TOKEN' -o -"
GITHUB_API_BASE="https://api.github.com/"

PR_NAME="Update $UPSTREAM_REPO to $UPSTREAM_REF"
PR_DESCRIPTION="This pull request updates $UPSTREAM_REPO to $UPSTREAM_REF/commits/$UPSTREAM_REF."
PR_BASE_URL="$GITHUB_API_BASE/repos/$GITHUB_REPO_SLUG/pulls"

PR_ID=$(curl $CURL_ARGS "$PR_BASE_URL?head=$UPDATE_BRANCH" | jq -e ".[0].number")

if [[ $? == 0 ]]; then
    echo "An update pull request exists already - updating the PR label accordingly."


    REQUEST_BODY=$(
        jq -n \
        --arg prName $PR_NAME \
        --arg prBody $PR_DESCRIPTION \
        '{ title: $prName, body: $prBody }'
    )
    curl $CURL_ARGS -X "PATCH" -d $REQUEST_BODY $PR_BASE_URL/$PR_ID 
fi

REQUEST_BODY=$(
    jq -n \
    --arg prName $PR_NAME \
    --arg prBody $PR_DESCRIPTION \
    --arg prHead $UPDATE_BRANCH \
    '{ title: $prName, body: $prBody, head: $prHead }'
)

curl $CURL_ARGS -X "POST" -d $REQUEST_BODY $PR_BASE_URL