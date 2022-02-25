<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,javax.naming.*,javax.naming.directory.*" 
isELIgnored="false"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="../tags/staticFiles.jsp" />
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>

<%-- <%
String userLogon = new com.sun.security.auth.module.NTSystem().getName();
String allAttributes = "";
System.out.println("userLogon:  "+userLogon);
System.out.println(request);
System.out.println(request.getSession());
System.out.println(request.getSession().getAttribute("userLogon"));

if(request.getSession().getAttribute("userLogon") == null)
{  
String auth = request.getHeader("Authorization");
try
 { 

   if (auth == null) 
   {
	   response.setStatus(response.SC_UNAUTHORIZED); 
       response.setHeader("WWW-Authenticate", "NTLM"); 
       response.flushBuffer(); 
   } 
   if (auth.startsWith("NTLM ")) 
   { 
     byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth.substring(5)); 
     int off = 0, length, offset; 
     if (msg[8] == 1) 
     { 
       byte z = 0; 
       byte[] msg1 = {(byte)'N', (byte)'T', (byte)'L', (byte)'M', (byte)'S', (byte)'S', (byte)'P', z,(byte)2, z, z, z, z, z, z, z,(byte)40, z, z, z, (byte)1, (byte)130, z, z,z, (byte)2, (byte)2, (byte)2, z, z, z, z, z, z, z, z, z, z, z, z}; 
       response.setHeader("WWW-Authenticate", "NTLM " + new sun.misc.BASE64Encoder().encodeBuffer(msg1)); 
       response.sendError(response.SC_UNAUTHORIZED);
     } 
    else if (msg[8] == 3) 
    {
       off = 30; 
       length = msg[off+17]*256 + msg[off+16]; 
       offset = msg[off+19]*256 + msg[off+18]; 
       String remoteHost = new String(msg, offset, length); 
       length = msg[off+1]*256 + msg[off]; 
       offset = msg[off+3]*256 + msg[off+2]; 
       String domain = new String(msg, offset, length); 
       length = msg[off+9]*256 + msg[off+8];
       offset = msg[off+11]*256 + msg[off+10]; 
       //String userLogon = new String(msg, offset, length); 
       userLogon = new String(msg, offset, length); 
       char a =0; 
       char b =32;
       request.getSession().setAttribute("userLogon",userLogon.trim().replace(a,b).replaceAll(" ","")); 
       request.getSession().setAttribute("domain",domain.trim().replace(a,b).replaceAll(" ","")); 
       response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
    } 
  } 
  }catch(Exception e)
  { 
    System.out.println(e.getMessage()); 
  }
}
%>


<%
if(request.getSession().getAttribute("usernamevalue") == null && request.getSession().getAttribute("usermail") == null)
{  

try {
            char a =0; 
            char b =32; 

            String DOMAIN_NAME = "qdepvtltd";
            String DOMAIN_CONTROLER = "domaincontroller";
            
            Hashtable env = new Hashtable();

            String host = "localhost";
            String port = "10389";
            
            String url = new String("ldap://localhost:10389");
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
            env.put(Context.PROVIDER_URL,url);
            env.put(Context.SECURITY_AUTHENTICATION, "simple");
            env.put(Context.REFERRAL, "follow");
            DirContext dirContext;
            dirContext = new InitialDirContext(env);
            
            String as[] = {"mailNickName", "distinguishedName", "mail", "name", "lname", "sAMAccountName"};
            //String as[] = {"mail", "name"};
            SearchControls ctls = new SearchControls();
            ctls.setSearchScope(2);
            ctls.setReturningAttributes(null);
            //ctls.setReturningAttributes(as);
            ctls.setReturningObjFlag(true);
            
            String filter = "(%A(sAMAccountName=%U)( distinguishedName=*))";
            filter = "(&(objectClass=inetOrgPerson)(uid={0}))";
            filter = "(&(&(objectClass=person)(objectCategory=user))(sAMAccountName=" + userLogon + "))";
            filter = "(&(objectClass=inetOrgPerson)(uid="+userLogon+"))";
          
            NamingEnumeration namingEnumeration = dirContext.search("dc=example,dc=com", filter, ctls);
          	//n = ctx.search("dc=example,dc=com", filter, ctls);
          	String domainName = null;
          	
          	while(namingEnumeration.hasMore()) {
              SearchResult result = (SearchResult) namingEnumeration.next();
              domainName = result.getNameInNamespace();
              Attributes attributes = result.getAttributes();
              NamingEnumeration namingEnumeration1 = attributes.getAll();
              while(namingEnumeration1.hasMore()) {
            	  Attribute attribute = (Attribute)namingEnumeration1.next();
            	  
            	  allAttributes = allAttributes + attribute.getID()+" ,: "+attributes.get(attribute.getID()).get().toString()+"\n";
              }
          	}

          	if (domainName == null || namingEnumeration.hasMore()) {
              throw new NamingException("Authentication failed");
          	}
          
          	namingEnumeration.close();
        } catch (Exception e) {
           System.out.println("Exception2 = "+ e);
        }
}
%>

