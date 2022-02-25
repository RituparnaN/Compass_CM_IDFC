<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var searchButton = '${searchButton}';
	var searchParamId = '${searchParamId}';
	var isRangeRequired = '${isRangeRequired}';
	var id = '${UNQID}';
	var tableClass = 'dynamicRiskAssignmentResultTable';
	compassDatatable.construct(tableClass, "Dynamic Risk Assignment", true);
	
	$(".updateOrDeleteDynamicParamCode").click(function(){
		if(isRangeRequired == 'Y'){
			var paramCode = $(this).html();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchParamCodeToDeleteDynamicRiskParameter",
				cache: false,
				type: "POST",
				data: "paramCode="+paramCode+"&searchParamId="+searchParamId+"&searchButton="+searchButton,
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
.updateOrDeleteDynamicParamCode{
	<c:if test="${isRangeRequired eq 'Y'}">
		text-decoration: underline;
		color: blue;
		cursor:pointer;
	</c:if>
}
</style>
<table class="table table-bordered table-striped dynamicRiskAssignmentResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info">Parameter Code</th>
			<th class="info">Parameter Description</th>
			<th class="info">Parameter Risk Value</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${DYNAMICRESULTLIST}">
			<tr>
				<td class="updateOrDeleteDynamicParamCode">${parameterList['SUBPARAMETERCODE']}</td>
				<td>${parameterList['SUBPARAMETERDESCRIPTION']}</td>
				<td>
					<select class="form-control input-sm" style="width: 50%">
						<option value="1" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '1'}">selected="selected"</c:if>>1-LOW</option>
						<option value="2" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '2'}">selected="selected"</c:if>>2-MEDIUM</option>
						<option value="3" <c:if test="${parameterList['SUBPARAMETERRISKVALUE'] eq '3'}">selected="selected"</c:if>>3-HIGH</option>
					</select>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>