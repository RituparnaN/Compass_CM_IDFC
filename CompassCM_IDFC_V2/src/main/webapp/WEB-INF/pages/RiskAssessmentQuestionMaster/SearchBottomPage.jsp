<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var tableClass = '${MODULETYPE}${UNQID}';
		
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
	});
	
	function getRiskAssessmentQuestionDetails(questionId, status, questionVersion, assessmentSection){
		var searchButton = '${submitButton}';
		status = (status.toUpperCase() == "PENDING" ? "P" : status.toUpperCase() == "APPROVED" ? "A" : status.toUpperCase() == "REJECTED" ? "R" : "");
		//alert(assessmentSection);

		$.ajax({
			url: "${pageContext.request.contextPath}/cmAdmin/getQuestionDetails",
			cache: false,
			type: "GET",
			data: {questionId:questionId,status:status,searchButton:searchButton,questionVersion:questionVersion,assessmentSection:assessmentSection},
			success: function(res){
				//alert(res);
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Risk Assessment Question - "+questionId);
				$("#compassCaseWorkFlowGenericModal-body").html(res);
				
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
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