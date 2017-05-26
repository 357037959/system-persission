var config = {
	browseFileId : "i_select_files", /** 选择文件的ID, 默认: i_select_files */
	browseFileBtn : "<div>请选择文件</div>", /** 显示选择文件的样式, 默认: `<div>请选择文件</div>` */
	dragAndDropArea: "i_select_files", /** 拖拽上传区域，Id（字符类型"i_select_files"）或者DOM对象, 默认: `i_select_files` */
	dragAndDropTips: "<span>把文件(文件夹)拖拽到这里</span>", /** 拖拽提示, 默认: `<span>把文件(文件夹)拖拽到这里</span>` */
	filesQueueId : "i_stream_files_queue", /** 文件上传容器的ID, 默认: i_stream_files_queue */
	filesQueueHeight : 200, /** 文件上传容器的高度（px）, 默认: 450 */
	messagerId : "i_stream_message_container", /** 消息显示容器的ID, 默认: i_stream_message_container */
	multipleFiles: true, /** 多个文件一起上传, 默认: false */
	autoUploading: false, /** 选择文件后是否自动上传, 默认: true */
// 	autoRemoveCompleted : true, /** 是否自动删除容器中已上传完毕的文件, 默认: false */
	maxSize: 104857600, /** 单个文件的最大大小，默认:2G */
	retryCount : 5, /** HTML5上传失败的重试次数 */
	postVarsPerFile : { /** 上传文件时传入的参数，默认: {} */
		param1: "val1",
		param2: "val2"
	},
	swfURL : "/swf/FlashUploader.swf", /** SWF文件的位置 */
	tokenURL : "/upload/tk", /** 根据文件名、大小等信息获取Token的URI（用于生成断点续传、跨域的令牌） */
	frmUploadURL : "/upload/fd;", /** Flash上传的URI */
	uploadURL : "/upload/up", /** HTML5上传的URI */
	simLimit: 200, /** 单次最大上传文件个数 */
	extFilters: [".txt", ".rpm", ".rmvb", ".gz", ".rar", ".zip", ".avi", ".mkv", ".mp3", ".ts"], /** 允许的文件扩展名, 默认: [] */
	onSelect: function(list) {
// 		alert('onSelect');
	}, 
	onMaxSizeExceed: function(size, limited, name) {
// 		alert('onMaxSizeExceed');
	},
	onFileCountExceed: function(selected, limit) {
// 		alert('onFileCountExceed');
	},
	onExtNameMismatch: function(name, filters) {
// 		alert('onExtNameMismatch');
	},
	onCancel : function(file) {
// 		alert('Canceled: ' + file.name);
	},
	onComplete: function(file) {
// 		alert('onComplete');
	},
	onQueueComplete: function() {
// 		alert('onQueueComplete');
	},
	onUploadError: function(status, msg) {
// 		alert('onUploadError');
	},
	onAddTask: function(file) {
// 		alert('onAddTask');
	},
	onUploadProgress: function(file) {
// 		alert('onUploadProgress');
	},
	onStop: function() {
// 		alert('onStop');
	},
	onCancelAll: function(numbers) {
// 		alert('onCancelAll');
	},
	onRepeatedFile: function(f) {
// 		alert('onRepeatedFile');
	}
};
var _t = new Stream(config);
if (!_t.bDraggable) {
	$("#i_stream_dropzone").hide();
}
if (!_t.bStreaming) {
	_t.config.maxSize = 2147483648;
}