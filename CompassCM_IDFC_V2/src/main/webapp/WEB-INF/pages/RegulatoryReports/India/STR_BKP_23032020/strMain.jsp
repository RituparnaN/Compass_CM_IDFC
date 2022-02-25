<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>

<%
String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
String contextPath = request.getContextPath()==null?"":request.getContextPath();
HttpSession l_CHttpSession = request.getSession(true);
String a_strAlertNo = request.getParameter("l_strAlertNo") == null?(String)l_CHttpSession.getAttribute("alertNo"):request.getParameter("l_strAlertNo").toString();
String l_strCaseStatus = "";
String l_strHierarchyCode = "";
//int l_intCaseStatus = 1;
try
{

//l_strCaseStatus = "6";
//System.out.println("l_intCaseStatus : "+l_intCaseStatus);

/* 
if(groupCode.equalsIgnoreCase("ROLE_USER")){
	l_strHierarchyCode = "4";
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLUSER")){
	l_strHierarchyCode = "3";
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLO")){
	l_strHierarchyCode = "2";
}
else {
	l_strHierarchyCode = "1";
}
*/
if(groupCode.equalsIgnoreCase("ROLE_USER")){
	l_strHierarchyCode = "4";
}
else if(groupCode.contains("ROLE_AMLUSER")){
	l_strHierarchyCode = "3";
}
else if(groupCode.contains("ROLE_AMLO")){
	l_strHierarchyCode = "2";
}
else {
	l_strHierarchyCode = "1";
}

}
catch(Exception e)
{
System.out.println("Exception found "+e.toString());
}
%>

