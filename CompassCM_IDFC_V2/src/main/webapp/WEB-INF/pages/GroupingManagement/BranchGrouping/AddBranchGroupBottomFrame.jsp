<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var tableClass = 'addBranchToGroupTable';
		compassDatatable.construct(tableClass, "Search Branch Result", false);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped addBranchToGroupTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;" width="5%">
				<input type="checkbox" class="checkbox-check-all" compassTable="addBranchToGroup" id="addBranchToGroup" />
			</th>
			<th class="info" width="10%">Branch Code</th>
			<th class="info" width="25%">Branch Name</th>
			<th class="info" width="13%">Branch Area</th>
			<th class="info" width="10%">Branch Address1</th>
			<th class="info" width="12%">Branch Address2</th>
			<th class="info" width="10%">Branch Address3</th>
			<th class="info" width="15%">Branch Address4</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${RESULTDATA}">
			<tr>
				<td style="text-align: center;"><input type="checkbox"> </td>
				<td>${record['BRANCHCODE']}</td>
				<td>${record['BRANCHNAME']}</td>
				<td>${record['BRANCHAREA']}</td>
				<td>${record['BRANCHADDR1']}</td>
				<td>${record['BRANCHADDR2']}</td>
				<td>${record['BRANCHADDR3']}</td>
				<td>${record['BRANCHADDR4']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
