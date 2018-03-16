/**  
* Title: ValidUrlPrefixParser.java
* Description:
* Copyright: Copyright (c) 2018
* Company: yz0515.cn
* @author yangzheng  
* @date 2018年3月9日  
* @version 1.0  
*/
package cn.yz0515.bigdata.hive.mr.parsers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import cn.yz0515.bigdata.exception.ExceptionCode;
import cn.yz0515.bigdata.exception.ServiceRuntimeException;

/**  
* Title: ValidUrlPrefixParser 
* Description:
* 	解析valid-url-prefix.conf文件
* 	获取正确的访问路径前缀
* @author yangzheng  
* @date 2018年3月9日  
*/
public class ValidUrlPrefixParser {
	private static final String CONFIG_NAME = "valid-url-prefix.conf";
	
	public static Collection<String> parse() {
		InputStream input = ValidUrlPrefixParser.class.getClassLoader().getResourceAsStream(CONFIG_NAME);
		BufferedReader reader = new BufferedReader(new InputStreamReader(input));
		
		Set<String> lines = new HashSet<>();
		
		String line;
		try {
			while ((line = reader.readLine()) != null) {
				if (line.startsWith("#")) {
					continue;
				}
				if (StringUtils.isEmpty(line)) {
					continue;
				}
				lines.add(line);
			}
		} catch (IOException e) {
			throw new ServiceRuntimeException(ExceptionCode.IOCode.IO_EXCEPTION, "配置文件valid-url-prefix.conf读取异常");
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				throw new ServiceRuntimeException(ExceptionCode.IOCode.IO_EXCEPTION, "流关闭异常");
			}
		}
		
		return lines;
	}
	
	//测试
	public static void main(String[] args) {
        System.out.println(ValidUrlPrefixParser.parse());
    }
}
