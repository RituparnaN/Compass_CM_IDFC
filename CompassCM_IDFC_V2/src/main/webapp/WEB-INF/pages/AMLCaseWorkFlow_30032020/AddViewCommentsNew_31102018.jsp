<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ page import ="java.io.IOException" %>
<%@ include file="../tags/tags.jsp"%>    
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();

String LOGGEDUSER = (request.getAttribute("LOGGEDUSER") == null ? "AMLUser":request.getAttribute("LOGGEDUSER").toString());
String LOGGED_USER_REGION = request.getAttribute("LOGGED_USER_REGION") == null ? "India":request.getAttribute("LOGGED_USER_REGION").toString();
String groupCode = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":(String)request.getSession(false).getAttribute("CURRENTROLE");

boolean isTemporaryDisbaled = true; 

Map<String, Object> resultData = new HashMap<String, Object>();
resultData = (HashMap<String, Object>)request.getAttribute("CASECOMMENTDETAILS");

String CaseNos = request.getAttribute("CaseNos").toString();
String l_strCaseStatus = request.getAttribute("CaseStatus") == null ? "-1":(String)request.getAttribute("CaseStatus");
String l_strUpdateMessage = resultData.get("updateMessage") == null ? "":(String)resultData.get("updateMessage"); 

String l_strAlertNo = request.getAttribute("CaseNos").toString(); 
String l_strFlagType = request.getAttribute("FlagType") == null ? "N":request.getAttribute("FlagType").toString();
String l_strActionType = request.getAttribute("ActionType") == null ? "":request.getAttribute("ActionType").toString(); 

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

