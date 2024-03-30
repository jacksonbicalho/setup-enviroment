#!/bin/bash

set -e

function ssh_keygen() {

  if ! __is_dir "$HOME/.ssh"; then
    return 1
  fi

  ssh_keys=( $( ls "$HOME/.ssh" ) )
  if [[ ! "${#ssh_keys[@]}" == 0 ]]; then
    echo -en "Você possue as seguintes chaves já instaladas em seu sistema:\n"
    for ssh_key in ${ssh_keys[@]};
    do
      echo -en "=>> $ssh_key\n"
    done

    if ! question "Deseja configurar uma nova?" n; then
      return 0
    fi

  else
    print_color "Aparentemente você não tem uma chave ssh configurada" $COLOR_WARNING
    if ! question "Vamos configurá-la agora?" y; then
      return 0
    fi
  fi

  echo -e "Digite um email válido:"
  read email
  if ! _is_email_valid "${email}"; then
    print_color "Email $email é inválido.\n" $COLOR_DANGER
    return 0
  fi

  PS3="Selecione um algorítmo de sua preferência: "
  select algorithm in "${ALGORITHMS[@]}"; do
    case $algorithm in
    "$algorithm")
      selected=$algorithm && break
      ;;
    esac
  done

  if [[ ! " ${ALGORITHMS[*]} " =~ [[:space:]]${selected}[[:space:]] ]]; then
    return 0
  fi

  if [[ "$selected" == "cancelar" ]]; then
    return 0
  fi

  echo -e gerando chave ssh em "$HOME/.ssh/id_${selected}"

  ssh-keygen -t ${selected} -q -f "$HOME/.ssh/id_${selected}" -N "" -C "$email"
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_${selected}"
  cat "$HOME/.ssh/id_${selected}.pub"
}
