#!/bin/bash

set -e

selection_menu() {
  options=$1
  echo "Selecione as opções:"
  for i in "${!options[@]}"; do
    printf "%3d%s) %s\n" $((i + 1)) "${choices[i]:- }" "${options[i]} => [$(git config --global "${options[i]}")]"
  done
  [[ "$msg" ]] && echo "$msg"
  :
}



