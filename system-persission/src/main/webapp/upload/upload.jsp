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
<title>上传</title>
</head>
<body>
<div id="app" class="app_context" v-loading.fullscreen.lock="loading">
	<div id="i_select_files" style="display: none;"></div>
	<div id="i_stream_files_queue" style="display: block;"></div>
	<div class="app_title">
		<div class="app_title_show">上传</div>
		<div style="float: right;">
<!-- 			<el-button type="primary" @click="onAddUser()" icon="plus" size="small">已上载记录</el-button> -->
		</div>
	</div>
	<div class="app_line"></div>
	<div class="app_bar">
		<div style="float: left;">
			<el-button type="primary" size="small" @click="upload('audioandvedio')">上传 音视频</el-button>
			<el-button type="primary" size="small" @click="upload('video')">视轨</el-button>
			<el-button type="primary" size="small" @click="selectAudio()">音轨</el-button>
			<el-button type="primary" size="small" @click="upload('script')">文稿</el-button>
			<el-button type="primary" size="small" @click="selectSubtitle()">字幕</el-button>
			<el-button type="primary" size="small" @click="upload('image')">图片</el-button>
			<el-button type="primary" size="small" @click="upload('other')">其他文件</el-button>
		</div>
		<div style="float: right;">
			<el-button type="primary" size="small" @click="selectAudio()">完成</el-button>
			<el-button type="primary" size="small" @click="upload('video')">保存</el-button>
		</div>
	</div>
	<el-row>
		<el-col :span="12">
			<el-table :data="tableData" style="width:100%" border highlight-current-row default-expand-all>
				<el-table-column type="expand" >
				<template scope="props">
					<li :id="props.row.fileBarId" class="stream-cell-file" style="border-color: #fff;">
						<div class="stream-process"> 
							<span class="stream-process-bar"><span class="bar-width" :style="props.row.barWidth"></span></span> 
					    	<span class="stream-percent">{{props.row.percent}}%</span>
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
		</el-col>
		<el-col :span="12">
			<el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="100px">
				<el-form-item label="标识" prop="pkGUID" v-show="false"><el-input v-model="ruleForm.pkGUID"></el-input></el-form-item>
				<el-row>
					<el-col :span="12"><el-form-item label="标题" prop="title"><el-input v-model="ruleForm.title"></el-input></el-form-item></el-col>
					<el-col :span="12"><el-form-item label="版本" prop="version"><el-input v-model="ruleForm.version"></el-input></el-form-item></el-col>
				</el-row>
				<el-row>
					<el-col :span="12">
						<el-form-item label="资源类型" prop="proMat">
							<el-radio-group v-model="ruleForm.proMat"><el-radio label="program">节目</el-radio><el-radio label="material">素材</el-radio></el-radio-group>
						</el-form-item>
					</el-col>
					<el-col :span="12"><el-form-item label="节目代码" prop="programCode"><el-input v-model="ruleForm.programCode"></el-input></el-form-item></el-col>
				</el-row>
				<el-row>
					<el-col :span="12">
						<el-form-item label="节目分类" prop="programType">
							<el-select v-model="ruleForm.programType" placeholder="请选择节目分类">
								<el-option :label="item.programname" :value="item.programCode" v-for="item in programTypeList"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="所属栏目" prop="mediaColumnCode">
							<el-select v-model="ruleForm.mediaColumnCode" placeholder="请选择所属栏目">
								<el-option :label="item.columnname" :value="item.columnid" v-for="item in columnList"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				<el-row>
					<el-col :span="12">
						<el-form-item label="码流" prop="bitType">
							<el-select v-model="ruleForm.bitType" placeholder="请选择码流">
								<el-option :label="item.bitName" :value="item.bitCode" v-for="item in bitList"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="适配终端" prop="terminal">
							<el-select v-model="ruleForm.terminal" placeholder="请选择适配终端">
								<el-option :label="item.terminalName" :value="item.terminalType" v-for="item in terminalList"></el-option>
							</el-select>
						</el-form-item>
					</el-col>
				</el-row>
				<el-form-item label="简介" prop="content"><el-input v-model="ruleForm.content" type="textarea" :autosize="{minRows: 5}"></el-input></el-form-item>
			</el-form>
		</el-col>
	</el-row>
	
	<el-dialog :title="audioDialog.title" v-model="audioDialog.display" style="width:1250px;">
		<el-form :model="audioDialog" :rules="rules" ref="audioForm" label-width="100px" style="width:500px;">
			<el-form-item label="音频文件声道" prop="language">
				<el-select v-model="audioDialog.channel">
					<el-option :label="item.channelName" :value="item.channel" v-for="item in channelList"></el-option>
				</el-select>
			</el-form-item>
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
	"audioandvedio" : "音视频", "video" : "视轨", "audio" : "音轨", "script" : "文稿", "subtitle" : "字幕", "image" : "图片", "other" : "文件"
}

var LanguageType = {
	"chinese" : "中文", "english" : "英文", "french" : "法文"
}

