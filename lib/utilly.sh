#!/bin/bash
#
# utilly package
# Reúne funções úteis usadas por todo o sistea.

set -e

#######################################
# Verifica a existência dos pacotes essenciais definidos na constante ESSENTIALS.
# Os não instalados, são oferecidos para instalação necessária para continuar
# Arguments:
#   replace_line_sleep (default: 5)
# Returns:
#   0 se tudo for bem, não zero se o usuário negar a instalção ou algum problema
#######################################
function utilly::check_essentials() {
  local replace_line_sleep="${1:-$SLEEP}"
  # clear
  echo -e "Verificando dependências..."
  echo -e ""
  sleep "$replace_line_sleep"

  not_installed=()
  for dep in "${ESSENTIALS[@]}"; do
    text=$(print_color "Verificando instalação de $dep" "$COLOR_INFO")
    utilly::replace_line "$text" "$replace_line_sleep"
    if ! utilly::is_installed "$dep"; then
      not_installed+=("$dep")
    fi
  done

  if [[ "${#not_installed[@]}" -gt 0 ]]; then
    # clear
    print_color "Os seguintes pacotes devem ser instalados para prosseguirmos:" "$COLOR_WARNING"
    for install in "${not_installed[@]}"; do
      print_color "- $install" "$COLOR_DEFAULT"
    done
    text=$(print_color "Digite ENTER para instalar" "$COLOR_INFO")
    if ! question "$text" y; then
      return 1
    fi

    utilly::apt_install "${not_installed[@]}"
    text=$(print_color "dependências instaladas com sucesso" "$COLOR_SUCCESS")
    utilly::replace_line "$text" "$replace_line_sleep"
  fi

  return 0
}

function utilly::is_email_valid() {
  regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+$"
  [[ "${1}" =~ $regex ]]
}

function utilly::is_installed() {
  pattern=$1
  if apt list --installed 2>/dev/null | grep -q "^$pattern/"; then
    return 0
  else
    return 1
  fi
}

function is_exist() {
  if [[ ${1:0:8} != *"::"* && $1 != "main" ]]; then return 1; fi
  type "${1}" &>/dev/null && return 0 || return 1
}

function file_exist() {
  if [ -f "${1}" ]; then
    return 0
  fi
  return 1
}

function utilly::is_dir() {
  if [ -d "${1}" ]; then
    return 0
  fi
  return 1
}

function join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function date_now() {
  timezone=$(config::get "timezone")
  now="$(TZ=":$timezone" date +'%Y-%m-%d %H:%M:%S')"
  echo "${now}"
}

function utilly::apt_update() {
  apt update --yes
}

function utilly::apt_upgrade() {
  apt upgrade --yes
}

function utilly::apt_dist_upgrade() {
  apt dist-upgrade --yes
}

function utilly::apt_install() {
  apt install --yes "${@}"
  return 0
}

function utilly::replace_line() {
  new_line=$1
  _sleep="${2:-$SLEEP}"
  echo -e "\e[1A\e[K$new_line"
  sleep "$_sleep"
}

function selection_menu() {
  flags="${*}"
  label="Selecione as opções:"
  case "$flags" in
    --label*)
          # shellcheck disable=SC2001
      label=$(echo "$1" | sed -e 's/^[^=]*=//g')
      shift
      ;;
    --options*)
      # shellcheck disable=SC2001
      options=$(echo "$1" | sed -e 's/^[^=]*=//g')
      shift
      ;;
  esac
  echo -e "$label"
  for i in "${!options[@]}"; do
    printf "%3d%s) %s\n" $((i + 1)) "${choices[i]:- }" "${options[i]}"
  done
  [[ "$msg" ]] && echo "$msg"
  :
}

function utilly::err() {
  local file_error_log="error.log"
  if ! utilly::is_dir "$LOG_PATH"; then
    mkdir -p "$LOG_PATH"
  fi
  if ! file_exist "$LOG_PATH/$file_error_log"; then
    touch "$LOG_PATH/$file_error_log"
  fi
  now=$(date_now)
  echo "[$now]:" "${@}" 2>&1 | tee "$LOG_PATH/$file_error_log"
}

