<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<style>
	.resizeTextarea{
    	resize: vertical;
	} 

</style>
<script type="text/javascript">
	var id = "${UNQID}";
	var submitButton = "${submitButton}";
	//console.log(submitButton);
	$("#approveRule"+id).click(function(){
		var CRPRuleStatus ="APPROVED";
		changeStaus(CRPRuleStatus);
		
	});
	$("#rejectRule"+id).click(function(){
		var CRPRuleStatus ="REJECTED";
		changeStaus(CRPRuleStatus);
		
	});
	
	function changeStaus(CRPRuleStatus){
		var ruleID = "${CRPRULEDETAILS['RULEID']}";
		var comment = $("#comment"+id).val();
		if(comment == '' || comment == null){
			alert('Please enter comemnts to approve/reject a rule.');
		}else{
			$.ajax({
				url : "${pageContext.request.contextPath}/admin/CRPRuleStatusChange",
				data : {ruleID:ruleID,status:CRPRuleStatus,comment:comment},
				type : "POST",
				cache : false,	
				success : function(resData){
					alert(resData);
					$("#"+submitButton).click();
					$("#compassMediumGenericModal").modal('hide');
				},
				error : function(a,b,c){
				 alert(a+"\n"+b+"\n"+c);
				}
			});
		}
	};
</script>

<div class="card card-default card-primary">
	<div class="card-header" style="cursor:pointer;">Rule Details</div>
		<table class="table table-striped">
			<tr>
				<td>Rule ID</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RULEID']}" disabled /></td>
				<td>Rule Code</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RULECODE']}" disabled /></td>
			</tr>
			<tr>
				<td>Rule Name</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RULENAME']}" disabled /></td>
				<td>Rule Risk</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RISK']}" disabled /></td>
			</tr>
			<tr>
				<td>Maker Code</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERCODE']}" disabled /></td>
				<td>Maker timestamp</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERTIMESTAMP']}" disabled /></td>
			</tr>
			<tr>
				<td>Maker IP Address</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERIPADDRESS']}" disabled /></td>
				<td>Maker Comments</td>
				<td ><textarea class="form-control input-sm resizeTextarea" rows ="3" disabled>${CRPRULEDETAILS['MAKERCOMMENTS']}</textarea></td>
			</tr>
			<tr>
				<td>CRP Rule</td>
				<td colspan = '3'><textarea class="form-control input-sm resizeTextarea" rows ="3" disabled>${CRPRULEDETAILS['RULE']}</textarea></td>
			</tr>
			<tr>
				<td>Comments</td>
				<td colspan = '3'><textarea class="form-control input-sm resizeTextarea" rows ="3"  id="comment${UNQID}"></textarea></td>
			</tr>
		
		</table>
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button type="button" class="btn btn-sm btn-success" id="approveRule${UNQID}">Approve</button>
			<button type="button" class="btn btn-sm btn-danger" id="rejectRule${UNQID}">Reject</button>
		</div>
	</div>
</div>

