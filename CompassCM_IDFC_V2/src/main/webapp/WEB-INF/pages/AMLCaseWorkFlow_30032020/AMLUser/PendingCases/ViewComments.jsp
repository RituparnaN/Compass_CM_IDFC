<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");

//System.out.println(userRole);
%>
<c:set var="MODULEDETAILS" value="${MODULEDETAILS}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>
<c:set var="ROLE" value="${f:substring(CURRENTROLE,5,12)}"/>
<c:set var="ACTION" value="${ACTION}"/>
<c:set var="REASONCODE" value="${TABNAMES}"/>
<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	/* .datepicker{
		background-image:url("../../images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} */
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalDetailsTable'+id;
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
			
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			//dateFormat: _dateFormat
		});
		
		$("#searchModuleDetails"+id).click(function(){
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			var moduleValue = $("#moduleValue"+id).val();
			var detailPage = $("#detailPage"+id).val();
			if(childWindow == "1"){
				searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage);
			}else{
				if($("#compassGenericModal").hasClass("in")){
					openDetails($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}else{
					openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}
			}
			
		});
		
		$(".panelSlidingViewComments"+id).click(function(){
			 if($(this).find("i").hasClass( "fa-chevron-down" ))
			{
				 $(this).find("i").removeClass('fa-chevron-down');
				 $(this).find("i").addClass('fa-chevron-up');  
			}
			else{
				$(this).find("i").removeClass('fa-chevron-up');
				$(this).find("i").addClass('fa-chevron-down');
			}
		});
		
		$("#moduleValue"+id).keydown(function(event){
	        if(event.which=="13")
	        	$("#searchModuleDetails"+id).click();
		});
		
		/* $("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
		 */
		
	});
	
	function changeMLROValues(selectName)
	{
	var value = selectName.value;
	if(value == "FUPR")
	{
		$("#highRiskRow").css("display", "block");

	}
	else
	{
		$("#highRiskRow").css("display", "none");
	}
	}
	
