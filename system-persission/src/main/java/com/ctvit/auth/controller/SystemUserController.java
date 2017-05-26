package com.ctvit.auth.controller;

import java.util.HashMap;
import java.util.Map;

import com.ctvit.auth.model.SystemUser;
import com.ctvit.framework.common.util.BaseController;
import com.jfinal.aop.Duang;

/**
 * 系统用户Controller
 * 
 * @author heyingcheng
 * @email heyingcheng@ctvit.com.cn
 * @date 2017年5月14日 上午8:43:48
 */
public class SystemUserController extends BaseController {

	SystemUserService systemUserService = Duang.duang(SystemUserService.class);

	public void findUser() {
		String name = getPara("name");
		String nameCh = getPara("name_ch");
		String email = getPara("email");
		Integer thepage = getParaToInt("thepage", 1);
		renderJson(systemUserService.findUser(name, nameCh, email, thepage));
	}

	public void saveUser() {
		SystemUser systemUser = new SystemUser();
		systemUser.setName(getPara("name"));
		systemUser.setNameCh(getPara("name_ch"));
		systemUser.setPassword(getPara("password"));
		systemUser.setEmail(getPara("email"));
		systemUser.setGender(Boolean.parseBoolean(getPara("gender")));
		systemUser.setState(Boolean.parseBoolean(getPara("state")));
		boolean flag = systemUserService.saveUser(systemUser);
		Map<String, Object> map = new HashMap<String, Object>();
		if (flag) {
			map.put("status", "OK");
		}
		renderJson(map);
	}

	public void updateUser() {
		SystemUser systemUser = new SystemUser();
		systemUser.setPk(Integer.parseInt(getPara("pk")));
		systemUser.setName(getPara("name"));
		systemUser.setNameCh(getPara("name_ch"));
		systemUser.setPassword(getPara("password"));
		systemUser.setEmail(getPara("email"));
		systemUser.setGender(Boolean.parseBoolean(getPara("gender")));
		systemUser.setState(Boolean.parseBoolean(getPara("state")));
		boolean flag = systemUserService.updateUser(systemUser);
		Map<String, Object> map = new HashMap<String, Object>();
		if (flag) {
			map.put("status", "OK");
		}
		renderJson(map);
	}

	public void getUser() {
		SystemUser systemUser = new SystemUser();
		systemUser.setPk(Integer.parseInt(getPara("pk")));
		renderJson(systemUserService.getUser(systemUser));
	}

	public void deleteUser() {
		SystemUser systemUser = new SystemUser();
		systemUser.setPk(Integer.parseInt(getPara("pk")));
		renderJson(systemUserService.deleteUser(systemUser));
	}
}
