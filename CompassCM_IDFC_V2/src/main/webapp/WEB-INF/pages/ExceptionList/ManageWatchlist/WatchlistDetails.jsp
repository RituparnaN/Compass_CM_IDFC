<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Watchlist Details</title>
<jsp:include page="../../tags/staticFiles.jsp"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var riskRating = "${DATAMAP['RISKRATING']}";
		$("#riskRating").val(riskRating);
		
		var tableClass = 'watchListRecordDetailsTable';
		compassDatatable.construct(tableClass, "ManageWatchList", false);
		compassDatatable.enableCheckBoxSelection();
		
		$("#searchCustomer").click(function(){
			var listCode = '${listCode}';
			$("#compassGenericModal").modal("show");
			$.ajax({
				url: "${pageContext.request.contextPath}/common/selectCustomerToAdd?listCode="+listCode+"&searchButton=searchCustomer",
				cache: false,
				type: "POST",
				success: function(res){
					$("#compassGenericModal-title").html("Add Customer To Watchlist");
					$("#compassGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#addNonCustomer").click(function(){
			var listCode = '${listCode}';
			$("#compassGenericModal").modal("show");
			$.ajax({
				url: "${pageContext.request.contextPath}/common/enterNonCustomerDetailsToWatchlist?listCode="+listCode,
				cache: false,
				type: "POST",
				success: function(res){
					$("#compassGenericModal-title").html("Add Non-Customer To Watchlist");
					$("#compassGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
			
		});
		
		$("#deleteRecord").click(function(){
			var table = $(".watchListRecordDetailsTable").children("tbody");
			var unqIdToDelete = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var unqId = $(this).children("td:nth-child(2)").html();
				if($(checkbox).prop("checked")){
					unqIdToDelete = unqIdToDelete + unqId+",";
					selectedCount++;
				}
			});
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/deleteWatchlistRecord",
						cache: false,
						type: "POST",
						data: "unqIdToDelete="+unqIdToDelete,
						success: function(res) {
							alert(res);
							window.location.reload();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Select atleast one record");
		});
	});
	
</script>
<style type="text/css">
	.panel_watchlistDetails, 
	.panel_watchlistRecords{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_watchlistDetails">
			<div class="card-header panelSlidingManageWatchlist${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Watchlist Details</h6>
			</div>
			<div class="panelWatchlistDetailsForm">
			<form action="javascript:void(0)" method="POST" id="watchlistDetailsForm${UNQID}">
				<table class="table table-striped watchlistDetailsTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">List Code</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${DATAMAP['LISTCODE']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${DATAMAP['LISTNAME']}"/></td>
					</tr>
					<tr>	
						<td width="15%">Description</td>
						<td width="30%"><textarea class="form-control input-sm">${DATAMAP['DESCRIPTION']}</textarea></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Risk Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="riskRating">
								<option value="1">Low</option>
								<option value="2">Medium</option>
								<option value="3">High</option>
							</select> 
						</td>
						
					</tr>
					<tr>
						<td width="15%">Updated By</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${DATAMAP['UPDATEDBY']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Updated On</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${DATAMAP['UPDATETIME']}"/></td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-right">
						<button type="button" id="closeWatchlist${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<div class="card card-primary panel_watchlistRecords">
		<div class="card-header">
			<h6 class="card-title">Watchlist Records</h6>
		</div>
		<table class="table table-bordered table-striped watchListRecordDetailsTable" >
			<thead>
				<tr>
					<th class="info no-sort" style="text-align: center;">
						<input type="checkbox" class="checkbox-check-all" compassTable="deleteWatchListDetailsRecords${UNQID}" id="deleteWatchListDetailsRecords${UNQID}" />
					</th>
					<th class="info">Unique ID</th>
					<th class="info">Customer ID</th>
					<th class="info">Customer Name</th>
					<th class="info">Is Non-Customer</th>
					<th class="info">Added By</th>
					<th class="info">Added On</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="record" items="${RECORDDETAILS}">
					<tr>
						<td style="text-align: center;"><input type="checkbox"> </td>
						<td>${record['UNQID']}</td>
						<td>${record['CUSTOMERID']}</td>
						<td>${record['CUSTOMERNAME']}</td>
						<td>${record['ISNONCUSTOMER']}</td>
						<td>${record['UPDATEDBY']}</td>
						<td>${record['UPDATETIME']}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-right">
				<button class="btn btn-primary btn-sm" id="addNonCustomer">Add Non-Customer</button>
				<button class="btn btn-success btn-sm" id="searchCustomer">Search Customer To Add</button>
				<button class="btn btn-danger btn-sm" id="deleteRecord">Delete</button>
			</div>
		</div>
	</div>
	</div>
</div>
<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassGenericModal-body">
				<br/>
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>