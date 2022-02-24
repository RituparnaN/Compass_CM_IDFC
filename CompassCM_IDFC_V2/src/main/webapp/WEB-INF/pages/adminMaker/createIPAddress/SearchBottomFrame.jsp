<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="createIPAddress"/>
<c:set var="MODULENAME" value="createIPAddress"/>
<c:set var="UNQID" value="${UNQID}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var ipCreated = '${IPCREATED}';
		if(ipCreated == '0'){
			$("#systemName").val("");
			alert("IPAddress successfully created");
		}
		
		var tableClass = 'createIPAddress${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped searchResultGenericTable createIPAddress${UNQID}" id="ipSearchResultTable">
	<thead>
		<tr>
			<th class="info no-sort">&nbsp;</th>
			<th class="info">IPAddress</th>
			<th class="info">System Name</th>
			<th class="info">Checker Checked?</th>
			<th class="info">IP Enabled</th>
			<th class="info">Created By</th>
			<th class="info">Creation Time</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="searchIP" items="${SEARCHEDIP}">
			<tr>
				<td class="no-sort">
					<input type="checkbox" class="checkbox-check-one" value="${searchIP['IPADDRESS']},${searchIP['TABLE']},${searchIP['MAKERCODE']}"/>
				</td>
				<td>${searchIP['IPADDRESS']}</td>
				<td>${searchIP['SYSTEMNAME']}</td>
				<td>${searchIP['IPSTATUS']}</td>
				<td>${searchIP['ISENABLED']}</td>
				<td>${searchIP['UPDATEDBY']}</td>
				<td>${searchIP['UPDATETIMESTAMP']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>