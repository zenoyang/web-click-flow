datestr=`date +%d-%a-%Y`
HQL="load data inpath '/azweblog/preprocessedlog/' into table azdw.ods_origin_weblog partition(datestr='$datestr')"
echo $HQL 
# /home/hadoop/apps/hive/bin/hive -e "$HQL"
