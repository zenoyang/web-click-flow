#!/bin/bash
if [ $# -eq 1 ]
then
    cur_date=`date --date="${1}" +%Y-%m-%d`
else
    cur_date=`date -d'-1 day' +%Y-%m-%d`
fi

echo "cur_date:"${cur_date}

year=`date --date=$cur_date +%Y`
month=`date --date=$cur_date +%m`
day=`date --date=$cur_date +%d`

table_name=""
table_columns=""
hadoop_dir=/user/rd/bi_dm/app_user_experience_d/year=${year}/month=${month}/day=${day}
mysql_db_pwd=biall_pwd2015
mysql_db_name=bi_tag_all


echo 'sqoop start'
$SQOOP_HOME/bin/sqoop export \
--connect "jdbc:mysql://hadoop03:3306/biclick" \
--username $mysql_db_name \
--password $mysql_db_pwd \
--table $table_name \
--columns $table_columns \
--fields-terminated-by '\001' \
--export-dir $hadoop_dir

echo 'sqoop end'
