<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>

<%
String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
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
else if(groupCode.equalsIgnoreCase("ROLE_AMLUSER")){
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
	
	HashMap hashMapDTO = (HashMap)request.getAttribute("INDIANSTRTRFDETAILS");
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

if(l_strCaseStatus.equals("19") || l_strCaseStatus.equals("6") || l_strCaseStatus.equals("8") || l_strCaseStatus.equals("10"))
{
canExported = "Y";
l_CHttpSession.setAttribute("canExported","Y");
}
else
{
canExported = "N";
}

if(!l_strCaseStatus.equals("5") && !l_strCaseStatus.equals("7") && !l_strCaseStatus.equals("8") && !l_strCaseStatus.equals("11")) 
{
canUpdated = "Y";
// canExported = "Y";

l_CHttpSession.setAttribute("canUpdated","Y");
// l_CHttpSession.setAttribute("canExported","Y");
}
else
{
canUpdated = "N";
// canExported = "N";
}

if(l_strCaseStatus.equals("8") && l_strHierarchyCode.equals("1")) 
{
canUpdated = "Y";
// canExported = "Y";

l_CHttpSession.setAttribute("canUpdated","Y");
// l_CHttpSession.setAttribute("canExported","Y");
}


//System.out.println("In ISTR caseNo: "+caseNo);
//String caseNo = request.getParameter("caseNo").toString();
	request.getSession().setAttribute("caseNo",caseNo);
	String strDisableFlag = request.getParameter("disable") == null? "N":request.getParameter("disable");

	request.setAttribute("ManualFormDTO", (ISTRTRFManualDetailsVO) hashMapDTO.get("ManualFormDTO"));
	request.setAttribute("BranchDetailsDTO", (ArrayList) hashMapDTO.get("BranchDetailsDTO"));
	request.setAttribute("TransactionDetailsDTO", (ArrayList) hashMapDTO.get("TransactionDetailsDTO"));
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
// var win= window.open('<%=contextPath%>/IndianRegulatoryReport/str/addTransactionDetails.jsp?caseNo='+caseNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
var win= window.open('<%=contextPath%>/common/addNewTransactionDetails?caseNo='+caseNo+'&AccountNo='+accno+'&BankName='+bankname+'&BSRCode='+bsrcode+'&CallFrom='+callfrom1,'ADDNEWTRANSACTION',"top=100, height=500, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}

function validate(frm)
{
	frm.submit();
	//alert("submitted");
	window.location.replace('<%=contextPath%>/common/getINDSTRTRFReport?caseNo='+caseNo);
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
 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>STR_TRF</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css"> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>


<link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<%-- <link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" /> --%>
<link rel="StyleSheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />

 <style type="text/css">
.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
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
			 dateFormat : "dd/mm/yy",
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
	
	<div class="content">
		<jsp:include page="header.jsp" />
		<form name="form1" action="<%=contextPath%>/common/saveINDSTRTRFManualDetails?${_csrf.parameterName}=${_csrf.token}" method="post">
			<input type="hidden" name="screen" value="IndianSTRTRF">
			<input type="hidden" name="Type" value="saveIndianSTRTRF">
			<input type="hidden" name="caseNo" value="<%=caseNo%>">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<jsp:include page="reportingEntityDetails.jsp"/>
				<jsp:include page="principalOfficerDetails.jsp"/>
				<jsp:include page="relatedTransactionsList.jsp"/>
				<%-- <div class="clear"/>
				<div class="section" style="height:60px;">
				  <form id="uploadForm" action="<%=contextPath%>/common/uploadINDSTRTransactions?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data"> 
				 <div class="normalTextField left">
						<label>File Upload</label>
						<input type="file"  name="fileupload"  class="txt2"/>
						<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
					</div>
					<div class="normalTextField right" style="top:22px;">
						<!-- <input type="submit" name="uploadTransaction" value="Upload Transaction"> -->
						<input type="button" class="diffButton" id="uploadTransaction" <%if(canUpdated.equals("N")){%> disabled <%}%> value="Upload Transaction"> onClick="uploadTxn('<%= caseNo%>');">
					</div> 
				 </form> 
				</div> 
				<div class="clear"/> --%>
				<jsp:include page="relatedBranchesList.jsp"/>
				<jsp:include page="suspicionDetails.jsp"/>
				<jsp:include page="actionTakenDetails.jsp"/>
				<div class="mainButtons">
				<input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
				<%-- <input type="button" class="diffButton" value="Export XML" <%if(canExported.equals("N")){%> disabled <%}%> onclick="exportXML('<%= caseNo%>')"/> --%>
				<%-- <input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= caseNo%>')"/> --%>
				<input type="button" class="diffButton" value="Export XML" onclick="exportXML('<%= caseNo%>')"/>
				<%-- <input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/> --%>
				<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</form>
		</div>
		<br/>
		<br/>
		<jsp:include page="annexure/transactionDetails/transactionDetailsMain.jsp"/>
		<br/>
		<jsp:include page="annexure/branchDetails/branchDetailsMain.jsp"/>
		<br/>
		
		<jsp:include page="instruction.jsp"/>
		<div class="mainButtons">
		<input type="button" class="diffButton" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
		<%-- <input type="button" class="diffButton" value="Export XML" <%if(canExported.equals("N")){%> disabled <%}%> onclick="exportXML('<%= caseNo%>')"/> --%>
		<input type="button" class="diffButton" value="Export XML" <%=exportXMLDisabled%> onclick="exportXML('<%= caseNo%>')"/>
		<%-- <input type="button" class="diffButton" value="Export GOS" onclick="exportGOS('<%= caseNo%>')"/> --%>
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div>
		
	</div>

</body>
</html>
<% }catch(Exception e){e.printStackTrace(); } %>