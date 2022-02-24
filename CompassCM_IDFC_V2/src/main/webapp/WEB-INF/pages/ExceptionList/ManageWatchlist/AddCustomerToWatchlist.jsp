<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var listCode = '${listCode}';
		var searchButton = '${searchButton}';
		
		$("#searchCustomerButton").click(function(){
			var customerId = $("#watchListCustomerId").val();
			var customerName = $("#watchListCustomerName").val();
			var branchCode = $("#watchListBranchCode").val();
			var riskRating = $("#watchListRiskRating").val();
			var fullData = "customerId="+customerId+"&customerName="+customerName+"&branchCode="+branchCode+"&riskRating="+riskRating;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchCustomerToAdd",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#customerSearchPanel").css("display", "block");
					$("#customerSearchResult").html(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#addCustomerButton").click(function(){
			var selectedCustomerIds = "";
			var table = $("#customerSearchResult").find("table").children("tbody");
			
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var customerId = $(this).children("td:nth-child(2)").html();
				if($(checkbox).prop("checked")){
					selectedCustomerIds = selectedCustomerIds + customerId+",";
					selectedCount++;
				}
			});
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/addCustomerToWatchlist?selectedCustomerIds="+selectedCustomerIds+"&listCode="+listCode,
						cache: false,
						type: "POST",
						success: function(res){
							alert(res);
							$("#compassGenericModal").modal("hide");
							var doc = $("#compassGenericModal-title")[0].ownerDocument;
							var win = doc.defaultView || doc.parentWindow;
							win.location.reload();
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			} else{
				alert("Select atleast one record to add");
			}
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Search Customer</h6>
			</div>
			<div class="panelWatchlistDetailsForm">
				<form action="javascript:void(0)" method="POST" id="searchCustomerForWatchlist">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">
								Customer ID
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="customerId" id="watchListCustomerId"/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Customer Name
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="customerName" id="watchListCustomerName"/>
							</td>
						</tr>
						<tr>
							<td width="15%">
								Risk Rating
							</td>
							<td width="30%">
								<select name="riskRating" id="watchListRiskRating" class="form-control input-sm">
									<option value="" selected="selected">ALL</option>
									<option value="1">LOW</option>
									<option value="2">MEDIUM</option>
									<option value="3">HIGH</option>
								</select>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Branch Code
							</td>
							<td width="30%">
								<select name="branchCode" id="watchListBranchCode" class="form-control input-sm">
									<option value="" selected="selected">ALL</option>
								</select>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-success btn-sm" id="searchCustomerButton">Search</button>
				</div>
			</div>
		</div>
		<div class="card card-primary" style="display: none;" id="customerSearchPanel">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Search Customer</h6>
			</div>
			<div id="customerSearchResult"></div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="addCustomerButton">Add</button>
				</div>
			</div>	
		</div>
	</div>
</div>