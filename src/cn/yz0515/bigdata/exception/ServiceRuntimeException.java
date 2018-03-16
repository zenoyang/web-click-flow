package cn.yz0515.bigdata.exception;

/**
 * “µŒÒ“Ï≥£
 * Created by zhenglian on 2017/11/26.
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

