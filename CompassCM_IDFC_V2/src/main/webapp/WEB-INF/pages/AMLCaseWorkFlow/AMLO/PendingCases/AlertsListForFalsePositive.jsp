<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var caseNo = '${caseNo}';
		var searchButton = '${searchButton}';
		var tableClass = 'alertsListForFalsePositive${UNQID}';
		compassDatatable.construct(tableClass, "AlertsListForFalsePositive", true);
		compassDatatable.enableCheckBoxSelection();
		
		$(".alertsListForFalsePositive"+id).children("tbody").children("tr").each(function(){
			var tdVal = $(this).children("td:nth-child(1)").html();
			$(this).children("td:nth-child(1)").html("<a href='javascript:void(0)' class='refNoLink"+id+"'>"+tdVal+"</a>");
		});
		
		$(".refNoLink"+id).click(function(){
			var refNo = ($(this).html());
			//alert(refNo);
			//alert(caseNo);
			$("#compassGenericModal").modal("show");
			$("#compassGenericModal-title").html("Update Details");
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getDetailsForUpdatingFalsePositive",
				cache: false,
				type: "POST",
				data: "caseNo="+caseNo+"&refNo="+refNo+"&searchButton="+searchButton,
				success: function(res){
					$("#compassGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	});
</script>
<style type="text/css">
	.refNoLink${UNQID}{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<table class="table table-bordered table-striped searchResultGenericTable alertsListForFalsePositive${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<%-- <th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="alertsListForFalsePositive${UNQID}" id="alertsListForFalsePositive${UNQID}" />
			</th>
			 --%>
			<c:forEach var="TH" items="${resultData['HEADER']}">
				<c:set var="colArray" value="${f:split(TH, '.')}" />
				<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['RECORDDATA']}">
			<tr>
				<!-- <td style="text-align: center;"><input type="checkbox"></td> -->
				<c:forEach var="field" items="${record}">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>