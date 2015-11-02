#!/bin/bash

VIDEO=$1
STEP=$2

HMS=`ffmpeg -i $VIDEO 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`

HMS_ARR=(${HMS//:/ })

HOUR_SECS=`echo "${HMS_ARR[0]} * 3600" | bc`
MIN_SECS=`echo "${HMS_ARR[1]} * 60" | bc`
SEC_SECS=${HMS_ARR[2]}

DURATION=`echo "( $HOUR_SECS + $MIN_SECS + $SEC_SECS ) * 10" | bc`

echo $DURATION

DURATION_SPLIT=(${DURATION//./ })

INT_DURATION=${DURATION_SPLIT[0]}

TIME=10

let INT_DURATION=INT_DURATION-STEP

CUTOFF=600

while [ $TIME -lt $INT_DURATION ]; do
	let NEXT_TIME=TIME+STEP	
	TIME0=`echo "$TIME * 0.1" | bc`
	TIME1=`echo "$NEXT_TIME * 0.1" | bc`

	DIFF=`./compareFrames.sh $VIDEO $TIME0 $TIME1`

	DIFF_ARR=(${DIFF//./ })
	DIFF_INT=${DIFF_ARR[0]}

	if [ $DIFF_INT -gt $CUTOFF ]; then
		MINS=`echo "$TIME0 * 0.01666666666" | bc`
		printf "\n%f, %0.2f, %s, %s\n" $TIME0 $MINS $DIFF
		# echo "$TIME0, $MINS, $DIFF"
	fi

	printf "."

	TIME=$NEXT_TIME
done

