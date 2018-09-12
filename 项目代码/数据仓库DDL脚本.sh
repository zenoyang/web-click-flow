#数据仓库DDL

create database web_click_project;
use web_click_project;


#ods贴源表
drop table if exists ods_weblog_origin;
create table ods_weblog_origin(
valid string,
remote_addr string,
remote_user string,
time_local string,
request string,
status string,
body_bytes_sent string,
http_referer string,
http_user_agent string)
partitioned by (datestr string)
row format delimited
fields terminated by '\001';



#ods点击流pageviews表
#加一个字段   user string,
drop table if exists ods_click_pageviews;
create table ods_click_pageviews(
Session string,
remote_addr string,
time_local string,
request string,
visit_step string,
page_staylong string,
http_referer string,
http_user_agent string,
body_bytes_sent string,
status string)
partitioned by (datestr string)
row format delimited
fields terminated by '\001';


#点击流visit表
drop table if exist ods_click_visit;
create table ods_click_visit(
session     string,
remote_addr string,
inTime      string,
outTime     string,
inPage      string,
outPage     string,
referal     string,
pageVisits  int)
partitioned by (datestr string);



#etl明细宽表
drop table ods_weblog_detail;
create table ods_weblog_detail(
valid           string, --有效标识
remote_addr     string, --来源IP
remote_user     string, --用户标识
time_local      string, --访问完整时间
daystr          string, --访问日期
timestr         string, --访问时间
month           string, --访问月
day             string, --访问日
hour            string, --访问时
request         string, --请求的url
status          string, --响应码
body_bytes_sent string, --传输字节数
http_referer    string, --来源url
ref_host        string, --来源的host
ref_path        string, --来源的路径
ref_query       string, --来源参数query
ref_query_id    string, --来源参数query的值
http_user_agent string --客户终端标识
)
partitioned by(datestr string);

#时间维度表
create table v_time(year string,month string,day string,hour string)
row format delimited
fields terminated by ',';

load data local inpath '/home/hadoop/v_time.txt' into table v_time;


#每小时pv统计表
drop table dw_pvs_hour;
create table dw_pvs_hour(month string,day string,hour string,pvs bigint) partitioned by(datestr string);

#每日用户平均pv
drop table dw_avgpv_user_d;
create table dw_avgpv_user_d(
day string,
avgpv string);

#来源维度PV统计表(小时粒度)
drop table zs.dw_pvs_referer_h;
create table zs.dw_pvs_referer_h(referer_url string,referer_host string,month string,day string,hour string,pv_referer_cnt bigint) partitioned by(datestr string);

#每小时来源PV topn
drop table zs.dw_pvs_refhost_topn_h;
create table zs.dw_pvs_refhost_topn_h(
hour string,
toporder string,
ref_host string,
ref_host_cnts string
) partitioned by(datestr string);