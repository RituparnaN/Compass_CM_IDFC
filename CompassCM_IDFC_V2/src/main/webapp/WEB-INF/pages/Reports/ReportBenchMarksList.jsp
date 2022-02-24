<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'reportBenchMarksListTable'+id;
		compassDatatable.construct(tableClass, "ReportBenchMarksList", true);
		compassDatatable.enableCheckBoxSelection();
	});

	function openReportSerialIdDetails(elm){
		var group = '${group}';
		var viewType = '${viewType}';
		var reportId = '${reportId}';
		var reportName = '${reportName}';
		var reportSerialNo = $(elm).html();
		var id = '${UNQID}';
		$("#compassMediumGenericModal").modal("show");
		//$("#compassGenericModal-title").html("Report Parameters");
		//$("#compassGenericModal-title").html(reportId);
		$("#compassMediumGenericModal-title").html(reportId + " - "+"Save/Generate Report");
		$("#compassMediumGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/common/getReportBenchMarkDetails" ,
			cache: false,
			data: "reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&group="+group,
			type: 'POST',
			success: function(res){
				// alert(res);
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
</script>
<style type="text/css">
	.reportSerialIdHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	
</style>
<div id="searchResultGenericDiv">
	<table class="table table-striped table-bordered reportBenchMarksListTable${UNQID}" style="margin-bottom: 0px;">
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