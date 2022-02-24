<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'cddMasterModulesDetailsTable${UNQID}';
		compassDatatable.construct(tableClass, "CDDMasterModules", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped searchResultGenericTable cddMasterModulesDetailsTable${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<c:set var="colArray" value="${f:split(colHeader, '.')}" />
			<c:forEach var="colHeader" items="${resultData['HEADER']}">
			<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<th class="info no-sort" style="text-align: center;" id="${colArray[colArrayCnt+1]}"><spring:message code="${colHeader}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['RECORDDATA']}">
			<tr>
				<c:forEach var="field" items="${record}" begin="0">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>