<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<%-- <c:set var="HEADERS" value="${ErrorDetails['HEADERS']}"/>
<c:set var="RECORDS" value="${ErrorDetails['RECORDS']}"/> --%>
<c:set var="MODULEDETAILS" value="${ErrorDetails}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var uploadRefNo = '${uploadRefNo}';
		var moduleRefNo = '${moduleRefId}';
		var tableClass = 'errorDetailsTable${UNQID}';
		compassDatatable.construct(tableClass, "File Upload Error Details", true, "");
	});
</script>
<body>

<div class="container" style="width: 100%;">
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_errorDetails">
			<div class="card-header panelSlidingErrorDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Error Details</h6>
			</div>
		
<div class="row">
	<div class="col-sm-12">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<div class="card card-primary" style="margin-bottom: 0; margin-top: 5px;	">
			<div class="card-header panelSlidingErrorDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">${tab}</h6>
			</div>
			<div id="fileUploadDetails${UNQID}${tab}${tabIndex.index}">
				<c:set var="tabIndex">${tabIndex.index}</c:set>
				<c:set var="tabDetail" value="${MODULEDETAILS[tabIndex]}"/>
				<c:set var="RECORDCOUNT" value="${f:length(tabDetail)}" scope="page"/>
				<c:choose>
						<c:when test="${TABDISPLAY[tabIndex] eq 'T'}">
							<c:choose>
								<c:when test="${RECORDCOUNT > 0}">
									<table class="table table-striped table-bordered searchResultGenericTable errorDetailsTable${UNQID}">
										<thead>
											<c:forEach var="recordDetails" items="${tabDetail}" begin="0" end="0">
												<tr>
													<c:forEach var="fieldDetails" items="${recordDetails}">
														<c:set var="colArray" value="${f:split(fieldDetails.key, '.')}" />
														<c:set var="colArrayCnt" value="${f:length(colArray)}" />
														<th id="${colArray[colArrayCnt-1]}"><spring:message code="${fieldDetails.key}"/></th>
													</c:forEach>
												</tr>
											</c:forEach>
										</thead>
										<tbody>
											<c:forEach var="recordDetails" items="${tabDetail}">
												<tr>
													<c:forEach var="fieldDetails" items="${recordDetails}">
														<td data-toggle="tooltip" data-placement="auto"  title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
													</c:forEach>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</c:when>
								<c:otherwise>
									<br/>
									<center>
									No ${tab} Record Found
									</center>
									<br/>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:forEach var="fieldDeatails" items="${tabDetail}">
								<table class="table table-striped">
									<tbody>
										<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
										<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
										<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
											<c:choose>
												<c:when test="${LABELSITRCOUNT % 2 == 0}">
													<tr>
														<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
														<td width="30%">
															<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</td>
														<td width="10%">&nbsp;</td>
												</c:when>
												<c:otherwise>
														<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
														<td width="30%">
															<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</td>
													</tr>
												</c:otherwise>
											</c:choose>
											<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
										</c:forEach>
										<c:if test="${LABELSITRCOUNT % 2 != 0}">
												<td width="15%">&nbsp;</td>
												<td width="30%">&nbsp;</td>
											</tr>
										</c:if>
									</tbody>
								</table>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</c:forEach>
</div>
</div>
</div>
</div>
</div>
</div>
</body>