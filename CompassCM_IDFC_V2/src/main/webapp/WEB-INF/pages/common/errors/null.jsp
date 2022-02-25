<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>CompassCM | Null Value</title>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
			<div class="collapse navbar-collapse">
				<div class="navbar-header">
					<img style="padding-top: 10px;" class="compasslogoimg"
						alt="CompassCM Logo"
						src="${pageContext.request.contextPath}/includes/images/qde/CompassCM-Logo-Full.png"
						height="45px" width="250px;" />
				</div>
			</div>
	</nav>
	<div class="card-body">
		<div class="errorDiv"
			style="margin-top: 140px; font-family: Segoe UI Light; text-align: center;">
			<div class="error" style="font-size: 50px"><font style="color:red">${pageContext.errorData.statusCode}</font></div>
			<div class="errorDesc" style="font-size: 20px">Null Pointer Exception has occurred. Kindly please contact the IT Administrator.</div>
			<div class="errorDesc" style="font-size: 18px"><a href="${pageContext.request.contextPath}/index">Try again</a></div>
		</div>
	</div>
</body>
</html>
