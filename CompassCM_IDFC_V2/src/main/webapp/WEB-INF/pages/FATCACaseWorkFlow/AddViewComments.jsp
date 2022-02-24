<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>

<%@ page language="java" %>
<%@ page import ="java.io.IOException" %>
<%@ page import ="java.util.*" %>
<%
// System.out.println("Loading page : AddViewComments");
String THEMEFILENAME = session.getAttribute("THEMEFILENAME") == null ? System.getProperty("THEMEFILENAME"):session.getAttribute("THEMEFILENAME").toString();
String THEMECOLORNAME = session.getAttribute("THEMECOLORNAME") == null ? System.getProperty("THEMECOLORNAME"):session.getAttribute("THEMECOLORNAME").toString();     
String contextPath = request.getContextPath()==null?"":request.getContextPath();

String LOGGEDUSER = (request.getAttribute("LOGGEDUSER") == null ? "AMLUser":request.getAttribute("LOGGEDUSER").toString());
String LOGGED_USER_REGION = request.getAttribute("LOGGED_USER_REGION") == null ? "India":request.getAttribute("LOGGED_USER_REGION").toString();
String groupCode = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":(String)request.getSession(false).getAttribute("CURRENTROLE");

Map<String, Object> resultData = new HashMap<String, Object>();
resultData = (HashMap<String, Object>)request.getAttribute("CASECOMMENTDETAILS");

String CaseNos = request.getAttribute("CaseNos").toString();
String l_strCaseStatus = request.getAttribute("CaseStatus") == null ? "-1":(String)request.getAttribute("CaseStatus");
// System.out.println("l_strCaseStatus:  "+l_strCaseStatus);
String l_strUpdateMessage = resultData.get("updateMessage") == null ? "":(String)resultData.get("updateMessage"); 

String l_strAlertNo = request.getAttribute("CaseNos").toString(); // request.getParameter("AlertNo");
// String l_strFlagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
String l_strFlagType = request.getAttribute("FlagType") == null ? "N":request.getAttribute("FlagType").toString();
String l_strActionType = request.getAttribute("ActionType") == null ? "":request.getAttribute("ActionType").toString(); 

/*
System.out.println("LOGGEDUSER:  "+LOGGEDUSER);
System.out.println("LOGGED_USER_REGION:  "+LOGGED_USER_REGION);
System.out.println("groupCode:  "+groupCode);
*/

String caseCustomerId = resultData.get("CUSTOMERID") == null ? "":(String)resultData.get("CUSTOMERID");
String caseAcctReviewedDate = resultData.get("CASEACCTREVIEWEDDATE") == null ? "":(String)resultData.get("CASEACCTREVIEWEDDATE");

int hierarchyCode = 3;
String l_strUserDisabled = ""; 
String l_strAMLUserDisabled = ""; 
String l_strAMLOUSERDisabled = "";
String l_strMLROUSERDisabled = "";

String l_strUserCodes = (String)resultData.get("USERCODE"); 
String l_strAMLUserCode = (String)resultData.get("AMLUSERCODE"); 
String l_strAMLOUSERCODE = (String)resultData.get("AMLOUSERCODE");
String l_strMLROUSERCode = (String)resultData.get("MLROUSERCODE");
String l_strUserComments = (String)resultData.get("USERCOMMENTS");
String l_strAMLUserComments = (String)resultData.get("AMLUSERCOMMENTS");
String l_strAMLUserBRComments = resultData.get("AMLUSER_BRCOMMENTS") == null ? "":(String)resultData.get("AMLUSER_BRCOMMENTS");
String l_strAMLOComments = (String)resultData.get("AMLOCOMMENTS");
String l_strMLROCComments = (String)resultData.get("MLROCOMMENTS");

String l_strUserReasonCode = (String)resultData.get("USERREASONCODE");
String l_strAMLUserReasonCode = (String)resultData.get("AMLUSERREASONCODE");
String l_strAMLUserBRReason = resultData.get("AMLUSER_BRREASONCODE") == null ? "":(String)resultData.get("AMLUSER_BRREASONCODE");
String l_strAMLORemovalReason = (String)resultData.get("AMLOREMOVALREASONCODE");
String l_strAMLOOUTCOMEINDICATOR = (String)resultData.get("AMLOOUTCOMEINDICATOR");
String l_strAMLOHIGHRISKREASONCODE = (String)resultData.get("AMLOHIGHRISKREASONCODE");
String l_strMLRORemovalReason = (String)resultData.get("MLROREMOVALREASONCODE");
String l_strMLROOutcomeIndicator = (String)resultData.get("MLROOUTCOMEINDICATOR");
String l_strMLROHighRiskReasonCode = (String)resultData.get("MLROHIGHRISKREASONCODE");

String l_strUserTimeStamp = (String)resultData.get("USERTIMESTAMP");
String l_strAMLUserTimeStamp = (String)resultData.get("AMLUSERTIMESTAMP");
String l_strAMLUserBRTime = resultData.get("AMLUSER_BRTIMESTAMP") == null ? "":(String)resultData.get("AMLUSER_BRTIMESTAMP");
String l_strAMLOTIMESTAMP = (String)resultData.get("AMLOTIMESTAMP");
String l_strMLROTimeStamp = (String)resultData.get("MLROTIMESTAMP");

