#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     每日新访客  将每天的新访客统计出来
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.dw_user_dsct_history
# 数据源表:     web_click_flow_project.ods_weblog_detail
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
TARGET_TABLE=dw_user_dsct_history

HQL="
insert into table $TARGET_DB.$TARGET_TABLE partition(datestr='$day_01')
select tmp.day as day, tmp.today_addr as new_ip  from 
(
select today.day as day, today.remote_addr as today_addr, old.ip as old_addr from 
(
select distinct remote_addr as remote_addr,'$day_01' as day from $TARGET_DB.ods_weblog_detail 
where datestr='$day_01'
) today
left outer join 
$TARGET_DB.$TARGET_TABLE old
on today.remote_addr=old.ip
) tmp
where tmp.old_addr is null;
"
#执行hql
echo "$HQL"
$exe_hive -e "$HQL"
