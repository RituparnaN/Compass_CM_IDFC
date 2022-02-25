<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var tableClass = 'staticRiskWeightageTable';
	compassDatatable.construct(tableClass, "Static Risk Weightage", true);
});
</script>
<table class="table table-bordered table-striped staticRiskWeightageTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th>Parameter Id </th>
			<th>Parameter Name</th>
			<th>Weightage</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${STATICPARAMLIST}">
			<tr>
				<td>${parameterList['RISKPARAMETERID']}</td>
				<td>${parameterList['RISKPARAMETERNAME']}</td>
				<td>
					<select class="form-control input-sm" style="width: 50%" <c:if test="${parameterList['ISRISKPARAMETERMARKED'] ne 'Y'}">disabled="disabled"</c:if>>
						<option value="1" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '1'}">selected="selected"</c:if>>1</option>
						<option value="2" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '2'}">selected="selected"</c:if>>2</option>
						<option value="3" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '3'}">selected="selected"</c:if>>3</option>
						<option value="4" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '4'}">selected="selected"</c:if>>4</option>
						<option value="5" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '5'}">selected="selected"</c:if>>5</option>
					</select>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>