<%
try{
	
	HashMap hashMapDTO = (HashMap)request.getAttribute("INDIANSTRDETAILS");
	String strSavedFlag = (String)request.getAttribute("saved");
	String strSaveButtonFlag = request.getParameter("saveButton");
	HashMap CaseStatusDetails = (HashMap)hashMapDTO.get("CaseStatusDetails");
	
	String strCaseStatus = CaseStatusDetails.get("CASESTATUS").toString();
	String strCaseUserCode = CaseStatusDetails.get("USERCODE").toString();
	String strCaseUserRole = CaseStatusDetails.get("USERROLE").toString();
	String exportXMLDisabled = "disabled";
	if(strCaseUserRole.equalsIgnoreCase("ROLE_AMLREP") && (strCaseStatus.equals("10")||strCaseStatus.equals("37"))) {
		exportXMLDisabled = "";
	}
	
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String canExported = l_CHttpSession.getAttribute("canExported") == null ?"N":(String)l_CHttpSession.getAttribute("canExported");

	if(strCaseStatus.equals("19") || strCaseStatus.equals("6") || strCaseStatus.equals("8") || strCaseStatus.equals("10"))
	{
	canExported = "Y";
	l_CHttpSession.setAttribute("canExported","Y");
	}
	else
	{
	canExported = "N";
	}

	if((l_strHierarchyCode.equals("3") && strCaseStatus.equals("0")) || (l_strHierarchyCode.equals("2") && strCaseStatus.equals("6")) || (l_strHierarchyCode.equals("1") && strCaseStatus.equals("8")) || (strCaseUserRole.equalsIgnoreCase("ROLE_AMLREP") && strCaseStatus.equals("10"))) 
	{
	canUpdated = "Y";
	l_CHttpSession.setAttribute("canUpdated","Y");
	}
	else
	{
	canUpdated = "N";
	}

	/* if(strCaseStatus.equals("8") && l_strHierarchyCode.equals("1")) 
	{
	canUpdated = "Y";
	// canExported = "Y";

	l_CHttpSession.setAttribute("canUpdated","Y");
	// l_CHttpSession.setAttribute("canExported","Y");
	} */


	//System.out.println("In ISTR a_strAlertNo: "+a_strAlertNo);
	//String a_strAlertNo = request.getParameter("l_strAlertNo").toString();
	request.getSession().setAttribute("alertNo",a_strAlertNo);
	String strDisableFlag = request.getParameter("disable") == null? "N":request.getParameter("disable");
	
	request.setAttribute("ManualFormDTO", (ISTRManualDetailsVO) hashMapDTO.get("ManualFormDTO"));
	request.setAttribute("ALIndvDetailsDTO", (ArrayList) hashMapDTO.get("ALIndvDetailsDTO"));
	request.setAttribute("ALLegPerDetailsDTO", (ArrayList) hashMapDTO.get("ALLegPerDetailsDTO"));
	request.setAttribute("AcctDetailsDTO", (ArrayList) hashMapDTO.get("AcctDetailsDTO")); 
	request.setAttribute("AlertIndicatorsList", (ArrayList) hashMapDTO.get("AlertIndicatorsList")); 
	request.setAttribute("disable",strDisableFlag);
	
%> 
<script language="javascript">
<!--
var acctNo;
var TranNo;
function addNewTransaction(accno,bankname,bsrcode)
{
var callfrom1 = '';
var l_strAlertNo = '<%= a_strAlertNo%>';
// var win= window.open('<%=contextPath%>/IndianRegulatoryReport/str/addTransactionDetails.jsp?l_strAlertNo='+l_strAlertNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
var win= window.open('<%=contextPath%>/common/addNewTransactionDetails?l_strAlertNo='+l_strAlertNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}
function updateTransactionDetails(strAcctNo,strTransacNo)
{
var callfrom = '';//document.form1.CallFrom.value;
acctNo = strAcctNo;
TranNo = strTransacNo;
var l_strAlertNo = '<%= a_strAlertNo%>';

var l_strAlertNo = '<%= a_strAlertNo%>';
window.open('<%=contextPath%>/common/getNewINDSTRTransactions?alertNo='+l_strAlertNo+'&accountNo='+acctNo+'&transactionNo='+TranNo+'&CallFrom='+callfrom,'ACCOUNTTRANSACTIONDETAILS','top=100, height=400, width=750,toolbar=no,location=no,menu=no,resizable=yes');
}

function deleteTransactionDetails(strAcctNo,strTransacNo)
{
var l_strAlertNo = '<%= a_strAlertNo%>';
var callfrom = '';//document.form1.CallFrom.value;
acctNo = strAcctNo;
TranNo = strTransacNo;
var conf=confirm('Do you want to delete the data?'); 
if(conf)
{	
	this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTRTransactions?alertNo='+l_strAlertNo+'&accountNo='+acctNo+'&tranNo='+TranNo+'&CallFrom='+callfrom);
}
}
function validate(frm)
{
	frm.submit();
}
function exportXML(strAlertNo){
	if(confirm("DO you want to Save this STR as XML ?")){
		window.open('<%=contextPath%>/common/INDSTRExportXML?l_strAlertNo='+strAlertNo);
	}
}

function exportGOS(strAlertNo){
	if(confirm("DO you want to generate GOS Word Document ?")){
		// window.open('<%=contextPath%>/INDSTRExportXML?l_strAlertNo='+strAlertNo);
		window.open('<%=contextPath%>/common/GroundOfSuspicionForSTRTemplateDOC?primaryCustomerId=N.A.&secondaryCustomerId=N.A.&accountNumbers=N.A.&templateId=N.A.&fromDate=N.A.&toDate=N.A.&caseNo='+strAlertNo,'GOSDOC','height=200, width=200, resizable=Yes, scrollbars=Yes');
	}
}

function exportExceptionReport(strAlertNo){
	if(confirm("DO you want to generate exception report ?")){
		window.open('<%=contextPath%>/common/exportConsildatedExceptionReport?caseNo='+strAlertNo);
	}
}


-->
</script>
 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>STR_ARF</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css">
  <script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
  <script src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
  <style type="text/css">
	#batchDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	.nav{
		margin-bottom: 5px !important;
		padding-left: 5px;
	}
	.card{
		padding: 0 5px 5px 5px;
	}
	.compass-nav-tabs li {
		border: none;
		padding: 0;
	}
	.nav-tabs>li.active>a{
		color: red !important;
		background-color: #FFE6E6 !important;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#batchDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		$("input[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		 });
		$("textarea[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		});
	});
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<body> 
<div id="page-wrapper"  >
<div class="content" style="margin-left: 5px; margin-right: 5px; width: auto; ">
<jsp:include page="header.jsp" />
<form name="form1" action="<%=contextPath%>/common/saveINDSTRManualDetails?${_csrf.parameterName}=${_csrf.token}" method="post">
<input type="hidden" name="screen" value="IndianSTR">
<input type="hidden" name="Type" value="saveIndianSTR">
<input type="hidden" name="alertno" value="<%=a_strAlertNo%>">
<div class="col-sm-12">
	<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
		<li class="active"><a data-toggle="tab" href="#reportingEntity">Reporting Entity</a></li>
	    <li><a data-toggle="tab" href="#principalOfficerDetails">Principal Officer Details</a></li>
	    <li><a data-toggle="tab" href="#relatedIndividualsList">Related Individuals List</a></li>
	    <li><a data-toggle="tab" href="#legalEntityName">Legal Entity Name</a></li>
	    <li><a data-toggle="tab" href="#relatedAccountsList">Related Accounts List</a></li>
	    <li><a data-toggle="tab" href="#suspicionDetails">Suspicion Details</a></li>
	    <li><a data-toggle="tab" href="#actionTakenDetails">Action Taken Details</a></li>
	    <li><a data-toggle="tab" href="#accountDetails">Account Details</a></li>
	    <li><a data-toggle="tab" href="#individualDetails">Individual Details</a></li>
	    <li><a data-toggle="tab" href="#legalPersonEntityDetails">Legal Person Entity Details</a></li>
	</ul>
			
	<div class="tab-content compass-tab-content">
		<div role="tabpanel" class="tab-pane fade in active" id="reportingEntity" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="reportingEntityDetails">
							<jsp:include page="reportingEntityDetails.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="principalOfficerDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="principalOfficerDetails">
							<jsp:include page="principalOfficerDetails.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="relatedIndividualsList" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="relatedIndividualsList">
							<jsp:include page="relatedIndividualsList.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="legalEntityName" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="legalEntityName">
							<jsp:include page="legalEntityName.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="relatedAccountsList" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="relatedAccountsList">
							<jsp:include page="relatedAccountsList.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="suspicionDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="suspicionDetails">
							<jsp:include page="suspicionDetails.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="actionTakenDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="actionTakenDetails">
							<jsp:include page="actionTakenDetails.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="accountDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="accountDetails">
							<jsp:include page="annexure/accountDetails/accountDetailsMain.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="individualDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="individualDetails">
							<jsp:include page="annexure/individualDetails/individualDetailsMain.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="legalPersonEntityDetails" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="legalPersonEntityDetails">
							<jsp:include page="annexure/legalPersonEntityDetails/legalPersonEntityDetailsMain.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	<%-- <div class="content">
		<jsp:include page="header.jsp" />
		<form name="form1" action="<%=contextPath%>/common/saveINDSTRManualDetails?${_csrf.parameterName}=${_csrf.token}" method="post">
			<input type="hidden" name="screen" value="IndianSTR">
			<input type="hidden" name="Type" value="saveIndianSTR">
			<input type="hidden" name="alertno" value="<%=a_strAlertNo%>">
			<jsp:include page="reportingEntityDetails.jsp"/>
			<jsp:include page="principalOfficerDetails.jsp"/>
			<jsp:include page="relatedIndividualsList.jsp"/>
			<jsp:include page="legalEntityName.jsp"/>
			<jsp:include page="relatedAccountsList.jsp"/>
			<jsp:include page="suspicionDetails.jsp"/>
			<jsp:include page="actionTakenDetails.jsp"/>
			<div class="mainButtons">
			<input type="button" class="diffButton" value="Post" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
			<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</form>
		</div> --%>
		<div class="mainButtons">
			<input type="button" class="diffButton" value="Post" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
			<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= a_strAlertNo%>')"/>
			<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</form>
		<jsp:include page="instruction.jsp"/>
		<div class="mainButtons">
		<!-- <input type="button" class="diffButton" value="Post" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" /> -->
		<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= a_strAlertNo%>')"/>
		<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= a_strAlertNo%>')"/>
		<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= a_strAlertNo%>')"/>
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div>
	</div>
</div>
</body>
</html>
<% }catch(Exception e){e.printStackTrace(); } %>