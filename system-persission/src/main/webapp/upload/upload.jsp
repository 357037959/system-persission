<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<link rel="stylesheet" href="../../css/app.css">
<link rel="stylesheet" href="/element/lib/theme-default/index.css">
<script src="/element/dist/vue.min.js"></script>
<script src="../../js/bootstrap/js/jquery.mini.js"></script>
<script src="../../js/app.js"></script>
<script src="/element/lib/index.js"></script>
<link href="/css/stream-v1.css" rel="stylesheet" type="text/css">
<title>上载</title>
</head>
<body>
<div id="app" class="app_context" v-loading.fullscreen.lock="loading">
	<div id="i_select_files" style="display: none;"></div>
	<div id="i_stream_files_queue" style="display: block;"></div>
	<div class="app_title">
		<div class="app_title_show">上载</div>
		<div style="float: right; margin-right: 20px;">
			<el-button type="primary" @click="onAddUser()" icon="plus" size="small">已上载记录</el-button>
		</div>
	</div>
	<div class="app_line"></div>
	<div class="app_bar">
		<el-button icon="upload" type="primary" size="small" @click="upload('video')">上载视频</el-button>
		<el-button icon="upload" type="primary" size="small" @click="selectAudio()">上载音频</el-button>
		<el-button icon="upload" type="primary" size="small" @click="upload('document')">上载文稿</el-button>
		<el-button icon="upload" type="primary" size="small" @click="selectSubtitle()">上载字幕</el-button>
		<el-button icon="upload" type="primary" size="small" @click="upload('image')">上载图片</el-button>
		<el-button icon="upload" type="primary" size="small" @click="upload('file')">其他文件</el-button>
	</div>
	<el-table :data="tableData" style="width:100%" border highlight-current-row default-expand-all>
		<el-table-column type="expand" >
		<template scope="props">
			<li :id="props.row.fileBarId" class="stream-cell-file" style="border-color: #fff;">
				<div class="stream-process"> 
					<span class="stream-process-bar"><span class="bar-width" :style="props.row.barWidth"></span></span> 
			    	<span class="stream-percent">{{props.row.percent}}</span>
				</div>
				<div class="stream-cell-infos"> 
			    	<span class="stream-cell-info">速度：<em class="stream-speed">{{props.row.formatSpeed}}</em></span> 
			    	<span class="stream-cell-info">已上传：<em class="stream-uploaded">{{props.row.formatLoaded}}/{{props.row.formatSize}}</em></span> 
			    	<span class="stream-cell-info">剩余时间：<em class="stream-remain-time">{{props.row.formatTimeLeft}}</em></span>
				</div>
			</li>
		</template>
		</el-table-column>
		<el-table-column prop="fileId" label="索引"></el-table-column>
		<el-table-column prop="fileType" label="类型" :formatter="fileTypeFormatter"></el-table-column>
		<el-table-column prop="fileName" label="文件名"></el-table-column>
		<el-table-column label="操作" :context="_self" inline-template>
		<template>
			<el-button size="small" @click="deleteFile($index, row)" type="danger"> 删除 </el-button>
		</template>
		</el-table-column>
	</el-table>
	<el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm" style="width: 500px; margin-top: 20px;">
		<el-form-item label="标识" prop="pk" v-show="false"><el-input v-model="ruleForm.pk"></el-input></el-form-item>
		<el-form-item label="标题" prop="title"><el-input v-model="ruleForm.title"></el-input></el-form-item>
		<el-form-item label="版本" prop="version"><el-input v-model="ruleForm.version"></el-input></el-form-item>
		<el-form-item label="资源类型" prop="resource">
			<el-radio-group v-model="ruleForm.resource"><el-radio label="true">节目</el-radio><el-radio label="false">素材</el-radio></el-radio-group>
		</el-form-item>
		<el-form-item label="节目代码" prop="code"><el-input v-model="ruleForm.code"></el-input></el-form-item>
		<el-form-item label="节目分类" prop="classification">
			<el-select v-model="ruleForm.classification" placeholder="请选择节目分类">
				<el-option :label="item.classificationName" :value="item.classification" v-for="item in classificationList"></el-option>
			</el-select>
		</el-form-item>
		<el-form-item label="所属栏目" prop="column">
			<el-select v-model="ruleForm.column" placeholder="请选择所属栏目">
				<el-option :label="item.columnName" :value="item.column" v-for="item in columnList"></el-option>
			</el-select>
		</el-form-item>
		<el-form-item label="码流" prop="stream">
			<el-select v-model="ruleForm.stream" placeholder="请选择码流">
				<el-option :label="item.streamName" :value="item.stream" v-for="item in streamList"></el-option>
			</el-select>
		</el-form-item>
		<el-form-item label="适配终端" prop="terminal">
			<el-select v-model="ruleForm.terminal" placeholder="请选择适配终端">
				<el-option :label="item.terminalName" :value="item.terminal" v-for="item in terminalList"></el-option>
			</el-select>
		</el-form-item>
		<el-form-item label="简介" prop="introduction"><el-input v-model="ruleForm.introduction"></el-input></el-form-item>
		<el-form-item><el-button type="primary" @click="doUpload">保存</el-button></el-form-item>
	</el-form>
	
	<el-dialog :title="audioDialog.title" v-model="audioDialog.display" style="width:1250px;">
		<el-form :model="audioDialog" :rules="rules" ref="audioForm" label-width="100px" style="width:500px;">
			<el-form-item label="音频文件语种" prop="language">
				<el-select v-model="audioDialog.language">
					<el-option :label="item.languageName" :value="item.language" v-for="item in languageList"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item><el-button type="primary" @click="uploadByLanguage('audio')">选择音频</el-button></el-form-item>
		</el-form>
	</el-dialog>
		
	<el-dialog :title="subtitleDialog.title" v-model="subtitleDialog.display" style="width:1250px;">
		<el-form :model="subtitleDialog" :rules="rules" ref="subtitleForm" label-width="100px" style="width:500px;">
			<el-form-item label="字母语种" prop="language">
				<el-select v-model="subtitleDialog.language" placeholder="请选择字母语种">
					<el-option :label="item.languageName" :value="item.language" v-for="item in languageList"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item><el-button type="primary" @click="uploadByLanguage('subtitle')">选择字幕</el-button></el-form-item>
		</el-form>
	</el-dialog>
