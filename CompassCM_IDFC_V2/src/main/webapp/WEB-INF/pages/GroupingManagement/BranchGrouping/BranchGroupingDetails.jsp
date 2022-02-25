<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Branch Grouping Details</title>
<jsp:include page="../../tags/staticFiles.jsp"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var riskRating = "${DATAMAP['RISKRATING']}";
		$("#riskRating").val(riskRating);
		
		var tableClass = 'branchGroupingRecordDetailsTable';
		compassDatatable.construct(tableClass, "BranchGrouping", false);
		compassDatatable.enableCheckBoxSelection();
		
		$("#updateBranchGroupingDetails"+id).click(function(){
			var groupCode = "${DATAMAP['GROUPCODE']}";
			var groupName = $("#groupName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "groupCode="+groupCode+"&groupName="+groupName+"&description="+description+"&riskRating="+riskRating;
			$.ajax({
				url: "${pageContext.request.contextPath}/common/updateBranchGroupingDetails",
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
		
		$("#deleteBranchRecord"+id).click(function(){
			var table = $(".branchGroupingRecordDetailsTable"+id).children("tbody");
			var branchCodeToDelete = "";
			var groupCodeToDelete = $("#groupCode"+id).val();
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var branchCode = $(this).children("td:nth-child(2)").html();
				if($(checkbox).prop("checked")){
					branchCodeToDelete = branchCodeToDelete + branchCode+",";
					selectedCount++;
				}
			});
			
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/deleteBranchRecord",
						cache: false,
						type: "POST",
						data: "branchCodeToDelete="+branchCodeToDelete+"&groupCodeToDelete="+groupCodeToDelete,
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
		
		$("#selectBranchToAdd"+id).click(function(){
			var groupCode = $("#groupCode").val();
			$("#compassGenericModal").modal("show");
			$.ajax({
				url: "${pageContext.request.contextPath}/common/selectBranchToAdd?groupCode="+groupCode+"&searchButton=searchBranchToAdd",
				cache: false,
				type: "POST",
				success: function(res){
					$("#compassGenericModal-title").html("Add Branch Group");
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
	.panel_branchGroupingDetails, 
	.panel_branchGroupingRecords{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_branchGroupingDetails">
			<div class="card-header panelSlidingBranchGrouping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Branch Grouping Details</h6>
			</div>
			<div class="panelBranchGroupingDetailsForm">
			<form action="javascript:void(0)" method="POST" id="branchGroupingDetailsForm${UNQID}">
				<table class="table table-striped branchGroupingDetailsTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Group Code</td>
						<td width="30%"><input type="text" id="groupCode${UNQID}" class="form-control input-sm" readonly="readonly" value="${DATAMAP['GROUPCODE']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Group Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" id="groupName" value="${DATAMAP['GROUPNAME']}"/></td>
					</tr>
					<tr>	
						<td width="15%">Description</td>
						<td width="30%"><textarea id="description" class="form-control input-sm">${DATAMAP['DESCRIPTION']}</textarea></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Risk Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="riskRating">
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
						<button type="button" class="btn btn-sm btn-primary updateBranchGroupingDetails" id="updateBranchGroupingDetails${UNQID}">Update</button>
						<button type="reset" class="btn btn-sm btn-danger clearBranchGroupingDetails" id="clearBranchGroupingDetails${UNQID}">Clear</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<div class="card card-primary panel_branchGroupingRecords">
		<div class="card-header">
			<h6 class="card-title">Branch Grouping Records</h6>
		</div>
		<table class="table table-bordered table-striped branchGroupingRecordDetailsTable" >
			<thead>
				<tr>
					<th class="info no-sort" style="text-align: center;">
						<input type="checkbox" class="checkbox-check-all" compassTable="deleteBranchGroupingRecords${UNQID}" id="deleteWatchListDetailsRecords${UNQID}" />
					</th>
					<th class="info">Branch Code</th>
					<th class="info">Branch Name</th>
					<th class="info">Added By</th>
					<th class="info">Added On</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="record" items="${RECORDDETAILS}">
					<tr>
						<td style="text-align: center;"><input type="checkbox"> </td>
						<td>${record['BRANCHCODE']}</td>
						<td>${record['BRANCHNAME']}</td>
						<td>${record['ADDEDBY']}</td>
						<td>${record['ADDEDON']}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-right">
				<button type="button" class="btn btn-success btn-sm" id="selectBranchToAdd${UNQID}">Search Branch To Add</button>
				<button type="button" class="btn btn-danger btn-sm" id="deleteBranchRecord${UNQID}">Delete Branches</button>
				<button type="button" id="closeBranchGroupingDetails${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
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