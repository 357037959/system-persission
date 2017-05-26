package com.ctvit.upload.roune;

import com.ctvit.upload.controller.UploadController;
import com.jfinal.config.Routes;

/**
 * 系统路由
 * 
 * @author heyingcheng
 * @email heyingcheng@ctvit.com.cn
 * @date 2017年5月14日 上午9:43:55
 */
public class UploadRoutes extends Routes {
	public void config() {
		add("upload", UploadController.class);
	}
}
