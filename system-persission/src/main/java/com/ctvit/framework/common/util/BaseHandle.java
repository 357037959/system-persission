package com.ctvit.framework.common.util;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jfinal.handler.Handler;

/**
 * 允许跨域访问
 * 
 * @author heyingcheng
 * @email heyingcheng@ctvit.com.cn
 * @date 2017年5月14日 上午8:46:06
 */
public class BaseHandle extends Handler {

	private static Logger LOGGER = LoggerFactory.getLogger(BaseHandle.class);

	@Override
	public void handle(String target, HttpServletRequest request, HttpServletResponse response, boolean[] isHandled) {
		response.addHeader("Access-Control-Allow-Origin", "*");
		response.addHeader("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
		response.addHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");

		if (target.endsWith(".do")) {
			target = target.substring(0, target.length() - 3);
			next.handle(target, request, response, isHandled);
		} else if (target.endsWith(".shtml")) {
			LOGGER.info("[接口调用:" + target + "地址,开始进行签名验证:]");
			target = target.substring(0, target.length() - 6);

			Map<String, String> map = BaseHandle.dealInterfaceRquest(request);
			if ("OK".equals(map.get("flag"))) {
				LOGGER.info("[接口调用:" + target + "地址 ---签名验证成功-调用成功 ]");
				next.handle(target, request, response, isHandled);
			} else {
				LOGGER.info("[接口调用:" + target + "地址 ---调用失败-签名验证失败]");
				target = "/common/fignatureFail";
				request.setAttribute("message", map.get("message"));
				next.handle(target, request, response, isHandled);
			}
		} else {
			next.handle(target, request, response, isHandled);
		}

	}

	/**
	 * @category 处理外部请求接口签名认证
	 * @param request
	 * @return 状态信息
	 */
	public static Map<String, String> dealInterfaceRquest(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("flag", "OK");
		return map;
	}

}