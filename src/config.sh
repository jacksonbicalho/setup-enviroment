#!/bin/bash

set -e


init_config () {
  last_update="`date_now`"
  set_config "last_update" "\"${last_update}\""
}

get_config () {
  local key="${1}"
  # echo $(jq -r \'."${key}"\' "$APP_CONFIG_FILE")
  echo `jq "$key" "${APP_CONFIG_FILE}"`
}

set_config () {

  local key="${1}"
  local value="${2}"

  if ! is_dir "${CONFIG_PATH}"; then
    mkdir -p "${CONFIG_PATH}"
  fi

  if ! file_exist "${APP_CONFIG_FILE}"; then
    create_json
  fi

  contents=$(jq ".$key = $value" ${APP_CONFIG_FILE})
  echo -E $contents > ${APP_CONFIG_FILE}

}

create_json () {

json=$(cat <<EOF
{
  "version": "0.0.0",
  "distro":[
    {
      "name": "null",
      "version": "null"
    }
  ],
  "config": [
    {
      "name": "null",
      "email": "null",
      "github": "null"
    }
  ],
  "last_update": "123123123"
}
EOF
)

  echo -E "${json}" > "${APP_CONFIG_FILE}"
}


