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
		//添加
		function newUser(){
			$("#dlg").dialog("open").dialog("setTitle","添加学生");
			$("#fm").form("clear");
			
			// 设置单选按钮默认选中
			$('[name="vo.student_sex"]:radio').each(function() {   
                if (this.value == '男'){   
                   this.checked = true;   
                }       
            }); 
			url="StudentManageAction!save.action";
		}
	
		//编辑
		function editUser(){
			var selectedRows=$("#dg").datagrid("getSelections");
			if(selectedRows.length!=1){
	    		$.messager.alert("系统提示","请选择一条要修改的数据！","warning");
	    		return;
	    	}
	    	var row=selectedRows[0];
	    	
	    	$("#dlg").dialog("open").dialog("setTitle","编辑学生");
	    	$("#student_userName").val(row.student_userName);
	    	/* $("#student_userPass").val(row.student_userPass); */
	    	$("#student_name").val(row.student_name);
	    	// 赋值给界面radio控件
	    	if(row.student_sex == "男"){
	    		$('input:radio[name="vo.student_sex"][value="男"]').prop('checked', true);
	    	}else if(row.student_sex == "女"){
	    		$('input:radio[name="vo.student_sex"][value="女"]').prop('checked', true);
	    	}
	    	//赋值给界面的checkBox
	    	if(row.student_headFlag == "是"){
	    		$("[name='vo.student_headFlag']").attr("checked","checked");
	    	}else{
	    		$("[name='vo.student_headFlag']").removeAttr("checked"); //从每一个匹配的元素中删除一个属性
	    	}
	    	
	    	$("#student_institution").val(row.student_institution);
	    	$("#student_major").val(row.student_major);
	    	$("#student_class").val(row.student_class);
	    	$("#student_phone").val(row.student_phone);
	    	$("#student_remark").val(row.student_remark);

	    	url="StudentManageAction!save.action?student_id="+row.student_id;
		}
		//保存
		function saveUser(){
			$("#fm").form("submit",{
				url:url,
				onSubmit:function(){
					return $(this).form('validate');
				},
				success:function(result){
					var result=eval("("+result+")");
					if(result.errorMsg){
						$.messager.alert("系统提示",result.errorMsg,"warning");
						return;
					}else{
						$.messager.alert("系统提示","您已经保存成功！","info");
						$("#dlg").dialog("close");
						$("#dg").datagrid("reload");
					}
				}
			});
		}

		//用模版导出用户
		 function exportUser(){
			$('#condition').submit();
		}
		// 获取当前时间
		function myformatterStart(date){  
		     var y = date.getFullYear();  
            var m = date.getMonth()+1;  
            var d = date.getDate();  
            var h = date.getHours();  
            var min = date.getMinutes();  
            var sec = date.getSeconds();
            var time = y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+(h<10?('0'+h):h)+':'+(min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
            return time; 
		}  
		
		function myformatterEnd(date){  
		    var y = date.getFullYear();  
            var m = date.getMonth()+1;  
            var d = date.getDate();  
            var h = date.getHours();  
            var min = date.getMinutes();  
            var sec = date.getSeconds();
            var time = y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+(h<10?('0'+h):h)+':'+(min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
            return time; 
		}  
		          
		function myparser(s){  
		    if (!s) return new Date();
		    if(s != null && s.length > 0 && s != undefined){
		    	var ss = (s.split('-')); 
			    var y = parseInt(ss[0],10);  
			    var m = parseInt(ss[1],10);  
			    var d = parseInt(ss[2],10); 
			    var tt = ss[2];
			    tt = (tt.split(' '));
			    var time = tt[1];
			    ss = (time.split(':')); 
			     var h = parseInt(ss[0],10);  
			     var min = parseInt(ss[1],10); 
			     var sec = parseInt(ss[2],10); 
	            if (!isNaN(y) && !isNaN(m) && !isNaN(d) && !isNaN(h) && !isNaN(min) && !isNaN(sec)){  
	                return new Date(y,m-1,d,h,min,sec);  
	            } else {  
	                return new Date();  
	            }  
		    }  
		} 
		//缺寝登记
		function lackUser(){
			var selectedRows=$("#dg").datagrid("getSelections");
			if(selectedRows.length!=1){
	    		$.messager.alert("系统提示","请先选择缺寝的学生！","warning");
	    		return;
	    	}
	    	var row=selectedRows[0];
	    	if(row.student_building == null || row.student_building == ""
	    		 || row.student_dorm == null || row.student_dorm == ""){
	    		$.messager.alert("系统提示","该学生还没有入住寝室，请确认后登记！","warning");
	    		return;
	    	}
	    	
	    	$("#dlgLack").dialog("open").dialog("setTitle","学生缺寝登记");
	    	$("#fmLack").form("clear");
	    	$("#student_userNameLack").val(row.student_userName);
	    	$("#student_id").val(row.student_id);
	    	$("#student_nameLack").val(row.student_name);
	    	
	    	// 赋值给界面radio控件
	    	if(row.student_sex == "男"){
	    		$('input:radio[name="vo.student_sex"][value="男"]').prop('checked', true);
	    	}else if(row.student_sex == "女"){
	    		$('input:radio[name="vo.student_sex"][value="女"]').prop('checked', true);
	    	}
	    	
	    	$("#student_institutionLack").val(row.student_institution);
	    	$("#student_majorLack").val(row.student_major);
	    	$("#student_classLack").val(row.student_class);
	    	$("#student_buildingLack").val(row.student_building);
	    	$("#student_dormLack").val(row.student_dorm);
	    	$("#student_remarkLack").val();
	    	