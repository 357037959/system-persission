package com.ctvit.auth.model.base;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.IBean;

/**
 * Generated by JFinal, do not modify this file.
 */
@SuppressWarnings("serial")
public abstract class BaseSystemRole<M extends BaseSystemRole<M>> extends Model<M> implements IBean {

	public void setPk(java.lang.Integer pk) {
		set("pk", pk);
	}

	public java.lang.Integer getPk() {
		return get("pk");
	}

	public void setName(java.lang.String name) {
		set("name", name);
	}

	public java.lang.String getName() {
		return get("name");
	}

	public void setState(java.lang.Boolean state) {
		set("state", state);
	}

	public java.lang.Boolean getState() {
		return get("state");
	}

}
