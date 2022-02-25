<%@ page language="java" import="java.util.*"%>
<%@page import="twitter4j.Status"%>

<%@ include file="../tags/staticFiles.jsp"%>
<%@ include file="../tags/tags.jsp"%>
<html>
<head>

<% 
List<Status> usersTwittsResultsList = (ArrayList<Status>)request.getAttribute("usersTwittsResultsList");
System.out.println("usersTwittsResultsList: "+usersTwittsResultsList.size());
String numResults = (String)request.getAttribute("numResults");
String userName = (String)request.getAttribute("userName");
String contextPath = request.getContextPath()==null?"":request.getContextPath();

%>
<script type="text/javascript">
	var id;
	$(document).ready(function() {
		id = '${UNQID}';
		compassTopFrame.init(id, 'twittsResultDetailsTable'+id, 'dd/mm/yy');
		
		var tableClass = 'twittsResultDetailsTable';
		compassDatatable.construct(tableClass, "twittsResultDetailsTable", true);		
		
	});

	function fetchLinkDetails(elm, linkId){
		window.open(linkId, "Link Details", 'height=600px,width=1000px');
	}

	function fetchUserTwittsResult(elm, userName){
		window.open('<%=contextPath%>/common/getUserTwittsResult?userName='+userName,'','width=550,height=635,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
	}
	
</script>
<style type="text/css">
	.listCodeLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
</head>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_listDetails" >
			<div class="card-header panelSlidingListDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Twitt Details For <%= userName %></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm" style="overflow: auto;">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table twittsResultDetailsTable${UNQID} searchGenericMaster table-striped table-bordered" style="margin-bottom: 0px; text-align: left; ">
					<thead>
					<tr style="font-weight: bold;">
						<!-- <td width="10%" class="info">Id</td>-->
						<td width="25%" class="info">CreatedAt</td>
						<td width="65%" class="info">Text</td>
						<!-- <td width="10%" class="info">InReplyToUserId</td> -->
						<td width="10%" class="info">InReplyToName</td>
						<!-- <td width="10%" class="info">SourceName</td>
						<td width="10%" class="info">Location</td>-->
					</tr>
					</thead>
					<tbody>
						<% for(int i=0;i < usersTwittsResultsList.size();i++){
							Status status = usersTwittsResultsList.get(i);
						%>
						<tr>
							<!-- <td><%= status.getId()%></td>-->
							<td><%= status.getCreatedAt()%></td>
							<td><%= status.getText()%></td>
							<!-- <td><%= status.getInReplyToUserId()%></td> -->
							<td><%= status.getInReplyToScreenName()%></td>
							<!-- <td><%= status.getSource()%></td> 
							<td><%= status.getPlace()%></td>-->
						</tr>
 						<% } %>
					</tbody>
					</table>
			</form>
			</div>
		</div>
	</div>
</div>

</html>