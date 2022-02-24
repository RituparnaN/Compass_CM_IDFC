<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'caseReassignment${UNQID}';
		compassDatatable.construct(tableClass, "CaseReassignment", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<div>
	<table class="table table-bordered table-striped searchResultGenericTable caseReassignment${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th class="info no-sort" style="text-align: center;">
					<input type="checkbox" class="checkbox-check-all" compassTable="caseReassignment${UNQID}" id="caseReassignment${UNQID}" />
				</th>
				<c:forEach var="TH" items="${resultData['HEADER']}">
					<c:set var="colArray" value="${f:split(TH, '.')}" />
					<c:set var="colArrayCnt" value="${f:length(colArray)}" />
					<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="record" items="${resultData['RECORDDATA']}">
				<tr>
					<td>
						<input type="checkbox" class="checkbox-check-many" value="${record['CASENO']}" compassId="${record['CASENO']}" /> 
					</td>
					<c:forEach var="field" items="${record}">
						<td>${field.value}</td>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>