#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82
MID_COLUMNS_SIZE=144
MIN_TASK_SIZE=24
MID_TASK_SIZE=40

COLUMNS=$1

if task active &>/dev/null; then
    TASK=$(task rc.verbose:nothing tmux\
        | head -1 | sed 's/  */ /g' | cut -d ' ' -f 2-)
    TASK_SIZE=$(echo -n $TASK | wc -m)
    TASK_TITLE=$(echo $TASK \
        | cut -d ' ' -f 2- \
        | rev | cut -d ' ' -f 2- | rev \
        | sed 's/ *$//')
    TIME_ESTIMATED=$(echo $TASK | rev | cut -d ' ' -f 1 | rev)
    TIME_SPEND=$(echo $TASK | cut -d ' ' -f 1)

    if (( $COLUMNS <= $MID_COLUMNS_SIZE )); then
        if (( $TASK_SIZE >= $MID_TASK_SIZE)); then
            TRIM_SIZE=$MID_TASK_SIZE
            if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
                if (( $TASK_SIZE >= $MIN_TASK_SIZE)); then
                    TRIM_SIZE=$MIN_TASK_SIZE
                fi
            fi
            TASK_TITLE=$(echo $TASK_TITLE | cut -c 1-$TRIM_SIZE)
            TASK_TITLE="$TASK_TITLE..."
        fi
    fi

    echo -n "#[bg=black fg=white]$TIME_SPEND "
    echo -n "#[fg=#ffffff]$TASK_TITLE "
    echo -n "#[fg=white]$TIME_ESTIMATED "
fi
