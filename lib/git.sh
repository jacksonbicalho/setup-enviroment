#!/bin/bash

set -e

function git::init() {
  local replace_line_sleep="${1:-$SLEEP}"
  echo -e "Verificando instação do git..."
  echo -e ""
  sleep "$replace_line_sleep"

  if ! git::is_instaled >/dev/null 2>&1; then
    text=$(print_color "git não está instalado" "$COLOR_WARNING")
    utilly::replace_line "$text" "$replace_line_sleep"
    if question "Deseja instalar git?" y; then
      utilly::apt_install git
      if git::is_instaled; then
        text=$(print_color "it instalado com sucesso" "$COLOR_SUCCESS")
        utilly::replace_line "$text" "$replace_line_sleep"
      fi
    fi
  else
    text=$(print_color "git está instalado" "$COLOR_SUCCESS")
    utilly::replace_line "$text" "$replace_line_sleep"
  fi

  git::config "$SLEEP"

}

function git::config() {
  local replace_line_sleep="${1:-$SLEEP}"
  echo -e "configurações padrões do git..."
  echo -e ""
  sleep "$replace_line_sleep"

  if question "Deseja verificar as configurações padrões do git?" y; then
    clear
    options=()
    options+=("user.name" "user.email" "init.defaultBranch" "pull.rebase")
    prompt=$(print_color "Marque a opção com [espaço] (use-o novamente para desmarcar, ENTER quando terminar, Q para sair):" "$COLOR_WARNING")
    declare -a FLAGS
    FLAGS=(--label="Configuração do git" --options="${options[@]}")
    readonly FLAGS
    while selection_menu "${FLAGS[@]}" && read -rp "$prompt" -n 1 num && [[ "$num" ]]; do
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
      config_default="$(config::get "${selected}")"
      if [ "$selected" == "user.name" ]; then
        config_default+=" $(config::get "user.surname")"
      fi
      echo "Dgite um valor para git.${selected}" "$config_default"
      read -r config
      if [[ -z "$config" ]]; then
        config=$config_default
      fi
      git config --global "${selected}" "${config}"
      if git::check_config "${selected}"; then
        config::set "git.$selected" "${config}"
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
