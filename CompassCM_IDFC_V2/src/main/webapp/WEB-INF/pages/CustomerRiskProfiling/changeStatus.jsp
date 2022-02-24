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
		changeStatus(CRPRuleStatus);
		
	});
	$("#rejectRule"+id).click(function(){
		var CRPRuleStatus ="REJECTED";
		changeStatus(CRPRuleStatus);
		
	});
	
	function changeStatus(CRPRuleStatus){
		var ruleID = "${CRPRULEDETAILS['RULEID']}";
		var comment = $("#comment"+id).val();
		if(comment == '' || comment == null){
			alert('Please enter comemnts to approve/reject a rule.');
		}else{
			/* alert(comment);
			alert(ruleID);
			alert(CRPRuleStatus); */
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
				<td>Rule Status</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['STATUS']}" disabled /></td>
			</tr>
			<tr>
				<td>Maker Code</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERCODE']}" disabled /></td>
				<td>Maker Timestamp</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERTIMESTAMP']}" disabled /></td>
			</tr>
			<tr>
				<td>Maker IP Address</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['MAKERIPADDRESS']}" disabled /></td>
				<td>Maker Comments</td>
				<td ><textarea class="form-control input-sm resizeTextarea" rows ="3" disabled>${CRPRULEDETAILS['MAKERCOMMENTS']}</textarea></td>
			</tr>
			<c:if test = "${CRPRULEDETAILS['STATUS'] ne 'PENDING' }">
			<tr>
				<td>Checker Code</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['CHECKERCODE']}" disabled /></td>
				<td>Checker Timestamp</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['CHECKERTIMESTAMP']}" disabled /></td>
			</tr>
			<tr>
				<td>Maker IP Address</td>
				<td><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['CHECKERIPADDRESS']}" disabled /></td>
				<td>Maker Comments</td>
				<td ><textarea class="form-control input-sm resizeTextarea" rows ="3" disabled>${CRPRULEDETAILS['CHECKERCOMMENTS']}</textarea></td>
			</tr>	
			</c:if>
			<tr>
				<td>CRP Rule</td>
				<td colspan = '3'><textarea class="form-control input-sm resizeTextarea" rows ="3" disabled>${CRPRULEDETAILS['RULE']}</textarea></td>
			</tr>
			<tr>
				<td>Rule Risk</td>
				<td ><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RISK']}" disabled /></td>
				<td>Rule For </td>
				<%-- <td>
				<c:choose>
					  <c:when test="${CRPRULEDETAILS['RULEFOR'] eq 'PROFILED_CUSTOMER'}">
						<input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RULEFOR']}" disabled />
					  </c:when>
					  <c:otherwise>
					  	<input type="text" class="form-control input-sm" value = "Non Profiled Customer" disabled />
					  </c:otherwise>
			    </c:choose>
			    </td> --%>
			    <td ><input type="text" class="form-control input-sm" value = "${CRPRULEDETAILS['RULEFOR']}" disabled /></td>		  	
			</tr>
			<c:if test = "${CRPRULEDETAILS['STATUS'] eq 'PENDING' }">
			<tr>
				<td>Comments</td>
				<td colspan = '3'><textarea class="form-control input-sm resizeTextarea" rows ="3"  id="comment${UNQID}"></textarea></td>
			</tr>
			</c:if>
		
		</table>
	<c:if test = "${CRPRULEDETAILS['STATUS'] eq 'PENDING' }">
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="button" class="btn btn-sm btn-success" id="approveRule${UNQID}">Approve</button>
				<button type="button" class="btn btn-sm btn-danger" id="rejectRule${UNQID}">Reject</button>
			</div>
		</div>
	</c:if>
</div>

