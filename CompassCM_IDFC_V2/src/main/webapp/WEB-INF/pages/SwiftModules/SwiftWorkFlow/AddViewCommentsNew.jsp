<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ page import ="java.io.IOException" %>
<%@ include file="../../tags/tags.jsp"%>    
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();

String LOGGEDUSER = (request.getAttribute("LOGGEDUSER") == null ? "AMLUser":request.getAttribute("LOGGEDUSER").toString());
String LOGGED_USER_REGION = request.getAttribute("LOGGED_USER_REGION") == null ? "India":request.getAttribute("LOGGED_USER_REGION").toString();
String groupCode = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":(String)request.getSession(false).getAttribute("CURRENTROLE");

Map<String, Object> resultData = new HashMap<String, Object>();
resultData = (HashMap<String, Object>)request.getAttribute("CASECOMMENTDETAILS");

String CaseNos = request.getAttribute("CaseNos").toString();
String l_strCaseStatus = request.getAttribute("CaseStatus") == null ? "-1":(String)request.getAttribute("CaseStatus");
String l_strUpdateMessage = resultData.get("updateMessage") == null ? "":(String)resultData.get("updateMessage"); 

String l_strAlertNo = request.getAttribute("CaseNos").toString(); 
String l_strFlagType = request.getAttribute("FlagType") == null ? "N":request.getAttribute("FlagType").toString();
String l_strActionType = request.getAttribute("ActionType") == null ? "":request.getAttribute("ActionType").toString(); 

int hierarchyCode = 3;
String l_strSwiftUserDisabled = ""; 
String l_strSwiftAdminDisabled = "";

String l_strSwiftUserCode        = (String)resultData.get("USERCODE"); 
String l_strSwiftAdminCODE       = (String)resultData.get("ADMINCODE");
String l_strSwiftUserComments    = (String)resultData.get("USERCOMMENTS");
String l_strSwiftAdminComments   = (String)resultData.get("ADMINCOMMENTS");
String l_strSwiftUserReasonCode  = (String)resultData.get("USERREASONCODE");
String l_strSwiftAdminReasonCode = (String)resultData.get("ADMINREASONCODE");
String l_strSwiftUserTimeStamp   = (String)resultData.get("USERTIMESTAMP");
String l_strSwiftAdminTIMESTAMP  = (String)resultData.get("ADMINTIMESTAMP");

if(groupCode.equalsIgnoreCase("ROLE_SWIFTUSER") || groupCode.equalsIgnoreCase("SWIFTUSER")){
	hierarchyCode = 2;
}
else {
	hierarchyCode = 1;
}

if(hierarchyCode == 2)
{
	l_strSwiftUserCode = LOGGEDUSER;
}
if(hierarchyCode == 1)
{
	l_strSwiftAdminCODE = LOGGEDUSER;
	l_strSwiftUserDisabled = "disabled";
}

