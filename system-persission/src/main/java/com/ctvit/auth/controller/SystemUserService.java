package com.ctvit.auth.controller;

import java.util.HashMap;

import com.ctvit.auth.model.SystemUser;
import com.ctvit.framework.common.util.BaseService;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

/**
 * 系统用户Service
 * 
 * @author heyingcheng
 * @email heyingcheng@ctvit.com.cn
 * @date 2017年5月14日 上午8:45:29
 */
public class SystemUserService extends BaseService {

	public HashMap<String, Object> findUser(String name, String nameCh, String email, Integer thepage) {
		String select = "SELECT pk, name, name_ch, gender, email, state ";
		String where = "FROM system_user WHERE 1 = 1 ";
		if (name != null && !"".equals(name)) {
			where += " AND name like '%" + name + "%' ";
		}
		if (nameCh != null && !"".equals(nameCh)) {
			where += " AND name_ch like '%" + nameCh + "%' ";
		}
		if (nameCh != null && !"".equals(nameCh)) {
			where += " AND name_ch like '%" + nameCh + "%' ";
		}
		if (email != null && !"".equals(email)) {
			where += " AND email like '%" + email + "%' ";
		}
		where += "ORDER BY name ";

		Page<Record> list = Db.paginate(thepage, getPageSize(), select, where);

		HashMap<String, Object> page = new HashMap<String, Object>();
		page.put("total", list.getTotalRow());
		page.put("pageSize", getPageSize());
		page.put("thepage", thepage);

		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("list", list.getList());
		result.put("page", page);
		return result;
	}

	public boolean saveUser(SystemUser systemUser) {
		return systemUser.save();
	}

	public boolean updateUser(SystemUser systemUser) {
		return systemUser.update();
	}

	public SystemUser getUser(SystemUser systemUser) {
		return systemUser.findById(systemUser.getPk());
	}

	public boolean deleteUser(SystemUser systemUser) {
		return systemUser.deleteById(systemUser.getPk());
	}

}
