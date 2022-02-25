<%@ page import="java.util.*,javax.naming.*,javax.naming.directory.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="./tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="./tags/staticFiles.jsp" />
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>

<%
String userLogon = new com.sun.security.auth.module.NTSystem().getName();
String allAttributes = "";
System.out.println("asdauserLogon:  "+userLogon);
//out.println("dasdasuserLogon   "+userLogon);
//String l_struserLogon      = (String)request.getSession().getAttribute("userLogon"); 
//String l_strusernameValue = (String)request.getSession().getAttribute("usernamevalue"); 
//String l_struserMail      = (String)request.getSession().getAttribute("usermail"); 


if(request.getSession().getAttribute("userLogon") == null)
{  
String auth = request.getHeader("Authorization");
//out.println("2:   ");
//System.out.println("auth:  "+auth);
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
       /* 
       System.out.println("userLogon:"+userLogon.trim().replace(a,b).replaceAll(" ","")); 
       System.out.println("RemoteHost:"+remoteHost.trim().replace(a,b).replaceAll(" ","")); 
       System.out.println("Domain:"+domain.trim().replace(a,b).replaceAll(" ",""));
       */
       request.getSession().setAttribute("userLogon",userLogon.trim().replace(a,b).replaceAll(" ","")); 
       request.getSession().setAttribute("domain",domain.trim().replace(a,b).replaceAll(" ","")); 
       response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
    } 
  } 
  }catch(Exception e)
  { 
    //System.out.println(e.getMessage()); 
  }
}
%>


