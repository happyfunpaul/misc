#!/bin/bash

ROTATION="akamai-rotation-fqdn-goes-here"
URL="http://$ROTATION/akamai"
INTERVAL=5

function gethostinfo {
	echo `host $ROTATION | grep address | sed 's/has address //'`
}

function fetchit {
	# curl, exiting >0 if document errors 404 or eotherwise.
        # Don't actually show progress, or the document.
	local TIME=`/usr/bin/time -f '%E' curl -fs -o /dev/null \'$URL\' 2>&1`
	if [ $? -eq 0 ]; then 
		echo "OK ($TIME)"
	else
		echo "FAILED! ($TIME)"
	fi
}

while /bin/true
do
	DATE=`date -u +'%m/%d %T'`
	DNS=`gethostinfo $ROTATION`
	HEALTH=`fetchit`
	echo "$DATE $DNS $HEALTH"	

	sleep $INTERVAL
done


