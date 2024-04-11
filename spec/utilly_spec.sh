#!/bin/bash

Describe 'utilly'
  Include src/utilly.sh
  Describe '__is_dir'

    It 'return false'
      func(){
        if ! __is_dir "$1"; then
          echo "false";
        fi
      }
      When run func "/teste/kjjjj"
      The output should equal 'true'
    End

  End

End

