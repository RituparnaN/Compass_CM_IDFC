<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'addFieldsToTemplate${UNQID}';
		compassDatatable.construct(tableClass, "AddFieldsToTemplate", true);
		compassDatatable.enableCheckBoxSelection();
		
		var tr = $(".addFieldsToTemplate"+id).children("tbody").children("tr");
		$(tr).each(function(){
			var isChecked = $(this).children("td:nth-child(8)").html();
			if(isChecked == "true"){
				$(this).children("td:first-child").children("input").prop("checked",true);
			}
		});
	});
</script>
<input type="hidden" id="searchTemplate" value="${template}"/>
<table class="table table-bordered table-striped searchResultGenericTable addFieldsToTemplate${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort" style="text-align: center;">
				<input type="checkbox" class="checkbox-check-all" compassTable="addFieldsToTemplate${UNQID}" id="addFieldsToTemplate${UNQID}" />
			</th>
			<c:forEach var="TH" items="${resultData['HEADER']}">
				<c:set var="colArray" value="${f:split(TH, '.')}" />
				<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['RECORDDATA']}">
			<tr>
				<td style="text-align: center;">
					<input type="checkbox"></td>
				<c:forEach var="field" items="${record}" varStatus="tabIndex">
					<c:choose>
						<c:when test="${tabIndex.index == 5}">
							<td>
								<select class = "form-control input-sm" id= "complianceScore">
									<option value="1" <c:if test="${field.value eq '1'}">selected="selected"</c:if>>1-Optional</option>
									<option value="2" <c:if test="${field.value eq '2'}">selected="selected"</c:if>>2-Mandatory by Bank</option>
									<option value="3" <c:if test="${field.value eq '3'}">selected="selected"</c:if>>3-Mandatory by Regulator</option>
								</select>
							</td>
						</c:when>
						<c:otherwise><td>${field.value}</td></c:otherwise>
					</c:choose>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>