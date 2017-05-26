<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<link rel="stylesheet" href="../../css/app.css">
<link rel="stylesheet" href="../../js/lib/theme-default/index.css">
<script src="../../js/vue/vue.js"></script>
<script src="../../js/bootstrap/js/jquery.mini.js"></script>
<script src="../../js/app.js"></script>
<script src="../../js/lib/index.js"></script>
<title>用户管理</title>
</head>
<body>
<div id="app" class="app_context" v-loading.fullscreen.lock="loading">
	<div class="app_title">
		<div class="app_title_show">用户管理</div>
		<div style="float: right; margin-right: 20px;">
			<el-button type="primary" @click="onAddUser()" icon="plus" size="small">添加</el-button>
		</div>
	</div>
	<div class="app_line"></div>
	<div class="app_bar">
		<el-input placeholder="用户名" style="display:inline-block;" size="small" v-model="name" width="200"></el-input>
		<el-input placeholder="姓名" style="display:inline-block;" size="small" v-model="name_ch" width="200"></el-input>
		<el-input placeholder="邮箱" style="display:inline-block;" size="small" v-model="email" width="200"></el-input>
		<el-button icon="search" type="primary" size="small" @click="onSearch()">查询</el-button>
	</div>
	<el-table :data="tableData" border highlight-current-row style="width:100%">
		<el-table-column prop="name" label="用户名" width="200" header-align="center"></el-table-column>
		<el-table-column prop="name_ch" label="姓名" width="100"> </el-table-column>
		<el-table-column prop="gender" label="性别" width="65" :formatter="genderFormatter"></el-table-column>
		<el-table-column prop="email" label="邮件" header-align="center"></el-table-column>
		<el-table-column prop="state" label="状态" :formatter="stateFormatter"></el-table-column>
		<el-table-column label="操作" width="180" :context="_self" inline-template>
		<template>
			<el-button size="small" @click="onEdit($index, row)" type="primary"> 编辑 </el-button>
			<el-button size="small" @click="onDel($index, row)" type="danger"> 删除 </el-button>
		</template>
		</el-table-column>
		<el-table-column label="标签"
	      prop="tag"
	      
	      width="100"
	      :filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]"
	      :filter-method="filterTag"
	      filter-placement="bottom-end"
	      >
<!-- 	      <template scope="scope"> -->
<!-- 	      	<span class="el-tag el-tag--primary __web-inspector-hide-shortcut__">家1</span> -->
<!-- 	        <el-tag -->
<!-- 	          :type="scope.row.tag === '家' ? 'primary' : 'success'" -->
<!-- 	          close-transition>{{scope.row.tag}}</el-tag> -->
<!-- 	      </template> -->
	    </el-table-column>
	</el-table>
	<div class="pagination">
		<el-pagination @current-change="onCurrentChange" :current-page="page.thepage" :page-size="page.pageSize" layout="total, prev, pager, next, jumper" :total="page.total"></el-pagination>
	</div>
	<el-dialog :title="titleStr" v-model="dialogFormVisible" style="width:1250px;">
		<el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm" style="width:500px;">
			<el-form-item label="用户标识" prop="pk" v-show="false"><el-input v-model="ruleForm.pk"></el-input></el-form-item>
			<el-form-item label="用户名" prop="name"><el-input v-model="ruleForm.name"></el-input></el-form-item>
			<el-form-item label="姓名" prop="name_ch"><el-input v-model="ruleForm.name_ch"></el-input></el-form-item>
			<el-form-item label="性别" prop="gender">
				<el-radio-group v-model="ruleForm.gender"><el-radio :label="true">男</el-radio><el-radio :label="false">女</el-radio></el-radio-group>
			</el-form-item>
			<el-form-item label="邮件" prop="email"><el-input v-model="ruleForm.email"></el-input></el-form-item>
			<el-form-item label="密码" prop="password"><el-input type="password" v-model="ruleForm.password"></el-input></el-form-item>
			<el-form-item label="状态" prop="state">
				<el-radio-group v-model="ruleForm.state"><el-radio :label="true">可用</el-radio><el-radio :label="false">禁用</el-radio></el-radio-group>
			</el-form-item>
			<template v-if="editoradd=='add'">
				<el-form-item><el-button type="primary" @click="doSubmitAdd">保存</el-button><el-button @click="doReset">重置</el-button> </el-form-item>
			</template>
			<template v-else> 
				<el-form-item><el-button type="primary" @click="doSubmitEdit">保存</el-button><el-button @click="doCancel()">取消</el-button></el-form-item>
			</template>
		</el-form>
	</el-dialog>
</div>
</body>
</html>
<script>
//表单对象
var ruleForm = {
	pk : '',
	name : '',
	name_ch : '',
	password : '',
	email : '',
	gender : true,
	state : true,
	tag : '家'
};
 // 表单验证
