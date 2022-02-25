<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="transactionDate" value="${DATA['TRANSACTIONDATE']}"></c:set>
<c:set var="transactionMode" value="${DATA['TRANSACTIONMODE']}"></c:set>
<c:set var="debitCredit" value="${DATA['DEBITCREDIT']}"></c:set>
<c:set var="amount" value="${DATA['TRANSACTIONAMOUNT']}"></c:set>
<c:set var="remarks" value="${DATA['TRANSACTIONREMARKS']}"></c:set>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${alertNo}';
		var seqNo = '${seqNo}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'suspiciousTransactionForm'+id, 'dd/mm/yy');

		$("#closeSuspiciousTransactionDetailsModal"+id).click(function(){
			$("#compassCaseWorkFlowGenericModal").modal("hide");
		});
		
		var transactionMode = '${transactionMode}';
		$("#"+transactionMode).prop("checked", true);
		
		var debitCredit = '${debitCredit}';
		$("#"+debitCredit).prop("checked", true);
		
		$("#deleteSuspiciousTransactionDetailsModal"+id).click(function(){
			$.ajax({
				url: "${pageContext.request.contextPath}/common/deleteSuspiciousTransactionDetails",
				cache: false,
				type: "POST",
				data: "seqNo="+seqNo+"&alertNo="+id,
				success: function(res){
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					$("#suspiciousTransactionTable").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#saveSuspiciousTransactionDetailsModal"+id).click(function(){
			var txnDate = $("#transactionDate"+id).val();
			var txnMode = "";
				if($("#CHQ").prop("checked")){
					txnMode = "CHQ";
				}else if($("#TWB").prop("checked")){
					txnMode = "TWB";
				}else if($("#Cash").prop("checked")){
					txnMode = "Cash";
				}else if($("#DD").prop("checked")){
					txnMode = "DD";
				}else if($("#EFT").prop("checked")){
					txnMode = "EFT";
				}else if($("#TC").prop("checked")){
					txnMode = "TC";
				}else if($("#Other").prop("checked")){
					txnMode = "Other";
				}
			var debitcredit = "";
				if($("#D").prop("checked")){
					debitcredit = "D";
				}else if($("#C").prop("checked")){
					debitcredit = "C";
				}
			var amount = $("#amount"+id).val();
			var remarks = $("#remarks"+id).val();
			var fulldata = "txnDate="+txnDate+"&txnMode="+txnMode+"&debitcredit="+debitcredit+"&amount="+amount+"&remarks="+remarks+"&alertNo="+id;

			if(txnDate != '' && txnMode != '' && debitcredit != '' && amount != '' && remarks != ''){			
				$.ajax({
					url: "${pageContext.request.contextPath}/common/saveSuspiciousTransaction",
					cache: false,
					type: "POST",
					data: fulldata,
					success: function(res){
						$("#compassCaseWorkFlowGenericModal").modal("hide");
							//alert("Successfully Saved");
						$("#suspiciousTransactionTable").html(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
			else{
				alert("Blank form cannot be saved.");
			}
		});
		
		$("#updateSuspiciousTransactionDetailsModal"+id).click(function(){
			var txnDate = $("#transactionDate"+id).val();
			var txnMode = "";
				if($("#CHQ").prop("checked")){
					txnMode = "CHQ";
				}else if($("#TWB").prop("checked")){
					txnMode = "TWB";
				}else if($("#Cash").prop("checked")){
					txnMode = "Cash";
				}else if($("#DD").prop("checked")){
					txnMode = "DD";
				}else if($("#EFT").prop("checked")){
					txnMode = "EFT";
				}else if($("#TC").prop("checked")){
					txnMode = "TC";
				}else if($("#Other").prop("checked")){
					txnMode = "Other";
				}
			var debitcredit = "";
				if($("#D").prop("checked")){
					debitcredit = "D";
				}else if($("#C").prop("checked")){
					debitcredit = "C";
				}
			var amount = $("#amount"+id).val();
			var remarks = $("#remarks"+id).val();
			var fulldata = "txnDate="+txnDate+"&txnMode="+txnMode+"&debitcredit="+debitcredit+"&amount="+amount+"&remarks="+remarks+"&alertNo="+id+"&seqNo="+seqNo;
			
			
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateSuspiciousTransaction",
					cache: false,
					type: "POST",
					data: fulldata,
					success: function(res){
						$("#compassCaseWorkFlowGenericModal").modal("hide");
						alert("Successfully Updated");
						$("#suspiciousTransactionTable").html(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
		});
});
</script>
<div class="row compassrow${alertNo}">
	<div class="col-sm-12">
	<div class="card card-primary suspiciousTransactionModalForm">
		<form action="javascript:void(0)" method="POST" id="suspiciousTransactionForm${alertNo}">
			<table class="table table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="30%">Date of Transaction</td>
					<td width="70%">
						<input style="width: 40%" value="${transactionDate}" type="text" class="form-control input-sm datepicker" name="transactionDate" id="transactionDate${alertNo}"/>
					</td> 
				</tr>
				<tr>
					<td width="30%">
						Mode of Transaction
					</td>
					<td>
						<div class="radio-inline">
							<label><input type="radio" name="transactionMode" id ="CHQ">Cheque</label>
						</div>
						<div class="radio-inline">
							<label><input type="radio" name="transactionMode" id="TWB">Transfer Within Branch</label>
						</div>
						<div class="radio-inline">
							<label><input type="radio" name="transactionMode" id="Cash">Cash</label>
						</div>
					</td>
				</tr>
				<tr>
				<td width="30%">&nbsp;</td>
				<td>
					<div class="radio-inline">
						<label><input type="radio" name="transactionMode" id="DD">Demand Draft</label>
					</div>
					<div class="radio-inline">
						<label><input type="radio" name="transactionMode" id="EFT">Electronic Funds Transfer</label>
					</div>
					<div class="radio-inline">
						<label><input type="radio" name="transactionMode" id="TC">Travelers Cheque</label>						</div>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<div class="radio-inline">
							<label><input type="radio" name="transactionMode" id="Other">Other</label>
						</div>
					</td>
				</tr>
				<tr>
					<td width="30%">
						Debit/Credit
					</td>
					<td width="70%">
						<div class="radio-inline">
						<label><input type="radio" name="debitCredit" id="D">Debit (Withdrawn by Customer)</label>
					</div>
					<div class="radio-inline">
						<label><input type="radio" name="debitCredit" id="C">Credit (Deposited by Customer)</label>
					</div>
					</td>
				</tr>
				<tr>
					<td width="30%">
						Amount(As per Local Currency)
					</td>
					<td width="70%">
						<input type="text" value="${amount}" class="form-control input-sm" name="amount" id="amount${alertNo}"/>
					</td>
				</tr>
				<tr>
					<td width="30%">
						Remarks 
					</td>
					<td width="70%">
						<textarea class="form-control input-sm" name="remarks" id="remarks${alertNo}">${remarks}</textarea>
					</td>
				</tr>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<c:choose>
						<c:when test="${f:length(seqNo) != 0}">
							<button type="button" id="updateSuspiciousTransactionDetailsModal${alertNo}" class="btn btn-primary btn-sm">Update</button>
							<button type="button" id="deleteSuspiciousTransactionDetailsModal${alertNo}" class="btn btn-danger btn-sm">Delete</button>
						</c:when>
						<c:otherwise>
							<button type="button" id="saveSuspiciousTransactionDetailsModal${alertNo}" class="btn btn-success btn-sm">Save</button>
						</c:otherwise>
					</c:choose>
					<button type="button" id="closeSuspiciousTransactionDetailsModal${alertNo}" class="btn btn-danger btn-sm">Close</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>