/**
 * 
 * 首页专用js
 * 
 */

/**
 * Get取数据
 * @param url
 * @param data 数据
 * @param success 成功回调函数
 * @param me Vue对象
 * @returns
 */
function getData(url,data,success,errType){
	var errorFunc=function(){
		alert("获取数据失败！");
	};
	
	//调用前
	var loading=function(){
		$('#loading').show();
	};
	//调用完成
	var completed=function(xhr, textStatus){
		$('#loading').hide();
		/*
		var status=xhr.getResponseHeader("sessionstatus");
		if(status=="sessionOut"){
			alert("被迫下线，原因：与服务器失去连接！");
			var top=getTopWin();
			top.document.location="/criportal/logout.jsp";
		}
		*/		
	};
	
	//success函数
	var gsuccess=function(data){
		var tmp=data+"";
		if(tmp.indexOf("login-form")>0){
			alert("被迫下线，原因：与服务器失去连接！");
			var top=getTopWin();
			top.document.location="/framework/index.jsp";			
		}else{
			success(data);
		}
	};

	$.ajax({
	   type: "GET",
	   cache:false,
	   url:  url,	  
	   data: data,
	   complete:completed,
	   beforeSend:loading,
	   success: gsuccess,
	   error:errorFunc
	});
}

/**
 * Post数据
 * @param url
 * @param data 数据
 * @param success 成功回调函数
 * @param me Vue对象
 * @returns
 */
function postData(url,data,success,errorType){
	var errorFunc=function(){
		alert("获取数据失败！");
	};
	
	//调用前
	var loading=function(){
		$('#loading').show();
	};
	//调用完成
	var completed=function(xhr, textStatus){
		$('#loading').hide();
		/*
		var status=xhr.getResponseHeader("sessionstatus");
		if(status=="sessionOut"){
			alert("被迫下线，原因：与服务器失去连接！");
			var top=getTopWin();
			top.document.location="/criportal/logout.jsp";
		}
		*/		
	};
	
	//success函数
	var gsuccess=function(data){
		var tmp=data+"";
		if(tmp.indexOf("login-form")>0){
			alert("被迫下线，原因：与服务器失去连接！");
			var top=getTopWin();
			top.document.location="/framework/index.jsp";			
		}else{
			success(data);
		}
	};

	$.ajax({
	   type: "POST",
	   cache:false,
	   url:  url,	  
	   data: data,
	   complete:completed,
	   beforeSend:loading,
	   success: gsuccess,
	   error:errorFunc
	});
}