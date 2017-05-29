package com.ctvit.framework.common.util;

import java.io.IOException;

/**
 * Key Util: 1> according file name|size ..., generate a key; 2> the key should be unique.
 */
public class TokenUtil {

	/**
	 * 生成Token， A(hashcode>0)|B + |name的Hash值| +_+size的值
	 * 
	 * @param name
	 * @param size
	 * @return
	 * @throws Exception
	 */
	public static String generateToken(String name, String size) throws IOException {
		if (name == null || size == null)
			return "";
		int code = name.hashCode();
		try {
			String token = (code > 0 ? "A" : "B") + Math.abs(code) + "_" + size.trim();
			/** TODO: store your token, here just create a file */
			IoUtil.storeToken(token);

			return token;
		} catch (Exception e) {
			throw new IOException(e);
		}
	}

	/**
	 * 生成Token， A(hashcode>0)|B + |name的Hash值| +_+size_+sessionId的值
	 * 
	 * @author heyingcheng
	 * @date 2017年5月26日 下午3:34:40
	 * @param name
	 * @param size
	 * @param sessionId
	 * @return
	 * @throws IOException
	 * @return String
	 */
	public static String generateToken(String name, String size, String sessionId) throws IOException {
		if (name == null || size == null)
			return "";
		int code = name.hashCode();
		try {
			String token = (code > 0 ? "A" : "B") + Math.abs(code) + "_" + size.trim() + "_" + sessionId;
			/** TODO: store your token, here just create a file */
			IoUtil.storeToken(token);

			return token;
		} catch (Exception e) {
			throw new IOException(e);
		}
	}
}
