#!/usr/bin/env bash

STATUS_CURRENT=$(tmux show -q status)
if [[ $STATUS_CURRENT == "" ]]; then
    STATUS_CURRENT=$(tmux show -qg status)
fi

if [ "$STATUS_CURRENT" == "status on" ]; then
    tmux set status off
elif [ "$STATUS_CURRENT" == "status off" ]; then
    tmux set status on
fi