String l_strBranchUserCode = resultData.get("USERASSIGNEE_CODE") == null ? "":(String)resultData.get("USERASSIGNEE_CODE"); 
String l_strBranchUserComments = resultData.get("USERASSIGNEE_COMMENTS") == null ? "":(String)resultData.get("USERASSIGNEE_COMMENTS");
String l_strBranchUserTimeStamp = resultData.get("USERASSIGNEE_DATE") == null ? "":(String)resultData.get("USERASSIGNEE_DATE");

String l_strAcctReviewDate = (String)resultData.get("ACCOUNTREVIEWEDDATE");
String l_strUSERAcctReviewDate = resultData.get("USER_ACCOUNTREVIEWEDDATE") == null ? caseAcctReviewedDate:(String)resultData.get("USER_ACCOUNTREVIEWEDDATE");
String l_strAMLUserAcctReviewDate = resultData.get("AMLUSER_ACCOUNTREVIEWEDDATE") == null ? caseAcctReviewedDate:(String)resultData.get("AMLUSER_ACCOUNTREVIEWEDDATE");
String l_strAMLUserBRReviewDate = resultData.get("AMLUSER_BRACCOUNTREVIEWEDDATE") == null ? caseAcctReviewedDate:(String)resultData.get("AMLUSER_BRACCOUNTREVIEWEDDATE");
String l_strAMLOAcctReviewDate = resultData.get("AMLO_ACCOUNTREVIEWEDDATE") == null ? caseAcctReviewedDate:(String)resultData.get("AMLO_ACCOUNTREVIEWEDDATE");
String l_strMLROAcctReviewDate = resultData.get("MLRO_ACCOUNTREVIEWEDDATE") == null ? caseAcctReviewedDate:(String)resultData.get("MLRO_ACCOUNTREVIEWEDDATE");

String l_strRegenrate_Flag          = resultData.get("REGENRATE_FLAG") == null ? "N":(String)resultData.get("REGENRATE_FLAG");
String l_strRegenrate_RefCaseNo     = (String)resultData.get("REGENRATE_REFCASENO");
String l_strRegenrate_MLROCode      = (String)resultData.get("REGENRATE_MLROCODE");
String l_strRegenrate_MLROComments  = (String)resultData.get("REGENRATE_MLROCOMMENTS");
String l_strRegenrate_MLROTimestamp = (String)resultData.get("REGENRATE_MLROTIMESTAMP");

if(groupCode.equalsIgnoreCase("ROLE_USER") || groupCode.equalsIgnoreCase("ROLE_FATCARMUSER") || groupCode.equalsIgnoreCase("USER")){
	hierarchyCode = 4;
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLUSER") || groupCode.equalsIgnoreCase("ROLE_FATCAUSER") || groupCode.equalsIgnoreCase("AMLUSER")){
	hierarchyCode = 3;
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLO") || groupCode.equalsIgnoreCase("ROLE_FATCAOFFICER") || groupCode.equalsIgnoreCase("AMLO")){
	hierarchyCode = 2;
}
else {
	hierarchyCode = 1;
}

// System.out.println("hierarchyCode: "+hierarchyCode);

if(hierarchyCode == 4)
{
	l_strUserCodes = LOGGEDUSER;
	//l_strAMLUserDisabled = "disabled";
}
if(hierarchyCode == 3)
{
	l_strAMLUserCode = LOGGEDUSER;
	l_strUserDisabled = "disabled";
}
if(hierarchyCode == 2)
{
	l_strAMLOUSERCODE = LOGGEDUSER;
	l_strUserDisabled = "disabled";
	l_strAMLUserDisabled = "disabled";
}
if(hierarchyCode == 1)
{
	l_strMLROUSERCode = LOGGEDUSER;
	l_strUserDisabled = "disabled";
	l_strAMLUserDisabled = "disabled";
	l_strAMLOUSERDisabled = "disabled";
}
if(!l_strFlagType.equals("Y"))
{
	l_strUserDisabled = "disabled";
	l_strAMLUserDisabled = "disabled";
	l_strAMLOUSERDisabled = "disabled";
	l_strMLROUSERDisabled = "disabled";
}

%>
<HTML>
<Title>Update Comments</Title>
<style>
.menuButtonC{ background: #4B5E78; border-style: groove; border-width:2px;border-color:#ffffff; color:#FFFFFF; text-align: center; white-space: nowrap; font-weight: bold;}
</style>

  <style type="text/css">
	#userAcctReviewedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#amlUserBrnRsedAcctReviewedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#amlUserAcctReviewedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#amloAcctReviewedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#mlroAcctReviewedDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
  </style>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#userAcctReviewedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		 });
		$( "#amlUserBrnRsedAcctReviewedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		 });
		$( "#amlUserAcctReviewedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		 });
		$( "#amloAcctReviewedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		 });
		$( "#mlroAcctReviewedDate" ).datepicker({
			 dateFormat : "dd/mm/yy"
		});
		
		
	});
</script>



<script>

function checkDate(dateToCheck){
if(dateToCheck == '' || dateToCheck == 'null'){
   alert('please enter the account reviewed date.');
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
			alert("Date should be less than sysdate");
			return false;					
		}
	}else{
		alert("Date format is wrong");
		return false;
	}
}else{
	alert("Date format is wrong");
	return false;
}
}

