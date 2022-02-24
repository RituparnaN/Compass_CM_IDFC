<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'alertBenchMarksListTable'+id;
		compassDatatable.construct(tableClass, "AlertBenchMarksList", true);
		compassDatatable.enableCheckBoxSelection();
		
	});
	
	function openAlertSerialIdDetails(elm, alertSerialNo, alertApprovalStatus, parameterType){
		var id = '${UNQID}';
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertName = '${alertName}';
		/*
		var alertSerialNo = $(elm).html();
		var alertApprovalStatus = '';		
		$(".alertBenchMarksListTable"+id).children("tbody").children("tr").each(function(){
			alertApprovalStatus = $(this).children("td:nth-child(2)").html();
		});
		*/
		$("#compassGenericModal").modal("show");

		$("#compassGenericModal-title").html(alertId + " - "+"Save/Generate Alert Parameters");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertBenchMarkDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&alertApprovalStatus="+alertApprovalStatus+"&parameterType="+parameterType,
			type: 'POST',
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	function openAlertApprovalStatusDetails(elm, alertSerialNo, alertApprovalStatus){
		var id = '${UNQID}';
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertName = '${alertName}';
		/*
		var alertApprovalStatus = $(elm).html();
		var alertSerialNo = '';		
		$(".alertBenchMarksListTable"+id).children("tbody").children("tr").each(function(){
			alertSerialNo = $(this).children("td:nth-child(1)").html();
		});
		*/
		
		$("#compassGenericModal").modal("show");

		$("#compassGenericModal-title").html("Alert Approval Status");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertBenchMarkStatusDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&alertApprovalStatus="+alertApprovalStatus,
			type: 'POST',
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
</script>
<style type="text/css">
	.alertSerialIdHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	.alertApprovalStatusHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div id="searchResultGenericDiv">
	<table class="table table-striped table-bordered alertBenchMarksListTable${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<c:forEach var="colHeader" items="${resultData['HEADER']}">
					<th class="info" id="${colHeader}">${colHeader}</th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="record" items="${resultData['DATA']}">
				<c:if test="${f:length(record) > 0}">
				<c:if test="${record[2] eq 'SIMULATION'}">
					<tr style="background-color: #8CEDF0; ">			
						<c:forEach var="field" items="${record}">	
							<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
						</c:forEach>
					</tr>
				</c:if>
				<c:if test="${record[1] eq 'EXISTING' && record[2] ne 'SIMULATION'}">
					<!-- <tr style="background-color:#87CEFA; "> -->
					<tr>			
						<c:forEach var="field" items="${record}">	
							<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
						</c:forEach>
					</tr>
				</c:if>
				<c:if test="${f:contains(record[1],'PENDING')}">
					<tr style="background-color: #F0E68C; ">			
						<c:forEach var="field" items="${record}">	
							<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
						</c:forEach>
					</tr>
				</c:if>
				
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>