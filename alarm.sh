#!/bin/bash

usage="Usage: $0 [-t title] [-m msg]"

# ==========================================================
# ATTENTIAION:  you should change USERNAME, LDIR & RDIR
# ==========================================================
if [ ${lplatform} == "Darwin" ] ; then
USERNAME="USERNAME"
else
USERNAME="USERNAME"
fi

if [ ${rplatform} == "Darwin" ] ; then
RDIR="/Users/${USERNAME}/osdalarm/"
else
RDIR="/home/${USERNAME}/osdalarm/"
fi

LDIR="${HOME}/osdalarm/"

host="localhost" # you may trigger osd from other machine

# ==========================================================
# Change the rest part for your fun.
# ==========================================================

# local platform
lplatform=`uname`

# rplatform can be replaced with remote system, ex. "Darwin" or "Linux"
rplatform=`uname`

# bubble stays for how long (in milliseconds)?
timeout=5000

MAXCOUNT=38

while getopts t:m: o
do
	case "$o" in 
		t)
			title="$OPTARG"
			;;
		m)
			msg="$OPTARG"
			;;
		[?]) 
			echo >&2 ${usage}
			exit 1
			;;
	esac
done

if [ -z ${title} ] ; then
	title="*BUZZ*"
fi

if [ -z ${msg} ] ; then
seed=$RANDOM
let "seed %= ${MAXCOUNT}"
msg="`cat ${LDIR}/alarm.texts/motif${seed}.txt`"
fi

icon="${RDIR}/alarm.pics/sexy${seed}.jpg"

date="$(echo ""; echo -n "@"; date +"%a %H:%M")"

if [ ${rplatform} == "Darwin" ] ; then
/usr/local/bin/growlnotify -t "${title}" -m "${msg} ${date}" --image ${icon}
else
ssh  -X ${USERNAME}@${host} "DISPLAY=:0 notify-send -u critical -i ${icon} \"${title}\" \"${msg} ${date}\""
fi
