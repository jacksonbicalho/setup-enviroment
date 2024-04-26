#!/bin/bash

Describe 'utilly'
  Include src/utilly.sh

  Mock apt
    echo 0
  End

  Describe 'check_dependencies'
    It 'runs the check_dependencies'
      When call check_dependencies
      The output should equal 'false'
    End
  End

  # Describe 'is_email_valid'
  #   It 'return true'
  #     func(){
  #       # shellcheck disable=SC2317
  #       if ! is_email_valid "$1"; then
  #         echo "false"
  #       else
  #         echo "true"
  #       fi
  #     }
  #     When run func 'teste@com.br'
  #     The output should equal 'true'
  #   End

  #   It 'return false'
  #     func(){
  #       # shellcheck disable=SC2317
  #       if ! is_email_valid "$1"; then
  #         echo "false"
  #       else
  #         echo "true"
  #       fi
  #     }
  #     When run func 'teste%%....%com.br'
  #     The output should equal 'false'
  #   End

  # End

  # Describe 'is_dir'

  #   It 'return false'
  #     func(){
  #       if ! is_dir "$1"; then
  #         echo "false";
  #       fi
  #     }
  #     When run func "/teste/kjjjj"
  #     The output should equal 'false'
  #   End

  # End

End

