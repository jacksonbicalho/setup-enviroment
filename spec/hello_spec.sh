Describe 'hello.sh'
  Include lib/hello.sh
  It 'says hello'
    When call hello ShellSpec
    The output should equal 'Hello ShellSpec!'
  End
  It 'says hello2'
    When call hello2 ShellSpec
    The output should equal 'goiaba ShellSpec!'
  End
End
