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
	
	function gettingRuleStatus(elm){
		var CRPRuleStatus = $(elm).closest("tr").children().eq(3).text();
		if(CRPRuleStatus == "EXISTING"){
			CRPRuleStatus = "APPROVED";
		}else{
			CRPRuleStatus = "PENDING FOR APPROVAL";
		}
		return CRPRuleStatus;
	};
	
	function openCRPRulesIDDetails(elm){
		var reportId = $(elm).html();
		var CRPRuleStatus = gettingRuleStatus(elm);
		//var mywin = window.open("${pageContext.request.contextPath}/admin/updateCRPRule?ruleID="+reportId,'CRPRuleUpdateFrame','height=700,width=1320,scrollbars=1,Full=Y,resizable=Yes');
		var updateRuleWindow = window.open("${pageContext.request.contextPath}/admin/updateRule?ruleID="+reportId+"&CRPRuleStatus="+CRPRuleStatus,'CRPRuleUpdateFrame','height=900px,width=1600px,scrollbars=1,Full=Y,resizable=Yes');
		updateRuleWindow.onload = function() {
			updateRuleWindow.onunload =  function () {
				let flag = $("#flagFromUpdateRuleWindow").val();
				console.log(flag);
				if(flag == "closingWindowAfterUpdatingRule"){
					customerRiskRuleSearchInit();	
				}
            };
      	};
	}
	
	function customerRiskRuleSearchInit(){
		var submitButton = "${submitButton}";
		$("#"+submitButton).click();
	}
	
	function openModelForChanginStatus(elm){
		var ruleID = $(elm).html();
		var submitButton = "${submitButton}";
		var CRPRuleStatus = gettingRuleStatus(elm);
		$("#compassMediumGenericModal").modal('show');
		$("#compassMediumGenericModal-title").html("Approve/Reject Rule");
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/openModelForChanginRuleStatus",
			data : "ruleID="+ruleID+"&submitButton="+submitButton+"&CRPRuleStatus="+CRPRuleStatus,
			type : "POST",
			cache : false,	
			success : function(resData){
				$("#compassMediumGenericModal-body").html(resData);
			},
			error : function(a,b,c){
			 alert(a,b,c);
			}
		});
		
		
	}
</script>

<style type="text/css">
	.CRPRuleHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	
</style>
<div id="searchResultGenericDiv">
	<input type ="hidden" id = "flagFromUpdateRuleWindow" />
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