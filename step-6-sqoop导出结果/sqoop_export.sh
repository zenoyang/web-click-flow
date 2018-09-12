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
hadoop_dir=
mysql_db_pwd=
mysql_db_name=


echo 'sqoop start'
$SQOOP_HOME/bin/sqoop export \
--connect "jdbc:mysql://master:3306/web_click_flow" \
--username $mysql_db_name \
--password $mysql_db_pwd \
--table $table_name \
--columns $table_columns \
--fields-terminated-by '\001' \
--export-dir $hadoop_dir

echo 'sqoop end'
