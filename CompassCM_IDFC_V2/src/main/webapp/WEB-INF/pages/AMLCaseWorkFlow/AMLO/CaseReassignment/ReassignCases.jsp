<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var caseNo = '${caseNo}';
		var caseStatus = '${caseStatus}';
		var selectedUserCode = '${selectedUserCode}';		
		var roleId = '${roleId}';
		var reassignmentFor =  '${reassignmentFor}';
		var pendingWith =  '${pendingWith}';
		var pendingWithUsersCode = '${pendingWithUsersCode}';
		var closedBy =  '${closedBy}';
		var closedByUsersCode = '${closedByUsersCode}';
		var caseStatus= '${caseStatus}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'compassReAssignToUserTable'+id, 'dd/mm/yy');
  		var parentFormId = '<%=(String) request.getAttribute("parentFormId")%>';
		
  		$(".compassrow"+id).find("select").select2({
  			dropdownParent: $("#compassCaseWorkFlowGenericModal")
  		});
  		
		//alert(reassignmentFor);
		if(reassignmentFor == 'PendingCases')
			$("#listOfUsers"+id+" option[value='"+ selectedUserCode +"']").remove();
		
		$("#comments"+id).keyup(function(){
			var input = $(this).val();
			re = /[%&<>]/gi;
			var isSplChar = re.test(input);
			if(isSplChar)
			{
				var no_spl_char = input.replace(/[%&<>]/gi, '');
				$(this).val(no_spl_char);
			}
			/* if((/[^a-zA-Z0-9\-\/]/).test( input ) ) {
		        input = input.replace(/[^A-Z0-9]+/ig, "");
		        $(this).val(input);
		    } */
		});
		
		$("#reAssignCaseToUser"+id).click(function(){
			//alert(caseNo);
			/* alert('pendingWith: '+pendingWith+", pendingWithUsersCode: "+pendingWithUsersCode);
			alert('closedBy: '+closedBy+", closedByUsersCode: "+closedByUsersCode);
			 */
			var caseRangeFrom = $("#caseRangeFrom"+id).val();
			var caseRangeTo = $("#caseRangeTo"+id).val();
			var hasOldCases = $("#hasOldCases"+id).val();
			var caseRating = $("#caseRating"+id).val();
			var branchCode = $("#branchCode"+id).val();
			var listOfCaseNos = $("#listOfCaseNos"+id).val();
			var listOfUsers = $("#listOfUsers"+id).val();
			var comments = $("#comments"+id).val();
			var fromDate = $("#FROMDATE"+id).val();
			var toDate = $("#TODATE"+id).val();
			var reassignmentReason = $("#reassignmentReason"+id).val();
			var ageingFor = $("#ageingFor"+id).val();
			
			//alert(selectedUserCode+", "+ageingFor+", "+listOfUsers);
			//alert(reassignmentReason);
			if((ageingFor == listOfUsers) || (ageingFor == selectedUserCode)){
				if(comments.length != 0){
					if(comments.length < 4000) {
						var fullData = "caseRangeFrom="+caseRangeFrom+"&caseRangeTo="+caseRangeTo+"&hasOldCases="+hasOldCases+
									   "&caseRating="+caseRating+"&branchCode="+branchCode+"&listOfCaseNos="+listOfCaseNos+
									   "&listOfUsers="+listOfUsers+"&comments="+comments+
							           "&fromDate="+fromDate+"&toDate="+toDate+"&reassignmentFor="+reassignmentFor+
							           "&pendingWith="+pendingWith+"&pendingWithUsersCode="+pendingWithUsersCode+
							           "&closedBy="+closedBy+"&closedByUsersCode="+closedByUsersCode+
							           "&reassignmentReason="+reassignmentReason+"&ageingFor="+ageingFor ;
						
						  //console.log(fullData);
						
						  $.ajax({
							url: "${pageContext.request.contextPath}/amlCaseWorkFlow/reAssignCaseToUser",
							cache: false,
							type: "POST",
							data: fullData+"&caseNo="+caseNo+"&caseStatus="+caseStatus,
							success: function(res) {
								$("#compassCaseWorkFlowGenericModal").modal("hide");
								alert(res);
								//$("#"+searchButton).click();
								reloadTabContent();
							},
							error: function(a,b,c) {
								alert(a+b+c);
							}
							}); 
					}else{
						alert("Comments cannot exceed 4000 characters.");
					}
				}else{
					alert("Please enter comments.");
				}
			}else{
				alert("Primary Owner usercode should be the Reassignment For usercode or Reassignment To usercode.");
			}
		});		
	});
	

