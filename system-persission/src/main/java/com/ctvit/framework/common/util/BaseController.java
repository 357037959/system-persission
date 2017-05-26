package com.ctvit.framework.common.util;

import com.jfinal.core.Controller;

public class BaseController extends Controller {

	private int pageSize = 20;

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * 获取当前登录用户编号
	 * 
	 * @return
	 */
	public String getCurrentUserCode() {
		// AttributePrincipal principal = (AttributePrincipal) getRequest().getUserPrincipal();
		// return principal.getName();
		return "admin";
	}

	/**
	 * 获取当前组织ID
	 * 
	 * @return
	 */
	public String getCurrentOrgId() {
		return "ctvit";
	}

	/**
	 * 取收录平台自己的systemId
	 * 
	 * @return
	 */
	public String getRecordSystemId() {
		return "Recorderself";
	}
}
