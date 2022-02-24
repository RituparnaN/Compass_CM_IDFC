<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var groupCode = '${groupCode}';
		var searchButton = '${searchButton}';
		
		$("#searchBranchForGrouping").click(function(){
			var branchCode = $("#groupBranchCode").val();
			var branchName = $("#groupBranchName").val();
			var fullData = "branchCode="+branchCode+"&branchName="+branchName;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchBranchForGrouping",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#branchListSearchPanel").css("display", "block");
					$("#branchListSearchResult").html(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#addBranchToGroup").click(function(){
			var selectedBranchCodes = "";
			var table = $("#branchListSearchResult").find("table").children("tbody");
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var branchCode = $(this).children("td:nth-child(2)").html();
				if($(checkbox).prop("checked")){
					selectedBranchCodes = selectedBranchCodes + branchCode+",";
					selectedCount++;
				}
			});
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					//alert(selectedBranchCodes+" "+groupCode);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/addBranchToGroup?selectedBranchCodes="+selectedBranchCodes+"&groupCode="+groupCode,
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
				<h6 class="card-title pull-${dirL}">Search Branch</h6>
			</div>
			<div class="panelAddBranchGroupForm">
				<form action="javascript:void(0)" method="POST" id="searchBranchForWatchlist">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">
								Branch Code
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="branchCode" id="groupBranchCode"/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Branch Name
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="branchName" id="groupBranchName"/>
							</td>
						</tr>
						</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-success btn-sm" id="searchBranchForGrouping">Search</button>
					<button type="reset" class="btn btn-danger btn-sm" id="clearBranchForGroupingFields">Clear</button>
					<button type="button" class="btn btn-danger btn-sm" id="closeBranchForGroupingModal">Close</button>
				</div>
			</div>
		</div>
		<div class="card card-primary" style="display: none;" id="branchListSearchPanel">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Branch List</h6>
			</div>
			<div id="branchListSearchResult"></div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="addBranchToGroup">Add Branch To Group</button>
				</div>
			</div>	
		</div>
	</div>
</div>