<%
if(request.getSession().getAttribute("usernamevalue") == null && request.getSession().getAttribute("usermail") == null)
{  

try {
            char a =0; 
            char b =32; 

            String userName = userLogon.trim().replace(a,b).replaceAll(" ","");

            String DOMAIN_NAME = "qdepvtltd";
            String DOMAIN_CONTROLER = "domaincontroller";
            
            Hashtable env = new Hashtable();

            // env.put(Context.SECURITY_AUTHENTICATION,"simple");

            //String activeDirUser = DOMAIN_NAME + "\\37766";
            String activeDirUser = DOMAIN_NAME + "\\"+userLogon;
            //activeDirUser = "QDE\\"+userLogon;
            activeDirUser = "QDE";
            //env.put(Context.SECURITY_CREDENTIALS, "Compass@123");
            String host = "localhost";
            String port = "10389";
            
            String url = new String("ldap://localhost:10389");
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
            env.put(Context.PROVIDER_URL,url);
            env.put(Context.SECURITY_AUTHENTICATION, "simple");
            env.put(Context.REFERRAL, "follow");
            //env.put(Context.SECURITY_PRINCIPAL, "cn=qdenew,ou=Users,dc=example,dc=com");
            // ctx.addToEnvironment(Context.SECURITY_CREDENTIALS, "Compass@123");
          	
            //System.out.println("aaaa, url : "+url+"  ,activeDirUser:  "+activeDirUser);
            DirContext ctx;
            ctx = new InitialDirContext(env);
            //ctx.addToEnvironment(Context.SECURITY_PRINCIPAL, "cn=qdenew,ou=Users,dc=example,dc=com");
          	
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
          
            //NamingEnumeration n= ctx.search("cn=QDE,ou=users,dc=example,dc=com",filter1,ctls);
          	NamingEnumeration n = ctx.search("dc=example,dc=com", filter, ctls);
          	//n = ctx.search("dc=example,dc=com", filter, ctls);
          	String dn = null;
          	
          	//private  final String AD_ATTR_NAME_USER_EMAIL = "mail";
          	final String AD_ATTR_NAME_USER_EMAIL = "mail";
          	while(n.hasMore()) {
              SearchResult result = (SearchResult) n.next();
              dn = result.getNameInNamespace();
              Attributes attributes = result.getAttributes();
              NamingEnumeration n1 = attributes.getAll();
              //System.out.println("n1 is "+n1.hasMore());
              while(n1.hasMore()) {
            	  Attribute attribute = (Attribute)n1.next();
            	  
            	  //System.out.println("  , attribute.getID():  "+attribute.getID()+" , And Value Is: "+attributes.get(attribute.getID()).get().toString());
            	  allAttributes = allAttributes + attribute.getID()+" ,: "+attributes.get(attribute.getID()).get().toString()+"\n";
            	  //allAttributes = allAttributes + "Id : "+attribute.getID().toString()+" , Value:= "+attribute.get(attribute.getID.toString()).toString();
              }
              // System.out.println("dn: "+dn+"  , mail: "+attributes.get(AD_ATTR_NAME_USER_EMAIL));
          	}

          	if (dn == null || n.hasMore()) {
              // uid not found or not unique
              throw new NamingException("Authentication failed");
          	}
          
          	//ctx.addToEnvironment(Context.SECURITY_PRINCIPAL, dn);
          	//ctx.addToEnvironment(Context.SECURITY_CREDENTIALS, "Compass@123");
          	// Perform a lookup in order to force a bind operation with JNDI
          	//ctx.lookup(dn);
          	//System.out.println("Authentication successful");

          	n.close();
          
		  /*           
          //System.out.println("n.hasMore() ,  "+n.hasMore());
          System.out.println("aaaa3 , "+n);
          //System.out.println("aaaa3 ,n.next() "+n.next());
          
          String l_strKey = n.next().toString();
          System.out.println("aaaa3, l_strKey0: "+l_strKey);
          String l_strUserMail=l_strKey.substring(l_strKey.indexOf("mail:")+5,l_strKey.indexOf("name")-1);
          String l_strRestValue =  l_strKey.substring(l_strKey.indexOf("mail:")+5,l_strKey.length());
          String l_strUserName  =l_strRestValue.substring(l_strRestValue.indexOf("name:")+5,l_strRestValue.indexOf("/")-1);
          System.out.println("aaaa3, l_strKey: "+l_strKey);
          System.out.println("aaaa3, l_strUserMail: "+l_strUserMail);
          System.out.println("aaaa3, l_strRestValue: "+l_strRestValue);
          System.out.println("aaaa3, l_strUserName: "+l_strUserName);
          
          request.getSession().setAttribute("usermail",l_strUserMail.trim().replace(",","")); 
          request.getSession().setAttribute("usernamevalue",l_strUserName.trim()); 

          //out.println("l_strUserMail    "+l_strUserMail+"<BR>");
          //out.println("l_strUserName    "+l_strUserName+"<BR>");

          while (n.hasMoreElements()) {

          System.out.println(n.next());
          }
          ctx.close();
          */
        } catch (Exception e) {
           out.println("Exception2  "+e+"<BR>");
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
 out.println("allAttributes   "+allAttributes);
%>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'suspicionTransactionDetailsTable';
		compassDatatable.construct(tableClass, "Suspicion Transaction Details", false);
		compassTopFrame.init(id, tableClass, 'dd/mm/yy');
		
		//for getting all suspicious reasons in js
		var subReasonsArr =	[];
		<c:forEach var="ALLREASONS" items="${TYPEOFSUSPICION}">
			<c:forEach var="SUBREASONS" items="${ALLREASONS}">
				var subReasonsObj = {};
				subReasonsObj["${SUBREASONS.key}"] = {};
				<c:forEach var = "reasonAndReasonCode" items= "${SUBREASONS.value}">
					subReasonsObj["${SUBREASONS.key}"]['REASONCODE'] = "${reasonAndReasonCode.key}"
					subReasonsObj["${SUBREASONS.key}"]['REASON'] = "${reasonAndReasonCode.value}"
				</c:forEach>
				subReasonsArr.push(subReasonsObj);
			</c:forEach>
		</c:forEach>
		
		
		
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
			$("#customerFields").css("display", "none");
		}
		else{
			$("#nonCustomerFields").css("display", "none");
			$("#customerFields").css("display", "table-row");
		}
	});
	
	$("#repeatSAR").on("change", function(){
		//alert($(this).val());
		if($(this).val() == "YES"){
			$("#repeatSARRemarksField").css("display", "table-row");
		}
		else{
			$("#repeatSARRemarksField").css("display", "none");
			$("#repeatSARRemarks").val('');
		}
	});
	
	$("#submitRaiseSuspicionForm"+id).click(function(){
		var reportingOn = $("#reportingOn").val();
		var branchCode = $("#branchCode").val();
		var accountOrPersonName = $("#accountOrPersonName").val();
		var alertRating = $("#alertRating").val();
		var accountNo = $("#accountNo").val();
		var customerId = $("#customerId").val();
		var address1 = $("#address1").val(); 
		var address2 = $("#address2").val();	
		var typeOfSuspicion = $("#typeOfSuspicion"+id).val();
		var reasonForSuspicion = $("#reasonForSuspicion").val();
		var referenceCaseNo = $("#referenceCaseNo").val();
		var referenceCaseDate = $("#referenceCaseDate").val();
		/* var repeatSAR = $("#repeatSAR").val();
		var repeatSARRemarks = $("#repeatSARRemarks").val();
		var sourceOfInternalSAR = $("#sourceOfInternalSAR").val(); */
		var repeatSAR = "NO";
		var repeatSARRemarks = "";
		var sourceOfInternalSAR = "";
		var scenarioType = $("#scenarioType"+id).val();
		
	    /* if(!checkDate(referenceCaseDate)){
			  return false;
	    }	 */
	    
	    /* if(repeatSARRemarks != null || repeatSARRemarks != ""){
	    	if(repeatSAR == "" || repeatSAR == null){
	    	alert(repeatSAR);
	    	alert(repeatSARRemarks);
	    	alert("Please select an option in Repeat SAR.");
	    	}
	    	return false;
	    }else{
	    	return true;
	    } */
	    
	   /*  if(!checkRepeatSARRemarks(repeatSAR, repeatSARRemarks)){
	    	return false;
	    } */
	    
	    /*
	    if(!checkRepeatSAR(repeatSAR, repeatSARRemarks)){
	    	return false;
	    }
	     */
	     
		if(reportingOn == 'customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
						   "&alertRating="+alertRating+"&accountNo="+accountNo+"&customerId="+customerId+"&typeOfSuspicion="+typeOfSuspicion+
						   "&reasonForSuspicion="+reasonForSuspicion+"&referenceCaseNo="+referenceCaseNo+"&referenceCaseDate="+referenceCaseDate+
						   "&repeatSAR="+repeatSAR+"&repeatSARRemarks="+repeatSARRemarks+"&sourceOfInternalSAR="+sourceOfInternalSAR+
						   "&scenarioType="+scenarioType;
				if(reportingOn != "" && branchCode != "" && alertRating != "" && accountNo != "" && typeOfSuspicion != "" && 
					typeOfSuspicion != "Select" && reasonForSuspicion != "" && scenarioType != ""){
	
					//alert(fullData);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							reloadTabContent();
							//$("#clearRaiseSuspicionForm"+id).click();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
					});
				}
				else{
					alert("Please fill the form before submitting.");
				}
			}
		else if(reportingOn == 'non-customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
			   			   "&alertRating="+alertRating+"&address1="+address1+"&address2="+address2+"&typeOfSuspicion="+typeOfSuspicion+ 
			   			   "&reasonForSuspicion="+reasonForSuspicion+"&referenceCaseNo="+referenceCaseNo+"&referenceCaseDate="+referenceCaseDate+
			   			   "&repeatSAR="+repeatSAR+"&repeatSARRemarks="+repeatSARRemarks+"&sourceOfInternalSAR="+sourceOfInternalSAR+
			   			   "&scenarioType="+scenarioType;
				if(reportingOn != "" && branchCode != "" && accountOrPersonName != "" && alertRating != "" &&
					address1 != "" && address2 != "" && typeOfSuspicion != "" && typeOfSuspicion != "Select" 
					&& reasonForSuspicion != "" && scenarioType != "" ){
					//alert(fullData);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							reloadTabContent();
							//$("#clearRaiseSuspicionForm"+id).click();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
					});
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
	
	$("#scenarioType"+id).on("change", function(){
		createSubReasonsDropdown($(this).val());
	});
	createSubReasonsDropdown($("#scenarioType"+id).val());
	function createSubReasonsDropdown(selectedReasons){
		var subReasonsOptionsString = "<option>Select</option>";
		$.each(subReasonsArr,function(i,v){
			$.each(v,function(key,value){
				if(key.includes(selectedReasons)){
					subReasonsOptionsString += "<option value = '"+value['REASONCODE']+"'>"+value['REASON']+"</option>"
				}
			})
		});
		$("#typeOfSuspicion"+id).empty().append(subReasonsOptionsString);
	}
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

 function checkRepeatSARRemarks(isRepeat, repeatRemarks){
	if(isRepeat == "YES" && (repeatRemarks == null || repeatRemarks == "")){
		alert("Please input the remarks for Repeat SAR.");
		return false;
	}else{
		return true;
	}
} 

