<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<c:set var="moduleDetails" value="${moduleDetails}"/>
<c:set var="TABNAMES" value="${moduleDetails['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${moduleDetails['TABDISPLAY']}"/>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<c:set var="action" value="${action}"/>

<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} 
	
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalDetailsTable'+id;
		var userRole = '${userRole}';
		var flagType = '${flagType}';
		var caseStatus = '${caseStatus}';
		var addedToFalsePositive = 'N';
		
		compassDatatable.construct(tableClass, "${MODULENAME}", true);

		/* $(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: _dateFormat
		}); */
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#searchModuleDetails"+id).click(function(){
			/* alert(moduleDetails);
			alert(colValue); */
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			var moduleValue = $("#caseNo"+id).val();
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
		
		$("#outcomeIndicator"+id).on("change", function(){
			if($(this).val() == "FUPR"){
				$("#highRiskRow").css("display", "table-row");
			}
			else{
				$("#highRiskRow").css("display", "none");
			}
		});
		
		$("#amlUserAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}else{
					addedToFalsePositive = 'N';
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}
			}
		});
		
		$("#amloAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}else{
					addedToFalsePositive = 'N';
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}
			}
		});
		
		$("#mlroAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					
				}else{
					addedToFalsePositive = 'N';
				}
			}
		});
		
		$("#saveComments"+id).click(function(){
			var caseNos = $("#caseNo"+id).val();
			var comments = '';
			var lastReviewedDate = '';
			var fraudIndicator = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';

			if(fraudIndicator == 'PNEF'){
				addedToFalsePositive = 'Y';
				$("#amluserAddToFalsePositive"+id).attr("checked","checked");
			}
			
			if(userRole == 'ROLE_USER'){
				lastReviewedDate = $("#userAcctReviewedDate"+id).val();
				comments  = $("#userComments"+id).val();
				fraudIndicator = $('#fraudIndicator'+id).val();
			}
			else if(userRole == 'ROLE_AMLUSER'){
				lastReviewedDate = $("#amluserAcctReviewedDate"+id).val();
				comments  = $("#amluserComments"+id).val();
				fraudIndicator = $('#fraudIndicator'+id).val();
			}
			else if(userRole == 'ROLE_AMLO'){
				lastReviewedDate = $("#amloAcctReviewedDate"+id).val();
				comments  = $("#amloComments"+id).val();
				outcomeIndicator = $('#outcomeIndicator'+id).val();
				removalReason = $('#removalReason'+id).val();
				highRiskReasonCode = $('#highRiskReasonCode'+id).val();
			}
			else if(userRole == 'ROLE_MLRO'){
				lastReviewedDate = $("#mlroAcctReviewedDate"+id).val();
				comments  = $("#mlroComments"+id).val();
				outcomeIndicator = $('#outcomeIndicator'+id).val();
				removalReason = $('#removalReason'+id).val();
				highRiskReasonCode = $('#highRiskReasonCode'+id).val();
			}
			
			// alert(caseNos+", "+comments+", "+lastReviewedDate+", "+fraudIndicator+", "+flagType+", "+caseStatus+", "+removalReason+", "+addedToFalsePositive);
			var fullData ="CaseNos="+caseNos+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
						  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+
						  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator;
			// alert(fullData);
			if(lastReviewedDate == '' && comments == ''){
				alert('Please enter Account Reviewed Date and Comments.');
			}else{
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res){
						alert("Saved successfully.");
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		}); 
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
	
</script>

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
								<%-- <tr>
									<td>
										${moduleDetails}
									</td>
								</tr> --%>
								<tr>
									<td width="30%"><spring:message code="app.common.CASENO"/></td>
									<td width="40%"><input type="text" class="form-control input-sm" name="caseNo" id="caseNo${UNQID}" value="${caseNo}"/></td>
									<td width="30%"><button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button></td>
								</tr>
								<%-- <tr>
									<td>
										${CASECOMMENTDETAILS}
									</td>
								</tr> --%>
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
				<c:set var="tabDetail" value="${moduleDetails[tabIndex]}"/>
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
						<c:if test="${tab eq ROLE && action ne 'viewComments'}">
							<div class="card card-primary commentsMainDiv${UNQID}" style="margin: 10px 5px 5px 5px;">
							<div class="card-header panelSlidingViewComments${UNQID} clearfix" 
								id="${varStatus.index}slidingViewCommentsPanel${UNQID}" data-toggle="collapse" 
								data-target="#${tabIndex}commentsDiv${varStatus.index}">
								<h6 class="card-title pull-${dirL}">Add Comments</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
								</div>
							</div>
							<div id="${tabIndex}commentsDiv${varStatus.index}" >
								<table class="table table-striped">
									<tr>
										<td width="20%">Account Reviewed Date</td>
										<c:if test="${ROLE eq 'USER'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="userAcctReviewedDate" id="userAcctReviewedDate${UNQID}" style="width:100%"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLUSER'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="amluserAcctReviewedDate" id="amluserAcctReviewedDate${UNQID}" style="width:100%"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLO'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="amloAcctReviewedDate" id="amloAcctReviewedDate${UNQID}" style="width:100%"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'MLRO'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="mlroAcctReviewedDate" id="mlroAcctReviewedDate${UNQID}" style="width:100%"/>
										</td>
										</c:if>
										<td width="10%">&nbsp;</td>
										<c:if test="${action eq 'closeWithSTR' || action eq 'closeWithoutSTR'}">
										<td width="20%">Suspicion Indicator</td>
										<td width="25%">
											<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}" style="width:100%">
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
										<c:if test="${action eq 'rejectSTRByAMLO' || action eq 'rejectSTRByMLRO'}">
										<td width="20%">Removal Reason</td>
										<td width="25%">
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
										<c:if test="${action eq 'approveSTRByAMLO' || action eq 'fileSTRByMLRO'}">
										<td width="20%">Outcome Indicator</td>
										<td width="25%">
											<select class="form-control input-sm" name="outcomeIndicator" id="outcomeIndicator${UNQID}" style="width:100%">
												<option value="FUPR">Laundering activity upheld, RED Mark Indicator assigned</option>
												<option value="FUNM">Laundering activity upheld, No marker applied</option>
											</select>		
										</td>
										</c:if>
									</tr>
									<c:if test="${action eq 'approveSTRByAMLO' || action eq 'fileSTRByMLRO'}">
										<tr id ="highRiskRow">
											<td width="20%">High-Risk Reason Code</td>
											<td width="25%">
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
									<c:if test="${action eq 'closeWithoutSTR'}">
										<tr>
											<td width="20%">Add To False Positive List</td>
											<td width="25%"> 
												<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="amlUserAddToFalsePositive" 
												id="amlUserAddToFalsePositive${UNQID}" >
											</td>
											<td colspan="3">&nbsp;</td>
										</tr>
									</c:if>
									<c:if test="${action eq 'rejectSTRByAMLO'}">
										<tr>
											<td width="20%">Add To False Positive List</td>
											<td width="25%"> 
												<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="amloAddToFalsePositive" 
												id="amloAddToFalsePositive${UNQID}" onclick="amloAddToFalsePositive()">
											</td>
											<td colspan="3">&nbsp;</td>
										</tr>
									</c:if>
									<c:if test="${action eq 'rejectSTRByMLRO'}">
										<tr>
											<td width="20%">Add To False Positive List</td>
											<td width="25%"> 
												<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="mlroAddToFalsePositive" 
												id="mlroAddToFalsePositive${UNQID}" onclick="mlroAddToFalsePositive()">
											</td>
											<td colspan="3">&nbsp;</td>
										</tr>
									</c:if>
									
									<tr>
										<td width="20%">Comments</td>
										<c:if test="${ROLE eq 'USER'}">
											<td colspan="4">
												<textarea class="form-control input-sm" name="userComments" id="userComments${UNQID}" ></textarea>
											</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLUSER'}">
											<td colspan="4">
												<textarea class="form-control input-sm" name="amluserComments" id="amluserComments${UNQID}" ></textarea>
											</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLO'}">
											<td colspan="4">
												<textarea class="form-control input-sm" name="amloComments" id="amloComments${UNQID}" ></textarea>
											</td>
										</c:if>
										<c:if test="${ROLE eq 'MLRO'}">
											<td colspan="4">
												<textarea class="form-control input-sm" name="mlroComments" id="mlroComments${UNQID}" ></textarea>
											</td>
										</c:if>
									</tr>
								</table>
							</div>
							<div class="card-footer clearfix">
								<div class="pull-${dirR}">
									<c:if test="${flagType eq 'Y'}">
										<input type="button" class="btn btn-success btn-sm" id="saveComments${UNQID}" value="Save" value="Save">
									</c:if>
									<input type="button" class="btn btn-danger btn-sm" id="closeAddViewCommentsModal${UNQID}" data-dismiss="modal" value="Close"/>
								</div>
							</div>
							</div>
							</c:if>
						<c:forEach var="fieldDetails" items="${tabDetail}" varStatus = "varStatus">
						<%-- ${fieldDetails['app.common.CASESTATUS']} --%>
							<div class="card card-primary commentsMainDiv${UNQID}" style="margin: 10px 5px 5px 5px;">
							<div class="card-header panelSlidingViewComments${UNQID} clearfix" 
								id="${varStatus.index}slidingViewCommentsPanel${UNQID}" data-toggle="collapse" 
								data-target="#${tabIndex}commentsDiv${varStatus.index}">
								<%-- <h6 class="card-title pull-${dirL}">Comments ${varStatus.index+1}</h6> --%>
								<h6 class="card-title pull-${dirL}">
								<c:forEach var="columnDetails1" items="${fieldDetails}">
								<c:set var="columnName1" value="${columnDetails1.key}"></c:set>
								<c:set var="columnValue1" value="${columnDetails1.value}"></c:set>
									<c:if test="${f:contains(columnName1, 'app.common.CASESTATUS')}">${columnValue1} || </c:if>
								</c:forEach>
								<c:forEach var="columnDetails2" items="${fieldDetails}">
								<c:set var="columnName2" value="${columnDetails2.key}"></c:set>
								<c:set var="columnValue2" value="${columnDetails2.value}"></c:set>
									<c:if test="${f:contains(columnName2, 'app.common.USERCODE')}">${columnValue2} || </c:if>
								</c:forEach>
								<c:forEach var="columnDetails3" items="${fieldDetails}">
								<c:set var="columnName3" value="${columnDetails3.key}"></c:set>
								<c:set var="columnValue3" value="${columnDetails3.value}"></c:set>
									<c:if test="${f:contains(columnName3, 'app.common.UPDATETIMESTAMP')}">${columnValue3}</c:if>
								</c:forEach>
								</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
								</div>
							</div>
							<div id="${tabIndex}commentsDiv${varStatus.index}" >
								<table class="table table-striped">
									<tbody>
										<c:set var="LABELSCOUNT" value="${f:length(fieldDetails)}"/>
										<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
										<c:forEach var="ALLLABELSMAP" items="${fieldDetails}">
											<c:choose>
												<c:when test="${LABELSITRCOUNT % 2 == 0}">
													<tr>
														<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
														<td width="25%">
															<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</td>
														<td width="10%">&nbsp;</td>
												</c:when>
												<c:otherwise>
														<td width="20%"><spring:message code="${ALLLABELSMAP.key}"/></td>
														<td width="25%">
															<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
														</td>
													</tr>
												</c:otherwise>
											</c:choose>
											<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
										</c:forEach>
										<c:if test="${LABELSITRCOUNT % 2 != 0}">
												<td width="20%">&nbsp;</td>
												<td width="25%">&nbsp;</td>
											</tr>
										</c:if>
									</tbody>
								</table>
							</div>
							</div>
						</c:forEach>
						
					</c:otherwise>
					</c:choose>				
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>
</form>

</body>