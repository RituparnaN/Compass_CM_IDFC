<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'suspicionTransactionDetailsTable';
		compassDatatable.construct(tableClass, "Suspicion Transaction Details", false);
		
	$("#addTransactionsToRS").click(function(){
		$("#compassCaseWorkFlowGenericModal").modal("show");
		$("#compassCaseWorkFlowGenericModal-title").html("Add Suspicious Transaction");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/findSuspiciousTransaction?alertCode="+id,
			cache:	false,
			type: "POST",
			success: function(response){
				$("#compassCaseWorkFlowGenericModal-body").html(response);
			} 
		});
	});
	
	$("#reportingOn").on("change", function(){
		if($(this).val() == "non-customer"){
			$("#nonCustomerFields").css("display", "table-row");
			$("#nonCustomerFields2").css("display", "table-row");
			$("#customerFields").css("display", "none");
			$("#branchField").html("Branch Code <span style='color: red;'>*</span>");
			//$("#changingFieldText").html("Others");
			$("#personNameField").html("Name of Account/Person <span style='color: red;'>*</span>");
		}
		else{
			$("#nonCustomerFields").css("display", "none");
			$("#nonCustomerFields2").css("display", "none");
			$("#customerFields").css("display", "table-row");
			$("#branchField").html("Branch Code");
			$("#changingFieldText").html("Customer ID");
		}
	});
	
	$("#submitRaiseSuspicionForm"+id).click(function(){
		var reportingOn = $("#reportingOn").val();
		var branchCode = $("#branchCode").val();
		var accountOrPersonName = $("#accountOrPersonName").val();
		var alertRating = $("#alertRating").val();
		var accountNo = $("#accountNo").val();
		var customerId = $("#customerId").val();
		var others = $("#others").val();
		var address1 = $("#address1").val(); 
		var address2 = $("#address2").val();
		var typeOfSuspicion = $("#typeOfSuspicion").val();
		var reasonForSuspicion = $("#reasonForSuspicion").val();
		
		var isValidCustId = true;
		var isValidAccNo = true;
		var custIdOrAccNoExist = true;
		//var getBranchCode = "";
		
		if(reportingOn == 'customer'){
			
			if(customerId != "" || accountNo != ""){
				//alert(custIdOrAccNoExist);
				if(accountNo != ""){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/validationCheck",
						data: "accountNo="+accountNo,
						cache:	false,
						type: "POST",
						async: false,
						success: function(response){
							console.log(response);
							for(i in response){
								$("#branchCode").val(response[i].BRANCHCODE).change();
							 	if(response[i].VALIDATIONMSG == 'AccountNo is not valid.'){
									isValidAccNo = false;
							 		custIdOrAccNoExist = false;
							 		alert(response[i].VALIDATIONMSG);
							 	}	
							} 
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});	
				}
				if(customerId != ""){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/validationCheck",
						data: "customerId="+customerId,
						cache:	false,
						type: "POST",
						async: false,
						success: function(response){
							console.log(response);
							for(i in response){
							 	if(response[i].VALIDATIONMSG == 'CustomerId is not valid.'){
							 		isValidCustId = false;
							 		custIdOrAccNoExist = false;
							 		alert(response[i].VALIDATIONMSG);
							 	}	
							} 
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
					
					if(branchCode == "ALL" && isValidCustId){
						custIdOrAccNoExist = false;
						alert("Please select the relevant branch code.");
					}
				}
			}else{
				custIdOrAccNoExist = false;
				//alert(custIdOrAccNoExist);
				alert("Please enter Account No or Customer Id.");
			}
			//alert("custIdOrAccNoExist = "+custIdOrAccNoExist);
			
			if(custIdOrAccNoExist){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
						   "&alertRating="+alertRating+"&accountNo="+accountNo+"&customerId="+customerId+"&typeOfSuspicion="+typeOfSuspicion+ "&reasonForSuspicion="+reasonForSuspicion;
			/*if(reportingOn != "" && branchCode != "" && accountOrPersonName != "" && alertRating != "" &&
			   accountNo != "" && customerId != "" && typeOfSuspicion != "" && reasonForSuspicion != "")*/
			if(reportingOn != "" && alertRating != "" && typeOfSuspicion != "" && reasonForSuspicion != ""){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
					data : fullData,
			        cache:	false,
					type: "POST",
					success: function(res){
						alert(res);
						reloadTabContent();
					}, 
					error: function(a,b,c){
						alert(a+b+c);
					}				
			    }); 
			}else{
				alert("Please fill the form before submitting.");
			} 
			}	
		}
		else if(reportingOn == 'non-customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
			   			   "&alertRating="+alertRating+"&accountNo="+accountNo+"&others="+others+"&address1="+address1+"&address2="+address2+"&typeOfSuspicion="+typeOfSuspicion+ 
			   			   "&reasonForSuspicion="+reasonForSuspicion;
			if(reportingOn != "" && branchCode != "" && alertRating != "" && accountOrPersonName != "" && typeOfSuspicion != "" && reasonForSuspicion != ""){
				if(branchCode == "ALL"){
					alert("Please select a specific Branch Code");
				}else{
					$.ajax({
						url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
						data : fullData,
				        cache:	false,
						type: "POST",
						success: function(res){
							alert(res);
							reloadTabContent();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
				    }); 
				}
			}
			else{
				alert("Please fill the form before submitting.");
			}
		}
	});
	
	$("#attachViewEvidence"+id).click(function(){
		compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","5678","0","Y","Y",id);
	});
	
	$(".compassrow"+id).find("select").select2();
});


