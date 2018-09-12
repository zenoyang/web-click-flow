#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     回头/单次访客统计 查询今日所有回头访客及其访问次数
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.dw_user_returning
# 数据源表:     web_click_flow_project.ods_click_visit
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
TARGET_TABLE=dw_user_returning

HQL="
insert into table $TARGET_DB.$TARGET_TABLE partition(datestr='$day_01')
select tmp.day, tmp.remote_addr, tmp.acc_cnt from
(
select '$day_01' as day, remote_addr as remote_addr, count(1) as acc_cnt
from $TARGET_DB.ods_click_visit
where datestr='$day_01' 
group by remote_addr
) tmp
where tmp.acc_cnt > 1;
"
#执行hql
echo "$HQL"
$exe_hive -e "$HQL"
