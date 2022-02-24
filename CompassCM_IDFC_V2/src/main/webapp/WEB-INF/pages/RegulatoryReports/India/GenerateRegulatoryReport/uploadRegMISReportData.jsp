<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    String contextPath = request.getContextPath()==null?"":request.getContextPath();
    String message = request.getParameter("message") == null ? "" : request.getParameter("message").toString();
    %>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<title>Upload RegReport Data</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		 var message = "<%out.print(message);%>";
		 if(message != ""){
			 alert(message);
			 window.close();
		 }
	});
</script>
<script type="text/javascript">
function checkForm(){
	var fileupload = $("#fileupload").val();
	if(fileupload.length > 0)
		return true;
	else{
		alert("Select RegReport Data Mapping file");
		return false;
	}
}
</script>
</head>
<body>
<div class="header">
			<table class="header-table">
				<tr>
					<td class="leftside">
						<div class="headerText">Upload RegReport Data</div>
					</td>
				</tr>
			</table>
</div>
<div class="section" style="height:160px;">
<form action="<%=contextPath%>/uploadOtherMapping" method="post" enctype="multipart/form-data" onsubmit="return checkForm()">
<div class="normalTextField">
		<label>File Upload</label>
		<input type="file"  name="fileupload"  id="fileupload" class="txt2"/>
</div>
<div class="mainButtons" style="top:15px;">
		<input type="submit" name="uploadRegReportData" value="Upload RegReport Data">
</div>
<input type="hidden" name="MAPPINGTYPE" value="REGREPORTMISDATA" />
</form>
</div>
</body>
</html>