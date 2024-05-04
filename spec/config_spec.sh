#shellcheck shell=ksh

Describe 'Config'
  Include lib/print_color.sh
  Include lib/utilly.sh
  Include lib/config.sh

  ROOT_DIR="./spec/mocks"
  CONFIG_PATH="$ROOT_DIR/config"
  APP_CONFIG_FILE="$CONFIG_PATH/mock.json"

  Mock APP_CONFIG_FILE
    echo "${APP_CONFIG_FILE}"
  End

  Mock SLEEP
    echo 0
  End

  setup() { rm -rf "$CONFIG_PATH"; }
  BeforeAll 'setup'
  AfterAll 'setup'


  Describe 'config::init'
    Data 'config_read'
    It 'should return 0 with success'
      When call config::init 0
      The output should include 'finalizada com sucesso'
    End

    It 'should create diretory config'
      When call config::init 0
      The output should include 'finalizada com sucesso'
    End


  End

  Describe 'get_version'
    VERSION_FILE="$ROOT_DIR/version"
    Mock VERSION_FILE
      echo "${VERSION_FILE}"
    End

    create_file() { echo "abc" > "$VERSION_FILE"; }
    delete_file() { rm -f "$VERSION_FILE"; }
    Before 'create_file'
    After 'delete_file'
    It 'should define variable no existent'
      When call get_version
      The output should eq 'abc'
      The status should end with 0
    End

    It 'should create file version if not exist'
      delete_file
      When call get_version
      The output should eq '0.0.0-dev'
      The status should end with 0
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
    It 'should return value defined prev'
      When call config::get 'fruta'
      The output should eq "morango"
    End

    It 'should return value defined 0.0.1'
      config::set 'configuration' '0.0.1'
      When call config::get 'configuration'
      The output should eq '0.0.1'
    End

    It 'cannot exist config'
      When call config::get 'not_exist'
      The status should end with 1
    End
  End

  Describe 'get_timezone_system'
      It 'should return timezone system'
      timezone=$(cat /etc/timezone)
      When call get_timezone_system
      The output should eq  "$timezone"
      The status should end with 0
    End
  End

End

