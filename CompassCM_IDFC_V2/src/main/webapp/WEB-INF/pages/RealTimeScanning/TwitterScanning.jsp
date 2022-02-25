<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@page import="twitter4j.User"%>

<%@ include file="../tags/tags.jsp"%>
<% 
List<User> twitterResultsList = (ArrayList<User>)request.getAttribute("twitterResultsList");
String status = (String)request.getAttribute("status");
String numResults = (String)request.getAttribute("numResults");
String searchName = (String)request.getAttribute("searchName");
String contextPath = request.getContextPath()==null?"":request.getContextPath();

%>
<script type="text/javascript">
	var id;
	$(document).ready(function() {
		id = '${UNQID}';
		compassTopFrame.init(id, 'twitterListDetailsTable'+id, 'dd/mm/yy');
		
		var tableClass = 'twitterListDetailsTable';
		compassDatatable.construct(tableClass, "twitterListDetailsTable", true);		
		
	});

	function fetchLinkDetails(elm, linkId){
		window.open(linkId, "Link Details", 'height=600px,width=1000px');
	}

	function fetchUserTwittsResult(elm, userName){
		window.open('<%=contextPath%>/common/getUserTwittsResult?userName='+userName,'TweetResultDetails','width=1400,height=800,left=10,top=10,toolbar=yes,resizable=yes, scrollbars=yes,menubar=yes');
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
				<table class="table twitterListDetailsTable${UNQID} searchGenericMaster table-striped table-bordered" style="margin-bottom: 0px; text-align: left; ">
					<thead>
					<tr style=" font-weight: bold;">
						<td width="10%" class="info">Id</td>
						<td width="10%" class="info">Name</td>
						<td width="10%" class="info">ScreenName</td>
						<td width="10%" class="info">ProfileImpage</td>
						<td width="10%" class="info">TimeZone</td>
						<td width="10%" class="info">WithheldInCountries</td>
						<td width="10%" class="info">Location</td>
						<td width="30%" class="info">OriginalProfileImpage</td>
					</tr>
					</thead>
					<tbody>
						<% for(int i=0;i < twitterResultsList.size();i++){
							User user = twitterResultsList.get(i);
						%>
						<tr>
							<td><%= user.getId()%></td>
							<td><%= user.getName()%></td>
							<td class = "listCodeLink" onclick="fetchUserTwittsResult(this, '<%= user.getScreenName()%>')"><%= user.getScreenName()%></td>
							<!-- <td><%= user.getScreenName()%></td> -->
							<td class = "listCodeLink" onclick="fetchLinkDetails(this, '<%= user.getBiggerProfileImageURL()%>')"><%= user.getBiggerProfileImageURL()%></td>
							<td><%= user.getTimeZone()%></td>
							<td><%= user.getWithheldInCountries()%></td>
							<td><%= user.getLocation()%></td>
							<td class = "listCodeLink" onclick="fetchLinkDetails(this, '<%= user.getOriginalProfileImageURL()%>')"><%= user.getOriginalProfileImageURL()%></td>
						</tr>
 						<% } %>
					</tbody>
					</table>
			</form>
			</div>
		</div>
	</div>
</div>