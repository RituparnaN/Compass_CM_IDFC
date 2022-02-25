<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var listCode = '${listCode}';
		$("#AddNonCustomerButton").click(function(){
			var nonCustomerName = $("#nonCustomerName").val();
			if(nonCustomerName.length > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/addNonCustomerToWatchlist?listCode="+listCode+"&nonCustomerName="+nonCustomerName,
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
			}else{
				alert("Enter Non-Customer Name");
			}
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Enter Non-Customer Details</h6>
			</div>
			<div class="panelWatchlistDetailsForm">
				<form action="javascript:void(0)" method="POST" id="addNonCustomerToWatchlistForm">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">
								Non-Customer Name
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="nonCustomerName" id="nonCustomerName"/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
							&nbsp;
							</td>
							<td width="30%">
							&nbsp;
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="AddNonCustomerButton">Add</button>
				</div>
			</div>
		</div>
	</div>
</div>