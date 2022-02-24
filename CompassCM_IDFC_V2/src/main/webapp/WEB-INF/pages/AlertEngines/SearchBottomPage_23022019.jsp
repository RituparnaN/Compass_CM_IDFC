<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="COLUMNDETAILS" value="${SEARCHRESULT['COLUMNDETAILS']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = "${UNQID}";
		var tableClass = '${MODULETYPE}${UNQID}';
		var columnDetails = [];
		<c:forEach items = "${COLUMNDETAILS}" var = "colName">
			var obj = {};
			obj["columnName"] = "${colName.key}";
			obj["isEnable"] = "${colName.value}";
			columnDetails.push(obj);
		</c:forEach>
		
		var resetColumnFlag = true;
		var tableClass = '${MODULETYPE}${UNQID}';
		var numberOfFixedColumn = 2;
		compassDatatable.construct(tableClass, "${MODULENAME}", true,"${MODULETYPE}",columnDetails,resetColumnFlag, numberOfFixedColumn);
		//compassDatatable.construct(tableClass, "${MODULENAME}", true);
	});
	/*
	function openAlertTransactions(elm){
		var alertNo = $(elm).parent("tr").children("td:nth-child(2)").html();
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html("Linked Transactions");
		alert(tdValue);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactionsForAlerts",
			cache: false,
			type: "GET",
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

<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" >
		<thead>
			<tr>
				<c:forEach var="TH" items="${HEADER}">
					<c:set var="colArray" value="${f:split(TH, '.')}" />
					<c:set var="colArrayCnt" value="${f:length(colArray)}" />
					<th id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RECORD" items="${DATA}">
				<tr>
					<c:forEach var="TD" items="${RECORD}">
						<c:choose>
							<c:when test="${TD ne ' ' and TD ne ''}">
								<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
							</c:when>
							<c:otherwise>
								<td>${TD}</td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>