#!/bin/bash

set -e

function git::init() {
  utilly::replace_line "Verificando instação do git..." 5
  if ! git::is_instaled >/dev/null 2>&1; then
    text=$(print_color "[!] git não está instalado" "$COLOR_WARNING")
    utilly::replace_line "$text" 5
    if question "Deseja instalar git?" y; then
      apt -y -qq install git -o Dpkg::Progress-Fancy="0" -o APT::Color="0" -o Dpkg::Use-Pty="0"
      if git::is_instaled; then
        print_color "git instalado com sucesso" "$COLOR_SUCCESS" >/dev/null 2>&1
      fi
    fi
  else
    text=$(print_color "git está instalado" "$COLOR_SUCCESS")
    utilly::replace_line "$text" 5
  fi

  if question "Deseja verificar as configurações padrões?" y; then
    clear
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
      echo "Dgite um valor para git.${selected}"
      read -r config
      git config --global "${selected}" "${config}"
      if git::check_config "${selected}"; then
        set_config "git.$selected" "${config}"
        echo -e "${selected} configurado: ${config}\n"
        unset config
      fi
      unset config
    done
  fi
}

function git::is_instaled() {
  git --version &>/dev/null || return 1
  return 0
}

function git::check_config() {
  git config --global "${1}" &>/dev/null || return 1
  return 0
}
