<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'missingFieldsTemplate${UNQID}';
		compassDatatable.construct(tableClass, "MissingFieldsTemplate", false);
		compassDatatable.enableCheckBoxSelection();
		
	});
</script>
<table class="table table-bordered table-striped searchResultGenericTable missingFieldsTemplate${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="missingFieldsTemplate${UNQID}" id="missingFieldsTemplate${UNQID}" />
			</th>
			<c:forEach var="colHeader" items="${resultData['HEADER']}">
				<th class="info" id="${colHeader}">${colHeader}</th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['RECORDDATA']}">
			<tr>
				<td style="text-align: center;"><input type="checkbox"></td>
				<c:forEach var="field" items="${record}">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>