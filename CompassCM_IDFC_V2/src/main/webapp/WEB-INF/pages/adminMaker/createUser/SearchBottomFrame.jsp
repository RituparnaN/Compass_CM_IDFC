<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="createUser"/>
<c:set var="MODULENAME" value="createUser"/>
<c:set var="UNQID" value="${UNQID}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var userCreated = '${USERCREATED}';
		if(userCreated == '0'){
			$("#userCode").val("");
			$("#userPass").val("");
			$("#firstName").val("");
			$("#lastName").val("");
			$("#emailId").val("");
			$("#mobileNo").val("");
			$("#designation").val("");
			$("#accountExpiryDate").val("");
			$("#employeeCode").val("");
			$("#departmentCode").prop('selectedIndex',0);
			$("#branchCode").prop('selectedIndex',0);
			//$("#groupCode").prop('selectedIndex',0);
			alert("User successfully created.");
		}/* else{
			alert("User already exists.");
		} */
		
		var tableClass = 'createUser${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>

<table class="table table-bordered table-striped searchResultGenericTable createUser${UNQID}" id="userSearchResultTable">
	<thead>
		<tr>
			<th class="info no-sort">&nbsp;</th>
			<th class="info">User Code</th>
			<th class="info">Employee Code</th>
			<th class="info">User Role</th>
			<th class="info">User Name</th>
			<th class="info">Email ID</th>
			<!-- <th class="info">Mobile No</th>
			<th class="info">Designation</th> -->
			<th class="info">Checker Status</th>
			<th class="info">Account Enabled</th>
			<!-- <th class="info">Account Expired</th> -->
			<th class="info">Account Dormant</th>
			<th class="info">Account Deleted</th>
			<th class="info">Account Locked</th>
			<th class="info">Maker Id</th>
			<th class="info">Creation Time</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="searchUser" items="${SEARCHEDUSER}">
			<tr>
				<td class="no-sort">
					<input type="checkbox" class="checkbox-check-one" value="${searchUser['USERCODE']},${searchUser['TABLE']},${searchUser['MAKERCODE']}"/>
				</td>
				<td>${searchUser['USERCODE']}</td>
				<td>${searchUser['EMPLOYEECODE']}</td>
				<td>${searchUser['GROUPCODE']}</td>
				<td>${searchUser['USERNAME']}</td>
				<td>${searchUser['EMAILID']}</td>
				<%-- <td>${searchUser['MOBILENO']}</td>
				<td>${searchUser['DESIGNATION']}</td> --%>
				<td>${searchUser['CHECKER']}</td>
				<td>${searchUser['ACCOUNTENABLE']}</td>
				<td>${searchUser['ACCOUNTDORMANT']}</td>
				<%-- <td>${searchUser['ACCOUNTEXPIRED']}</td> --%>
				<td>${searchUser['ACCOUNTDELETED']}</td>
				<td>${searchUser['ACCOUNTLOCKED']}</td>
				<td>${searchUser['MAKERID']}</td>
				<td>${searchUser['CREATIONTIME']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>