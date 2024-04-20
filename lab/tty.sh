#!/bin/bash

#Get PID of terminal
#terminal.txt holds most recent PID of console in use
value=$(<./terminal.txt)

#Get tty using the PID from terminal.txt
TERMINAL="$(ps h -p $value -o tty)"
echo $TERMINAL

#Use tty to get full filepath for terminal in use
TERMINALPATH=/dev/$TERMINAL
echo $TERMINALPATH

COLUMNS=$(./get_columns.sh)
echo $COLUMNS
