<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%@ page import = "java.util.*, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %> 
<%
try{
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String message = request.getAttribute("message") == null ? "" : request.getAttribute("message").toString();
String IsSaved = request.getAttribute("IsSaved") == null ? "":(String) request.getAttribute("IsSaved");
/*System.out.println("msg is "+message);
System.out.println("saved "+IsSaved);*/ 
HttpSession l_CHttpSession = request.getSession(true);

String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
%>

<html>
<head><title>UploadTransactions</title>
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>

 <script type="text/javascript">
	$(document).ready(function(){
		 var message = "<%out.print(message);%>";
		 var isSaved = "<%out.print(IsSaved);%>";
		 var caseNo = '<%=caseNo%>';
		 if(isSaved == "No"){
			 alert(message);
			 window.opener.location.reload();
		 }else if(isSaved == "Yes"){
			 alert(message);
			 alert("Transaction has been added to the list");
			 window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRTRFReport?caseNo="+caseNo+"&canUpdated=Y&canExported=N");
			 window.close();
		 }else{
			 alert(message);
			 window.opener.location.reload();
		 }
	});
</script> 

</head>
<body>
<div class="content">
<div class="section" style="height:60px;">
<form action="<%=contextPath%>/common/uploadINDSTRTRFTransactionsFile?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
<div class="normalTextField left">
		<label>File Upload</label>
		<input type="file"  name="fileupload"  class="txt2"/>
		<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
	</div>
	<div class="normalTextField right" style="top:22px;">
		<input type="submit" name="uploadTransaction" value="Upload Transaction">
	</div>
</form>
</div>
</div>
</body>
</html>

<%}catch(Exception e){e.printStackTrace();}%>
