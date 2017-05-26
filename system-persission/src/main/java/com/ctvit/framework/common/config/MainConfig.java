package com.ctvit.framework.common.config;

import com.ctvit.auth.model._MappingKit;
import com.ctvit.auth.route.SystemRoutes;
import com.ctvit.framework.common.util.BaseHandle;
import com.ctvit.upload.roune.UploadRoutes;
import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.kit.PathKit;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.activerecord.tx.TxByMethodRegex;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.plugin.ehcache.EhCachePlugin;
import com.jfinal.render.ViewType;

public class MainConfig extends JFinalConfig {
	/**
	 * 配置JFinal常量
	 */
	@Override
	public void configConstant(Constants me) {
		// 读取数据库配置文件
		PropKit.use("config.properties");
		// 设置当前是否为开发模式
		me.setDevMode(PropKit.getBoolean("devMode"));
		me.setDevMode(true);
		// 设置默认上传文件保存路径 getFile等使用
		me.setBaseUploadPath("upload/temp/");
		// 设置上传最大限制尺寸
		// me.setMaxPostSize(1024*1024*10);
		// 设置默认下载文件路径 renderFile使用
		// me.setBaseDownloadPath("");
		// 设置默认视图类型
		me.setViewType(ViewType.JSP);
		// 设置404渲染视图
		// me.setError404View("404.html");
	}

	/*
	 * 创建c3p0
	 */
	public static C3p0Plugin createC3p0Plugin() {
		C3p0Plugin c3p0Plugin = new C3p0Plugin(PropKit.get("jdbcUrl"), PropKit.get("user"), PropKit.get("password"));
		return c3p0Plugin;
	}

	/**
	 * 配置JFinal路由映射
	 */
	@Override
	public void configRoute(Routes me) {
		me.add(new SystemRoutes());
		me.add(new UploadRoutes());
	}

	/**
	 * 配置JFinal插件 数据库连接池 ORM 缓存等插件 自定义插件
	 */
	@Override
	public void configPlugin(Plugins me) {
		// 配置数据库连接池插件
		C3p0Plugin c3p0Plugin = new C3p0Plugin(PropKit.get("jdbcUrl"), PropKit.get("user"), PropKit.get("password"));
		// orm映射 配置ActiveRecord插件
		ActiveRecordPlugin arp = new ActiveRecordPlugin(c3p0Plugin);
		arp.setShowSql(PropKit.getBoolean("devMode"));
		arp.setDialect(new MysqlDialect());
		/******** 在此添加数据库 表-Model 映射 *********/
		_MappingKit.mapping(arp);
		// 添加到插件列表中
		me.add(c3p0Plugin);
		me.add(arp);
		// 配置缓存插件 两种方式都可以
		String path = PathKit.getRootClassPath() + "/" + "ehcache.xml";
		me.add(new EhCachePlugin(path));
	}

	/**
	 * 配置全局处理器
	 */
	@Override
	public void configHandler(Handlers me) {
		// 跨域访问
		BaseHandle baseHandle = new BaseHandle();
		me.add(baseHandle);
	}

	@Override
	public void afterJFinalStart() {
	}

	@Override
	public void beforeJFinalStop() {
		super.beforeJFinalStop();
	}

	/**
	 * 配置全局拦截器
	 */
	@Override
	public void configInterceptor(Interceptors me) {
		// 事务拦截器 方法中含save update delete将开启事务
		me.add(new TxByMethodRegex("(.*save.*|.*update.*|.*delete.*)"));
	}

}
