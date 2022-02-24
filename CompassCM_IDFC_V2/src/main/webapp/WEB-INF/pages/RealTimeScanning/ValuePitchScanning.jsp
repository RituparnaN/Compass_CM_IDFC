<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@page import="com.quantumdataengines.app.compass.model.ValuePitchWebServiceResult"%>
<%@page import="com.quantumdataengines.app.compass.model.ValuePitchResult"%>
<%@ include file="../tags/tags.jsp"%>
<% 
List<ValuePitchResult> valuePitchResultsList = (ArrayList<ValuePitchResult>)request.getAttribute("valuePitchResultsList");
String status = (String)request.getAttribute("status");
String numResults = (String)request.getAttribute("numResults");
String searchName = (String)request.getAttribute("searchName");

%>
<script type="text/javascript">
	var id;
	$(document).ready(function() {
		id = '${UNQID}';
		compassTopFrame.init(id, 'valuePitchListDetailsTable'+id, 'dd/mm/yy');
		
		var tableClass = 'valuePitchListDetailsTable';
		compassDatatable.construct(tableClass, "valuePitchListDetailsTable", true);		
		
	});

	function fetchLinkDetails(elm, linkId){
		window.open(linkId, "Link Details", 'height=600px,width=1000px');
	}
	
</script>
<style type="text/css">
	.listCodeLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_listDetails" >
			<div class="card-header panelSlidingListDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Match Result For <%= searchName %></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm" style="overflow: auto;">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table valuePitchListDetailsTable${UNQID} searchGenericMaster table-striped table-bordered" style="margin-bottom: 0px; text-align: left; ">
					<thead>
					<tr style=" font-weight: bold;">
						<td width="10%" class="info">Name</td>
						<td width="10%" class="info">Score</td>
						<td width="10%" class="info">Address</td>
						<td width="10%" class="info">Verify Code</td>
						<td width="10%" class="info">Case Category</td>
						<td width="10%" class="info">Case Type</td>
						<td width="10%" class="info">Description</td>
						<td width="30%" class="info">Link</td>
					</tr>
					</thead>
					<tbody>
						<% for(int i=0;i < valuePitchResultsList.size();i++){
							ValuePitchResult valuePitchResult = valuePitchResultsList.get(i);
						%>
						<tr>
							<td><%= valuePitchResult.getName()%></td>
							<td><%= valuePitchResult.getScore()%></td>
							<td><%= valuePitchResult.getAddress()%></td>
							<td><%= valuePitchResult.getVerifycode()%></td>
							<td><%= valuePitchResult.getCase_category()%></td>
							<td><%= valuePitchResult.getCase_type()%></td>
							<td><%= valuePitchResult.getCase_type_description()%></td>
							<td class = "listCodeLink" onclick="fetchLinkDetails(this, '<%= valuePitchResult.getLink()%>')"><%= valuePitchResult.getLink()%></td>
						</tr>
 						<% } %>
					</tbody>
					</table>
			</form>
			</div>
		</div>
	</div>
</div>