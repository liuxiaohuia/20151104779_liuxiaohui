<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>学生基本信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

	<link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.3.2/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.3.2/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.3.2/demo/demo.css">
	<!-- <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.3.3/themes/bootstrap/easyui.css"> -->
	<script type="text/javascript" src="js/jquery-easyui-1.3.2/jquery-1.8.0.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="js/jquery-easyui-1.3.2/jquery.easyui.min.js" charset="utf-8"></script>
	<script type="text/javascript" src="js/jquery-easyui-1.3.2/locale/easyui-lang-zh_CN.js" charset="utf-8"></script>

	<script type="text/javascript">
		var url;

		//隐藏密码这一列
		$(function(){
			// TIP: 配合body解决页面跳动和闪烁问题
			$("body").css({visibility:"visible"});
			
			// 隐藏student_userPass列
			$("#dg").datagrid('hideColumn', 'student_userPass');
			
			var loginFlag=$("#loginFlag").val();
			if("teacher"==loginFlag){
				$("#teacherShow").show();
				$("#systemShow").hide();
				$("#vipStudentShow").hide();
			}
			if("system"==loginFlag){
				$("#systemShow").show();
				$("#teacherShow").hide();
				$("#vipStudentShow").hide();
			}
			if("vipStudent"==loginFlag){
				$("#systemShow").hide();
				$("#teacherShow").hide();
				$("#vipStudentShow").show();
			}
		});
		//查询
		function searchUser(){
	    	$("#dg").datagrid('load',{
	    		s_name:$("#s_name").val(),
	    		s_state:$("#s_state").combobox('getValue'),
	    		s_institution:$("#s_institution").combobox('getValue'),
	    		s_class:$("#s_class").val()
	    	});
	    }
		
		//点击删除按钮
		function deleteUser(){
			var selectedRows=$("#dg").datagrid("getSelections");
			if(selectedRows.length==0){
	    		$.messager.alert("系统提示","请选择要删除的数据!","warning");
	    		return;
	    	}	
	    	
			var strIds=[];
		    for(var i=0;i<selectedRows.length;i++){
		    	strIds.push(selectedRows[i].student_id);
		    }
		    var ids = strIds.join(",");
		    if(ids.length == 1 || ids.length == 2){
		    	if(selectedRows[0].student_building != null && selectedRows[0].student_dorm != null 
		    			&& selectedRows[0].student_dorm != "" && selectedRows[0].student_building != ""){
		    		$.messager.alert("系统提示","该学生已入住寝室，禁止删除！","warning");
			    	return;
		    	}
		    }else {
		    	for(var i=0;i<selectedRows.length;i++){
			    	if(selectedRows[i].student_building != null && selectedRows[i].student_building != "" 
			    			&& selectedRows[i].student_dorm != null && selectedRows[i].student_dorm !=""){
		    			$.messager.alert("系统提示","选中记录存在已入住学生，禁止删除！","warning");
		    			return;
			    	}
			    }
		    }
		    $.messager.confirm("系统提示","您确定要删掉这<font color='red'>"+selectedRows.length+"</font>条数据么?",function(r){
		    	if(r){
		    		$.post("StudentManageAction!delete.action",{delIds:ids},function(result){
		    			if(result.success){
		    				$.messager.alert("系统提示",'您已成功删除<font color=red>'+result.delNums+"</font>条数据!","info");
		    				$("#dg").datagrid("reload");
		    			}else{
		    				$.messager.alert("系统提示",result.errorMsg,"warning");
		    			}
		    		},"json"); 
		    	}
		    });
		}
		