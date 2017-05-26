package com.ctvit.framework.common.util;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class ApplicationLogger {
	// Logger实例
	public Logger logger = null;
	// 将Log类封装为单例模式
	static {
		 PropertyConfigurator.configureAndWatch("./log4j.properties", 6000);
	}

	// 构造函数，用于初始化Logger配置需要的属性
	private Logger initLogger(Class<?> entityClass) {

		// 获得当前目录路径
		String filePath = this.getClass().getResource("/").getPath();
		// 找到log4j.properties配置文件所在的目录(已经创建好)
		filePath = filePath.substring(1).replace("bin", "src");
		PropertyConfigurator.configureAndWatch(filePath + "log4j.properties", 60000);
		// logger所需的配置文件路径
		PropertyConfigurator.configure(filePath + "log4j.properties");
		// 获得日志类logger的实例
		logger = Logger.getLogger(entityClass);
		return logger;
	}

	public static Logger getLogger(Class<?> entityClass) {
		return new ApplicationLogger().initLogger(entityClass);
	}

}
