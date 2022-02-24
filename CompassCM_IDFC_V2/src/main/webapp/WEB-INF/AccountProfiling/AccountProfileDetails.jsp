<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULEDETAILS" value="${MODULEDETAILS}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>

<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	.nonCashDetailsTd{
		text-align: center;
	}
	.profileDetailsLinks > a{
		cursor: pointer;
	}
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalDetailsTable'+id;
		compassDatatable.construct(tableClass, "AccountProfileDetails", true);
		
		$("#searchModuleDetails"+id).click(function(){
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			
			var ap_fromDate = $("#ap_fromDate"+id).val();
			var ap_toDate = $("#ap_toDate"+id).val();
			var ap_accountNo = $("#ap_accountNo"+id).val();
			var ap_custId = $("#ap_custId"+id).val();
			var moduleValue = ap_accountNo+"||"+ap_fromDate+"||"+ap_toDate+"||"+ap_custId;
			
			
			var detailPage = $("#detailPage"+id).val();
			if(childWindow == "1"){
				searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage);
			}else{
				if($("#compassGenericModal").hasClass("show")){
					openDetails($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}else{
					openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}
			}
			
		});
		
		$("#moduleValue"+id).keydown(function(event){
	        if(event.which=="13")
	        	$("#searchModuleDetails"+id).click();
		});
		
		$("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			
			var ap_fromDate = $("#ap_fromDate"+id).val();
			var ap_toDate = $("#ap_toDate"+id).val();
			var ap_accountNo = $("#ap_accountNo"+id).val();
			var ap_custId = $("#ap_custId"+id).val();
			var moduleValue = ap_accountNo+"||"+ap_fromDate+"||"+ap_toDate+"||"+ap_custId;
			if(ap_accountNo != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			
			var ap_fromDate = $("#ap_fromDate"+id).val();
			var ap_toDate = $("#ap_toDate"+id).val();
			var ap_accountNo = $("#ap_accountNo"+id).val();
			var ap_custId = $("#ap_custId"+id).val();
			var moduleValue = ap_accountNo+"||"+ap_fromDate+"||"+ap_toDate+"||"+ap_custId;
			if(ap_accountNo != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
		
		if($("#accountProfileDetailsSearchFrame"+id).parents("div#accountProfileDetailsDiv").attr("class") != undefined){
			$("#accountProfileDetailsSearchFrame"+id).css("display", "none");
		}
	});
</script>
<div class="container" id="accountProfilingDetailsDiv" style="width: 100%;">
	<div class="row" id="accountProfileDetailsSearchFrame${UNQID}">
		<div class="col-sm-12">
			<div class="card card-primary">
				<div class="row">
					<div class="col-sm-12">
						<div class="card-body" style="text-align: center; padding: 5px 0px;">
							<input type="hidden" name="moduleCode" id="moduleCode${UNQID}" value="${moduleCode}"/>
							<input type="hidden" name="detailPage" id="detailPage${UNQID}" value="${detailPage}"/>
							<input type="hidden" name="moduleHeader" id="moduleHeader${UNQID}" value="${moduleHeader}"/>
							<table class="table compassModuleDetailsSearchTable" style="margin-bottom: 0px;">
								<tr>
									<td width="15%"><spring:message code="app.common.FROMDATE"/></td>
									<td width="30%"><input type="text" class="form-control input-sm datepicker" name="ap_fromDate" id="ap_fromDate${UNQID}" value="${AP_FROMDATE}"/></td>
									<td width="10%">&nbsp;
									<td width="15%"><spring:message code="app.common.TODATE"/></td>
									<td width="30%"><input type="text" class="form-control input-sm datepicker" name="ap_toDate" id="ap_toDate${UNQID}" value="${AP_TODATE}"/></td>
								</tr>
								<tr>
									<td width="15%"><spring:message code="app.common.ACCOUNTNO"/></td>
									<td width="30%"><input type="text" class="form-control input-sm" name="ap_accountNo" id="ap_accountNo${UNQID}" value="${AP_ACCOUNTNO}"/></td>
									<td width="10%">&nbsp;
									<td width="15%"><spring:message code="app.common.CUSTOMERID"/></td>
									<td width="30%"><input type="text" class="form-control input-sm" name="ap_custId" id="ap_custId${UNQID}" value="${AP_CUSTOMERID}"/></td>
								</tr>
							</table>
						</div>
						<div class="card-footer clearfix">
							<div class="pull-right">
								<button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
	<ul class="nav nav-pills modalNav" role="tablist">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<li role="presentation">
				<a class="subTab nav-link <c:if test='${tabIndex.index == 0}'>active</c:if>" href="#${moduleCode}${UNQID}${tabIndex.index}" aria-controls="tab" role="tab" data-toggle="tab">${tab}</a>
			</li>
		</c:forEach>
	</ul>
	<div class="tab-content">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<div role="tabpanel" class="tab-pane <c:if test="${tabIndex.index == 0}">active</c:if>" id="${moduleCode}${UNQID}${tabIndex.index}">
				<c:set var="tabIndex">${tabIndex.index}</c:set>
				<c:set var="tabDetail" value="${MODULEDETAILS[tabIndex]}"/>
				<c:set var="RECORDCOUNT" value="${f:length(tabDetail)}" scope="page"/>
				<c:choose>
					<c:when test="${TABDISPLAY[tabIndex] eq 'T'}">
						<c:choose>
							<c:when test="${RECORDCOUNT > 0}">
								<table class="table table-striped table-bordered searchResultGenericTable modalDetailsTable${UNQID}">
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
													<c:choose>
														<c:when test="${fieldDetails.value ne ' ' and fieldDetails.value ne ''}">
															<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${fieldDetails.value}</td>
														</c:when>
														<c:otherwise>
															<td>${fieldDetails.value}</td>
														</c:otherwise>
													</c:choose>
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
						<br/><br/>
						<div class="row profilingDetailsDiv${tabIndex}" style="display: none;">
							<div class="col-sm-12">
								<div class="card">
								</div>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="fieldDeatails" items="${tabDetail}">
							<table class="table table-striped accountProfiling">
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
				<!-- <br/><br/>
				<div class="row" id="profilingDetailsDiv" style="display: none;">
					<div class="col-sm-12">
						<div class="card">
						</div>
					</div>
				</div> -->
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>

