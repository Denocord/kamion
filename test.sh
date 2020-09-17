UPSTREAM_REF="a"
UPSTREAM_REPO="http://localhost"
PR_NAME="Update $UPSTREAM_REPO to $UPSTREAM_REF"
PR_DESCRIPTION="This pull request updates $UPSTREAM_REPO to $UPSTREAM_REF/commits/$UPSTREAM_REF."

jq -n \
    --arg prName "$PR_NAME" \
    --arg prBody "$PR_DESCRIPTION" \
    '{title: $prName,body: $prBody}'