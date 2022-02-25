<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<c:set var="moduleDetails" value="${moduleDetails}"/>
<c:set var="TABNAMES" value="${moduleDetails['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${moduleDetails['TABDISPLAY']}"/>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<c:set var="action" value="${action}"/>
<c:set var="currentCaseStatus" value="${CASECOMMENTDETAILS['CASESTATUS']}" />

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
		var caseNos = '${caseNo}';
		var parentFormId = '${parentFormId}';
		var tableClass = 'modalDetailsTable'+id;
		var userRole = '${userRole}';
		var flagType = '${flagType}';
		var caseStatus = '${caseStatus}';
		var customerId = '${inputCustomerId}';
		var addedToFalsePositive = 'N';
		var amlUserAddToMarkAll = 'N';
		var evidenceCount;
		
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
		
		$("#amlUserAddToMarkAll"+id).change(function(){
			//alert("customerId = "+customerId);
 			if($(this).prop("checked", true)){
 				if(customerId == ''){
					alert('Please select customer id.');
					amlUserAddToMarkAll = 'N';
					$(this).prop("checked",false);
				}else{
					if(confirm('Are you sure to mark all the cases for desktop closure?')){
						amlUserAddToMarkAll = 'Y';	
					}else{
						amlUserAddToMarkAll = 'N';
					}
				}
			 } 
		});
		
		$("#attachEvidence"+id).click(function(){
			compassFileUpload.init("attachEvidence","${pageContext.request.contextPath}","5678","amlUserPendingCaseSerachResult"+id,"Y","Y",caseNos);
		});
		
		$("#saveComments"+id).click(function(){
			var caseNos = $("#caseNo"+id).val();
			var comments = '';
			var lastReviewedDate = '';
			var fraudIndicator = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';
			var reassignToUserCode = '';

			/* if(fraudIndicator == 'PNEF'){
				addedToFalsePositive = 'Y';
				$("#amluserAddToFalsePositive"+id).attr("checked","checked");
			}
			 */
			
			if(userRole == 'ROLE_USER'){
				lastReviewedDate = $("#userAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#userComments"+id).val();
			}
			else if(userRole == 'ROLE_AMLUSER'){
				lastReviewedDate = $("#amluserAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amluserComments"+id).val();
				reassignToUserCode = $("#amloList"+id).val();
			}
			else if(userRole == 'ROLE_AMLO'){
				lastReviewedDate = $("#amloAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amloComments"+id).val();
				// outcomeIndicator = $('#outcomeIndicator'+id).val();
				// removalReason = $('#removalReason'+id).val();
				// highRiskReasonCode = $('#highRiskReasonCode'+id).val();
				if(caseStatus != '7'){
 				   reassignToUserCode = $("#mlroList"+id).val();
				}
			}
			else if(userRole == 'ROLE_MLRO'){
				lastReviewedDate = $("#mlroAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#mlroComments"+id).val();
				// outcomeIndicator = $('#outcomeIndicator'+id).val();
				// removalReason = $('#removalReason'+id).val();
				// highRiskReasonCode = $('#highRiskReasonCode'+id).val();
			}
			
			// alert(caseNos+", "+comments+", "+lastReviewedDate+", "+fraudIndicator+", "+flagType+", "+caseStatus+", "+removalReason+", "+addedToFalsePositive);
			var fullData ="CaseNos="+caseNos+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
						  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+"&amlUserAddToMarkAll="+amlUserAddToMarkAll+
						  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator+
				          "&userActionType=saveOnly&reassignToUserCode="+reassignToUserCode;
			// alert(fullData);
			
			if(lastReviewedDate == '' || comments == ''){
				alert('Please enter Account Reviewed Date and Comments.');
			}else{
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res){
						alert("Saved successfully.");
						$("#"+parentFormId).submit();
						$("#compassCaseWorkFlowGenericModal").modal("hide");
						$(".compass-tab-content").find("div.active").find("form").submit();
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		}); 

		$("#saveAndCloseComments"+id).click(function(){
			var caseNos = $("#caseNo"+id).val();
			var comments = '';
			var lastReviewedDate = '';
			var fraudIndicator = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';
			var reassignToUserCode = '';

			if(fraudIndicator == 'PNEF'){
				addedToFalsePositive = 'Y';
				$("#amluserAddToFalsePositive"+id).attr("checked","checked");
			}
			
			if(userRole == 'ROLE_USER'){
				lastReviewedDate = $("#userAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#userComments"+id).val();
			}
			else if(userRole == 'ROLE_AMLUSER'){
				lastReviewedDate = $("#amluserAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amluserComments"+id).val();
				reassignToUserCode = $("#amloList"+id).val();
			}
			else if(userRole == 'ROLE_AMLO'){
				lastReviewedDate = $("#amloAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amloComments"+id).val();
				outcomeIndicator = $("#outcomeIndicator"+id).val();
				removalReason = $("#removalReason"+id).val();
				highRiskReasonCode = $("#highRiskReasonCode"+id).val();
				reassignToUserCode = $("#mlroList"+id).val();
			}
			else if(userRole == 'ROLE_MLRO'){
				lastReviewedDate = $("#mlroAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#mlroComments"+id).val();
				outcomeIndicator = $("#outcomeIndicator"+id).val();
				removalReason = $("#removalReason"+id).val();
				highRiskReasonCode = $("#highRiskReasonCode"+id).val();
			}
			
			// alert(caseNos+", "+comments+", "+lastReviewedDate+", "+fraudIndicator+", "+flagType+", "+caseStatus+", "+removalReason+", "+addedToFalsePositive);
			var fullData ="CaseNos="+caseNos+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
						  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+"&amlUserAddToMarkAll="+amlUserAddToMarkAll+
						  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator+
				          "&userActionType=saveAndClose&reassignToUserCode="+reassignToUserCode;
			
			if(lastReviewedDate == '' || comments == '' ){
				alert('Please enter Account Reviewed Date and Comments.');
			}else{
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getEvidenceAttachedCount",
					data : "caseNo="+caseNos,
					cache:	false,
					type: "POST",
					success: function(response){
						//alert(response);
						if(response == 0){
							if(confirm("No evidence has been attached. Click Ok to proceed.")){
								$.ajax({
									url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
									cache: false,
									type: "POST",
									data: fullData,
									success: function(res){
										alert("Saved successfully.");
										$("#"+parentFormId).submit();
										$("#compassCaseWorkFlowGenericModal").modal("hide");
										$(".compass-tab-content").find("div.active").find("form").submit();
									},
									error: function(a,b,c){
										alert(a+b+c);
									}
								});
							}
						}else{
							$.ajax({
								url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
								cache: false,
								type: "POST",
								data: fullData,
								success: function(res){
									alert("Saved successfully.");
									$("#"+parentFormId).submit();
									$("#compassCaseWorkFlowGenericModal").modal("hide");
									$(".compass-tab-content").find("div.active").find("form").submit();
								},
								error: function(a,b,c){
									alert(a+b+c);
								}
							});
						}
					}, 
					error: function(a,b,c){
						alert(a+b+c);
					}				
				});

				
			}
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
									<td width="40%"><input type="text" class="form-control input-sm" name="caseNo" id="caseNo${UNQID}" value="${caseNo}" readOnly/></td>
									<!--
									<td width="30%"><button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button></td>
									-->
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
										<td width="20%">Account Reviewed Date </td>
										<c:if test="${ROLE eq 'USER'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="userAcctReviewedDate" 
											       id="userAcctReviewedDate${UNQID}" style="width:100%" value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLUSER'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="amluserAcctReviewedDate" 
											       id="amluserAcctReviewedDate${UNQID}" style="width:100%" value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLO'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="amloAcctReviewedDate" 
											       id="amloAcctReviewedDate${UNQID}" style="width:100%" value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}"/>
										</td>
										</c:if>
										<c:if test="${ROLE eq 'MLRO'}">
										<td width="25%">
											<input type="text" class="form-control input-sm datepicker" name="mlroAcctReviewedDate" 
											       id="mlroAcctReviewedDate${UNQID}" style="width:100%"  value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}"/>
										</td>
										</c:if>
										<td width="10%">&nbsp;</td>
										
										<c:if test="${empty SUSPICIONINDICATORS}">
										    <td width="20%">Sub-Action</td>
											<td width="25%">
												<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}" style="width:100%">
										   			<option value="NA">Not Available<option>
										   		</select>
										   	</td>
									    </c:if>
										
										<c:if test="${not empty SUSPICIONINDICATORS}"> 
										<td width="20%">Sub-Action </td>
										<td width="25%">
											<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}" style="width:100%">
											   	<c:forEach var="suspicionIndicators" items="${SUSPICIONINDICATORS}">
											   		<option value="${suspicionIndicators.SUSPICION_INDICATOR_CODE}">${suspicionIndicators.SUSPICION_INDICATOR_DESC}</option>
											   	</c:forEach>
											</select>	
										</td>
										</c:if>
									</tr>
									<tr>
										<c:if test="${ROLE eq 'AMLUSER'}">
											<c:if test="${action eq 'bonafideOkay'}">
												<td width="20%">Mark All</td>
												<td width="25%">
													<input type="checkbox" class="form-control input-sm" name="amlUserAddToMarkAll" id="amlUserAddToMarkAll${UNQID}" style="width: 20px; margin-top: -4px;" >
												</td>
												<td width="10%">&nbsp;</td>
											</c:if>
											<td width="20%">AMLO List</td>
											<td width="20%">
												<select class="form-control input-sm" name="amloList" id="amloList${UNQID}" style="width:100%">
												    <c:forEach var="AMLUserAMLOMappings" items="${AMLUserAMLOMappingDetails}">
														<option value="${AMLUserAMLOMappings.AMLUSERCODE}" <c:if test="${AMLUserAMLOMappings.AMLUSERCODE eq userCode}">selected="selected"</c:if>>${AMLUserAMLOMappings.AMLOCODE}</option>
													</c:forEach>
												</select>
											</td>
										</c:if>
										<c:if test="${ROLE eq 'AMLO' && caseStatus ne '7'}"> 
											<td width="20%">MLRO List </td>
											<td width="25%">
											<select class="form-control input-sm" name="mlroList" id="mlroList${UNQID}" style="width:100%">
											    <c:forEach var="AMLOMLROMappings" items="${AMLOMLROMappingDetails}">
													<option value="${AMLOMLROMappings.AMLOCODE}" <c:if test="${AMLOMLROMappings.AMLOCODE eq userCode}">selected="selected"</c:if>>${AMLOMLROMappings.MLROCODE}</option>
												</c:forEach>
											</select>
											</td>
											<td colspan="3">&nbsp;</td>
									</c:if> 
									</tr>
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
									    <input type="button" class="btn btn-warning btn-sm" id="attachEvidence${UNQID}" value="Attach Evidence">
										<input type="button" class="btn btn-success btn-sm" id="saveComments${UNQID}" value="Save">
										<input type="button" class="btn btn-success btn-sm" id="saveAndCloseComments${UNQID}" value="Save And Close" >
									</c:if>
									<input type="button" class="btn btn-danger btn-sm" id="closeAddViewCommentsModal${UNQID}" data-dismiss="modal" value="Close Window"/>
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