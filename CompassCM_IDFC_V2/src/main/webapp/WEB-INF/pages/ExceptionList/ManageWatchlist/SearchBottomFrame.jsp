<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'manageWatchList${UNQID}';
		compassDatatable.construct(tableClass, "ManageWatchList", true);
		compassDatatable.enableCheckBoxSelection();
		
		$(".manageWatchList"+id).children("tbody").children("tr").each(function(){
			var tdVal = $(this).children("td:nth-child(2)").html();
			$(this).children("td:nth-child(2)").html("<a href='javascript:void(0)' class='listCodeLink'>"+tdVal+"</a>");
		});
		
		$(".listCodeLink").click(function(){
			var listCode = ($(this).html());
			var url = "${pageContext.request.contextPath}/common/watchlistDetails?listCode="+listCode;
			window.open(url,'Watchlist Details','height=600px,width=1000px');
		});
	});
</script>
<style type="text/css">
	.listCodeLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<table class="table table-bordered table-striped manageWatchList${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="manageWatchList${UNQID}" id="manageWatchList${UNQID}" />
			</th>
			<c:forEach var="TH" items="${resultData['HEADER']}">
				<c:set var="colArray" value="${f:split(TH, '.')}" />
				<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['DATA']}">
			<tr>
				<td style="text-align: center;"><input type="checkbox"> </td>
				<c:forEach var="field" items="${record}">
					<td>${field.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>
