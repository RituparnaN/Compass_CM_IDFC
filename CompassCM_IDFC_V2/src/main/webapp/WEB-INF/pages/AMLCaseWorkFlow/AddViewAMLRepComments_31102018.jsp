<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ page import ="java.io.IOException" %>
<%@ include file="../tags/tags.jsp"%>    
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();

String LOGGEDUSER = (request.getAttribute("LOGGEDUSER") == null ? "AMLUser":request.getAttribute("LOGGEDUSER").toString());
String LOGGED_USER_REGION = request.getAttribute("LOGGED_USER_REGION") == null ? "India":request.getAttribute("LOGGED_USER_REGION").toString();
String groupCode = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":(String)request.getSession(false).getAttribute("CURRENTROLE");
System.out.println("1");
Map<String, Object> resultData = new HashMap<String, Object>();
resultData = (HashMap<String, Object>)request.getAttribute("CASECOMMENTDETAILS");
System.out.println("2");

String CaseNos = request.getAttribute("CaseNos").toString();
String l_strCaseStatus = request.getAttribute("CaseStatus") == null ? "-1":(String)request.getAttribute("CaseStatus");
String l_strUpdateMessage = resultData.get("updateMessage") == null ? "":(String)resultData.get("updateMessage"); 
System.out.println("3");

String l_strAlertNo = request.getAttribute("CaseNos").toString(); 
String l_strFlagType = request.getAttribute("FlagType") == null ? "N":request.getAttribute("FlagType").toString();
String l_strActionType = request.getAttribute("ActionType") == null ? "":request.getAttribute("ActionType").toString(); 

String caseCustomerId = resultData.get("CUSTOMERID") == null ? "":(String)resultData.get("CUSTOMERID");
String caseAcctReviewedDate = resultData.get("CASEACCTREVIEWEDDATE") == null ? "":(String)resultData.get("CASEACCTREVIEWEDDATE");
System.out.println("4");

int hierarchyCode = 3;
String l_strUserDisabled = ""; 
String l_strAMLUserDisabled = ""; 
String l_strAMLOUSERDisabled = "";
String l_strMLROUSERDisabled = "";

Map<String, String> commentMapDetails = new HashMap<String, String>();
commentMapDetails = (HashMap<String, String>)request.getAttribute("CommentMapDetails");
System.out.println("5");

