<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var selectedCases = '${selectedCases}';
		var caseStatus = '${caseStatus}';
		var selectedCustomerType = '${selectedCustomerType}';		
		var selectedCustomerId = '${selectedCustomerId}';
		var selectedCaseRangeFrom = '${selectedCaseRangeFrom}';
		var selectedCaseRangeTo = '${selectedCaseRangeTo}';
		var caseStatus= '${caseStatus}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'compassAssignCasesToSelfTable'+id, 'dd/mm/yy');
  		var parentFormId = '<%=(String) request.getAttribute("parentFormId")%>';
		
  		$(".compassrow"+id).find("select").select2({
  			dropdownParent: $("#compassCaseWorkFlowGenericModal")
  		});
  				
		$("#comments"+id).keyup(function(){
			var input = $(this).val();
			re = /[%&<>]/gi;
			var isSplChar = re.test(input);
			if(isSplChar)
			{
				var no_spl_char = input.replace(/[%&<>]/gi, '');
				$(this).val(no_spl_char);
			}
		});
		
		$("#assignCasesToSelf"+id).click(function(){
			var caseRangeFrom = $("#caseRangeFrom"+id).val();
			var caseRangeTo = $("#caseRangeTo"+id).val();
			var listOfCustType = $("#listOfCustType"+id).val();
			var listOfCustId = $("#listOfCustId"+id).val();
			var listOfBranchCodes = $("#listOfBranchCodes"+id).val();
			var listOfCaseNos = $("#listOfCaseNos"+id).val();
			var maxCaseCount = $("#maxCaseCount"+id).val();
			var comments = $("#comments"+id).val();
			
			if(comments.length != 0){
				var fullData = "caseRangeFrom="+caseRangeFrom+"&caseRangeTo="+caseRangeTo+"&listOfCustType="+listOfCustType+
							   "&listOfCustId="+listOfCustId+"&listOfBranchCodes="+listOfBranchCodes+"&listOfCaseNos="+listOfCaseNos+
							   "&maxCaseCount="+maxCaseCount+"&comments="+comments;
				//alert(fullData);
				  $.ajax({
						url: "${pageContext.request.contextPath}/amlCaseWorkFlow/assignCasesToSelf",
						cache: false,
						type: "POST",
						data: fullData+"&caseNo="+selectedCases+"&caseStatus="+caseStatus,
						success: function(res) {
							$("#compassCaseWorkFlowGenericModal").modal("hide");
							alert(res);
							reloadTabContent();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
				  }); 
			}else{
				alert("Please enter comments.");
			}
			
		});		
	});
	
	function countChar(val, field) {	
	  var max = 4000;
	  var len = val.value.length;
	  var remainingChars = max - len;
	  if (len >= max) {
		alert('You have reached the limit of '+max+' characters.');
			$('#charsComments').text('You have reached the limit of '+max+' characters.');
	  }else {
		  $('#charsComments').text(remainingChars+' character(s) remaining out of '+max);
	  } 
	}
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_assignCasesToSelf">
			<div class="card-header  clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.assignCasesToSelfTableHeader"/></h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassAssignCasesToSelfTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">List of Customer Type</td>
						<td width="30%">
							<textarea class="form-control input-sm" id="listOfCustType${UNQID}" name="listOfCustType">${selectedCustomerType}</textarea>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List of Customer Id</td>
						<td width="30%">
							<textarea class="form-control input-sm" id="listOfCustId${UNQID}" name="listOfCustId">${selectedCustomerId}</textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">Case Range From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="caseRangeFrom${UNQID}" name="caseRangeFrom" value="${selectedCaseRangeFrom}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Range To</td>
						<td width="30%">
							<%-- <textarea class="form-control input-sm" id="caseRangeTo${UNQID}" name="caseRangeTo">${selectedCaseRangeTo}</textarea> --%>
							<input type="text" class="form-control input-sm" id="caseRangeTo${UNQID}" name="caseRangeTo" value="${selectedCaseRangeTo}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">List of Branch Codes</td>
						<td width="30%">
							<textarea class="form-control input-sm" id="listOfBranchCodes${UNQID}" name="listOfBranchCodes"></textarea>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List of Case No(s)</td>
						<td width="30%">
							<textarea class="form-control input-sm" id="listOfCaseNos${UNQID}" name="listOfCaseNos">${selectedCases}</textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">Maximum Case Count</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="maxCaseCount${UNQID}" name="maxCaseCount"/>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td width="15%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" id="comments${UNQID}" name="comments" onkeyup="countChar(this,'comments')" maxlength="4000"></textarea>
							 <span class="badge badge-info" id="charsComments" style="margin: 2px 0 0 4px; float: right;">4000 character()s) remaining out of 4000</span> 
						</td>
					</tr>
					</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="assignCasesToSelf${UNQID}" class="btn btn-primary btn-sm" name="Assign" value="Assign">
						<input type="reset" class="btn btn-danger btn-sm" id="clear${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>