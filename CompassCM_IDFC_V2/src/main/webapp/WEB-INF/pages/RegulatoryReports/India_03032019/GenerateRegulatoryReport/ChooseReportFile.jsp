<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.List"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<String> listReportFile = (List<String>) request.getAttribute("ReportFileList");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Choose File for Reporting</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script> 
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css"> --%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Choose File for Reporting</title>
<jsp:include page="../../../tags/staticFiles.jsp"/>

<script type="text/javascript">
 $(document).ready(function(){
		$("input[type='radio']").click(function(){
			if($(this).is(':checked')){
				//var elmVal = $(this).find("td").children().attr("radioId");
				var elmVal = $(this).val();
				//alert($(this).find("td").children().attr("radioId"));
				window.opener.$("#reportFileName").val(elmVal);
				window.close();
			}
		});
	});

	/* function selectFile(){
		var radioBtnVal = $("input[type='radio']:checked").val();
		window.opener.document.getElementById('reportFileName').value = radioBtnVal;
		window.close();
	}  */
</script>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_filenameList" style="margin: 10px 10px;">
		<div class="card-header">
			<h6 class="card-title">Choose File for Reporting</h6>
		</div>
		<table class="table table-bordered table-striped fileNamesTable${UNQID}" >
			<tr class="info">
				<td width="10%">&nbsp;</td>
				<td width="45%" style="font-weight: bold;">Filename</td>
				<td width="45%" style="font-weight: bold;">Uploaded Datetime</td>
			</tr>
			<c:forEach var="record" items="${ReportFileList}">
				<tr>
					<td style="text-align: center;">
						<input type="radio" name="fileNameRadioOption" value="${record['FILENAME']}"><!-- radioId=${record['FILENAME']}  -->
					</td>
					<td width="45%">${record['FILENAME']}</td>
					<td width="45%">${record['UPLOADTIMESTMP']}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</div>
</body>
</html>

<%-- <tr>
				<td>${ReportFileList}</td>
			</tr>
			<tr>
				<td>
					<input type="radio" name="fileName" id="<%=listReportFile.get(i)%>" value="<%=listReportFile.get(i)%>" />
				</td>
				<td>
					<label for="<%=listReportFile.get(i)%>"><%=listReportFile.get(i)%></label>
				</td>
				<td>
					<label for="<%=listReportFile.get(i)%>"><%=listReportFile.get(i)%></label>
				</td>
			</tr>
			<% } %> --%>
<%-- <div class="section">
	<div class="mainHeader">Choose File</div>
	<%
		for(int i = 0; i <= listReportFile.size()-1; i++){
	%>
	<input type="radio" name="fileName" id="<%=listReportFile.get(i)%>" value="<%=listReportFile.get(i)%>" />
	<label for="<%=listReportFile.get(i)%>"><%=listReportFile.get(i)%></label>
	<br/>
	<% } %>
</div> --%>

