#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82
MID_COLUMNS_SIZE=144
MAX_WIDTH=40

COLUMNS=$1

if mpc|grep -q playing; then
    echo -n "#[bg=black fg=green]"
    if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
        #echo "■ ⏏ "
        echo "▶ "
    else
        MPC_LINE=$(mpc current -f '%title% (%date%) %artist%'|sed 's/ *$//')
        MPC_LINE_SIZE=$(echo $MPC_LINE | wc -m)
        if (( $COLUMNS <= $MID_COLUMNS_SIZE )); then
            if (( $MPC_LINE_SIZE > $MAX_WIDTH )); then
                MPC_LINE_TRIM=$(echo $MPC_LINE \
                    | cut -c 1-$MAX_WIDTH \
                    | sed 's/ $//g')
                echo "$MPC_LINE_TRIM... "
            else
                echo "$MPC_LINE "
            fi
        else
            echo "$MPC_LINE "
        fi
    fi
elif mpc|grep -q paused; then
    echo -n "#[bg=black fg=green]"
    echo "♫ "
fi