function submitAjaxForm(){
	var parentFormId = '<%=(String) request.getAttribute("parentFormId")%>';
	var formObj = $("#saveCommentForm");
	var action = $(formObj).attr("action");
	var formData = (formObj).serialize();
	var l_strAlertNo = '<%=l_strAlertNo.trim() %>';
	var region = '<%= LOGGED_USER_REGION %>';
	$.ajax({
		url :  action,
		cache : false,
		type : 'POST',
		data : formData,
		success : function(response){
			// alert(response.updateMessage);
			var caseStatus = response.CASESTATUS;
			// alert((caseStatus == 11)+"   "+(region == "India"));
			
			$("#"+parentFormId).submit();
			$("#compassCaseWorkFlowGenericModal").modal("hide");
			$(".compass-tab-content").find("div.active").find("form").submit();
			
			if((caseStatus == 19) || (caseStatus == 6) || (caseStatus == 8) || (caseStatus == 11)){
				if(region == "India"){
				//	alert('${pageContext.request.contextPath}/getINDSTRReport?l_strAlertNo='+l_strAlertNo+'&canUpdated=Y&canExported=N');
				//	window.open('${pageContext.request.contextPath}/getINDSTRReport?l_strAlertNo='+l_strAlertNo+'&canUpdated=Y&canExported=N','ARF_IndianSTR','top=50, height=650,width=900, scrollbars=yes,toolbar=yes,resizable=yes ');
				//	window.open('${pageContext.request.contextPath}/index','ARF_IndianSTR','top=50, height=650,width=900, scrollbars=yes,toolbar=yes,resizable=yes ');
				}
			}
		},
		error : function(a,b,c){
			alert("Something went wrong"+a+b+c);
		}
	});
}

function closeModal(){
	$("#compassCaseWorkFlowGenericModal").modal("hide");
}


function saveComments()
{
   var l_strAlertNo = "<%=l_strAlertNo%>";
   var flagType = "<%=l_strFlagType%>";
   var Comments = "";
   var userCode = "<%=LOGGEDUSER%>";
   var hierarchyCode = "<%=hierarchyCode%>";
   var FraudIndicator = "";
   var RemovalReason = "";
   var OutcomeIndicator = "";
   var HighRiskReasonCode = "";
   var AddedToFalsePositive = "N";
   var LastReviewedDate = "";
   //var Comments = "";
   //var Comments = "";
   if(hierarchyCode == 1 )
   {
	<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("9")) { %>
	RemovalReason = document.UserComments.MLRORemovalReason.value;
	if(document.UserComments.mlroAddToFalsePositive.checked)
		AddedToFalsePositive = "Y";
	<% } else if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("10")) { %>
	OutcomeIndicator = document.UserComments.MLROOutcomeIndicator.value;
	if(OutcomeIndicator == 'FUPR' || mlroOutcomeIndicator == 'FUPA')
		HighRiskReasonCode = document.UserComments.MLROHighRiskReasonCode.value;
	<% } %>

	Comments = document.UserComments.MLROComments.value;
	LastReviewedDate = document.UserComments.mlroAcctReviewedDate.value;
   
   }
   if(hierarchyCode == 2 )
   {
	<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("7")) { %>
	RemovalReason = document.UserComments.AMLORemovalReason.value;
	if(document.UserComments.AMLOAddToFalsePositive.checked)
		AddedToFalsePositive = "Y";
	<% } else if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) { %>
	OutcomeIndicator = document.UserComments.AMLOOUTCOMEINDICATOR.value;
	if(OutcomeIndicator == 'FUPR' || OutcomeIndicator == 'FUPA')
		HighRiskReasonCode = document.UserComments.AMLOHIGHRISKREASONCODE.value;
	<% } %>

	Comments = document.UserComments.AMLOCOMMENTS.value;
	LastReviewedDate = document.UserComments.amloAcctReviewedDate.value;
   }
   if(hierarchyCode == 3 )
   {
	FraudIndicator = document.UserComments.FraudIndicator.value;
	if(FraudIndicator == 'PNEF'){
	if(document.UserComments.amlUserAddToFalsePositive.checked)
		AddedToFalsePositive = "Y";
	}
	Comments = document.UserComments.AMLUserComments.value;
	
	LastReviewedDate = document.UserComments.amlUserAcctReviewedDate.value;
   }
   if(hierarchyCode == 4 )
   {
	FraudIndicator = document.UserComments.UserFraudIndicator.value;
	if(FraudIndicator == 'PNEF'){
	if(document.UserComments.UserAddToFalsePositive.checked)
		AddedToFalsePositive = "Y";
	}
	Comments = document.UserComments.UsersComments.value;
	LastReviewedDate = document.UserComments.userAcctReviewedDate.value;
   }
   //window.opener.l_strAMLComments = Comments;	

   var l_strCaseStatus = '<%= l_strCaseStatus %>';
   // document.form1.AlertNo.value=l_strAlertNo;
   document.form1.FlagType.value=flagType;
   document.form1.UserCode.value=userCode;
   document.form1.Comments.value=Comments;
   document.form1.FraudIndicator.value = FraudIndicator;
   document.form1.RemovalReason.value = RemovalReason;
   document.form1.OutcomeIndicator.value = OutcomeIndicator;
   document.form1.HighRiskReasonCode.value = HighRiskReasonCode;
   document.form1.AddedToFalsePositive.value = AddedToFalsePositive;
   document.form1.LastReviewedDate.value = LastReviewedDate;
   document.form1.CaseStatus.value=l_strCaseStatus;
   document.form1.actionType.value="saveComments";
   /*
   var reg = /^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/g;
   var dateObj = new Date(LastReviewedDate);
   var mm = dateObj.getMonth()+1;
   var strDate = new Date(dateObj.getDate()+"/"+mm+"/"+dateObj.getFullYear());
   var currDateObj = new Date();
   if(!reg.test(LastReviewedDate) || strDate > currDateObj){
	  alert('please enter a valid date');
	return false;
   }
   else */
   if(!checkDate(LastReviewedDate)){
	  return false;
   }
   else if(Comments == "")
   {
   alert('Please enter comments');
   return false;
   }
   else if(LastReviewedDate == "" || LastReviewedDate == "null")
   {
   alert('Please enter last reviewed date');
   return false;
   }
   else
   {
   //document.form1.submit();
   submitAjaxForm();
   }
}

