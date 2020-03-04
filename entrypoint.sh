#!/bin/bash -e
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi

GITHUB_URL="https://api.github.com/repos"
COMMIT_SHA=$(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" | jq -r '.head_sha')
COMMIT_TIMESTAMP=$(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" | jq -r '.head_commit.timestamp')
echo "COMMIT_SHA: $COMMIT_SHA"

workflows=$(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows"  | jq -r '.workflows | .[] | select(.name|test("'$INPUT_WORKFLOWS_FILTER'")) | .id')

for wf in $workflows; do
	runs=$(echo $runs $(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/workflows/$wf/runs" | jq -r '.workflow_runs | .[] | select((.head_sha|test("'$COMMIT_SHA'")|not) and (.status|test("in_progress|queued"))) | .id'))
done

for run in $runs; do
	run_timestamp=$(curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X GET "$GITHUB_URL/$GITHUB_REPOSITORY/actions/runs/$run" | jq -r '.head_commit.timestamp')
	if [[ "$COMMIT_TIMESTAMP" > "$run_timestamp" ]]; then
		echo "We're about to cancel target: $run $run_timestamp"
                curl -s -H "authorization: Bearer $GITHUB_TOKEN" -X POST "$GITHUB_URL/$GITHUB_REPOSITORY/actions/runs/$run/cancel"
	fi
done
