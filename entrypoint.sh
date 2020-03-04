#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi

GITHUB_URL="https://api.github.com/repos"


# Get all workflows that should be stopped
workflows=$(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows"  | jq '.workflows | .[] | select(.name|test("'$INPUT_WORKFLOWS_FILTER'")) | .id')

for wf in $workflows; do
	runs=$(echo $runs $(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows/$wf/runs" | jq '.workflow_runs | .[] | select(.head_sha|test("'$GITHUB_SHA'")|not) | select(.status|test("in_progress|queued")) | .id'))
done

for run in $runs; do
	echo "Possible target $run"
done
