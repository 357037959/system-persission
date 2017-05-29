package com.ctvit.upload.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.log4j.Logger;

import com.ctvit.framework.common.config.Configurations;
import com.ctvit.framework.common.util.ApplicationLogger;
import com.ctvit.framework.common.util.IoUtil;
import com.ctvit.framework.common.util.TokenUtil;
import com.ctvit.upload.exception.StreamException;
import com.ctvit.upload.model.Range;
import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.ext.interceptor.GET;
import com.jfinal.ext.interceptor.POST;

public class UploadController extends Controller {

	private Logger logger = ApplicationLogger.getLogger(UploadController.class);

	@Before(GET.class)
	public void tk() {
		String name = getFileName();
		String size = getPara(Configurations.FILE_SIZE_FIELD);
		String sessionId = UUID.randomUUID().toString().replace("-", "").toUpperCase();
		String token = null;
		Map<String, Object> json = new HashMap<String, Object>();
		try {
			token = TokenUtil.generateToken(name, size, sessionId);
			json.put(Configurations.TOKEN_FIELD, token);
			if (Configurations.isCrossed()) {
				json.put(Configurations.SERVER_FIELD, Configurations.getCrossServer());
			}
			json.put(Configurations.SUCCESS, true);
			json.put(Configurations.MESSAGE, "");
			/** TODO: save the token. */
		} catch (Exception e) {
			logger.error("[获取上传文件Token出现异常！" + e.getMessage() + "]", e);
		}
		renderJson(json);
	}

	public void up() {
		if ("GET".equalsIgnoreCase(getRequest().getMethod())) {
			uploadGet();
		} else if ("POST".equalsIgnoreCase(getRequest().getMethod())) {
			uploadPost();
		}
	}

	@Before(POST.class)
	public void fd() {
		/** flash @ windows bug */
		boolean isMultipart = ServletFileUpload.isMultipartContent(getRequest());
		if (!isMultipart) {
			renderText("ERROR: It's not Multipart form.");
			return;
		}
		Map<String, Object> json = new HashMap<String, Object>();
		long start = 0;
		boolean success = true;
		String message = "";

		ServletFileUpload upload = new ServletFileUpload();
		InputStream in = null;
		String token = null;
		try {
			String filename = null;
			FileItemIterator iter = upload.getItemIterator(getRequest());
			while (iter.hasNext()) {
				FileItemStream item = iter.next();
				String name = item.getFieldName();
				in = item.openStream();
				if (item.isFormField()) {
					String value = Streams.asString(in);
					if (Configurations.TOKEN_FIELD.equals(name)) {
						token = value;
						/** TODO: validate your token. */
					}
					System.out.println(name + ":" + value);
				} else {
					if (token == null || token.trim().length() < 1)
						token = getPara(Configurations.TOKEN_FIELD);
					/** TODO: validate your token. */

					// 这里不能保证token能有值
					filename = item.getName();
					if (token == null || token.trim().length() < 1)
						token = filename;

					start = IoUtil.streaming(in, token, filename);
				}
			}

			System.out.println("Form Saved : " + filename);
		} catch (Exception e) {
			success = false;
			message = "Error: " + e.getMessage();
			logger.error("[Form上传文件出现异常！" + e.getMessage() + "]", e);
		} finally {
			if (success) {
				json.put(Configurations.START_FIELD, start);
			}
			json.put(Configurations.SUCCESS, success);
			json.put(Configurations.MESSAGE, message);

			IoUtil.close(in);
			renderJson(json);
		}
	}

	private void uploadGet() {
		final String token = getPara(Configurations.TOKEN_FIELD);
		final String size = getPara(Configurations.FILE_SIZE_FIELD);
		final String fileName = getFileName();

		/** TODO: validate your token. */
		Map<String, Object> json = new HashMap<String, Object>();
		long start = 0;
		boolean success = true;
		String message = "";
		try {
			File f = IoUtil.getTokenedFile(token);
			start = f.length();
			/** file size is 0 bytes. */
			if (token.endsWith("_0") && "0".equals(size) && 0 == start)
				f.renameTo(IoUtil.getFile(fileName));
		} catch (Exception e) {
			success = false;
			message = "Error: " + e.getMessage();
			logger.error("[获得文件上传位置出现异常！" + e.getMessage() + "]", e);
		} finally {
			if (success) {
				json.put(Configurations.START_FIELD, start);
			}
			json.put(Configurations.SUCCESS, success);
			json.put(Configurations.MESSAGE, message);
			renderJson(json);
		}
	}

	private void uploadPost() {
		final String token = getPara(Configurations.TOKEN_FIELD);
		final String fileName = getFileName();

		OutputStream out = null;
		InputStream content = null;

		/** TODO: validate your token. */
		Map<String, Object> json = new HashMap<String, Object>();
		long start = 0;
		boolean success = true;
		String message = "";

		Range range = null;
		File f = null;
		try {
			range = IoUtil.parseRange(getRequest());
			f = IoUtil.getTokenedFile(token);
			if (f.length() != range.getFrom()) {
				/** drop this uploaded data */
				throw new StreamException(StreamException.ERROR_FILE_RANGE_START);
			}

			out = new FileOutputStream(f, true);
			content = getRequest().getInputStream();
			int read = 0;
			final byte[] bytes = new byte[Configurations.BUFFER_LENGTH];
			while ((read = content.read(bytes)) != -1)
				out.write(bytes, 0, read);

			start = f.length();
		} catch (StreamException e) {
			success = StreamException.ERROR_FILE_RANGE_START == e.getCode();
			message = "Code: " + e.getCode();
			logger.error("[文件上传出现异常！" + e.getMessage() + "]", e);
		} catch (FileNotFoundException e) {
			message = "Code: " + StreamException.ERROR_FILE_NOT_EXIST;
			success = false;
			logger.error("[文件上传出现异常！" + e.getMessage() + "]", e);
		} catch (Exception e) {
			success = false;
			message = "Error: " + e.getMessage();
			logger.error("[文件上传出现异常！" + e.getMessage() + "]", e);
		} finally {
			IoUtil.close(out);
			IoUtil.close(content);

			/** rename the file */
			if (range != null && f != null && range.getSize() == start) {
				try {
					// IoUtil.getFile(fileName).delete();
					Files.move(f.toPath(), f.toPath().resolveSibling(UUID.randomUUID() + "-" + fileName));
					System.out.println("TK: `" + token + "`, NE: `" + fileName + "`");
					if (Configurations.isDeleteFinished()) {
						IoUtil.getFile(fileName).delete();
					}
				} catch (IOException e) {
					success = false;
					message = "Rename file error: " + e.getMessage();
					logger.error("[文件重命名出现异常！" + e.getMessage() + "]", e);
				}
			}

			if (success) {
				json.put(Configurations.START_FIELD, start);
			}
			json.put(Configurations.SUCCESS, success);
			json.put(Configurations.MESSAGE, message);
			renderJson(json);
		}
	}

	private String getFileName() {
		String paraFileName = getPara(Configurations.FILE_NAME_FIELD, "");
		try {
			paraFileName = URLDecoder.decode(paraFileName, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return paraFileName;
	}

}