</div>
</body>
</html>
<script type="text/javascript" src="/js/stream-v1.js"></script>
<script>
var FileType = {
	"video" : "视频",
	"audio" : "音频",
	"document" : "文档",
	"subtitle" : "字幕",
	"image" : "图片",
	"file" : "文件"
}

var LanguageType = {
	"chinese" : "中文",
	"english" : "英文",
	"french" : "法文"
}

//表单对象
var ruleForm = {
	pk : '',
	title : '',
	version : '',
	resource : "true",
	code : '',
	classification : '',
	column : '',
	stream : '',
	terminal : '',
	introduction : ''
};

 // 表单验证
var rules = {
	title : [ {
		required : true,
		message : '请输入标题',
		trigger : 'blur'
	}, {
		max : 60,
		message : '用户名不能超过60个字符',
		trigger : 'blur'
	} ],
	language : [ {
		required : true,
		message : '请选择语种',
		trigger : 'blur'
	} ]
};

var DataFileMap = {}
 
function DataFile(fileId, fileType, fileName, language) {
	this.fileId = fileId;
	this.fileType = fileType;
	this.fileName = fileName;
	this.percent;
	this.formatSpeed;
	this.formatLoaded;
	this.formatTimeLeft;
	this.formatSize;
	this.totalPercent;
	this.barStyle;
	this.fileBarId = "stream-process-bar_" + fileId;
	if (language) {
		this.language = language;
	} else {
		this.language = '';
	}
}
 
var vm = new Vue({
	data : {
		tableData : [],
		ruleForm : ruleForm,
		rules : rules,
		loading : true,
		classificationList : [],
		columnList : [],
		streamList : [ {
			"stream" : "super",
			"streamName" : "超清"
		}, {
			"stream" : "hight",
			"streamName" : "高清"
		}, {
			"stream" : "normal",
			"streamName" : "标清"
		} ],
		terminalList : [ {
			"terminal" : "tv",
			"terminalName" : "TV端"
		}, {
			"terminal" : "pc",
			"terminalName" : "PC端"
		}, {
			"terminal" : "mobile",
			"terminalName" : "移动端"
		}],
		audioDialog : {
			title : "音频文件语种",
			display : false,
			language : ''
		},
		subtitleDialog : {
			title : "字母文件语种",
			display : false,
			language : ''
		},
		languageList : [ {
			"language" : "chinese",
			"languageName" : "中文"
		}, {
			"language" : "english",
			"languageName" : "英文"
		}, {
			"language" : "french",
			"languageName" : "法文"
		} ]
	},
	el : '#app',
	methods : {
		doUpload : function(ev) {
			var _self = this;
			_self.$refs.ruleForm.validate(function(valid) {
				if (valid) {
					_t.upload();
				} else {
					return false;
				}
			});
		}, deleteFile : function(index, row) {
			var _self = this;
			_t.cancelUploadHandler(null, {"nodeId" : row.fileId});
			_self.tableData.splice(index, 1);
		}, upload : function(type) {
			_t.uploadType = type;
			$('#i_select_files').click();
		}, uploadByLanguage : function(type) {
			var _self = this;
			_t.uploadType = type;
			var form;
			if ("audio" === type) {
				form = _self.$refs.audioForm;
			} else if ("subtitle" === type) {
				form = _self.$refs.subtitleForm;
			}
			if (form) {
				form.validate(function(valid) {
					if (valid) {
						$('#i_select_files').click();
					} else {
						return false;
					}
				});
			}
		}, selectAudio : function() {
			var _self = this;
			_self.audioDialog.display = true;
		}, selectSubtitle : function() {
			var _self = this;
			_self.subtitleDialog.display = true;
		}, fileTypeFormatter : function(row, column) {
			if (row.language) {
				return row.fileType + " " + LanguageType[row.language];
			} else {
				return row.fileType;
			}
		}
	}, created : function() {
		var _self = this;
		_self.loading = false;
	}
});

