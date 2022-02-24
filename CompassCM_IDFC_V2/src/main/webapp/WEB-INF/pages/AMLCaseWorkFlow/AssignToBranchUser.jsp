<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var caseNo = '${caseNo}';
		var caseStatus = '${caseStatus}';
		var formId = '${formId}';		
		
  		compassTopFrame.init(id, 'compassAssignToBranchUserTable'+id, 'dd/mm/yy');
  		var parentFormId = '<%=(String) request.getAttribute("parentFormId")%>';
		
		
		$("#assignCaseToBranchUser"+id).click(function(){
			//alert(caseNo);
			var caseRangeFrom = $("#caseRangeFrom"+id).val();
			var caseRangeTo = $("#caseRangeTo"+id).val();
			var hasOldCases = $("#hasOldCases"+id).val();
			var caseRating = $("#caseRating"+id).val();
			var branchCode = $("#branchCode"+id).val();
			var listOfCaseNos = $("#listOfCaseNos"+id).val();
			var listOfUsers = $("#listOfUsers"+id).val();
			var comments = $("#comments"+id).val();
			var fullData = "caseRangeFrom="+caseRangeFrom+"&caseRangeTo="+caseRangeTo+"&hasOldCases="+hasOldCases+
						   "&caseRating="+caseRating+"&branchCode="+branchCode+"&listOfCaseNos="+listOfCaseNos+
						   "&listOfUsers="+listOfUsers+"&comments="+comments+"&formId="+formId;
			//alert(fullData+"&caseNo="+caseNo+"&caseStatus="+caseStatus);
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/assignCaseToBranchUser",
				cache: false,
				type: "POST",
				data: fullData+"&caseNo="+caseNo+"&caseStatus="+caseStatus,
				success: function(res) {
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					alert(res);
					$("#"+parentFormId).submit();
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					$(".compass-tab-content").find("div.active").find("form").submit();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_assignToBranchUser">
			<div class="card-header  clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.assignToBranchUserTableHeader"/></h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassAssignToBranchUserTable" style="margin-bottom: 0px;">
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
							<select class="form-control input-sm" id="hasOldCases${UNQID}" name="hasOldCases">
								<option value="ALL">All</option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
								<option value="R">Review again</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="caseRating${UNQID}" name="caseRating">
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
							<textarea class="form-control input-sm" id="listOfCaseNos${UNQID}" name="listOfCaseNos" placeholder="ALL"></textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">List of Users</td>
						<td width="30%">
							<select class="form-control input-sm" id="listOfUsers${UNQID}" name="listOfUsers">
							    <c:forEach items="${USERSLIST}" var="users">
									<option value="${users['USERCODE']}">${users['USERNAME']}</option>
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
						<input type="button" id="assignCaseToBranchUser${UNQID}" class="btn btn-primary btn-sm" name="Assign" value="Assign">
						<input type="reset" class="btn btn-danger btn-sm" id="clear${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>