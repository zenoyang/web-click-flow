#!/bin/bash
HQL="
insert into table azdw.ods_weblog_detail partition(datestr='18/Sep/2013')
select c.valid,c.remote_addr,c.remote_user,c.time_local,substring(c.time_local,0,11) as daystr,
substring(c.time_local,13) as timestr,
substring(c.time_local,4,3) as month,
substring(c.time_local,0,2) as day,
substring(c.time_local,13,2) as hour,
c.request,c.status,c.body_bytes_sent,c.http_referer,c.ref_host,c.ref_path,c.ref_query,c.ref_query_id,c.http_user_agent
from
(SELECT 
a.valid,a.remote_addr,a.remote_user,a.time_local,
a.request,a.status,a.body_bytes_sent,a.http_referer,a.http_user_agent,b.ref_host,b.ref_path,b.ref_query,b.ref_query_id 
FROM azdw.ods_origin_weblog a LATERAL VIEW parse_url_tuple(regexp_replace(http_referer, \"\\\"\", \"\"), 'HOST', 'PATH','QUERY', 'QUERY:id') b as ref_host, ref_path, ref_query, ref_query_id) c
"
echo $HQL
/home/hadoop/apps/hive/bin/hive -e "$HQL"