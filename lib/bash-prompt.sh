#!/bin/bash

set -e

function __bash_prompt() {
  cat <<'EOF' >~/.bash_prompt
  export PS1='\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]$ '
EOF

  sed -i '/bash_prompt/d' ~/.bashrc
  echo -e "[ -f ~/.bash_prompt ] && source ~/.bash_prompt" >>~/.bashrc
}
