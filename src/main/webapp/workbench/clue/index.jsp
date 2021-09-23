<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

		// 添加时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-right"
		});

		// 打开添加操作的模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url: "workbench/clue/getUserList.do",
				type: "get",
				data: {

				},
				dataType: "json",
				success: function (data) {
					var html = ""
					$.each(data, function (i, e) {
						html += "<option value='"+e.id+"'>"+e.name+"</option>"
					})
					$("#create-owner").html(html)
					$("#create-owner").val("${user.id}")
					$("#createClueModal").modal("show")
				}
			})
		})

		// 执行添加操作
		$("#saveBtn").on("click", save)
		$("#createClueModal").keydown(function (e) {
			if (13 == e.keyCode) {
				save()
			}
		})

		// 执行查询操作
		$("#search").click(function () {
			$("#hidden-fullname").val($.trim($("#search-fullname").val()))
			$("#hidden-company").val($.trim($("#search-company").val()))
			$("#hidden-phone").val($.trim($("#search-phone").val()))
			$("#hidden-source").val($.trim($("#search-source").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-mphone").val($.trim($("#search-mphone").val()))
			$("#hidden-state").val($.trim($("#search-state").val()))
			pageList(1, 4)
		})

		// 全选和反选
		$("#qx").click(function () {
			$("input[name=dx]").prop("checked", this.checked)
		})
		$("#clueBody").on("click", $("input[name=dx]"), function () {
			var checkedLen = $("input[name=dx]:checked").length
			var checkboxLen = $("input[name=dx]").length
			if (checkboxLen != checkedLen) {
				$("#qx").prop("checked", false)
			} else if (checkboxLen == checkedLen) {
				$("#qx").prop("checked", true)
			}
		})

		// 打开修改操作的模态窗口
		$("#editBtn").click(function () {
			var checkedLen = $("input[name=dx]:checked").length
			if (0 == checkedLen) {
				alert("请选择要修改的线索")
			} else if (1 < checkedLen) {
				alert("一次只能修改一个线索")
			} else {
				$.ajax({
					url: "workbench/clue/getUserListAndClue.do",
					type: "get",
					data: {
						"id": $("input[name=dx]:checked").val()
					},
					dataType: "json",
					success: function (data) {
						var users = data.users
						var clue = data.clue
						var html = ""
						$.each(users, function (i, e) {
							html += "<option value='"+e.id+"'>"+e.name+"</option>"
						})
						$("#edit-clueOwner").html(html)
						$("#edit-clueOwner").val(clue.owner)
						$("#edit-company").val(clue.company)
						$("#edit-appellation").val(clue.appellation)
						$("#edit-fullname").val(clue.fullname)
						$("#edit-job").val(clue.job)
						$("#edit-email").val(clue.email)
						$("#edit-phone").val(clue.phone)
						$("#edit-website").val(clue.website)
						$("#edit-mphone").val(clue.mphone)
						$("#edit-state").val(clue.state)
						$("#edit-source").val(clue.source)
						$("#edit-description").val(clue.description)
						$("#edit-contactSummary").val(clue.contactSummary)
						$("#edit-nextContactTime").val(clue.nextContactTime)
						$("#edit-address").val(clue.address)
						$("#editClueModal").modal("show")
					}
				})
			}
		})

		// 执行修改操作
		$("#updateBtn").on("click", update)
		$("#editClueModal").keydown(function (e) {
			if (13 == e.keyCode) {
				update()
			}
		})

		// 执行删除操作
		$("#deleteBtn").click(function () {
			var checked = $("input[name=dx]:checked")
			var checkedLen = checked.length
			if (0 == checkedLen) {
				alert("请选择要删除的记录")
			} else {
				if (!confirm("确定删除吗")) {
					return false
				}
				var ids = ""
				$.each(checked, function (i, e) {
					ids += "id=" + $(e).val() + "&"
				})
				ids = ids.substr(0, ids.length-1)
				$.ajax({
					url: "workbench/clue/delete.do",
					type: "post",
					data: ids,
					dataType: "json",
					success: function (data) {
						if (data.success) {
							pageList(1,
									$("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
						} else {
							alert("删除失败")
						}
					}
				})
			}
		})

		pageList(1, 4)
	});

	function pageList(pageNo, pageSize) {
		// 获取隐藏域中的查询条件
		$("#search-fullname").val($.trim($("#hidden-fullname").val()))
		$("#search-company").val($.trim($("#hidden-company").val()))
		$("#search-phone").val($.trim($("#hidden-phone").val()))
		$("#search-source").val($.trim($("#hidden-source").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-mphone").val($.trim($("#hidden-mphone").val()))
		$("#search-state").val($.trim($("#hidden-state").val()))

		// 请求对应页码的记录
		$.ajax({
			url: "workbench/clue/pageList.do",
			type: "get",
			data: {
				"pageNo": pageNo,
				"pageSize": pageSize,
				"fullname": $.trim($("#hidden-fullname").val()),
				"company": $.trim($("#hidden-company").val()),
				"phone": $.trim($("#hidden-phone").val()),
				"source": $.trim($("#hidden-source").val()),
				"owner": $.trim($("#hidden-owner").val()),
				"mphone": $.trim($("#hidden-mphone").val()),
				"state": $.trim($("#hidden-state").val())
			},
			dataType: "json",
			success: function (data) {
				var total = data.total
				var clues = data.clues
				var html = ""
				$.each(clues, function (i, n) {
					html += '<tr>'
					html += '<td><input value="'+n.id+'" name="dx" type="checkbox" /></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>'
					html += '<td>'+n.company+'</td>'
					html += '<td>'+n.phone+'</td>'
					html += '<td>'+n.mphone+'</td>'
					html += '<td>'+n.source+'</td>'
					html += '<td>'+n.owner+'</td>'
					html += '<td>'+n.state+'</td>'
					html += '</tr>'
				})
				var totalPages = Math.ceil(total / pageSize)
				$("#clueBody").html(html)
				$("#cluePage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: total, // 总记录条数

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

	function save() {
		$.ajax({
			url: "workbench/clue/save.do",
			type: "post",
			data: {
				"fullname" : $.trim($("#create-fullname").val()),
				"appellation" : $.trim($("#create-appellation").val()),
				"owner" : $.trim($("#create-owner").val()),
				"company" : $.trim($("#create-company").val()),
				"job" : $.trim($("#create-job").val()),
				"email" : $.trim($("#create-email").val()),
				"phone" : $.trim($("#create-phone").val()),
				"website" : $.trim($("#create-website").val()),
				"mphone" : $.trim($("#create-mphone").val()),
				"state" : $.trim($("#create-state").val()),
				"source" : $.trim($("#create-source").val()),
				"description" : $.trim($("#create-description").val()),
				"contactSummary" : $.trim($("#create-contactSummary").val()),
				"nextContactTime" : $.trim($("#create-nextContactTime").val()),
				"address" : $.trim($("#create-address").val())
			},
			dataType: "json",
			success: function (data) {
				if (data.success) {
					pageList(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
					$("#createClueModal").modal("hide")
					$("#createClueForm")[0].reset()
				} else {
					alert("添加失败")
				}
			}
		})
	}

	function update() {
		$.ajax({
			url: "workbench/clue/update.do",
			type: "post",
			data: {
				"id": $("input[name=dx]:checked").val(),
				"fullname" : $.trim($("#edit-fullname").val()),
				"appellation" : $.trim($("#edit-appellation").val()),
				"owner" : $.trim($("#edit-clueOwner").val()),
				"company" : $.trim($("#edit-company").val()),
				"job" : $.trim($("#edit-job").val()),
				"email" : $.trim($("#edit-email").val()),
				"phone" : $.trim($("#edit-phone").val()),
				"website" : $.trim($("#edit-website").val()),
				"mphone" : $.trim($("#edit-mphone").val()),
				"state" : $.trim($("#edit-state").val()),
				"source" : $.trim($("#edit-source").val()),
				"description" : $.trim($("#edit-description").val()),
				"contactSummary" : $.trim($("#edit-contactSummary").val()),
				"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
				"address" : $.trim($("#edit-address").val())
			},
			dataType: "json",
			success: function (data) {
				if (data.success) {
					pageList($("#cluePage").bs_pagination('getOption', 'currentPage'),
							$("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
					$("#editClueModal").modal("hide")
				} else {
					alert("修改失败")
				}
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option value="">请选择...</option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option value="">请选择...</option>
								  <c:forEach items="${clueState}" var="c">
									  <option value="${c.value}">${c.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option value="">请选择...</option>
								  <c:forEach items="${source}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <c:forEach items="${clueState}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
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

	<%-- 页面标题 --%>
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%-- 查询条件 --%>
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<input id="hidden-fullname" type="hidden">
				<input id="hidden-company" type="hidden">
				<input id="hidden-phone" type="hidden">
				<input id="hidden-source" type="hidden">
				<input id="hidden-owner" type="hidden">
				<input id="hidden-mphone" type="hidden">
				<input id="hidden-state" type="hidden">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="search-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="search-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="search-source" class="form-control">
					  	  <option></option>
					  	  <c:forEach items="${source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="search-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="search-state" class="form-control">
					  	<option></option>
					  	<c:forEach items="${clueState}" var="s">
							<option value="${s.value}">${s.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="search" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>

			<%-- 创建、修改、删除 --%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<%-- 数据列表 --%>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="qx" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>

					<tbody id="clueBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>

			<%-- 页码 --%>
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>

</body>
</html>