var rules = {
	name : [ {
		required : true,
		message : '请输入用户名',
		trigger : 'blur'
	}, {
		max : 60,
		message : '用户名不能超过60个字符',
		trigger : 'blur'
	} ],
	name_ch : [ {
		required : true,
		message : '请输入姓名',
		trigger : 'blur'
	}, {
		min : 1,
		max : 60,
		message : '姓名不能超过60 个字符',
		trigger : 'blur'
	} ]
};

var vm = new Vue({
	data : {
		tableData : [],
		ruleForm : ruleForm,
		rules : rules,
		dialogFormVisible : false, // 弹框
		titleStr : '用户信息编辑', // 弹框标题
		loading : true,
		editoradd : "add",
		page : {
			thepage : 1,
			pageSize : 20,
			total : 0
		},
		name : '',
		name_ch : '',
		email : ''
	},
	el : '#app',
	methods : {
		onEdit : function(index, row) {
			_self = this;
			_self.dialogFormVisible = true;
			_self.editoradd = "edit";
			var pk = row.pk;
			if (pk == "") {
				_self.$message({
					message : "错误的请求,请后退重试",
					type : "error",
					showClose : true
				});
			} else {
				var data = {
					"pk" : pk
				};
				postData("getUser.do", data, _self, function(response) {
					_self.ruleForm = response;
				});
			}
		}, doReset : function() {
			this.$refs.ruleForm.resetFields();
		}, doCancel : function() {
			var _self = this;
			_self.dialogFormVisible = false;
			_self.$refs.ruleForm.resetFields();
		}, doSubmitEdit : function(ev) {
			var _self = this;
			_self.dialogFormVisible = false;
			_self.$refs.ruleForm.validate(function(valid) {
				if (valid) {
					var url = "updateUser.do";
					var data = _self.ruleForm;
					postData(url, data, _self, function(response) {
						if (response.status == "OK") {
							_self.$refs.ruleForm.resetFields();
							_self.$message({
								message : '保存成功！',
								showClose : true,
								onClose : function() {
									document.location = "list.jsp";
								}
							});
						} else {
							_self.$message.error(response.message);
						}

					});
				} else {
					return false;
				}
			});
		}, onDel : function(index, row) {
			var _self = this;
			var pk = row.pk;
			this.$confirm('此操作将永久删除该用户, 是否继续?', '提示', {
				confirmButtonText : '确定',
				cancelButtonText : '取消',
				type : 'warning'
			}).then(function() {
				getData("deleteUser.do", {
					"pk" : pk
				}, _self, function(response) {
					window.location.reload();
				});
			});
		}, doSubmitAdd : function(ev) {
			var _self = this;
			_self.dialogFormVisible = false;
			_self.$refs.ruleForm.validate(function(valid) {
				if (valid) {
					var url = "saveUser.do";
					var data = _self.ruleForm;
					postData(url, data, _self, function(response) {
						if (response.status == "OK") {
							_self.$refs.ruleForm.resetFields();
							_self.$message({
								message : '保存成功！',
								showClose : true,
								onClose : function() {
									document.location = "list.jsp";
								}
							});
						} else {
							_self.$message.error(response.message);
						}
					});
				} else {
					return false;
				}
			});
		}, onAddUser : function() {
			var _self = this;
			_self.editoradd = "add";
			_self.funFlag = false;
			_self.dialogFormVisible = true;
		}, onCurrentChange : function(pageNum) {
			var _self = this;
			var data = {
				"thepage" : pageNum,
				"name" : _self.name,
				"name_ch" : _self.name_ch,
				"email" : _self.email
			};
			getData('findUser.do', data, _self, function(response) {
				_self.tableData = response.list;
				_self.page = response.page;
			});
		}, onSearch : function() {
			var _self = this;
			var data = {
				"thepage" : _self.page.thepage,
				"name" : _self.name,
				"name_ch" : _self.name_ch,
				"email" : _self.email				
			};
			getData('findUser.do', data, _self, function(response) {
				_self.tableData = response.list;
				_self.page = response.page;
			});
		}, genderFormatter : function(row, column) {
			return row.gender == 1 ? "男" : "女";
		}, stateFormatter : function(row, column) {
			return row.state == 1 ? "可用" : "禁用";
		}, filterTag : function(value, row) {
	    	return row.tag === value;
	    }
	}, created : function() {
		var _self = this;
		getData('findUser.do', null, _self, function(response) {
			for (var i=0; i<response.list.length; i++) {
				var data = response.list[i];
				data.tag = "家";
			}
			_self.tableData = response.list;
			_self.page = response.page;
		});
		_self.loading = false;
	}
})
</script>
