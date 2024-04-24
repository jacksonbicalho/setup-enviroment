#!/bin/bash

set -e

function check_git() {

  echo -e "Verificando instação do git...\n"
  if ! git_is_instaled >/dev/null 2>&1; then
    print_color "[!] git não está instalado" "$COLOR_WARNING"
    if question "Deseja instalar git?" y; then
      apt -y -qq install git -o Dpkg::Progress-Fancy="0" -o APT::Color="0" -o Dpkg::Use-Pty="0"
      if git_is_instaled; then
        print_color "git instalado com sucesso" "$COLOR_SUCCESS" >/dev/null 2>&1
      fi
    fi
  else
    print_color "git está instalado" "$COLOR_SUCCESS" >/dev/null 2>&1
  fi

  if question "Deseja verificar as configurações padrões?" y; then
    options=()
    options+=("user.name" "user.email" "init.defaultBranch" "pull.rebase")
    prompt=$(print_color "Marque a opção com [espaço] (use-o novamente para desmarcar, ENTER quando terminar, Q para sair):" "$COLOR_WARNING")
    while selection_menu "${options[@]}" && read -rp "$prompt" -n 1 num && [[ "$num" ]]; do
      case $num in
      q | Q) exit 0 ;;
      esac
      [[ "$num" != *[![:digit:]]* ]] &&
        ((num > 0 && num <= ${#options[@]})) ||
        {
          continue
        }
      ((num--))
      [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
      clear
    done

    selecteds=()
    for i in "${!options[@]}"; do
      [[ "${choices[i]}" ]] && {
        selecteds+=("${options[i]}")
      }
    done

    for selected in "${selecteds[@]}"; do
      echo -e "${selected}\n"
      echo "Dgite um valor para ${selected}"
      read -r config
      git config --global "${selected}" "${config}"
      if check_git_config "${selected}"; then
        set_config "git[].$selected" "${config}"
        echo -e "${selected} configurado: ${config}\n"
        unset config
      fi
      unset config
    done
  fi
}

function git_is_instaled() {
  git --version &>/dev/null || return 1
  return 0
}

function check_git_config() {
  git config --global "${1}" &>/dev/null || return 1
  return 0
}
