#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82

COLUMNS=$1

if mpc|grep -q playing; then
    echo -n "#[bg=black fg=green]"
    if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
        #echo "■ ⏏ "
        echo "▶ "
    else
        echo "$(mpc current -f '%title% (%date%) %artist%'|sed 's/ *$//') "
    fi
elif mpc|grep -q paused; then
    echo -n "#[bg=black fg=green]"
    echo "♫ "
fi
