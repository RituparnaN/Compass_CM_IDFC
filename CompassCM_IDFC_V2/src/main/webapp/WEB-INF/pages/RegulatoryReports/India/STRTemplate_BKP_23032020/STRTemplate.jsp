<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<Map<String, String>> TEMPLATES = (List<Map<String, String>>) request.getAttribute("TEMPLATES");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript">
			function openTemplate(templateId){
				var strTemplateWindow = window.open('${pageContext.request.contextPath}/common/createSTRTemplate?templateid='+templateId,'STRTemplate','height=975, width=1200, resizable=Yes, scrollbars=Yes');
				strTemplateWindow.focus();
			}
			
			function openVariables(){
				var strVariableWindow = window.open('${pageContext.request.contextPath}/common/getSTRVariables','STRVariables','height=800, width=600, resizable=Yes, scrollbars=Yes');
				strVariableWindow.focus();
				strVariableWindow.moveTo(screen.width-600,0);
			}
		</script>
		<title>STR Template</title>
	</head>
	<body>
		<div class="container-fluid" style="padding-left: 0px;">
			<div class="row">
				<div class="col-xs-12">
					<div class="card card-info">
						<br/>
						<center>
							<button class="btn btn-primary btn-sm" onclick="openTemplate('')">Create New Template</button>
							&nbsp;
							&nbsp;
							<button class="btn btn-primary btn-sm" onclick="openVariables()">View STR Variables</button>
						</center>
						<br/>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12">
					<div class="card card-info">
					  <div class="card-header">STR Template</div>
					  <table class="table table-bordered table-striped">
					  	<thead>
					  		<tr>
					  			<th width="35%">Template Name</th>
					  			<th width="15%">Source of Alert</th>
					  			<th width="15%">Alert Indicator</th>
					  			<th width="10%">Priority Rating</th>
					  			<th width="5%">Status</th>
					  			<th width="10%">Updated By</th>
					  			<th width="10%">Updated On</th>
					  		</tr>
					  	</thead>
					  	<%
					  	if(TEMPLATES != null && TEMPLATES.size() > 0){
					  	%>
					  	<tbody>
					  		<% for(int i = 0; i < TEMPLATES.size(); i++){
					  			Map<String, String> templateDetails = TEMPLATES.get(i);
					  			String status = "DISABLED";
					  			if(templateDetails.get("STATUS") != null && templateDetails.get("STATUS").equals("E"))
					  				status = "ENABLED";
					  		%>
					  			<tr onclick="openTemplate('<%= templateDetails.get("TEMPLATEID")%>')">
					  				<td><a href="javascript:void(0)"><%= templateDetails.get("TEMPLATENAME") != null ? templateDetails.get("TEMPLATENAME") : "" %></a></td>
					  				<td><%= templateDetails.get("SOURCEOFALERT") != null ? templateDetails.get("SOURCEOFALERT") : "" %></td>
					  				<td><%= templateDetails.get("ALERTREDFLAGINDICATOR") != null ? templateDetails.get("ALERTREDFLAGINDICATOR") : "" %></td>
					  				<td><%= templateDetails.get("PRIORITYRATING") != null ? templateDetails.get("PRIORITYRATING") : "" %></td>
					  				<td><%= status %></td>
					  				<td><%= templateDetails.get("UPDATEDBY") != null ? templateDetails.get("UPDATEDBY") : "" %></td>
					  				<td><%= templateDetails.get("UPDATETIMESTAMP") != null ? templateDetails.get("UPDATETIMESTAMP") : "" %></td>
					  			</tr>
					  		<%} %>
					  	</tbody>
					  	<%}else{ %>
					  		<tr>
					  			<td colspan="7" style="text-align: center;"> No Template Created. </td>
					  		</tr>
					  	<%} %>
					  </table>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>