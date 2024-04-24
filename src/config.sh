#!/bin/bash

set -e

init_config() {

  if ! is_dir "${CONFIG_PATH}"; then
    mkdir -p "${CONFIG_PATH}"
  fi

  if ! file_exist "${APP_CONFIG_FILE}"; then
    touch "${APP_CONFIG_FILE}"
    set_config "version" "0.0.1"
  fi

  last_update="$(date_now)"
  set_config "last_update" "${last_update}"
  # shellcheck disable=SC2091
  distro=$(distro_info)
  IFS='|'
  distro_info=()
  read -ra distro_info <<<"$distro"
  # shellcheck disable=SC2043
  for i in "|"; do distro_info+=("$i"); done
  set_config "distro[].name" "${distro_info[0]}"
  set_config "distro[].version" "${distro_info[1]}"
}

get_config() {
  local key="\"${1}\""
  res=$(jq ".$key" "${APP_CONFIG_FILE}")
  if [ ! -n "$res" ]; then
    return 1
  fi
  echo "$res"
}

set_config() {

  local key="${1}"
  local value="\"${2}\""

  if ! get_config "$key"; then
    contents=$( echo "{\"$key\": \"$value\"}" | jq .)
    echo -e1 "$contents"
  else
    contents=$(jq ".$key = $value" "${APP_CONFIG_FILE}")
  fi

  echo -E "$contents" >"${APP_CONFIG_FILE}"
}
