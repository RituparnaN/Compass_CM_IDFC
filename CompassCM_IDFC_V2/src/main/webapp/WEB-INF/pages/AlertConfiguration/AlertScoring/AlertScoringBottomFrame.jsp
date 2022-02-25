<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var searchParamId = '${searchParamId}';
	var tableClass = 'compassAlertScoreAssignmentResultTable';
	compassDatatable.construct(tableClass, "Alert Score Assignment", true);
	
	});
</script>
<table class="table table-bordered table-striped compassAlertScoreAssignmentResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info">Parameter Code</th>
			<th class="info">Parameter Description</th>
			<th class="info">Parameter Score Value</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="parameterList" items="${RESULTLIST}">
			<tr>
				<td>${parameterList['CODE']}</td>
				<td>${parameterList['DESCRIPTION']}</td>
				<td>
					<select class="form-control input-sm" style="width: 50%">
						<c:forEach var="i" begin="1" end="10">
							<option value="${i}" <c:if test="${parameterList['SCOREVALUE'] eq i}">selected="selected"</c:if>>${i}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>