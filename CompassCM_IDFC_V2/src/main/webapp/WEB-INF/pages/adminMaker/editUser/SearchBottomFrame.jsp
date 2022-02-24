<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="STATUS" value="${f:substring((f:toUpperCase(USERFOREDIT['USERSTATUS'])),0,1)}"></c:set>
<script type="text/javascript">
	$(document).ready(function(){
		var elmId = '${ELMID}';
		var accountEnableCurrent = '${ALLSTATUSOFUSER["ACCOUNTENABLE"]}';
		var accountDormantCurrent = '${ALLSTATUSOFUSER["ACCOUNTDORMANT"]}';
		var accountLockedCurrent = '${ALLSTATUSOFUSER["ACCOUNTLOCKED"]}'; 
		var accountDeletedCurrent = '${ALLSTATUSOFUSER["ACCOUNTDELETED"]}';
		
		//alert(accountEnableCurrent+" "+accountDormantCurrent+" "+accountLockedCurrent+" "+accountDeletedCurrent);
		
		if(accountDeletedCurrent == 'Y'){
			$("input[name='editStatusAccountEnabled"+elmId+"']").attr("disabled", true);
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
		    changeYear: true,
		    dateFormat:'dd/mm/yy'
		});
		
		$("#updateUserProfile"+elmId).click(function(){
			var isValid = true;
			var button = $(this);
			var actionFlag = "UserProfile";
			var usercode = $("#editUserUserCode"+elmId).val();
			var userPass = escape($("#editUserUserPass"+elmId).val());
			var firstname = escape($("#editUserFirstName"+elmId).val());
			var lastname = escape($("#editUserLastName"+elmId).val());
			var emailId = $("#editUserEmailID"+elmId).val();
			var mobileNo = "";
			var designation = "";
			var departmentCode = $("#editUserDepartmentCode"+elmId).val()
			var employeeCode = $("#editUserEmployeeCode"+elmId).val();

			var accountenable = ($("#editUserAccountEnabled"+elmId).val() == "No") ? "N" : "Y";
			var accountDormant = ($("#editUserAccountDormant"+elmId).val() == "No") ? "N" : "Y";
			var accountLocked = ($("#editUserAccountLocked"+elmId).val() == "No") ? "N" : "Y";
			var accountDeleted = ($("#editUserAccountDeleted"+elmId).val() == "No") ? "N" : "Y";
			var accountExpired = "N";
			
			var passwordexpired = "N";
			var chatEnabled = "N";
			var accessstarttime = "00:00";
			var accessendtime = "23:59";
			var accountexpirydate = "01/01/3000";
			var branchCode = escape($("#editUserBranchCode"+elmId).val());
			var isETLUser = "N";
			//var groupCode = $("#groupCode"+elmId).val();
			
			if((firstname == "" || lastname == "")){
				isValid = false;
				alert("Enter First Name and Last Name");
				if(firstname == "")
					$("#firstname").focus();
				if(lastname == "")
					$("#lastname").focus();
			}
			
			emailIdToCheck = emailId.toLowerCase();
			if(!(emailIdToCheck.endsWith("@idfcbank.com")) && !(emailIdToCheck.endsWith("@in.idfcbank.com"))){
				isValid = false;
				alert("Email Id domain does not exist.");
				$("#emailId").focus();
			}
			
			if(branchCode == "ALL"){
				isValid = false;
				alert("Select Branch Code");
				$("#branchCode").focus();
			}
			
		/* Commented for BANDHAN 23/09/2020 
			if(groupCode == "ALL"){
				isValid = false;
				alert("Select User Role");
				$("#groupCode").focus();
			} */
			var fulldata = "usercode="+usercode+"&firstname="+firstname+"&lastname="+lastname+"&userPass="+userPass+"&emailId="+emailId+
						   "&mobileNo="+mobileNo+"&designation="+designation+"&accountenable="+accountenable+"&passwordExired="+passwordexpired+
						   "&accessstarttime="+accessstarttime+"&accessendtime="+accessendtime+"&accountexpirydate="+accountexpirydate+
						   "&chatEnabled="+chatEnabled+"&branchCode="+branchCode+"&isETLUser="+isETLUser+
						   //"&groupCode="+groupCode+
						   "&accountExpired="+accountExpired+"&accountLocked="+accountLocked+"&accountDeleted="+accountDeleted+
						   "&departmentCode="+departmentCode+"&employeeCode="+employeeCode+"&accountDormant="+accountDormant+"&actionFlag="+actionFlag;
			//alert(fulldata);
			if(isValid){
				$(button).html("Updating...");
				$(button).attr("disabled","disabled");
				
				$.ajax({
		    		url : "${pageContext.request.contextPath}/cmUAMMaker/updateUser",
		    		cache : false,
		    		type : 'POST',
		    		data : fulldata,
		    		success : function(resData){
		    			alert(resData);
		    			$(button).removeAttr("disabled");
		    			$(button).html("Update User");
		    			reloadTabContent();
		    		},
		    		error : function(){
		    			alert("Something went wrong");
		    		}
		    	}); 
			}  
		});
		
		$("#updateUserStatus"+elmId).click(function(){
			var button = $(this);
			var actionFlag = "UserStatus";
			var userCode = $("#editStatusUserCode"+elmId).val();
			var userStatus = $("#editStatusUserStatus"+elmId).val();
			/* var userPass = "Compass@123"; */
			var userPass = escape($("#editUserUserPass"+elmId).val());
			var firstname = "${USERFOREDIT['FIRSTNAME']}";
			var lastname = "${USERFOREDIT['LASTNAME']}";
			var emailId = "${USERFOREDIT['EMAILID']}";
			var mobileNo = "";
			var designation = "";
			var departmentCode = "${USERFOREDIT['DEPARTMENTCODE']}";
			var employeeCode = "${USERFOREDIT['EMPLOYEECODE']}";
			
			var passwordexpired = "N";
			var chatEnabled = "N";
			var accessstarttime = "00:00";
			var accessendtime = "23:59";
			var accountexpirydate = "01/01/3000";
			var branchCode = "${USERFOREDIT['BRANCHCODE']}";
			var isETLUser = "N";
			//var groupCode = "${USERFOREDIT['GROUPCODE']}";
			//console.log(${USERFOREDIT['GROUPCODE']});
			var accountLocked = $("input[name='editStatusAccountLocked"+elmId+"']:checked").val();
			var accountenable = $("input[name='editStatusAccountEnabled"+elmId+"']:checked").val();
			var accountDeleted = $("input[name='editStatusAccountDeleted"+elmId+"']:checked").val();
			var accountDormant = $("input[name='editStatusAccountDormant"+elmId+"']:checked").val();
			var accountExpired = "N";

			var count = 0;
			
			if(accountenable != accountEnableCurrent)
				count++;
			
			if(accountDormant != accountDormantCurrent)
				count++;
			
			if(accountLocked != accountLockedCurrent)
				count++;
			
			if(accountDeleted != accountDeletedCurrent)
				count++;

			if(count == 1){
				var fullData = "usercode="+userCode+"&userStatus="+userStatus+"&firstname="+firstname+"&lastname="+lastname+"&userPass="+userPass+"&emailId="+emailId+
				   "&mobileNo="+mobileNo+"&designation="+designation+"&accountenable="+accountenable+"&passwordExired="+passwordexpired+
				   "&accessstarttime="+accessstarttime+"&accessendtime="+accessendtime+"&accountexpirydate="+accountexpirydate+
				   "&chatEnabled="+chatEnabled+"&branchCode="+branchCode+"&isETLUser="+isETLUser+
				   //"&groupCode="+groupCode+
				   "&accountExpired="+accountExpired+"&accountLocked="+accountLocked+"&accountDeleted="+accountDeleted+
				   "&departmentCode="+departmentCode+"&employeeCode="+employeeCode+"&accountDormant="+accountDormant+"&actionFlag="+actionFlag;
			//	alert(fullData);
				   $.ajax({
					url : "${pageContext.request.contextPath}/cmUAMMaker/updateUser",
					cache : false,
					type : 'POST',
					data : fullData,
					success : function(resData){
						alert(resData);
						$(button).removeAttr("disabled");
						$(button).html("Update User Status");
						reloadTabContent();
					},
					error : function(){
						alert("Something went wrong");
					}
				});    
			}else if(count == 0){
				alert('Update any one status to save.');
			}else{
				alert('Only one status can be updated at a time.');
			}
		});
	});
