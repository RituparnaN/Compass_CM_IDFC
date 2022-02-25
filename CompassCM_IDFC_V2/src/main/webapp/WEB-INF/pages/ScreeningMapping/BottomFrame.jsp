<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	var tableClass = 'compassFieldScreeningMappingSerachResultTable';
	compassDatatable.construct(tableClass, "Screening Fields Mapping", true);
	compassDatatable.enableCheckBoxSelection();
});
</script>
<table class="table table-bordered table-striped compassFieldScreeningMappingSerachResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="compassFieldScreeningMappingSerachResultTable" id="compassFieldScreeningMappingSerachResultTable"></th>
			<th class="info">Source List</th>
			<th class="info">Source Field</th>
			<th class="info">Destination List</th>
			<th class="info">Destination Field</th>
			<th class="info">Rank</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="searchFieldList" items="${BOTTOMDATALIST}">
			<tr>
				<td class="no-sort" style="text-align: center;">
					<input type="checkbox" <c:if test="${searchFieldList['ISCHECKED'] eq 'true'}">checked="checked"</c:if>/>	
				</td>
				<td>${searchFieldList['IMPORTLIST']}</td>
				<td>${searchFieldList['IMPORTFIELD']}</td>
				<td>${searchFieldList['SCREENLIST']}</td>
				<td>${searchFieldList['SCREENFIELD']}</td>
				<td><select class="form-control input-sm" style="width: 50%">
						<c:forEach var="i" begin="50" end="100">
							<option value="${i}" <c:if test="${searchFieldList['SCORERANK'] eq i}">selected="selected"</c:if>>${i}</option>
						</c:forEach>
						
						<%--<option value="50" <c:if test="${searchFieldList['SCORERANK'] eq '50'}">selected="selected"</c:if>>50</option>
						<option value="60" <c:if test="${searchFieldList['SCORERANK'] eq '60'}">selected="selected"</c:if>>60</option>
						<option value="70" <c:if test="${searchFieldList['SCORERANK'] eq '70'}">selected="selected"</c:if>>70</option>
						<option value="80" <c:if test="${searchFieldList['SCORERANK'] eq '80'}">selected="selected"</c:if>>80</option>
						<option value="90" <c:if test="${searchFieldList['SCORERANK'] eq '90'}">selected="selected"</c:if>>90</option>
						<option value="100" <c:if test="${searchFieldList['SCORERANK'] eq '100'}">selected="selected"</c:if>>100</option> --%>
					</select></td>
			</tr>
		</c:forEach>
	</tbody>
</table>