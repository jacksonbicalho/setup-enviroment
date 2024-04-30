#!/bin/bash

set -e

function config::init() {
  local replace_line_sleep="${1:-5}"

  local first=false
  version=$(get_version)

  utilly::replace_line "Verificando configuração..." "$replace_line_sleep"

  utilly::replace_line "Verificando existência do diretório de configuração." "$replace_line_sleep"
  if ! is_dir "${CONFIG_PATH}"; then
    utilly::replace_line "Criando diretório ${CONFIG_PATH}" "$replace_line_sleep"
    mkdir -p "${CONFIG_PATH}"
  fi

  utilly::replace_line "Verificando existência do arquivo de configuração." "$replace_line_sleep"
  if ! file_exist "${APP_CONFIG_FILE}"; then
    utilly::replace_line "Criando aequivo de configuração ${APP_CONFIG_FILE}" "$replace_line_sleep"
    touch "${APP_CONFIG_FILE}"
    first=true
  fi

  if $first; then
    utilly::replace_line "configurando versão [ $version ]..." "$replace_line_sleep"
    config::set "version" "$version"
    utilly::replace_line "configurando timezone padrão [ UTC+3 ]..." "$replace_line_sleep"
    config::set "timezone" "UTC+3"
    date_instation="$(date_now)"
    utilly::replace_line "configurando data de instalação [ $date_instation ]..." "$replace_line_sleep"
    config::set "instalation_date" "$date_instation"
    config::prompt_input
  fi
  text=$(print_color "Configuração finalizada com sucesso..." "$COLOR_SUCCESS")
  utilly::replace_line "$text" "$replace_line_sleep"
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
  done <"$APP_CONFIG_FILE" && return 1
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


function config::prompt_input(){
  for conf_ini in "${CONFIGS_INI[@]}"; do
    utilly::replace_line "Digite uma valor para $conf_ini: " "$replace_line_sleep"
    read -r "${conf_ini?}"
    utilly::replace_line "Configurando $conf_ini" "$replace_line_sleep"
    config::set "$conf_ini" "${conf_ini?}"
  done && return 0
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
  VERSION_FILE="${ROOT_DIR}/version"
  if ! file_exist "${VERSION_FILE}"; then
    touch "${VERSION_FILE}"
    echo "0.0.0-dev" >"${VERSION_FILE}"
  fi
  version=$(head -n 1 "$VERSION_FILE")
  echo "$version"
  return 0
}
