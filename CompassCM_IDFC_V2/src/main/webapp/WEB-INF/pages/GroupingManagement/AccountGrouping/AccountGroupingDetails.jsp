<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Account Grouping Details</title>
<jsp:include page="../../tags/staticFiles.jsp"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var riskRating = "${DATAMAP['RISKRATING']}";
		$("#riskRating").val(riskRating);
		
		var tableClass = 'accountGroupingRecordDetailsTable'+id;
		compassDatatable.construct(tableClass, "AccountGrouping", false);
		compassDatatable.enableCheckBoxSelection();
		
		$("#updateAccountGroupingDetails"+id).click(function(){
			var groupCode = "${DATAMAP['GROUPCODE']}";
			var groupName = $("#groupName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "groupCode="+groupCode+"&groupName="+groupName+"&description="+description+"&riskRating="+riskRating;
			$.ajax({
				url: "${pageContext.request.contextPath}/common/updateAccountGroupingDetails",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					alert(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
			$("#deleteAccountRecord"+id).click(function(){
				var table = $(".accountGroupingRecordDetailsTable"+id).children("tbody");
				var accNoToDelete = "";
				var groupCodeToDelete = $("#groupCode").val();
				var selectedCount = 0;
				$(table).children("tr").each(function(){
					var checkbox = $(this).children("td:first-child").children("input");
					var accNo = $(this).children("td:nth-child(2)").html();
					if($(checkbox).prop("checked")){
						accNoToDelete = accNoToDelete + accNo+",";
						selectedCount++;
					}
				});
				//alert(accNoToDelete);
				if(selectedCount > 0){
					if(confirm("Are you sure?")){
						$.ajax({
							url: "${pageContext.request.contextPath}/common/deleteAccountRecord",
							cache: false,
							type: "POST",
							data: "accNoToDelete="+accNoToDelete+"&groupCodeToDelete="+groupCodeToDelete,
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
			
			$("#selectAccountToAdd"+id).click(function(){
				var groupCode = $("#groupCode").val();
				$("#compassGenericModal").modal("show");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/selectAccountToAdd?groupCode="+groupCode+"&searchButton=searchAccountToAdd",
					cache: false,
					type: "POST",
					success: function(res){
						$("#compassGenericModal-title").html("Add Account Group");
						$("#compassGenericModal-body").html(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			});	
		});
		
</script>

<style type="text/css">
	.panel_accountGroupingDetails, 
	.panel_accountGroupingRecords{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_accountGroupingDetails">
			<div class="card-header panelSlidingAccountGrouping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Account Grouping Details</h6>
			</div>
			<div class="panelAccountGroupingDetailsForm">
			<form action="javascript:void(0)" method="POST" id="accountGroupingDetailsForm${UNQID}">
				<table class="table table-striped accountGroupingDetailsTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Group Code</td>
						<td width="30%"><input type="text" id="groupCode${UNQID}" class="form-control input-sm" readonly="readonly" value="${DATAMAP['GROUPCODE']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Group Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" id="groupName${UNQID}" value="${DATAMAP['GROUPNAME']}"/></td>
					</tr>
					<tr>	
						<td width="15%">Description</td>
						<td width="30%"><textarea id="description${UNQID}" class="form-control input-sm">${DATAMAP['DESCRIPTION']}</textarea></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Risk Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="riskRating${UNQID}">
								<option value="1" selected="selected">Low</option>
								<option value="2">Medium</option>
								<option value="3">High</option>
							</select> 
						</td>
					</tr>
					<tr>
						<td width="15%">Updated By</td>
						<td width="30%"><input type="text" class="form-control input-sm" readonly="readonly" value="${DATAMAP['UPDATEDBY']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Updated On</td>
						<td width="30%"><input type="text" class="form-control input-sm" readonly="readonly" value="${DATAMAP['UPDATETIME']}"/></td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-right">
						<button type="button" class="btn btn-sm btn-primary updateAccountGroupingDetails" id="updateAccountGroupingDetails${UNQID}">Update</button>
						<button type="reset" class="btn btn-sm btn-danger clearAccountGroupingDetails" id="clearAccountGroupingDetails${UNQID}">Clear</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<div class="card card-primary panel_accountGroupingRecords">
		<div class="card-header">
			<h6 class="card-title">Account Grouping Records</h6>
		</div>
		<table class="table table-bordered table-striped accountGroupingRecordDetailsTable${UNQID}" >
			<thead>
				<tr>
					<th class="info no-sort" style="text-align: center;">
						<input type="checkbox" class="checkbox-check-all" compassTable="deleteAccountGroupingRecords${UNQID}" id="deleteWatchListDetailsRecords${UNQID}" />
					</th>
					<th class="info">Account No</th>
					<th class="info">Customer ID</th>
					<th class="info">Customer Name</th>
					<th class="info">Added By</th>
					<th class="info">Added On</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="record" items="${RECORDDETAILS}">
					<tr>
						<td style="text-align: center;"><input type="checkbox"> </td>
						<td>${record['ACCOUNTNO']}</td>
						<td>${record['CUSTOMERID']}</td>
						<td>${record['CUSTOMERNAME']}</td>
						<td>${record['ADDEDBY']}</td>
						<td>${record['ADDEDON']}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-right">
				<button type="button" class="btn btn-success btn-sm" id="selectAccountToAdd${UNQID}">Search Account To Add</button>
				<button type="button" class="btn btn-danger btn-sm" id="deleteAccountRecord${UNQID}">Delete Accounts</button>
				<button type="button" id="closeAccountGroupingDetails${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
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