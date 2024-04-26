#!/bin/bash

set -e


function check_dependencies() {
  not_installed=()
  for dep in "${@}";
  do
    if ! is_installed "$dep"; then
       read -ra not_installed <<< "$dep"
    else
      echo -e "${dep} Instalado!"
    fi
  done

  if [[ "${#not_installed[@]}" == 0 ]]; then
    return 1;
  fi

  # shellcheck disable=SC2068
  echo ${not_installed[@]}

}

function is_email_valid() {
  regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+$"
  [[ "${1}" =~ $regex ]]
}

function is_installed() {
  pattern=$1
  if apt list --installed 2>/dev/null | grep -q "^$pattern/"; then
      return 0
  else
      return 1
  fi
}

function is_exist() {
  type "${1}" &>/dev/null && return 0 || return 1
}

function file_exist() {
  if [ -f "${1}" ]; then
    return 0
  fi
  return 1
}

function is_dir() {
  if [ -d "${1}" ]; then
    return 0
  fi
  return 1
}

function join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function split() {
  IFS=' '
  words=()
  read -ra words <<< "$1"
  for i in $(' '); do words+=($i) ; done
  echo "${words[@]}"
}

function date_now () {
  timezone=$(get_config "timezone")
  now="$(TZ=":$timezone" date +'%Y-%m-%d %H:%M:%S')"
  echo "${now}"
}

function apt_update() {
  apt update --yes
}

function apt_upgrade() {
  apt upgrade --yes
}


function apt_dist_upgrade() {
  apt dist-upgrade --yes
}

function apt_install() {
  apt install --yes "${@}"
}
