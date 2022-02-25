<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var tableClass = 'addAccountToGroupTable';
		compassDatatable.construct(tableClass, "Search Account Result", false);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped addAccountToGroupTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;" width="5%">
				<input type="checkbox" class="checkbox-check-all" compassTable="addAccountToGroup" id="addAccountToGroup" />
			</th>
			<th class="info" width="10%">Account No</th>
			<th class="info" width="13%">Customer Id</th>
			<th class="info" width="25%">Customer Name</th>
			<th class="info" width="10%">Branch Code</th>
			<th class="info" width="12%">Product Code</th>
			<th class="info" width="10%">Account Opened Date</th>
			<th class="info" width="15%">Risk Rating</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${RESULTDATA}">
			<tr>
				<td style="text-align: center;"><input type="checkbox"> </td>
				<td>${record['ACCOUNTNO']}</td>
				<td>${record['CUSTOMERID']}</td>
				<td>${record['CUSTOMERNAME']}</td>
				<td>${record['BRANCHCODE']}</td>
				<td>${record['PRODUCTCODE']}</td>
				<td>${record['ACCOUNTOPENEDDATE']}</td>
				<td>${record['RISKRATING']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