function updateComments()
{
	<% if(l_strActionType.equalsIgnoreCase("saveComments")) { %>
    // alert('Comments Updated');
    alert('<%= l_strUpdateMessage %>');

	window.opener.location.reload();
	
	<% if(l_strCaseStatus.equals("19") || l_strCaseStatus.equals("6") || l_strCaseStatus.equals("8")  || l_strCaseStatus.equals("10")) { %>
	var l_strAlertNo = '<%=l_strAlertNo.trim() %>';
	var region = '<%= LOGGED_USER_REGION %>';
	if(region == 'India')
	{
	<% if(l_strCaseStatus.equals("19") || l_strCaseStatus.equals("6")  || l_strCaseStatus.equals("8")  || l_strCaseStatus.equals("10") ) { %>
	window.open('${pageContext.request.contextPath}/getINDSTRReport?l_strAlertNo='+l_strAlertNo+'&canUpdated=Y&canExported=N','ARF_IndianSTR','top=50, height=650,width=900, scrollbars=yes,toolbar=yes,resizable=yes ');
	<% } else if(l_strCaseStatus.equals("6") || l_strCaseStatus.equals("8") || l_strCaseStatus.equals("10") ) { %>
	window.open('${pageContext.request.contextPath}/getINDSTRReport?l_strAlertNo='+l_strAlertNo+'&canUpdated=Y&canExported=Y','ARF_IndianSTR','top=50, height=650,width=900, scrollbars=yes,toolbar=yes,resizable=yes ');
	<% } %>
	}
	<% } %>
	window.close();
    <% } %>
}

function changeAMLOValues(selectName)
{
var value = selectName.value;
if(value == 'FUPR' || value == 'FUPA')
{
	//document.UserComments.AMLOHighRiskReasonCode.disabled=false;
	td_AMLOHIGHRISKREASONCODE.style.display = '';
}
else
{
	//document.UserComments.AMLOHighRiskReasonCode.disabled=true;
	td_AMLOHIGHRISKREASONCODE.style.display = 'none';
}
}

function changeMLROValues(selectName)
{
var value = selectName.value;
if(value == 'FUPR' || value == 'FUPA')
{
	//document.UserComments.AMLOHighRiskReasonCode.disabled=false;
	td_MLROHighRiskReasonCode.style.display = '';
}
else
{
	//document.UserComments.AMLOHighRiskReasonCode.disabled=true;
	td_MLROHighRiskReasonCode.style.display = 'none';
}
}
function setValues()
{
<% if(l_strUserReasonCode != null && !l_strUserReasonCode.trim().equalsIgnoreCase("")) { %>
	document.UserComments.UserFraudIndicator.value = '<%= l_strUserReasonCode %>';
<% } if(l_strAMLUserBRReason != null && !l_strAMLUserBRReason.trim().equalsIgnoreCase("")) { %>
	document.UserComments.BRFraudIndicator.value = '<%= l_strAMLUserBRReason %>';
<% } if(l_strAMLUserReasonCode != null && !l_strAMLUserReasonCode.trim().equalsIgnoreCase("")) { %>
	document.UserComments.FraudIndicator.value = '<%= l_strAMLUserReasonCode %>';
<% } if(l_strAMLORemovalReason != null && !l_strAMLORemovalReason.trim().equalsIgnoreCase("")) { %>
	document.UserComments.AMLORemovalReason.value = '<%= l_strAMLORemovalReason %>';
<% } if(l_strAMLOOUTCOMEINDICATOR != null && !l_strAMLOOUTCOMEINDICATOR.trim().equalsIgnoreCase("")) { %>
	document.UserComments.AMLOOUTCOMEINDICATOR.value = '<%= l_strAMLOOUTCOMEINDICATOR %>';
<% } if(l_strAMLOHIGHRISKREASONCODE != null && !l_strAMLOHIGHRISKREASONCODE.trim().equalsIgnoreCase("")) { %>
	td_AMLOHIGHRISKREASONCODE.style.display = '';
	document.UserComments.AMLOHIGHRISKREASONCODE.value = '<%= l_strAMLOHIGHRISKREASONCODE %>';
<% } if(l_strMLRORemovalReason != null && !l_strMLRORemovalReason.trim().equalsIgnoreCase("")) { %>
	document.UserComments.MLRORemovalReason.value = '<%= l_strMLRORemovalReason %>';
<% } if(l_strMLROOutcomeIndicator != null && !l_strMLROOutcomeIndicator.trim().equalsIgnoreCase("")) { %>
	document.UserComments.MLROOutcomeIndicator.value = '<%= l_strMLROOutcomeIndicator %>';
<% } if(l_strMLROHighRiskReasonCode != null && !l_strMLROHighRiskReasonCode.trim().equalsIgnoreCase("")) { %>
	td_MLROHighRiskReasonCode.style.display = '';
	document.UserComments.MLROHighRiskReasonCode.value = '<%= l_strMLROHighRiskReasonCode %>';
<% } %>
}

