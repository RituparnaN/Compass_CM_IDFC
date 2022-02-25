<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
	String message = (String) request.getAttribute("MESSAGE");
	List<Map<String, String>> templateDetails = request.getAttribute("TEMPLATES") != null ? (List<Map<String, String>>) request.getAttribute("TEMPLATES") : new ArrayList<Map<String, String>>();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!--[if lt IE 9]>
			<script src="<%=contextPath%>/scripts/html5shiv.js"></script>
			<script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
			<script src="<%=contextPath%>/scripts/respond.min.js"></script>
		<![endif]-->
		
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css"/>
		<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css">
		<script type="text/javascript">
			$(document).ready(function(){
				var message = '<%=message%>';
				if(message != ""){
					alert(message);
					document.location.href = "generateAutoSTRView";
				}
				
				$("#TRANSACTIONFROMDATE").datepicker({
					defaultDate: "+1w",
					numberOfMonths: 1,
					changeMonth: true,
					changeYear: true,
				    dateFormat:'dd/mm/yy',
				    onClose: function(selecteddate){
				    	$("#TRANSACTIONTODATE").datepicker("option", "minDate", selecteddate);
				    }
				});
				
				$("#TRANSACTIONTODATE").datepicker({
					changeMonth: true,
					defaultDate: "+1w",
					numberOfMonths: 1,
					changeYear: true,
				    dateFormat:'dd/mm/yy',
				    onClose: function(selecteddate){
				    	$("#TRANSACTIONFROMDATE").datepicker("option", "maxDate", selecteddate);
				    }
				});

				$("#selectAccount").click(function(){
					var primaryCustomerId = $("#PRIMARYCUSTOMERID").val();
					var secondaryCustomerId = $("#SECONDARYCUSTOMERID").val();
					$("#accountsDetails").html("<center>Please wait while system fetches all the accounts for the specified Customer IDs</center>");
					$.ajax({
						type : "POST",
						url : "<%=contextPath%>/selectAccountNumber?primaryCustomerId="+primaryCustomerId+"&secondaryCustomerId="+secondaryCustomerId,
						cache : false,
						success : function(response){
							$("#accountsDetails").html(response);
						},
						error : function(a,b,c){
							$("#accountsDetails").html("Error occured while fetching account Details");
						}
					});
				});
				
				$("#selectedAccountNumber").click(function(){
					var accountNumber = "";
					$(".accountNumberCheck").each(function(){
						if($(this).is(":checked")){
							accountNumber = accountNumber+$(this).val()+",";
						}
					});
					$("#ACCOUNTNUMBERS").val(accountNumber);
					$('#accountSelectionModal').modal('hide');
				});
				
				$("#generateGOS").click(function(){
					var primaryCustomerId = $("#PRIMARYCUSTOMERID").val();
					var secondaryCustomerId = $("#SECONDARYCUSTOMERID").val();
					var accountNumbers = $("#ACCOUNTNUMBERS").val();
					var templateID = $("#TEMPLATEID").val();
					var fromDate = $("#TRANSACTIONFROMDATE").val();
					var toDate = $("#TRANSACTIONTODATE").val();
					
					if(templateID != "" && accountNumbers.length > 0){
						window.open('<%=contextPath%>/GroundOfSuspicionForSTRTemplateDOC?primaryCustomerId='+primaryCustomerId+'&secondaryCustomerId='+secondaryCustomerId+'&accountNumbers='+accountNumbers+'&templateId='+templateID+'&fromDate='+fromDate+'&toDate='+toDate+'&caseNo=N.A.','GOSDOC','height=200, width=200, resizable=Yes, scrollbars=Yes');
					}else{
						alert("Please enter Customer IDs, Account Numbers and Template before generating GOS");
					}
				});
				
				$("#updateGOS").click(function(){
					var primaryCustomerId = $("#PRIMARYCUSTOMERID").val();
					var secondaryCustomerId = $("#SECONDARYCUSTOMERID").val();
					var accountNumbers = $("#ACCOUNTNUMBERS").val();
					var templateID = $("#TEMPLATEID").val();
					var fromDate = $("#TRANSACTIONFROMDATE").val();
					var toDate = $("#TRANSACTIONTODATE").val();
					
					if(templateID != "" && accountNumbers.length > 0){
						var url = 'GroundOfSuspicionForSTRTemplate?primaryCustomerId='+primaryCustomerId+'&secondaryCustomerId='+secondaryCustomerId+'&accountNumbers='+accountNumbers+'&templateId='+templateID+'&fromDate='+fromDate+'&toDate='+toDate;
						$.ajax({
							type : "POST",
							url : url,
							cache : false,
							success : function(response){
								alert(response);
							}
						});
					}else{
						alert("Please enter Customer IDs, Account Numbers and Template before generating GOS");
					}
				});
			});
			
			function checkAll(elm){
				if($(elm).is(":checked")){
					$(".accountNumberCheck").each(function(){
						$(this).prop("checked", true);
					});
				}else{
					$(".accountNumberCheck").each(function(){
						$(this).prop("checked", false);
					});
				}
			}
			
			function getTemplateDetails(elm){
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/getSTRTemplateView?templateId="+elm.value,
					cache : false,
					success : function(response){
						$("#GROUNDOFSUSPICION").val(response.GROUNDOFSUSPICION);
						$("#ALERTREDFLAGINDICATOR").val(response.ALERTREDFLAGINDICATOR);
						$("#INVESTIGATIONDETAILS").val(response.INVESTIGATIONDETAILS);
						$("#LEADETAILS").val(response.LEADETAILS);
						$("#SOURCEOFALERT option[value='"+response.SOURCEOFALERT+"']").prop('selected', true);
						$("#STRREASON option[value='"+response.STRREASON+"']").prop('selected', true);
						$("#ATTEMPTEDTRANSACTIONS option[value='"+response.ATTEMPTEDTRANSACTIONS+"']").prop('selected', true);
						$("#PRIORITYRATING option[value='"+response.PRIORITYRATING+"']").prop('selected', true);
						$("#REPORTCOVERAGE option[value='"+response.REPORTCOVERAGE+"']").prop('selected', true);
						$("#ADDITIONALDOCUMENTS option[value='"+response.ADDITIONALDOCUMENTS+"']").prop('selected', true);
						$("#LEAINFORMED option[value='"+response.LEAINFORMED+"']").prop('selected', true);
						$("#SOURCEOFALERT option[value='"+response.SOURCEOFALERT+"']").prop('selected', true);
					},
					error : function(a,b,c){
						alert("Error occured while fetching Template Details");
					}
				});
			}
			
			function strConfirmation(){
				if(confirm("Do you want to generate STR?")){
					$("#generateSTRBTN").attr("disabled","disabled");
					return true;
				}else
					return false;
			}
		</script>
		<title>Generate STR</title>
	</head>
	<body>
		<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" id="accountSelectionModal">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title">Select Accounts</h4>
		      </div>
		      <div class="modal-body" id="accountsDetails">
		      	...
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-primary" id="selectedAccountNumber">Select</button>
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		      </div>
		    </div>
		  </div>
		</div>
		<div class="container-fluid" style="margin-left: 10px;">
			<div class="row">
				<div class="col-xs-12">
					<div class="card card-info">
					  <div class="card-header">Generate STR</div>
					  <form action="<%=contextPath%>/generateAutoSTR" method="post" onsubmit="return strConfirmation()">
					  <table class="table table-bordered table-striped">
					  	<tr>
					  		<td>
					  			Primary Customer ID
					  		</td>
					  		<td>
					  			<input type="text" class="form-control input-sm" name="PRIMARYCUSTOMERID" id="PRIMARYCUSTOMERID">
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Secondary Customer ID
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="2" cols="5" name="SECONDARYCUSTOMERID" id="SECONDARYCUSTOMERID"></textarea>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Account Numbers
					  		</td>
					  		<td>
					  			<table width="100%">
					  				<tr>
					  					<td width="90%">
					  						<textarea class="form-control" rows="2" cols="5" name="ACCOUNTNUMBERS" id="ACCOUNTNUMBERS"></textarea>
					  					</td>
					  					<td width="10%" style="text-align: right;">
					  						<button type="button" id="selectAccount" class="btn btn-primary" data-toggle="modal" data-target=".bs-example-modal-lg">Select Accounts</button>
					  					</td>
					  				</tr>
					  			</table>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Transaction Date Range
					  		</td>
					  		<td>
					  			<div class="input-daterange input-group">
									<span class="input-group-addon">FROM</span>
									<input type="text" class="form-control" id="TRANSACTIONFROMDATE" name="TRANSACTIONFROMDATE"/>
									<span class="input-group-addon">TO</span>
									<input type="text" class="form-control" id="TRANSACTIONTODATE" name="TRANSACTIONTODATE"/>
								</div>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td width="30%">
					  			Select Template
					  		</td>
					  		<td width="70%">
					  			<select class="form-control input-sm" name="TEMPLATEID" id="TEMPLATEID" onchange="getTemplateDetails(this)">
					  				<option value="">Select One</option>
					  				<%
					  				for(int i = 0; i < templateDetails.size(); i++){
					  					Map<String, String> template = templateDetails.get(i);
					  					if("E".equals(template.get("STATUS"))){
					  					%>
					  					<option value="<%=template.get("TEMPLATEID")%>"><%=template.get("TEMPLATENAME")%></option>
					  					<%
					  					}
					  				}					  				
					  				%>
					  			</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Ground of Suspicion
					  		</td>
					  		<td>
					  			<table width="100%">
					  				<tr>
					  					<td width="100%" colspan="2">
					  						<textarea class="form-control" rows="10" cols="5" name="GROUNDOFSUSPICION" id="GROUNDOFSUSPICION"></textarea>
					  					</td>
					  					<!--<td width="10%" style="text-align: right;">
					  						<button type="button" class="btn btn-primary" id="updateGOS">Update GOS</button>
					  					</td>-->
					  				</tr>
					  			</table>
					  			
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Source of Alert
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="SOURCEOFALERT" id="SOURCEOFALERT">
					  				<option value="">Select One</option>
									<option value="BA" >BA - Business Associates</option>
									<option value="CV" >CV - Customer Verification</option>
									<option value="EI" >EL - Employee Initiated</option>
									<option value="LQ" >LQ - Law Enforcement Agency Query</option>
									<option value="MR" >MR - Media Report</option>
									<option value="PC" >PC - Public Complaint (Replace CC with PC)</option>
									<option value="RM" >RM - Risk Management System</option>
									<option value="TM" >TM - Transaction Monitoring</option>
									<option value="TY" >TY - Topology</option>
									<option value="WL" >WL - Watch List</option>
									<option value="XX" >XX - Non Categorized</option>
									<option value="XX" >ZZ - Others</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Alert Red Flag Indicator
					  		</td>
					  		<td>
					  			<input type="text" class="form-control input-sm" name="ALERTREDFLAGINDICATOR" id="ALERTREDFLAGINDICATOR" />
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Reason for Filing STR
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="STRREASON" id="STRREASON">
					  				<option value="">Select One</option>
									<option value="A" >Proceeds of Crime</option>
									<option value="B" >Unusual or Complex Transaction</option>
									<option value="C" >No Economic Rationale or Bonafide Purpose</option>
									<option value="D" >Financing Of Terrorism</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Attempted Transactions
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="ATTEMPTEDTRANSACTIONS" id="ATTEMPTEDTRANSACTIONS">
					  				<option value="">Select One</option>
									<option value="Y">Y - Yes</option>
									<option value="N">N - No</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Priority Rating
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="PRIORITYRATING" id="PRIORITYRATING">
					  				<option value="">Select One</option>
									<option value="P1">P1 - Very High Priority</option>
									<option value="P2">P2 - High Priority</option>
									<option value="P3">P3 - Normal Priority</option>
									<option value="XX">XX - Non Categorized</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Report Coverage
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="REPORTCOVERAGE" id="REPORTCOVERAGE">
					  				<option value="">Select One</option>
									<option value="C">C - Complete</option>
									<option value="P">P - Partial</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Additional Documents
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="ADDITIONALDOCUMENTS" id="ADDITIONALDOCUMENTS">
					  				<option value="">Select One</option>
									<option value="Y">Y - Yes</option>
									<option value="N">N - No</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Details of Investigation
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="5" cols="5" name="INVESTIGATIONDETAILS" id="INVESTIGATIONDETAILS"></textarea>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Law Enforcement Agency Informed?
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="LEAINFORMED" id="LEAINFORMED">
					  				<option value="">Select One</option>
									<option value="R">Correspondence Received from LEA</option>
									<option value="S">Matter Referred to LEA</option>
									<option value="N">No Correspondence Sent or Received</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Law Enforcement Agency Details
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="5" cols="5" name="LEADETAILS" id="LEADETAILS"></textarea>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td colspan="2" style="text-align: center">
					  			<button type="submit" class="btn btn-success btn-sm" id="generateSTRBTN">Generate STR</button>
					  			<!--<button type="button" id="generateGOS" class="btn btn-success btn-sm">Generate GOS</button>-->
					  		</td>
					  	</tr>
					  </table>
					  </form>
					  </div>
				 </div>
				</div>
			</div>
		</body>
	</html>
	