<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<%@ include file="../../../tags/tags.jsp"%>
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

 <%--  <style type="text/css">
	#reportFileName{
		background-image:url("<%=contextPath%>/includes/images/search.jpeg");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style> --%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var message = "<%out.print(message);%>";
		 if(message != ""){
			 alert(message);
		 }
		$( "#batchDate"+id ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		
		$(".searchFileName"+id).click(function(){
			var reportingMonth = $("#reportingMonth"+id).val();
			var reportingYear = $("#reportingYear"+id).val();
			var reportType = $("#reportType"+id).val();
			//alert(reportType);
			if(reportingYear != ""){
				window.open("<%=contextPath%>/common/chooseReportFile?reportingMonth="+reportingMonth+"&reportingYear="+reportingYear+"&reportType="+reportType,"","width:400px,height:500px");
			}else{
				alert("Enter Reporting Year");
			}
		});
		
		$("#BatchType"+id).change(function(){
			if($(this).val() == "N"){
				$("#OriginalBatchID"+id).val("");
				$("#ReasonOfRevision"+id).val("");
				$("#OriginalBatchID"+id).attr("readonly",true);
				$("#ReasonOfRevision"+id).attr("readonly",true);
			}else{
				$("#OriginalBatchID"+id).attr("readonly",false);
				$("#ReasonOfRevision"+id).attr("readonly",false);
			}
		});

		$("#generateXML"+id).click(function(){
			var patt = new RegExp("[0-9]*");
			var noOfLines = $("#noOfLines"+id).val();
			var res = noOfLines.match(patt);
			//alert(noOfLines);
			if(noOfLines > 0 && res == noOfLines){
				var formData = $("#reportForm"+id).serialize();
				//alert(formData);
				//document.write(formData);
				$.ajax({
					url : "<%=contextPath%>/common/generateReportXML",
					type : "POST",
					cache : false,
					data : formData,
					success : function(res){
						alert(res);
					}
				});
			}else{
				alert("Record count is invalid");
			}
		});

		$("#generateReportData"+id).click(function(){
			var formData = $("#reportForm"+id).serialize();
			$.ajax({
				url : "<%=contextPath%>/common/generateRegReportData",
				type : "POST",
				cache : false,
				data : formData,
				success : function(res){
					alert(res);
				}
			});
		});
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_regulatoryReportGenetation">
			<div class="card-header panelSlidingRegulatoryReportGenetation${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Generate Regulatory Data/Xml Report</h6>
			</div>
			<form method="POST" action="javascript:void()" id="reportForm${UNQID}" name="reportForm">
			<div class="panelSearchForm">
				<table class="table table-striped regulatoryReportGenetation${UNQID}"  style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="15%">
								Reporting Month
							</td>
							<td width="30%">
								<select name="reportingMonth" class="form-control input-sm" id="reportingMonth${UNQID}">
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
							</td>
							<td>&nbsp;</td>
							<td width="15%">
								Reporting Year
							</td>
							<td width="30%">
								<input type="text"  class="form-control input-sm" name="reportingYear" id="reportingYear${UNQID}" value= "<%=currentYear%>"/>
							</td>
						</tr>
						<tr>
							<td>Report Type</td>
							<td>
								<select name="reportType" class="form-control input-sm" id="reportType${UNQID}">
									<option value="CTR">CTR</option>
									<option value="NTR">NTR</option>
									<option value="CCR">CCR</option>
									<option value="CBWT">CBWT</option>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>File Name</td>
							<td>
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon-ela" name="reportFileName" id="reportFileName" readonly="readonly"/>
										<span class="input-group-addon searchFileName${UNQID}" id="basic-addon-ela" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
								</div>
							</td>
						</tr>
						<tr>
							<td>Batch Type</td>
							<td>
								<select name="BatchType" class="form-control input-sm" class="form-control input-sm" id="BatchType${UNQID}" >
									<option value="N">N - New Report</option>
									<option value="R">R - Replacement Report</option>
									<option value="D">D - Deletion Report</option>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>Original Batch ID</td>
							<td>
								<input type="text" class="form-control input-sm" name="OriginalBatchID" id="OriginalBatchID${UNQID}" readonly/>
							</td>
						</tr>
						<tr>
							<td>Reason of Revision</td>
							<td>
								<input type="text" class="form-control input-sm" name="ReasonOfRevision" id="ReasonOfRevision${UNQID}" readonly/>
							</td>
							<td>&nbsp;</td>
							<td>Record Count in a XML</td>
							<td>
								<input type="text" class="form-control input-sm" name="noOfLines" id="noOfLines${UNQID}" value="1000"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-warning btn-sm" value="Generate Report Data" id="generateReportData${UNQID}"/>
					<input type="button" class="btn btn-warning btn-sm" value="Generate XML" id="generateXML${UNQID}"/>
				</div>
			</div>
			</form>
		</div>
	</div>
</div>