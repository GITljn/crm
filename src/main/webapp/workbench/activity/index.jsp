<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		// 打开添加操作的模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url: "workbench/activity/getUserList.do",
				type: "get",
				data: {

				},
				dataType: "json",
				success: function (data) {
					var html = ""
					$.each(data, function (i, e) {
						// 给用户看的是name，实际提交的是id
						html += "<option value='"+e.id+"'>"+ e.name +"</option>"
					})
					$("#create-owner").html(html)
					//设置下拉菜单的默认选项
					$("#create-owner").val("${user.id}")
					$("#createActivityModal").modal("show")
				}
			})

		})


		// 执行添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url: "workbench/activity/save.do",
				type: "post",
				data: {
					"owner" : $.trim($("#create-owner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val()),
				},
				dataType: "json",
				success: function (data) {
					if (data.success) {
						//$("#activityAddForm").submit()  可以提交表单
						//jquery没有提供reset函数，需要转化为原生对象
						$("#activityAddForm")[0].reset()
						$("#createActivityModal").modal("hide")
						pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
					} else {
						alert("创建失败");
					}
				}
			})
		})


		// 进入市场活动页面后显示市场活动列表
		pageList(1, 4)


		// 执行查询操作
		$("#searchBtn").click(function () {
			//点击查询按钮的时候将搜索框中的信息保存在隐藏域
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))
			pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
		})


		// 执行全选和反选操作
		$("#qx").click(function () {
			$("input[name='xz']").prop("checked", this.checked)
		})
		// 动态生成的元素要使用on的方式绑定事件
		// $(需要绑定元素的有效外层元素).on(事件，需要绑定的元素，回调函数)
		// 有效元素指非动态拼接的
		$("#activityBody").on("click", $("input[name='xz']"), function () {
			$("#qx").prop("checked", $("input[name='xz']").length == $("input[name='xz']:checked").length)
		})


		// 执行删除操作
		$("#deleteBtn").click(function () {
			var $xz = $("input[name='xz']:checked")
			if (0 == $xz.length) {
				alert("请选择要删除的记录")
			} else {
				if (!confirm("确定删除吗?")) {
					return false
				}
				var param = ""
				for (var i = 0; i < $xz.length; i++) {
					param += "id=" + $xz[i].value + "&"
				}
				param = param.substring(0, param.length - 1)
				// alert(param)
				$.ajax({
					url: "workbench/activity/delete.do",
					type: "post",
					data: param,
					dataType: "json",
					success: function (data) {
						if (data.success) {
							pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
						} else {
							alert("删除失败")
						}
					}
				})
			}
		})


		// 打开修改操作的模态窗口
		$("#editBtn").click(function () {
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			var $xz = $("input[name='xz']:checked")
			if (0 == $xz.length) {
				alert("请先选中要修改的记录")
			} else if (1 < $xz.length) {
				alert("不能同时修改多条记录")
			} else {
				$.ajax({
					url: "workbench/activity/getUserListAndActivity.do",
					type: "post",
					data: {
						"id": $xz.val()
					},
					dataType: "json",
					success: function (data) {
						var userHtml = ""
						$.each(data.userList, function (i, e) {
							userHtml += "<option value='"+e.id+"'>"+e.name+"</option>"
						})
						$("#edit-owner").html(userHtml)

						$("#edit-owner").val(data.activity.owner)
						$("#edit-name").val(data.activity.name)
						$("#edit-startDate").val(data.activity.startDate)
						$("#edit-endDate").val(data.activity.endDate)
						$("#edit-cost").val(data.activity.cost)
						$("#edit-description").val(data.activity.description)
						$("#editActivityModal").modal("show")
					}
				})
			}
		})


		// 执行修改操作
		$("#updateBtn").on("click", update)

	});
	
	function pageList(pageNo, pageSize) {
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-startDate").val($.trim($("#hidden-startDate").val()))
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))
		$("#qx").prop("checked", false)
		$.ajax({
			url: "workbench/activity/pageList.do",
			type: "get",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"name": $.trim($("#search-name").val()),
				"owner": $.trim($("#search-owner").val()),
				"startDate": $.trim($("#search-startDate").val()),
				"endDate": $.trim($("#search-endDate").val())
			},
			dataType: "json",
			success: function (data) {
				var html = ""
				$.each(data.dataList, function (i, e) {
					html += '<tr class="active">' +
								'<td><input type="checkbox" name="xz" value="'+e.id+'" /></td>' +
								'<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+e.id+'\';">'+e.name+'</a></td>' +
								'<td>'+e.owner+'</td>' +
								'<td>'+e.startDate+'</td>' +
								'<td>'+e.endDate+'</td>' +
							'</tr>'
				})
				// var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1
				var totalPages = Math.ceil(data.total / pageSize)
				$("#activityBody").html(html)
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				})
			}
		})
	}

	function update() {
		var $xz = $("input[name='xz']:checked")
		$.ajax({
			url: "workbench/activity/update.do",
			type: "post",
			data: {
				"id": $xz.val(),
				"owner": $.trim($("#edit-owner").val()),
				"name": $.trim($("#edit-name").val()),
				"startDate": $.trim($("#edit-startDate").val()),
				"endDate": $.trim($("#edit-endDate").val()),
				"cost": $.trim($("#edit-cost").val()),
				"description": $.trim($("#edit-description").val())
			},
			dataType: "json",
			success: function (data) {
				if (data.success) {
					$("#editActivityModal").modal("hide")
					pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),
							$("#activityPage").bs_pagination('getOption', 'rowsPerPage'))
				} else {
					alert("修改失败")
				}
			}
		})
	}
	
</script>
</head>
<body>
	<%-- 隐藏域，用于保存搜索框中的信息 --%>
	<input id="hidden-name" type="hidden">
	<input id="hidden-owner" type="hidden">
	<input id="hidden-startDate" type="hidden">
	<input id="hidden-endDate" type="hidden">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<input id="hidden-checked" type="hidden">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%-- 查询条件 --%>
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>

			<%-- 创建、修改、删除 --%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<%-- 数据列表 --%>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="qx" type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>

			<%-- 页码 --%>
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>