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

<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" >
		<thead>
			<tr>
				<th class="no-sort">
					<input type="checkbox" class="checkbox-check-all" compassTable="${MODULETYPE}${UNQID}"
					id="${MODULETYPE}${UNQID}" />
				</th>
				<c:forEach var="TH" items="${HEADER}">
					<c:set var="colArray" value="${f:split(TH, '.')}" />
					<c:set var="colArrayCnt" value="${f:length(colArray)}" />
					<th id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RECORD" items="${DATA}">
				<tr>
					<td>
						<input type="checkbox" class="checkbox" value="${RECORD[1]}" compassId="${RECORD[1]}" /> 
					</td>
					<c:forEach var="TD" items="${RECORD}" varStatus="loop">
						<c:choose>
							<c:when test="${TD ne ' ' and TD ne ''}">
								<c:choose>
									<c:when test="${HEADER[loop.index] eq 'app.common.ISENABLED'}">
										<td>
											<select class="form-control input-sm" id="isEnabledField${UNQID}">
												<option value="Y" <c:if test="${TD eq 'Y'}" >selected</c:if>>Yes</option>
												<option value="N" <c:if test="${TD eq 'N'}" >selected</c:if>>No</option>
											</select>
										</td>
									</c:when>
									<c:otherwise>
										<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
									</c:otherwise>
								</c:choose>
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