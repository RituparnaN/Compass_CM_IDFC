<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<c:set var="group" value="${groupCode}"></c:set>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>STR_TRF</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">

<script type="text/javascript">
	$(document).ready(function(){
		/* $( "#batchDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		$("input[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		 });
		$("textarea[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		}); */
	});
</script>

</head>
<body>

	<div class="content">
		<jsp:include page="header.jsp" />
		</div>
		<br/>
		<br/>
		<jsp:include page="annexure/accountDetails/accountDetailsMain.jsp"/>
		<br/>
		<jsp:include page="annexure/individualDetails/individualDetailsMain.jsp"/>
		<br/>
		<jsp:include page="annexure/legalPersonEntityDetails/legalPersonEntityDetailsMain.jsp"/>
		<br/><br/>
		<jsp:include page="instruction.jsp"/>
		<%-- <div class="mainButtons">
		<input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
		<input type="button" class="diffButton" value="Export XML" <%if(canExported.equals("N")){%> disabled <%}%> onclick="exportXML('<%= caseNo%>')"/>
		<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/>
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div> --%>
		
	</div>

</body>
</html>
