<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$(".selectpicker").selectpicker();

	var id = '${UNQID}';
	var paramId = '${paramId}';
	var isNew = '${isNew}';
	var searchButton = '${searchButton}';
	if(isNew != 'Y'){
		$("#paramCode"+id).attr("readonly", "readonly");
	}
	
	/* var SUBPARAMETERRISKVALUE = '${DATAMAP['SUBPARAMETERRISKVALUE']}';
	$("#paramRiskValue"+id).val(SUBPARAMETERRISKVALUE); */
	
	$("#saveNewDynamicRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var paramDesc = $("#paramDesc"+id).val();
		var paramRangeFrom = $("#paramRangeFrom"+id).val();
		var paramRangeTo = $("#paramRangeTo"+id).val();
		var paramRiskValue = $("#paramRiskValue"+id).val();
		var paramOccupation = $("#paramOccupation"+id).val();
		alert(paramOccupation);
		var fullData = "paramId="+paramId+"&paramCode="+paramCode+"&paramDesc="+paramDesc+"&paramRangeFrom="+paramRangeFrom+
			"&paramRangeTo="+paramRangeTo+"&paramRiskValue="+paramRiskValue+"&paramOccupation="+paramOccupation;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/saveNewDynamicRiskParam",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				alert(res);
				$("#"+searchButton).click();
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});	
	});
	
	$("#deleteNewDynamicRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var fullData = "paramId="+paramId+"&paramCode="+paramCode;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/deleteNewDynamicRiskParam",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				alert(res);
				$("#"+searchButton).click();
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});	
	});
	
	$("#updateNewDynamicRiskParam"+id).click(function(){
		var paramCode = $("#paramCode"+id).val();
		var paramDesc = $("#paramDesc"+id).val();
		var paramRangeFrom = $("#paramRangeFrom"+id).val();
		var paramRangeTo = $("#paramRangeTo"+id).val();
		var paramRiskValue = $("#paramRiskValue"+id).val();
		var paramOccupation = $("#paramOccupation"+id).val();
		alert(paramOccupation);
		var fullData = "paramId="+paramId+"&paramCode="+paramCode+"&paramDesc="+paramDesc+"&paramRangeFrom="+paramRangeFrom+
			"&paramRangeTo="+paramRangeTo+"&paramRiskValue="+paramRiskValue+"&paramOccupation="+paramOccupation;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/updateNewDynamicRiskParam",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				alert(res);
				$("#"+searchButton).click();
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});	
	});
});
</script>
<style>
#compassCaseWorkFlowGenericModal-body{
	height: auto;
}
</style>
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
					Occupation
				</td>
				<td width="30%">
					<select class="selectpicker" id="paramOccupation${UNQID}" name="paramOccupation" multiple="multiple" data-live-search="true" data-width="100%" title="Select an option">
						<option value="All">All</option>
						<c:forEach var="occupationCodes" items="${OccupationCodes}">
							<option value="${occupationCodes.CODE}" <c:if test="${f:contains(DATAMAP.SUBRISKPARAMETER_OCCU_CODE, occupationCodes.CODE)}">selected="selected"</c:if>>${occupationCodes.DESCRIPTION}</option>
						</c:forEach>
					</select>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Parameter Risk Value
				</td>
				<td width="30%">
					<select class="form-control input-sm selectpicker" id="paramRiskValue${UNQID}" name="paramRiskValue">
						<option value="1" <c:if test="${DATAMAP.SUBPARAMETERRISKVALUE eq 1}">selected="selected"</c:if>>1-LOW</option>  
						<option value="2" <c:if test="${DATAMAP.SUBPARAMETERRISKVALUE eq 2}">selected="selected"</c:if>>2-MEDIUM</option>
						<option value="3" <c:if test="${DATAMAP.SUBPARAMETERRISKVALUE eq 3}">selected="selected"</c:if>>3-HIGH</option>
					</select>
				</td>
			</tr>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<c:choose>
					<c:when test="${isNew eq 'Y'}">
						<button type="button" id="saveNewDynamicRiskParam${UNQID}" class="btn btn-success btn-sm">Save</button>
					</c:when>
					<c:otherwise>
						<button type="button" id="updateNewDynamicRiskParam${UNQID}" class="btn btn-success btn-sm">Update</button>
						<button type="button" id="deleteNewDynamicRiskParam${UNQID}" class="btn btn-danger btn-sm">Delete</button>
					</c:otherwise>
				</c:choose>
				
					
			</div>
		</div>