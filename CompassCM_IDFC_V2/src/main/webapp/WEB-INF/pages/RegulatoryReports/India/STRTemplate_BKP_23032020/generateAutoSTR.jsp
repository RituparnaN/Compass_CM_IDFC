<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%@ page import="java.io.*,java.sql.*,java.util.*,java.sql.ResultSet,java.text.*,java.text.SimpleDateFormat" %>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String message = (String) request.getAttribute("MESSAGE");
List<Map<String, String>> templateDetails = request.getAttribute("TEMPLATES") != null ? (List<Map<String, String>>) request.getAttribute("TEMPLATES") : new ArrayList<Map<String, String>>();
List<Map<String, String>> typeOfSuspicionDetails = request.getAttribute("TYPEOFSUSPICIONS") != null ? (List<Map<String, String>>) request.getAttribute("TYPEOFSUSPICIONS") : new ArrayList<Map<String, String>>();
%>
<%
String groupCode = "AMLO" ; // session.getAttribute("GROUPOFLOGGEDUSER") == null ? "N.A.":session.getAttribute("GROUPOFLOGGEDUSER").toString();
ArrayList amlUsersList = new ArrayList();
Map amlUsersMap = new HashMap();
amlUsersList.add("AMLUser");
amlUsersMap.put("AMLUser","AMLUser");	
%>
<html>
	<head>
		<!-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap.min.css"/>
		
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-ui.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/bootstrap.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap.min.css"/>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
		 -->
		<script type="text/javascript">
			$(document).ready(function(){
				var message = '<%=message%>';
				if(message != ""){
					// alert(message);
					document.location.href = "generateAutoSTRView";
				}

				$("#REFERENCECASEDATE").datepicker({
					defaultDate: "+0w",
					numberOfMonths: 1,
					changeMonth: true,
					changeYear: true,
				    dateFormat:'dd/mm/yy',
				    onClose: function(selecteddate){
				    	$("#REFERENCECASEDATE").datepicker("option", "minDate", selecteddate);
				    }
				});
				
				$("#TRANSACTIONFROMDATE").datepicker({
					defaultDate: "+0w",
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
					defaultDate: "+0w",
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
					
					$("#accountsDetails").modal("show");
					$("#accountsDetails-body").html("<center>Please wait while system fetches all the accounts for the specified Customer IDs</center>");
					$.ajax({
						type : "POST",
						url : "<%=contextPath%>/common/selectAccountNumber?${_csrf.parameterName}=${_csrf.token}&primaryCustomerId="+primaryCustomerId+"&secondaryCustomerId="+secondaryCustomerId,
						cache : false,
						success : function(response){
							$("#accountsDetails-body").html(response);
						},
						error : function(a,b,c){
							$("#accountsDetails-body").html("Error occured while fetching account Details");
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
						window.open('<%=contextPath%>/common/GroundOfSuspicionForSTRTemplateDOC?primaryCustomerId='+primaryCustomerId+'&secondaryCustomerId='+secondaryCustomerId+'&accountNumbers='+accountNumbers+'&templateId='+templateID+'&fromDate='+fromDate+'&toDate='+toDate+'&caseNo=N.A.','GOSDOC','height=200, width=200, resizable=Yes, scrollbars=Yes');
					}else{
						alert("Please enter Customer IDs, Account Numbers and Template before generating GOS");
					}
				});

				$("#IS_REPEATSAR").on("change", function(){
					//alert($(this).val());
					if($(this).val() == "YES"){
						$("#repeatSARRemarksField").css("display", "table-row");
						//$("#repeatSARRemarks").val("");
					}
					else{
						$("#repeatSARRemarksField").css("display", "none");
						$("#REPEATSAR_REMARKS").val('');
					}
				});
				
				$("#generateSTRBTN").click(function(){
					
					if(confirm("Do you want to generate STR?")){

						var referenceCaseDate = $("#REFERENCECASEDATE").val();
						var repeatSAR = $("#IS_REPEATSAR").val();
						var repeatSARRemarks = $("#REPEATSAR_REMARKS").val();
						var sourceOfInternalSAR = $("#SOURCEOF_INTERNAL_SAR").val();
																		
						if(!checkDate(referenceCaseDate)){
							  return false;
					    }
						
						if(!checkRepeatSARRemarks(repeatSAR, repeatSARRemarks)){
					    	return false;
					    }
						
						if(!checkSrcOfInternalSAR(sourceOfInternalSAR)){
							  return false;
					    }
						
						$("#generateSTRBTN").attr("disabled","disabled");
						
						var formData = $("#generateAutoSTRForm").serialize();
						
						$(".checkboxValForSerializeForm").each(function(n){
							if(!$(this).is(":checked")){
								//alert("&"+$(this).attr("name")+"=N");
								formData = formData + "&"+$(this).attr("name")+"=N" ;
							}
						});
						/* alert(formData);
						document.write(formData); */
						$.ajax({
							type : "POST",
							url : "<%=contextPath%>/common/generateAutoSTR",
							data : formData,
							cache : false,
							success : function(response){
								alert(response);
							},
							error : function(a,b,c){
								alert("Error occured while fetching Template Details");
							}
						});
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
						var url = 'GroundOfSuspicionForSTRTemplate?${_csrf.parameterName}=${_csrf.token}&primaryCustomerId='+primaryCustomerId+'&secondaryCustomerId='+secondaryCustomerId+'&accountNumbers='+accountNumbers+'&templateId='+templateID+'&fromDate='+fromDate+'&toDate='+toDate;
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
					url : "<%=contextPath%>/common/getSTRTemplateView?${_csrf.parameterName}=${_csrf.token}&templateId="+elm.value,
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

			function checkDate(dateToCheck){
				if(dateToCheck == '' || dateToCheck == 'null'){
				   alert('Please enter the reference case date.');
				   return false;
				}
				var datePatArr = dateToCheck.split("/");
				if(datePatArr.length == 3){
					var dd = datePatArr[0];
					var mm = datePatArr[1];
					var yy = datePatArr[2];
					if(dd.length == 2 && mm.length == 2 && yy.length == 4 && mm <= 12){
						var date1 = new Date(yy, parseInt(mm-1), dd); //Date((parseInt(mm)+1-1)+"/"+dd+"/"+yy);				
						var dateObj = new Date();
						var date2 = new Date(parseInt(dateObj.getMonth()+1)+"/"+dateObj.getDate()+"/"+dateObj.getFullYear());
						var diffDays = ((date2.getTime() - date1.getTime()));
						if(diffDays >= 0){
							return true;
						}else{
							alert("Date should be less than sysdate.");
							return false;					
						}
					}else{
						alert("Date format is wrong.");
						return false;
					}
				}else{
					alert("Date format is wrong.");
					return false;
				}
			}
			
			function checkRepeatSARRemarks(isRepeat, repeatRemarks){
				if(isRepeat == "YES" && (repeatRemarks == null || repeatRemarks == "")){
					alert("Please input the remarks for Repeat SAR");
					return false;
				}else{
					return true;
				}
			}
			
			function checkSrcOfInternalSAR(sourceOfInternalSAR){
				if(sourceOfInternalSAR == "" || sourceOfInternalSAR == null){
					alert("Source of Internal SAR is mandatory. Please enter data.");
				return false;
				}else{
					return true;
				}
			}
			
		</script>
		<title>Generate STR</title>
	</head>  
	<body>
		<div class="modal fade bs-example-modal-lg" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel" id="accountsDetails">
		  <div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" >Select Accounts</h4>					
				</div>
		      <div class="modal-body" id="accountsDetails-body">
		      	<br/>
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
		      </div>
		      <div class="modal-footer" id="accountsDetails-footer">
		        <button type="button" class="btn btn-primary" id="selectedAccountNumber">Select</button>
		        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
		      </div>
		    </div>
		  </div>
		</div>
		<!-- <div class="container-fluid" style="margin-left: 10px;">-->
		<!--<div class="container-fluid">-->
			<div class="row compassrow${UNQID}">
				<div class="col-sm-12">
					<div class="card card-primary">
					  <div class="card-header">Generate STR</div>
					  <!-- <form action="<%=contextPath%>/common/generateAutoSTR?${_csrf.parameterName}=${_csrf.token}" method="post" onsubmit="return strConfirmation()"> -->
					  <form action="javascript:void(0)" method="post" id="generateAutoSTRForm">
					  <table class="table table-bordered table-striped">
					    <tr>
					  		<td width="30%">
					  			Select AMLUser
					  		</td>
					  		<td width="70%">
					  			<select class="form-control input-sm" name="AMLUSERCODE" id="AMLUSERCODE">
					  				<option value=""<%if(groupCode.equalsIgnoreCase("AMLUSER")){ %>disabled<% } %>>Select One</option>
					  				<%
									String l_strUserCode = "";
	 	                            String l_strUserName = "";
					  				for(int i = 0; i < amlUsersList.size(); i++){
					  					l_strUserCode = (String)amlUsersList.get(i).toString();
	                                    l_strUserName = (String)amlUsersMap.get(l_strUserCode);
					  					%>
					  					<option value="<%=l_strUserCode%>"selected><%=l_strUserName%></option>
					  					<%
					  				}					  				
					  				%>
					  			</select>
					  		</td>
					  	</tr> 
					  	<tr>
					  		<td>
					  			Reference Case No
					  		</td>
					  		<td>
					  			<input type="text" class="form-control input-sm" name="REFERENCECASENO" id="REFERENCECASENO">
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Reference Case Date
					  		</td>
					  		<td>
					  			<input type="text" class="form-control" id="REFERENCECASEDATE" name="REFERENCECASEDATE"/>
					  		</td>
					  	</tr>
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
					  					<td width="80%">
					  						<textarea class="form-control" rows="2" cols="5" name="ACCOUNTNUMBERS" id="ACCOUNTNUMBERS"></textarea>
					  					</td>
					  					<td width="20%" style="text-align: right;">
					  						<button type="button" id="selectAccount" class="btn btn-primary">Select Accounts</button>
					  						 <!--data-toggle="modal" data-target=".bs-example-modal-lg"--> 
					  					</td>
					  				</tr>
					  			</table>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>RFI Indicators</td>
					  		<td>
					  			<table width="100%">
					  				<tr>
					  					<td width="15%">
					  						RF1&nbsp;&nbsp;&nbsp;&nbsp;
					  						<input type="checkbox" class="checkboxValForSerializeForm" id="RF1INDICATOR" name="RF1INDICATOR" value="Y">
					  					</td>
					  					<td width="5%">&nbsp;</td>
					  					<td width="15%">
					  						RF2&nbsp;&nbsp;&nbsp;&nbsp;
					  						<input type="checkbox" class="checkboxValForSerializeForm" id="RF2INDICATOR" name="RF2INDICATOR" value="Y">
					  					</td>
					  					<td width="5%">&nbsp;</td>
					  					<td width="15%">
					  						RF3&nbsp;&nbsp;&nbsp;&nbsp;
					  						<input type="checkbox" class="checkboxValForSerializeForm" id="RF3INDICATOR" name="RF3INDICATOR" value="Y">
					  					</td>
					  					<td width="5%">&nbsp;</td>
					  					<td width="15%">
					  						RF4&nbsp;&nbsp;&nbsp;&nbsp;
					  						<input type="checkbox" class="checkboxValForSerializeForm" id="RF4INDICATOR" name="RF4INDICATOR" value="Y">
					  					</td>
					  					<td width="5%">&nbsp;</td>
					  					<td width="15%">
					  						RF5&nbsp;&nbsp;&nbsp;&nbsp;
					  						<input type="checkbox" class="checkboxValForSerializeForm" id="RF5INDICATOR" name="RF5INDICATOR" value="Y">
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
					  				<option value="">Select an option</option>
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
							<td width="30%">Repeat SAR
							</td>
							<td width="70%">
								<select class="form-control input-sm" id="IS_REPEATSAR" name="IS_REPEATSAR">
									<option value="">Select an option</option>
									<option value="YES">Yes</option>
									<option value="NO">No</option>
								</select>
							</td>
						</tr>
						<tr id = "repeatSARRemarksField" style="display: none;">
							<td width="30%">Repeat SAR Remarks
							</td>
							<td width="70%">
								<textarea class="form-control input-sm " id="REPEATSAR_REMARKS" name="REPEATSAR_REMARKS"></textarea>
							</td>
						</tr>
						<tr>
							<td width="30%">Source of Internal SAR
								<span style="color: red;">*</span>
							</td>
							<td width="70%">
								<textarea class="form-control input-sm " id="SOURCEOF_INTERNAL_SAR" name="SOURCEOF_INTERNAL_SAR"></textarea>
							</td>
						</tr>
						<tr>
					  		<td width="30%">
					  			Type Of Suspicion
					  		</td>
					  		<td width="70%">
					  			<select class="form-control input-sm" name="TYPEOFSUSPICION" id="TYPEOFSUSPICION">
					  				<option value="">Select an option</option>
					  				<%
					  				for(int i = 0; i < typeOfSuspicionDetails.size(); i++){
					  					Map<String, String> typeOfSuspicion = typeOfSuspicionDetails.get(i);
					  					%>
					  					<option value="<%=typeOfSuspicion.get("ALERTID")%>"><%=typeOfSuspicion.get("ALERTNAME")%></option>
					  					<%
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
				 <!-- </div>-->
				</div>
		</body>
	</html>
	