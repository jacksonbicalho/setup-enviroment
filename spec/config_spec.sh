#!/bin/bash

Describe 'Config'

  Include src/utilly.sh
  Include src/config.sh

  ROOT_DIR=$(dirname "$0")
  CONFIG_PATH="$ROOT_DIR/config/"
  APP_CONFIG_FILE="$CONFIG_PATH/mock.json"
  CONFIGS_INI=("a")

  Mock APP_CONFIG_FILE
    echo "${APP_CONFIG_FILE}"
  End


  Mock CONFIGS_INI
    echo "${CONFIGS_INI[@]}"
  End


  Mock utilly::prompt_input
    echo "$@"
  End


  Describe 'config::init'
    It 'should return 0'
      When call config::init
      The status should end with 0
    End

    It 'version '
      version=$(get_version)
      When call config::get 'version'
      The output should eq "$version"
    End

  End

  Describe 'config::set'
    It 'should define variable no existent'
      When call config::set 'fruta' 'goiaba'
      The status should end with 0
    End

    It 'should change variable existent'
      When call config::set  'fruta' 'morango'
      The status should end with 0
    End

    It 'should return variable changed previus'
      When call config::get  'fruta'
      The output should eq 'morango'
    End


  End

  Describe 'change_var'
    It 'should existent variable'
      config::set 'variable1' 'xxx'
      When call change_var 'variable1' '123'
      The status should end with 0
    End

    It 'should return variable changed previus'
      When call config::get 'variable1'
      The output should eq '123'
    End


    It 'should change variable existent'
      config::set 'fruta' 'morango'
      When call config::get 'fruta'
      The output should eq 'morango'
    End

  End


  Describe 'config::get'
    It ' run external commands without mocking'
      When call config::get 'fruta'
      The output should eq "morango"
    End

    It 'cannot run external commands without mocking'
      config::set 'version' '0.0.1'
      When call config::get 'version'
      The output should eq '0.0.1'
    End

    It 'cannot exist config'
      When call config::get 'not_exist'
      The status should end with 1
    End

  End

End

