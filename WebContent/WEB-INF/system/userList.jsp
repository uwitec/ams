<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>用户列表</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" ></meta>
    <link href="${path}/resources/ligerUI/skins/Gray/css/ligerui-all.css" rel="stylesheet" type="text/css" />	
    <link href="${path}/resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css"/>
    <link href="${path}/resources/css/ui.css" rel="stylesheet" type="text/css" />
    <link href="${path}/resources/css/main.css" rel="stylesheet" type="text/css" />
    <link href="${path}/resources/css/main2.css" rel="stylesheet" type="text/css" />
    <link href="${path}/resources/css/base.css" rel="stylesheet" type="text/css" />
    <script src="${path}/resources/js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="${path}/resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="${path}/resources/js/config.js" type="text/javascript" ></script>
    <script src="${path}/resources/js/commonFN.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	
		var grid = null;
		$(document).ready(function(){
			grid = $("#maingrid").ligerGrid({
				toolbar: { items: [
					{ text: '新增', click: add, icon:'add'},               	
					{ line: true },                
					{ text: '刷新', click: refresh, icon:'refresh'}
				]},
				columns: [
				{ display: '用户账号', name: 'userName', width: "250" },
				{ display: '用户姓名', name: 'realName', width: "250" },
				{ display: '电话', name: 'phone', width: "150"}, 
				{ display: '部门', name: 'departId', width: "150"}, 
				{ display: '是否启用', name: 'enable', width: "100"},
				{display: '操作',width: "200", render: function (rowdata, rowindex, value){
					var h="";
					h += "<a href='${path}/user/detail?id="+rowdata.userId+"' rel='pageTab' data-tabid='yhxx"+rowdata.userId+"' data-tabTxt='用户详细' data-parentOpen='true' style='color:teal'>详细</a>&nbsp;|";
					h += "<a href='javascript:beginEdit(\"" + rowdata.userId + "\")' style='color:teal'>编辑</a>&nbsp;|";
					if(rowdata.enable=="启用"){
						h += "<a href='javascript:disable(\""+rowdata.userId+"\")' style='color:teal' >停用</a>&nbsp;|";
					}else{
						h += "<a href='javascript:enable(\""+rowdata.userId+"\")' style='color:teal' >启用</a>&nbsp;|";
					}
					h += "<a href='javascript:itemDel(\""+rowdata.userId+"\")' style='color:teal' >删除</a> ";
					return h;
				}}],
				usePager:true,
				root:'rows',
				record:'total',
                url:"${path}/user/list",
				fixedCellHeight: false,
				rownumbers:true,
				clickToEdit:false,
				width: '100%',height:'99%'
			});
			Public.pageTab();//启用链接打开tab页
		});
		function add(){
			parent.Public.addTab("","新建用户","${path}/userRole/add");
		}
		function refresh(){
			window.location.reload();
		}
		function search(){
			grid.changePage("first");
			var params=$("#searchForm").serialize();
			grid.set("url","${path}/user/list?"+params);//重新设置url,grid会自动加载，不需要再用grid.loadData(),否则查询会执行两次;
			return false;
		}
		function beginEdit(userId) { 
			parent.Public.addTab("yhbj"+userId,"用户编辑","${path}/userRole/edit?id="+userId);
        }
		//停用
        function disable(userId) {
        	parent.Public.ajaxPost("${path}/user/disable?id="+userId,"",function(data){
        		data=eval(data);
        		if(data){
        			parent.Public.tips({type: 0, content : data.message});
        			grid.reload();
        		}else{
        			parent.Public.tips({type: 0, content : data.message});
        		}
        	});
        }
		//启用
        function enable(userId)
        {
        	parent.Public.ajaxPost("${path}/user/enable?id="+userId,"",function(data){
        		data=eval(data);
        		if(data.state){
        			parent.Public.tips({type: 0, content : data.message});
        			grid.reload();
        		}else{
        			parent.Public.tips({type: 1, content : data.message});
        		}
        	});
        }
		//删除
        function itemDel(userId){
        	$.ligerDialog.confirm('确定删除？', function (yes) {
        		if(yes){
		        	parent.Public.ajaxPost("${path}/user/delete?id="+userId,"",function(data){
		        		data=eval(data);
		        		if(data){
		        			parent.Public.tips({type: 0, content : data.message});
		        			params=$("#searchForm").serializeObject();
		        			grid.loadServerData(params);
		        		}else{
		        			parent.Public.tips({type: 0, content : data.message});
		        		}
		        	});
        		}
        	});
        }
 
	</script>
</head>
<body>
	
	<div class="search-wrap">
		<form id="searchForm" onsubmit="return search();" method="post">
		<dl>
			<dd>
				<label class="b-label" >是否启用：</label>
				<span class="ui-search">
					<select name="enable">
						 <option value="">--全部 --</option>
						 <gt:option groupName="dic_state" selectedValue="${model.enable}"></gt:option>
					</select>
				</span>
				&nbsp;&nbsp;
				<label class="b-label">用户名：</label>
				<span class="ui-search">
					<input type="text" class="ui-input" name="name" value="${model.name}" placeholder="请输入用户姓名"/>
				</span>
			    <input id="btnOK" type="submit" value="搜 索" class="ui-btn" >
			    <input type="reset" value="重置" class="ui-btn" >
			</dd>
		</dl>
		</form>	
	</div>
	
	<div class="clear ht_10"></div>
	<div id="maingrid" style="margin:0; padding:0"></div>
</body>
</html>