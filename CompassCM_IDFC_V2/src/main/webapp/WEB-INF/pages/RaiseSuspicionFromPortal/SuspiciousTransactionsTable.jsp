<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${alertNo}';
		var tableClass = 'suspicionTransactionDetailsTable';
		compassDatatable.construct(tableClass, "Suspicion Transaction Details", false);
		
		$(".suspicionTransactionDetailsTable tbody tr").click(function(){
			var seqNo = $(this).attr("unqid");
			$("#compassCaseWorkFlowGenericModal-title").html("Delete Suspicious Transaction");
			$("#compassCaseWorkFlowGenericModal-body").html("");
			$("#compassCaseWorkFlowGenericModal").modal("show");
			// alert(seqNo+"  "+id);
			$.ajax({
				url: "${pageContext.request.contextPath}/common/showSuspiciousTransactionDetails?seqNo="+seqNo+"&alertNo="+id,
				cache:	false,
				type: "POST",
				success: function(res){
					$("#compassCaseWorkFlowGenericModal-body").html(res);
				}
			});
		});		
	});
</script>
<table class="table table-bordered table-striped suspicionTransactionDetailsTable"
	style="margin-bottom: 0px; margin-top: 0px;">
	<thead>
		<tr>
			<th width="25%" class="info">DATE OF TRANSACTION</th>
			<th width="15%" class="info">TRANSACTION TYPE</th>
			<th width="15%" class="info">DEBIT/CREDIT</th>
			<th width="20%" class="info">AMOUNT</th>
			<th width="25%" class="info">REMARKS</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${result}">
			<tr unqid="${record['SEQUENCENO']}">
				<td>${record['TRANSACTIONDATE']}</td>
				<td>${record['TRANSACTIONMODE']}</td>
				<td>${record['DEBITCREDIT']}</td>
				<td>${record['TRANSACTIONAMOUNT']}</td>
				<td>${record['TRANSACTIONREMARKS']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>