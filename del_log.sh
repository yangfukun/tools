#! /bin/bash

#set -x

if [ $# != 3 ] ; then 
	echo "USAGE: $0 LOG_PATH LOG_NAME DAYS" 
	echo "delete logs before 30 days. e.g.: $0 /home/admin/nqp-prober/logs nqp-prober 30" 
	exit 1; 
fi

LOG_PATH=$1
LOG_NAME=$2
DAYS=$3

echo "LOG_PATH = $1, LOG_NAME = $2, DAYS = $3"

cd $LOG_PATH

tmpFile=del_file.dat

ls -l | grep "$LOG_NAME.log." | awk '{print $NF}' > $tmpFile

echo "delete these log file ==================="
echo "start delete ..."

function compDate() {
	t1=`date -d $1 +%s` 
	t2=`date -d $2 +%s`
	#echo $t1, $t2
	if [ $t1 -gt $t2 ]; then  
		echo 1	
	elif [ $t1 -eq $t2 ]; then  
		echo 0
	else  
		echo 2
	fi
}

now=$(date +%Y-%m-%d)
old=$(date -d -"$DAYS"day +%Y-%m-%d)
#date -d -30day +%Y-%m-%d
#echo "now = $now"
echo "old = $old"

echo "-------------"
while read LINE
do
	logDate=$(echo $LINE | awk -F. '{print $NF}')
	#echo $logDate
	i=$(compDate $logDate $old)
	#echo '-----------> ' $i
	if [ $i -eq 2 ]; then
		echo "delete $LINE ..."
	    rm -f $LINE	
	fi
done  < $tmpFile
