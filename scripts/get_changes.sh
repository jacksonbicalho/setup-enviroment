#!/bin/bash

function get_changes() {
  current_branch=$(git branch --show-current)
  changes=$(git log "${current_branch}" \
    --no-merges ^master^! \
    --pretty=format:'%H%x00%an <%ae>%x00%ad%x00%s%x00' |
    jq -R -s '[split("\n")[:-1] | map(split("\u0000")) | .[] | {
    "commit": .[0],
    "author": .[1],
    "date": .[2],
    "message": .[3]
  }]')

  echo "$changes"
}
