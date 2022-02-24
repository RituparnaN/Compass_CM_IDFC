<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'reportParamsTable', 'dd/mm/yy');
	});
</script>
	
<div id="searchResultGenericDiv">
	<table class="table table-striped formSearchTable reportParamsTable${UNQID}" style="margin-bottom: 0px;">
		<tbody>
			<c:set var="LABELSCOUNT" value="${f:length(REPORTPARAMS)}"/>
			<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
			
			<c:forEach var="ALLLABELSMAP" items="${REPORTPARAMS}">
				<c:choose>
					<c:when test="${LABELSITRCOUNT % 2 == 0}">
						<tr>
							<td width="15%"><spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/></td>
							<td width="30%">
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepicker" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
									<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
									
									<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
										<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
											<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'selectfromview'}">
									<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
									
									<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
										<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
											<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
									<div class="input-group" style="z-index: 1">
										<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
										class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
										id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
										validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
										name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
										<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
										onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</c:if>
							</td>
							<td width="10%">&nbsp;</td>
					</c:when>
					<c:otherwise>
							<td width="15%"><spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/></td>
							<td width="30%">
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepicker" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
									<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
									
									<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
										<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
											<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'selectfromview'}">
									<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
									
									<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
										<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
											<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
									<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
								</c:if>
								<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
									<div class="input-group" style="z-index: 1">
										<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
										class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
										id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
										validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
										name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
										<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
										onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>												
								</c:if>
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
</div>