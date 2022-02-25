<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ASSESSMENTUNIT" value="${ASSESSMENTUNIT}"></c:set>
<c:if test="${empty ASSESSMENTUNIT}">
	<c:set var="ASSESSMENTUNIT" value="${GENERALTABDATA['ASSESSMENTUNIT']}"></c:set>
</c:if>
<c:set var="STATUS" value="${GENERALTABDATA['STATUS']}"/>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var ASSESSMENTUNIT = '${ASSESSMENTUNIT}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var ISNEWFORM = '${ISNEWFORM}';
		alert(COMPASSREFERENCENO+" -- "+ISNEWFORM);
		var STATUS = "${GENERALTABDATA['STATUS']}";
		var CURRENTROLE = "${CURRENTROLE}";
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#riskAssessmentForm :input").prop("disabled", true);
		}
		
		loadCustomerTab();
		loadGeographyTab();
		loadProductsServicesTab();
		loadTransactionsTab();
		loadDeliveryChannelsTab();
		loadControlParametersTab();
		loadRiskRatingTab();
		loadStatusApprovalsTab();
		
		function loadCustomerTab(){
			$("#customer").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadCustomerTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=A-Customer"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#customer").html(res);
				},
				error : function(){
					alert("Error while loading customer tab");
				}
			});
		}
		
		function loadGeographyTab(){
			$("#geography").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadGeographyTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=B-Geography"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#geography").html(res);
				},
				error : function(){
					alert("Error while loading geography tab");
				}
			});
		}
		
		function loadProductsServicesTab(){
			$("#productsServices").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadProductsServicesTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=C-ProductsServices"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#productsServices").html(res);
				},
				error : function(){
					alert("Error while loading products and services tab");
				}
			});
		}
		
		function loadTransactionsTab(){
			$("#transactions").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadTransactionsTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=D-Transactions"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#transactions").html(res);
				},
				error : function(){
					alert("Error while loading transactions tab");
				}
			});
		}
		
		function loadDeliveryChannelsTab(){
			$("#deliveryChannels").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadDeliveryChannelsTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=E-DeliveryChannels"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#deliveryChannels").html(res);
				},
				error : function(){
					alert("Error while loading delivery channels tab");
				}
			});
		}
		
		function loadControlParametersTab(){
			$("#controlParameters").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadControlParametersTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&ASSESSMENTSECTIONCODE=ControlParameters"+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#controlParameters").html(res);
				},
				error : function(){
					alert("Error while loading control parameters tab");
				}
			});
		}
		
		function loadRiskRatingTab(){
			$("#riskRating").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadRiskRatingTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#riskRating").html(res);
				},
				error : function(){
					alert("Error while getting risk rating page");
				}
			});
		}
		
		function loadStatusApprovalsTab(){
			$("#statusApprovals").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/common/loadStatusAndApprovalTab",
				type : "POST",
				cache : false,
				data : "ASSESSMENTUNIT="+ASSESSMENTUNIT+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&ISNEWFORM="+ISNEWFORM,
				success : function(res){
					$("#statusApprovals").html(res);
				},
				error : function(){
					alert("Error while getting status and approval page");
				}
			});
		}
		
		/* $("#saveRiskAssessment"+id).click(function(){ */
		/*$("button[name='saveRiskAssessment']").click(function(){
			var status = $(this).val();
			var formData = $("#searchMasterForm1"+id).serialize();
			formData = formData + "&status="+status;

			var userRole = '${CURRENTROLE}';
			var officerComments = $("#STATUS_CMOFFICERCOMMENTS"+id).val();
			var managerComments = $("#STATUS_CMMANAGERCOMMENTS"+id).val();
			var allow = true;
			
			
		 	if(userRole == 'ROLE_CM_OFFICER' && officerComments == ''){
				alert("CM Officer's Comment is mandatory.");
				allow = false;
			}else if(userRole == 'ROLE_CM_MANAGER' && managerComments == ''){
				alert("CM Manager's Comment is mandatory.");
				allow = false;
			} 
			console.log(formData);

			//if(allow){
				$.ajax({
					url : "${pageContext.request.contextPath}/common/saveRiskAssessmentData",
					type : "POST",
					cache : false,
					data : formData,
					success : function(res){
						alert(res);
					},
					error : function(){
						alert("Error while saving.");
					}
				});
			//}
		});*/
	});
	
	function handleRaiseToRFIBulk(elm){
		/* 
		var yourArray = []
		$("input:checkbox[name=type]:checked").each(function(){
		    yourArray.push($(this));
		});
		console.log(yourArray) */
		/* $('input:checked').each(qs=>{
			
			console.log(qs);
		}) */
		
		
		if(JSON.parse(document.getElementById("selectedQIds").value).length > 0){
			document.getElementById('bulk').value = 'bulk';
			document.getElementById('crn').value = elm.name.split("||")[1]
			/* handleCCRisk(elm) */
			rfiCaseWorkFlowActions.handleRaiseForRFIPage(elm)
		}
		else{
			alert("Please select atleast one question")
		}
	}
