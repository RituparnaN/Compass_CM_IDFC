<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 
This page is for all the static contents like StyleSheet and JavaScript files.
 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>
<link rel="StyleSheet" type="text/css"
	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<title>CompassCM | Reset Password</title>
<script type="text/javascript">
	$(function() {
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		var multiTabDisplay = 1;
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(header, token);
		});

		$("#logout").click(function() {
			$("#logoutForm").submit();
		});
	});
</script>
</head>
<body>

	<div id="wrapper">
		<nav class="navbar navbar-default" role="navigation"
			style="margin-bottom: 0">
		<div class="navbar-header">
			<a class="navbar-brand" href="javascript:void(0)"
				style="margin-left: 50px;"> <img alt="CompassCM"
				src="${pageContext.request.contextPath}/includes/images/qde/CompassCM-Logo-Full.png"
				width="200px" style="margin-top: -15px; height: inherit;">
			</a>
		</div>

		</nav>
		<div id="page-content-wrapper" style="padding-top: 10px;">
			<div class="card card-info">
				<div class="card-header">
					<h3 class="card-title">Reset Password</h3>
				</div>
				<div class="card-body">
					<form role="form" action="<c:url value='/resetAccountPassword'/>"
						method="POST" onsubmit="return resetPassword()">
						<table style="width: 100%" >
							<tr>
		    					<td width="30%"><p>Your password has been expired.</p>
		    									<p>New password should have at least-</p>
		    									<p> &#9679;8 characters and maximum of 32 characters</br>
		    										&#9679;One Uppercase letter</br>
		    									 	&#9679;One Lowercase Letter</br>
		    										&#9679;One Numeric Character</br>
		    									    &#9679;One Special character among ~`!@#$%^&*()_-+=<,>.?/:'{[}]|</p>
		    					</td>
		    					<td width="60%">
		    						<div class="form-group">
										<label for="newpassword">New Password</label> <input
											type="password" class="form-control" id="newpassword"
											name="newpassword" placeholder="New Password" />
									</div>
									<div class="form-group">
										<label for="confirmpassword">Confirm Password</label> <input
											type="password" class="form-control" id="confirmpassword"
											name="confirmpassword" placeholder="Confirm Password" />
									</div>
									<div class="form-group">
										<button type="submit" class="btn btn-primary">Reset</button>
										<button type="button" class="btn btn-danger" id="logout" >Logout</button>
										<br/><br/>${message}									
									</div>
		    					</td>
		    				</tr>
						</table>
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					</form>
					<c:url value="/logout" var="logoutUrl" />
					<form action="${logoutUrl}" method="post" id="logoutForm">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>