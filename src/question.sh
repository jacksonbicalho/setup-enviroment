#!/bin/bash

set -e

function validate_question() {
  grep -F -q -x "$1" <<EOF
y
n
EOF
}

function question() {
  question_message="${1}"
  question_default_option="${2:-n}"
  question_options="[y/n]"
  question_options_uppercase_default=$(echo "$question_options" | sed "s|$question_default_option|\U&|g")

  validate_question "$question_default_option" || {
    echo -e "${question_default_option} não é uma opção válida"
    echo -e "Use y ou n"
    echo "exemplo: question \"Reiniciar\" y"
    echo "resultado: Reiniciar [Y/n]"
    exit 1
  }

  read -r -p "$question_message ${question_options_uppercase_default} " question_answer
  if [[ -z "$question_answer" ]]; then
    question_answer=$question_default_option
  fi
  case "$question_answer" in
  [yY][eE][sS] | [yY])
    true
    ;;
  *)
    false
    ;;
  esac
}
