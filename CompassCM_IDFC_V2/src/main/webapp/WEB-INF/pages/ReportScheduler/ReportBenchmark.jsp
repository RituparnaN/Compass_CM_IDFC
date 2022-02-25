<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
String reportName = request.getAttribute("reportName") != null ? (String) request.getAttribute("reportName") : "";
String reportID = request.getAttribute("reportID") != null ? (String) request.getAttribute("reportID") : "";
Map<String,Object> mainMap = (Map<String,Object>) request.getAttribute("mainMap");
String[] arrAlertData = (String[]) mainMap.get("ReportBenchmarkHeader");
ArrayList<HashMap<String, String>> benchmarkDetails = (ArrayList<HashMap<String, String>>) mainMap.get("ReportBenchMarkList");;
int benchmarkSize = benchmarkDetails.size();
%>
<script type="text/javascript">
	function viewBenchmarkDetails(userID, reportID, reportName) {
		$("#compassSearchModuleModal").modal("show");
		$("#compassSearchModuleModal-title").html("Schedule Report");
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/scheduleReport?userID="+userID+"&reportID="+reportID+"&reportName="+reportName,
			type : "GET",
			cache : false,
			success : function(res){
				$("#compassSearchModuleModal-body").html(res);
			}
		});
	}
</script>
<table class="table table-bordered table-striped searchResultGenericTable" style="margin-bottom: 0px;">
	<%
		if (benchmarkSize < 1) {
	%>
	<tr>
		<th colspan="<%=arrAlertData.length%>">No Record Found</th>
	</tr>
	<%
		} else {
	%>
	<thead>
		<tr>
			<% for (int i = 0; i < arrAlertData.length; i++) { %>
			<th><%=arrAlertData[i]%></th>
			<% } %>
			<th>&nbsp;</th>
		</tr>
	</thead>
	<tbody>
	<%
		for (int i = 0; i < benchmarkSize; i++) {
				Map<String, String> innerMap = benchmarkDetails.get(i);
				String userID = innerMap.get("USERID");
	%>
	<tr>
		<% for (int j = 0; j < arrAlertData.length; j++) {	%>
			<td><%=innerMap.get(arrAlertData[j])%></td>
		<% } %>
		<td><a href="javascript:void(0)" onclick="viewBenchmarkDetails('<%=userID%>','<%=reportID%>','<%=reportName%>')">Open</a> </td>
	</tr>
	<%
		}
	%>
	</tbody>
	<%
		}
	%>
</table>