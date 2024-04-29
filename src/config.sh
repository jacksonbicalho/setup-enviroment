#!/bin/bash

set -e

function config::init() {
  clear
  local first=false
  version=$(get_version)

  utilly::replace_line "Verificando configuração..." 5

  utilly::replace_line "Verificando existência do diretório de configuração." 5
  if ! is_dir "${CONFIG_PATH}"; then
    utilly::replace_line "Criando diretório ${CONFIG_PATH}" 5
    mkdir -p "${CONFIG_PATH}"
  fi

  utilly::replace_line "Verificando existência do arquivo de configuração." 5
  if ! file_exist "${APP_CONFIG_FILE}"; then
    utilly::replace_line "Criando aequivo de configuração ${APP_CONFIG_FILE}" 5
    touch "${APP_CONFIG_FILE}"
    first=true
  fi

  if $first; then
    utilly::replace_line "configurando versão [ $version ]..." 5
    config::set "version" "$version"
    utilly::replace_line "configurando timezone padrão [ UTC+3 ]..." 5
    config::set "timezone" "UTC+3"
    date_instation="$(date_now)"
    utilly::replace_line "configurando data de instalação [ $date_instation ]..." 5
    config::set "instalation_date" "$date_instation"

    for conf_ini in "${CONFIGS_INI[@]}"; do
      utilly::replace_line "Digite uma valor para $conf_ini: " 0
      read -r "${conf_ini?}"
      utilly::replace_line "Configurando $conf_ini" 5
      config::set "$conf_ini" "${conf_ini?}"
    done
  fi
  text=$(print_color "Configuração finalizada com sucesso..." "$COLOR_SUCCESS")
  utilly::replace_line "$text" 5
  return 0
}

function config::get() {
  normalize_file
  while read -r line; do
    IFS="=" read -r -a key_value <<<"$line"
    local key="${key_value[0]}"
    local value="${key_value[1]}"
    if [ "${key}" = "$1" ]; then
      echo "${value}"
      return 0
    fi
  done <"$APP_CONFIG_FILE"
  return 1
}

function config::set() {
  normalize_file
  local key="${1}"
  local value="${2}"
  if ! config::get "$key" >/dev/null 2>&1; then
    write_file "$key=$value"
    return 0
  fi
  change_var "$key" "$value"
  return 0
}

change_var() {
  local key="${1}"
  local value="${2}"
  local sign="="
  sed -i "s/^\($key\)[[:blank:]]*${sign}.*/\1${sign}${value}/" "${APP_CONFIG_FILE}"
  return 0
}

normalize_file() {
  sed -i '/^\s*$/d' "${APP_CONFIG_FILE}"
  sed -i -r "s/[[:space:]]*=[[:space:]]*/=/g" "${APP_CONFIG_FILE}"
  return 0
}

write_file() {
  echo "$1" >>"${APP_CONFIG_FILE}"
  return 0
}

function get_version() {
  ROOT_DIR=$(dirname "$0")
  VERSION_FILE="${ROOT_DIR}/version"
  if ! file_exist "${VERSION_FILE}"; then
    touch "${VERSION_FILE}"
    echo "0.0.0-dev" >"${VERSION_FILE}"
  fi
  version=$(head -n 1 "$VERSION_FILE")
  echo "$version"
  return 0
}
