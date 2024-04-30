#!/bin/bash

# print_color "Info" $COLOR_INFO
# print_color "Success" $COLOR_SUCCESS
# print_color "Warning" $COLOR_WARNING
# print_color "Danger" $COLOR_DANGER
# print_color "Default" $COLOR_DEFAULT

set -e

COLOR_INFO="96m"
COLOR_SUCCESS="92m"
COLOR_WARNING="93m"
COLOR_DANGER="91m"
COLOR_DEFAULT="0m"

function validate_print_color() {
  grep -F -q -x "$1" <<EOF
$COLOR_INFO
$COLOR_SUCCESS
$COLOR_WARNING
$COLOR_DANGER
$COLOR_DEFAULT
EOF
}


function print_color() {
  COLOR="${2:-$COLOR_DEFAULT}"
  validate_print_color "$COLOR" || {
    echo -e "${COLOR} não é uma opção válida"
   return 1;
  }

  COLOR="$2"
  STARTCOLOR="\e[$COLOR"
  ENDCOLOR="\e[0m"
  res=$(printf "${STARTCOLOR}%b${ENDCOLOR}" "$1")
  echo -e "$res"
  return 0;
}
