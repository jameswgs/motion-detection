#!/bin/bash

VIDEO=$1
POS0=$2
POS1=$3

METRIC="RMSE"
# "PSNR"

if [ ! -f $VIDEO ]; then 
	echo "file $VIDEO not found"
	exit 1
fi


rm first.bmp 2> /dev/null
rm second.bmp 2> /dev/null
rm all.bmp 2> /dev/null

ffmpeg -loglevel panic -ss $POS0 -i $VIDEO -vframes 1 all.bmp

/opt/ImageMagick/bin/convert all.bmp -crop 640x440+0+40 first.bmp

rm all.bmp

ffmpeg -loglevel panic -ss $POS1 -i $VIDEO -vframes 1 all.bmp

/opt/ImageMagick/bin/convert all.bmp -crop 640x440+0+40 second.bmp

rm all.bmp

DIFF=$( (/opt/ImageMagick/bin/compare -metric $METRIC first.bmp second.bmp /dev/null) 2>&1 )

echo $DIFF

rm first.bmp 2> /dev/null
rm second.bmp 2> /dev/null
rm all.bmp 2> /dev/null
