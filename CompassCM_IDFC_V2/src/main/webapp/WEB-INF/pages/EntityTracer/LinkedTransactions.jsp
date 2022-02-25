<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>    

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'linkedTransactions'+id;
		compassDatatable.construct(tableClass, "Linked Transactions", true);
	});
</script>
<c:set var="RECORDCOUNT" value="${f:length(LINKEDTXNS)}" scope="page"/>
<c:choose>
	<c:when test="${RECORDCOUNT > 0}">
		<table class="table table-striped table-bordered searchResultGenericTable linkedTransactions">
			<thead>
				<c:forEach var="recordDetails" items="${LINKEDTXNS}" begin="0" end="0">
					<tr>
						<c:forEach var="fieldDetails" items="${recordDetails}">
							<c:set var="colArray" value="${f:split(fieldDetails.key, '.')}" />
							<c:set var="colArrayCnt" value="${f:length(colArray)}" />
							<th id="${colArray[colArrayCnt-1]}"><spring:message code="${fieldDetails.key}"/></th>
						</c:forEach>
					</tr>
				</c:forEach>
			</thead>
			<tbody>
				<c:forEach var="recordDetails" items="${LINKEDTXNS}">
					<tr>
						<c:forEach var="fieldDetails" items="${recordDetails}">
							<c:choose>
								<c:when test="${fieldDetails.value ne ' ' and fieldDetails.value ne ''}">
									<td data-toggle="tooltip" data-placement="auto"  title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
								</c:when>
								<c:otherwise>
									<td>${fieldDetails.value}</td>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</c:when>
	<c:otherwise>
	<br/>
		<center>
			No ${tab} Record Found
		</center>
		<br/>
	</c:otherwise>
</c:choose>