function uploadDetailsButton(elm){
	compassFileUpload.init("uploadFile","${pageContext.request.contextPath}","uploadRASAlertsdata","0","Y","Y","");
}

</script>
<style type="text/css">
	fieldset.suspicion{
	border: 1px groove #ddd !important;
    padding: -5px 10px 5px 10px!important;
    margin: 5px 0 0 0 !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.suspicion {
	text-align: left !important;
	width:inherit; 
    border-bottom:none;
    margin: 0px;
    margin-left: 10px;
    margin-bottom : 5px;
    padding: 0px;
}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_raiseSuspicion">
			<div class="card-header panelRaiseSuspicionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Report A Suspicion</h6>
			</div>
			<form id="reportSuspicionForm" >
			<div class="panelSearchForm subjectMatterOfSuspicion" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Subject Matter of Suspicion</legend>
						<table class="table subjectOfSuspicionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%">Reporting On</td>
								<td width="30%">
									<select class="form-control input-sm" id="reportingOn" name="reportingOn">
										<option value="customer">Customer</option>
										<option value="non-customer">Non-Customer</option>
									</select>
								</td>
								<td width="10%">&nbsp;</td>
								<td id="branchField" width="15%">Branch Code</td>
								<td width="30%">
									<select class="form-control input-sm" id="branchCode" name="branchCode">
										<c:forEach var="NAMEVALUE" items="${BRANCHCODES}">
											<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td id="personNameField" width="15%">Name of Account/Person
									<!-- <span style="color: red;">*</span> -->
								</td>
								<td width="30%"><input type="text" class="form-control input-sm" id="accountOrPersonName" name="accountOrPersonName"/></td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Alert Rating</td>
								<td width="30%">
									<select class="form-control input-sm" name="alertRating" id="alertRating">
										<option value="LOW">Low</option>
										<option value="MEDIUM">Medium</option>
										<option value="HIGH">High</option>
									</select> 
								</td>
							</tr>
							<%-- <tr>
								<td width="15%">Account No
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="accountNo" name="accountNo"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('accountNo','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</td>
								<td width="10%">&nbsp;</td>
								<td id="changingFieldText" width="15%">Customer Id</td>
								<td width="30%">
									<div class="input-group" id="custIdContent" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="customerId" name="customerId"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('customerId','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
									<div class="input-group" id="othersContent" style="width:100%; display:none; z-index: 1">
										<textarea class="form-control input-sm" aria-describedby="basic-addon" id="others" name="others"></textarea>
									</div>
								</td>
							</tr> --%>
							<tr id = "customerFields">
								<td width="15%">Account No
									<!-- <span style="color: red;">*</span> -->
								</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="accountNo" name="accountNo"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('accountNo','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</td>
								<td width="10%" style="color: red; font-size: xx-small; overflow: hidden; text-align: center;">Please Enter AccountNo or CustomerId</td>
								<td width="15%">Customer Id
									<!-- <span style="color: red;">*</span> -->
								</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="customerId" name="customerId"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('customerId','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>	
								</td>
							</tr>
							<tr id = "nonCustomerFields" style="display: none; background-color: #f9f9f9;">
								<td width="15%">Address 1</td>
								<td width="30%">
									<textarea  class="form-control input-sm" aria-describedby="basic-addon" id="address1" name="address1"></textarea>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Address 2</td>
								<td width="30%">
									<textarea  class="form-control input-sm" aria-describedby="basic-addon" id="address2" name="address2"></textarea>
								</td>
							</tr>
							<tr id = "nonCustomerFields2" style="display: none; background-color: #FFFFFF;">
								<td width="15%">Others</td>
								<td width="30%">
									<textarea class="form-control input-sm" aria-describedby="basic-addon" id="others" name="others"></textarea>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">&nbsp;</td>
								<td width="30%">&nbsp;</td>
							</tr>
						</table>
					</fieldset>
			</div>
			<div class="panelSearchForm reasonForSuspicion" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Reason For Suspicion</legend>
					
						<table class="table reasonForSuspicionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<!-- <td width="25%">Type of Suspicion</td> -->
								<td width="25%">Alert Type</td>
								<td width="75%">
									<select class="form-control input-sm" id="typeOfSuspicion" name="typeOfSuspicion">
										<c:forEach var="NAMEVALUE" items="${RAISEOFSUSPICION}">
											<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<!-- <td width="25%">Reason for Suspicion -->
								<td width="25%">Alert Indicator
									<span style="color: red;">*</span>
								</td>
								<td width="75%"><textarea class="form-control input-sm" id="reasonForSuspicion" name="reasonForSuspicion"></textarea>
								</td>
							</tr>
						</table>
				</fieldset>
			</div>
		<!-- 	
		<div class="panelSearchForm suspicionTransactionDetails" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Suspicion Transaction Details(if any)</legend>
							<p style="margin-left: 10px; font-weight: bold;">
								<a href="javascript:void(0)" id="addTransactionsToRS">Click here to enter suspicious transaction details</a>
							</p>			
					<div id="suspiciousTransactionTable"></div>
			</fieldset>
		</div>
		 -->
		<div class="card-footer clearfix">
				<div class="pull-right">
				<c:if test="${f:containsIgnoreCase(ROLE,'AMLUSER')}">
					<%-- <input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Submit"/> --%>
					<input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Create Case"/>
					<input type="button" class="btn btn-success btn-sm" id="attachViewEvidence${UNQID}" name="Attach/View Evidence" value="Attach/View Evidence"/>
				</c:if>
				<c:if test="${f:containsIgnoreCase(ROLE,'AMLO') || f:containsIgnoreCase(ROLE,'MLROL1')}">
					<button type="button" id="uploadRASAlertsdata${UNQID}" class="btn btn-primary btn-sm"  onclick="uploadDetailsButton(this)">Upload Alerts Data</button>
				</c:if>
				<input type="reset" class="btn btn-danger btn-sm" id="clearRaiseSuspicionForm${UNQID}" name="Clear" value="Clear"/>
				</div>
		</div>
	</form>
	</div>
</div>
</div>	