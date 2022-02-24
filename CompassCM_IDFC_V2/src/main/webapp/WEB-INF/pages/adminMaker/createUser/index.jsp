<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	var id = '${UNQID}';
	$(document).ready(function() {	
		compassTopFrame.init(id, 'createUserTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingCreateUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'createUserSerachResultPanel');
	    });
		
		var accountExpiryDatepicker = $('#accountExpiryDate');
		accountExpiryDatepicker = accountExpiryDatepicker.datepicker('setDate', new Date()+'5y');
		
		$("#searchUser"+id).click(function(e){
			var buttonDisableMessage;
			var buttonActualMessage;
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");	
			var userCode = $("#userCode").val();
			var firstName = $("#firstName").val();
			var lastName = $("#lastName").val();
			var emailId = $("#emailId").val();
			var mobileNo = "";
			
			var fullData = "userCode="+userCode+"&firstName="+firstName+"&lastName="+lastName+"&emailId="+emailId+"&mobileNo="+mobileNo;	
			
			if(userCode == ""){
				alert("Please enter usercode to search.");
			}else{
				buttonDisableMessage = "Searching..."
				$("#createUserSerachResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
				buttonActualMessage = $(e.target).html();
				$(e.target).attr("disabled", "disabled");
				$(e.target).html(buttonDisableMessage);
				$.ajax({
		    		url : '${pageContext.request.contextPath}/cmUAMMaker/searchUserForm',
		    		data : fullData,
		    		cache : false,
		    		type : 'POST',
		    		success : function(resData){
		    			// alert(resData);
		    			$("#createUserSerachResultPanel"+id).css("display","block");
		    			$("#createUserSerachResult"+id).html(resData);
		    			$(e.target).removeAttr("disabled");
						$(e.target).html(buttonActualMessage);
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();					
		    		},
		    		error : function(){
		    			$("#createUserSerachResult"+id).html("Something went wrong");
		    		}
		    	});
			}
		});
		
		
		$("#createUser"+id).click(function(e){
			// alert('in create');
			var isValid = true;
			var fullData;
			var buttonDisableMessage;
			var buttonActualMessage;
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");				
			
			var userCode = $("#userCode").val();
			var userPass = $("#userPass").val();
			var firstName = $("#firstName").val();
			var lastName = $("#lastName").val();
			var emailId = $("#emailId").val();
			var mobileNo = "";
			var designation = "";
			var employeeCode = $("#employeeCode").val();
			var branchCode = $("#branchCode").val();
			var departmentCode = $("#departmentCode").val();
			//var groupCode = $("#groupCode").val();
			
			var accessStartTime = '00:00';
			var accessEndTime = '23:59';
			var accountExpiryDate = '01/01/3000';
			var ISETLUSER = 'N'; 
			var passwordReset = 'N';
			var chatEnabled = 'N';
			
			if(userCode == ""){
				isValid = false;
				alert("Enter User Code");
				$("#userCode").focus();
			}else{
				if(!validateUserCode()){
					isValid = false;
					$("#userCode").focus();
				}
			}
			
			if(userPass == "" && isValid){
				isValid = false;
				alert("Enter User's Password");
				$("#userPass").focus();
			}
			if((firstName == "" || lastName == "")){
				isValid = false;
				alert("Enter First Name and Last Name");
				if(firstName == "")
					$("#firstName").focus();
				if(lastName == "")
					$("#lastName").focus();
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
			
			if(employeeCode == ""){
				isValid = false;
				alert("Enter Employee Code");
				$("#employeeCode").focus();
			}else{
				if(!validateEmpCode()){
					isValid = false;
					$("#employeeCode").focus();
				}
			}
			if(departmentCode == "ALL"){
				isValid = false;
				alert("Select Department Code");
				$("#departmentCode").focus();
			}
			
			/* Commented for BANDHAN 23/09/2020 */
			/* if(groupCode == "ALL"){
				isValid = false;
				alert("Select User Role");
				$("#groupCode").focus();
			} */
			
			fullData = "userCode="+userCode+"&userPass="+userPass+"&firstName="+firstName+"&lastName="+lastName+
					   "&emailId="+emailId+"&mobileNo="+mobileNo+"&designation="+designation+
					   "&employeeCode="+employeeCode+"&branchCode="+branchCode+"&departmentCode="+departmentCode+
					   //"&groupCode="+groupCode+
					   "&accessStartTime="+accessStartTime+"&accessEndTime="+accessEndTime+
			           "&accountExpiryDate="+accountExpiryDate+"&passwordReset="+passwordReset+
			           "&chatEnabled="+chatEnabled+"&ISETLUSER="+ISETLUSER;
			
			if(isValid){
				buttonDisableMessage = "Creating...";
				$("#createUserSerachResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
				buttonActualMessage = $(e.target).html();
				$(e.target).attr("disabled", "disabled");
				$(e.target).html(buttonDisableMessage);
				$.ajax({
		    		url : '${pageContext.request.contextPath}/cmUAMMaker/createUserWithRole',
		    		data : fullData,
		    		cache : false,
		    		type : 'POST',
		    		success : function(resData){
		    			// alert(resData);
		    			$("#searchUser"+id).click();
		    			/*$("#createUserSerachResultPanel"+id).css("display","block");
		    			$("#createUserSerachResult"+id).html(resData); */
		    			$(e.target).removeAttr("disabled");
						$(e.target).html(buttonActualMessage);
						$("#userCode").val("");
						$("#userPass").val("");
						$("#firstName").val("");
						$("#lastName").val("");
						$("#emailId").val("");
						$("#mobileNo").val("");
						$("#designation").val("");
						$("#accountExpiryDate").val("");
						$("#employeeCode").val("");
						$("#departmentCode").prop('selectedIndex',0);
						$("#branchCode").prop('selectedIndex',0);
						//$("#groupCode").prop('selectedIndex',0);
						/*$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();	*/				
		    		},
		    		error : function(){
		    			$("#createUserSerachResult"+id).html("Something went wrong");
		    		}
		    	});
			}
		});
		
		/* $(".createUserPanelButtons > button").click(function(e){
			e.preventDefault();
				var isValid = true;
				var url;
				var fullData;
				var buttonDisableMessage;
				var buttonActualMessage;
				var mainRow = $(this).parents(".compassrow"+id);
				var slidingDiv = $(mainRow).children().children().children();
				var panelBody = $(mainRow).children().children().find(".panelSearchForm");				
				
				var userCode = $("#userCode").val();
				var userPass = $("#userPass").val();
				var firstName = $("#firstName").val();
				var lastName = $("#lastName").val();
				var emailId = $("#emailId").val();
				// var mobileNo = $("#mobileNo").val();
				//var designation = $("#designation").val(); 
				var mobileNo = "";
				var designation = "";
				var employeeCode = $("#employeeCode").val();
				var branchCode = $("#branchCode").val();
				var departmentCode = $("#departmentCode").val();
				var groupCode = $("#groupCode").val();
				
				var accessStartTime = '00:00';
				var accessEndTime = '23:59';
				var accountExpiryDate = '01/01/3000';
				var ISETLUSER = 'N'; 
				var passwordReset = 'N';
				var chatEnabled = 'N';
				
				 
				if($(e.target).attr("id") == "searchUser"){
					url = "${pageContext.request.contextPath}/adminMaker/searchUserForm";
					var firstName= "";
					var lastName= "";
					var emailId= "";
					var mobileNo= "";
					
					fullData = "userCode="+userCode+"&firstName="+"&lastName="+lastName+"&emailId="+emailId;	
				  //fullData = "userCode="+userCode+"&firstName="+firstName+"&lastName="+lastName+"&emailId="+emailId+"&mobileNo="+mobileNo;
					buttonDisableMessage = "Searching...";
				}
					
				if($(e.target).attr("id") == "createUser"){
					if(userCode == ""){
						isValid = false;
						alert("Enter User Code");
						$("#userCode").focus();
					}
					if(userPass == "" && isValid){
						isValid = false;
						alert("Enter User's Password");
						$("#userPass").focus();
					}
					if((firstName == "" || lastName == "")){
						isValid = false;
						alert("Enter First Name and Last Name");
						if(firstName == "")
							$("#firstName").focus();
						if(lastName == "")
							$("#lastName").focus();
					}
					// if(emailId == ""){
					//	isValid = false;
					//	alert("Enter Email ID");
					//	$("#emailId").focus();
					//}else{ 
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
					
					if(employeeCode == ""){
						isValid = false;
						alert("Enter Employee Code");
						$("#employeeCode").focus();
					}else{
						if(!validateEmpCode()){
							isValid = false;
							$("#employeeCode").focus();
						}
					}
					
					if(departmentCode == "ALL"){
						isValid = false;
						alert("Select Department Code");
						$("#departmentCode").focus();
					}
					if(groupCode == "ALL"){
						isValid = false;
						alert("Select User Role");
						$("#groupCode").focus();
					}
					
					url = "${pageContext.request.contextPath}/adminMaker/createUserWithRole";
					fullData = "userCode="+userCode+"&userPass="+userPass+"&firstName="+firstName+"&lastName="+lastName+
							   "&emailId="+emailId+"&mobileNo="+mobileNo+"&designation="+designation+
							   "&employeeCode="+employeeCode+"&branchCode="+branchCode+"&departmentCode="+departmentCode+
							   "&groupCode="+groupCode+
							   "&accessStartTime="+accessStartTime+"&accessEndTime="+accessEndTime+
					           "&accountExpiryDate="+accountExpiryDate+"&passwordReset="+passwordReset+
					           "&chatEnabled="+chatEnabled+"&ISETLUSER="+ISETLUSER;
					buttonDisableMessage = "Creating...";
				}
				//alert(fullData);
				if(isValid){
					$("#createUserSerachResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
					buttonActualMessage = $(e.target).html();
					$(e.target).attr("disabled", "disabled");
					$(e.target).html(buttonDisableMessage);
					$.ajax({
			    		url : url,
			    		data : fullData,
			    		cache : false,
			    		type : 'POST',
			    		success : function(resData){
			    			console.log(resData);
			    			$("#searchUser").click();
			    			$("#createUserSerachResultPanel"+id).css("display","block");
			    			//$("#createUserSerachResult"+id).html(resData);
			    			$(e.target).removeAttr("disabled");
							$(e.target).html(buttonActualMessage);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();					
			    		},
			    		error : function(){
			    			$("#createUserSerachResult"+id).html("Something went wrong");
			    		}
			    	});
				}
		}); */		
	});
	
	function editUser(){
		var selectedCount = 0;
		var selectedValue = "";
		var enable = "";
		$("#createUserSerachResult"+id).find("table.searchResultGenericTable").children("tbody").children("tr").each(function(){			
			if($(this).children("td:first-child").children("input[type='checkbox']").is(":checked")){
				selectedValue = $(this).find("td").children("input[type='checkbox']").val();
				selectedCount++;
			}
		});
		//alert(selectedValue);
		if(selectedCount == 1){
			navigate('Edit User','editUser','cmUAMMaker/editUser?usercode='+escape(selectedValue),'1')
		}else{
			alert("Select one row");
		}
	}
	
	function validateEmpCode(){
	    var empCode = $("#employeeCode").val();
		//alert(empCode);
	    if(/[^a-zA-Z0-9\-\/]/.test( empCode ) ) {
	        alert('Employee Code contains special characters.');
	        /* empCode = empCode.replace(/[^A-Z0-9]+/ig, "");
	        alert(empCode); */
	        return false;
	    }
	    return true;     
	}

	function validateUserCode(){
	    var userCode = $("#userCode").val();
	    if(/[^a-zA-Z0-9\.\-\/]/.test( userCode ) ) {
	        alert('User Code contains special characters.');
	        return false;
	    }
	    return true;     
	}
	
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_alertEngines">
			<div class="card-header panelSlidingCreateUser${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.createUserHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="AlertEngines/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable table-sm" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="18%">UserCode</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" id="userCode" name="userCode" placeholder="User Code" onkeyup="this.value = this.value.toUpperCase();"/>								
							</td>
							<td width="4%">&nbsp;</td>
							<td width="18%">Password</td>
							<td width="30%">
							    <!--
								<input type="password" class="form-control input-sm" id="userPass" name="userPass" disabled="disabled" value="Compass@123"/>
								-->
								<c:if test="${LDAPSYSTEM == 'Y' }">
									<input type="password" class="form-control input-sm" id="userPass" name="userPass" value="Compass@123" disabled="disabled"/>
									<em style="font-size: 11px; color: red">This password will be dummy as System is connected to AD</em>
								</c:if>
								<c:if test="${LDAPSYSTEM == 'N' }">
									<input type="password" class="form-control input-sm" id="userPass" name="userPass" value="Compass@123" />
								</c:if>
							</td>
						</tr>
						<tr>
							<td>FirstName</td>
							<td>
								<input type="text" class="form-control input-sm" id="firstName" name="firstName" placeholder="First Name" />
							</td>
							<td>&nbsp;</td>
							<td>LastName</td>
							<td>
								<input type="text" class="form-control input-sm" id="lastName" name="lastName" placeholder="Last Name"/>
							</td>
						</tr>
						<tr>
							<td>Employee Code</td>
							<td>
								<input type="text" class="form-control input-sm" id="employeeCode" name="employeeCode" 
									oninput="validateEmpCode()" placeholder="Employee Code" onkeyup="this.value = this.value.toUpperCase();"/>
							</td>
							<td>&nbsp;</td>
							<td>Email ID</td>
							<td>
								<input type="text" class="form-control input-sm" id="emailId" name="emailId" placeholder="Email ID" />
							</td>
						</tr>
						<!-- <tr>
							<td>
								<select class="form-control input-sm" id="designation" name="designation">
									<c:forEach var="designationCode" items="${DESIGNATIONCODES}">
										<option value="${designationCode.key}">${designationCode.key} - ${designationCode.value}</option>
									</c:forEach>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>Mobile No</td>
							<td>
								<input type="text" class="form-control input-sm" id="mobileNo" name="mobileNo" placeholder="Mobile No"/>
							</td> 
						</tr> -->
						<tr>
							<!-- <td>Department Code</td> -->
							<td>Assessment Unit</td>
							<td>
								<select class="form-control input-sm" id="departmentCode" name="departmentCode">
									<c:forEach var="departmentCode" items="${DEPARTMENTCODES}">
										<option value="${departmentCode.key}">${departmentCode.value}</option>
									</c:forEach>
								</select>
							</td>
							<td>&nbsp;</td>
							<td>Branch Code</td>
							<td>
								<select class="form-control input-sm" id="branchCode" name="branchCode">
									<c:forEach var="branchCode" items="${BRANCHCODES}">
										<option value="${branchCode.key}">${branchCode.key} - ${branchCode.value}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<%-- <tr>
							<td>User Role</td>
							<td>
								<select class="form-control input-sm" id="groupCode" name="groupCode">
									<option value="ALL">Select User Role</option>
									<c:forEach items="${ALLROLES}" var="roleDetails">
										<option value="${roleDetails}">${roleDetails}</option>
									</c:forEach>
								</select>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr> --%>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR} createUserPanelButtons">
					<button id="searchUser${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<button id="createUser${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.createUserHeader"/></button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="createUserSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCreateUser${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="createUserSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-right">
					<button type="button" class="btn btn-primary btn-sm" onclick="editUser()"><spring:message code="app.common.editUserHeader"/></button>
				</div>
			</div>
		</div>
	</div>
</div>