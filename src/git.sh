#!/bin/bash

set -e

function check_git() {


  echo -e "Verificando instação do git...\n"
  if ! git_is_instaled > /dev/null 2>&1; then
    print_color "[!] git não está instalado" "$COLOR_WARNING"
    if question "Deseja instalar git?" y; then
      apt -y -qq install git -o Dpkg::Progress-Fancy="0" -o APT::Color="0" -o Dpkg::Use-Pty="0"
      if git_is_instaled; then
        print_color "git instalado com sucesso" "$COLOR_SUCCESS" > /dev/null 2>&1
      fi
    fi
  else
    print_color "git está instalado" "$COLOR_SUCCESS" > /dev/null 2>&1
  fi

  if question "Deseja verificar as configurações padrões?" y; then
    options=()
    options+=("user.name" "user.email" "init.defaultBranch" "pull.rebase")
    prompt="Check an option (again to uncheck, ENTER when done, Q to quit): "
    while selection_menu && read -rp "$prompt" -n 1 num && [[ "$num" ]]; do
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
      clear;
    done

    selecteds=()
    for i in "${!options[@]}"; do
      [[ "${choices[i]}" ]] && {
        selecteds+=("${options[i]}")
      }
    done

    for selected in "${selecteds[@]}"; do
      echo -e "${selected}\n"
      if ! check_git_config "${selected}"; then
        echo -e "[!] ${selected} não está configurado\n"
        if question "Vamos configurar agora?" y; then
          echo "Dgite um valor para ${selected}"
          read config
          git config --global "${selected}" "${config}"
          if [ "${selected}" == "user.name" ]; then
            set_config "config[].name" "\"${config}\""
          fi
          if check_git_config "${selected}"; then
            echo -e "${selected} configurado: ${config}\n"
            unset config
          fi
        fi
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

