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
		<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	</head>
	<body>
		<script type="text/javascript">
			$(function () {
				// 如果当前窗口不是顶层窗口，则把当前窗口设置为顶层窗口
				if (window.top != window) {
					window.top.location = window.location
				}
				// 在页面加载完成后清空文本框内的内容
				// $("#loginAct").val("")
				// $("#loginPwd").val("")
				// 获得焦点
				$("#loginAct").focus()
				// 为登录按钮绑定事件
				$("#submitBtn").click(function () {
					login()
				})
				// 为当前窗口绑定键盘事件
				$(window).keydown(function (event) {
					if (13 == event.keyCode) {
						login()
					}
				})
			})
			// 普通的自定义的方法写在$(function(){})外面
			function login() {
				// 验证用户名和密码是否为空
				var loginAct = $.trim($("#loginAct").val())
				var loginPwd = $.trim($("#loginPwd").val())
				if (loginAct == "" || loginPwd == "") {
					$("#msg").html("用户名或密码不能为空")
					// 如果用户名或密码为空，则终止该方法
					return
				}
				$.ajax({
					url: "settings/user/login.do",
					type: "post",
					data: {
						"loginAct": loginAct,
						"loginPwd": loginPwd
					},
					dataType: "json",
					success: function (data) {
						// 登录成功则跳转，登录失败则显示错误信息
						if (data.success) {
							window.location.href = "workbench/index.jsp"
						} else {
							$("#msg").html(data.msg)
						}
					}
				})
			}
		</script>
		<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
			<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
		</div>
		<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
			<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
		</div>

		<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
			<div style="position: absolute; top: 0px; right: 60px;">
				<div class="page-header">
					<h1>登录</h1>
				</div>
				<form action="workbench/index.jsp" class="form-horizontal" role="form">
					<div class="form-group form-group-lg">
						<div style="width: 350px;">
							<input id="loginAct" class="form-control" type="text" placeholder="用户名">
						</div>
						<div style="width: 350px; position: relative;top: 20px;">
							<input id="loginPwd" class="form-control" type="password" placeholder="密码">
						</div>
						<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

								<span id="msg" style="color: red"></span>

						</div>
						<button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
					</div>
				</form>
			</div>
		</div>
	</body>
</html>