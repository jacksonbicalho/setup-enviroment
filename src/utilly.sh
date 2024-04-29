#!/bin/bash

set -e

function check_essentials() {
  local replace_line_sleep="${1:-5}"
  # clear
  not_installed=()
  for dep in "${ESSENTIALS[@]}"; do
    text=$(print_color "Verificando instalação de $dep" "$COLOR_INFO")
    utilly::replace_line "$text" "$replace_line_sleep"
    if ! is_installed "$dep"; then
      not_installed+=("$dep")
    fi
  done

  if [[ "${#not_installed[@]}" -gt 0 ]]; then
    # clear
    print_color "Os seguintes pacotes devem ser instalados para prosseguirmos:" "$COLOR_WARNING"
    for install in "${not_installed[@]}"; do
      print_color "- $install" "$COLOR_DEFAULT"
    done
    text=$(print_color "Digite ENTER para instalar" "$COLOR_INFO")
    if ! question "$text" y; then
      return 1
    fi

    apt_install "${not_installed[@]}"
    text=$(print_color "dependências instaladas com sucesso" "$COLOR_SUCCESS")
    utilly::replace_line "$text" "$replace_line_sleep"
  fi

  return 0
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

function date_now() {
  timezone=$(config::get "timezone")
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
  return 0
}

function utilly::replace_line() {
  new_line=$1
  _sleep="${2:-$SLEEP}"
  echo -e "\e[1A\e[K$new_line"
  sleep "$_sleep"
}

function selection_menu() {
  options=$1
  echo "Selecione as opções:"
  for i in "${!options[@]}"; do
    printf "%3d%s) %s\n" $((i + 1)) "${choices[i]:- }" "${options[i]}"
  done
  [[ "$msg" ]] && echo "$msg"
  :
}

function utilly::err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}
