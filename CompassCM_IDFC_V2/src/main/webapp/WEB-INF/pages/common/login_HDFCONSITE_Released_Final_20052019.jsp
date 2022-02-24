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
	margin: 30% 5% 5% 0%;
	width: 100%;
	height: 20% !important;
}

.productinfo {
	text-align: left;
	margin: 10% 5% 5% 5%;
	font-family: Segoe UI Semibold;
	font-size: 20px;
}

.productversion {
	font-size: 16px;
}

.footer {
	text-align: left;
	font-family: Segoe UI Semibold;
	margin: 2% 5% 5% 5%;
	font-size: 13px;
}

.login {
	float: right;
	height: 100% !important;
	background: transparent;
	padding: 8% 0 0 5%;
}

.alertSection {
	height: 10% !important;
}

.messages {
	width: 70%;
}

.bankLogo{
	height: 10%! important;
}
</style>
</head>
<body>
	<div class="container row">
		<div class="col-xs-5">
			<div class="compasslogo">
				<img class="compasslogoimg" alt="Application Logo"
					src="includes/images/<spring:message code="app.login.IMG"/>">					
			</div>
			<div class="productinfo">
				Welcome to <spring:message code="app.login.NAME"/><br /><spring:message code="app.login.SYSTEMNAME"/>
				<div class="productversion">
					<spring:message code="app.login.VERSION"/>
				</div>
			</div>
			<div class="compasslogo" style="margin-left: -20px; margin-top: 30px;">
					<img class="compasslogoimg" alt="Company Logo" style="width: 80%; height: 80%;"
						src="includes/images/<spring:message code="app.login.BUILDERIMG"/>">
				</div>
			<div class="footer">				
				<spring:message code="app.login.COPYRIGHTTEXT"/>
			</div>
		</div>
		<div class="col-xs-1">
			<span>
				<img alt="HDFC" src='${pageContext.request.contextPath}/includes/images/separator.png'
					width="2px" height="500px" style="margin-top: 100px;" />
			</span>
		</div>
		<div class="col-xs-6 login">
			<div class="bankLogo" style="margin-top: 30px;">
				<img class="hdfcBankLogo" alt="HDFC Bank Logo" style="width: 70%; height: 80%;"
						src="includes/images/HDFC_Bank_Logo.png">
			</div>
			<div class="alertSection" style="margin-top: 10px; margin-bottom: 5px;">
				<c:if test="${not empty message or not empty error}">
					<div
						class='messages
						<c:if test="${not empty message}">
							alert alert-success alert-dismissable
						</c:if>
						<c:if test="${not empty error}">
							alert alert-danger alert-dismissable
						</c:if>'>
						<c:if test="${not empty message}">
							${message}
						</c:if>
						<c:if test="${not empty error}">
							${error}
						</c:if>
						<button type="button" class="close">
							<span aria-hidden="true">&times;</span> <span class="sr-only">Close</span>
						</button>
					</div>
				</c:if>
			</div>
			<div class="formContent">
			<form role="form" action="<c:url value="/loginAction"/>" method="post" onsubmit="return loginCheck()">
					<div class="form-group">
						<%-- <label for="username"><spring:message code="app.login.USERNAME"/></label> --%> 
						<!-- <input type="text" class="form-control" style="width: 70%" id="username" name="username" placeholder="Enter User Name" autocomplete="off"/> -->
						<input type="text" class="form-control" style="width: 70%" id="username" name="username" placeholder="Enter User Name" autocomplete="off" onkeyup="this.value = this.value.toUpperCase();"/>
					</div>
					<div class="form-group">
						<%-- <label for="password"><spring:message code="app.login.PASSWORD"/></label> --%> 
						<input type="password" class="form-control" style="width: 70%" id="password" name="password" placeholder="Enter Password" />
					</div>
					<c:choose>
						<c:when test="${f:length(requestScope.institutions) > 1}">
							<div class="form-group">
								<label for="domain"><spring:message code="app.login.DOMAIN"/></label> 
								<select class="form-control" style="width: 70%" id="domain" name="domain">
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
					<button type="submit" style="float: right; margin-right: 30%;"
						class="btn btn-primary">Login</button>
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
					<input type="hidden" name="auth_key" value="${auth_key}">
				</form>
			</div>
			<div>
				<br>
				<label for="disclaimer" style="width: 70%; margin-top: 40px; font-size: small;">
					Unauthorised use of the HDFC Bank applications is prohibited.
				</label>
				<br>
			</div>	
		</div>
	</div>
</body>
</html>