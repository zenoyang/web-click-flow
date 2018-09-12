#!/bin/bash
. /home/anjianbing/soft/functions/wait4FlagFile.sh
# ===========================================================================
# 程序名称:     
# 功能描述:     城市每日完成订单数
# 输入参数:     运行日期
# 目标表名:     app.app_order_city_d
# 数据源表:     dw.dw_order
#   创建人:     任我行
# 创建日期:     2016-12-21
# 版本说明:     v1.0
# 代码审核:     
# 修改人名:
# 修改日期:
# 修改原因:
# 修改列表: 
# ===========================================================================
### 1.参数加载
exe_hive="hive"
if [ $# -eq 1 ]
then
    day_01=`date --date="${1}" +%Y-%m-%d`
else
    day_01=`date -d'-1 day' +%Y-%m-%d`
fi
syear=`date --date=$day_01 +%Y`
smonth=`date --date=$day_01 +%m`
sday=`date --date=$day_01 +%d`

TARGET_DB=app.db
TARGET_TABLE=app_order_city_d

### 2.定义执行HQL
HQL="insert overwrite table app.app_order_city_d partition (dt='${day_01}')
SELECT city_id,COUNT(1) FROM dw.dw_order WHERE dt='${day_01}' 
AND order_status=5 GROUP BY city_id;
"
### 3.检查依赖
wait4FlagFile HDFS /user/hive/warehouse/dw.db/dw_order/dt=${day_01} _SUCCESS 18612039282

#### 4.执行HQL
$exe_hive -e "$HQL"

#### 5. 判断代码是否执行成功，touch控制文件
result=`hadoop fs -ls /user/hive/warehouse/${TARGET_DB}/${TARGET_TABLE}/dt=${day_01} | wc -l`
if [[ $result -gt 0 ]]; then
    hadoop fs -touchz /user/hive/warehouse/${TARGET_DB}/${TARGET_TABLE}/dt=${day_01}/_SUCCESS
else
    echo "失败发送预警短信和邮件"
fi
