<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<c:set var="ROLE" value="${userRole}"/>
<c:set var="userCode" value="${LOGGEDUSER}"/>
<c:set var="action" value="${action}"/>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var caseNo = '${caseNo}';
		var caseStatus = '${caseStatus}';
		var flagType = '${flagType}';
		
		$("#saveCommentsForCasesToBeReviewed"+id).click(function(){
			var fraudIndicator = $("#subAction"+id).val();
			var reassignToUserCode = $("#userCodeForReview"+id).val();
			var comments = $("#comments"+id).val();
			var lastReviewedDate = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';
			var amlUserAddToMarkAll = 'N';
			var addedToFalsePositive = 'N';
			var FROMDATE = '${inputFromDate}';
			var TODATE = '${inputToDate}';
			var ALERTCODE = '${inputAlertCode}';
			var BRANCHCODE = '${inputBranchCode}';
			var ACCOUNTNO = '${inputAccountNo}';
			var CUSTOMERID = '${inputCustomerId}';
			var HASANYOLDCASES = '${inputHasAnyOldCases}';
			var CASERATING = '${inputCaseRating}';
			var FROMCASENO = '${inputFromCaseNo}';
			var TOCASENO = '${inputToCaseNo}';
			
			if(comments == "")
			{
				alert('Please enter comments');
				return false;
			}else if(comments.length > 4000){
			   alert('Comments cannot exceed 4000 characters.');
			   return false;
			}
			var fullData ="CaseNos="+caseNo+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
			  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+"&amlUserAddToMarkAll="+amlUserAddToMarkAll+
			  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator+
		      "&userActionType=saveAndClose&reassignToUserCode="+reassignToUserCode+
		      "&FROMDATE="+FROMDATE+"&TODATE="+TODATE+"&TODATE="+TODATE+"&ALERTCODE="+ALERTCODE+"&BRANCHCODE="+BRANCHCODE+"&ACCOUNTNO="+ACCOUNTNO+
		      "&CUSTOMERID="+CUSTOMERID+"&HASANYOLDCASES="+HASANYOLDCASES+"&CASERATING="+CASERATING+"&FROMCASENO="+FROMCASENO+"&TOCASENO="+TOCASENO;
		
			//alert(fullData);	
			
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(response) {
					// alert(response);
					alert("Comments Updated");
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					$(".compass-tab-content").find("div.active").find("form").submit();
				},
				error: function(a,b,c) {
					// alert(a+b+c);
					alert("Error While Updating : "+a+b+c);
				}
			});
		});
	});
	
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_falsePositive">
			<div class="card-header panelSlidingFalsePositive${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Add Comments</h6>
				<%-- <div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div> --%>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Sub-Action</td>
						<td width="30%">
							<select class="form-control input-sm" id="subAction${UNQID}" name="subAction">
							<c:if test="${action eq 'toBeReviewedByAMLO'}">
								<option value="ICI">Inadequate Review/ Closure Comment</option>
								<option value="BRO">Business response to be obtained</option>
								<option value="OTH">Other</option>
							</c:if>
							<c:if test="${action eq 'okayByAMLO'}">
								<option value="FOK">Found to be Okay</option>
								<option value="OTH">Other</option>
							</c:if>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<c:if test="${action eq 'toBeReviewedByAMLO'}">
						<td width="15%">Users List </td>
						<td width="30%">
							<select class="form-control input-sm" name="userCodeForReview" id="userCodeForReview${UNQID}" style="width:100%">
							    <c:forEach var="AllUsersListMappings" items="${ALLUSERSLIST}">
									<option value="${AllUsersListMappings.USERCODE2}" <c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERCODE2}</option>
								</c:forEach>
							</select>
						</td>
						</c:if>
					</tr>
					<tr>
						<td width="15%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" id="comments${UNQID}" name="comments"></textarea>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="saveCommentsForCasesToBeReviewed${UNQID}" class="btn btn-success btn-sm" name="Save" value="Post">
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>