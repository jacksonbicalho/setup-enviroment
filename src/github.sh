#!/bin/bash

set -e

get_credentials() {
  unset github_email
  unset github_token
  if ! __file_exist "${APP_CONFIG_FILE}"; then
    echo -e "Vocẽ ainda não possui credenciais"
    echo -e "Acesse ${GIT_HUB_NEW_TOKEN_URL}"
    echo -e "e cole o token aqui:"
    read -r -s -p "token: " github_token

    echo -r -e "Digite o email usado para acessar o github"
    read -r github_email
    set_credentials "$github_email" "$github_token"
    unset github_email
    unset github_token
  fi

  credentials=$(jq -r '.github' "$APP_CONFIG_FILE")
  IFS='.' read -r -a array <<<"$credentials"
  github_email="$(echo -n "${array[0]}" | base64 --decode)"
  github_token="$(echo -n "${array[1]}" | base64 --decode)"
  github_credentials=("$github_email" "$github_token")
}

set_credentials() {

  if ! __is_dir "${CONFIG_PATH}"; then
    mkdir -p "${CONFIG_PATH}"
  fi

  github_email="${1}"
  github_token="${2}"
  github_token_base64="$(echo -n "${github_token}" | base64)"
  github_email_base64="$(echo -n "${github_email}" | base64)"
  github_json=$(
    cat <<-END
  {
    "github":"$github_email_base64.$github_token_base64"
  }
END
  )
  echo -n "$github_json" >"$APP_CONFIG_FILE"
}

github_send_ssh_key() {

  echo $KEY_PUB


  get_credentials
  github_token="$(echo -n "${github_credentials[1]}")"
  ssh_key_pub="$(cat "$HOME"/.ssh/id_ed25519.pub)"
  now=$(date)
  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${github_token}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/keys \
    -d "{\"title\":\"setup-enviroment $now\",\"key\":\"$ssh_key_pub\""
}