if(!l_strFlagType.equals("Y"))
{
	l_strSwiftUserDisabled = "disabled";
	l_strSwiftAdminDisabled = "disabled";
}

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'compassModuleDetailsSearchTable'+id;
		compassTopFrame.init(id, tableClass, 'dd/mm/yy');
		
		$('.panelSlidingAddViewCommentsAMLUser'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsAMLUser');
	    });
	
		$('.panelSlidingAddViewCommentsAMLO'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'panelAddViewCommentsAMLO');
	    });
		
		$("#closeAddViewCommentsModal"+id).click(function(){
			$("#compassCaseWorkFlowGenericModal").modal("hide");
		});
	});
	
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
	
	function changeAMLOValues(selectName)
	{
	var value = selectName.value;
	if(value == "FUPR")
	{
		$("#div_AMLOHIGHRISKREASONCODE").css("display", "block");
	}
	else
	{
		$("#div_AMLOHIGHRISKREASONCODE").css("display", "none");
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
	<% if(l_strSwiftUserReasonCode != null && !l_strSwiftUserReasonCode.trim().equalsIgnoreCase("")) { %>
		document.userComments.fraudIndicator.value = '<%= l_strSwiftUserReasonCode %>';
	<% } if(l_strSwiftAdminReasonCode != null && !l_strSwiftAdminReasonCode.trim().equalsIgnoreCase("")) { %>
		document.userComments.amlofraudIndicator.value = '<%= l_strSwiftAdminReasonCode %>';
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
	   
	   if(hierarchyCode == 2 )
	   {
		fraudIndicator = document.userComments.fraudIndicator.value;
		Comments = document.userComments.amlUserComments.value;
	   } else if(hierarchyCode == 1 )
	   {
		fraudIndicator = document.userComments.amlofraudIndicator.value;
		Comments = document.userComments.amloComments.value;
	   }
	  
	   var l_strCaseStatus = '<%= l_strCaseStatus %>';
	   document.form1.FlagType.value=flagType;
	   document.form1.UserCode.value=userCode;
	   document.form1.Comments.value=Comments;
	   document.form1.fraudIndicator.value = fraudIndicator;
	   document.form1.CaseStatus.value=l_strCaseStatus;
	   document.form1.actionType.value="saveComments";
	   
	   if(Comments == "") 
	   {
	   alert('Please enter comments.');
	   return false;
	   } 
	   else {
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
</head>

<body onLoad= "setValues();updateComments();">
<form method="POST" name="userComments">
<% if(hierarchyCode <=2 ) { %>

<div class="row compassrow${UNQID}">
	 <div class="col-sm-12" >
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsAMLUser" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsAMLUser${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">
					<%=l_strSwiftUserCode == null ? "":l_strSwiftUserCode%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strSwiftUserTimeStamp == null ? "":l_strSwiftUserTimeStamp%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Suspicion Indicator</td>
						<td  colspan="4">
							<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}"  <%=l_strSwiftUserDisabled%> style="width:100%">
								<option value="PFPM">Potentially Suspicious Payment Mechanism</option>
								<option value="PFAP">Potentially Suspicious Address Provided</option>
								<option value="PFND">Potentially Suspicious Non Disclosure</option>
								<option value="PFCI">Potentially Suspicious Alerted Transaction</option>
								<option value="PFTP">Potentially Suspicious Third Party Involved</option>
								<option value="PFIP">Potentially Suspicious Identity Provided</option>
								<option value="PFUD">Potentially Suspicious Underwriting Disclosure</option>
								<option value="TPOF">Tip Off Provided</option>
								<option value="SIOP">Relationship Information On Party</option>
								<option value="OFCM">OFACSDN List Match</option>
								<option value="UNCM">UNSanction List Match</option>
								<option value="OTHM">Other List Match</option>
								<option value="HSCOR">High Alert ScoreCard</option>
								<option value="OTHERS">Others</option>
								<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
								<option value="PNEF">Potentially Not Suspicious</option>
								<% } %>
							</select>	
						</td>
					</tr>
					<tr>	
							<td width="20%">Comments</td>
							<td colspan="4">
								<textarea class="form-control input-sm" name="amlUserComments" id="amlUserComments${UNQID}"  <%=l_strSwiftUserDisabled%>><%=l_strSwiftUserComments == null ? "":l_strSwiftUserComments%></textarea>
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
		<div class="card card-primary panel_addViewComments" id="panelAddViewCommentsAMLO" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingAddViewCommentsAMLO${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">
					<%=l_strSwiftAdminCODE == null ? "":l_strSwiftAdminCODE%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=l_strSwiftAdminTIMESTAMP == null ? "":l_strSwiftAdminTIMESTAMP%>
				</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
				</div>		
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">Suspicion Indicator</td>
						<td  colspan="4">
							<select class="form-control input-sm" name="amlofraudIndicator" id="amlofraudIndicator${UNQID}"  <%=l_strSwiftAdminDisabled%> style="width:100%">
								<option value="PFPM">Potentially Suspicious Payment Mechanism</option>
								<option value="PFAP">Potentially Suspicious Address Provided</option>
								<option value="PFND">Potentially Suspicious Non Disclosure</option>
								<option value="PFCI">Potentially Suspicious Alerted Transaction</option>
								<option value="PFTP">Potentially Suspicious Third Party Involved</option>
								<option value="PFIP">Potentially Suspicious Identity Provided</option>
								<option value="PFUD">Potentially Suspicious Underwriting Disclosure</option>
								<option value="TPOF">Tip Off Provided</option>
								<option value="SIOP">Relationship Information On Party</option>
								<option value="OFCM">OFACSDN List Match</option>
								<option value="UNCM">UNSanction List Match</option>
								<option value="OTHM">Other List Match</option>
								<option value="HSCOR">High Alert ScoreCard</option>
								<option value="OTHERS">Others</option>
								<% if(l_strCaseStatus != null && (l_strCaseStatus.trim().equalsIgnoreCase("4") || l_strCaseStatus.trim().equalsIgnoreCase("5"))) { %>
								<option value="PNEF">Potentially Not Suspicious</option>
								<% } %>
							</select>	
						</td>
					</tr>
					<tr>	
						<td width="20%">Comments</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="amloComments" id="amloComments${UNQID}"  <%=l_strSwiftAdminDisabled%>><%=l_strSwiftAdminComments == null?"":l_strSwiftAdminComments%></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<% } %>
				</table>
			</div>
		</div>
	</div>
</div>
<div class="card-footer clearfix">
	<div class="pull-${dirR}">
		<% if(l_strFlagType.equals("Y")) { %>
		<input  type="button" id="saveComments${UNQID}" class="btn btn-success btn-sm" value="Post" onclick="saveComments()" value="Post">
		<%} %>
		<input type="button" id="closeAddViewCommentsModal${UNQID}" class="btn btn-danger btn-sm" value="Close"/>
	</div>
</div>
</form>
<form name="form1" id="saveCommentForm" method='POST' action="${pageContext.request.contextPath}/swiftcommon/swiftWorkFlow/saveComments">
<input type="hidden" name="CaseNos" value="<%= CaseNos %>" />
<input type="hidden" name="FlagType" value="" />
<input type="hidden" name="UserCode" value="" />
<input type="hidden" name="Comments" value="" />
<input type="hidden" name="fraudIndicator" value="" />
<input type="hidden" name="CaseStatus" value="" />
<input type="hidden" name="actionType" value="saveComments" />
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
</body>
</html>