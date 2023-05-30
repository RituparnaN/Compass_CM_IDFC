<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code="app.login.NAME"/> | Login</title>
<jsp:include page="../tags/staticFiles.jsp" />
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#username").focus();
		$(".close").click(function() {
			$(".messages").fadeOut("slow");
		});
		$("#username, #password").keypress(function() {
			$(".messages").fadeOut("slow");
		});
	});
</script>
<style type="text/css">
body {
	width: 100%;
	height: auto !important;
}

.container {
	position: absolute;
	width: 70%;
	height: 100%;
	margin: 0px 15% 0 15%;
}

.info {
	text-align: justify;
	position: absolute;
	height: auto !important;
	min-height: 95% !important;
	float: left;
	background: #F5FBFF !important;
	box-shadow: 0 0 5px #99D6FF;
	-webkit-box-shadow: 0 0 5px #99D6FF;
	-moz-box-shadow: 0 0 5px #99D6FF;
}

body.ie6 .info, body.ie7 .info, body.ie8 .info {
	zoom: 1;
	filter: progid:DXImageTransform.Microsoft.DropShadow(OffX=0, OffY=0,
		Color= #99D6FF);
}

.compasslogo {
	width: 80%;
	text-align: center;
}

.compasslogoimg {
	margin: 20% 5% 5% 0%;
	width: 100%;
	height: 20% !important;
}

.productinfo {
	text-align: left;
	margin: 10% 5% 0% 5%;
	font-family: Segoe UI Semibold;
	font-size: 20px;
}

.productversion {
	font-size: 13px;
}

.footer {
	text-align: left;
	font-family: Segoe UI Semibold;
	margin: 0% 5% 10% 5%;
	font-size: 13px;
}

.login {
	float: right;
	height: 100% !important;
	background: transparent;
	padding: 10% 0 0 5%;
}

.alertSection {
	height: 20% !important;
}

.messages {
	width: 80%;
}
</style>
</head>
<body style="overflow-y: hidden; background-color: white;">
	<div class="container row">
		<div class="col-sm-5">
			<div class="compasslogo" style="margin: 45% 5% 5% 5%;">
				<img class="compasslogoimg" alt="Application Logo"
					src="includes/images/<spring:message code="app.login.IMG"/>">					
			</div>
			
			<%-- <div class="productinfo">
				Welcome to <spring:message code="app.login.NAME"/><br /><spring:message code="app.login.SYSTEMNAME"/>
				<div class="productversion">
					<spring:message code="app.login.VERSION"/>
				</div>
			</div> --%>
			<div class="compasslogo" style="margin-left: -35px; margin-top: 10px;">
					<img class="compasslogoimg" alt="Company Logo" style="width: 70%; height: 70%;  margin-bottom: 5px;"
						src="includes/images/<spring:message code="app.login.BUILDERIMG"/>">
				</div>
			<div class="productinfo productversion">
				<spring:message code="app.login.VERSION"/>
			</div>	
			<div class="footer">	
				<spring:message code="app.login.COPYRIGHTTEXT"/>
			</div>
		</div>
		<div class="col-sm-2" style="margin: 60px 0 0 0; text-align: center;">
			<img  alt="Separator" id="separatorImg" src="includes/images/separator.png" height="625px" width="0.5px;">
		</div>
		<div class="col-sm-5 login">
			<div class="alertSection">
				<c:if test="${not empty message or not empty error}">
					<div
						class='messages	<c:if test="${not empty message}">alert alert-success alert-dismissable	</c:if><c:if test="${not empty error}">	alert alert-danger alert-dismissable</c:if>'>
						<c:if test="${not empty message}">
							${message}
							<button type="button" class="close" style="color: #3C763D">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						</c:if>
						<c:if test="${not empty error}">
							${error}
							<button type="button" class="close" style="color: #A94442">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
						</c:if>
					</div>
				</c:if>
			</div>
			<div class="formContent">
						<!-- <label for="disclaimer" style="width: 80%"><font size="2">Disclaimer: Access to this site and network is restricted to person authorized by FCC department of Standard Chartered Bank India.Unauthorized access is prohibited and is wrongful under law.</font> </label>
						<br>
						<br> -->
			<form role="form" action="<c:url value="/loginAction"/>" method="post" onsubmit="return loginCheck()">
					<div class="form-group">

						<label for="username"><spring:message code="app.login.USERNAME"/></label> 
						<input type="text" class="form-control" style="width: 80%" id="username" name="username" placeholder="Enter User Name" autocomplete="off" onkeyup="this.value = this.value.toUpperCase();"/>
					</div>
					<div class="form-group">
						<label for="password"><spring:message code="app.login.PASSWORD"/></label> 
						<input type="password" class="form-control" style="width: 80%" id="password" name="password" placeholder="Enter Password" />
					</div>
					<c:choose>
						<c:when test="${f:length(requestScope.institutions) > 1}">
							<div class="form-group">
								<label for="domain"><spring:message code="app.login.DOMAIN"/></label> 
								<select class="form-control" style="width: 80%" id="domain" name="domain">
									<option value="">Select one</option>
									<c:forEach var="domain" items="${requestScope.institutions}">
										<option 
										<c:if test="${sessionScope.instituteName eq domain}">
										selected
										</c:if>
										value="${domain}">${domain}</option>
									</c:forEach>
								</select>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="domain" items="${requestScope.institutions}">
								<input type="hidden" name="domain" value="${domain}"/>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<button type="submit" style="float: right; margin-right: 20%"
						class="btn btn-primary">Login</button>
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
					<input type="hidden" name="auth_key" value="${auth_key}">
				</form>
			</div>
		</div>
	</div>
</body>
</html>