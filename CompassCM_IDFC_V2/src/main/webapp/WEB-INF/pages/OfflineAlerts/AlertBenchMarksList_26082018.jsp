<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'alertBenchMarksListTable'+id;
		compassDatatable.construct(tableClass, "AlertBenchMarksList", true);
		compassDatatable.enableCheckBoxSelection();
	});

	function openAlertSerialIdDetails(elm){
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertName = '${alertName}';
		var alertSerialNo = $(elm).html();
		var id = '${UNQID}';
		$("#compassGenericModal").modal("show");
		//$("#compassGenericModal-title").html("IBA Alert Parameters");
		// $("#compassGenericModal-title").html(alertId);
		$("#compassGenericModal-title").html(alertId + " - "+"Save/Generate Alert Parameters");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertBenchMarkDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo,
			type: 'POST',
			success: function(res){
				// alert(res);
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
				<tr>				
					<c:forEach var="field" items="${record}">
						<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
					</c:forEach>
				</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>