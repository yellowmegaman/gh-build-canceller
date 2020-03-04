#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi

CURL_HEADERS='-H "authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json"'
GITHUB_URL="https://api.github.com/repos"
COMMITS=$(git log --skip 1 -n"$INPUT_COMMIT_FILTER_LIMIT" --format=format:%H)

# Get all workflows that should be stopped
workflows=$(curl -s $CURL_HEADERS -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows"  | jq '.workflows | .[] | select(.name|test("'$INPUT_WORKFLOWS_FILTER'")) | .id')

for wf in $workflows; do
	runs=$(echo $runs $(curl -s $CURL_HEADERS -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows/$wf/runs" | jq '.workflow_runs | .[] | select((.head_sha|test("'$INPUT_COMMIT_SHA'")|not) and (.status|test("in_progress|queued")) | .id'))
done

for run in $runs; do
	echo "Possible target $run"
	commit=$(curl -s $CURL_HEADERS -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/runs/$run" | jq '.head_sha')
done
