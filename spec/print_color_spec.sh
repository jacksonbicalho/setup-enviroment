#!/bin/bash

Describe 'print_color'
  Include src/print_color.sh

    Describe 'colors valids'
      Parameters
        "#1" "${COLOR_INFO}"
        "#2" "${COLOR_SUCCESS}"
        "#3" "${COLOR_WARNING}"
        "#4" "${COLOR_DANGER}"
        "#5" "${COLOR_DEFAULT}"
      End

      Example "$1 is color valid"
        When call print_color 'test' "$2"
        The output should include 'test'
      End
    End


    Describe 'colors invalids'
      Parameters
        "#1" "${COLOR_INFO}\3m"
        "#2" "${COLOR_SUCCESS}\3m"
        "#3" "${COLOR_WARNING}\3m"
        "#4" "${COLOR_DANGER}\3m"
        "#5" "${COLOR_DEFAULT}\3m"
      End

      Example "$1 is color invalid"
        When call print_color 'test' "$2"
        The output should include 'não é uma opção válida'
        The status should end with 1
      End
    End



End
