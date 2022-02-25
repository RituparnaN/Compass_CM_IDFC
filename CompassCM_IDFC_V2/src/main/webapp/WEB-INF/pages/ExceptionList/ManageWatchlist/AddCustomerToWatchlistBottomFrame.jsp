<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var tableClass = 'addcustomerToWatchListTable';
		compassDatatable.construct(tableClass, "Search Customer Result", false);
		compassDatatable.enableCheckBoxSelection();
	});
</script>

<table class="table table-bordered table-striped addcustomerToWatchListTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;" width="5%">
				<input type="checkbox" class="checkbox-check-all" compassTable="addcustomerToWatchList" id="addcustomerToWatchList" />
			</th>
			<th class="info" width="10%">Customer ID</th>
			<th class="info" width="25%">Customer Name</th>
			<th class="info" width="13%">Customer Type</th>
			<th class="info" width="10%">Risk Rating</th>
			<th class="info" width="12%">Branch Code</th>
			<th class="info" width="10%">Is Minor</th>
			<th class="info" width="15%">Created On</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${RESULTDATA}">
			<tr>
				<td style="text-align: center;"><input type="checkbox"> </td>
				<td>${record['CUSTOMERID']}</td>
				<td>${record['CUSTOMERNAME']}</td>
				<td>${record['CUSTOMERTYPE']}</td>
				<td>${record['RISKRATING']}</td>
				<td>${record['BRANCHCODE']}</td>
				<td>${record['MINOR']}</td>
				<td>${record['CREATEDDATETIME']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
