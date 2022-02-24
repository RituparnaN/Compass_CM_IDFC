<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var userRole = '${userRole}';
		var tableClass = 'reportingUsersMappingTable${UNQID}';
		compassDatatable.construct(tableClass, "Reporting Users Mapping", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped reportingUsersMappingTable${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="reportingUsersMappingTable" id="reportingUsersMappingTable">
			</th>
			<th class="info" style="text-align: center;">Is Enabled</th>
			<th class="info" style="text-align: center;">User Code</th>
			<th class="info" style="text-align: center;">Reporting User Code</th>
			<th class="info" style="text-align: center;">Reviewer's Code</th>
			<th class="info" style="text-align: center;">Status</th>
		</tr>
	</thead>
	<c:if test="${(userRole eq 'ROLE_ADMIN' || userRole eq 'ROLE_AMLO')}">
		<tbody>
			<c:forEach var="dataList" items="${RESULTDATA}">
			<tr>
				<td class="no-sort" style="text-align: center;">
					<input type="checkbox"/>	
				</td>
				<td class="no-sort" style="text-align: center;">
					<%-- <input type="checkbox" value="${dataList['ISENABLED']}" <c:if test="${dataList['ISENABLED'] eq 'Y'}" >checked="checked"</c:if>/> --%>	
					<select class="form-control input-sm " style="width: 50%; ">
						<option value="Y" <c:if test="${dataList['ISENABLED'] eq 'Y'}" >selected</c:if>>Yes</option>
						<option value="N" <c:if test="${dataList['ISENABLED'] eq 'N'}" >selected</c:if>>No</option>
					</select>
				</td>
				<td style="text-align: center;">${dataList['USERCODE']}</td>
				<td style="text-align: center;">
					<select class="form-control input-sm " style="width: 50%; ">
					<c:forEach var="reportingUserCode" items="${WHOLELIST_REPORTINGUSERCODE}">
						<option value="${reportingUserCode}" <c:if test="${reportingUserCode eq dataList['REPORTINGUSERCODE']}">selected</c:if>>${reportingUserCode}</option>
					</c:forEach>
					</select>
				</td>
				<td style="text-align: center;">
					<select class="form-control input-sm " style="width: 50%; ">
					<c:forEach var="reviewersCode" items="${WHOLELIST_REVIEWERSCODE}">
						<option value="${reviewersCode}" <c:if test="${reviewersCode eq dataList['REVIEWERSCODE']}">selected</c:if>>${reviewersCode}</option>
					</c:forEach>
					</select>
				</td>
				<td style="text-align: center;">${dataList['STATUS']}</td>
			</tr>
			</c:forEach>
		</tbody>
	</c:if>
	<c:if test="${(userRole eq 'ROLE_MLRO' || userRole eq 'ROLE_MLROL1' || userRole eq 'ROLE_MLROL2')}">
		<tbody>
			<c:forEach var="dataList" items="${RESULTDATA}">
			<tr>
				<td class="no-sort" style="text-align: center;">
					<input type="checkbox"/>	
				</td>
				<td class="no-sort" style="text-align: center;">
					<c:if test="${dataList['ISENABLED'] eq 'Y'}">Yes</c:if><c:if test="${dataList['ISENABLED'] eq 'N'}">No</c:if>
				</td>
				<td style="text-align: center;">${dataList['USERCODE']}</td>
				<td style="text-align: center;">
					${dataList['REPORTINGUSERCODE']}
					<%-- <c:forEach var="dataList1" items="${WHOLELIST}">
						<c:if test="${dataList1['USERCODE'] eq dataList['USERCODE']}">
							${dataList1['REPORTINGUSERCODE']}
						</c:if>
					</c:forEach> --%>
				</td>
				<td style="text-align: center;">
					${dataList['REVIEWERSCODE']}
				</td>
				<td style="text-align: center;">${dataList['STATUS']}</td>
			</tr>
			</c:forEach>
		</tbody>
	</c:if>
</table>