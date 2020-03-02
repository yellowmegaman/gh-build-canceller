#!/bin/bash

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi


env | sort

# curl -s -H "authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -X GET "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls" | jq -r '.[].head.ref'
