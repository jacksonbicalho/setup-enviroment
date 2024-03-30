#!/bin/bash

set -e

function help() {
  FIRST_MESSAGE="${1:f}"
  funcs=$(compgen -A function | grep -v '^_')
  echo "${funcs}" | cat >functions
  INFILE=functions
  funcs_list=" "

  # Read the input file line by line
  while read -r LINE; do
    funcs_list+=$(echo -e "\n\t${LINE} |")
  done <"$INFILE"

  if [[ "$FIRST_MESSAGE" != "f" ]]; then
    echo -e "=================================================================="
    echo -e "${FIRST_MESSAGE}"
    echo -e "=================================================================="
  fi

  usage="$(basename "$0") [-h] [-f string] -- [CRIAR DESCRIÇÃO]

where:
  -h  show this help text
  -f  Informe a função a ser executada

    FUNCTIONS:
  $funcs_list
"

  echo "$usage"
}
