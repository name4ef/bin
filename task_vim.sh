#!/usr/bin/env bash

PARAMS="$*"

task rc.verbose:nothing rc.defaultwidth:0 $PARAMS vim \
    | sed 's/  */ /g' \
    | while read line; do
        TASK_UID=$(echo $line | rev | cut -d ' ' -f 1 | rev)
        DESCRIPTION_RAW=$(echo $line | rev | cut -d ' ' -f 2- | rev)
        TASK_DESCRIPTION=$(echo $DESCRIPTION_RAW | sed 's/ \[[0-9]*\]$//g')
        echo " * [ ] $TASK_DESCRIPTION #$TASK_UID"
    done
