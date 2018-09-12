#!/bin/bash
# ===========================================================================
# 程序名称:     
# 功能描述:     统计pv总量最大的来源TOPN (取分组TOP)  按照时间维度，比如，统计一天内各小时产生最多pvs的来源topN
# 输入参数:     运行日期
# 目标表名:     web_click_flow_project.dw_pvs_refhost_topn_h
# 数据源表:     web_click_flow_project.dw_ref_host_visit_cnts_h
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
TARGET_TABLE=dw_pvs_refhost_topn_h
TOPN=3

HQL="
insert into table $TARGET_DB.$TARGET_TABLE partition(datestr='$TARGET_TABLE')
select a.hour, a.toporder, a.ref_host, a.ref_host_cnts from
(select concat(month,day,hour) as hour, 
row_number() over (partition by concat(month,day,hour) as hour order by ref_host_cnts desc) as toporder,
ref_host, ref_host_cnts
from $TARGET_DB.dw_ref_host_visit_cnts_h
) a where a.toporder <=$TOPN;
"
#执行hql
echo "$HQL"
$exe_hive -e "$HQL"
