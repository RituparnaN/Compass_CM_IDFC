<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${SEARCHRESULT['HEADER']}"/>
<c:set var="DATA" value="${SEARCHRESULT['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var tableClass = '${MODULETYPE}${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>

<div id="riskAssessmentSearchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" id="searchResultGenericTable ${MODULETYPE}${UNQID}">
		<thead>
			<tr>
				<th class="info no-sort">
					<input type="checkbox" class="checkbox-check-all" compassTable="${MODULETYPE}${UNQID}"
					id="${MODULETYPE}${UNQID}" />
				</th>
				<c:forEach var="TH" items="${HEADER}" varStatus="headerIndex">
					<c:set var="colArray" value="${f:split(TH, '.')}" />
					<c:set var="colArrayCnt" value="${f:length(colArray)}" />
					<c:if test = "${ TH.contains('COMPASSREFNO')}">
						<c:set var = "crnIndex" value = "${headerIndex.index}"/>
					</c:if>
					<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RECORD" items="${DATA}">
			
				<tr>
					<td>
						<input type="checkbox" class="checkbox-check-one" value="${RECORD[0] }||${RECORD[1]}||${RECORD[crnIndex]}" compassId="${RECORD[1]}" /> 
					</td>
					<c:forEach var="TD" items="${RECORD}">
						<c:choose>
							<c:when test="${TD ne ' ' and TD ne ''}">
								<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
							</c:when>
							<c:otherwise>
								<td>${TD}</td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>