</script>
<style type="text/css">
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<div class="container" style="width: 100%;">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
				<div class="row">
					<div class="col-sm-3"></div>
					<div class="col-sm-6">
						<div class="card-body" style="text-align: center; padding: 5px 0px;">
							<input type="hidden" name="moduleCode" id="moduleCode${UNQID}" value="${moduleCode}"/>
							<input type="hidden" name="detailPage" id="detailPage${UNQID}" value="${detailPage}"/>
							<input type="hidden" name="moduleHeader" id="moduleHeader${UNQID}" value="${moduleHeader}"/>
							<table class="table compassModuleDetailsSearchTable" style="margin-bottom: 0px;">
								<tr>
									<td width="30%"><spring:message code="app.common.CASENO"/></td>
									<td width="40%"><input type="text" class="form-control input-sm" name="moduleValue" id="moduleValue${UNQID}" value="${moduleValue}"/></td>
									<td width="30%"><button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button></td>
								</tr>
							</table>
						</div>
					</div>
					<div class="col-sm-3"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
	<ul class="nav nav-pills modalNav" role="tablist">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<li role="presentation" <c:if test="${tabIndex.index == 0}">class="active"</c:if>>
				<a class="subTab" href="#${moduleCode}${UNQID}${tabIndex.index}" aria-controls="tab" role="tab" data-toggle="tab">${tab}</a>
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
						<c:forEach var="fieldDetails" items="${tabDetail}" varStatus = "status">
							<div class="card card-primary commentsMainDiv${UNQID}" style="margin: 10px 5px 5px 5px;">
							<div class="card-header panelSlidingViewComments${UNQID} clearfix" 
								id="${status.index}slidingViewCommentsPanel${UNQID}" data-toggle="collapse" 
								data-target="#${tabIndex}commentsDiv${status.index}">
								<h6 class="card-title pull-${dirL}">Comments ${status.index+1}</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
								</div>
							</div>
							<div id="${tabIndex}commentsDiv${status.index}" >
								<table class="table table-striped">
									<tbody>
										<c:set var="LABELSCOUNT" value="${f:length(fieldDetails)}"/>
										<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
										<c:forEach var="ALLLABELSMAP" items="${fieldDetails}">
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
							</div>
							</div>
						</c:forEach>
						<c:if test="${tab eq ROLE}">
							<div class="card card-primary commentsMainDiv${UNQID}" style="margin: 10px 5px 5px 5px;">
							<div class="card-header panelSlidingViewComments${UNQID} clearfix" 
								id="${status.index}slidingViewCommentsPanel${UNQID}" data-toggle="collapse" 
								data-target="#${tabIndex}commentsDiv${status.index}">
								<h6 class="card-title pull-${dirL}">Add Comments</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
								</div>
							</div>
							<div id="${tabIndex}commentsDiv${status.index}" >
								<table class="table table-striped">
									<tr>
										<td width="15%">Account Reviewed Date</td>
										<td width="30%">
											<input type="text" class="form-control input-sm datepicker" name="acctReviewedDate" id="acctReviewedDate${UNQID}" style="width:100%"/>
										</td>
										<td width="10%">&nbsp;</td>
										<c:if test="${ACTION eq 'closeWithSTR' || ACTION eq 'closeWithoutSTR'}">
										<td width="15%">Suspicion Indicator</td>
										<td width="30%">
											<select class="form-control input-sm" name="suspicionIndicator" id="suspicionIndicator${UNQID}" style="width:100%">
												<option value="PFPM">Potentially Suspicious Payment Mechanism</option>
												<option value="PFAP">Potentially Suspicious Address Provided</option>
												<option value="PFND">Potentially Suspicious Non Disclosure</option>
												<option value="PFCI">Potentially Suspicious Alerted Transaction</option>
												<option value="PFTP">Potentially Suspicious Third Party Involved</option>
												<option value="PFIP">Potentially Suspicious Identity Provided</option>
												<option value="PFUD">Potentially Suspicious Underwriting Disclosure</option>
												<option value="TPOF">Tip Off Provided</option>
												<option value="SIOP">Relationship Information On Party</option>
												<option value="OFCM">OFACSDN List Match</option>
												<option value="UNCM">UNSanction List Match</option>
												<option value="OTHM">Other List Match</option>
												<option value="HSCOR">High Alert ScoreCard</option>
												<option value="OTHERS">Others</option>
												<option value="PNEF">Potentially Not Suspicious</option>
											</select>	
										</td>
										</c:if>
										<c:if test="${ACTION eq 'rejectSTRByAMLO'}">
										<td width="15%">Removal Reason</td>
										<td width="30%">
											<select class="form-control input-sm" name="removalReason" id="removalReason${UNQID}" style="width:100%">
												<option value="PFPM">Potentially Suspicious Payment Mechanism</option>
												<option value="PFAP">Potentially Suspicious Address Provided</option>
												<option value="PFND">Potentially Suspicious Non Disclosure</option>
												<option value="PFCI">Potentially Suspicious Alerted Transaction</option>
												<option value="PFTP">Potentially Suspicious Third Party Involved</option>
												<option value="PFIP">Potentially Suspicious Identity Provided</option>
												<option value="PFUD">Potentially Suspicious Underwriting Disclosure</option>
												<option value="TPOF">Tip Off Provided</option>
												<option value="SIOP">Relationship Information On Party</option>
												<option value="OFCM">OFACSDN List Match</option>
												<option value="UNCM">UNSanction List Match</option>
												<option value="OTHM">Other List Match</option>
												<option value="HSCOR">High Alert ScoreCard</option>
												<option value="OTHERS">Others</option>
												<option value="PNEF">Potentially Not Suspicious</option>
											</select>	
										</td>
										</c:if>
										<c:if test="${ACTION eq 'approveSTRByAMLO'}">
										<td width="15%">Outcome Indicator</td>
										<td width="30%">
											<select name="mlroOutcomeIndicator" id="mlroOutcomeIndicator${UNQID}" class="form-control input-sm"  onChange="changeMLROValues(this)"  style="width:100%">
												<option value="FUPR">Laundering activity upheld, RED Mark Indicator assigned</option>
												<option value="FUNM">Laundering activity upheld, No marker applied</option>
											</select>		
										</td>
										</c:if>
									</tr>
									<c:if test="${ACTION eq 'closeWithoutSTR'}">
										<tr>
											<td width="15%">Add To False Positive List</td>
											<td width="30%"> 
												<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="addToFalsePositive" id="addToFalsePositive${UNQID}" onclick="addToFalsePositive()">
											</td>
											<td colspan="3">&nbsp;</td>
										</tr>
									</c:if>
									<c:if test="${ACTION eq 'approveSTRByAMLO'}">
										<tr id ="highRiskRow" style="display:none">
											<td width="15%">High-Risk Reason Code</td>
											<td width="30%">
												<select class="form-control input-sm" name="highRiskReasonCode" id="highRiskReasonCode${UNQID}" style="width:100%">
													<option value="WAT">Suspicious activity watch List</option>
													<option value="HRWLA">Mark As High Risk Accounts And Add To System Watchlist</option>
													<option value="MLA">Money laundering activities</option>
													<option value="CPA">Continuous payment arrears</option>
													<option value="TBS">Threatening behaviour towards staff or supplier</option>
													<option value="TER">ABC terminated commercial agreement (Broker / Supplier)</option>
													<option value="OTHERS">Others</option>
												</select>	
											</td>	
											<td colspan="3">&nbsp;</td>
										</tr>
									</c:if>
									<tr>
										<td width="15%">Comments</td>
										<td colspan="4">
											<textarea class="form-control input-sm" name="UserInputComments" id="UserInputComments${UNQID}" ></textarea>
										</td>
									</tr>
								</table>
							</div>
							<div class="card-footer clearfix">
								<div class="pull-${dirR}">
									<input type="button" id="saveComments${UNQID}" class="btn btn-success btn-sm" value="Post" onclick="saveComments()" value="Post">
								</div>
							</div>
							</div>
							</c:if>
					</c:otherwise>
					</c:choose>				
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>

