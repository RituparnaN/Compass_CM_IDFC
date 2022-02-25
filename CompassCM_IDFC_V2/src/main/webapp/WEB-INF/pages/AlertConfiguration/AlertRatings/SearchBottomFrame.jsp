<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	var tableClass = 'compassAlertRatingsValuesSerachResultTable';
	compassDatatable.construct(tableClass, "Alert Ratings Values", true);
	compassDatatable.enableCheckBoxSelection();
});
</script>
<table class="table table-bordered table-striped searchResultGenericTable compassAlertRatingsValuesSerachResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;" width="5%">
				<input type="checkbox" class="checkbox-check-all" compassTable="compassAlertRatingsValuesSerachResultTable" id="compassAlertRatingsValuesSerachResultTable">
			</th>
			<th class="info" width="30%">Alert Code</th>
			<th class="info" width="25%">Alert Message</th>
			<th class="info" width="15%">Alert Rating</th>
			<th class="info" width="15%">Updated By</th>
			<th class="info" width="15%">Updated On</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="searchAlertRatingList" items="${DATALIST}">
			<tr>
				<td class="no-sort" style="text-align: center;">
					<input type="checkbox" <c:if test="${searchAlertRatingList['ISUPDATED'] eq 'Y'}">checked="checked"</c:if>/>	
				</td>
				<td>${searchAlertRatingList['ALERTCODE']}</td>
				<td>${searchAlertRatingList['ALERTMESSAGE']}</td>
				<td><select class="form-control input-sm" onchange= "checkSelectBoxOnUpdate(this)">
						<option value="1" <c:if test="${searchAlertRatingList['ALERTRATING'] eq '1'}">selected="selected"</c:if>>LOW</option>
						<option value="2" <c:if test="${searchAlertRatingList['ALERTRATING'] eq '2'}">selected="selected"</c:if>>MEDIUM</option>
						<option value="3" <c:if test="${searchAlertRatingList['ALERTRATING'] eq '3'}">selected="selected"</c:if>>HIGH</option>
					</select></td>
				<td>${searchAlertRatingList['UPDATEDBY']}</td>
				<td>${searchAlertRatingList['UPDATEDON']}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>