#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82
MID_COLUMNS_SIZE=144
MIN_TASK_SIZE=24
MID_TASK_SIZE=40

COLUMNS=$1

if task active &>/dev/null; then
    echo -n "#[bg=black fg=white]"
    TASK=$(task rc.verbose:nothing tmux\
        | head -1 | sed 's/  */ /g' | cut -d ' ' -f 2-)
    TASK_SIZE=$(echo -n $TASK | wc -m)

    if (( $COLUMNS <= $MID_COLUMNS_SIZE )); then
        if (( $TASK_SIZE >= $MID_TASK_SIZE)); then
            TASK_TIME=$(echo $TASK | rev | cut -d ' ' -f 1 | rev)
            TRIM_SIZE=$MID_TASK_SIZE
            if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
                if (( $TASK_SIZE >= $MIN_TASK_SIZE)); then
                    TRIM_SIZE=$MIN_TASK_SIZE
                fi
            fi
            TASK_TRIM=$(echo $TASK | cut -c 1-$TRIM_SIZE)
            echo "$TASK_TRIM... $TASK_TIME "
        else
            echo "$TASK "
        fi
    else
        echo "$TASK "
    fi
fi
