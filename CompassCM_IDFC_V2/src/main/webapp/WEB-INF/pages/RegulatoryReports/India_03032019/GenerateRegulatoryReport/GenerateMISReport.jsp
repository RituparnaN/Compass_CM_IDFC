<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.util.HashMap" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
Date sysDate = new Date();
SimpleDateFormat smdateformat = new SimpleDateFormat("yyyy");
String currentYear = "";
try{
currentYear = smdateformat.format(sysDate);
} catch(Exception e) {
e.printStackTrace();
}

String message = request.getAttribute("message") == null ? "" : request.getAttribute("message").toString();
String reportingMonth = request.getAttribute("reportingMonth") == null ? "01" : request.getAttribute("reportingMonth").toString();
String reportingYear = request.getAttribute("reportingYear") == null ? currentYear : request.getAttribute("reportingYear").toString();
String reportType = request.getAttribute("reportType") == null ? "CTR" : request.getAttribute("reportType").toString();
String batchType = request.getAttribute("batchType") == null ? "N" : request.getAttribute("batchType").toString();

HashMap reportData  = request.getAttribute("reportData") == null ? new HashMap(): (HashMap)request.getAttribute("reportData");

String recordsCount = reportData.get("RECORDSCOUNT") == null ? "":reportData.get("RECORDSCOUNT").toString();
String originalBatchID = reportData.get("ORIGINALBATCHID") == null ? "0":reportData.get("ORIGINALBATCHID").toString();
String reasonOfRevision = reportData.get("REASONOFREVISION") == null ? "N":reportData.get("REASONOFREVISION").toString();
String reportedDate = reportData.get("REPORTEDDATE") == null ? "":reportData.get("REPORTEDDATE").toString();


String actionType = request.getAttribute("actionType") == null ? "viewData" : request.getAttribute("actionType").toString();

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View/Update Regulatory MIS Report</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
  <style type="text/css">
	#reportedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var message = "<%out.print(message);%>";
		var actionType = "<%= actionType %>";
		 if(actionType != "viewData" && message != ""){
			 alert(message);
		 }
		$( "#reportedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		 });
		$("#batchType").change(function(){
			if($(this).val() == "N"){
				$("#originalBatchID").val("");
				$("#reasonOfRevision").val("");
				$("#originalBatchID").attr("readonly",true);
				$("#reasonOfRevision").attr("readonly",true);
			}else{
				$("#originalBatchID").attr("readonly",false);
				$("#reasonOfRevision").attr("readonly",false);
			}
		});

		$("#updateData").click(function(){
			$("#actionType").attr("value", "updateData");
			var patt = new RegExp("[0-9]*");
			var recordsCount = $("#recordsCount").val();
			var res = recordsCount.match(patt);
			if(recordsCount > 0 && res == recordsCount){
				$("#reportForm").attr("action", "<%=contextPath%>/regMISReportData");
				$("#reportForm").submit();
			}else{
				alert("Record count is invalid");
			}
		});
        
		$("#viewData").click(function(){
			$("#actionType").attr("value", "viewData");
			$("#reportForm").attr("action", "<%=contextPath%>/regMISReportData");
			$("#reportForm").submit();
		});
	});

function openBulkUploadPrompt()
{
window.open('<%=contextPath%>/IndianRegulatoryReport/GenerateRegulatoryReport/uploadRegMISReportData.jsp','uploadAlertsRatingMapping','top=10,left=20,height=250,width=900,scrollbars=yes,resizable=yes');
}	

</script>
<script type="text/javascript">

</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<body>
<form method="POST" action="javascript:void()" id="reportForm">
<input type="hidden" name="actionType" id="actionType" value="<%=actionType%>" />
<div class="section">
	<fieldset>
	<fieldset>
	<div class="mainHeader">View/Update Regulatory MIS Report</div>
	<div class="normalTextField left">
		<label>Reporting Month</label>
		<select name="reportingMonth" id="reportingMonth">
			<option value="01" <% if(reportingMonth.equals("01")) {%> selected <%}%>>January</option>
			<option value="02" <% if(reportingMonth.equals("02")) {%> selected <%}%>>February</option>
			<option value="03" <% if(reportingMonth.equals("03")) {%> selected <%}%>>March</option>
			<option value="04" <% if(reportingMonth.equals("04")) {%> selected <%}%>>April</option>
			<option value="05" <% if(reportingMonth.equals("05")) {%> selected <%}%>>May</option>
			<option value="06" <% if(reportingMonth.equals("06")) {%> selected <%}%>>June</option>
			<option value="07" <% if(reportingMonth.equals("07")) {%> selected <%}%>>July</option>
			<option value="08" <% if(reportingMonth.equals("08")) {%> selected <%}%>>August</option>
			<option value="09" <% if(reportingMonth.equals("09")) {%> selected <%}%>>September</option>
			<option value="10" <% if(reportingMonth.equals("10")) {%> selected <%}%>>October</option>
			<option value="11" <% if(reportingMonth.equals("11")) {%> selected <%}%>>November</option>
			<option value="12" <% if(reportingMonth.equals("12")) {%> selected <%}%>>December</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>Reporting Year</label>
		<input type="text" name="reportingYear" id="reportingYear" value= "<%=reportingYear%>"/>
	</div>
	<div class="normalTextField left">
		<label>Report Type</label>
		<select name="reportType" id="reportType">
			<option value="CTR" <% if(reportType.equals("CTR")) {%> selected <%}%>>CTR</option>
			<option value="NTR" <% if(reportType.equals("NTR")) {%> selected <%}%>>NTR</option>
			<option value="CCR" <% if(reportType.equals("CCR")) {%> selected <%}%>>CCR</option>
			<option value="CBWT" <% if(reportType.equals("CBWT")) {%> selected <%}%>>CBWT</option>
		</select>
	</div>
	
	<div class="normalTextField right">
		<label>Batch Type</label>
		<select name="batchType" id="batchType">
			<option value="N" <% if(batchType.equals("N")) {%> selected <%}%>>N - New Report</option>
			<option value="R" <% if(batchType.equals("R")) {%> selected <%}%>>R - Replacement Report</option>
			<option value="D" <% if(batchType.equals("D")) {%> selected <%}%>>D - Deletion Report</option>
		</select>
	</div>

	<div class="mainButtons">
		<input type="button" value="Search" id="viewData" style="align:center"/>
	</div>
	</fieldset>
	</fieldset>
	<fieldset>
	<div class="normalTextField left">
		<label>Reported Date</label><b><font color="red"> (dd/mm/yyyy)</font></b><br/>
		<input type="text" name="reportedDate" id="reportedDate" value="<%=reportedDate%>"/>
	</div>
	<div class="normalTextField right">
		<label>Record Count</label><br/>
		<input type="text" name="recordsCount" id="recordsCount" value="<%=recordsCount%>"/>
	</div>
	<div class="normalTextField left">
		<label>Original Batch ID</label>
		<input type="text" name="originalBatchID" id="originalBatchID" value="<%=originalBatchID%>" readonly/>
	</div>
	<div class="normalTextField right">
		<label>Reason of Revision</label>
		<input type="text" name="reasonOfRevision" id="reasonOfRevision" value="<%=reasonOfRevision%>" readonly/>
	</div>
	
	<div class="mainButtons">
		<input type="button" value="Update Data" id="updateData"/>
		<input type="button" value="Upload Data" id="uploadData" onClick="openBulkUploadPrompt();"/>
	</div>
	</fieldset>
</div>
</form>
</body>
</html>