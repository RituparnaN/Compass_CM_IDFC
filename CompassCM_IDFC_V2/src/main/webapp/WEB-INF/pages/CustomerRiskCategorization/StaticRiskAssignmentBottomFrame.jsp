<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var searchParamId = '${searchParamId}';
	var isRangeRequired = '${isRangeRequired}';
	var tableClass = 'staticRiskAssignmentResultTable';
	compassDatatable.construct(tableClass, "Static Risk Assignment", true);
	
	/* $(".updateOrDeleteParamCode").click(function(){
		if(isRangeRequired == 'Y'){
			var paramCode = $(this).html();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchParamCodeToDeleteRiskParameter",
				cache: false,
				type: "POST",
				data: "paramCode="+paramCode+"&searchParamId="+searchParamId,
				success: function(res){
						$("#compassCaseWorkFlowGenericModal").modal("show");
						$("#compassCaseWorkFlowGenericModal-title").html("Static Risk Parameter Details");
						$("#compassCaseWorkFlowGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}
	}); */
});
</script>
<table class="table table-bordered table-striped staticRiskAssignmentResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info">Parameter Code</th>
			<th class="info">Parameter Description</th>
			<th class="info">Parameter Risk Value</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${STATICRESULTLIST}">
			<tr>
				<td>${parameterList['SUBPARAMETERCODE']}</td>
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