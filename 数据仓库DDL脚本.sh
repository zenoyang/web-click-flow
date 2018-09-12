#数据仓库DDL

create database web_click_flow_project;
use web_click_flow_project;


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
request string,
time_local string,
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
drop table if exists ods_click_visit;
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

# 时间维表创建
drop table if exists dim_time;
create table dim_time(
year string,
month string,
day string,
hour string)
row format delimited
fields terminated by ',';

# 多维度统计PV总量
# 维度：小时
drop table dw_pvs_hour;
create table dw_pvs_hour(
month string,
day string,
hour string,
pvs bigint) 
partitioned by(datestr string);

# 维度：日
drop table dw_pvs_day;
create table dw_pvs_day(pvs bigint,month string,day string);

# 维度：月
drop table dw_pvs_month;
create table dw_pvs_month (pvs bigint,month string);

# 人均浏览页数
drop table dw_avgpv_user_d;
create table dw_avgpv_user_d(
day string,
avgpv string);

# 按referer维度统计pv总量
drop table dw_pvs_referer_h;
create table dw_pvs_referer_h(
referer_url string,
referer_host string,
month string,
day string,
hour string,
pv_referer_cnt bigint) 
partitioned by(datestr string);

# 按小时粒度统计各来访域名的产生的pv数并排序
drop table dw_ref_host_visit_cnts_h;
create table dw_ref_host_visit_cnts_h(ref_host string,
month string,
day string,
hour string,
ref_host_cnts bigint) 
partitioned by(datestr string);

# 统计pv总量最大的来源TOPN (取分组TOP)
drop table dw_pvs_refhost_topn_h;
create table dw_pvs_refhost_topn_h(
hour string,
toporder string,
ref_host string,
ref_host_cnts string
) partitioned by(datestr string);

# 统计每日最热门的页面top10
drop table dw_pvs_topn_d;
create table dw_pvs_topn_d(day string,url string,pvs string);


# 独立访客
# 按照时间维度比如小时来统计独立访客及其产生的pvCnts
drop table dw_user_dstc_ip_h;
create table dw_user_dstc_ip_h(
remote_addr string,
pvs bigint,
hour string);

# 每日新访客
drop table dw_user_dsct_history;
create table dw_user_dsct_history(
day string,
ip string
) 
partitioned by(datestr string);


# 回头/单次访客统计
drop table dw_user_returning;
create table dw_user_returning(
day string,
remote_addr string,
acc_cnt string)
partitioned by (datestr string);