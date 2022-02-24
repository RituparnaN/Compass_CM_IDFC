<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'CDDStatus${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var LINENO = '${LINENO}';
		var STATUS = '${STATUSTABDATA["STATUS"]}';
		compassDatatable.construct(tableClass, "Risk Assement Search", true);
		
		var userRole = '${CURRENTROLE}';
		var userCode = '${USERCODE}';
		var currentTimestamp = compassTopFrame.getDate(new Date(),"","");
		
		if(STATUS == 'CMM-A'){
			$("#statusTable"+id).find("input, textarea, select").prop("disabled", true);
		}else if(userRole == 'ROLE_CM_OFFICER' && STATUS != 'CMM-A'){
			$("#STATUS_CMOFFICERCODE"+id).val(userCode);
			$("#STATUS_CMOFFICERTIMESTAMP"+id).val(currentTimestamp);
			$("#STATUS_CMMANAGERCOMMENTS"+id).prop("readonly", "readonly");
		}else if(userRole == 'ROLE_CM_MANAGER' && STATUS != 'CMM-A'){
			$("#STATUS_CMMANAGERCODE"+id).val(userCode);
			$("#STATUS_CMMANAGERTIMESTAMP"+id).val(currentTimestamp);
			$("#STATUS_CMOFFICERCOMMENTS"+id).prop("readonly", "readonly");
		} 
		
		$("button[name='saveRiskAssessment']").click(function(){
			var status = $(this).val();
			var userRole = '${CURRENTROLE}';
			var officerCode = $("#STATUS_CMOFFICERCODE"+id).val();
			var managerCode = $("#STATUS_CMMANAGERCODE"+id).val();
			var officerComments = $("#STATUS_CMOFFICERCOMMENTS"+id).val();
			var managerComments = $("#STATUS_CMMANAGERCOMMENTS"+id).val();
			var allow = true;
			var formData;
			
			if(userRole == 'ROLE_CM_OFFICER' && officerComments == ''){
				alert("CM Officer's Comment is mandatory.");
				allow = false;
			}else if(userRole == 'ROLE_CM_MANAGER' && managerComments == ''){
				alert("CM Manager's Comment is mandatory.");
				allow = false;
			}
			
			if(userRole == 'ROLE_CM_OFFICER' && officerComments != ''){
				//formData = $(document).find("form#riskAssessmentForm").serialize();
				formData = $(document).find("form#riskAssessmentForm").serializeArray();
				//formData = formData+"&status="+status;
				formData.push({
				    name: "status",
				    value: status
				});
				
				console.log(formData);
				 
				var custFinalRisk = "";
				var geoFinalRisk = 0;
				var productFinalRisk = 0;
				var txnFinalRisk = 0;
				var deliveryFinalRisk = 0;
				var ctrlParamsFinalRisk = 0;
				var residualFinalRisk = 0;
				
				for (index = 0; index < formData.length; ++index) {
				    if (formData[index].name.startsWith("CUSTOMER_FINALRISKRATING")) {
				    	custFinalRisk = custFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("GEOGRAPHY_FINALRISKRATING")) {
				    	geoFinalRisk = geoFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("PRODUCTSSERVICES_FINALRISKRATING")) {
				    	productFinalRisk = productFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("TRANSACTIONS_FINALRISKRATING")) {
				    	txnFinalRisk = txnFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("DELIVERYCHANNELS_FINALRISKRATING")) {
				    	deliveryFinalRisk = deliveryFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("CONTROLPARAMETERS_FINALRISKRATING")) {
				    	ctrlParamsFinalRisk = ctrlParamsFinalRisk+formData[index].value;
				    }
				    
				    if (formData[index].name.startsWith("TOTAL_RESIDUALFINALRISKRATING")) {
				    	residualFinalRisk = residualFinalRisk+formData[index].value;
				    }
				}
				
				if(custFinalRisk > 9){
					alert("The customer final risk rating should not exceed 9.");
					allow = false;
				}else if(geoFinalRisk > 9){
					alert("The geography final risk rating should not exceed 9.");
					allow = false;
				}else if(productFinalRisk > 9){
					alert("The products and services final risk rating should not exceed 9.");
					allow = false;
				}else if(txnFinalRisk > 9){
					alert("The transactions final risk rating should not exceed 9.");
					allow = false;
				}else if(deliveryFinalRisk > 9){
					alert("The delivery channels final risk rating should not exceed 9.");
					allow = false;
				}else if(ctrlParamsFinalRisk > 10){
					alert("The control parameters final risk rating should not exceed 10.");
					allow = false;
				}else if(residualFinalRisk > 10){
					alert("The residual final risk rating should not exceed 10.");
					allow = false;
				}else{
					allow = true;
				}
			}else if(userRole == 'ROLE_CM_MANAGER' && managerComments != ''){
				formData = "STATUS_CMOFFICERCODE="+officerCode+"&STATUS_CMMANAGERCODE="+managerCode+"&STATUS_CMOFFICERCOMMENTS="+
							officerComments+"&STATUS_CMMANAGERCOMMENTS="+managerComments+"&COMPASSREFNO="+COMPASSREFERENCENO+"&status="+status;
				allow = true;
			}
			
			//console.log(formData);
			//alert(allow);
			if(allow){
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
			}
		});
	});
	
	function loadStatusApprovalsLocal(elm,COMPASSREFERENCENO, LINENO){
		$(elm).attr("disabled","disabled");
		$(elm).html("Refreshing...")
		loadStatusApprovals(COMPASSREFERENCENO, LINENO);
	}
