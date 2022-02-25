<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	/* var id = '${UNQID}'; */
	var tableClass = 'staticCRCAssignmentResultTable';
	compassDatatable.construct(tableClass, "Static CRC Assignment", true);
});
</script>
<table class="table table-bordered table-striped staticCRCAssignmentResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info">Parameter Code</th>
			<th class="info">Parameter Description</th>
			<th class="info">Parameter Risk Value</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${RESULTLIST}">
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