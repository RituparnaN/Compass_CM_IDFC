<%@ page import = "java.util.*, com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRAccountDetailsVO" %> 
<%
try{
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String message = request.getAttribute("message") == null ? "" : request.getAttribute("message").toString();
HttpSession l_CHttpSession = request.getSession(true);

String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
String readOnly = "disabled";
String disabled = "readonly";
if(canUpdated.equals("Y")){
	readOnly = "";
	disabled = "";
}

String strModeOfTransactions = "";
String strDebitOrCredit = "";
String strTransactionNo = "";
String strBankName = request.getParameter("BankName");
String strBSRCode = request.getParameter("BSRCode");
String strTransactionDetailsRemarks = "";

HashMap hmTransactionDetails = null;
ISTRAccountDetailsVO objISTRTranDetailsVO = null;
if((HashMap)request.getAttribute("HmDto")!=null)
	hmTransactionDetails = (HashMap)request.getAttribute("HmDto");
if(hmTransactionDetails != null)
{
	objISTRTranDetailsVO = (ISTRAccountDetailsVO)hmTransactionDetails.get("ALTranDetailsDTO");
	if(objISTRTranDetailsVO != null)
	{
		strModeOfTransactions = (String)objISTRTranDetailsVO.getTransactiondetailsmode();	
		strDebitOrCredit = (String)objISTRTranDetailsVO.getTransactiondetailsDebit();
		strTransactionNo = objISTRTranDetailsVO.getTransactionNo()== null ? "" : objISTRTranDetailsVO.getTransactionNo();
		strTransactionDetailsRemarks = objISTRTranDetailsVO.getTransactiondetailsRemarks() == null ? "" : objISTRTranDetailsVO.getTransactiondetailsRemarks().trim();
	}
		
}	
String l_strAccountNo = (String)request.getParameter("AccountNo");
if(objISTRTranDetailsVO !=null && objISTRTranDetailsVO.getAccountNo() !=null) l_strAccountNo=objISTRTranDetailsVO.getAccountNo();
%>
<html>
<head><title>AddNewTransactions</title>
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
<%
	String IsSaved = request.getAttribute("IsSaved") == null ? "N":(String) request.getAttribute("IsSaved");
	if(IsSaved!=null && IsSaved.equalsIgnoreCase("Yes")){
%>
	<script>
	alert('Transaction has been added to the list');
	var caseNo = '<%=caseNo%>';
	window.opener.location.reload();
	window.close();
    </script>
<%}%>


<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
  <script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script> --%>

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css"> --%>
<script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
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
	/* #chTransactionDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#fromDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	#toDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} */
</style>
<script type="text/javascript">
	$(document).ready(function(){
		/* $( "#chTransactionDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 }); 
		$( "#fromDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		 $( "#toDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 }); */
		 $(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });

		 var message = "<%out.print(message);%>";
		 if(message != ""){
			 alert(message);
			 window.opener.location.reload();
			 window.close();
		 }
	});
</script>

<script language="javascript">
<!--
function setValues()
{
	var frm = document.NewTransactionDetails;
	//var checkFields = "false";
	var caseNo = '<%=(String)(request.getSession(true).getAttribute("caseNo"))%>';	
	var ACCNO = frm.AccountNo.value;
	var checkFields = "true";
	if(checkFields==false)
	{
		return false;
	}
	else
	{
		frm.ModeOfTransaction.value=frm.ModeOfTransactionGroup.value;
		frm.DebitCredit.value=frm.DebitCreditGroup.value;
		//alert('frm.ModeOfTransaction.value:  '+frm.ModeOfTransaction.value);	
		var con = confirm('Do you want to save the data');
		if(con)
		{			
			frm.submit();	
			alert('Request Submitted');
		}
	}
}
-->
</script>
<script type="text/javascript">
function autoSaveTransaction(actionType){
	var form = document.AutoSaveTransaction;
	form.SaveOrDelete.value = actionType;
	form.SaveButton.disabled = true;
	form.DeleteButton.disabled = true;
	/*
	var caseNo = form.caseNo.value;
	var ACCNO = form.accountNumber.value;
	var FromDate = form.fromDate.value;
	var ToDate = form.toDate.value;

	alert("From Date : "+FromDate+"\n ToDate : "+ToDate+" \n AccNO : "+ACCNO+"\n Alert No : "+caseNo);
	*/
	form.submit();
	}
	
	</script>
</head>
<body>

<div class="section">