function addSBUFDDDetails()
{
var alertNo = '<%= l_strAlertNo %>';
var flagType = 'Y';
var userCode = '<%= LOGGEDUSER %>';
var caseStatus = '<%= l_strCaseStatus %>';
var hierarchyCode = 

window.open("${pageContext.request.contextPath}/CaseManager/AddSBUFDDDetails.jsp?AlertNo="+alertNo+"&FlagType="+flagType+"&userCode="+userCode+"&CaseStatus="+caseStatus+"&hierarchyCode=2",'OfficeFDDForms')
}

function addMLROFDDDetails()
{
var alertNo = '<%= l_strAlertNo %>';
var flagType = 'Y';
var userCode = '<%= LOGGEDUSER %>';
var caseStatus = '<%= l_strCaseStatus %>';

window.open("${pageContext.request.contextPath}/CaseManager/AddMLROFDDDetails.jsp?AlertNo="+alertNo+"&FlagType="+flagType+"&userCode="+userCode+"&CaseStatus="+caseStatus+"&hierarchyCode=1",'ManagerFDDForms')
}

function AddToUserFalsePositive()
{
if(document.UserComments.UserAddToFalsePositive.checked)
var con = confirm('Are you sure to add this account in the false positive list');
}

function AddToAMLUserFalsePositive()
{
if(document.UserComments.amlUserAddToFalsePositive.checked)
var con = confirm('Are you sure to add this account in the false positive list');
}

function AddToAMLOFalsePositive()
{
if(document.UserComments.AMLOAddToFalsePositive.checked)
var con = confirm('Are you sure to add this account in the false positive list');
}

function AddToMLROFalsePositive()
{
if(document.UserComments.mlroAddToFalsePositive.checked)
var con = confirm('Are you sure to add this account in the false positive list');
}

function updateFDDAccountDetails()
{
var alertNo = '<%= l_strAlertNo %>';
var flagType = 'Y';
var userCode = '<%= LOGGEDUSER %>';
var caseStatus = '<%= l_strCaseStatus %>';

var mywin = window.open("${pageContext.request.contextPath}/CaseManager/AddAccountToFDD.jsp?AlertNo="+alertNo+"&FlagType="+flagType+"&userCode="+userCode+"&CaseStatus="+caseStatus+"&hierarchyCode=1",'','height=320,width=850,resizable=Yes');
mywin.moveTo(10,62);
}

function updateFDDTransactionDetails()
{
var alertNo = '<%= l_strAlertNo %>';
var flagType = 'Y';
var userCode = '<%= LOGGEDUSER %>';
var caseStatus = '<%= l_strCaseStatus %>';

var mywin = window.open("${pageContext.request.contextPath}/CaseManager/AddTransactionToFDD.jsp?AlertNo="+alertNo+"&FlagType="+flagType+"&userCode="+userCode+"&CaseStatus="+caseStatus+"&hierarchyCode=1",'','height=320,width=850,resizable=Yes');
mywin.moveTo(10,62);
}

