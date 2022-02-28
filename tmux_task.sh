#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82
MIN_TASK_SIZE=32
MAX_WIDTH=60

COLUMNS=$1

if task active &>/dev/null; then
    echo -n "#[bg=black fg=white]"
    TASK=$(task rc.verbose:nothing rc.defaultwidth:$MAX_WIDTH tmux\
        | head -1 | sed 's/  */ /g' | cut -d ' ' -f 2-)
    LENGTH=$(echo -n $TASK | wc -m)
    if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
        if (( $LENGTH > $MIN_TASK_SIZE)); then
            echo "$(echo $TASK | cut -c 1-$MIN_TASK_SIZE)... "
        else
            echo "$TASK "
        fi
    else
        echo "$TASK "
    fi
fi
