#!/bin/bash

set -e

#Choose a formatter for display | <[p]> [d] [t] [j] [f] [null] [debug]

docker compose run --rm \
  shellspec  --kcov \
  --format d \
  --kcov \
  --reportdir report \
  --output documentation
