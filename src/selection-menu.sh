#!/bin/bash

set -e

selection_menu() {
  echo "Avaliable options:"
  for i in "${!options[@]}"; do
    printf "%3d%s) %s\n" $((i + 1)) "${choices[i]:- }" "${options[i]} => [$(git config --global "${options[i]}")]"
  done
  [[ "$msg" ]] && echo "$msg"
  :
}