String l_strUserExitRecommended = resultData.get("USER_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("USER_ISEXITRECOMMENDED");
String l_strAMLUserExitRecommended = resultData.get("AMLUSER_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("AMLUSER_ISEXITRECOMMENDED");
String l_strAMLUserBRExitRecommended = resultData.get("AMLUSERBR_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("AMLUSERBR_ISEXITRECOMMENDED");
String l_strAMLOExitRecommended = resultData.get("AMLO_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("AMLO_ISEXITRECOMMENDED");
String l_strMLROExitRecommended = resultData.get("MLRO_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("MLRO_ISEXITRECOMMENDED");
String l_strAMLRepExitRecommended = resultData.get("AMLREP_ISEXITRECOMMENDED") == null ? "NO":(String)resultData.get("AMLREP_ISEXITRECOMMENDED");

if(groupCode.equalsIgnoreCase("ROLE_USER") || groupCode.equalsIgnoreCase("USER")){
	hierarchyCode = 4;
}
else if(groupCode.equalsIgnoreCase("ROLE_BRANCHUSER") || groupCode.equalsIgnoreCase("BRANCHUSER")){
	hierarchyCode = 4;
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLUSER") || groupCode.equalsIgnoreCase("AMLUSER")){
	hierarchyCode = 3;
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLO") || groupCode.equalsIgnoreCase("AMLO")){
	hierarchyCode = 2;
}
else {
	hierarchyCode = 1;
}

if(hierarchyCode == 4)
{
	l_strUserCodes = LOGGEDUSER;
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

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
 -->
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'compassModuleDetailsSearchTable'+id;
		compassTopFrame.init(id, tableClass, 'dd/mm/yy');
		
		$('.panelSlidingAddViewCommentsBranchUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsBranchUser');
	    });
		
		$('.panelSlidingAddViewCommentsUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsUser');
	    });
		
		$('.panelSlidingAddViewCommentsRegenerateMLRO'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsRegenerateMLRO');
	    });
		
		$('.panelSlidingRaisedToBranch'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelRaisedToBranch');
	    });
		
		$('.panelSlidingAddViewCommentsAMLUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsAMLUser');
	    });
	
		$('.panelSlidingAddViewCommentsAMLO'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsAMLO');
	    });
		
		$('.panelSlidingAddViewCommentsMLRO'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsMLRO');
	    });
		
		
		$("#closeAddViewCommentsModal"+id).click(function(){
			$("#compassCaseWorkFlowGenericModal").modal("hide");
		});
	});
	
	function addToUserFalsePositive()
	{
	if(document.userComments.userAddToFalsePositive.checked)
	var con = confirm('Are you sure to add this account in the false positive list');
	}

	function addToAMLUserFalsePositive()
	{
	if(document.userComments.amlUserAddToFalsePositive.checked)
	var con = confirm('Are you sure to add this account in the false positive list');
	}

	function addToAMLOFalsePositive()
	{
	if(document.userComments.addToAMLOFalsePositive.checked)
	var con = confirm('Are you sure to add this account in the false positive list');
	}

	function addToMLROFalsePositive()
	{
	if(document.userComments.mlroAddToFalsePositive.checked)
	var con = confirm('Are you sure to add this account in the false positive list');
	}
	
	function changeAMLOValues(selectName)
	{
	var value = selectName.value;
	//alert(value);
	if(value == "FUPR")
	{
		//document.userComments.amloHighRiskReasonCode. false;
		//document.userComments.amloHighRiskReasonCode.style.display = 'block';
		$("#div_AMLOHIGHRISKREASONCODE").css("display", "block");
		//alert($("#div_AMLOHIGHRISKREASONCODE").html());
	}
	else
	{
		//document.userComments.amloHighRiskReasonCode. true;
		//document.userComments.amloHighRiskReasonCode.style.display = 'none';
		$("#div_AMLOHIGHRISKREASONCODE").css("display", "none");
	}
	}

	function changeMLROValues(selectName)
	{
	var value = selectName.value;
	if(value == "FUPR")
	{
		//document.userComments.amloHighRiskReasonCode. false;
		//document.userComments.div_MLROHighRiskReasonCode.style.display = 'block';
		$("#div_MLROHighRiskReasonCode").css("display", "block");

	}
	else
	{
		//document.userComments.amloHighRiskReasonCode. true;
		//document.userComments.div_MLROHighRiskReasonCode.style.display = 'none';
		$("#div_MLROHighRiskReasonCode").css("display", "none");

	}
	}
	
	function checkDate(dateToCheck){
		if(dateToCheck == '' || dateToCheck == 'null'){
		   alert('Please enter the account reviewed date.');
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
	
	
	function setValues()
	{
	<% if(!isTemporaryDisbaled && l_strUserReasonCode != null && !l_strUserReasonCode.trim().equalsIgnoreCase("")) { %>
		document.userComments.userFraudIndicator.value = '<%= l_strUserReasonCode %>';
	<% } if(!isTemporaryDisbaled && l_strAMLUserBRReason != null && !l_strAMLUserBRReason.trim().equalsIgnoreCase("")) { %>
		document.userComments.bRFraudIndicator.value = '<%= l_strAMLUserBRReason %>';
	<% } if(!isTemporaryDisbaled && l_strAMLUserReasonCode != null && !l_strAMLUserReasonCode.trim().equalsIgnoreCase("")) { %>
		document.userComments.fraudIndicator.value = '<%= l_strAMLUserReasonCode %>';
	<% } if(!isTemporaryDisbaled && l_strAMLORemovalReason != null && !l_strAMLORemovalReason.trim().equalsIgnoreCase("")) { %>
		document.userComments.amloRemovalReason.value = '<%= l_strAMLORemovalReason %>';
	<% } if(!isTemporaryDisbaled && l_strAMLOOUTCOMEINDICATOR != null && !l_strAMLOOUTCOMEINDICATOR.trim().equalsIgnoreCase("")) { %>
		document.userComments.amloOutcomeIndicator.value = '<%= l_strAMLOOUTCOMEINDICATOR %>';
	<% } if(!isTemporaryDisbaled && l_strAMLOHIGHRISKREASONCODE != null && !l_strAMLOHIGHRISKREASONCODE.trim().equalsIgnoreCase("")) { %>
		td_AMLOHIGHRISKREASONCODE.style.display = '';
		document.userComments.amloHighRiskReasonCode.value = '<%= l_strAMLOHIGHRISKREASONCODE %>';
	<% } if(!isTemporaryDisbaled && l_strMLRORemovalReason != null && !l_strMLRORemovalReason.trim().equalsIgnoreCase("")) { %>
		document.userComments.mlroRemovalReason.value = '<%= l_strMLRORemovalReason %>';
	<% } if(!isTemporaryDisbaled && l_strMLROOutcomeIndicator != null && !l_strMLROOutcomeIndicator.trim().equalsIgnoreCase("")) { %>
		document.userComments.mlroOutcomeIndicator.value = '<%= l_strMLROOutcomeIndicator %>';
	<% } if(!isTemporaryDisbaled && l_strMLROHighRiskReasonCode != null && !l_strMLROHighRiskReasonCode.trim().equalsIgnoreCase("")) { %>
		td_MLROHighRiskReasonCode.style.display = '';
		document.userComments.mlroHighRiskReasonCode.value = '<%= l_strMLROHighRiskReasonCode %>';
	<% } if(!isTemporaryDisbaled && l_strMLROExitRecommended != null && !l_strMLROExitRecommended.trim().equalsIgnoreCase("")) { %>
		document.userComments.mlroIsExitRecommended.value = '<%= l_strMLROExitRecommended %>';
	<% } %>
	}
	
	function saveComments()
	{
	   var l_strAlertNo = "<%=l_strAlertNo%>";
	   var flagType = "<%=l_strFlagType%>";
	   var Comments = "";
	   var userCode = "<%=LOGGEDUSER%>";
	   var hierarchyCode = "<%=hierarchyCode%>";
	   var fraudIndicator = "";
	   var RemovalReason = "";
	   var OutcomeIndicator = "";
	   var HighRiskReasonCode = "";
	   var AddedToFalsePositive = "N";
	   var LastReviewedDate = "";
	   var ExitRecommended = "NO";
	   
	   if(hierarchyCode == 1 )
	   {
		<% if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("9")) { %>
		RemovalReason = document.userComments.mlroRemovalReason.value;
		if(document.userComments.mlroAddToFalsePositive.checked)
			AddedToFalsePositive = "Y";
		<% } else if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("10")) { %>
		OutcomeIndicator = document.userComments.mlroOutcomeIndicator.value;
		if(OutcomeIndicator == 'FUPR' || mlroOutcomeIndicator == 'FUPA')
			HighRiskReasonCode = document.userComments.mlroHighRiskReasonCode.value;
		<% } %> 

		Comments = document.userComments.mlroComments.value;
		LastReviewedDate = document.userComments.mlroAcctReviewedDate.value;
		ExitRecommended = document.userComments.mlroIsExitRecommended.value;
	   //alert(ExitRecommended);
	   }
	   if(hierarchyCode == 2 )
	   {
		<% if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("7")) { %>
		RemovalReason = document.userComments.amloRemovalReason.value;
		if(document.userComments.addToAMLOFalsePositive.checked)
			AddedToFalsePositive = "Y";
		<% } else if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) { %>
		OutcomeIndicator = document.userComments.amloOutcomeIndicator.value;
		if(OutcomeIndicator == 'FUPR' || OutcomeIndicator == 'FUPA')
			HighRiskReasonCode = document.userComments.amloHighRiskReasonCode.value;
		<% } %>

		Comments = document.userComments.amloComments.value;
		LastReviewedDate = document.userComments.amloAcctReviewedDate.value;
		ExitRecommended = document.userComments.amloIsExitRecommended.value;
	   }
	   if(hierarchyCode == 3 )
	   {
		<% if(!isTemporaryDisbaled) { %>
		fraudIndicator = document.userComments.fraudIndicator.value;
		if(fraudIndicator == 'PNEF'){
		if(document.userComments.amlUserAddToFalsePositive.checked)
			AddedToFalsePositive = "Y";
		}
		<% } %>
		Comments = document.userComments.amlUserComments.value;
		
		LastReviewedDate = document.userComments.amlUserAcctReviewedDate.value;
		ExitRecommended = document.userComments.amlUserIsExitRecommended.value;
	   }
	  
	   if(hierarchyCode == 4 )
	   {
	   <% if(!isTemporaryDisbaled) { %>
		fraudIndicator = document.userComments.userFraudIndicator.value;
		   
		if(fraudIndicator == 'PNEF'){
		if(document.userComments.userAddToFalsePositive.checked)
			AddedToFalsePositive = "Y";
		}
		<% } %>
		Comments = document.userComments.UserInputComments.value;
		LastReviewedDate = document.userComments.userAcctReviewedDate.value;
		ExitRecommended = document.userComments.userIsExitRecommended.value;
	   }
	   
	   var l_strCaseStatus = '<%= l_strCaseStatus %>';
	   document.form1.FlagType.value=flagType;
	   document.form1.UserCode.value=userCode;
	   document.form1.Comments.value=Comments;
	   document.form1.FraudIndicator.value = fraudIndicator;
	   document.form1.RemovalReason.value = RemovalReason;
	   document.form1.OutcomeIndicator.value = OutcomeIndicator;
	   document.form1.HighRiskReasonCode.value = HighRiskReasonCode;
	   document.form1.AddedToFalsePositive.value = AddedToFalsePositive;
	   document.form1.LastReviewedDate.value = LastReviewedDate;
	   document.form1.CaseStatus.value=l_strCaseStatus;
	   document.form1.ExitRecommended.value = ExitRecommended;
	   document.form1.actionType.value="saveComments";
	   
	   if(!checkDate(LastReviewedDate)){
		  return false;
	   }
	   else if(Comments == "")
	   {
	   alert('Please enter comments.');
	   return false;
	   }
	   else if(LastReviewedDate == "" || LastReviewedDate == "null")
	   {
	   alert('Please enter last reviewed date.');
	   return false;
	   }
	   else
	   {
	   submitAjaxForm();
	   }
	}
	
	function submitAjaxForm(){
		var parentFormId = '<%=(String) request.getAttribute("parentFormId")%>';
		var formObj = $("#saveCommentForm");
		var action = $(formObj).attr("action");
		var formData = (formObj).serialize();
		var l_strAlertNo = '<%=l_strAlertNo.trim() %>';
		var region = '<%= LOGGED_USER_REGION %>';
		//alert(formData);
		$.ajax({
			url :  action,
			cache : false,
			type : 'POST',
			data : formData,
			success : function(response){
				var caseStatus = response.CASESTATUS;
				// alert((caseStatus == 11)+"   "+(region == "India"));
				//alert(l_strAlertNo);
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
	
	function updateComments()
	{
		<% if(l_strActionType.equalsIgnoreCase("saveComments")) { %>
	    //alert('<%= l_strUpdateMessage %>');

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
</script>
<!-- <link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
 -->
</head>

<body onLoad= "setValues();updateComments();">
<form method="POST" name="userComments">
<% if(hierarchyCode <=4 && l_strRegenrate_Flag.equals("N")) { %>
<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
	    <% if(l_strBranchUserCode != null && !l_strBranchUserCode.equals("")) { %>
	    	<div class="card card-primary panel_addViewComments" id= "panelAddViewCommentsBranchUser${UNQID}" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsBranchUser${UNQID} clearfix">			
				<h6 class="card-title pull-${dirL}">
					<%=l_strBranchUserCode == null ? "":l_strBranchUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strBranchUserTimeStamp == null ? "":l_strBranchUserTimeStamp%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Comments</td>
						<td colspan="4">
								<textarea class="form-control input-sm " name="branchUserComments" id="branchUserComments${UNQID}" <%=l_strUserDisabled%>><%=l_strBranchUserComments == null ? "":l_strBranchUserComments%></textarea>
						</td>
						<!-- <td width="25%">
								<textarea class="form-control input-sm " name="branchUserComments" id="branchUserComments${UNQID}" <%=l_strUserDisabled%>><%=l_strBranchUserComments == null ? "":l_strBranchUserComments%></textarea>
						</td>
						<td colspan="3">&nbsp;</td>-->
					</tr>
				</table>
			</div>
			</div>
	    <%} %>
		<div class="card card-primary panel_addViewComments" id= "panelAddViewCommentsUser${UNQID}" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsUser${UNQID} clearfix">			
				<h6 class="card-title pull-${dirL}">
					<%=l_strUserCodes == null ? "":l_strUserCodes%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strUserTimeStamp == null ? "":l_strUserTimeStamp%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Account Reviewed Date</td>
							<td width="25%">
								<input type="text" class="form-control input-sm datepicker" name="userAcctReviewedDate" id="userAcctReviewedDate${UNQID}" value="<%=l_strUSERAcctReviewDate%>" <%=l_strUserDisabled%> style="width:100%"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Exit Recommended</td>
						<td width="25%">
							<select class="form-control input-sm" name="userIsExitRecommended" id="userIsExitRecommended${UNQID}" disabled style="width:100%">
								<option>Select one option</option>
								<option value="YES" <%if("YES".equals(l_strUserExitRecommended)) {%> selected="selected" <%} %>>YES</option>
								<option value="NO" <%if("NO".equals(l_strUserExitRecommended)) {%> selected="selected" <%} %>>NO</option>
							</select>
						</td>
						<% if(!isTemporaryDisbaled) { %> 
						<td width="20%">Suspicion Indicator</td>
						<td width="25%">
							<select class="form-control input-sm" name="userFraudIndicator" id="userFraudIndicator${UNQID}" <%=l_strUserDisabled%> style="width:100%">
								<option value="PFPM" <%if("PFPM".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Payment Mechanism</option>
								<option value="PFAP" <%if("PFAP".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Address Provided</option>
								<option value="PFND" <%if("PFND".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Non Disclosure</option>
								<option value="PFCI" <%if("PFCI".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Alerted Transaction</option>
								<option value="PFTP" <%if("PFTP".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Third Party Involved</option>
								<option value="PFIP" <%if("PFIP".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Identity Provided</option>
								<option value="PFUD" <%if("PFUD".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Underwriting Disclosure</option>
								<option value="TPOF" <%if("TPOF".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Tip Off Provided</option>
								<option value="SIOP" <%if("SIOP".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Relationship Information On Party</option>
								<option value="OFCM" <%if("OFCM".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>OFACSDN List Match</option>
								<option value="UNCM" <%if("UNCM".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>UNSanction List Match</option>
								<option value="OTHM" <%if("OTHM".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Other List Match</option>
								<option value="HSCOR" <%if("HSCOR".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>High Alert ScoreCard</option>
								<option value="OTHERS" <%if("OTHERS".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Others</option>
								<option value="PNEF" <%if("PNEF".equals(l_strUserReasonCode) || l_strCaseStatus == "5"){%>selected="selected"<%}%> >Potentially Not Suspicious</option>
						<!--		<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("2")) { %>
								<option value="PNEF" <%if("PNEF".equals(l_strUserReasonCode)){%>selected="selected"<%}%>>Potentially Not Suspicious</option>
								<% } %>-->
							</select>	
						</td>
						<% } %>
					</tr>
					<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("2")) { %>
						<tr>
							<td width="20%">Add To False Positive List</td>
							<td width="25%">
								<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="userAddToFalsePositive" id="userAddToFalsePositive${UNQID}" onclick="addToUserFalsePositive()" <%=l_strUserDisabled%>>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
					<% } %>
					<tr>	
						<td width="20%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="UserInputComments" id="UserInputComments${UNQID}" <%=l_strUserDisabled%>><%=l_strUserComments == null ? "":l_strUserComments%></textarea>
						</td>
					</tr>
				</table>
			
			</div>
		</div>
	</div>
</div>

<br/>
<% }  if(hierarchyCode <=4 && l_strRegenrate_Flag.equals("Y")) { %>
<div class="row compassrow${UNQID}">
   <div class="col-sm-12" >
   <% if(l_strRegenrate_MLROCode != null && !l_strRegenrate_MLROCode.equals("")) { %>
		<div class="card card-primary panel_addViewComments" id= "panelAddViewCommentsRegenerateMLRO${UNQID}" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsRegenerateMLRO${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><%=l_strRegenrate_MLROCode == null ? "":l_strRegenrate_MLROCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strRegenrate_MLROTimestamp == null ? "":l_strRegenrate_MLROTimestamp%></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>	
						<td width="15%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="regenerateMLROComments" id="regenerateMLROComments${UNQID}"  "disabled"><%=l_strRegenrate_MLROComments == null ? "":l_strRegenrate_MLROComments%></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<% } } if(hierarchyCode <=3 ) { %>

<% if(l_strAMLUserBRTime != null && !l_strAMLUserBRTime.equals("")) { %>
<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id= "panelRaisedToBranch${UNQID}" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingRaisedToBranch${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Raised to Branch Comment</h6>
					<div class="card-header panelSlidingAddViewComments${UNQID} clearfix">			
						<h6 class="card-title pull-${dirL}">
							<%=l_strAMLUserCode == null ? "":l_strAMLUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLUserBRTime == null ? "":l_strAMLUserBRTime%>
						</h6>
						<div class="btn-group pull-${dirR} clearfix">
							<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
						</div>
					</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Account Reviewed Date</td>
						<td width="25%">
							<input type="text" class="form-control input-sm datepicker" name="amlUserBRAcctReviewedDate" id="amlUserBRAcctReviewedDate${UNQID}" value="<%=l_strAMLUserBRReviewDate%>"  <%=l_strAMLUserDisabled%> style="width:100%"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Exit Recommended</td>
						<td width="25%">
							<select class="form-control input-sm" name="amlUserBRIsExitRecommended" id="amlUserBRIsExitRecommended${UNQID}" disabled style="width:100%">
								<option>Select one option</option>
								<option value="YES" <%if("YES".equals(l_strAMLUserBRExitRecommended)) {%> selected="selected" <%} %>>YES</option>
								<option value="NO" <%if("NO".equals(l_strAMLUserBRExitRecommended)) {%> selected="selected" <%} %>>NO</option>
							</select>
						</td>
						<% if(!isTemporaryDisbaled) { %>
						<td width="20%">Suspicion Indicator</td>
						<td width="25%">
							<select class="form-control input-sm" name="bRFraudIndicator" id="bRFraudIndicator${UNQID}"  <%=l_strAMLUserDisabled%> style="width:100%">
								<option value="PFPM" <%if("PFPM".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Payment Mechanism</option>
								<option value="PFAP" <%if("PFAP".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Address Provided</option>
								<option value="PFND" <%if("PFND".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Non Disclosure</option>
								<option value="PFCI" <%if("PFCI".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Alerted Transaction</option>
								<option value="PFTP" <%if("PFTP".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Third Party Involved</option>
								<option value="PFIP" <%if("PFIP".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Identity Provided</option>
								<option value="PFUD" <%if("PFUD".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Suspicious Underwriting Disclosure</option>
								<option value="TPOF" <%if("TPOF".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Tip Off Provided</option>
								<option value="SIOP" <%if("SIOP".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Relationship Information On Party</option>
								<option value="OFCM" <%if("OFCM".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>OFACSDN List Match</option>
								<option value="UNCM" <%if("UNCM".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>UNSanction List Match</option>
								<option value="OTHM" <%if("OTHM".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Other List Match</option>
								<option value="HSCOR" <%if("HSCOR".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>High Alert ScoreCard</option>
								<option value="OTHERS" <%if("OTHERS".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Others</option>
								<option value="PNEF" <%if("PNEF".equals(l_strAMLUserBRReason)|| "5".equals(l_strCaseStatus)){%>selected="selected"<%}%>>Potentially Not Suspicious</option>
								<!--<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
								<option value="PNEF" <%if("PNEF".equals(l_strAMLUserBRReason)){%>selected="selected"<%}%>>Potentially Not Suspicious</option>
								<% } %>-->
							</select>	
						</td>
						<% } %>
					</tr>
					<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("5")) { %>
						<tr>	
							<td width="20%">Comments</td>
							<td colspan="4">
								<textarea class="form-control input-sm" name="amlUserBRComments" id="amlUserBRComments${UNQID}"  <%=l_strAMLUserDisabled%>><%=l_strAMLUserBRComments == null ? "":l_strAMLUserBRComments%></textarea>
							</td>
						</tr>
					<%}%>
				</table>
			</div>
		</div>
	</div>
</div>
<%}%>
<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsAMLUser" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsAMLUser${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">
					<%=l_strAMLUserCode == null ? "":l_strAMLUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLUserTimeStamp == null ? "":l_strAMLUserTimeStamp%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Account Reviewed Date</td>
							<td width="25%">
								<input type="text" class="form-control input-sm datepicker" name="amlUserAcctReviewedDate" id="amlUserAcctReviewedDate${UNQID}" value="<%=l_strAMLUserAcctReviewDate%>"  <%=l_strAMLUserDisabled%> style="width:100%"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Exit Recommended</td>
						<td width="25%">
							<select class="form-control input-sm" name="amlUserIsExitRecommended" id="amlUserIsExitRecommended${UNQID}" disabled style="width:100%">
								<option>Select one option</option>
								<option value="YES" <%if("YES".equals(l_strAMLUserExitRecommended)) {%> selected="selected" <%} %>>YES</option>
								<option value="NO" <%if("NO".equals(l_strAMLUserExitRecommended)) {%> selected="selected" <%} %>>NO</option>
							</select>
						</td>
						
						<% if (!isTemporaryDisbaled) {%>						
						<td width="20%">Suspicion Indicator</td>
						<td width="25%">
							<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}"  <%=l_strAMLUserDisabled%> style="width:100%">
								<option value="PFPM" <%if("PFPM".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Payment Mechanism</option>
								<option value="PFAP" <%if("PFAP".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Address Provided</option>
								<option value="PFND" <%if("PFND".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Non Disclosure</option>
								<option value="PFCI" <%if("PFCI".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Alerted Transaction</option>
								<option value="PFTP" <%if("PFTP".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Third Party Involved</option>
								<option value="PFIP" <%if("PFIP".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Identity Provided</option>
								<option value="PFUD" <%if("PFUD".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Suspicious Underwriting Disclosure</option>
								<option value="TPOF" <%if("TPOF".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Tip Off Provided</option>
								<option value="SIOP" <%if("SIOP".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Relationship Information On Party</option>
								<option value="OFCM" <%if("OFCM".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>OFACSDN List Match</option>
								<option value="UNCM" <%if("UNCM".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>UNSanction List Match</option>
								<option value="OTHM" <%if("OTHM".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Other List Match</option>
								<option value="HSCOR" <%if("HSCOR".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>High Alert ScoreCard</option>
								<option value="OTHERS" <%if("OTHERS".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Others</option>
								<option value="PNEF" <%if("PNEF".equals(l_strAMLUserReasonCode)|| "5".equals(l_strCaseStatus)){%>selected="selected"<%}%>>Potentially Not Suspicious</option>
								<!--<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
								<option value="PNEF" <%if("PNEF".equals(l_strAMLUserReasonCode)){%>selected="selected"<%}%>>Potentially Not Suspicious</option>
								<% } %>-->
							</select>	
						</td>
						<% } %>
					</tr>
					<% if(l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("5")) { %>
						<tr>
							<td width="20%">Add To False Positive List</td>
							<td width="25%">
								<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="amlUserAddToFalsePositive" id="amlUserAddToFalsePositive${UNQID}" onclick="addToAMLUserFalsePositive()" <%=l_strAMLUserDisabled%>>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
					<% } %>
						<tr>	
							<td width="20%">Comments</td>
							<td colspan="4">
								<textarea class="form-control input-sm" name="amlUserComments" id="amlUserComments${UNQID}"  <%=l_strAMLUserDisabled%>><%=l_strAMLUserComments == null ? "":l_strAMLUserComments%></textarea>
							</td>
						</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<% } if(hierarchyCode <=2 ) { %>
<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsAMLO" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsAMLO${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">
					<%=l_strAMLOUSERCODE == null ? "":l_strAMLOUSERCODE%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strAMLOTIMESTAMP == null ? "":l_strAMLOTIMESTAMP%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Account Reviewed Date</td>
							<td width="25%">
								<input type="text" class="form-control input-sm datepicker" name="amloAcctReviewedDate" id="amloAcctReviewedDate${UNQID}" value="<%=l_strAMLOAcctReviewDate%>"  <%=l_strAMLOUSERDisabled%>  style="width:100%"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Exit Recommended</td>
						<td width="25%">
							<select class="form-control input-sm" name="amloIsExitRecommended" id="amloIsExitRecommended${UNQID}" disabled style="width:100%">
								<option>Select one option</option>
								<option value="YES" <%if("YES".equals(l_strAMLOExitRecommended)) {%> selected="selected" <%} %>>YES</option>
								<option value="NO" <%if("NO".equals(l_strAMLOExitRecommended)) {%> selected="selected" <%} %>>NO</option>
							</select>
						</td>
						<% if(!isTemporaryDisbaled && (l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("7")) || (l_strAMLORemovalReason != null && !l_strAMLORemovalReason.trim().equalsIgnoreCase("")))  { %>
						<td width="20%">Removal Reason</td>
						<td width="25%">
							<select class="form-control input-sm" name="amloRemovalReason" id="amloRemovalReason${UNQID}"  <%=l_strAMLOUSERDisabled%> style="width:100%">
								<option value="SBRR1" <%if("SBRR1".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Confirmed non-suspicious activity</option>
								<option value="SBRR2" <%if("SBRR2".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Potential laundering attempt but unsuccessful</option>
								<option value="SBRR3" <%if("SBRR3".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Sniffing activity aimed to test</option>
								<option value="SBRR4" <%if("SBRR4".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>False positive</option>
								<option value="SBRR5" <%if("SBRR5".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Referred in error</option>
								<option value="SBRR6" <%if("SBRR6".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Potential suspicion investigated but disproved</option>
								<option value="SBRR7" <%if("SBRR7".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Suspicion indicated against incorrect party</option>
								<option value="SBRR8" <%if("SBRR8".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Laundering intention but transaction allowed</option>
								<option value="SBRR9" <%if("SBRR9".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Potentially non-suspicious</option>
								<option value="OTHERS" <%if("OTHERS".equals(l_strAMLORemovalReason)){%>selected="selected"<%}%>>Others</option>
							</select>	
						</td>
					</tr>
						<tr>
							<td width="20%">Add To False Positive List</td>
							<td width="25%">
								<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="addToAMLOFalsePositive" id="addToAMLOFalsePositive${UNQID}" onclick="addToAMLOFalsePositive()" <%=l_strAMLOUSERDisabled%>>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
					<% } %>
					<% if(!isTemporaryDisbaled && (l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) || (l_strAMLOOUTCOMEINDICATOR != null && !l_strAMLOOUTCOMEINDICATOR.trim().equalsIgnoreCase(""))) { %>
						<tr>	
						<td width="20%">Outcome Indicator</td>
						<td width="25%">
							<select name="amloOutcomeIndicator" id="amloOutcomeIndicator${UNQID}" class="form-control input-sm"  onChange="changeAMLOValues(this)"  <%=l_strAMLOUSERDisabled%> style="width:100%">
								<option value="FUPR" <%if("FUPR".equals(l_strAMLOOUTCOMEINDICATOR)){%>selected="selected"<%}%>>Laundering activity upheld, RED Mark Indicator assigned</option>
								<!--<option value="FUPA">Laundering activity upheld, AMBER Fraud Indicator assigned</option>-->
								<option value="FUNM" <%if("FUNM".equals(l_strAMLOOUTCOMEINDICATOR)){%>selected="selected"<%}%>>Laundering activity upheld, No marker applied</option>
							</select>		
						</td>
						<td width="10%"></td>
						<td colspan = "2">
					<%}if(!isTemporaryDisbaled && (l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("8")) || (l_strAMLOHIGHRISKREASONCODE != null && !l_strAMLOHIGHRISKREASONCODE.trim().equalsIgnoreCase(""))) { %>
						<div id="div_AMLOHIGHRISKREASONCODE" style="display:block">
							<table>
								<tr>
									<td width="20%">High-Risk Reason Code</td>
										<td width="25%">
											<select name="amloHighRiskReasonCode" id="amloHighRiskReasonCode${UNQID}" class="form-control input-sm"  style="width:100%" <%=l_strAMLOUSERDisabled%>>
											<!--<option value="HRA">Mark As High Risk Accounts</option>-->
												<option value="WAT" <%if("WAT".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Suspicious activity watch List</option>
												<option value="HRWLA" <%if("HRWLA".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Mark As High Risk Accounts And Add To System Watchlist</option>
												<option value="MLA" <%if("MLA".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Money laundering activities</option>
												<option value="CPA" <%if("FCPAUNM".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Continuous payment arrears</option>
												<option value="TBS" <%if("TBS".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Threatening behaviour towards staff or supplier</option>
												<option value="TER" <%if("TER".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>ABC terminated commercial agreement (Broker / Supplier)</option>
												<option value="OTHERS" <%if("OTHERS".equals(l_strAMLOHIGHRISKREASONCODE)){%>selected="selected"<%}%>>Others</option>
											</select>
										</td>
								</tr>
							</table>
						</div>
					<%} %>
						</td>
					</tr>
					<tr>	
						<td width="20%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="amloComments" id="amloComments${UNQID}"  <%=l_strAMLOUSERDisabled%>><%=l_strAMLOComments == null?"":l_strAMLOComments%></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<% } if(hierarchyCode <=1 ) { %>
<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsMLRO" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsMLRO${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">
					<%=l_strMLROUSERCode == null ? "":l_strMLROUSERCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strMLROTimeStamp == null ? "":l_strMLROTimeStamp%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Account Reviewed Date</td>
							<td width="25%">
								<input type="text" class="form-control input-sm datepicker" name="mlroAcctReviewedDate" id="mlroAcctReviewedDate${UNQID}" <%=l_strMLROUSERDisabled%> value="<%= l_strMLROAcctReviewDate %>" style="width:100%"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Exit Recommended</td>
						<td width="25%">
							<select class="form-control input-sm" name="mlroIsExitRecommended" id="mlroIsExitRecommended${UNQID}"  <%=l_strMLROUSERDisabled%> style="width:100%">
								<option>Select one option</option>
								<option value="YES" <%if("YES".equals(l_strMLROExitRecommended)) {%> selected="selected" <%} %>>YES</option>
								<option value="NO" <%if("NO".equals(l_strMLROExitRecommended)) {%> selected="selected" <%} %>>NO</option>
							</select>
						</td>
						<% if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("9")) { %>
						<td width="20%">Removal Reason</td>
						<td width="25%">
							<select class="form-control input-sm" name="mlroRemovalReason" id="mlroRemovalReason${UNQID}"  <%=l_strMLROUSERDisabled%> style="width:100%">
								<option value="NUPH" <%if("NUPH".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Suspicion activity not upheld</option>
								<option value="FRDP" <%if("FRDP".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Case disproved</option>
								<option value="ADIP" <%if("ADIP".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Added against incorrect party</option>
								<option value="SBRR1" <%if("SBRR1".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Confirmed non-suspicious activity</option>
								<option value="SBRR2" <%if("SBRR2".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Potential laundering attempt but unsuccessful</option>
								<option value="SBRR3" <%if("SBRR3".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Sniffing activity aimed to test</option>
								<option value="SBRR4" <%if("SBRR4".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>False positive</option>
								<option value="SBRR5" <%if("SBRR5".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Referred in error</option>
								<option value="SBRR6" <%if("SBRR6".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Potential suspicion investigated but disproved</option>
								<option value="SBRR7" <%if("SBRR7".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Suspicion indicated against incorrect party</option>
								<option value="SBRR8" <%if("SBRR8".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Laundering intention but transaction allowed</option>
								<option value="SBRR9" <%if("SBRR9".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Potentially non-suspicious</option>
								<option value="OTHERS" <%if("OTHERS".equals(l_strMLRORemovalReason)){%>selected="selected"<%}%>>Others</option>
							</select>	
						</td>
					</tr>
						<tr>
							<td width="20%">Add To False Positive List</td>
							<td width="25%">
								<input style="width: 20px; margin-top: -4px;" type="checkbox" class="form-control input-sm" name="mlroAddToFalsePositive" id="mlroAddToFalsePositive${UNQID}" onclick="addToMLROFalsePositive()" <%=l_strMLROUSERDisabled%>>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
					<% } %>
					<% if(!isTemporaryDisbaled && l_strCaseStatus != null && l_strCaseStatus.trim().equalsIgnoreCase("10")) { %>
						<tr>	
						<td width="20%">Outcome Indicator</td>
						<td width="25%">
							<select name="mlroOutcomeIndicator" id="mlroOutcomeIndicator${UNQID}" class="form-control input-sm"  onChange="changeMLROValues(this)"  <%=l_strMLROUSERDisabled%> style="width:100%">
								<option value="FUPR" <%if("FUPR".equals(l_strMLROOutcomeIndicator)){%>selected="selected"<%}%>>Laundering activity upheld, RED Mark Indicator assigned</option>
								<!--<option value="FUPA">Laundering activity upheld, AMBER Fraud Indicator assigned</option>-->
								<option value="FUNM" <%if("FUNM".equals(l_strMLROOutcomeIndicator)){%>selected="selected"<%}%>>Laundering activity upheld, No marker applied</option>
							</select>		
						</td>
						<td width="10%"></td>
						<td colspan="2">
							<div id="div_MLROHighRiskReasonCode"  style="display:block;">
								<table>
									<tr>
										<td width="20%">High-Risk Reason Code</td>
											<td width="25%">
												<select name="mlroHighRiskReasonCode" id="mlroHighRiskReasonCode${UNQID}" class="form-control input-sm" style="width:100%" <%=l_strMLROUSERDisabled%>>
												<!--<option value="HRA">Mark As High Risk Accounts</option>-->
													<option value="WAT" <%if("WAT".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Suspicious activity watch List</option>
													<option value="HRWLA" <%if("HRWLA".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Mark As High Risk Accounts And Add To System Watchlist</option>
													<option value="MLA" <%if("MLA".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Money laundering activities</option>
													<option value="CPA" <%if("CPA".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Continuous payment arrears</option>
													<option value="TBS" <%if("TBS".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Threatening behaviour towards staff or supplier</option>
													<option value="TER" <%if("TER".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>ABC terminated commercial agreement (Broker / Supplier)</option>
													<option value="OTHERS" <%if("OTHERS".equals(l_strMLROHighRiskReasonCode)){%>selected="selected"<%}%>>Others</option>
												</select>
											</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					<%} %>
					<tr>	
						<td width="20%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="mlroComments" id="mlroComments${UNQID}"  <%=l_strMLROUSERDisabled%>><%=l_strMLROCComments == null ? "":l_strMLROCComments%></textarea>
						</td>
					</tr>
				<%} %>
				</table>
			</div>
		</div>
	</div>
</div>
<div class="card-footer clearfix">
	<div class="pull-${dirR}">
		<% if(l_strFlagType.equals("Y")) { %>
		<input  type="button" id="saveComments${UNQID}" class="btn btn-success btn-sm" value="Save" onclick="saveComments()" value="Save">
		<%} %>
		<input type="button" id="closeAddViewCommentsModal${UNQID}" class="btn btn-danger btn-sm" value="Close"/>
	</div>
</div>
</form>
<form name="form1" id="saveCommentForm" method='POST' action="${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments">
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
<input type="hidden" name="ExitRecommended" value=""/>
<input type="hidden" name="CaseStatus" value="" />
<input type="hidden" name="actionType" value="saveComments" />
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
</body>
</html>