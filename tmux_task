#!/usr/bin/env bash

MIN_COLUMNS_SIZE=96
MID_COLUMNS_SIZE=144
MIN_TASK_SIZE=24
MID_TASK_SIZE=40

COLUMNS=$1

time_to_sec()
{
    TOTAL_SEC=0

    read -r input
    for i in $input; do
        H=$(echo $i | cut -d ':' -f 1)
        M=$(echo $i | cut -d ':' -f 2 | sed 's/^0//g')
        S=$(echo $i | cut -d ':' -f 3 | sed 's/^0//g')
        TOTAL_SEC=$(($S + $M*60 + $H*60*60 + $TOTAL_SEC))
    done

    echo -n $TOTAL_SEC
}

sec_to_hms()                                 # hsm - hours minutes seconds
{
    read -r input
    H=$(($input / 3600))
    M=$((($input - $H*3600) / 60))
    S=$(($input - $H*3600 - $M*60))

    echo -n "${H}h${M}min"
}

if ! task active &>/dev/null; then
    exit 0
fi

TASK=$(task rc.verbose:nothing rc.defaultwidth:0 tmux\
    | head -1 | sed 's/  */ /g' | cut -d ' ' -f 2-)
TASK_SIZE=$(echo -n $TASK | wc -m)
TASK_TITLE=$(echo $TASK \
    | cut -d ' ' -f 2- \
    | rev | cut -d ' ' -f 2- | rev \
    | sed 's/ *$//')
TIME_ESTIMATED=$(echo $TASK \
    | rev | cut -d ' ' -f 1 | rev \
    | sed 's/(//g' | sed 's/)//g')
TIME_SPEND=$(echo $TASK | cut -d ' ' -f 1)

if (( $COLUMNS <= $MID_COLUMNS_SIZE )); then
    if (( $TASK_SIZE >= $MID_TASK_SIZE)); then
        TRIM_SIZE=$MID_TASK_SIZE
        if (( $COLUMNS <= $MIN_COLUMNS_SIZE )); then
            if (( $TASK_SIZE >= $MIN_TASK_SIZE)); then
                TRIM_SIZE=$MIN_TASK_SIZE
            fi
        fi
        TASK_TITLE=$(echo $TASK_TITLE \
            |cut -c 1-$TRIM_SIZE \
            |sed 's/ *$//')
        TASK_TITLE="$TASK_TITLE..."
    fi
fi

DURATIONS=$(task +ACTIVE info \
    | grep duration \
    | rev | cut -d ' ' -f 1 | rev \
    | sed 's/).//g')
if [[ ! x$DURATIONS == "x" ]]; then
    DURATIONS=$(echo -n $DURATIONS | time_to_sec | sec_to_hms)
    TIME_ESTIMATED=$(echo "$DURATIONS of $TIME_ESTIMATED")
fi

echo -n "#[bg=black fg=white]$TIME_SPEND "
echo -n "#[fg=#ffffff]$TASK_TITLE "
echo -n "#[fg=white]($TIME_ESTIMATED) "