</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_reAssignToUser">
			<div class="card-header  clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.reAssignToUserTableHeader"/></h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassReAssignToUserTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Case Range From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="caseRangeFrom${UNQID}" name="caseRangeFrom"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Range To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="caseRangeTo${UNQID}" name="caseRangeTo"/>
						</td>
					</tr>
					<tr>
						<td width="15%">Has Old Cases</td>
						<td width="30%">
							<select class="form-control input-sm" id="hasOldCases${UNQID}" name="hasOldCases" style="width: 100%">
								<option value="ALL">All</option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
								<option value="R">Review again</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="caseRating${UNQID}" name="caseRating" style="width: 100%">
								<option value="ALL">All</option>
								<option value="HIGH">HIGH</option>
								<option value="MEDUM">MEDIUM</option>
								<option value="LOW">LOW</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="15%">Branch Code</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="branchCode${UNQID}" name="branchCode" placeholder="0000"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List of Case Nos</td>
						<td width="30%">
							<textarea class="form-control input-sm" id="listOfCaseNos${UNQID}" name="listOfCaseNos" placeholder="ALL">${caseNo}</textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">List of Users</td>
						<c:choose>
						<c:when test="${reassignmentFor eq 'ClosedCases'}">
							<td width="30%">
								<select class="form-control input-sm" id="listOfUsers${UNQID}" name="listOfUsers" style="width: 100%">
								    <c:forEach items="${USERSLIST}" var="users">
										<option value="${users['USERCODE']}"
										<c:if test="${users['USERCODE'] eq selectedUserCode}">selected="selected"</c:if>>${users['USERNAME']}</option>
									</c:forEach>
								</select>
							</td>
						</c:when>
						<c:otherwise>
							<td width="30%">
								<select class="form-control input-sm" id="listOfUsers${UNQID}" name="listOfUsers" style="width: 100%">
								    <c:forEach items="${USERSLIST}" var="users">
										<option value="${users['USERCODE']}">${users['USERNAME']}</option>
									</c:forEach>
								</select>
							</td>
						</c:otherwise>
						</c:choose>
						<td width="10%">&nbsp;</td>
						<c:choose>
							<c:when test="${reassignmentFor eq 'ClosedCases'}">
								<td width="15%">Reason of Reopen with Sub action</td>
								<td width="30%">
									<select class="form-control input-sm" name="reassignmentReason" id="reassignmentReason${UNQID}" >
									    <option value="INADEQUATE_CLOSURE_COMMENT">Inadequate Closure Comment</option>
									    <option value="ADDITIONAL_DUE_DILIGENCE_REQ">Additional Due Diligence Required</option>
										<option value="ERRONEOUS_CLOSURE_BY_USER">Erroneous Closure by User</option>
									</select>	
								</td>
							</c:when>
							<c:otherwise>
								<td width="15%">Reason Of Reassignment</td>
								<td width="30%">
									<select class="form-control input-sm" name="reassignmentReason" id="reassignmentReason${UNQID}" >
									    <option value="ADHOC_ACTIVITY_ASSIGNED">Adhoc Activity Assigned</option>
									    <option value="HIGH_PENDENCY">High Pendency</option>
										<option value="ON_TRAINING">On Training</option>
									    <option value="ON_LEAVE">On Leave</option>
									</select>	
								</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<tr>
						<td width="15%">Primary Owner</td>
						<td width="30%">
							<select class="form-control input-sm" id="ageingFor${UNQID}" name="ageingFor" style="width: 100%">
							    <c:forEach items="${USERSLIST}" var="users">
									<option value="${users['USERCODE']}"
										<c:if test="${users['USERCODE'] eq selectedUserCode}">selected="selected"</c:if>>${users['USERNAME']}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
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
						<input type="button" id="reAssignCaseToUser${UNQID}" class="btn btn-primary btn-sm" name="Assign" value="Assign">
						<input type="reset" class="btn btn-danger btn-sm" id="clear${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>