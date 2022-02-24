<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alerted Transaction Details</title>
<jsp:include page="../../tags/staticFiles.jsp"/>


<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'alertLinkedTransactions'+id;
		compassDatatable.construct(tableClass, "Alert Linked Transactions", true);
	});
	/*
	function openAlertedTransactions(elm){
		var alertNo = $(elm).parent("tr").children("td:nth-child(1)").html();
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html("Linked Transactions");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactionsForAlerts",
			cache: false,
			type: "POST",
			data: "alertNo="+alertNo,
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	*/
</script>
<c:set var="RECORDCOUNT" value="${f:length(LINKEDTXNS)}" scope="page"/>
<c:choose>
	<c:when test="${RECORDCOUNT > 0}">
		<table class="table table-striped table-bordered searchResultGenericTable alertLinkedTransactions${UNQID}">
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
</head>
</html>