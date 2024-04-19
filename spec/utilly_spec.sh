#!/bin/bash

Describe 'utilly'
  Include src/utilly.sh

  # Describe '_check_dependencies'
  #   _check_dependencies() {
  #     apt_install
  #   }

  #   It 'runs the _check_dependencies'
  #     When call _check_depend \
  #       "Instalando pacotes necessários..." \
  #       "Pronto!"
  #   End
  # End

  Describe 'is_email_valid'
    Include src/utilly.sh
    It 'return true'
      func(){
        if ! is_email_valid "$1"; then
          echo "false"
        else
          echo "true"
        fi
      }
      When run func 'teste@com.br'
      The output should equal 'true'
    End

    It 'return false'
      func(){
        if ! is_email_valid "$1"; then
          echo "false"
        else
          echo "true"
        fi
      }
      When run func 'teste%%....%com.br'
      The output should equal 'false'
    End






  End

  Describe '__is_dir'

    It 'return false'
      func(){
        if ! __is_dir "$1"; then
          echo "false";
        fi
      }
      When run func "/teste/kjjjj"
      The output should equal 'false'
    End

  End

End
