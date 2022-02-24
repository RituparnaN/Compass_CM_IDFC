<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	String cifNo = (String) request.getAttribute("CIF");
	String accountNo = (String) request.getAttribute("AccountNo");
	String caseNo = (String) request.getAttribute("caseNo");
	String canEdit = (String) request.getAttribute("canEdit");
%>
<html>
	<head>
	</head>
	<body>
		<iframe src="<%=contextPath%>/cpumaker/addAccountNo?CIF=<%=cifNo%>&AccountNo=<%=accountNo%>&CaseNo=<%=caseNo%>&canEdit=<%=canEdit%>" height="100%" width="100%" frameBorder="0">Browser not compatible.</iframe>
	</body>
</html>