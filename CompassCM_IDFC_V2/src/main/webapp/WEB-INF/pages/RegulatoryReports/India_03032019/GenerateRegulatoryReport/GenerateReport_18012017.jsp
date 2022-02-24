<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.util.HashMap" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String message = request.getAttribute("message") == null ? "" : request.getAttribute("message").toString();
Date sysDate = new Date();
SimpleDateFormat smdateformat = new SimpleDateFormat("yyyy");
String currentYear = "";
try{
currentYear = smdateformat.format(sysDate);
} catch(Exception e) {
e.printStackTrace();
}%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Generate Regulatory Report</title>
  <style type="text/css">
	#reportFileName{
		background-image:url("<%=contextPath%>/includes/images/search.jpeg");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var message = "<%out.print(message);%>";
		 if(message != ""){
			 alert(message);
		 }
		$( "#batchDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		$("#reportFileName").click(function(){
			var reportingMonth = $("#reportingMonth").val();
			var reportingYear = $("#reportingYear").val();
			var reportType = $("#reportType").val();
			if(reportingYear != ""){
				window.open("<%=contextPath%>/common/chooseReportFile?reportingMonth="+reportingMonth+"&reportingYear="+reportingYear+"&reportType="+reportType,"","width:400px,height:500px");
			}else{
				alert("Enter Reporting Year");
			}
		});
		$("#BatchType").change(function(){
			if($(this).val() == "N"){
				$("#OriginalBatchID").val("");
				$("#ReasonOfRevision").val("");
				$("#OriginalBatchID").attr("readonly",true);
				$("#ReasonOfRevision").attr("readonly",true);
			}else{
				$("#OriginalBatchID").attr("readonly",false);
				$("#ReasonOfRevision").attr("readonly",false);
			}
		});

		$("#generateXML").click(function(){
			var patt = new RegExp("[0-9]*");
			var noOfLines = $("#noOfLines").val();
			var res = noOfLines.match(patt);
			if(noOfLines > 0 && res == noOfLines){
				$("#reportForm").attr("action", "<%=contextPath%>/common/generateReportXML");
				$("#reportForm").submit();
			}else{
				alert("Record count is invalid");
			}
		});

		$("#generateReportData").click(function(){
			$("#reportForm").attr("action", "<%=contextPath%>/common/generateRegReportData");
			$("#reportForm").submit();
		});
	});
</script>
<script type="text/javascript">

</script>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/includes/styles/strStyle.css">
</head>
<body>
<form method="POST" action="javascript:void()" id="reportForm">
<div class="section">
	<div class="mainHeader">Generate Regulatory Data/Xml Report</div>
	<div class="normalTextField left">
		<label>Reporting Month</label>
		<select name="reportingMonth" id="reportingMonth">
			<option value="01">January</option>
			<option value="02">February</option>
			<option value="03">March</option>
			<option value="04">April</option>
			<option value="05">May</option>
			<option value="06">June</option>
			<option value="07">July</option>
			<option value="08">August</option>
			<option value="09">September</option>
			<option value="10">October</option>
			<option value="11">November</option>
			<option value="12">December</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>Reporting Year</label>
		<input type="text" name="reportingYear" id="reportingYear" value= "<%=currentYear%>"/>
	</div>
	<div class="normalTextField left">
		<label>Report Type</label>
		<select name="reportType" id="reportType">
			<option value="CTR">CTR</option>
			<option value="NTR">NTR</option>
			<option value="CCR">CCR</option>
			<option value="CBWT">CBWT</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>File Name</label>
		<input type="text" readonly name="reportFileName" id="reportFileName"/>
		
	</div>
	<div class="normalTextField left">
		<label>Batch Type</label>
		<select name="BatchType" id="BatchType">
			<option value="N">N - New Report</option>
			<option value="R">R - Replacement Report</option>
			<option value="D">D - Deletion Report</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>Original Batch ID</label>
		<input type="text" name="OriginalBatchID" id="OriginalBatchID" readonly/>
	</div>
	<div class="normalTextField">
		<label>Reason of Revision</label>
		<input type="text" name="ReasonOfRevision" id="ReasonOfRevision" readonly/>
	</div>
	<div class="normalTextField">
		<label>Record Count in a XML</label><br/>
		<input type="text" name="noOfLines" id="noOfLines" value="1000" style="width:47%"/>
	</div>
	<div class="mainButtons">
		<input type="button" value="Generate XML" id="generateXML"/>
		<input type="button" value="Generate Report Data" id="generateReportData"/>
	</div>
</div>
</form>
</body>
</html>