var config = {
	customered : true,
	browseFileId : "i_select_files",
	browseFileBtn : "<div></div>",
	filesQueueId : "i_stream_files_queue",
	filesQueueHeight : 200,
	messagerId : "i_stream_message_container",
	multipleFiles: true,
	autoUploading: true,
	onRepeatedFile: true,
// 	maxSize: 104857600,
	retryCount : 5,
// 	postVarsPerFile : {
// 		param1: "val1",
// 		param2: "val2"
// 	},
	tokenURL : "/upload/tk",
	frmUploadURL : "/upload/fd;",
	uploadURL : "/upload/up",
	simLimit: 200,
// 	extFilters: [".txt", ".rpm", ".rmvb", ".gz", ".rar", ".zip", ".avi", ".mkv", ".mp3", ".ts"],
	onSelect: function(list) {
// 		var language = '';
// 		if ('audio' === _t.uploadType) {
// 			vm._data.audioDialog.display = false;
// 			language = vm._data.audioDialog.language;
// 		} else if ('subtitle' === _t.uploadType) {
// 			vm._data.subtitleDialog.display = false;
// 			language = vm._data.subtitleDialog.language;
// 		}
// 		var length = list.length;
// 		for (var i = 0; i < length; i++) {
// 			var streamFile = list[i];
// 			var dataFile = new DataFile(streamFile.id, FileType[_t.uploadType], streamFile.name, language);
// 			DataFileMap[streamFile.id] = dataFile;
// 			vm._data.tableData.push(dataFile);
// 		}
// 		vm._data.audioDialog.language = '';
// 		vm._data.subtitleDialog.language = '';
	},
	onMaxSizeExceed: function(file) {
		vm.$message({
			message : "文件[name="+file.name+", size="+file.formatSize+"]超过文件大小限制‵"+file.formatLimitSize+"‵，将不会被上传！",
			type : "error",
			showClose : true
		});
	},
	onFileCountExceed: function(selected, limit) {
//	 	alert('onFileCountExceed');
	},
	onExtNameMismatch: function(name, filters) {
//	 	alert('onExtNameMismatch');
	},
	onCancel : function(file) {
//	 	alert('Canceled: ' + file.name);
		alert("onCancel");
	},
	onComplete: function(file) {
		var barId = "#stream-process-bar_" + file.id;
		$(barId + " .bar-width").css("width", "100%");
		$(barId + " .stream-percent").html("100%");
		$(barId + " .stream-uploaded").html(file.formatLoaded + "/" + file.formatSize);
		$(barId + " .stream-remain-time").html("00:00:00");
		
		var dataFile = DataFileMap[file.id];
		dataFile['barWidth'] = "width: 100%;";
		dataFile['percent'] = "100%";
		dataFile['formatLoaded'] = file.formatLoaded;
		dataFile['formatSize'] = file.formatSize;
		dataFile['formatTimeLeft'] = "00:00:00";
		dataFile['totalPercent'] = file.totalPercent;
	},
	onQueueComplete: function() {
//	 	alert('onQueueComplete');
	},
	onUploadError: function(status, msg) {
//	 	alert('onUploadError');
	},
	onAddTask: function(file) {
		var language = '';
		if ('audio' === _t.uploadType) {
			vm._data.audioDialog.display = false;
			language = vm._data.audioDialog.language;
		} else if ('subtitle' === _t.uploadType) {
			vm._data.subtitleDialog.display = false;
			language = vm._data.subtitleDialog.language;
		}
		
		var dataFile = new DataFile(file.id, FileType[_t.uploadType], file.name, language);
		DataFileMap[file.id] = dataFile;
		vm._data.tableData.push(dataFile);
		
		vm._data.audioDialog.language = '';
		vm._data.subtitleDialog.language = '';
	},
	onUploadProgress: function(file) {
		var barId = "#stream-process-bar_" + file.id;
		$(barId + " .bar-width").css("width", file.percent + "%");
		$(barId + " .stream-percent").html(file.percent + "%");
		$(barId + " .stream-speed").html(file.formatSpeed);
		$(barId + " .stream-uploaded").html(file.formatLoaded + "/" + file.formatSize);
		$(barId + " .stream-remain-time").html(file.formatTimeLeft);
		
		var dataFile = DataFileMap[file.id];
		dataFile['barWidth'] = "width: " + file.percent + "%;";
		dataFile['percent'] = file.percent;
		dataFile['formatSpeed'] = file.formatSpeed;
		dataFile['formatLoaded'] = file.formatLoaded;
		dataFile['formatSize'] = file.formatSize;
		dataFile['formatTimeLeft'] = file.formatTimeLeft;
		dataFile['totalPercent'] = file.totalPercent;
	},
	onStop: function() {
	 	alert('onStop');
	},
	onCancelAll: function(numbers) {
//	 	alert('onCancelAll');
	}, onRepeatedFile: function(f) {}
};
var _t = new Stream(config);
</script>
