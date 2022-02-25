<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tableClass = 'dynamicParameterListTable';
	compassDatatable.construct(tableClass, "Dynamic Risk Parameters", true);
	compassDatatable.enableCheckBoxSelection();
});
</script>
<table class="table table-bordered table-striped dynamicParameterListTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th style="text-align: center;" class="info no-sort"><input type="checkbox" class="checkbox-check-all"></th>
			<th class="info">Parameter Id</th>
			<th class="info">Parameter Name</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${DYNAMICPARAMLIST}">
			<tr>
				<td style="text-align: center;">
					<input type="checkbox" id="${parameterList['RISKPARAMETERID']}" <c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y'}">checked="checked"</c:if> >
				</td>
				<td>${parameterList['RISKPARAMETERID']}</td>
				<td>${parameterList['RISKPARAMETERNAME']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>