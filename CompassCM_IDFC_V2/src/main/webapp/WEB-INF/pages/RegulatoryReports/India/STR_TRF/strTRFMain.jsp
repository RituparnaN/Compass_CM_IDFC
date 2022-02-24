<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>

<%
String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
String currentUserRole = groupCode.replaceAll("ROLE_","");

String contextPath = request.getContextPath()==null?"":request.getContextPath();
HttpSession l_CHttpSession = request.getSession(true);
String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
String l_strCaseStatus = "";
String l_strHierarchyCode = "";
//int l_intCaseStatus = 1;
try
{

//l_strCaseStatus = "6";
//System.out.println("l_intCaseStatus : "+l_intCaseStatus);

if(groupCode.equalsIgnoreCase("ROLE_USER")){
	l_strHierarchyCode = "4";
}
else if(groupCode.contains("ROLE_AMLUSER")){
	l_strHierarchyCode = "3";
}
else if(groupCode.equalsIgnoreCase("ROLE_AMLO")){
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
	System.out.println("caseNo : "+caseNo);
	HashMap hashMapDTO = (HashMap)request.getAttribute("INDIANSTRTRFDETAILS");
	String strSavedFlag = (String)request.getAttribute("saved");
	String strSaveButtonFlag = request.getParameter("saveButton");
	HashMap CaseStatusDetails = (HashMap)hashMapDTO.get("CaseStatusDetails");
	
	String strCaseStatus = CaseStatusDetails.get("CASESTATUS").toString();
	String strCaseUserCode = CaseStatusDetails.get("USERCODE").toString();
	String strCaseUserRole = CaseStatusDetails.get("USERROLE").toString();

	String strPreviousCaseStatus = CaseStatusDetails.get("PREVIOUS_CASESTATUS") == null ? "":CaseStatusDetails.get("PREVIOUS_CASESTATUS").toString();
	String strPreviousCaseUserCode = CaseStatusDetails.get("PREVIOUS_USERCODE") == null ? "":CaseStatusDetails.get("PREVIOUS_USERCODE").toString();
	String strPreviousCaseUserRole = CaseStatusDetails.get("PREVIOUS_USERROLE") == null ? "":CaseStatusDetails.get("PREVIOUS_USERROLE").toString();
	String strCurrentCaseStatus = CaseStatusDetails.get("CURRENT_CASESTATUS") == null ? "":CaseStatusDetails.get("CURRENT_CASESTATUS").toString();
	String strCurrentCaseUserCode = CaseStatusDetails.get("CURRENT_USERCODE") == null ? "":CaseStatusDetails.get("CURRENT_USERCODE").toString();
	String strCurrentCaseUserRole = CaseStatusDetails.get("CURRENT_USERROLE") == null ? "":CaseStatusDetails.get("CURRENT_USERROLE").toString();
	String strIsManualCase = CaseStatusDetails.get("ISMANUALCASE") == null ? "":CaseStatusDetails.get("ISMANUALCASE").toString();
	String strCaseSubAction = CaseStatusDetails.get("CASESTATUS_SUBACTION") == null ? "":CaseStatusDetails.get("CASESTATUS_SUBACTION").toString();

	String exportXMLDisabled = "disabled";
	exportXMLDisabled = "";
	if(strCaseUserRole.equalsIgnoreCase("ROLE_AMLREP") && (strCaseStatus.equals("10")||strCaseStatus.equals("37"))) {
		exportXMLDisabled = "";
	}
	
	System.out.println("l_strHierarchyCode : "+l_strHierarchyCode+" , strCaseStatus: "+strCaseStatus);
	System.out.println("currentUserRole : "+currentUserRole+" , strCurrentCaseStatus: "+strCurrentCaseStatus+" , strCurrentCaseUserRole:"+strCurrentCaseUserRole);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String canExported = l_CHttpSession.getAttribute("canExported") == null ?"N":(String)l_CHttpSession.getAttribute("canExported");

	/*
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
	System.out.println("l_strHierarchyCode : "+l_strHierarchyCode+" , strCaseStatus: "+strCaseStatus+" , canUpdated: "+canUpdated);	
	}
	else
	{
	canUpdated = "N";
	}
	*/
	if(currentUserRole.equalsIgnoreCase(strCurrentCaseUserRole) && strCurrentCaseStatus.equals("P"))
	{
	canExported = "Y";
	l_CHttpSession.setAttribute("canExported","Y");
	}
	else
	{
	canExported = "N";
	}

	if(currentUserRole.equalsIgnoreCase(strCurrentCaseUserRole) && strCurrentCaseStatus.equals("P"))
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


	//System.out.println("In ISTR caseNo: "+caseNo);
	//String caseNo = request.getParameter("caseNo").toString();
	request.getSession().setAttribute("caseNo",caseNo);
	String strDisableFlag = request.getParameter("disable") == null? "N":request.getParameter("disable");

	request.setAttribute("ManualFormDTO", (ISTRTRFManualDetailsVO) hashMapDTO.get("ManualFormDTO"));
	request.setAttribute("BranchDetailsDTO", (ArrayList) hashMapDTO.get("BranchDetailsDTO"));
	request.setAttribute("TransactionDetailsDTO", (ArrayList) hashMapDTO.get("TransactionDetailsDTO"));
	request.setAttribute("ALIndvDetailsDTO", (ArrayList) hashMapDTO.get("ALIndvDetailsDTO"));
	request.setAttribute("ALLegPerDetailsDTO", (ArrayList) hashMapDTO.get("ALLegPerDetailsDTO"));
	request.setAttribute("AlertIndicatorsList", (ArrayList) hashMapDTO.get("AlertIndicatorsList"));
	request.setAttribute("disable",strDisableFlag);
	
%> 
<script language="javascript">

var acctNo;
var TranNo;
function addNewTransaction(accno,bankname,bsrcode)
{
var callfrom1 = '';
var caseNo = '<%= caseNo%>';
<%-- var win= window.open('<%=contextPath%>/IndianRegulatoryReport/str/addTransactionDetails.jsp?caseNo='+caseNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no"); --%>
var win= window.open('<%=contextPath%>/common/addNewTransactionDetails?caseNo='+caseNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}

function validate(frm)
{
	var serializeData = $(frm).serialize();
	console.log(serializeData);
	var caseNo = '<%= caseNo%>';
	
	frm.submit();
	//alert("submitted");
	//window.location.replace('<%=contextPath%>/common/getINDSTRTRFReport?caseNo='+caseNo);
}
function exportXML(strcaseNo){
	if(confirm("Do you want to save this STR as XML ?")){
		window.open('<%=contextPath%>/common/INDSTRTRFExportXML?caseNo='+strcaseNo);
	}
}

function exportGOS(strcaseNo){
	if(confirm("Do you want to generate GOS Word Document ?")){
		// window.open('<%=contextPath%>/INDSTRExportXML?caseNo='+strcaseNo);
		window.open('<%=contextPath%>/common/GroundOfSuspicionForSTRTRFTemplateDOC?primaryCustomerId=N.A.&secondaryCustomerId=N.A.&accountNumbers=N.A.&templateId=N.A.&fromDate=N.A.&toDate=N.A.&caseNo='+strcaseNo,'GOSDOC','height=200, width=200, resizable=Yes, scrollbars=Yes');
	}
}

function uploadTxn(strcaseNo){
	alert(strcaseNo);
	if(confirm("Do you want to upload the file?")){
		window.open('<%=contextPath%>/common/uploadINDSTRTransactions?caseNo='+strcaseNo);
		alert("doen");
		<%-- window.location.replace('<%=contextPath%>/common/getINDSTRTRFReport?caseNo='+caseNo); --%>
	}
}

</script>
 
 <script language="javascript">
	function countChar(val, field) {	
	  var max = 4000;
	  var len = val.value.length;
	  var remainingChars = max - len;
	  if (len >= max) {
		alert('You have reached the limit of '+max+' characters.');
		if(field == 'Part8susGrounds0')
	    	$('#charsDOI').text('You have reached the limit of '+max+' characters.');
		else
			$('#charsGOS').text('You have reached the limit of '+max+' characters.');
	  }else {
		  if(field == 'Part8susGrounds0') { 
	    	$('#charsDOI').text(remainingChars+' character(s) remaining out of '+max);
		  } else{
			$('#charsGOS').text(remainingChars+' character(s) remaining out of '+max);
		  }
	  } 
	}
	//});
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>STR_TRF</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css"> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>


<link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />

 <style type="text/css">
.datepicker{
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
  <!-- <style type="text/css">
	#batchDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} -->
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".datepicker").datepicker({
			 dateFormat : "yy-mm-dd",
			 changeMonth: true,
		     changeYear: true
		 });
		/* $( "#batchDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 }); */
		$("input[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		 });
		$("textarea[readonly]").mouseover(function(){
			$(this).attr('title','readOnly value');
		});
		
		/* $("#uploadTransaction").click(function(){
			var caseNo = '${caseNo}'; 
			$.ajax({
				url: "${pageContext.request.contextPath}/common/uploadINDSTRTRFTransactions?caseNo="+caseNo,
				cache:	false,
				type: "POST",
				contentType: false,
		        processData: false,
		        enctype : "multipart/form-data",
				success: function(response){
					alert(response);
				},
				error: function(a,b,c){
					alert(a+", "+ b+", "+c);
				} 
			});
		});		 */
	});
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<body>
<div id="page-wrapper"  >
<div class="content" style="margin-left: 5px; width: 1510px; ">
<jsp:include page="header.jsp" />
<form name="form1" action="<%=contextPath%>/common/saveINDSTRTRFManualDetails?${_csrf.parameterName}=${_csrf.token}" method="post">
<input type="hidden" name="screen" value="IndianSTRTRF">
<input type="hidden" name="Type" value="saveIndianSTRTRF">
<input type="hidden" name="caseNo" value="<%=caseNo%>">
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
<div class="col-sm-12">
	<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
		<li class="active"><a class="nav-link active" data-toggle="tab" href="#reportingEntity">Reporting Entity</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#principalOfficerDetails">Principal Officer Details</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#relatedTransactionsList">Related Transactions List</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#relatedBranchesList">Related Branches List</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#relatedIndividualsList">Related Individuals List</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#relatedLegalEntityList">Related Legal Persons/Entities List</a></li>	    
	    <li><a class="nav-link" data-toggle="tab" href="#suspicionDetails">Suspicion Details</a></li>
	    <li><a class="nav-link" data-toggle="tab" href="#actionTakenDetails">Action Taken Details</a></li>
	    <!-- <li><a data-toggle="tab" href="#transactionDetails">Individual Details</a></li>
	    <li><a data-toggle="tab" href="#branchDetails">Individual Details</a></li>
	    <li><a data-toggle="tab" href="#individualDetails">Individual Details</a></li>
	    <li><a data-toggle="tab" href="#legalPersonEntityDetails">Legal Person Entity Details</a></li> -->
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
		<div role="tabpanel" class="tab-pane fade" id="relatedTransactionsList" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="relatedTransactionsList">
							<jsp:include page="relatedTransactionsList.jsp"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane fade" id="relatedBranchesList" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="#relatedBranchesList">
							<jsp:include page="relatedBranchesList.jsp"/>
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
		<div role="tabpanel" class="tab-pane fade" id="relatedLegalEntityList" >
			<div class="row">
				<div class="col-sm-12">
					<div class="card card-primary">
						<div id="relatedLegalEntityList">
							<jsp:include page="relatedLegalEntityList.jsp"/>
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
		<%-- <div role="tabpanel" class="tab-pane fade" id="accountDetails" >
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
		</div> --%>
	</div>
				<%-- <jsp:include page="reportingEntityDetails.jsp"/>
				<jsp:include page="principalOfficerDetails.jsp"/>
				<jsp:include page="relatedTransactionsList.jsp"/>
				<jsp:include page="relatedBranchesList.jsp"/>
				<jsp:include page="relatedIndividualsList.jsp"/>
				<jsp:include page="relatedLegalEntityList.jsp"/>
				<jsp:include page="suspicionDetails.jsp"/>
				<jsp:include page="actionTakenDetails.jsp"/>
				<div class="mainButtons">
				<input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
				<input type="button" class="diffButton" value="Export XML" onclick="exportXML('<%= caseNo%>')"/>
				<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</form>
		</div>
		<br/>
		<br/>
		<jsp:include page="annexure/transactionDetails/transactionDetailsMain.jsp"/>
		<br/>
		<jsp:include page="annexure/branchDetails/branchDetailsMain.jsp"/>
		<br/>
		
		<jsp:include page="instruction.jsp"/> --%>
</div>
		<%-- <div class="mainButtons">
		<!-- <input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" /> -->
		<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= caseNo%>')"/>
		<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/>
		<!--<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= caseNo%>')"/>-->
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div> --%>
		
		<div class="mainButtons">
			<input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
			<%-- <input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= caseNo%>')"/> --%>
			<input type="button" class="diffButton" value="Export XML" onclick="exportXML('<%= caseNo%>')"/>
			<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/>
			<!--<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= caseNo%>')"/>-->
			<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</form>
		<jsp:include page="instruction.jsp"/>
		<div class="mainButtons">
		<!-- <input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" /> -->
		<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= caseNo%>')"/>
		<input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/>
		<!--<input type="button" class="diffButton" value="Export Exception Report" onclick="exportExceptionReport('<%= caseNo%>')"/>-->
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div>
		
	</div>
</div>
</body>
</html>
<% }catch(Exception e){e.printStackTrace(); } %>