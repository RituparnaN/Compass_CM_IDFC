<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'userReportMapping${UNQID}';
		compassDatatable.construct(tableClass, "UserReportMapping", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<form name="userReportMappingBottomFrame" id="userReportMappingBottomFrame${UNQID}">

<table class="table table-bordered table-striped searchResultGenericTable userReportMapping${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info sort" style="text-align: center;">
				IS ENABLED&nbsp;<input type="checkbox" class="checkbox-check-all" compassTable="userReportMappingTable" id="userReportMappingIsEnabled${UNQID}" >
			</th>
			<c:forEach var="colHeader" items="${resultData['HEADER']}">
				<c:if test="${colHeader ne 'ISENABLED'}">
					<th class="info sort" style="text-align: center;" id="${colHeader}${UNQID}">${colHeader}</th>
				</c:if>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['RECORDDATA']}">
			<tr>
				<td style="text-align: center;">
					<input type="checkbox" <c:if test="${record['ISENABLED'] eq 'Y'}" >checked="checked"</c:if>>
				</td>
				<c:forEach var="field" items="${record}" begin="1">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>
</form>