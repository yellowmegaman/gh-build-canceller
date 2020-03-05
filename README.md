# Github Actions build canceller

A GitHub Action for cancelling old PR builds.


## How it works
 * Action is looking for workflows on current repo
 * To limit in which workflows we want to kill old builds, you can use "worflow1|workflow2" as a value for `workflow_filter` parameter.
 * Action is looking then for `older` builds that have status `in_progress|queued` on the different GIT SHA and kills 'em

### GitHub Actions
```
# File: .github/workflows/shot.yml

on:
  pull_request:
jobs:
  build_canceller:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: shot
      uses: yellowmegaman/gh-build-canceller@v1.3
      with:
        github_token: ${{secrets.PERSONAL_TOKEN}}
        workflows_filter: "CI|pr"
```

This will automatically kill all old builds on this PR branch.