</script>
<div class="col-sm-12">
	<div style = "display:none">
		<textarea id = "selectedQIds" value = ""/>
		<textarea id = "rowsData" value = ""/>
		<textarea id = "qId" value = ""/>
		<textarea id = "emailAlertDetails" value = ""/>
		<textarea id = "checkerList" value = ""/>
		<textarea id = "makerList" value = ""/>
		<textarea id = "crn" value = ""/>
		<textarea id = "makerAssignedCases" value = ""/>
		<textarea id = "bulk" value = ""/>
		<textarea id = "selectedMakers" value = ""/>
	</div>
	<div class="card card-primary panel_CDDForm">
		<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
			<h6 class="card-title pull-${dirL}">Inherent Risk Questionnaire for ${ASSESSMENTUNIT}</h6>
		</div>
		<div class="panelSearchForm">
				<div class="card-search-card" >
				<form action="javascript:void(0)" method="POST" id="riskAssessmentForm">
				<input type="hidden" value="${ASSESSMENTUNIT}" name="ASSESSMENTUNIT"></input>
				<input type="hidden" value="${COMPASSREFERENCENO}" name="COMPASSREFNO"></input>
					<ul class="nav nav-pills modalNav" role="tablist">
						<li role="presentation" class="active" id="generalTab">
							<a class="subTab nav-link active" href="#general" aria-controls="tab" role="tab" data-toggle="tab">General</a>
						</li>
						<li role="presentation" id="customerTab">
							<a class="subTab nav-link" href="#customer" aria-controls="tab" role="tab" data-toggle="tab">Customer</a>
						</li>
						<li role="presentation" id="geographyTab">
							<a class="subTab nav-link" href="#geography" aria-controls="tab" role="tab" data-toggle="tab">Geography</a>
						</li>
						<li role="presentation" id="productsServicesTab">
							<a class="subTab nav-link" href="#productsServices" aria-controls="tab" role="tab" data-toggle="tab">Products & Services</a>
						</li>
						<li role="presentation" id="transactionsTab">
							<a class="subTab nav-link" href="#transactions" aria-controls="tab" role="tab" data-toggle="tab">Transactions</a>
						</li>
						<li role="presentation" id="deliveryChannelsTab">
							<a class="subTab nav-link" href="#deliveryChannels" aria-controls="tab" role="tab" data-toggle="tab">Delivery Channels</a>
						</li>
						<li role="presentation" id="controlParametersTab">
							<a class="subTab nav-link" href="#controlParameters" aria-controls="tab" role="tab" data-toggle="tab">Control Parameters</a>
						</li>
						<li role="presentation" id="riskRatingTab">
							<a class="subTab nav-link" href="#riskRating" aria-controls="tab" role="tab" data-toggle="tab">Residual Risk Rating</a>
						</li>
						<li role="presentation" id="statusApprovalsTab">
							<a class="subTab nav-link" href="#statusApprovals" aria-controls="tab" role="tab" data-toggle="tab">Status & Approvals</a>
						</li>
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="general">
							<%-- <input type="hidden" name="COMPASSREFERENCENO" id="COMPASSREFERENCENO${UNQID}" value="${COMPASSREFERENCENO}"/>
							<input type="hidden" name="LINENO" id="LINENO${UNQID}" value="${LINENO}"/> --%>
							<table class="table table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td width="10%">
											Assessment Period
										</td>
										<td width="20%">
											<input type="text" autocomplete="off" class="form-control input-sm" name="GENERAL_ASSESSMENTPERIOD" id="GENERAL_ASSESSMENTPERIOD${UNQID}" value="${GENERALTABDATA['ASSESSMENTPERIOD']}">
										</td>
										<td width="5%">&nbsp;</td>
										<td width="10%">
											 Point of Contact Name
										</td>
										<td width="20%">
											<input type="text"  autocomplete="off" class="form-control input-sm" name="GENERAL_POCNAME" id="GENERAL_POCNAME${UNQID}"  value="${GENERALTABDATA['POCNAME']}">
										</td>
										<td width="5%">&nbsp;</td>
										<td>Point of Contact Email</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_POCEMAIL" id="GENERAL_POCEMAIL${UNQID}" value="${GENERALTABDATA['POCEMAIL']}">
										</td>
									</tr>
									<tr>
										<td>Assessment Unit</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_ASSESSMENTUNIT" id="GENERAL_ASSESSMENTUNIT${UNQID}" 
											       value="${ASSESSMENTUNIT}" readonly="readonly">
										</td>
										<td>&nbsp;</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">Compliance:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Business:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Other:</td>
											 	</tr>
											 </table>
										</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_COMPLIANCE1" id="GENERAL_COMPLIANCE1${UNQID}" value="${GENERALTABDATA['COMPLIANCE1']}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_BUSINESS1" id="GENERAL_BUSINESS1${UNQID}" value="${GENERALTABDATA['BUSINESS1']}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_OTHER1" id="GENERAL_OTHER1${UNQID}" value="${GENERALTABDATA['OTHER1']}">
											 		</td>
											 	</tr>
											 </table>
										</td>
										<td>&nbsp;</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">Compliance:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Business:</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">Other:</td>
											 	</tr>
											 </table>
										</td>
										<td>
											 <table>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_COMPLIANCE2" id="GENERAL_COMPLIANCE2${UNQID}" value="${GENERALTABDATA['COMPLIANCE2']}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_BUSINESS2" id="GENERAL_BUSINESS2${UNQID}" value="${GENERALTABDATA['BUSINESS2']}">
											 		</td>
											 	</tr>
											 	<tr>
											 		<td class="noBgTableTd">
											 			<input type="text" class="form-control input-sm" name="GENERAL_OTHER2" id="GENERAL_OTHER2${UNQID}" value="${GENERALTABDATA['OTHER2']}">
											 		</td>
											 	</tr>
											 </table>
										</td>
									</tr>
									<tr>
										<td colspan="8" style="text-align: left;">
											Who are the key business leads / stakeholders for the assessment unit responsible for providing responses to the questionnaires? Please provide name and role.
										</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											Sr. No.
										</td>
										<td>
											Name
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 Role
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											1
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_NAME1" id="GENERAL_NAME1${UNQID}" value="${GENERALTABDATA['KEYBUSINESSNAME1']}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="GENERAL_ROLE1" id="GENERAL_ROLE1${UNQID}" value="${GENERALTABDATA['KEYBUSINESSROLE1']}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											2
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_NAME2" id="GENERAL_NAME2${UNQID}" value="${GENERALTABDATA['KEYBUSINESSNAME2']}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="GENERAL_ROLE2" id="GENERAL_ROLE2${UNQID}" value="${GENERALTABDATA['KEYBUSINESSROLE2']}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td>
											3
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="GENERAL_NAME3" id="GENERAL_NAME3${UNQID}" value="${GENERALTABDATA['KEYBUSINESSNAME3']}">
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 <input type="text" class="form-control input-sm" name="GENERAL_ROLE3" id="GENERAL_ROLE3${UNQID}" value="${GENERALTABDATA['KEYBUSINESSROLE3']}">
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>									
									<tr>
										<td colspan="8" style="text-align: left;">
											Table below illustrates the weightage of each risk factor:
										</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Risk Factor
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 Weight
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Customer Risk
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 30%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Geographic Risk
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 25%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Products & Services
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 25%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Transactions
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 10%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr style="text-align: center;">
										<td colspan="2">
											Delivery Channel
										</td>
										<td>&nbsp;</td>
										<td colspan="2">
											 10%
										</td>
										<td colspan="3">&nbsp;</td>
									</tr>									
								</tbody>
							</table>
						</div>
						<!-- <div role="tabpanel" class="tab-pane" id="customer"></div>
						<div role="tabpanel" class="tab-pane" id="geography"></div>
						<div role="tabpanel" class="tab-pane" id="productsServices"></div>
						<div role="tabpanel" class="tab-pane" id="transactions"></div>
						<div role="tabpanel" class="tab-pane" id="deliveryChannels"></div>
						<div role="tabpanel" class="tab-pane" id="controlParameters"></div>
						<div role="tabpanel" class="tab-pane" id="riskRating"></div>
						<div role="tabpanel" class="tab-pane" id="statusApprovals"></div> -->
						<div role="tabpanel" class="tab-pane fade in" id="customer" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="customerDetails">
											<jsp:include page="customerTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="geography" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="geographyDetails">
											<jsp:include page="geographyTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="productsServices" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="productsServicesDetails">
											<jsp:include page="productsServicesTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="transactions" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="transactionsDetails">
											<jsp:include page="transactionsTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="deliveryChannels" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="deliveryChannelsDetails">
											<jsp:include page="deliveryChannelsTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="controlParameters" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="controlParametersDetails">
											<jsp:include page="controlParametersTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="riskRating" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="riskRatingDetails">
											<jsp:include page="riskRatingTab.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="statusApprovals" >
							<div class="row">
								<div class="col-sm-12">
									<div class="card card-primary">
										<div id="statusApprovalsDetails">
											<jsp:include page="getStatusAndApproval.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
				<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS != 'CMM-A'}">
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<%-- <button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P">Save</button> --%>
							<button type="button" name="raiseToRFIBulk||QForm||${COMPASSREFERENCENO}" id="raiseToRFIBulk${UNQID}" class="btn btn-primary btn-sm" onclick="handleRaiseToRFIBulk(this)" value="CMO-P">Raise to RFI</button>
							<button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button>
						</div>
					</div>
				</c:if>
				<%-- <c:if test="${CURRENTROLE eq 'ROLE_CM_MANAGER' && STATUS eq 'CMM-P'}">
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<button type="button" name="saveRiskAssessment" id="approveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-A">Approve</button>
							<button type="button" name="saveRiskAssessment" id="rejectRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMM-R">Reject</button>
					
							<button type="button" name="saveRiskAssessment" class="btn btn-success btn-sm" id="approveRiskAssessment${UNQID}" value="CMM-A">Approve</button>
							<button type="button" name="saveRiskAssessment" class="btn btn-danger btn-sm" id="rejectRiskAssessment${UNQID}" value="CMM-R">Reject</button>
						</div>
					</div>
				</c:if> --%>
			</div>
		</div>
	</div>
</div>