/* function checkRepeatSAR(isRepeat,repeatSARRemarks){
	//alert("isRepeat = '"+isRepeat+"'");
	if(repeatSARRemarks != "" || repeatSARRemarks != null){
		alert("Please select an option for Repeat SAR.");
		return false;
		if(isRepeat == ""){
			
		}
		return false;
	}else{
		return true;
	}
} */

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
						<table class="table table-striped subjectOfSuspicionTable" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%">Reporting On</td>
								<td width="30%">
									<select class="form-control " id="reportingOn" name="reportingOn">
										<option value="customer">Customer</option>
										<option value="non-customer">Non-Customer</option>
									</select>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Branch Code</td>
								<td width="30%">
									<select class="form-control " id="branchCode" name="branchCode">
										<c:forEach var="NAMEVALUE" items="${BRANCHCODES}">
											<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td width="15%">Name of Account/Person
									<!-- <span style="color: red;">*</span> -->
								</td>
								<td width="30%"><input type="text" class="form-control input-sm" id="accountOrPersonName" name="accountOrPersonName"/></td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Alert Rating</td>
								<td width="30%">
									<select class="form-control input-sm" name="alertRating" id="alertRating">
										<option value="1">Low</option>
										<option value="2">Medium</option>
										<option value="3">High</option>
									</select> 
								</td>
							</tr>
							<tr id = "customerFields">
								<td width="15%">Account No
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="accountNo" name="accountNo"/>
										<span class="input-group-addon formSearchIcon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('accountNo','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Customer Id</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="customerId" name="customerId"/>
										<span class="input-group-addon formSearchIcon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('customerId','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>	
								</td>
							</tr>
							<tr id = "nonCustomerFields" style="display: none; background-color: #f9f9f9;">
								<td width="15%">Address 1
									<span style="color: red;">*</span>
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
							<tr  style="background-color: white;">
								<td width="15%">Reference Case No
								</td>
								<td width="30%">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="referenceCaseNo" name="referenceCaseNo"/>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Reference Case Date
								</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="referenceCaseDate" name="referenceCaseDate"/>
								</td>
							</tr>
							<!-- <tr  style="background-color: #f9f9f9;">
								<td width="15%">Repeat SAR
								</td>
								<td width="30%">
									<select class="form-control " id="repeatSAR" name="repeatSAR">
										<option value="">Select an option</option>
										<option value="YES">Yes</option>
										<option value="NO">No</option>
									</select>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Source of Internal SAR
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<textarea class="form-control input-sm " id="sourceOfInternalSAR" name="sourceOfInternalSAR"></textarea>
								</td>
							</tr> -->
							<!-- <tr id = "repeatSARRemarksField" style="display: none; background-color: white;">
								<td width="15%">Repeat SAR Remarks
								</td>
								<td width="30%">
									<textarea class="form-control input-sm " id="repeatSARRemarks" name="repeatSARRemarks"></textarea>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">&nbsp;</td>
								<td width="30%">&nbsp;</td>
							</tr> -->
						</table>
					</fieldset>
			</div>
			<div class="panelSearchForm reasonForSuspicion" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Reason For Suspicion</legend>
					
						<table class="table reasonForSuspicionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="25%">Scenario Type</td>
								<td width="75%">
									<select class="form-control " id="scenarioType${UNQID}" name="scenarioType">
										<c:forEach var="SUSPICIONSCENARIOS" items="${SUSPICIONSCENARIOS}">
											<option value="${SUSPICIONSCENARIOS.key}">${SUSPICIONSCENARIOS.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							
							<tr>
								<td width="25%">Type of Suspicion</td>
								<td width="75%">
									<select class="form-control " id="typeOfSuspicion${UNQID}" name="typeOfSuspicion">
										<option>Select</option>
									</select>
								</td>
							</tr>
							<tr>
								<td width="25%">Reason for Suspicion
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
				<input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Submit"/>
				<input type="button" class="btn btn-success btn-sm" id="attachViewEvidence${UNQID}" name="Attach/View Evidence" value="Attach/View Evidence"/>
				<input type="reset" class="btn btn-danger btn-sm" id="clearRaiseSuspicionForm${UNQID}" name="Clear" value="Clear"/>
				</div>
		</div>
	</form>
	</div>
</div>
</div>	