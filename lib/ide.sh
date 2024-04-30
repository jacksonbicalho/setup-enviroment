#!/bin/bash

set -e

vscode_extensions=(EditorConfig.EditorConfig shakram02.bash-beautify eamodio.gitlens)
function vscode_install() {
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update
  apt_install code --yes
  rm -f microsoft.gpg
  sudo apt autoremove --yes
}

function select_ide() {
  PS3="Selecione uma IDE de sua preferência: "

  select ide in vs-code "Não instalar"; do
    case $ide in
    "vs-code")
      vscode_install && break
      ;;
    "Não instalar")
      echo -e "Cancelando..." && break && return 0
      ;;
    *)
      echo "Ooops"
      ;;
    esac
  done
}
