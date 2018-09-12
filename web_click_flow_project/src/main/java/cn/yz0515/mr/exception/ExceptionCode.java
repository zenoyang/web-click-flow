/**
 * Title: ExceptionCode.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月12日
 * @version 1.0
 */
package cn.yz0515.mr.exception;

/**
 * 定义的业务异常响应码
 */
public class ExceptionCode {

    /**
     * IO通用异常
     */
    public static class IOCode {
        public static final Integer IO_EXCEPTION = 1000;
    }

    /**
     * mr错误码
     */
    public static class COMMON {
        /**
         * 对象复制报错
         */
        public static final Integer BEAN_ATTR_COPY_EXCEPTION = 2000;

        /**
         * 日期格式转化错误
         */
        public static final Integer DATE_FORMAT_EXCEPTION = 2001;
    }
}

