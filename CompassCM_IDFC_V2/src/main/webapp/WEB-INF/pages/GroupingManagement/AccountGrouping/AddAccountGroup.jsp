<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var groupCode = '${groupCode}';
		var searchButton = '${searchButton}';
		
		$("#searchAccountForGrouping").click(function(){
			var accountNo = $("#groupAccountNo").val();
			var accountName = $("#groupAccountName").val();
			var fullData = "accountNo="+accountNo+"&accountName="+accountName;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchAccountForGrouping",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#accountListSearchPanel").css("display", "block");
					$("#accountListSearchResult").html(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#addAccountToGroup").click(function(){
			var selectedAccountNos = "";
			var table = $("#accountListSearchResult").find("table").children("tbody");
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var accountNo = $(this).children("td:nth-child(2)").html();
				if($(checkbox).prop("checked")){
					selectedAccountNos = selectedAccountNos + accountNo+",";
					selectedCount++;
				}
			});
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					//alert(selectedAccountNos+" "+groupCode);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/addAccountToGroup?selectedAccountNos="+selectedAccountNos+"&groupCode="+groupCode,
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
				<h6 class="card-title pull-${dirL}">Search Account</h6>
			</div>
			<div class="panelAddAccountGroupForm">
				<form action="javascript:void(0)" method="POST" id="searchAccountForWatchlist">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">
								Account No
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="accountNo" id="groupAccountNo"/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Account Name
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="accountName" id="groupAccountName"/>
							</td>
						</tr>
						</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-success btn-sm" id="searchAccountForGrouping">Search</button>
					<button type="reset" class="btn btn-danger btn-sm" id="clearAccountForGroupingFields">Clear</button>
					<button type="button" class="btn btn-danger btn-sm" id="closeAccountForGroupingModal">Close</button>
				</div>
			</div>
		</div>
		<div class="card card-primary" style="display: none;" id="accountListSearchPanel">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Account List</h6>
			</div>
			<div id="accountListSearchResult"></div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="addAccountToGroup">Add Account To Group</button>
				</div>
			</div>	
		</div>
	</div>
</div>