<%
 String l_SerialNo=System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9);
 String l_strCustomerType = request.getParameter("CustomerType");
 if(l_strCustomerType == null) l_strCustomerType="C";
 String l_strMesage = (String)request.getAttribute("Message");
 System.out.println("allAttributes   "+allAttributes);
%> --%>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var csrfToken = '${XCSRFTOKEN1}';
		var userLogon = '${USERLOGON}';
		var tableClass = 'suspicionTransactionDetailsTable';
		
		
		var uid = '${uid}';
		var mailId = '${mail}';
		var givenName = '${givenname}';
		var sn = '${sn}';
		var cn = '${cn}';
		var userPassword = '${userpassword}';
		
		//console.log(uid+" -- "+mailId+" -- "+givenName+" -- "+sn+" -- "+cn+" -- "+userPassword);			
		
		compassDatatable.construct(tableClass, "Suspicion Transaction Details", false);
		compassTopFrame.init(id, tableClass, 'dd/mm/yy');		
		
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
			$("#customerFields1"+id).css("display", "none");
			$("#branchField").html("Branch Code <span style='color: red;'>*</span>");
			//$("#changingFieldText").html("Others");
			$("#personNameField").html("Name of Account/Person <span style='color: red;'>*</span>");
		}
		else{
			$("#nonCustomerFields").css("display", "none");
			$("#nonCustomerFields2").css("display", "none");
			$("#customerFields").css("display", "table-row");
			$("#customerFields1"+id).css("display", "table-row");
			$("#branchField").html("Branch Code");
			$("#changingFieldText").html("Customer ID");
		}
	});
	
	$("#submitRaiseSuspicionForm"+id).click(function(){
		//var userLogon = $(userLogon);
		var reportingOn = $("#reportingOn").val();
		var branchCode = $("#branchCode").val();
		var accountOrPersonName = $("#accountOrPersonName").val();
		var alertRating = $("#alertRating").val();
		var accountNo = $("#accountNo").val();
		var customerId = $("#customerId").val();
		var address1 = $("#address1").val(); 
		var address2 = $("#address2").val();	
		var typeOfSuspicion = $("#typeOfSuspicion").val();
		var reasonForSuspicion = $("#reasonForSuspicion").val();
		var rasUserCode = $("#rasUserCode"+id).val();
		
		var isValidCustId = true;
		var isValidAccNo = true;
		var custIdOrAccNoExist = true;
		
		if(reportingOn == 'customer'){
			if(customerId != "" || accountNo != ""){
				//alert(custIdOrAccNoExist);
				if(accountNo != ""){
					$.ajax({
						url: "${pageContext.request.contextPath}/commonFromPortal/validationCheck",
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
						url: "${pageContext.request.contextPath}/commonFromPortal/validationCheck",
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
				branchCode = $("#branchCode").val();
				
				var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
				   "&alertRating="+alertRating+"&accountNo="+accountNo+"&customerId="+customerId+
				   "&typeOfSuspicion="+typeOfSuspicion+ "&reasonForSuspicion="+reasonForSuspicion+
				   "&rasUserCode="+rasUserCode;
	
				if(reportingOn != "" && alertRating != "" && typeOfSuspicion != "" && reasonForSuspicion != ""){
						//alert(fullData);
					 $.ajax({
						url: "${pageContext.request.contextPath}/commonFromPortal/submitReportOfSuspicionFromPortal?alertNo="+id+"&userLogon="+userLogon+
								"&uid="+uid+"&mailId="+mailId+"&givenName="+givenName+"&sn="+sn+"&cn="+cn+"&userPassword="+userPassword,
						headers: {
							"X-CSRF-TOKEN": csrfToken	
						 },		
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							window.location.reload();
							//sendEmailFromPortal();
							//$("#clearRaiseSuspicionForm"+id).click();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
				    });  
				}else{
					alert("Please fill the form before submitting.");
				}
			}
		}else if(reportingOn == 'non-customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
			   "&alertRating="+alertRating+"&accountNo="+accountNo+"&others="+others+"&address1="+address1+"&address2="+address2+"&typeOfSuspicion="+typeOfSuspicion+ 
			   "&reasonForSuspicion="+reasonForSuspicion+"&rasUserCode="+rasUserCode;
			if(reportingOn != "" && branchCode != "" && alertRating != "" && accountOrPersonName != "" && typeOfSuspicion != "" 
					&& reasonForSuspicion != ""){
				if(branchCode == "ALL"){
					alert("Please select a specific Branch Code");
				//alert(fullData);
				}else{
					 $.ajax({
						url: "${pageContext.request.contextPath}/commonFromPortal/submitReportOfSuspicionFromPortal?alertNo="+id+"&userLogon="+userLogon+
						"&uid="+uid+"&mailId="+mailId+"&givenName="+givenName+"&sn="+sn+"&cn="+cn+"&userPassword="+userPassword,
						headers: {
							"X-CSRF-TOKEN": csrfToken	
						 },		
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							window.location.reload();
							//$("#clearRaiseSuspicionForm"+id).click();
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
		compassFileUploadFromPortal.init("attachEvedence","${pageContext.request.contextPath}","5678","0","Y","Y",id);
	});
	
	$(".compassrow"+id).find("select").select2();
	
});


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

/* function uploadDetailsButton(elm){
	compassFileUpload.init("uploadFile","${pageContext.request.contextPath}","uploadRASAlertsdata","0","Y","Y","");
}
 */
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
			<%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
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
						<tr id = "customerFields">
							<td width="15%">Account No
								<!-- <span style="color: red;">*</span> -->
							</td>
							<td width="30%">
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="accountNo" name="accountNo"/>
									<span class="input-group-addon formSearchIcon" id="basic-addon" 
										onclick="compassTopFrameFromPortal.moduleSearch('accountNo','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
										<i class="fa fa-search"></i>
									</span>
								</div>
							</td>
							<td width="10%" style="color: red; font-size: xx-small; overflow: hidden; text-align: center;">Please Enter AccountNo or CustomerId</td>
							<td width="15%">Customer Id</td>
							<td width="30%">
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="customerId" name="customerId"/>
									<span class="input-group-addon formSearchIcon" id="basic-addon" 
										onclick="compassTopFrameFromPortal.moduleSearch('customerId','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
										<i class="fa fa-search"></i>
									</span>
								</div>	
							</td>
						</tr>
						<tr id="customerFields1${UNQID}">
							<td width="15%">List of Users</td>
							<td width="30%">
								<c:choose>
									<c:when test="${f:contains(ROLE, 'AMLUSER')}">
										<select class="form-control input-sm" id="rasUserCode${UNQID}" name="rasUserCode" disabled="disabled">
											<c:forEach var="RASUsersList" items="${RASUSERSLIST}">
												<option value="${RASUsersList.USERCODE}" <c:if test="${RASUsersList.USERCODE eq userCode}">selected="selected"</c:if>>${RASUsersList.USERNAME}</option>
											</c:forEach>
										</select>
									</c:when>
									<c:otherwise>
										<select class="form-control input-sm" id="rasUserCode${UNQID}" name="rasUserCode">
											<c:forEach var="RASUsersList" items="${RASUSERSLIST}">
												<option value="${RASUsersList.USERCODE}" <c:if test="${RASUsersList.USERCODE eq userCode}">selected="selected"</c:if>>${RASUsersList.USERNAME}</option>
											</c:forEach>
										</select>
									</c:otherwise>
								</c:choose>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr id = "nonCustomerFields" style="display: none; background-color: #f9f9f9;">
							<td width="15%">Address 1
								<!-- <span style="color: red;">*</span> -->
							</td>
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
							<td width="15%">List of Users</td>
							<td width="30%">
								<c:choose>
									<c:when test="${f:contains(ROLE, 'AMLUSER')}">
										<select class="form-control input-sm" id="listOfRasUsers${UNQID}" name="listOfRasUsers" disabled="disabled" style="width: 100%;">
											<c:forEach var="RASUsersList" items="${RASUSERSLIST}">
												<option value="${RASUsersList.USERCODE}" <c:if test="${RASUsersList.USERCODE eq userCode}">selected="selected"</c:if>>${RASUsersList.USERNAME}</option>
											</c:forEach>
										</select>
									</c:when>
									<c:otherwise>
										<select class="form-control input-sm" id="listOfRasUsers${UNQID}" name="listOfRasUsers" style="width: 100%;">
											<c:forEach var="RASUsersList" items="${RASUSERSLIST}">
												<option value="${RASUsersList.USERCODE}" <c:if test="${RASUsersList.USERCODE eq userCode}">selected="selected"</c:if>>${RASUsersList.USERNAME}</option>
											</c:forEach>
										</select>
									</c:otherwise>
								</c:choose>
							</td>
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
				<%-- <input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Submit"/> --%>
				<input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Create Case"/>
				<input type="button" class="btn btn-success btn-sm" id="attachViewEvidence${UNQID}" name="Attach/View Evidence" value="Attach/View Evidence"/>
				<%-- <button type="button" id="uploadRASAlertsdata${UNQID}" class="btn btn-primary btn-sm"  onclick="uploadDetailsButton(this)">Upload Alerts Data</button> --%>
				<input type="reset" class="btn btn-danger btn-sm" id="clearRaiseSuspicionForm${UNQID}" name="Clear" value="Clear"/>
			</div>
		</div> 
		
		<div class="modal fade bd-example-modal-sm" id="compassSearchModuleModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
  		<div class="modal-dialog modal-xl">
    		<div class="modal-content card-primary">
    			<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassSearchModuleModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassSearchModuleModal-body">
				</div>
			</div>
 		</div>
		</div>
	
		<div class="modal fade bs-example-modal-lg" id="compassFileUploadModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassFileUploadModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassFileUploadModal-body">
					<div id="compassFileUploadModal-loader">
						<br/>
							<center>
								<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
							</center>
						<br/>
					</div>
					<div id="compassFileUploadModal-process" style="display: none;">
					</div>
					<div class="d-flex">
					<div class="row" id="compassFileUploadModal-upload" style="display: none;">
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Upload File</h6>
								</div>
								<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
									<tr>
										<td colspan="2" style="font-size: 10px;">
											Allowed File Size : <span id="compassFileUploadModal-uploadFileSize"></span><br/>
											Allowed File Type : <span id="compassFileUploadModal-uploadFileAllowedType"></span><br/>
											Block File Type : <span id="compassFileUploadModal-uploadFileBlockedType"></span><br/>
											Maximum File Select Count : <span id="compassFileUploadModal-uploadFileMaxNoSize"></span><br/>
											Upload Enable : <span id="compassFileUploadModal-uploadEnable"></span>
										</td>
									</tr>
									<tr>
										<td width="15%">Select Files</td>
										<td width="85%">
											<input id="fileupload" onchange="compassFileUploadFromPortal.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center; font-weight: bold;">Or</td>
									</tr>
									<tr>
										<td>Drop Files</td>
										<td>
											<div id="dragandrophandler">Drag & Drop Files Here</div>
										</td>
									</tr>
									<tr>
										<td>Selected Files</td>
										<td>
											<table class="table table-bordered table-striped" id="upload-files" style="font-size: 12px;">
										        <tr>
										            <th width="25%">File Name</th>
										            <th width="15%">File Size</th>
										            <th width="10%">File Type</th>
										            <th width="25%">Progress</th>
										            <th width="25%">Action / Status</th>
										        </tr>
										    </table>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center;">
											<button type="button" class="btn btn-warning btn-sm" id="upload" disabled="disabled" onclick="compassFileUploadFromPortal.startUpload(this);">Upload</button>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Download File</h6>
								</div>
								<div id="compassFileUploadModal-uploadedFiles">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				</div>
			</div>
		</div>
	</div>
</form>
</div>
</div>
</div>	