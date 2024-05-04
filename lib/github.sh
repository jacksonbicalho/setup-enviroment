#!/bin/bash

set -e

get_credentials() {
  unset github_email
  unset github_token

  credentials==`get_config ".config[].github"`
  if [[ ! -z "$credentials" ]]; then
    echo -e "Vocẽ não possui credenciais de acesso ao github"
    echo -e "Acesse o seguinte link, clique apenas em gerar token, copie-o e cole no terminal"
    echo -e "${GIT_HUB_NEW_TOKEN_URL}"
    echo -e "cole o token aqui:"
    read -r github_token

    email_salvo=`get_config ".config[].email"`
    if [[ ! -z "$email_salvo" ]]; then
      if question "Você deseja usar este email para acessar o github? [$email_salvo]" y; then
        github_email=$email_salvo
      else
        echo -r -e "Digite o email usado para acessar o github"
        read -r github_email
      fi
    fi
    set_credentials "$github_email" "$github_token"
    unset github_email
    unset github_token
  fi

  credentials==`get_config ".config[].github"`
  IFS='.' read -r -a array <<<"$credentials"
  github_email="$(echo -n "${array[0]}" | base64 --decode)"
  github_token="$(echo -n "${array[1]}" | base64 --decode)"
  github_credentials=("$github_email" "$github_token")
}

set_credentials() {
  github_email=$1
  github_token=$2
  github_token_base64="$(echo -n "${github_token}" | base64)"
  github_email_base64="$(echo -n "${github_email}" | base64)"
  credentials_base64="$github_email_base64.$github_token_base64"
  set_config "config[].github" "\"${credentials_base64}\""
}

github_send_ssh_key() {

  echo $KEY_PUB


  get_credentials
  github_token="$(echo -n "${github_credentials[1]}")"
  ssh_key_pub="$(cat "$HOME"/.ssh/id_ed25519.pub)"
  now="`date_now`"
  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${github_token}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/keys \
    -d "{\"title\":\"setup-enviroment $now\",\"key\":\"$ssh_key_pub\""
}
