#!/bin/bash

Describe 'config'
  Include src/utilly.sh
  Include src/config.sh

  ROOT_DIR=$(dirname "$0")
  CONFIG_PATH="$ROOT_DIR/config/"
  APP_CONFIG_FILE="$CONFIG_PATH/mock.json"

  Mock APP_CONFIG_FILE
    echo "${APP_CONFIG_FILE}"
  End

  Describe 'init_config'
    It 'init_config'
      When call init_config
      The status should end with 0
    End

    It 'version '
      version=$(get_version)
      When call get_config 'version'
      The output should eq "$version"
    End

  End

  Describe 'set_config'
    It 'should define variable no existent'
      When call set_config 'fruta' 'goiaba'
      The status should end with 0
    End

    It 'should change variable existent'
      When call set_config  'fruta' 'morango'
      The status should end with 0
    End

    It 'should return variable changed previus'
      When call get_config  'fruta'
      The output should eq 'morango'
    End


  End

  Describe 'change_var'
    It 'should existent variable'
      set_config 'variable1' 'xxx'
      When call change_var 'variable1' '123'
      The status should end with 0
    End

    It 'should return variable changed previus'
      When call get_config 'variable1'
      The output should eq '123'
    End


    It 'should change variable existent'
      set_config 'fruta' 'morango'
      When call get_config 'fruta'
      The output should eq 'morango'
    End

  End


  Describe 'get_config'
    It ' run external commands without mocking'
      When call get_config 'fruta'
      The output should eq "morango"
    End

    It 'cannot run external commands without mocking'
      set_config 'version' '0.0.1'
      When call get_config 'version'
      The output should eq '0.0.1'
    End

    It 'cannot exist config'
      When call get_config 'not_exist'
      The status should end with 1
    End

  End

End

