#!/bin/bash

set -e

function help() {
  FIRST_MESSAGE="${1:h}"

  if [[ "$FIRST_MESSAGE" != "f" ]]; then
    echo -e "=================================================================="
    echo -e "${FIRST_MESSAGE}"
    echo -e "=================================================================="
  fi

  usage="$(basename "$0") [-h] [-f string] -- [CRIAR DESCRIÇÃO]

where:
  -h  show this help text
  -v  display current version
"

  echo "$usage"
}
