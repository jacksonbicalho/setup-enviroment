#!/bin/bash

set -e


function _check_dependencies() {

  echo -e "Verificando se as dependências solitadas estão instaladas..."
  deps=("${@}")
  deps_split=$(__split " " "${deps}")
  not_installed=()
  for dep in ${deps[@]};
  do
    if ! _is_installed "$dep"; then
      not_installed+=("${dep}")
    else
      echo -e "${dep} Instalado!"
    fi
  done

  if [[ "${#not_installed[@]}" == 0 ]]; then
    echo -en "os pacotes necessários estão instalados!\n"
    return 0;
  fi

  echo -en "os seguinte pacotes não estão instalados:\n"
  for _not_installed in ${not_installed[@]};
  do
    echo -en "$_not_installed\n"
  done

  if ! question "Para prosseguir precisamos instalar essas dependências, vamos continuar?" y ; then
    exit 0
  fi

  apt_install ${not_installed[@]}


  (apt -y -qq autoremove &>/dev/null) &  echo -e "Executando apt autoremove..."

  unset deps
  unset deps_split
  unset not_installed
  unset _not_installed
}

function is_email_valid() {
  regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+$"
  [[ "${1}" =~ $regex ]]
}

function _is_installed() {
  pattern=$1
  if apt list --installed 2>/dev/null | grep -q "^$pattern/"; then
      return 0
  else
      return 1
  fi
}

function _is_exist() {
  type "${1}" &>/dev/null && return 0 || return 1
}

function __file_exist() {
  if [ -f "${1}" ]; then
    return 0
  fi
  return 1
}

function __is_dir() {
  if [ -d "${1}" ]; then
    return 0
  fi
  return 1
}

function __join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function __exit() {
  print_color "Saindo..." "$COLOR_INFO"
  exit 1
}

function __split() {
  IFS=' '
  words=()
  read -a words <<< "$1"
  for i in ' '; do words+=($i) ; done
  echo ${words[@]}
}



function apt_update() {
  (apt -y -qq update &>/dev/null) & echo -e "Atualizando base de dados dos pacotes"
}

function apt_upgrade() {
  (apt -y -qq upgrade &>/dev/null) & echo -e "Vericando se há pacotes a serem atualizados"
}


function dist-upgrade() {
  (apt -y -qq dist-upgrade &>/dev/null) & echo -e "Vericanco se há atualizações da distro"
}

function apt_install() {
  (apt -y -qq install "${@}" &>/dev/null) & echo -e "Instalando pacotes necessários"
}
