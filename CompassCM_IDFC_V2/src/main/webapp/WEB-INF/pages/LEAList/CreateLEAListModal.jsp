<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		var listCode = '${listCode}';
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$("#saveLEAList"+id).click(function(){
			var formObj = $("#leaListForm"+id).serialize();
			var serialNo = $("#serialNo"+id).val();
			var firstName = $("#firstName"+id).val();
			var addressLine = $("#addressLine"+id).val();
			var letterReceivedDate = $("#letterReceivedDate"+id).val();
			var scrubbingResultMatch = $("#scrubbingResultMatch"+id).val();
			var customerName = $("#customerName"+id).val();
			var customerUCIC = $("#customerUCIC"+id).val();
			var customerAccount = $("#customerAccount"+id).val();
			var customerHomeBranch = $("#customerHomeBranch"+id).val();
			
			if(serialNo != "" && firstName != "" && addressLine != "" && letterReceivedDate != ""){
				if(scrubbingResultMatch == "Y"){
					if(customerName != "" && customerUCIC != "" && customerAccount != "" && customerHomeBranch != "" ){
						if(confirm("Confirm saving")){
							$.ajax({
								url : "${pageContext.request.contextPath}/common/saveLEAList",
								type : "POST",
								cache : false,
								data : formObj,
								success : function(res){
									$("#"+searchButton).click();
									$("#compassCaseWorkFlowGenericModal").modal("hide");
									alert(res);
								},
								error : function(a,b,c){
									alert("Error while saving form"+a+b+c);
								}
							});
						}
					}else{
						alert("Please enter the Customer details.");
					}
				}else{
					if(confirm("Confirm saving")){
						$.ajax({
							url : "${pageContext.request.contextPath}/common/saveLEAList",
							type : "POST",
							cache : false,
							data : formObj,
							success : function(res){
								$("#"+searchButton).click();
								$("#compassCaseWorkFlowGenericModal").modal("hide");
							},
							error : function(a,b,c){
								alert("Error while saving form"+a+b+c);
							}
						});
					}
				}
			}else{
				alert("Please fill up the mandatory fields.");
			}
		});
		
		
		
		$("#updateWatchlistModal"+id).click(function(){
			//var listCode = '${listCode}';
			var formObj = $("#leaListForm"+id).serialize();
			var serialNo = $("#serialNo"+id).val();
			var firstName = $("#firstName"+id).val();
			var addressLine = $("#addressLine"+id).val();
			var letterReceivedDate = $("#letterReceivedDate"+id).val();
			var scrubbingResultMatch = $("#scrubbingResultMatch"+id).val();
			var customerName = $("#customerName"+id).val();
			var customerUCIC = $("#customerUCIC"+id).val();
			var customerAccount = $("#customerAccount"+id).val();
			var customerHomeBranch = $("#customerHomeBranch"+id).val();
			
			if(serialNo != "" && firstName != "" && addressLine != "" && letterReceivedDate != ""){
				if(scrubbingResultMatch == "Y"){
					if(customerName != "" && customerUCIC != "" && customerAccount != "" && customerHomeBranch != "" ){
						if(confirm("Confirm updation")){
							$.ajax({
								url: "${pageContext.request.contextPath}/common/updateLEAList",
								cache: false,
								type: "POST",
								data: formObj+"&listCode="+listCode,
								success: function(res){
									$("#"+searchButton).click();
									$("#compassCaseWorkFlowGenericModal").modal("hide");
									alert(res);
								},
								error: function(a,b,c){
									alert("Error while updating form"+a+b+c);
								}
							});
						}
					}else{
						alert("Please enter the Customer name.");
					}
				}else{
					if(confirm("Confirm updation")){
						$.ajax({
							url: "${pageContext.request.contextPath}/common/updateLEAList",
							cache: false,
							type: "POST",
							data: formObj+"&listCode="+listCode,
							success: function(res){
								$("#"+searchButton).click();
								$("#compassCaseWorkFlowGenericModal").modal("hide");
								alert(res);
							},
							error: function(a,b,c){
								alert("Error while updating form"+a+b+c);
							}
						});
					}
				}
			}else{
				alert("Please fill up the mandatory fields.");
			}
		}); 
		
		$("#clearLEAModalList"+id).click(function(){
			$("#leaListForm"+id).find('input:text, select').not( $("#listCode"+id)).val('');
		});
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary updateWatchlistModalForm">
		<form action="javascript:void(0)" method="POST" id="leaListForm${UNQID}">
			<table class="table table-striped" style="margin-bottom: 0px;">
			<c:choose>
				<c:when test="${not empty listCode}">
					<tr>
						<td width="15%">Serial No <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="serialNo" id="serialNo${UNQID}" value="${DATAMAP['SERIALNO']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%" id="listCodeText${UNQID}">List Code</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="listCode" id="listCode${UNQID}" value="${DATAMAP['LISTCODE']}" disabled="disabled"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">First Name <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="firstName" id="firstName${UNQID}" value="${DATAMAP['FIRST_NAME']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Middle Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="middleName" id="middleName${UNQID}" value="${DATAMAP['MIDDLE_NAME']}" /> 
						</td>
					</tr>
					<tr>
						<td width="15%">Surname</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="surname" id="surname${UNQID}" value="${DATAMAP['SURNAME']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Gender</td>
						<td width="30%">
							<select class="form-control input-sm" id="gender${UNQID}" name="gender">
								<option value="">Select</option>
								<option value="Female" <c:if test="${DATAMAP['GENDER'] eq 'Female'}">selected="selected"</c:if>>Female</option>
								<option value="Male" <c:if test="${DATAMAP['GENDER'] eq 'Male'}">selected="selected"</c:if>>Male</option>
							</select>  
						</td>
					</tr>
					<tr>
						<td width="15%">Source of Letter/Mail</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="sourceOfLetterMail" id="sourceOfLetterMail${UNQID}" value="${DATAMAP['SOURCE_OF_LETTER_MAIL']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Address Line <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="addressLine" id="addressLine${UNQID}" value="${DATAMAP['ADDRESS_LINE']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Identification Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="identificationType${UNQID}" name="identificationType">
								<option value="">Select</option>
								<option value="PAN" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'PAN'}">selected="selected"</c:if>>PAN</option>
								<option value="PASSPORT" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'PASSPORT'}">selected="selected"</c:if>>Passport</option>
								<option value="LANDLINENO" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'LANDLINENO'}">selected="selected"</c:if>>Landline Number</option>
								<option value="MOBILENO" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'MOBILENO'}">selected="selected"</c:if>>Mobile Number</option>
								<option value="EMAILID" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'EMAILID'}">selected="selected"</c:if>>Email ID</option>
								<option value="OTHERS" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'OTHERS'}">selected="selected"</c:if>>Others</option>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Identification Number</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="identificationNumber" id="identificationNumber${UNQID}" value="${DATAMAP['IDENTIFICATION_NUMBER']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Letter/Mail Received Date <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="letterReceivedDate" id="letterReceivedDate${UNQID}" value="${DATAMAP['LETTER_RECEIVED_DATE']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Scrubbing Date - LEA team</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="scrubbingDate" id="scrubbingDate${UNQID}" value="${DATAMAP['SCRUBBING_DATE']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Scrubbing Result Match - (Y/N)</td>
						<td width="30%">
							<select class="form-control input-sm" id="scrubbingResultMatch${UNQID}" name="scrubbingResultMatch">
								<option value="">Select</option>
								<option value="Y" <c:if test="${DATAMAP['SCRUBBING_RESULT_MATCH'] eq 'Y'}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${DATAMAP['SCRUBBING_RESULT_MATCH'] eq 'N'}">selected="selected"</c:if>>No</option>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">If Y to scrubbing - Customer Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerName" id="customerName${UNQID}" value="${DATAMAP['CUSTOMER_NAME']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Customer UCIC</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerUCIC" id="customerUCIC${UNQID}" value="${DATAMAP['CUSTOMER_UCIC']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Account</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerAccount" id="customerAccount${UNQID}" value="${DATAMAP['CUSTOMER_ACCOUNT']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Home Branch of Customer</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerHomeBranch" id="customerHomeBranch${UNQID}" value="${DATAMAP['CUSTOMER_HOME_BRANCH']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">&nbsp;</td>
						<td width="30%">&nbsp;</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td width="15%">Serial No <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="serialNo" id="serialNo${UNQID}" value="${DATAMAP['SERIALNO']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">First Name <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="firstName" id="firstName${UNQID}" value="${DATAMAP['FIRST_NAME']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Middle Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="middleName" id="middleName${UNQID}" value="${DATAMAP['MIDDLE_NAME']}" /> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Surname</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="surname" id="surname${UNQID}" value="${DATAMAP['SURNAME']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Gender</td>
						<td width="30%">
							<select class="form-control input-sm" id="gender${UNQID}" name="gender">
								<option value="">Select</option>
								<option value="Female" <c:if test="${DATAMAP['GENDER'] eq 'Female'}">selected="selected"</c:if>>Female</option>
								<option value="Male" <c:if test="${DATAMAP['GENDER'] eq 'Male'}">selected="selected"</c:if>>Male</option>
							</select>   
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Source of Letter/Mail</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="sourceOfLetterMail" id="sourceOfLetterMail${UNQID}" value="${DATAMAP['SOURCE_OF_LETTER_MAIL']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Address Line <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="addressLine" id="addressLine${UNQID}" value="${DATAMAP['ADDRESS_LINE']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Identification Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="identificationType${UNQID}" name="identificationType">
								<option value="">Select</option>
								<option value="PAN" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'PAN'}">selected="selected"</c:if>>PAN</option>
								<option value="PASSPORT" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'PASSPORT'}">selected="selected"</c:if>>Passport</option>
								<option value="LANDLINENO" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'LANDLINENO'}">selected="selected"</c:if>>Landline Number</option>
								<option value="MOBILENO" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'MOBILENO'}">selected="selected"</c:if>>Mobile Number</option>
								<option value="EMAILID" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'EMAILID'}">selected="selected"</c:if>>Email ID</option>
								<option value="OTHERS" <c:if test="${DATAMAP['IDENTIFICATION_TYPE'] eq 'OTHERS'}">selected="selected"</c:if>>Others</option>
							</select> 
						</td>
					</tr>
					<tr>
						<td width="15%">Identification Number</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="identificationNumber" id="identificationNumber${UNQID}" value="${DATAMAP['IDENTIFICATION_NUMBER']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Letter/Mail Received Date <span style="color: red;">*</span></td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="letterReceivedDate" id="letterReceivedDate${UNQID}" value="${DATAMAP['LETTER_RECEIVED_DATE']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Scrubbing Date - LEA team</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="scrubbingDate" id="scrubbingDate${UNQID}" value="${DATAMAP['SCRUBBING_DATE']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Scrubbing Result Match - (Y/N)</td>
						<td width="30%">
							<select class="form-control input-sm" id="scrubbingResultMatch${UNQID}" name="scrubbingResultMatch">
								<option value="">Select</option>
								<option value="Y" <c:if test="${DATAMAP['SCRUBBING_RESULT_MATCH'] eq 'Y'}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${DATAMAP['SCRUBBING_RESULT_MATCH'] eq 'N'}">selected="selected"</c:if>>No</option>
							</select> 
						</td>
					</tr>
					<tr>
						<td width="15%">If Y to scrubbing - Customer Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerName" id="customerName${UNQID}" value="${DATAMAP['CUSTOMER_NAME']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer UCIC</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerUCIC" id="customerUCIC${UNQID}" value="${DATAMAP['CUSTOMER_UCIC']}"/> 
						</td>
					</tr>
					<tr>
						<td width="15%">Customer Account</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerAccount" id="customerAccount${UNQID}" value="${DATAMAP['CUSTOMER_ACCOUNT']}"/> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Home Branch of Customer</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="customerHomeBranch" id="customerHomeBranch${UNQID}" value="${DATAMAP['CUSTOMER_HOME_BRANCH']}"/> 
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<c:if test="${actionType ne 'fetchLEAListForUpdate'}">
						<button type="button" id="saveLEAList${UNQID}" class="btn btn-success btn-sm">Save</button>
					</c:if>
					<c:if test="${actionType eq 'fetchLEAListForUpdate'}">
						<button type="button" id="updateWatchlistModal${UNQID}" class="btn btn-primary btn-sm">Update</button>
					</c:if>
					<input type="button" class="btn btn-danger btn-sm" id="clearLEAModalList${UNQID}" name="Clear" value="Clear"/>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>