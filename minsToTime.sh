#!/bin/bash

MINS=0$1
MINS_SPLIT=(${MINS//./ })
FULL_MINS=${MINS_SPLIT[0]}
SUB_MINS=${MINS_SPLIT[1]}
SUB_MIN_SECS=`echo "x = 0.$SUB_MINS * 60.0; if(x<1.0) print 0; x" | bc`
SECS_SPLIT=(${SUB_MIN_SECS//./ })
FULL_SECS=${SECS_SPLIT[0]}
if [ $FULL_SECS -lt 10 ]; then
	FULL_SECS="0$FULL_SECS"
fi
echo $FULL_MINS:$FULL_SECS
