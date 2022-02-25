<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String search = (String) request.getAttribute("SEARCH");
	List<Map<String, String>> formStatus = (List<Map<String, String>>) request.getAttribute("FORMSTATUS");
	String fromDate = request.getAttribute("FROMDATE") != null ? (String) request.getAttribute("FROMDATE") : "";
	String toDate = request.getAttribute("TODATE") != null ? (String) request.getAttribute("TODATE") : "";
	String status = request.getAttribute("STATUS") != null ? (String) request.getAttribute("STATUS") : "";
%>
<%
	if("1".equals(search)){
%>
<div class="row">
	<div class="col-lg-12">
		<div class="card card-primary">
			<div class="card-header">
					Forms Status
				<span class="pull-right">
				<%
					if(formStatus != null && formStatus.size() > 0){
				%>
					Search: <input type="text" class="input-ovr" id="searchAOF">
				<%} %>
				</span>
			</div>
<%
		if(formStatus != null && formStatus.size() > 0){
%>
	<table class="table table-bordered table-stripped" id="formStatusTable">
		<thead>
			<tr>
				<th>Case No</th>
				<th>CIF No</th>
				<th>CIF Type</th>
				<th>Account No</th>
				<th>Update time</th>
				<th>Status</th>
				<th>Open</th>
			</tr>
		</thead>
		<tbody>
			<%
			for(int i = 0; i < formStatus.size() ; i++){
				Map<String, String> map = formStatus.get(i);
				%>
				<tr>
					<td><%=map.get("CASE_NO") != null ? map.get("CASE_NO") : ""%></td>
					<td><%=map.get("CIF_NO") != null ? map.get("CIF_NO") : ""%></td>
					<td><%=map.get("CIF_TYPE_NAME") != null ? map.get("CIF_TYPE_NAME") : ""%></td>
					<td><%=map.get("ACCOUNT_NO") != null ? map.get("ACCOUNT_NO") : ""%></td>
					<td><%=map.get("DATA_UPDATE_TIMESTAMP") != null ? map.get("DATA_UPDATE_TIMESTAMP") : ""%></td>
					<td><%=map.get("STATUS")%></td>
					<td style="color: blue;cursor: pointer;" onclick="navigate('Account Opening Form','accountOpeningForm','cpuMaker/accountOpeningForm?caseNo=<%=map.get("CASE_NO")%>','1')">Open</td>
				</tr>
				<%
			}
			%>
		</tbody>
	</table>
<%
		}else{
		%>
		<br/><br/><center>No record found</center><br/>
		<%	
		}
%>
		</div>
	</div>
</div>
<%
	} 
%>