//表单对象
var ruleForm = {
	"pkGUID" : "",
	"title" : "",
	"proMat" : "program",
	"programCode" : "",
	"programType" : "",
	"mediaColumnCode" : "",
	"mediaColumnName" : "",
	"bitType" : "",
	"terminalType" : "",
	"content" : ""
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
		programTypeList : [ {
			"programCode" : "001", "programname" : "新闻类"
		}, {
			"programCode" : "002", "programname" : "电视剧"
		}, {
			"programCode" : "003", "programname" : "综艺"
		}, {
			"programCode" : "004", "programname" : "体育"
		} ],
		columnList : [ {
			"columnid" : "BJ001_03", "columnname" : "城市人家"
		}, {
			"columnid" : "BJ001_04", "columnname" : "服装秀"
		}, {
			"columnid" : "BJ001_05", "columnname" : "道德与法制"
		} ],
		channelList : [ {
			"channel" : "00", "channelName" : "混音"
		}, {
			"channel" : "01", "channelName" : "声道01"
		}, {
			"channel" : "02", "channelName" : "声道02"
		}, {
			"channel" : "03", "channelName" : "声道03"
		}, {
			"channel" : "04", "channelName" : "声道04"
		}, {
			"channel" : "05", "channelName" : "声道05"
		}, {
			"channel" : "06", "channelName" : "声道06"
		}, {
			"channel" : "07", "channelName" : "声道07"
		}, {
			"channel" : "08", "channelName" : "声道08"
		} ],
		bitList : [ {
			"bitCode" : "archive", "bitName" : "归档码流"
		}, {
			"bitCode" : "play", "bitName" : "播放码流"
		}, {
			"bitCode" : "review", "bitName" : "预览码流"
		} ],
		terminalList : [ {
			"terminalType" : "TV", "terminalName" : "电视"
		}, {
			"terminalType" : "PC", "terminalName" : "PC端"
		}, {
			"terminalType" : "MO", "terminalName" : "移动端"
		}],
		audioDialog : {
			title : "音频文件声道/语种",
			display : false,
			channel : '',
			language : ''
		},
		subtitleDialog : {
			title : "字幕文件语种",
			display : false,
			language : ''
		},
		languageList : [ {
			"language" : "chinese", "languageName" : "中文"
		}, {
			"language" : "english", "languageName" : "英文"
		}, {
			"language" : "french", "languageName" : "法文"
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

var setStreamProcessBar = function(p) {
	var barId = "#stream-process-bar_" + p.id;
	$(barId + " .bar-width").css("width", p.percent + "%");
	$(barId + " .stream-percent").html(p.percent + "%");
	if (p.formatSpeed) {
		$(barId + " .stream-speed").html(p.formatSpeed);
	}
	$(barId + " .stream-uploaded").html(p.formatLoaded + "/" + p.formatSize);
	$(barId + " .stream-remain-time").html(p.formatTimeLeft);
	
	var dataFile = DataFileMap[p.id];
	dataFile['barWidth'] = "width: " + p.percent + "%;";
	dataFile['percent'] = p.percent;
	if (p.formatSpeed) {
		dataFile['formatSpeed'] = p.formatSpeed;
	}
	dataFile['formatLoaded'] = p.formatLoaded;
	dataFile['formatSize'] = p.formatSize;
	dataFile['formatTimeLeft'] = p.formatTimeLeft;
	dataFile['totalPercent'] = p.totalPercent;
}

var config = {
	customered : true,
	browseFileId : "i_select_files",
	browseFileBtn : "<div></div>",
	filesQueueId : "i_stream_files_queue",
	filesQueueHeight : 200,
	messagerId : "i_stream_message_container",
	autoUploading: true,
	maxSize: 9007199254740992,
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
		console.log(JSON.stringify("onCancel"));
	},
	onComplete: function(file) {
		var params = {
			id : file.id,
			percent : "100",
			formatLoaded : file.formatLoaded,
			formatSize : file.formatSize,
			formatTimeLeft : "00:00:00",
			totalPercent : file.totalPercent
		}
		setStreamProcessBar(params);
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
		
		var params = {
			id : file.id,
			percent : "0",
			formatLoaded : "0",
			formatSpeed : "--",
			formatSize : file.formatSize,
			formatTimeLeft : "--:--:--",
			totalPercent : file.totalPercent
		}
		setStreamProcessBar(params);
	},
	onUploadProgress: function(file) {
		var params = {
			id : file.id,
			percent : file.percent,
			formatSpeed : file.formatSpeed,
			formatLoaded : file.formatLoaded,
			formatSize : file.formatSize,
			formatTimeLeft : file.formatTimeLeft,
			totalPercent : file.totalPercent
		}
		setStreamProcessBar(params);
	},
	onStop: function() {
	 	alert('onStop');
	},
	onCancelAll: function(numbers) {
//	 	alert('onCancelAll');
	}, 
	onRepeatedFile: function(f) {
	}
};
var _t = new Stream(config);
</script>