<form name="NewTransactionDetails" action="<%=contextPath%>/common/saveNewINDSTRTransaction?${_csrf.parameterName}=${_csrf.token}" method="post">
<input type="hidden"  name="NameOfBank"  value='<%=strBankName%>'>
<input type="hidden"  name="BSRCode"  value='<%=strBSRCode%>'>
<input type="hidden"  name="TransactionNo"  value='<%=strTransactionNo%>'>



	<div class="normalTextField">
		<label>Account number</label>
		<input type="text" name="AccountNo" <%=readOnly%>  value="<%=l_strAccountNo%>" class="txt2">
	</div>
	<div class="normalTextField">
		<label>Date of Transaction</label>
		<input type="text" class="topOpenTextBox datepicker" id="chTransactionDate" name="chTransactionDate" <%=readOnly%> value="<%=(objISTRTranDetailsVO==null || objISTRTranDetailsVO.getTransactiondetailsdate()==null)?"":objISTRTranDetailsVO.getTransactiondetailsdate()%>" />
	</div>
	<div class="normalTextField">
		<label>Mode Of Transaction</label>
		<select name="ModeOfTransactionGroup" <%=disabled%>>
				<option value="A" title="Cheque Clearing" <% if(strModeOfTransactions.equals("A")) {%>selected<% } %>>A - Cheque Clearing</option>
				<option value="B" title="Internal Transaction" <% if(strModeOfTransactions.equals("B")) {%>selected<% } %>>B - Internal Transaction</option>
				<option value="C" title="Cash" <% if(strModeOfTransactions.equals("C")) {%>selected<% } %>>C - Cash</option>
				<option value="D" title="Demand Draft / Pay Order" <% if(strModeOfTransactions.equals("D")) {%>selected<% } %>>D - Demand Draft / Pay Order</option>
				<option value="E" title="Electronic Fund Transfer" <% if(strModeOfTransactions.equals("E")) {%>selected<% } %>>E - Electronic Fund Transfer</option>
				<option value="F" title="Exchange Based Transfer" <% if(strModeOfTransactions.equals("F")) {%>selected<% } %>>F - Exchange Based Transfer</option>
				<option value="G" title="Securities Transaction" <% if(strModeOfTransactions.equals("G")) {%>selected<% } %>>G - Securities Transaction</option>
				<option value="S" title="Switching Transaction" <% if(strModeOfTransactions.equals("S")) {%>selected<% } %>>S - Switching Transaction</option>
				<option value="X" title="Not Categorised" <% if(strModeOfTransactions.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
				<option value="Z" title="Others" <% if(strModeOfTransactions.equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>Debit/Credit</label>
		<select name="DebitCreditGroup" <%=disabled%>>
				<option value="C" title="Credit" <% if(strDebitOrCredit.equals("A")) {%>selected<% } %>>C - Credit</option>
				<option value="D" title="Debit" <% if(strDebitOrCredit.equals("B")) {%>selected<% } %>>D - Debit</option>
		</select>
	</div>
	<%
		String strTransactionAmount = "";
		strTransactionAmount = (objISTRTranDetailsVO==null || objISTRTranDetailsVO.getTransactiondetailsAmount() == null) ? "" : objISTRTranDetailsVO.getTransactiondetailsAmount();
	%>
	<div class="normalTextField">
		<label>Amount(As Per Of Indian currency)</label>
		<input type="text"  name="chTranAmount" <%=readOnly%> value="<%=strTransactionAmount%>" class="txt2" size=30 maxlength=30/>
	</div>
	<div class="normalTextField">
		<label>Remarks</label>
		<input type="text"  name="Remarks"  <%=readOnly%> value="<%=strTransactionDetailsRemarks%>" class="txt2"/>
	</div>
	<div class="mainButtons">
		<input type="hidden" name="ModeOfTransaction" value="">
		<input type="hidden" name="DebitCredit" value="">
		<input type="button" value="Save" <%=disabled%> onclick="setValues()"  class="diffButton"/>
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
	</div>
</form>


</div>

<div class="clear"/>

<div class="section" style="height:60px;">
<form action="<%=contextPath%>/common/uploadINDSTRTransactions?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
<div class="normalTextField left">
		<label>File Upload</label>
		<input type="file"  name="fileupload"  class="txt2"/>
		<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
		<input type="hidden" name="BankName" value="<%=strBankName%>"/>
		<input type="hidden" name="BSRCode" value="<%=strBSRCode%>"/>
		<input type="hidden" name="AccountNo" value="<%=l_strAccountNo%>"/>
	</div>
	<div class="normalTextField right" style="top:22px;">
		<input type="submit" name="uploadTransaction" <%=disabled%> value="Upload Transaction">
	</div>
</form>
</div>

<div class="clear"/>

<div class="section">
<form name="AutoSaveTransaction" action="<%=contextPath%>/common/autoSaveINDSTRTransactions?${_csrf.parameterName}=${_csrf.token}" method="post">
	<div class="normalTextField">
		<label>From Date</label>
		<input type="text"  name="fromDate" id="fromDate" class="txt2 datepicker"/>
	</div>
	<div class="normalTextField">
		<label>To Date</label>
		<input type="text"  name="toDate" id="toDate" class="txt2 datepicker"/>
	</div>
	<div class="normalTextField">
		<label>Account Number</label>
		<input type="text"  name="accountNumber" value="<%=l_strAccountNo%>" class="txt2"/>
	</div>
	<div class="mainButtons">
		<input type="hidden" name="BankName" value="<%=strBankName%>"/>
		<input type="hidden" name="BSRCode" value="<%=strBSRCode%>"/>
		<input type="hidden" name="SaveOrDelete" value=""/>
		<input type="hidden" name="caseNo" value="<%=(String)(request.getSession(true).getAttribute("caseNo"))%>"/>
		<input type="button" name="SaveButton" value="Save" <%=disabled%> onclick="autoSaveTransaction('Save')" class="diffButton"/>
		<input type="button" name="DeleteButton" value="Delete" <%=disabled%> onclick="autoSaveTransaction('Delete')" class="diffButton"/>
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
	</div>
</form>
</div>
</body>
</html>

<%}catch(Exception e){e.printStackTrace();}%>
