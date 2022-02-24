<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'userHierarchyMappingTable${UNQID}';
		compassDatatable.construct(tableClass, "User Hierarchy Mapping", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
<table class="table table-bordered table-striped userHierarchyMappingTable${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="userHierarchyMappingTable" id="userHierarchyMappingTable"></th>
			<c:if test="${mappingType eq 'AMLUserAMLO'}">
				<th class="info">AMLUser Code</th>
				<th class="info">AMLO Code</th>
			</c:if>
			<c:if test="${mappingType eq 'AMLOMLRO'}">
				<th class="info">AMLO Code</th>
				<th class="info">MLRO Code</th>
			</c:if>
		</tr>
	</thead>
	<tbody>
			<c:forEach var="dataList" items="${RESULTDATA}">
			<tr>
				<td class="no-sort" style="text-align: center;">
					<input type="checkbox" value="${dataList['ISENABLED']}" <c:if test="${dataList['ISENABLED'] eq 'Y'}" >checked="checked"</c:if>/>	
				</td>
				<c:if test="${mappingType eq 'AMLUserAMLO'}">
					<td>${dataList['AMLUSERCODE']}</td>
					<td>
						<select class="form-control input-sm " style="width: 50%; ">
							<c:forEach var="amloList" items="${AMLOLIST}">
								<option value="${amloList.key}" <c:if test="${dataList.AMLOCODE eq amloList.key}">selected="selected"</c:if>>
									${amloList.value}</option>
							</c:forEach>
						</select>
					</td>
				</c:if>
				<c:if test="${mappingType eq 'AMLOMLRO'}">
					<td>${dataList['AMLOCODE']}</td>
					<td>
						<select class="form-control input-sm " style="width: 50%; ">
							<c:forEach var="mlroList" items="${MLROLIST}">
								<option value="${mlroList.key}" <c:if test="${dataList.MLROCODE eq mlroList.key}">selected="selected"</c:if>>
									${mlroList.value}</option>
							</c:forEach>
						</select>
					</td>
				</c:if>
			</tr>
			</c:forEach>
	</tbody>
</table>