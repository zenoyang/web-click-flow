#!/bin/bash
function SendText
{
   phoneList=($1)
   msg=$2
   for iPhone in ${phoneList[@]}
   do
      php ~/global_tools/sms.php $iPhone "$msg" 
   done
} 

function wait4FlagFile(){
    	FILE_SYS=$1
        INPUT_PATH=$2
        FLAG_FILE_NAME=$3
        TARGET_MONITORS=$4
        clock=0
        waitingHours=0
        while true
        do
                if [ "$FILE_SYS" == "HDFS" ]
                then
                        hadoop fs -ls ${INPUT_PATH}/${FLAG_FILE_NAME} && result=$? || result=$?
                        echo ${INPUT_PATH}/${FLAG_FILE_NAME}
                else
                        if [ -e ${INPUT_PATH}/${FLAG_FILE_NAME} ]
                        then
                                result=0
                        fi
                fi

                if [ $result -eq 0 ]
                then
                        if [ $waitingHours \> 0.5 ]
                                then
                                 SendText "$TARGET_MONITORS" "文件 ${INPUT_PATH}/${FLAG_FILE_NAME} 已经到达"
                        fi
                        break
                else
                        echo 'Source file not ready, sleep 10 secs'
                        sleep 10
                    ((clock=$clock+10))
                        if [ $[$clock%1500] -eq 0 ]
                        then
                                waitingHours=$(echo "scale=1;$clock/3600"|bc)
                                echo "Already waiting for       ${waitingHours} hours!"
                               #SendText "$TARGET_MONITORS" "文件 ${INPUT_PATH}/${FLAG_FILE_NAME} 已经等待 ${waitingHours}小时了"
                        fi
                fi
        done
}

#wait4FlagFile HDFS /user/hive/warehouse/dw.db/t_order/dt=2015-10-10 _SUCCESS 18612039282

