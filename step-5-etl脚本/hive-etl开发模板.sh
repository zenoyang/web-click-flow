#!/bin/bash
. /.../wait4FlagFile.sh
# ===========================================================================
# 程序名称:     
# 功能描述:     
# 输入参数:     
# 目标表名:     
# 数据源表:     
#   创建人:     
# 创建日期:     
# 版本说明:     
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

TARGET_DB=
TARGET_TABLE=

### 2.定义执行HQL
HQL=""

### 3.检查依赖
wait4FlagFile HDFS /user/hive/warehouse/xxx/xxx/dt=${day_01} _SUCCESS 155xxxxxxxx

#### 4.执行HQL
$exe_hive -e "$HQL"

#### 5. 判断代码是否执行成功，touch控制文件
result=`hadoop fs -ls /user/hive/warehouse/${TARGET_DB}/${TARGET_TABLE}/dt=${day_01} | wc -l`
if [[ $result -gt 0 ]]; then
    hadoop fs -touchz /user/hive/warehouse/${TARGET_DB}/${TARGET_TABLE}/dt=${day_01}/_SUCCESS
else
    echo "失败发送预警短信和邮件"
fi
