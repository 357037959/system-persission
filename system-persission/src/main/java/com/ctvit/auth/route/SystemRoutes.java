package com.ctvit.auth.route;

import com.ctvit.auth.controller.SystemUserController;
import com.jfinal.config.Routes;

/**
 * 系统路由
 * 
 * @author heyingcheng
 * @email heyingcheng@ctvit.com.cn
 * @date 2017年5月14日 上午9:43:55
 */
public class SystemRoutes extends Routes {
	public void config() {
		add("system/user", SystemUserController.class);
	}
}
