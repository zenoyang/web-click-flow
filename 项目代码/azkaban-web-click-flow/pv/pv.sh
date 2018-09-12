#!/bin/bash
HQL="
insert into table azdw.dw_pvs_hour partition(datestr='18/Sep/2013')
select a.month as month,a.day as day,a.hour as hour,count(1) as pvs from azdw.v_time a
join azdw.ods_weblog_detail b 
on b.datestr='18/Sep/2013' and a.month=b.month and a.day=b.day and a.hour=b.hour
group by a.month,a.day,a.hour;
"
echo $HQL
/home/hadoop/apps/hive/bin/hive -e "$HQL"