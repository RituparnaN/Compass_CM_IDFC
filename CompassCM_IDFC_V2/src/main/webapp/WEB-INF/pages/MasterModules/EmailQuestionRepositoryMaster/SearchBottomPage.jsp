<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = "${UNQID}";
		var submitButton = "${submitButton}";
		var tableClass = '${MODULETYPE}${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		$("#addNewQuestion"+id).click(function(){
		$.ajax({
			url : "${pageContext.request.contextPath}/common/addNewEmailQuestions",
			type : "GET",
			data : {submitButton:submitButton},
			cache : false,	
			success : function(resData){
				$("#compassMediumGenericModal").modal('show');
				$("#compassMediumGenericModal-title").html("Add Email Question");
				$("#compassMediumGenericModal-body").html(resData);
			},
			error : function(a,b,c){
			 alert(a,b,c);
			}
		});
	});
		
		
		
	});
	function getEmailQuestion(elm){
		var emailQuestionID = $(elm).html();
		var submitButton = "${submitButton}";
		$.ajax({
			url : "${pageContext.request.contextPath}/common/getEmailQuestionForEdit",
			data : {emailQuestionID:emailQuestionID,submitButton:submitButton},
			type : "GET",
			cache : false,	
			success : function(resData){
				$("#compassMediumGenericModal").modal('show');
				$("#compassMediumGenericModal-title").html("Edit Email Question");
				$("#compassMediumGenericModal-body").html(resData);
			},
			error : function(a,b,c){
			 alert(a,b,c);
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
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button   id="addNewQuestion${UNQID}" class="btn btn-success btn-sm">Add New Question</button>
		</div>
	</div>
</div>