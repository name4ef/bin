#!/usr/bin/env bash

PATH=$PATH:/sbin

if [ ! -x `which pv` ]; then
    echo 'ERROR: pv not found'
    exit -1
elif [[ $# < 2 ]]; then
    echo "Usage: ddpv.sh <form> <to>"
    exit -1
fi

FROM=$1
TO=$2

case `uname -s` in
    'Darwin')
        #SIZE=$(ls -l $FROM | cut -d " " -f 8)
        #BLOCKSIZE="1m"
        echo 'For macOS under work. Not done yet.'; exit 1
        ;;
    'Linux')
        if [ -f $FROM ]; then
            SIZE=$(ls -l $FROM | cut -d " " -f 5)
        elif [ -b $FROM ]; then
            SIZE=$(fdisk -l $FROM | grep $FROM: | cut -d " " -f 5)
        else
            echo "Error: $FROM is not regular or block special file"; exit 1;
        fi
        BLOCKSIZE="64K"
        ;;
    *)
        echo 'Operation system is not supported'; exit 1
esac

dd if=$FROM bs=$BLOCKSIZE iflag=sync 2>/dev/null \
    | pv -s $SIZE \
    | dd of=$TO bs=$BLOCKSIZE oflag=sync 2>/dev/null
sync
printf '\a'
