<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${moduleHeader}</title>
<jsp:include page="../tags/staticFiles.jsp"/>
<script type="text/javascript">
	$(document).ready(function(){
		var moduleCode = '${moduleCode}';
		var moduleValue = '${moduleValue}';
		var moduleHeader = '${moduleHeader}';
		var detailPage = '${detailPage}';
		var fullData = 'moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+moduleValue+'&detailPage='+detailPage;
		$("#moduleDetails").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
			url :  '${pageContext.request.contextPath}/common/getModuleDetails',
			cache : false,
			type : 'GET',
			data : fullData,
			success : function(response){
				$("#moduleDetails").html(response);
			},
			error : function(a,b,c){
				alert("Something went wrong"+a+b+c);
			}
		});
	});
	
	function searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage){
		var fullData = 'moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+moduleValue+'&detailPage='+detailPage;
		$("#moduleDetails").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
			url :  '${pageContext.request.contextPath}/common/getModuleDetails',
			cache : false,
			type : 'GET',
			data : fullData,
			success : function(response){
				$("#moduleDetails").html(response);
			},
			error : function(a,b,c){
				alert("Something went wrong"+a+b+c);
			}
		});
	}
</script>
</head>
<body>
<input type="hidden" id="childWindow" value="1"/>
<div id="moduleDetails" style="margin: 10px;"></div>
</body>
</html>