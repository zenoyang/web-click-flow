#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     人均浏览页数 (今日所有来访者，平均请求的页面数)
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.dw_avgpv_user_d
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
TARGET_TABLE=dw_avgpv_user_d

HQL="
insert into table $TARGET_DB.$TARGET_TABLE
select '$day_01', sum(b.pvs)/count(b.remote_addr) from
(select remote_addr, count(1) as pvs from $TARGET_DB.ods_weblog_detail where datestr = '$day_01'
group by remote_addr) b;
"
#执行hql
echo "$HQL"
$exe_hive -e "$HQL"
