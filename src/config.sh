#!/bin/bash

set -e

config::init() {
  local first=false
  version=$(get_version)

  if ! is_dir "${CONFIG_PATH}"; then
    mkdir -p "${CONFIG_PATH}"
  fi

  if ! file_exist "${APP_CONFIG_FILE}"; then
    touch "${APP_CONFIG_FILE}"
    first=true
  fi

  if $first; then
    config::set "version" "$version"
    config::set "timezone" "UTC+3"
    config::set "instalation_date" "$(date_now)"

    for conf_ini in "${CONFIGS_INI[@]}";
      do
      res=$(utilly::prompt_input  "Digite um valor para" "$conf_ini")
      config::set "$conf_ini" "$res"
    done
  fi

  return 0
}

config::get() {
  normalize_file
  while read -r line; do
    IFS="=" read -r -a key_value <<<"$line"
    local key="${key_value[0]}"
    local value="${key_value[1]}"
    if [ "${key}" = "$1" ]; then
      echo "${value}"
      return 0
    fi
  done <"$APP_CONFIG_FILE"; return 1
}

config::set() {
  normalize_file
  local key="${1}"
  local value="${2}"
  if ! config::get "$key" >/dev/null 2>&1; then
    write_file "$key=$value"
    return 0
  fi
  change_var "$key" "$value"
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
}

write_file() {
  echo "$1" >>"${APP_CONFIG_FILE}"
}

get_version() {
  ROOT_DIR=$(dirname "$0")
  VERSION_FILE="${ROOT_DIR}/version"
  if ! file_exist "${VERSION_FILE}"; then
    touch "${VERSION_FILE}"
    echo "0.0.0-dev" >"${VERSION_FILE}"
  fi
  version=$(head -n 1 "$VERSION_FILE")
  echo "$version"
}