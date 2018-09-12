#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     抽取明细宽表
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.ods_weblog_detail
# 数据源表:     web_click_flow_project.ods_weblog_origin
#   创建人:     ZenoYang
# 创建日期:     2018-03-21
# 版本说明:     v1.0
# 代码审核:     
# 修改人名:
# 修改日期:
# 修改原因:
# 修改列表: 
# ===========================================================================
### 1.参数加载
exe_hive="/usr/local/hive/bin/hive"
if [ $# -eq 1 ]
then
    day_01=`date --date="${1}" +%Y-%m-%d`
else
    day_01=`date -d'-1 day' +%Y-%m-%d`
fi
syear=`date --date=$day_01 +%Y`
smonth=`date --date=$day_01 +%m`
sday=`date --date=$day_01 +%d`

TARGET_DB=web_click_flow_project
TARGET_TABLE=ods_weblog_detail

### 2.定义执行HQL
HQL="
insert into table $TARGET_DB.$TARGET_TABLE partition(datestr='$day_01')
select c.valid,c.remote_addr,c.remote_user,c.time_local,
substring(c.time_local,0,10) as daystr,
substring(c.time_local,12) as tmstr,
substring(c.time_local,6,2) as month,
substring(c.time_local,9,2) as day,
substring(c.time_local,11,3) as hour,
c.request,
c.status,
c.body_bytes_sent,
c.http_referer,
c.ref_host,
c.ref_path,
c.ref_query,
c.ref_query_id,
c.http_user_agent
from
(SELECT 
a.valid,
a.remote_addr,
a.remote_user,a.time_local,
a.request,a.status,a.body_bytes_sent,a.http_referer,b.ref_host,b.ref_path,b.ref_query,b.ref_query_id,a.http_user_agent  
FROM $TARGET_DB.ods_weblog_origin a 
LATERAL VIEW 
parse_url_tuple(regexp_replace(http_referer, \"\\\"\", \"\"), 'HOST', 'PATH','QUERY', 'QUERY:id') b 
as ref_host, ref_path, ref_query, ref_query_id) c
"

#执行hql
echo "$HQL"
$exe_hive -e "$HQL"

#异常处理
#如果失败，发送邮件、短信