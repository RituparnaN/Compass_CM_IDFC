<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String reportID = request.getAttribute("reportID") != null ? (String) request.getAttribute("reportID") : "";
String reportName = request.getAttribute("reportName") != null ? (String) request.getAttribute("reportName") : "";
String message = request.getAttribute("message") != null ? (String) request.getAttribute("message") : "";

String isBenchmarkScheduled = request.getAttribute("isBenchmarkScheduled") != null ? (String) request.getAttribute("isBenchmarkScheduled") : "";
String strScheduleFrequency = request.getAttribute("ScheduleFrequency") != null ? (String) request.getAttribute("ScheduleFrequency") : "";
String strScheduleDates = request.getAttribute("ScheduleDates") != null ? (String) request.getAttribute("ScheduleDates") : "";
Map<String, String> benchmarkScheduleDetails = (Map<String, String>) request.getAttribute("benchmarkScheduleDetails");

%>
<style type="text/css">
	#date0, #date1, #date2, #date3{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){

		var message = '<%=message%>';
		if(message != ""){
			alert(message);
			window.close();
			window.opener.location.reload();
		}
		
		$("#date0, #date1, #date2, #date3, #date4").datepicker({
			 dateFormat : "mm/dd/yy"
		 });
		
		if($("#isSchedule1").is(':checked')){
			$("#schedulesSection").fadeIn('slow');
		}else{
			$("#schedulesSection").fadeOut('slow');
		}

		$("#isSchedule1").click(function(){
			if($("#isSchedule1").is(':checked')){
				$("#schedulesSection").fadeIn('slow');
			}else{
				$("#schedulesSection").fadeOut('slow');
			}
		});

		var frequencyTagValue = $("#reportFrequency").val();
		if(frequencyTagValue == "NONE"){
			$("#genTag").html("Generation Dates (<em>in comma(,) separated)</em>");
		}else{
			$("#genTag").html("Generation Start Date ");
		}
		
		
		$("#saveScheduledReport").click(function(){
			var action = "${pageContext.request.contextPath}/admin/saveScheduledBenchmark";
			var formObj = $("#ScheduledReportForm");
			var formData = $(formObj).serialize();
			$.ajax({
				url: action,
				cache: false,
				type: "POST",
				data: formData,
				success: function(res){
					alert(res);
					$("#compassSearchModuleModal").modal("hide");
					$("#searchScheduledReports").click();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#updateScheduledReport").click(function(){
			var action = "${pageContext.request.contextPath}/admin/saveScheduledBenchmark";
			var formObj = $("#ScheduledReportForm");
			var formData = $(formObj).serialize();
			$.ajax({
				url: action,
				cache: false,
				type: "POST",
				data: formData,
				success: function(res){
					alert(res);
					$("#compassSearchModuleModal").modal("hide");
					$("#searchScheduledReports").click();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#deleteScheduledReport").click(function(){
			var action = "${pageContext.request.contextPath}/admin/deleteScheduledBenchmark";
			var formObj = $("#ScheduledReportForm");
			var formData = $(formObj).serialize();
			$.ajax({
				url: action,
				cache: false,
				type: "POST",
				data: formData,
				success: function(res){
					alert(res);
					$("#compassSearchModuleModal").modal("hide");
					$("#searchScheduledReports").click();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	});

	function changeGenTag(val){
		if(val == "NONE"){
			$("#genTag").html("Generation Dates <em>(in comma(,) separated)</em>");
		}else{
			$("#genTag").html("Generation Start Date ");
		}
	}
</script>
<%
	if(benchmarkScheduleDetails != null){
%>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_scheduleReport">
			<div class="panelSearchForm">
				<form action="javascript:void(0)" id="ScheduledReportForm" method="POST">
				<input type="hidden" name="userID" value="<%=userID%>"/>
				<input type="hidden" name="reportID" value="<%=reportID%>"/>
				<input type="hidden" name="reportName" value="<%=reportName%>"/>
				<table class="table table-striped searchResultGenericTable">
				<%
					int noOfParams = benchmarkScheduleDetails.size();
					Iterator<String> keyItr = benchmarkScheduleDetails.keySet().iterator();
					int noOfRow = (noOfParams / 2) + (noOfParams % 2);
					int rowIndex = 0;
					while(keyItr.hasNext()){
						String strKey = keyItr.next();
						String strValue = benchmarkScheduleDetails.get(strKey);
						if(rowIndex % 2 == 0){ %>
							<tr>
								<td width="15%"><%= (strKey.contains("Date")?strKey:strKey) %>
								</td>
								<td width="30%">
									<input type="text" class="form-control input-sm" name="<%= strKey %>" value="<%=strValue %>" id="<% if(strKey.contains("Date")) {%>date<%=rowIndex%><%}%>"/>
								</td>
								<td width="10%" <% if((rowIndex == noOfParams-1) && noOfParams % 5 == 1){ %> colspan="3"
									<% } %>>&nbsp;</td>
								<% }else{ %>
									<td  width="15%">
										<%= (strKey.contains("Date")?strKey:strKey) %> 
									</td>
									<td width="30%">
										<input type="text" class="form-control input-sm" name="<%= strKey %>" value="<%=strValue %>" id="<% if(strKey.contains("Date")) {%>date<%=rowIndex%><%}%>"/>
									</td>
							</tr>
										<% }
								if((rowIndex == noOfParams-1) && noOfParams % 2 == 1){
										%></tr><%
									}
									rowIndex++;
								}
							%>
							<tr>
								<td colspan="6"  style="background-color : #37BC61;"><em>
								<% if(isBenchmarkScheduled.equalsIgnoreCase("Y")){%>
								This benchmark is scheduled. Do you want to keep this schedule?
								<%}else{ %>
								This benchmark is not scheduled. Do you want to schedule?
								<%} %>
								<label class="checkbox-inline" for="isSchedule1">
								  <input type="checkbox" name="isSchedule" id="isSchedule1" value="YES"
								  <% if(isBenchmarkScheduled.equalsIgnoreCase("Y")){%>
								  checked
								  <% }%>
								  >YES
								</label>
								</em></td>
							</tr>
							<tr id="schedulesSection" style="display: none;">
								<td width="15%">
									 Report Frequency 
								</td>
								<td width="30%">
									<select class="form-control input-sm" name="reportFrequency" id="reportFrequency" onchange="changeGenTag(this.value)">
									  <option value="NONE">NONE</option>
									  <option value="DAILY"
									  <% if(strScheduleFrequency.equals("DAILY")) {%>
									  selected
									  <%} %>
									  >DAILY</option>
									  <option value="WEEKLY"
									  <% if(strScheduleFrequency.equals("WEEKLY")) {%>
									  selected
									  <%} %>
									  >WEEKLY</option>
									  <option value="FORTNIGHTLY"
									  <% if(strScheduleFrequency.equals("FORTNIGHTLY")) {%>
									  selected
									  <%} %>
									  >FORTNIGHTLY</option>
									  <option value="MONTHLY"
									  <% if(strScheduleFrequency.equals("MONTHLY")) {%>
									  selected
									  <%} %>
									  >MONTHLY</option>
									</select>
								</td>
								<td>&nbsp;</td>
								<td>
									<span id="genTag">Generation Dates <em>(comma(,) separated)</em></span>
								</td>
								<td>
									<textarea name="generationDates" class="form-control  input-sm" rows="3"><%=strScheduleDates.trim()%></textarea>
								</td>
							</tr>
							</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">				
				<% if(userID.equals("default")){ %>
				<button type="button" name="save"  id="saveScheduledReport" class="btn btn-success btn-sm">Save New</button>
				<%} else {%>
					<button type="button" name="save"  id="updateScheduledReport" class="btn btn-success btn-sm">Update</button>
					<button type="button" name="save"  id="deleteScheduledReport" class="btn btn-danger btn-sm">Delete</button>
				<%} %>
			</div>
			</div>
			</form>
		</div>
		</div>
<% }else{%>
	No Details Found
<% }%>
</div>
