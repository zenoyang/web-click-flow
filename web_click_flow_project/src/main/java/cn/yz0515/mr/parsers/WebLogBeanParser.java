/**
 * Title: WebLogBeanParser.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月9日
 * @version 1.0
 */
package cn.yz0515.mr.parsers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Locale;

import cn.yz0515.mr.bean.WebLogBean;
import cn.yz0515.mr.exception.ExceptionCode;
import cn.yz0515.mr.exception.ServiceRuntimeException;
import org.apache.commons.lang.StringUtils;


/**
 * Title: WebLogBeanParser
 * Description:
 * 	日志解析器
 * @author yangzheng
 * @date 2018年3月9日
 */
public class WebLogBeanParser {
    public static SimpleDateFormat df1 = new SimpleDateFormat("dd/MMM/yyyy:HH:mm:ss", Locale.US);
    public static SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);

    /**
     * 列分隔符
     */
    public static final String SPLIT_DELIMITER = "\001";

    public static WebLogBean parse(String line) {
        if (StringUtils.isEmpty(line)) {
            return null;
        }

        WebLogBean bean = new WebLogBean();

        String[] fields = line.split(" ");

        if (fields.length < 12) {	//记录的数据必须要包含所有的数据，否则认为是脏数据
            bean.setValid(false);
            return bean;
        }

        bean.setRemote_addr(fields[0]);
        bean.setRemote_user(fields[1]);
        String time_local = getFormatDate(fields[3].substring(1));
        if (time_local == null) {
            bean.setValid(false);	//时间转换错误，定为脏数据
            return bean;
        }
        bean.setTime_local(time_local);
        bean.setRequest(fields[6]);
        bean.setStatus(fields[8]);
        bean.setBody_bytes_sent(fields[9]);
        bean.setHttp_referer(fields[10]);

        // 获取客户端浏览器系统信息
        StringBuilder sb = new StringBuilder();
        for(int i= 11; i < fields.length; i++) {
            sb.append(fields[i]);
        }
        bean.setHttp_user_agent(sb.toString());

        if (Integer.parseInt(bean.getStatus()) >= 400) {	// 大于400，HTTP错误，定为脏数据
            bean.setValid(false);
        }

        return bean;
    }

    public static String getFormatDate(String time_local) {
        try {
            return df2.format(df1.parse(time_local));
        } catch (ParseException e) {
            return null;
        }
    }

    public static void filtStaticResource(WebLogBean bean, Collection<String> pages) {
        if (!pages.contains(bean.getRequest())) {
            bean.setValid(false);
        }
    }

    public static Date toDate(String timeStr) {
        if (StringUtils.isEmpty(timeStr)) {
            return null;
        }

        try {
            return df2.parse(timeStr);
        } catch (ParseException e) {
            throw new ServiceRuntimeException(ExceptionCode.COMMON.DATE_FORMAT_EXCEPTION, "日期格式化错误");
        }
    }

    public static long timeDiff(String time1, String time2) {
        Date d1 = toDate(time1);
        Date d2 = toDate(time2);
        long millSeconds = d1.getTime() - d2.getTime();
        return millSeconds;
    }
}