</script>
<c:set var="STATUS" value="${STATUSTABDATA['STATUS']}"/>

<table class="table table-striped" id="statusTable${UNQID}" style="margin-bottom: 0px;">
	<tr>
		<td>Form Status</td>
		<td>
			<c:choose>
				<c:when test="${STATUS eq 'CMO-P'}">
					Pending with CM Officer
				</c:when>
				<c:when test="${STATUS eq 'CMM-P'}">
					Pending with CM Manager
				</c:when>
				<c:when test="${STATUS eq 'CMM-R'}">
					Rejected by CM Manager
				</c:when>
				<c:when test="${STATUS eq 'CMM-A'}">
					Approved by CM Manager. Risk Assessment Complete.
				</c:when>
				<c:otherwise>
					In Progress
				</c:otherwise>
			</c:choose>
		</td>
		<td colspan="3">&nbsp;</td>
		<%-- <td colspan="2" style="text-align: center;">
			<c:if test="${CURRENTROLE eq 'ROLE_CM_MANAGER' && STATUS eq 'CMM-P'}">
					<button type="button" class="btn btn-success btn-sm btnCDDFormApproveReject" id="btnApprove" action="APPROVE">Approve</button>
					<button type="button" class="btn btn-danger btn-sm btnCDDFormApproveReject" id="btnReject" action="REJECT">Reject</button>
			</c:if>
		</td> --%>
	</tr>
	<tr>
		<td width="15%">
			CM Officer Code
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMOFFICERCODE" id="STATUS_CMOFFICERCODE${UNQID}" />
		</td>
		<td width="4%">&nbsp;</td>
		<td width="15%">
			CM Officer Timestamp
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMOFFICERTIMESTAMP" id="STATUS_CMOFFICERTIMESTAMP${UNQID}" />
		</td>
	</tr>
	<tr>
		<td width="15%">
			CM Officer Comments
		</td>
		<td colspan="4">
			<textarea rows="2" cols="2" class="form-control" name="STATUS_CMOFFICERCOMMENTS" id="STATUS_CMOFFICERCOMMENTS${UNQID}">${STATUSTABDATA['CMOFFICERCOMMENTS']}</textarea>
		</td>
	</tr>
	<tr>
		<td width="15%">
			CM Manager Code
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMMANAGERCODE" id="STATUS_CMMANAGERCODE${UNQID}" />
		</td>
		<td width="4%">&nbsp;</td>
		<td width="15%">
			CM Manager Timestamp
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm"  readonly="readonly" name="STATUS_CMMANAGERTIMESTAMP" id="STATUS_CMMANAGERTIMESTAMP${UNQID}" />
		</td>
	</tr>
	<tr>
		<td width="20%">
			CM Manager Comments
		</td>
		<td colspan="4">
			<textarea rows="2" cols="2" class="form-control" name="STATUS_CMMANAGERCOMMENTS" id="STATUS_CMMANAGERCOMMENTS${UNQID}">${STATUSTABDATA['CMMANAGERCOMMENTS']}</textarea>
		</td>
	</tr>
</table>
<br/>
<c:set var="AUDITLOGLIST" value="${STATUSAUDITLOGDATA}"/>
<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable CMStatus${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th width="15%">User Name</th>
				<th width="10%">User Role</th>
				<th width="10%">Status</th>
				<th width="15%">Timestamp</th>
				<th width="40%">Comments</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="AUDITLOGLIST" items="${AUDITLOGLIST}">
				<tr>
					<td>${AUDITLOGLIST['USERCODE']}</td>
					<td>${AUDITLOGLIST['USERROLE']}</td>
					<td>${AUDITLOGLIST['STATUS']}</td>
					<td>${AUDITLOGLIST['USERTIMESTAMP']}</td>
					<td>${AUDITLOGLIST['COMMENTS']}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
<c:if test="${CURRENTROLE eq 'ROLE_CM_OFFICER' && STATUS ne 'CMM-A'}">
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button type="button" name="saveRiskAssessment" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm" value="CMM-P">Save</button>
			<%-- <button type="button" name="saveRiskAssessment" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm" value="CMO-P">Save as draft</button> --%>
		</div>
	</div>
</c:if>
<c:if test="${CURRENTROLE eq 'ROLE_CM_MANAGER' && STATUS eq 'CMM-P'}">
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button type="button" name="saveRiskAssessment" class="btn btn-success btn-sm" id="approveRiskAssessment${UNQID}" value="CMM-A">Approve</button>
			<button type="button" name="saveRiskAssessment" class="btn btn-danger btn-sm" id="rejectRiskAssessment${UNQID}" value="CMM-R">Reject</button>
		</div>
	</div>
</c:if>