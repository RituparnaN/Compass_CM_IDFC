<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'userALertMapping${UNQID}';
		compassDatatable.construct(tableClass, "UserALertMapping", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<form name="userAlertMappingBottomFrame" id="userAlertMappingBottomFrame${UNQID}">
<input type = "hidden" name = "selectedMappingType" id = "selectedMappingType" value = "${mappingType}" />
<input type = "hidden" name = "selectedUserLevel" id = "selectedUserLevel" value = "${userLevel}" />
<input type = "hidden" name = "selectedUserCode" id = "selectedUserCode" value = "${userCode}" />
</form>
<table class="table table-bordered table-striped searchResultGenericTable userALertMapping${UNQID}" style="margin-bottom: 0px;">
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
				<td style="text-align: center;">
					<input type="checkbox" <c:if test="${record['ISSELECTED'] eq 'Y'}">checked="checked"</c:if>>
				</td>
				<c:forEach var="field" items="${record}" begin="1">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>