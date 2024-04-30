#shellcheck shell=sh

Describe 'utilly'
  Include lib/print_color.sh
  Include lib/question.sh
  Include lib/utilly.sh

  Mock config::get
    echo "$@"
  End

  Describe 'check_essentials'

    It 'check_essentials instaled'
      Mock ESSENTIALS
        essentials=("git")
        echo "${essentials[@]}"
      End
      When call check_essentials 0
      The status should end with 0
    End

    It 'runs the check_essentials instaled'
      Mock ESSENTIALS
        essentials+=("shellspec")
        echo "${essentials[@]}"
      End
      Mock not_installed
        echo "${#not_installed[@]}"
      End

      When call check_essentials 0
      The status should end with 0
    End

    It 'check_essentials no instaled'
      # shellcheck disable=SC2034
      ESSENTIALS=("batata" "ddddddd" "gururu")
      question() {
        # shellcheck disable=SC2317
        if true ; then
          return 1
        fi
      }
      When call check_essentials 0
      The output should include "batata"
      The output should include "ddddddd"
      The output should include "gururu"
      The status should end with 1
    End

    It 'check_essentials no instaled and install'
      Mock apt
        echo 0;
      End
      # shellcheck disable=SC2034
      ESSENTIALS=("batata")
      question() {
        return 0
      }
      When call check_essentials 0
      The output should include "dependências instaladas com sucesso"
      The status should end with 0
    End

  End


  Describe 'is_email_valid'
    Describe 'emails valid'
      Parameters
        "#1" 'batata@teste.org'
        "#2" 'batata@org.br'
        "#3" 'dedo@geme.com.br'
        "#4" 'eer@saco.org'
      End

      Example "$1 is email valid $2"
        When call is_email_valid "$2"
        The status should end with 0
      End
    End

    Describe 'emails invalid'
      Parameters
        "#1" 'batata@org'
        "#2" 'b atata@org.br.tede'
        "#3" 'dedo@br'
        "#4" 'eer@saco .org'
      End

      Example "$1 is email ivalid $2"
        When call is_email_valid "$2"
        The status should end with 1
      End
    End
  End

  Describe 'is_installed'
    It 'guruguru not intaled'
      When call is_installed "guruguru"
      The status should end with 1
    End


    It 'gurugqualque.lib not intaled'
      When call is_installed "gurugqualque.lib"
      The status should end with 1
    End

    It 'git is intaled'
      When call is_installed "git"
      The status should end with 0
    End


    It 'bash is intaled'
      When call is_installed "bash"
      The status should end with 0
    End
  End


  Describe 'is_exist'
    It 'd not exist'
      When call is_exist "$d"
      The status should end with 1
    End

    It 'd exist'
      d="qualquer coisa"
      When call is_exist "$d"
      The status should end with 1
    End

  End


  Describe 'file_exist'
    It 'file /batata/5/teste.txt not exist'
      When call file_exist "/batata/5/teste.txt"
      The status should end with 1
    End

    It 'file /etc/passwd exist'
      When call file_exist "/etc/passwd"
      The status should end with 0
    End
  End


  Describe 'is_dir'
    It 'is /batata/ not is dir'
      When call is_dir "/batata/"
      The status should end with 1
    End

    It 'is /etc is dir'
      When call is_dir "/etc"
      The status should end with 0
    End
  End



  Describe 'join_by'
    array_pipe=("um" "dois" "tres")
    It 'is join by pipe'
      When call join_by "|" "${array_pipe[@]}"
      The output should equal "um|dois|tres"
    End

    It 'is join by space'
      When call join_by " " "${array_pipe[@]}"
      The output should equal "um dois tres"
    End
  End

  Describe 'apt'

    Mock apt
      echo 0;
    End

    It 'apt_update simple'
      When call apt_update
      The output should equal 0
    End


    It 'apt_upgrade simple'
      When call apt_upgrade
      The output should equal 0
    End

    It 'apt_dist_upgrade simple'
      When call apt_dist_upgrade
      The output should equal 0
    End

    It 'apt_install simple'
      When call apt_install
      The output should equal 0
    End
  End


# while selection_menu "${options[@]}" && read -rp "$prompt" -n 1 num && [[ "$num" ]]; do
  Describe 'selection_menu'
    It 'should options'
      When call selection_menu '("name" "bird")'
      The output should include 'Selecione as opções:'
      The output should include 'name'
      The output should include 'bird'
      The status should end with 0
    End
  End


  LOG_PATH="./logs"
  Describe 'utilly::err'
    setup() { rm -rf "$LOG_PATH"; }
    Before 'setup'
    After 'setup'
    It 'should return date and eerror'
      When call utilly::err 'goiaba'
      text=$(cat "$LOG_PATH/error.log")
      The output should include "$text"
    End
  End

End