String fromDate = commentMapDetails.get("fromDate") == null ? "":(String)commentMapDetails.get("fromDate");
String toDate = commentMapDetails.get("toDate") == null ? "":(String)commentMapDetails.get("toDate");
String alertCode = commentMapDetails.get("alertCode") == null ? "":(String)commentMapDetails.get("alertCode");
String branchCode = commentMapDetails.get("branchCode") == null ? "":(String)commentMapDetails.get("branchCode");
String accountNo = commentMapDetails.get("accountNo") == null ? "":(String)commentMapDetails.get("accountNo");
String customerId = commentMapDetails.get("customerId") == null ? "":(String)commentMapDetails.get("customerId");
String hasAnyOldCases = commentMapDetails.get("hasAnyOldCases") == null ? "":(String)commentMapDetails.get("hasAnyOldCases");
String caseRating = commentMapDetails.get("caseRating") == null ? "":(String)commentMapDetails.get("caseRating");
String fromCaseNo = commentMapDetails.get("fromCaseNo") == null ? "":(String)commentMapDetails.get("fromCaseNo");
String toCaseNo = commentMapDetails.get("toCaseNo") == null ? "":(String)commentMapDetails.get("toCaseNo");
System.out.println("63");

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
		
		$('.panelSlidingAddViewCommentsAMLUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsAMLUser');
	    });
	
				
		$("#closeAddViewCommentsModal"+id).click(function(){
			$("#compassCaseWorkFlowGenericModal").modal("hide");
		});
	});
	
	function addToAMLUserMarkAll()
	{
	if(document.userComments.amlUserAddToMarkAll.checked)
	var con = confirm('Are you sure to mark all the cases for desktop closure');
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
	}


	function checkDate(dateToCheck){
		if(dateToCheck == '' || dateToCheck == 'null'){
		   alert('Please enter the FIU reference date.');
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

	function saveComments()
	{
	   var l_strAlertNo = "<%=l_strAlertNo%>";
	   var flagType = "<%=l_strFlagType%>";
	   var FiuReferenceNo = document.userComments.amlUserFiuReferenceNo.value;
	   var FiuReferenceDate = document.userComments.amlUserFiuReferenceDate.value;
	   var ExitRecommended = document.userComments.amlUserIsExitRecommended.value;
	   var Comments = document.userComments.amlUserComments.value;
	   var userCode = "<%=LOGGEDUSER%>";
	   var hierarchyCode = "<%=hierarchyCode%>";
	   var fraudIndicator = "";
	   var RemovalReason = "";
	   var OutcomeIndicator = "";
	   var HighRiskReasonCode = "";
	   var AddedToMarkAll = "N";
	   var LastReviewedDate = "";

	   var l_strCaseStatus = '<%= l_strCaseStatus %>';
	   document.form1.FlagType.value=flagType;
	   document.form1.UserCode.value=userCode;
	   document.form1.Comments.value=Comments;
	   document.form1.FIUReferenceNo.value=FiuReferenceNo;
	   document.form1.FIUReferenceDate.value=FiuReferenceDate;
	   document.form1.ExitRecommended.value=ExitRecommended;
	   
	   document.form1.AddedToMarkAll.value = AddedToMarkAll;
	   document.form1.LastReviewedDate.value = LastReviewedDate;
	   document.form1.CaseStatus.value=l_strCaseStatus;
	   document.form1.actionType.value="saveComments";
	   
	   if(Comments == "")
	   {
	   alert('Please enter comments.');
	   return false;
	   }
	   else if(FiuReferenceNo == "")
	   {
	   alert('Please enter FIU reference no.');
	   return false;
	   }
	   else if(FiuReferenceDate == "" || FiuReferenceDate == "null")
	   {
	   alert('Please enter FIU reference date.');
	   return false;
	   }
	   else if(!checkDate(FiuReferenceDate)){
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

<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsAMLUser" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsAMLUser${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
							<td width="20%">FIU Reference No</td>
							<td width="25%">
								<input type="text" class="form-control input-sm" name="amlUserFiuReferenceNo" id="amlUserFiuReferenceNo${UNQID}" value=""/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">STR Upload Date</td>
							<td width="25%">
								<input type="text" class="form-control input-sm datepicker" name="amlUserFiuReferenceDate" id="amlUserFiuReferenceDate${UNQID}" value=""/>
							</td>
							
					</tr>
					<tr>
							<td width="20%">Exit Recommended</td>
							<td width="25%">
								<select class="form-control input-sm" name="amlUserIsExitRecommended" id="amlUserIsExitRecommended${UNQID}"  <%=l_strMLROUSERDisabled%> style="width:100%">
									<option>Select one option</option>
									<option value="YES" selected>YES</option>
									<option value="NO">NO</option>
								</select>
							</td>
							<td colspan="3">
					</tr>	
					<tr>	
							<td width="20%">Comments</td>
							<td colspan="4">
								<textarea class="form-control input-sm" name="amlUserComments" id="amlUserComments${UNQID}"></textarea>
							</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>

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
<form name="form1" id="saveCommentForm" method='POST' action="${pageContext.request.contextPath}/amlCaseWorkFlow/saveAMLREPComments">
<input type="hidden" name="CaseNos" value="<%= CaseNos %>" />
<input type="hidden" name="FlagType" value="" />
<input type="hidden" name="UserCode" value="" />
<input type="hidden" name="Comments" value="" />
<input type="hidden" name="FIUReferenceNo" value="" />
<input type="hidden" name="FIUReferenceDate" value="" />
<input type="hidden" name="ExitRecommended" value="" />


<input type="hidden" name="AddedToMarkAll" value="" />
<input type="hidden" name="LastReviewedDate" value="" />
<input type="hidden" name="CaseStatus" value="" />
<input type="hidden" name="actionType" value="saveComments" />

<input type="hidden" name="fromDate" value="<%= fromDate %>" />
<input type="hidden" name="toDate" value="<%= toDate %>" />
<input type="hidden" name="alertCode" value="<%= alertCode %>" />
<input type="hidden" name="branchCode" value="<%= branchCode %>" />
<input type="hidden" name="accountNo" value="<%= accountNo %>" />
<input type="hidden" name="customerId" value="<%= customerId %>" />
<input type="hidden" name="hasAnyOldCases" value="<%= hasAnyOldCases %>" />
<input type="hidden" name="caseRating" value="<%= caseRating %>" />
<input type="hidden" name="fromCaseNo" value="<%= fromCaseNo %>" />
<input type="hidden" name="toCaseNo" value="<%= toCaseNo %>" />

<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
</body>
</html>