function openClear()
{
   document.getElementById('txtFromDate').value = "";
   document.getElementById('txtToDate').value = "";
   document.getElementById('txtAlertCode').value = "";
   document.getElementById('txtBranchCode').value = "";
   document.getElementById('txtAccountNo').value = "";
   document.getElementById('txtCustomerId').value = "";
}
</script>
<BODY onLoad= "setValues();updateComments();" >
<FORM METHOD='POST' name='UserComments' >
<% if(hierarchyCode <=4 && l_strRegenrate_Flag.equals("N")) { %>
<table>
<% if(l_strBranchUserCode != null && !l_strBranchUserCode.equals("")) { %>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strBranchUserCode == null ? "":l_strBranchUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strBranchUserTimeStamp == null ? "":l_strBranchUserTimeStamp%></td></tr></table>
<table>
<tr><textarea rows=3 cols=140 name='BranchUserComments' disabled><%=l_strBranchUserComments == null ? "":l_strBranchUserComments%></textarea>	</tr>
</table>
<% } %>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strUserCodes == null ? "":l_strUserCodes%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strUserTimeStamp == null ? "":l_strUserTimeStamp%></td>
<td>
<label>AccountReviewedDate<font color="red"> * </font>:</label>&nbsp;
<input type="text" name="userAcctReviewedDate" <%=l_strUserDisabled%> value="<%= l_strUSERAcctReviewDate %>" class="topOpenTextBox" size=12 maxlength=12 id="userAcctReviewedDate"/> </b><font color="yellow">(dd/mm/yyyy)</font>
</td>
</tr></table>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">FATCA/CRS Indicator&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
<select name='UserFraudIndicator' class="txt" <%=l_strUserDisabled%>>
<option value='PFPM'>Documentary Evidence, Received but not attached</option>
<option value='PFAP'>Documentary Evidence, Received and attached </option>
<option value='PFND'>Documentary Evidence, Received and mark as US/Other Accounts</option>
<option value='PFCI'>Documentary Evidence, Not Received and mark as Undocumented Accounts</option>
<option value='PFTP'>Documentary Evidence, Received but mark as Undocumented Accounts</option>
<option value='UDAM'>Mark as Undocumented Accounts</option>
<option value='OTHERS'>Others</option>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("2")) { %>
<option value='PNEF'>Potentially Not FATCA/CRS Customers</option>
<% } %>
</select>
</td>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("2")) { %>
<td>&nbsp;&nbsp;<input type="checkbox" name="UserAddToFalsePositive" onclick="AddToUserFalsePositive()" <%=l_strUserDisabled%>><b><font face="Arial" color="#ED3237" size="2">&nbsp;Add To False Positive List</font></td>
<% } %>
</tr>
</table>
<table>
<tr><textarea rows=5 cols=140 name='UsersComments' <%=l_strUserDisabled%>><%=l_strUserComments == null ? "":l_strUserComments%></textarea>	</tr>
</table>
</table>
<% } if(hierarchyCode <=4 && l_strRegenrate_Flag.equals("Y")) { %>
<table>
<% if(l_strRegenrate_MLROCode != null && !l_strRegenrate_MLROCode.equals("")) { %>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strRegenrate_MLROCode == null ? "":l_strRegenrate_MLROCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strRegenrate_MLROTimestamp == null ? "":l_strRegenrate_MLROTimestamp%></td></tr></table>
<table>
<tr><textarea rows=3 cols=140 name='RegenrateMLROComments' disabled><%=l_strRegenrate_MLROComments == null ? "":l_strRegenrate_MLROComments%></textarea>	</tr>
</table>
<% } } if(hierarchyCode <=3 ) { %>
<% if(l_strAMLUserBRTime != null && !l_strAMLUserBRTime.equals("")) { %>
<table>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062"><td colspan=2 align = "center" ><font color="red">Raised To Branch Comment</font></td></tr>
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strAMLUserCode == null ? "":l_strAMLUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLUserBRTime == null ? "":l_strAMLUserBRTime%></td>
<td>
<label>AccountReviewedDate<font color="red"> * </font>:</label>&nbsp;
<input type="text" name="amlUserBRAcctReviewedDate" disabled value="<%= l_strAMLUserBRReviewDate %>" class="topOpenTextBox" size=12 maxlength=12 id="amlUserBRAcctReviewedDate"/> </b><font color="yellow">(dd/mm/yyyy)</font>
</td>
</tr></table>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">FATCA/CRS Indicator&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
<select name='BRFraudIndicator' class="txt" disabled>
<option value='PFPM'>Documentary Evidence, Received but not attached</option>
<option value='PFAP'>Documentary Evidence, Received and attached </option>
<option value='PFND'>Documentary Evidence, Received and mark as US/Other Accounts</option>
<option value='PFCI'>Documentary Evidence, Not Received and mark as Undocumented Accounts</option>
<option value='PFTP'>Documentary Evidence, Received but mark as Undocumented Accounts</option>
<option value='UDAM'>Mark as Undocumented Accounts</option>
<option value='OTHERS'>Others</option>
<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
<option value='PNEF'>Potentially Not FATCA/CRS Customers</option>
<% } %>
</select>
</td>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("5")) { %>
<td>&nbsp;&nbsp;<input type="checkbox" name="amlUserBRAddToFalsePositive" onclick="AddToAMLUserFalsePositive()" disabled><b><font face="Arial" color="#ED3237" size="2">&nbsp;Add To False Positive List</font></td>
<% } %>
</tr>
</table>
<table>
<tr><textarea rows=5 cols=140 name='AMLUserBRComments' disabled><%=l_strAMLUserBRComments == null ? "":l_strAMLUserBRComments%></textarea>	</tr>
</table>
</table>
<% } %>
<table>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strAMLUserCode == null ? "":l_strAMLUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLUserTimeStamp == null ? "":l_strAMLUserTimeStamp%></td>
<td>
<label>AccountReviewedDate<font color="red"> * </font>:</label>&nbsp;
<input type="text" name="amlUserAcctReviewedDate" <%=l_strAMLUserDisabled%> value="<%= l_strAMLUserAcctReviewDate %>" class="topOpenTextBox" size=12 maxlength=12 id="amlUserAcctReviewedDate"/> </b><font color="yellow">(dd/mm/yyyy)</font>
</td>
</tr></table>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">FATCA/CRS Indicator&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
<select name='FraudIndicator' class="txt" <%=l_strAMLUserDisabled%>>
<option value='PFPM'>Documentary Evidence, Received but not attached</option>
<option value='PFAP'>Documentary Evidence, Received and attached </option>
<option value='PFND'>Documentary Evidence, Received and mark as US/Other Accounts</option>
<option value='PFCI'>Documentary Evidence, Not Received and mark as Undocumented Accounts</option>
<option value='PFTP'>Documentary Evidence, Received but mark as Undocumented Accounts</option>
<option value='UDAM'>Mark as Undocumented Accounts</option>
<option value='OTHERS'>Others</option>
<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
<option value='PNEF'>Potentially Not FATCA/CRS Customers</option>
<% } %>
</select>
</td>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("5")) { %>
<td>&nbsp;&nbsp;<input type="checkbox" name="amlUserAddToFalsePositive" onclick="AddToAMLUserFalsePositive()" <%=l_strAMLUserDisabled%>><b><font face="Arial" color="#ED3237" size="2">&nbsp;Add To False Positive List</font></td>
<% } %>
</tr>
</table>
<table>
<tr><textarea rows=5 cols=140 name='AMLUserComments' <%=l_strAMLUserDisabled%>><%=l_strAMLUserComments == null ? "":l_strAMLUserComments%></textarea>	</tr>
</table>
</table>
<% } if(hierarchyCode <=2 ) { %>
<table>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strAMLOUSERCODE == null ? "":l_strAMLOUSERCODE%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLOTIMESTAMP == null ? "":l_strAMLOTIMESTAMP%></td>
<td>
<label>AccountReviewedDate<font color="red"> * </font>:</label>&nbsp;
<input type="text" name="amloAcctReviewedDate" <%=l_strAMLOUSERDisabled%> value="<%= l_strAMLOAcctReviewDate %>" class="topOpenTextBox" size=12 maxlength=12 id="amloAcctReviewedDate"/> </b><font color="yellow">(dd/mm/yyyy)</font>
</td>
</tr></table>
<% if((l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("7")) || (l_strAMLORemovalReason != null && !l_strAMLORemovalReason.trim().equalsIgnoreCase("")))  { %>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">Removal Reason&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
<select name='AMLORemovalReason' class="txt" <%=l_strAMLOUSERDisabled%>>
<option value='SBRR1'>Confirmed as non FATCA/CRS Customers</option>
<option value='SBRR4'>False positive</option>
<option value='SBRR5'>Referred in error</option>
<option value='SBRR6'>Potential FATCA/CRS Customers but disproved</option>
<option value='SBRR9'>Potentially Not FATCA/CRS Customers</option>
<option value='OTHERS'>Others</option>
</select>
</td><td></td><td></td><td></td><td></td>
<td>&nbsp;&nbsp;<input type="checkbox" name="AMLOAddToFalsePositive" onclick="AddToAMLOFalsePositive()" <%=l_strAMLOUSERDisabled%>><b><font face="Arial" color="#ED3237" size="2">&nbsp;Add To False Positive List</font></td>
</tr>
</table>
<% } %>
<% if((l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) || (l_strAMLOOUTCOMEINDICATOR != null && !l_strAMLOOUTCOMEINDICATOR.trim().equalsIgnoreCase(""))) { %>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">Outcome Indicator&nbsp;*</font>
<select name='AMLOOUTCOMEINDICATOR' class="txt"  onChange='changeAMLOValues(this)' <%=l_strAMLOUSERDisabled%>>
<option value='FUUA'>FATCA/CRS Status upheld and mark as US/Other Accounts</option>
<option value='FURA'>FATCA/CRS Status upheld and mark as Undocumented Accounts</option>
</select>
</td>
<!--</tr>
</table>
<table><tr>-->
<% } if((l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) || (l_strAMLOHIGHRISKREASONCODE != null && !l_strAMLOHIGHRISKREASONCODE.trim().equalsIgnoreCase(""))) { %>
<td id='td_AMLOHIGHRISKREASONCODE' style='display:true'>
<b><font face="Arial" color="#ED3237" size="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reason Code</font>
<select name='AMLOHIGHRISKREASONCODE' class="txt" <%=l_strAMLOUSERDisabled%>>
<!--<option value='HRA'>Mark As High Risk Accounts</option>-->
<option value='MLA'>Received and verified W8/W9 form</option>
<option value='WAT'>Customer reluctant to share the information</option>
<option value='CPA'>Customer reluctant to share the W8/W9 Form</option>
<option value='TBS'>Received old/wrong W8/W9 Form</option>
<option value='OTHERS'>Others</option>
</select>
</td>
</tr>
</table>
<!--
<table align="center">
<tr align="right">
<td align="right" width="30%"><a href="#1" onClick="updateFDDAccountDetails()" <%=l_strAMLOUSERDisabled%>><font face="Arial" color="#606062" size="2"><b>Update&nbsp;Parties&nbsp;List&nbsp;</font><a></td>
<td align="right" width="30%"><a href="#1" onClick="updateFDDTransactionDetails()" <%=l_strAMLOUSERDisabled%>><font face="Arial" color="#606062" size="2"><b>Update&nbsp;Transactions&nbsp;List&nbsp;</font><a></td>
</tr>
</table>
-->
<% } %>
<table>
<tr><textarea rows=7 cols=140 name='AMLOCOMMENTS' <%=l_strAMLOUSERDisabled%>><%=l_strAMLOComments == null?"":l_strAMLOComments%></textarea>	</tr>
</table>
</table>
<% } if(hierarchyCode <=1 ) { %>
<table>
<table width="100%" bgcolor="#606062">
<tr width="100%" align = "center" bgcolor="#606062">
<td><%=l_strMLROUSERCode == null ? "":l_strMLROUSERCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strMLROTimeStamp == null ? "":l_strMLROTimeStamp%></td>
<td>
<label>AccountReviewedDate<font color="red"> * </font>:</label>&nbsp;
<input type="text" name="mlroAcctReviewedDate" <%=l_strMLROUSERDisabled%> value="<%= l_strMLROAcctReviewDate %>" class="topOpenTextBox" size=12 maxlength=12 id="mlroAcctReviewedDate"/> </b><font color="yellow">(dd/mm/yyyy)</font>
</td>
</tr></table>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("9")) { %>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">Removal Reason&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
<select name='MLRORemovalReason' class="txt" <%=l_strMLROUSERDisabled%>>
<option value='NUPH'>FATCA/CRS status not upheld</option>
<option value='NUPH'>FATCA/CRS status disproved</option>
<option value='SBRR4'>False positive</option>
<option value='SBRR5'>Referred in error</option>
<option value='SBRR6'>Potential FATCA/CRS Customers but disproved</option>
<option value='SBRR9'>Potentially Not FATCA/CRS Customers</option>
<option value='OTHERS'>Others</option>
</select>
</td>
<td>&nbsp;&nbsp;<input type="checkbox" name="mlroAddToFalsePositive" onclick="AddToMLROFalsePositive()" <%=l_strMLROUSERDisabled%>><b><font face="Arial" color="#ED3237" size="2">&nbsp;Add To False Positive List</font></td>
</tr>
</table>
<% } %>
<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("10")) { %>
<table><tr>
<td>
<b><font face="Arial" color="#ED3237" size="3">Outcome Indicator&nbsp;*</font>
<select name='MLROOutcomeIndicator' class="txt"  onChange='changeMLROValues(this)' <%=l_strMLROUSERDisabled%>>
<option value='FUUA'>FATCA/CRS Status upheld and mark as US/Other Accounts</option>
<option value='FURA'>FATCA/CRS Status upheld and mark as Undocumented Accounts</option>
</select>
</td>
<!--</tr>
</table>
<table><tr>-->
<td id='td_MLROHighRiskReasonCode' style='display:true'>
<b><font face="Arial" color="#ED3237" size="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reason Code</font>
<select name='MLROHighRiskReasonCode' class="txt" <%=l_strMLROUSERDisabled%>>
<!--<option value='HRA'>Mark As High Risk Accounts</option>-->
<option value='MLA'>Received and verified W8/W9 form</option>
<option value='WAT'>Customer reluctant to share the information</option>
<option value='CPA'>Customer reluctant to share the W8/W9 Form</option>
<option value='TBS'>Received old/wrong W8/W9 Form</option>
<option value='OTHERS'>Others</option>
</select>
</td>
</tr>
</table>
<!--<table align="center">
<tr align="right">
<td align="right" width="30%"><a href="#1" onClick="updateFDDAccountDetails()" <%=l_strMLROUSERDisabled%>><font face="Arial" color="#606062" size="2"><b>Update&nbsp;Parties&nbsp;List&nbsp;</font><a></td>
<td align="right" width="30%"><a href="#1" onClick="updateFDDTransactionDetails()" <%=l_strMLROUSERDisabled%>><font face="Arial" color="#606062" size="2"><b>Update&nbsp;Transactions&nbsp;List&nbsp;</font><a></td>
</tr>
</table>
-->
<% } %>
<table width="100%" bgcolor="#606062">
<tr><textarea rows=7 cols=140 name='MLROComments' <%=l_strMLROUSERDisabled%>><%=l_strMLROCComments == null ? "":l_strMLROCComments%></textarea></tr>
</tr></table>
</table>
<% } %>
<table>
<tr></tr>
<tr></tr>
<tr align="center">
<td  align="center">
<% if(l_strFlagType.equals("Y")) { %>
<input type='button' name='save' value='Save' class='menuButtonC' OnClick='saveComments();'>
<% } %>
<input type='button' name='close' value='Close' class='menuButtonC' OnClick='closeModal()'></td>
</tr>
</table>
</FORM>
<form name="form1" id="saveCommentForm" METHOD='POST' target='_self' action="${pageContext.request.contextPath}/fatcaCaseWorkFlow/fatcaSaveComments">
<input type="hidden" name="CaseNos" value="<%= CaseNos %>" />
<input type="hidden" name="FlagType" value="" />
<input type="hidden" name="UserCode" value="" />
<input type="hidden" name="Comments" value="" />
<input type="hidden" name="FraudIndicator" value="" />
<input type="hidden" name="RemovalReason" value="" />
<input type="hidden" name="OutcomeIndicator" value="" />
<input type="hidden" name="HighRiskReasonCode" value="" />
<input type="hidden" name="AddedToFalsePositive" value="" />
<input type="hidden" name="LastReviewedDate" value="" />
<input type="hidden" name="CaseStatus" value="" />
<input type="hidden" name="actionType" value="saveComments" />
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
</BODY>
</html>