</script>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-primary">
			<ul class="nav nav-pills modalNav" role="tablist">
				<li role="presentation" class="active">
					<a class="subTab nav-link active" href="#profileDetails" aria-controls="tab" role="tab" data-toggle="tab">Profile Details</a>
				</li>
				<li role="presentation" >
					<a class="subTab nav-link" href="#statusDetails" aria-controls="tab" role="tab" data-toggle="tab">Status Details</a>
				</li>
			</ul>
			<div class="tab-content" id="editUserDetailsBottomFrame">
				<div role="tabpanel" class="tab-pane active" id="profileDetails" >
					<div class="row resultRow">
						<div class="col-sm-12">
							<div class="card card-primary" style="margin-bottom: 0; margin-top: 5px;">
								<div class="card-header clearfix">
							      <h6 class="card-title pull-${dirL}">Edit User Profile of ${USERFOREDIT['USERCODE']}</h6>
							     </div>				
								<table class="table table-striped">
									<tr>
										<td width="18%">User Code</td>
										<td width="30%"><input type="text" class="form-control input-sm" id="editUserUserCode${ELMID}" value="${USERFOREDIT['USERCODE']}" readonly="readonly"/></td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Password</td>
										<td width="30%">
											<!--
											<input type="password" class="form-control input-sm" id="editUserUserPass${ELMID}" name="userPass" disabled="disabled" value="Compass@123"/>
											-->
											<c:if test="${LDAPSYSTEM == 'Y' }">
												<input type="password" class="form-control input-sm" id="editUserUserPass" name="userPass" value="Compass@123" disabled="disabled"/>
												<em style="font-size: 11px; color: red">This password will be dummy as System is connected to AD</em>
											</c:if>
											<c:if test="${LDAPSYSTEM == 'N' }">
												<!-- <input type="password" class="form-control input-sm" id="editUserUserPass" name="userPass" value="Compass@123" /> -->
												<input type="password" class="form-control input-sm" id="editUserUserPass${ELMID}" name="userPass" value="" />
											</c:if>
										</td>
									</tr>
									<tr>
										<td width="18%">First Name</td>
										<td width="30%"><input type="text" class="form-control input-sm" id="editUserFirstName${ELMID}" value="${USERFOREDIT['FIRSTNAME']}"/> </td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Last Name</td>
										<td width="30%"><input type="text" class="form-control input-sm" id="editUserLastName${ELMID}" value="${USERFOREDIT['LASTNAME']}"/></td>
									</tr>
									<tr>
										<td width="18%">Email ID</td>
										<td width="30%"><input type="text" class="form-control input-sm" id="editUserEmailID${ELMID}" value="${USERFOREDIT['EMAILID']}"/> </td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Employee Code</td>
										<td width="30%">
											<%-- <input type="text" class="form-control input-sm" id="editUserEmployeeCode${ELMID}" name="editUserEmployeeCode${ELMID}" disabled="disabled" value="${USERFOREDIT['EMPLOYEECODE']}"/> --%>
											<input type="text" class="form-control input-sm" id="editUserEmployeeCode${ELMID}" name="editUserEmployeeCode${ELMID}" value="${USERFOREDIT['EMPLOYEECODE']}"/>
										</td>
									</tr>
									<%-- <tr>
										<td width="18%">Designation</td>
										<td width="30%">
											<select class="form-control input-sm" id="editUserDesignation${ELMID}">
												<c:forEach var="DESIGNATIONCODES" items="${DESIGNATIONCODES}">
													<option value="${DESIGNATIONCODES.key}" <c:if test="${f:contains(USERFOREDIT['DESIGNATION'], DESIGNATIONCODES.key)}">selected="selected"</c:if>>${DESIGNATIONCODES.value}</option>
												</c:forEach>
											</select>
										<td width="4%">&nbsp;</td>
										<td width="18%">Mobile No</td>
										<td width="30%"><input type="text" class="form-control input-sm" id="editUserMobileNo${ELMID}" value="${USERFOREDIT['MOBILENO']}"/></td>
									</tr> --%>
									<tr>
										<td width="18%">Account Enable</td>
										<td width="30%">
											<input type="text" class="form-control input-sm" id="editUserAccountEnabled${ELMID}" name="editUserAccountEnabled${ELMID}" value="${USERFOREDIT['ACCOUNTENABLE']}" readonly="readonly"/>
											<%-- <label class="btn btn-default btn-sm" for="editUserAccountEnabledYes${ELMID}">
												<input type="radio" name="editUserAccountEnabled${ELMID}" id="editUserAccountEnabledYes${ELMID}" value="Y" disabled="disabled" <c:if test="${USERFOREDIT['ACCOUNTENABLE'] == 'Y'}">checked</c:if> /> Yes
											</label>
											<label class="btn btn-default btn-sm" for="editUserAccountEnabledNo${ELMID}">
											  	<input type="radio" name="editUserAccountEnabled${ELMID}" id="editUserAccountEnabledNo${ELMID}" value="N" disabled="disabled" <c:if test="${USERFOREDIT['ACCOUNTENABLE'] != 'Y'}">checked</c:if> /> No
											</label> --%>
										</td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Account Dormant</td>
										<td width="30%">
											<input type="text" class="form-control input-sm" id="editUserAccountDormant${ELMID}" name="editUserAccountDormant${ELMID}" value="${USERFOREDIT['ACCOUNTDORMANT']}" readonly="readonly"/>
											<%-- <label class="btn btn-default btn-sm" for="editUserAccountExpiredYes${ELMID}">
												<input type="radio" name="editUserAccountExpired${ELMID}" id="editUserAccountExpiredYes${ELMID}" value="Y" <c:if test="${USERFOREDIT['ACCOUNTEXPIRED'] == 'Y'}">checked</c:if> /> Yes
											</label>
											<label class="btn btn-default btn-sm" for="editUserAccountExpiredNo${ELMID}">
											  	<input type="radio" name="editUserAccountExpired${ELMID}" id="editUserAccountExpiredNo${ELMID}" value="N" <c:if test="${USERFOREDIT['ACCOUNTEXPIRED'] != 'Y'}">checked</c:if> /> No
											</label> --%>
										</td>
									</tr>
									<tr>
										<td width="18%">Account Locked</td>
										<td width="30%">
											<input type="text" class="form-control input-sm" id="editUserAccountLocked${ELMID}" name="editUserAccountLocked${ELMID}" value="${USERFOREDIT['ACCOUNTLOCKED']}" readonly="readonly"/>
											<%-- <label class="btn btn-default btn-sm" for="editUserAccountLockedYes${ELMID}" >
												<input type="radio" name="editUserAccountLocked${ELMID}" id="editUserAccountLockedYes${ELMID}" disabled="disabled" value="Y" <c:if test="${USERFOREDIT['ACCOUNTLOCKED'] == 'Y'}">checked</c:if> /> Yes
											</label>
											<label class="btn btn-default btn-sm" for="editUserAccountLockedNo${ELMID}">
											  	<input type="radio" name="editUserAccountLocked${ELMID}" id="editUserAccountLockedNo${ELMID}" value="N" disabled="disabled" <c:if test="${USERFOREDIT['ACCOUNTLOCKED'] != 'Y'}">checked</c:if> /> No
											</label> --%>
										</td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Account Deleted</td>
										<td width="30%">
											<input type="text" class="form-control input-sm" id="editUserAccountDeleted${ELMID}" name="editUserAccountDeleted${ELMID}" value="${USERFOREDIT['ACCOUNTDELETED']}" readonly="readonly"/>
											<%-- <label class="btn btn-default btn-sm" for="editUserAccountDeletedYes${ELMID}">
												<input type="radio" name="editUserAccountDeleted${ELMID}" id="editUserAccountDeletedYes${ELMID}" value="Y" disabled="disabled" <c:if test="${USERFOREDIT['ACCOUNTDELETED'] == 'Y'}">checked</c:if> /> Yes
											</label>
											<label class="btn btn-default btn-sm" for="editUserAccountDeletedNo${ELMID}">
											  	<input type="radio" name="editUserAccountDeleted${ELMID}" id="editUserAccountDeletedNo${ELMID}" value="N" disabled="disabled" <c:if test="${USERFOREDIT['ACCOUNTDELETED'] != 'Y'}">checked</c:if> /> No
											</label> --%>
										</td>
									</tr>
									<tr>
										<td width="18%">Branch Code</td>
										<td>
											<select class="form-control input-sm" id="editUserBranchCode${ELMID}">
												<c:forEach var="BRANCHCODE" items="${BRANCHCODES}">
													<option value="${BRANCHCODE.key}" <c:if test="${USERFOREDIT['BRANCHCODE'] eq BRANCHCODE.key}">selected="selected"</c:if>>${BRANCHCODE.value}</option>
												</c:forEach>
											</select>
										</td>
										<td width="4%">&nbsp;</td>
										<!-- <td width="18%">Department Code</td> -->
										<td width="18%">Assessment Unit</td>
										<td>
											<select class="form-control input-sm" id="editUserDepartmentCode${ELMID}" name="editUserDepartmentCode">
												<c:forEach var="departmentCode" items="${DEPARTMENTCODES}">
													<option value="${departmentCode.key}" <c:if test="${USERFOREDIT['DEPARTMENTCODE'] eq departmentCode.key}">selected="selected"</c:if>>${departmentCode.key} - ${departmentCode.value}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<%-- <tr>
										<td width="18%">User Role</td>
										<td>
											<select class="form-control input-sm" id="groupCode${ELMID}">
												<c:forEach var="ALLROLES" items="${ALLROLES}">
													<option value="${ALLROLES}" <c:if test="${USERFOREDIT['GROUPCODE'] eq ALLROLES}">selected="selected"</c:if>>${ALLROLES}</option>
												</c:forEach>
											</select>
										</td>
										<td colspan="3">&nbsp;</td>
									</tr> --%>
									<%-- <tr>
										
										<td width="4%">&nbsp;</td>
										<td width="18%">Checker Action</td>
										<td width="30%">${USERFOREDIT['USERSTATUS']} <c:if test="${USERFOREDIT['USERSTATUS'] != 'Pending'}">by ${USERFOREDIT['APPROVEDBY']}</c:if> </td>
									</tr>
									<tr>
										<td width="18%">Checker Action Date</td>
										<td width="30%" >${USERFOREDIT['APPROVEDTIMESTAMP']}</td>
										<td width="4%">&nbsp;</td>
										<td width="18%">Checker Remarks</td>
										<td width="82%" colspan="4">${USERFOREDIT['CHECKERREMAKRS']}</td>
									</tr> --%>
									<%-- <tr><td>${USERFOREDIT['ACCOUNTENABLE']}</td><td>${USERFOREDIT['ACCOUNTEXPIRED']}</td><td>&nbsp;</td><td>${USERFOREDIT['ACCOUNTLOCKED']}</td><td>${USERFOREDIT['ACCOUNTDELETED']}</td></tr> --%>
								</table>
								<c:if test="${STATUS ne 'P'}">
								<c:if test="${USERFOREDIT['ACCOUNTENABLE'] == 'Yes' && USERFOREDIT['ACCOUNTEXPIRED'] == 'No' && USERFOREDIT['ACCOUNTLOCKED'] == 'No' && USERFOREDIT['ACCOUNTDELETED'] == 'No'}">
									<div class="card-footer clearfix searchButtonDiv" style="display: block;">
								        <div class="pull-${dirR}">
								            <button type="button" class="btn btn-primary btn-sm" id="updateUserProfile${ELMID}">Update User</button>
								        </div>
							    	</div>
							    </c:if>
						    	</c:if>
								<%-- <c:if test="${USERFOREDIT['ACCOUNTENABLE'] == 'Y' && USERFOREDIT['ACCOUNTEXPIRED'] == 'N'  && USERFOREDIT['ACCOUNTLOCKED'] == 'N' && USERFOREDIT['ACCOUNTDELETED'] == 'N'}"> 
									<div class="card-footer clearfix searchButtonDiv" style="display: block;">
								        <div class="pull-${dirR}">
								            <button type="button" class="btn btn-primary btn-sm" id="updateUser${ELMID}">Update User</button>
								        </div>
							    	</div>
								</c:if>
								<c:if test="${USERFOREDIT['ACCOUNTENABLE'] == 'N' && USERFOREDIT['ACCOUNTEXPIRED'] == 'Y'  && USERFOREDIT['ACCOUNTLOCKED'] == 'Y' && USERFOREDIT['ACCOUNTDELETED'] == 'Y'}"> 
									<div class="card-footer clearfix searchButtonDiv" style="display: none;">
								        <div class="pull-${dirR}">
								            <button type="button" class="btn btn-primary btn-sm" id="updateUser${ELMID}">Update User</button>
								        </div>
							    	</div>
								</c:if> --%>
						</div>
					</div>
				</div>
			</div>

		<div role="tabpanel" class="tab-pane" id="statusDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary" style="margin-bottom: 0; margin-top: 5px;">
				  		<div class="card-header clearfix">
				  			<h6 class="card-title pull-${dirL}">Edit User Status of ${ALLSTATUSOFUSER.USERCODE}</h6>
				  		</div>				
			  			<table class="table table-striped">
			  				<tbody>
			  					<tr>
			  						<td width="18%">User Code</td>
			  						<td width="30%">
			  							<input type="text" class="form-control input-sm" id="editStatusUserCode${ELMID}" value="${ALLSTATUSOFUSER['USERCODE']}" readonly="readonly"/>
			  						</td>
			  						<td width="4%">&nbsp;</td>
			  						<td width="18%">User Status</td>
			  						<td width="30%">
			  							<input type="text" class="form-control input-sm" id="editStatusUserStatus${ELMID}" value="${ALLSTATUSOFUSER['USERSTATUS']}" readonly="readonly"/>
			  						</td>
			  					</tr>
			  					<tr>
			  						<td width="18%">Account Locked</td>
			  						<td width="30%">
			  							<label class="btn btn-default btn-sm" for="editStatusAccountLockedYes${ELMID}">
											<input type="radio" name="editStatusAccountLocked${ELMID}" id="editStatusAccountLockedYes${ELMID}" value="Y" disabled="disabled" <c:if test="${ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y'}">checked</c:if> /> Yes
										</label>
										<label class="btn btn-default btn-sm" for="editStatusAccountLockedNo${ELMID}">
										  	<input type="radio" name="editStatusAccountLocked${ELMID}" id="editStatusAccountLockedNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'N'}">checked</c:if> /> No
										</label>
									</td>
			  						<td width="4%">&nbsp;</td>
			  						<td width="18%">Account Enabled</td>
			  						<td width="30%">
			  							<label class="btn btn-default btn-sm" for="editStatusAccountEnabledYes${ELMID}">
											<input type="radio" name="editStatusAccountEnabled${ELMID}" id="editStatusAccountEnabledYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'Y'}">checked</c:if> /> Yes
										</label>
										<label class="btn btn-default btn-sm" for="editStatusAccountEnabledNo${ELMID}">
										  	<input type="radio" name="editStatusAccountEnabled${ELMID}" id="editStatusAccountEnabledNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N'}">checked</c:if> /> No
										</label>
									</td>
			  					</tr>
			  					<tr>
			  						<td width="18%">Account Deleted</td>
			  						<td width="30%">
			  							<label class="btn btn-default btn-sm" for="editStatusAccountDeletedYes${ELMID}">
											<input type="radio" name="editStatusAccountDeleted${ELMID}" id="editStatusAccountDeletedYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">checked</c:if> /> Yes
										</label>
										<label class="btn btn-default btn-sm" for="editStatusAccountDeletedNo${ELMID}">
										  	<input type="radio" name="editStatusAccountDeleted${ELMID}" id="editStatusAccountDeletedNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'N'}">checked</c:if> /> No
										</label>
									</td>
			  						<td width="4%">&nbsp;</td>
			  						<%-- <td width="18%">Account Expired </td>
			  						<td width="30%">
			  							<label class="btn btn-default btn-sm" for="editStatusAccountExpiredYes${ELMID}">
											<input type="radio" name="editStatusAccountExpired${ELMID}" id="editStatusAccountExpiredYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'Y'}">checked</c:if> /> Yes
										</label>
										<label class="btn btn-default btn-sm" for="editStatusAccountExpiredNo${ELMID}">
										  	<input type="radio" name="editStatusAccountExpired${ELMID}" id="editStatusAccountExpiredNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'N'}">checked</c:if> /> No
										</label>
									</td>  --%>
									<td width="18%">Account Dormant </td>
			  						<td width="30%">
			  							<label class="btn btn-default btn-sm" for="editStatusAccountDormantYes${ELMID}">
											<input type="radio" name="editStatusAccountDormant${ELMID}" id="editStatusAccountDormantYes${ELMID}" disabled="disabled" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'Y'}">checked</c:if> /> Yes
										</label>
										<label class="btn btn-default btn-sm" for="editStatusAccountDormantNo${ELMID}">
										  	<input type="radio" name="editStatusAccountDormant${ELMID}" id="editStatusAccountDormantNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'N'}">checked</c:if> /> No
										</label>
									</td>
			  					</tr>
			  				</tbody>
			  			</table>
			  			<c:if test="${STATUS ne 'P'}">	
			  			<div class="card-footer clearfix searchButtonDiv" style="display: block;">
					        <div class="pull-${dirR}">
					            <button type="button" class="btn btn-primary btn-sm" id="updateUserStatus${ELMID}"
					            <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N' && ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'Y'  && ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y' && ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">disabled="disabled"</c:if>
					            >Update Status</button>
					            <%-- <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N' && ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'Y'  && ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y' && ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">disabled="disabled"</c:if>
					            >Update Status</button> --%>
					        </div>
				    	</div>
				    	</c:if>
				  		</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>