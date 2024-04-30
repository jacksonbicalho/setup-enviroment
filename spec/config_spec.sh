#shellcheck shell=sh

Describe 'Config'
  Include lib/print_color.sh
  Include lib/utilly.sh
  Include lib/config.sh

  ROOT_DIR="/tmp"
  CONFIG_PATH="$ROOT_DIR/config/"
  APP_CONFIG_FILE="$CONFIG_PATH/mock.json"

  Mock APP_CONFIG_FILE
    echo "${APP_CONFIG_FILE}"
  End


  Mock CONFIGS_INI
    # shellcheck disable=SC3054
    echo "${CONFIGS_INI[@]}"
  End

  Describe 'config::init'
    It 'should return 0'
      When call config::init 0
      The output should include 'finalizada com sucesso'
    End

    It 'version '
      When call config::set 'version' "abc"
      The status should end with 0
    End

    It 'version '
      When call config::get 'version'
      The output should eq "abc"
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

