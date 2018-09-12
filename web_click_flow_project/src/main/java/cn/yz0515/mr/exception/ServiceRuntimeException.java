/**
 * Title: ServiceRuntimeException.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月12日
 * @version 1.0
 */
package cn.yz0515.mr.exception;

/**
 * 业务异常
 */
public class ServiceRuntimeException extends RuntimeException {
    private Integer code;
    private String description;

    public ServiceRuntimeException() {
        super();
    }

    public ServiceRuntimeException(Throwable cause) {
        super(cause);
    }

    public ServiceRuntimeException(Integer code, String description) {
        super(description);
        this.code = code;
        this.description = description;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

