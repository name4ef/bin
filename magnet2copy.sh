#!/usr/bin/env bash

if ! which xclip &>/dev/null; then
    echo "Error: xclip is not found"
    exit -1
fi
if [ $# != 1 ]; then
    echo "Usage: $0 <magnet URL>"
    exit -1
fi
STR="$1"
HASH=$(echo -n $STR \
    | cut -d "&" -f 1 \
    | rev | cut -d ":" -f 1 | rev)
echo -n $HASH | xclip
