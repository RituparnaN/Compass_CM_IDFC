<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var paramId = '${paramId}';
	var isNew = '${isNew}';
	var searchButtonId = '${SEARCHBUTTONID}';
	
	console.log(searchButtonId);
	
	if(isNew != 'Y'){
		$("#paramCode"+id).attr("readonly", "readonly");
	}
	
	var SUBPARAMETERRISKVALUE = '${DATAMAP['SUBPARAMETERRISKVALUE']}';
	$("#paramRiskValue"+id).val(SUBPARAMETERRISKVALUE);
	
	var previousPriorityRiskValue = '${DATAMAP['PRIORITYRISKVALUE']}';
	$("#priorityRiskValue"+id).val(previousPriorityRiskValue);
	
	$("#saveNewRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var paramDesc = $("#paramDesc"+id).val();
		var paramRangeFrom = $("#paramRangeFrom"+id).val();
		var paramRangeTo = $("#paramRangeTo"+id).val();
		var paramRiskValue = $("#paramRiskValue"+id).val();
		var priorityRiskValue = $("#priorityRiskValue"+id).val();
		var fullData = "paramId="+paramId+"&paramCode="+paramCode+"&paramDesc="+paramDesc+"&paramRangeFrom="+paramRangeFrom+
						"&paramRangeTo="+paramRangeTo+"&paramRiskValue="+paramRiskValue+"&priorityRiskValue="+priorityRiskValue;

		if(paramCode != '' && paramRangeFrom != '' & paramRangeTo != '' && paramRiskValue != null & priorityRiskValue != null){
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveNewRiskParam",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					alert(res);
					$("#"+searchButtonId).click();
					$("#compassCaseWorkFlowGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});	
		}else{
			alert("Please enter the values.");
		}
	});
	
	$("#deleteNewRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var fullData = "paramId="+paramId+"&paramCode="+paramCode;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/deleteNewRiskParam",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				alert(res);
				$("#"+searchButtonId).click();
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});	
	});
	
	$("#updateNewRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var paramDesc = $("#paramDesc"+id).val();
		var paramRangeFrom = $("#paramRangeFrom"+id).val();
		var paramRangeTo = $("#paramRangeTo"+id).val();
		var paramRiskValue = $("#paramRiskValue"+id).val();
		var priorityRiskValue = $("#priorityRiskValue"+id).val();
		var fullData = "paramId="+paramId+"&paramCode="+paramCode+"&paramDesc="+paramDesc+
					"&paramRangeFrom="+paramRangeFrom+"&paramRangeTo="+paramRangeTo+"&paramRiskValue="+paramRiskValue+
					"&priorityRiskValue="+priorityRiskValue;
		
		if(paramCode != '' && paramRangeFrom != '' & paramRangeTo != '' && paramRiskValue != null & priorityRiskValue != null){
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateNewRiskParam",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					alert(res);
					$("#"+searchButtonId).click();
					$("#compassCaseWorkFlowGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});	
		}else{
			alert("Please enter the values.");
		}
	});
});
</script>
<div class="row compassrow">
	<div class="col-sm-12">
	<div class="card card-primary addNewRiskParamModal">
		<table class="table table-striped table-bordered" style="margin-bottom: 0px;">
			<tr>
				<td width="15%">
					Parameter Code
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="paramCode${UNQID}"  name="paramCode" value="${DATAMAP['SUBPARAMETERCODE']}">
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Parameter Description
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="paramDesc${UNQID}" name="paramDesc" value="${DATAMAP['SUBPARAMETERDESCRIPTION']}">
				</td>
			</tr>		
			<tr>
				<td width="15%">
					From Value
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="paramRangeFrom${UNQID}" name="paramRangeFrom" value="${DATAMAP['SUBRISKPARAMETER_FROMVALUE']}">
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					To Value
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="paramRangeTo${UNQID}" name="paramRangeTo" value="${DATAMAP['SUBRISKPARAMETER_TOVALUE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">
					Parameter Risk Value
				</td>
				<td width="30%">
					<select class="form-control input-sm" id="paramRiskValue${UNQID}" name="paramRiskValue">
						<option value="1">1-LOW</option>
						<option value="2">2-MEDIUM</option>
						<option value="3" >3-HIGH</option>
					</select>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Priority Risk Value
				</td>
				<td width="30%">
					<select class="form-control input-sm" id="priorityRiskValue${UNQID}" name="priorityRiskValue">
						<option value="0">NA</option>
						<option value="1">1-LOW</option>
						<option value="2">2-MEDIUM</option>
						<option value="3" >3-HIGH</option>
					</select>
				</td>
			</tr>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<c:choose>
					<c:when test="${isNew eq 'Y'}">
						<button type="button" id="saveNewRiskParam${UNQID}" class="btn btn-success btn-sm">Save</button>
					</c:when>
					<c:otherwise>
						<button type="button" id="updateNewRiskParam${UNQID}" class="btn btn-success btn-sm">Update</button>
						<button type="button" id="deleteNewRiskParam${UNQID}" class="btn btn-danger btn-sm">Delete</button>
					</c:otherwise>
				</c:choose>
				
					
			</div>
		</div>