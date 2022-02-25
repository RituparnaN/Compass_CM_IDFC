<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var searchParamId = '${searchParamId}';
	var isRangeRequired = '${isRangeRequired}';
	var tableClass = 'compassRiskAssignmentResultTable';
	var searchButtonId = '${SEARCHBUTTONID}';
	console.log(searchButtonId);
	
	compassDatatable.construct(tableClass, "Risk Assignment", true);
	
	$(".updateOrDeleteParamCode").click(function(){
		if(isRangeRequired == 'Y'){
			var paramCode = $(this).html();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchParamCodeToDeleteRiskParameter",
				cache: false,
				type: "POST",
				data: "paramCode="+paramCode+"&searchParamId="+searchParamId+"&searchButtonId="+searchButtonId,
				success: function(res){
						$("#compassCaseWorkFlowGenericModal").modal("show");
						$("#compassCaseWorkFlowGenericModal-title").html("Risk Parameter Details");
						$("#compassCaseWorkFlowGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}
	});
});
</script>
<style type="text/css">
.updateOrDeleteParamCode{
	<c:if test="${isRangeRequired eq 'Y'}">
		text-decoration: underline;
		color: blue;
		cursor:pointer;
	</c:if>
}
</style>
<table class="table table-bordered table-striped compassRiskAssignmentResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info">Parameter Code</th>
			<th class="info">Parameter Description</th>
			<th class="info">Parameter Risk Value</th>
			<th class="info">Priority Risk Value</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${RESULTLIST}">
			<tr>
				<td class="updateOrDeleteParamCode">${parameterList['SUBPARAMETERCODE']}</td>
				<td>${parameterList['SUBPARAMETERDESCRIPTION']}</td>
				<td>
					<select class="form-control input-sm" style="width: 50%">
						<option value="1" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '1'}">selected="selected"</c:if>>1-LOW</option>
						<option value="2" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
						<option value="3" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '3'}">selected="selected"</c:if>>3-HIGH</option>
					</select>
				</td>
				<td>
					<select class="form-control input-sm" style="width: 50%">
						<option value="0" <c:if test="${parameterList['PRIORITYRISKVALUE'] eq '0'}">selected="selected"</c:if>>NA</option>
						<option value="1" <c:if test="${parameterList['PRIORITYRISKVALUE'] eq '1'}">selected="selected"</c:if>>1-LOW</option>
						<option value="2" <c:if test="${parameterList['PRIORITYRISKVALUE'] eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
						<option value="3" <c:if test="${parameterList['PRIORITYRISKVALUE'] eq '3'}">selected="selected"</c:if>>3-HIGH</option>
					</select>
				
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>