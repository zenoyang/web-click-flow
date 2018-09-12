#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     多维度统计PV总量  维度：月
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.dw_pvs_month
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
TARGET_TABLE=dw_pvs_month

HQL="
insert into table $TARGET_DB.$TARGET_TABLE
select sum(pvs) as pvs,month from $TARGET_DB.dw_pvs_day 
group by month having month='$smonth';
"
#执行hql
echo "$HQL"
$exe_hive -e "$HQL"
