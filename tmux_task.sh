#!/usr/bin/env bash

MIN_COLUMNS_SIZE=82
DEFAULTWIDTH=60
POSTFIX=" "

COLUMNS=$1

if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
    DEFAULTWIDTH=32
    POSTFIX="... "
fi

echo -n "#[bg=black fg=white]"

if task active &>/dev/null; then
    TASK=$(task rc.verbose:nothing rc.defaultwidth:$DEFAULTWIDTH tmux\
        |head -1 |sed 's/  */ /g' |cut -d ' ' -f 2-)
    echo "${TASK}${POSTFIX}"
fi
