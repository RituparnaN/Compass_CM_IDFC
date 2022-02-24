<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%@ page import = "java.util.*, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %> 
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

HashMap hmTransactionDetails = null;
ISTRTRFTransactionDetailsVO objISTRTranDetailsVO = null;

if((HashMap)request.getAttribute("HmTxnDTO")!=null)
	hmTransactionDetails = (HashMap)request.getAttribute("HmTxnDTO");

String strBankName 	= "";
String strTransactionDate 	=  "";
String strTransactionTime 	= "";
String strTransactionRefNo 	= "";
String strTransactionType 	= "";
String strInstrumentType  = "";
String strTransactionInstitutionName  = "";
String strTransactionInstitutionRefNo = "";
String strTransactionStateCode 	= "";
String strTxnCountryCode 	= "";
String strTransactionAmount	= "";
String strTransactionAmountForeignCurr 	= "";
String strTransactionCurrency 	= "";
String strTransactionPurpose  = "";
String strRiskRating = "";
String strPaymentInstrumentNo 	= "";
String strPaymentInstrumentIssueInstName	=  "";
String strCustomerName 	= "";
String strOccupation 	= "";
String strDateofBirth 	= "";
String strGender	  = "";
String strNationality  = "";
String strCustIDType = "";
String strCustIDNo 	= "";
String strCustIDIssuingAuthority 	= "";
String strCustIDIssuingPlace	= "";
String strCustPAN 	= "";
String strCustUIN = "";
String strCustAddress 	= "";
String strCustCity  = "";
String strCustState = "";
String strCustCountry 	= "";
String strCustPIN 	= "";
String strCustTelephone	  = "";
String strCustMobile  = "";
String strCustFAX = "";
String strCustEmail 	= "";
String strAccountNo 	= "";
String strAccountInstName	= "";
String strInstRefNo 	= "";
String strRelatedInstName 	= "";
String strRelatedInstFlag  = "";
String strTxnRemarks = "";
String strTxnSeqNo = "";

if((HashMap)request.getAttribute("HmAddNewTxnDTO")!=null)
	hmTransactionDetails = (HashMap)request.getAttribute("HmAddNewTxnDTO");

if(hmTransactionDetails!=null)
{
	objISTRTranDetailsVO = (ISTRTRFTransactionDetailsVO)hmTransactionDetails.get("TransactionDetailsDTO");
}

if(objISTRTranDetailsVO != null){
	strBankName  = (objISTRTranDetailsVO.getNameOfBank() ==	null) ? "" : objISTRTranDetailsVO.getNameOfBank();
	strTransactionDate = (objISTRTranDetailsVO.getTransactionDate() ==	null) ? "" : objISTRTranDetailsVO.getTransactionDate();
	strTransactionTime = (objISTRTranDetailsVO.getTransactionTime() ==	null) ? "" : objISTRTranDetailsVO.getTransactionTime();
	strTransactionRefNo	= (objISTRTranDetailsVO.getTransactionNo() ==	null) ? "" : objISTRTranDetailsVO.getTransactionNo();
	strTransactionType	= (objISTRTranDetailsVO.getTransactionType() ==	null) ? "" : objISTRTranDetailsVO.getTransactionType();
	strInstrumentType 	= (objISTRTranDetailsVO.getInstrumentType() ==	null) ? "" : objISTRTranDetailsVO.getInstrumentType();
	strTransactionInstitutionName 	= (objISTRTranDetailsVO.getTransactionInstitutionName() ==	null) ? "" : objISTRTranDetailsVO.getTransactionInstitutionName();
	strTransactionInstitutionRefNo 	= (objISTRTranDetailsVO.getTransactionInstitutionRefNo() ==	null) ? "" : objISTRTranDetailsVO.getTransactionInstitutionRefNo();
	strTransactionStateCode = (objISTRTranDetailsVO.getTransactionStateCode() ==	null) ? "" : objISTRTranDetailsVO.getTransactionStateCode();
	strTxnCountryCode	= (objISTRTranDetailsVO.getTransactionCountryCode() ==	null) ? "" : objISTRTranDetailsVO.getTransactionCountryCode();
	strTransactionAmount 	= (objISTRTranDetailsVO.getTransactionAmount() ==	null) ? "" : objISTRTranDetailsVO.getTransactionAmount();
	strTransactionAmountForeignCurr	= (objISTRTranDetailsVO.getTransactionAmtInForeignCurr() ==	null) ? "" : objISTRTranDetailsVO.getTransactionAmtInForeignCurr();
	strTransactionCurrency 	= (objISTRTranDetailsVO.getTransactionCurrencyCode() ==	null) ? "" : objISTRTranDetailsVO.getTransactionCurrencyCode();
	strTransactionPurpose 	= (objISTRTranDetailsVO.getPurposeOfTransaction() ==	null) ? "" : objISTRTranDetailsVO.getPurposeOfTransaction();
	strRiskRating  = (objISTRTranDetailsVO.getRiskRating() ==	null) ? "" : objISTRTranDetailsVO.getRiskRating();
	strPaymentInstrumentNo = (objISTRTranDetailsVO.getPaymentInstrumentNo() ==	null) ? "" : objISTRTranDetailsVO.getPaymentInstrumentNo();
	strPaymentInstrumentIssueInstName = (objISTRTranDetailsVO.getPaymentInstrumentInstName() ==	null) ? "" : objISTRTranDetailsVO.getPaymentInstrumentInstName();
	strCustomerName	= (objISTRTranDetailsVO.getCustomerName() ==	null) ? "" : objISTRTranDetailsVO.getCustomerName();
	strOccupation	= (objISTRTranDetailsVO.getOccupation() ==	null) ? "" : objISTRTranDetailsVO.getOccupation();
	strDateofBirth 	= (objISTRTranDetailsVO.getDateOfBirth() ==	null) ? "" : objISTRTranDetailsVO.getDateOfBirth();
	strGender 	= (objISTRTranDetailsVO.getGender() ==	null) ? "" : objISTRTranDetailsVO.getGender();
	strNationality 	= (objISTRTranDetailsVO.getNationality() ==	null) ? "" : objISTRTranDetailsVO.getNationality();
	strCustIDType = (objISTRTranDetailsVO.getIdentificationType() ==	null) ? "" : objISTRTranDetailsVO.getIdentificationType();
	strCustIDNo	= (objISTRTranDetailsVO.getIdentificationNo() ==	null) ? "" : objISTRTranDetailsVO.getIdentificationNo();
	strCustIDIssuingAuthority 	= (objISTRTranDetailsVO.getIssuingAuthority() ==	null) ? "" : objISTRTranDetailsVO.getIssuingAuthority();
	strCustIDIssuingPlace	= (objISTRTranDetailsVO.getIssuingPlace() ==	null) ? "" : objISTRTranDetailsVO.getIssuingPlace();
	strCustPAN 	= (objISTRTranDetailsVO.getPanNo() ==	null) ? "" : objISTRTranDetailsVO.getPanNo();
	strCustUIN 	= (objISTRTranDetailsVO.getUinNo() ==	null) ? "" : objISTRTranDetailsVO.getUinNo();
	strCustAddress  = (objISTRTranDetailsVO.getAddressLine() ==	null) ? "" : objISTRTranDetailsVO.getAddressLine();
	strCustCity = (objISTRTranDetailsVO.getCity() ==	null) ? "" : objISTRTranDetailsVO.getCity();
	strCustState = (objISTRTranDetailsVO.getState() ==	null) ? "" : objISTRTranDetailsVO.getState();
	strCustCountry	= (objISTRTranDetailsVO.getCountry() ==	null) ? "" : objISTRTranDetailsVO.getCountry();
	strCustPIN	= (objISTRTranDetailsVO.getPinCode() ==	null) ? "" : objISTRTranDetailsVO.getPinCode();
	strCustTelephone 	= (objISTRTranDetailsVO.getTelephone() ==	null) ? "" : objISTRTranDetailsVO.getTelephone();
	strCustMobile 	= (objISTRTranDetailsVO.getMobile() ==	null) ? "" : objISTRTranDetailsVO.getMobile();
	strCustFAX 	= (objISTRTranDetailsVO.getFax() ==	null) ? "" : objISTRTranDetailsVO.getFax();
	strCustEmail = (objISTRTranDetailsVO.getEmailId() ==	null) ? "" : objISTRTranDetailsVO.getEmailId();
	strAccountNo	= (objISTRTranDetailsVO.getAccountNo() ==	null) ? "" : objISTRTranDetailsVO.getAccountNo();
	strAccountInstName	= (objISTRTranDetailsVO.getAccountWithInstitutionName() ==	null) ? "" : objISTRTranDetailsVO.getAccountWithInstitutionName();
	strInstRefNo	= (objISTRTranDetailsVO.getRelatedInstitutionRefNo() ==	null) ? "" : objISTRTranDetailsVO.getRelatedInstitutionRefNo();
	strRelatedInstName 	= (objISTRTranDetailsVO.getRelatedInstitutionName() ==	null) ? "" : objISTRTranDetailsVO.getRelatedInstitutionName();
	strRelatedInstFlag 	= (objISTRTranDetailsVO.getInstitutionRelationFlag() ==	null) ? "" : objISTRTranDetailsVO.getInstitutionRelationFlag();
	strTxnRemarks 	= (objISTRTranDetailsVO.getTransactionRemarks() ==	null) ? "" : objISTRTranDetailsVO.getTransactionRemarks();
	strTxnSeqNo = (objISTRTranDetailsVO.getTransactionSeqNo() ==	null) ? "" : objISTRTranDetailsVO.getTransactionSeqNo();
}

	String l_disable =(String) request.getAttribute("disable");	
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
	//window.opener.location.reload();
	window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRTRFReport?caseNo="+caseNo+"&canUpdated=Y&canExported=N");
	window.close();
    </script>
<%}%>


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

	/* #transactionDate, #fromDate, #toDate, #dob{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} */
  </style> 
<script type="text/javascript">
	$(document).ready(function(){
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		/* $( "#transactionDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		 $( "#fromDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		 $( "#toDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
		 $( "#dob" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 }); */
		 var message = "<%out.print(message);%>";
		 if(message != ""){
			 alert(message);
			 window.opener.location.reload();
			 window.close();
		 }
	});
	
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
<div class="content">
<form name="NewTransactionDetails" action="<%=contextPath%>/common/saveNewINDSTRTRFTransaction?${_csrf.parameterName}=${_csrf.token}" method="post">
<input type="hidden" name="caseNo" value="<%=caseNo%>">	
<input type="hidden" name="txnSeqNo" value="<%=strTxnSeqNo%>">
<div class="header">
	<table class="header-table">
		<tr>
			<td class="leftside">
				<div class="HeaderText">Transaction Details</div>
				</td>
				<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>TRN</li>
					<li class="last">1</li>
				</ul>
			</td>
		</tr>
	</table>
</div>

<div class="section" style="height : auto;">
	<div class="normalTextField">
		<label>1. Name of Reporting Entity</label>
		<input type="text" name="reportingEntity" class="txt2" value="<%=strBankName%>">
	</div>
	<div class="normalTextField">
		<label>2. Transaction Date</label>
		<input type="text" class="topOpenTextBox datepicker" id="transactionDate" name="transactionDate" placeholder="YYYY-MM-DD" <%=readOnly%> value="<%=strTransactionDate%>"/>
	</div>
	<div class="normalTextField">
		<label>3. Transaction Time</label>
		<input type="text"  name="transactionTime" placeholder="hh:mm" <%=readOnly%> value="<%=strTransactionTime%>" class="topOpenTextBox" size=12 maxlength=12 id="transactionTime"/>
	</div>
	<div class="normalTextField">
		<label>4. Transaction Reference Number</label>
		<input type="text" name="transactionRefNo" value="<%=strTransactionRefNo%>" class="txt2" size=30 maxlength=30/>
	</div>
	<div class="normalTextField">
		<label>5. Transaction Type</label>
		<select name="transactionType">
			<option value="P" title="Purchase" <% if(strTransactionType.equals("P")) {%>selected<% } %>>P - Purchase</option>
			<option value="R" title="Redemption" <% if(strTransactionType.equals("R")) {%>selected<% } %>>R - Redemption</option>	
		</select>
	</div>
	<div class="normalTextField">
		<label>6. Instrument Type</label>
		<select name="instrumentType" <%=disabled%>>
			<option value="A" <% if(strInstrumentType.equals("A")) {%>selected<% } %>>A - Currency Note</option>
			<option value="B" <% if(strInstrumentType.equals("B")) {%>selected<% } %>>B - Travellers Cheque</option>
			<option value="C" <% if(strInstrumentType.equals("C")) {%>selected<% } %>>C - Demand Draft</option>
			<option value="D" <% if(strInstrumentType.equals("D")) {%>selected<% } %>>D - Money Order</option>
			<option value="E" <% if(strInstrumentType.equals("E")) {%>selected<% } %>>E - Wire Transfers / TT</option>
			<option value="F" <% if(strInstrumentType.equals("F")) {%>selected<% } %>>F - Money Transfer</option>
			<option value="G" <% if(strInstrumentType.equals("G")) {%>selected<% } %>>G - Credit card</option>
			<option value="H" <% if(strInstrumentType.equals("H")) {%>selected<% } %>>H - Debit card</option>
			<option value="I" <% if(strInstrumentType.equals("I")) {%>selected<% } %>>I - Smart card</option>
			<option value="J" <% if(strInstrumentType.equals("J")) {%>selected<% } %>>J - Prepaid card</option>	
			<option value="K" <% if(strInstrumentType.equals("K")) {%>selected<% } %>>K - Gift card</option>
			<option value="L" <% if(strInstrumentType.equals("L")) {%>selected<% } %>>L - Cheque</option>
			<option value="X" <% if(strInstrumentType.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
			<option value="Z" <% if(strInstrumentType.equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>7. Transaction Institution Name</label>
		<input type="text"  name="transactionInstName"  value="<%=strTransactionInstitutionName%>" class="txt2" size=30 maxlength=30/>
	</div>
	<div class="normalTextField">
		<label>8. Transaction Institution Reference Number</label>
		<input type="text"  name="transactionInstRefNo"  value="<%=strTransactionInstitutionRefNo%>" class="txt2" size=30 maxlength=30/>
	</div>
	<div class="normalTextField">
		<label>9. Transaction State Code</label>
		<select name="txnStateCode" <%=disabled%>>
			<option value="AN" title="Andaman & Nicobar" <% if(strTransactionStateCode.equals("AN")) {%>selected<% } %>>AN- Andaman & Nicobar </option>
			<option value="AP" title="Andhra Pradesh" <% if(strTransactionStateCode.equals("AP")) {%>selected<% } %>>AP- Andhra Pradesh</option>
			<option value="AR" title="Arunachal Pradesh" <% if(strTransactionStateCode.equals("AR")) {%>selected<% } %>>AR- Arunachal Pradesh</option>
			<option value="AS" title="Assam" <% if(strTransactionStateCode.equals("AS")) {%>selected<% } %>>AS- Assam</option>
			<option value="BR" title="Bihar" <% if(strTransactionStateCode.equals("BR")) {%>selected<% } %>>BR- Bihar</option>
			<option value="CH" title="Chandigarh" <% if(strTransactionStateCode.equals("CH")) {%>selected<% } %>>CH- Chandigarh</option>
			<option value="CG" title="Chattisgarh" <% if(strTransactionStateCode.equals("CG")) {%>selected<% } %>>CG- Chattisgarh</option>
			<option value="DN" title="Dadra and Nagar Haveli" <% if(strTransactionStateCode.equals("DN")) {%>selected<% } %>>DN- Dadra and Nagar Haveli</option>
			<option value="DD" title="Daman & Diu" <% if(strTransactionStateCode.equals("DD")) {%>selected<% } %>>DD- Daman & Diu</option>
			<option value="DL" title="Delhi" <% if(strTransactionStateCode.equals("DL")) {%>selected<% } %>>DL- Delhi</option>
			<option value="GA" title="Goa" <% if(strTransactionStateCode.equals("GA")) {%>selected<% } %>>GA- Goa</option>
			<option value="GJ" title="Gujarat" <% if(strTransactionStateCode.equals("GJ")) {%>selected<% } %>>GJ- Gujarat</option>
			<option value="HR" title="Haryana" <% if(strTransactionStateCode.equals("HR")) {%>selected<% } %>>HR- Haryana</option>
			<option value="HP" title="Himachal Pradesh" <% if(strTransactionStateCode.equals("HP")) {%>selected<% } %>>HP- Himachal Pradesh</option>
			<option value="JK" title="Jammu & Kashmir" <% if(strTransactionStateCode.equals("JK")) {%>selected<% } %>>JK- Jammu & Kashmir</option>
			<option value="JH" title="Jharkhand" <% if(strTransactionStateCode.equals("JH")) {%>selected<% } %>>JH- Jharkhand</option>
			<option value="KA" title="Karnataka" <% if(strTransactionStateCode.equals("KA")) {%>selected<% } %>>KA- Karnataka</option>
			<option value="KL" title="Kerala" <% if(strTransactionStateCode.equals("KL")) {%>selected<% } %>>KL- Kerala</option>
			<option value="LD" title="Lakshadweep" <% if(strTransactionStateCode.equals("LD")) {%>selected<% } %>>LD- Lakshadweep</option>
			<option value="MP" title="Madhya Pradesh" <% if(strTransactionStateCode.equals("MP")) {%>selected<% } %>>MP- Madhya Pradesh</option>
			<option value="MH" title="Maharashtra" <% if(strTransactionStateCode.equals("MH")) {%>selected<% } %>>MH- Maharashtra</option>
			<option value="MN" title="Manipur" <% if(strTransactionStateCode.equals("MN")) {%>selected<% } %>>MN- Manipur</option>
			<option value="ML" title="Meghalaya" <% if(strTransactionStateCode.equals("ML")) {%>selected<% } %>>ML- Meghalaya</option>
			<option value="MZ" title="Mizoram" <% if(strTransactionStateCode.equals("MZ")) {%>selected<% } %>>MZ- Mizoram</option>
			<option value="NL" title="Nagaland" <% if(strTransactionStateCode.equals("NL")) {%>selected<% } %>>NL- Nagaland</option>
			<option value="OR" title="Orissa" <% if(strTransactionStateCode.equals("OR")) {%>selected<% } %>>OR- Orissa</option>
			<option value="PY" title="Pondicherry" <% if(strTransactionStateCode.equals("PY")) {%>selected<% } %>>PY- Pondicherry</option>
			<option value="PB" title="Punjab" <% if(strTransactionStateCode.equals("PB")) {%>selected<% } %>>PB- Punjab</option>
			<option value="RJ" title="Rajasthan" <% if(strTransactionStateCode.equals("RJ")) {%>selected<% } %>>RJ- Rajasthan</option>
			<option value="SK" title="Sikkim" <% if(strTransactionStateCode.equals("SK")) {%>selected<% } %>>SK- Sikkim</option>
			<option value="TN" title="Tamil Nadu" <% if(strTransactionStateCode.equals("TN")) {%>selected<% } %>>TN- Tamil Nadu</option>
			<option value="TR" title="Tripura" <% if(strTransactionStateCode.equals("TR")) {%>selected<% } %>>TR- Tripura</option>
			<option value="UP" title="Uttar Pradesh" <% if(strTransactionStateCode.equals("UP")) {%>selected<% } %>>UP- Uttar Pradesh</option>
			<option value="UA" title="Uttarakhand" <% if(strTransactionStateCode.equals("UA")) {%>selected<% } %>>UA- Uttarakhand</option>
			<option value="WB" title="West Bengal" <% if(strTransactionStateCode.equals("WB")) {%>selected<% } %>>WB- West Bengal</option>
			<option value="ZZ" title="Others" <% if(strTransactionStateCode.equals("ZZ")) {%>selected<% } %>>ZZ- Others</option>
			<option value="XX" title="Not Applicable" <% if(strTransactionStateCode.equals("XX")) {%>selected<% } %>>XX -Not Applicable</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>10. Transaction Country Code</label>
		<select name="txnCountryCode" <%=disabled%>>
			<option value="IN" title="India" <% if(strTxnCountryCode.equals("IN") || strTxnCountryCode.equals("")) {%>selected<% } %>>IN-India</option>
			<option value="AF" title="Afghanistan" <% if(strTxnCountryCode.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
			<option value="AX" title="Aland Islands" <% if(strTxnCountryCode.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
			<option value="AL" title="Albania" <% if(strTxnCountryCode.equals("AL")) {%>selected<% } %>>AL-Albania</option>
			<option value="DZ" title="Algeria" <% if(strTxnCountryCode.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
			<option value="AS" title="American Samoa" <% if(strTxnCountryCode.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
			<option value="AD" title="Andorra" <% if(strTxnCountryCode.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
			<option value="AO" title="Angola" <% if(strTxnCountryCode.equals("AO")) {%>selected<% } %>>AO-Angola</option>
			<option value="AI" title="Anguilla" <% if(strTxnCountryCode.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
			<option value="AQ" title="Antarctica" <% if(strTxnCountryCode.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
			<option value="AG" title="Antigua And Barbuda" <% if(strTxnCountryCode.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
			<option value="AR" title="Argentina" <% if(strTxnCountryCode.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
			<option value="AM" title="Armenia" <% if(strTxnCountryCode.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
			<option value="AW" title="Aruba" <% if(strTxnCountryCode.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
			<option value="AU" title="Australia" <% if(strTxnCountryCode.equals("AU")) {%>selected<% } %>>AU-Australia</option>
			<option value="AT" title="Austria" <% if(strTxnCountryCode.equals("AT")) {%>selected<% } %>>AT-Austria</option>
			<option value="AZ" title="Azerbaijan" <% if(strTxnCountryCode.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
			<option value="BS" title="Bahamas" <% if(strTxnCountryCode.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
			<option value="BH" title="Bahrain" <% if(strTxnCountryCode.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
			<option value="BD" title="Bangladesh" <% if(strTxnCountryCode.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
			<option value="BB" title="Barbados" <% if(strTxnCountryCode.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
			<option value="BY" title="Belarus" <% if(strTxnCountryCode.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
			<option value="BE" title="Belgium" <% if(strTxnCountryCode.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
			<option value="BZ" title="Belize" <% if(strTxnCountryCode.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
			<option value="BJ" title="Benin" <% if(strTxnCountryCode.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
			<option value="BM" title="Bermuda" <% if(strTxnCountryCode.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
			<option value="BT" title="Bhutan" <% if(strTxnCountryCode.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
			<option value="BO" title="Bolivia" <% if(strTxnCountryCode.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
			<option value="BA" title="Bosnia And Herzegovina" <% if(strTxnCountryCode.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
			<option value="BW" title="Botswana" <% if(strTxnCountryCode.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
			<option value="BV" title="Bouvet Island" <% if(strTxnCountryCode.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
			<option value="BR" title="Brazil" <% if(strTxnCountryCode.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
			<option value="IO" title="British Indian Ocean Territory" <% if(strTxnCountryCode.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
			<option value="BN" title="Brunei Darussalam" <% if(strTxnCountryCode.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
			<option value="BG" title="Bulgaria" <% if(strTxnCountryCode.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
			<option value="BF" title="Burkina Faso" <% if(strTxnCountryCode.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
			<option value="BI" title="Burundi" <% if(strTxnCountryCode.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
			<option value="KH" title="Cambodia" <% if(strTxnCountryCode.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
			<option value="CM" title="Cameroon" <% if(strTxnCountryCode.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
			<option value="CA" title="Canada" <% if(strTxnCountryCode.equals("CA")) {%>selected<% } %>>CA-Canada</option>
			<option value="CV" title="Cape Verde" <% if(strTxnCountryCode.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
			<option value="KY" title="Cayman Islands" <% if(strTxnCountryCode.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
			<option value="CF" title="Central African Republic" <% if(strTxnCountryCode.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
			<option value="TD" title="Chad" <% if(strTxnCountryCode.equals("TD")) {%>selected<% } %>>TD-Chad</option>
			<option value="CL" title="Chile" <% if(strTxnCountryCode.equals("CL")) {%>selected<% } %>>CL-Chile</option>
			<option value="CN" title="China" <% if(strTxnCountryCode.equals("CN")) {%>selected<% } %>>CN-China</option>
			<option value="CX" title="Christmas Island" <% if(strTxnCountryCode.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
			<option value="CC" title="Cocos (Keeling) Islands" <% if(strTxnCountryCode.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
			<option value="CO" title="Colombia" <% if(strTxnCountryCode.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
			<option value="KM" title="Comoros" <% if(strTxnCountryCode.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
			<option value="CG" title="Congo" <% if(strTxnCountryCode.equals("CG")) {%>selected<% } %>>CG-Congo</option>
			<option value="CD" title="Congo,Democratic Republic" <% if(strTxnCountryCode.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
			<option value="CK" title="Cook Islands" <% if(strTxnCountryCode.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
			<option value="CR" title="Costa Rica" <% if(strTxnCountryCode.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
			<option value="CI" title="Côte D'ivoire" <% if(strTxnCountryCode.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
			<option value="HR" title="Croatia" <% if(strTxnCountryCode.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
			<option value="CU" title="Cuba" <% if(strTxnCountryCode.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
			<option value="CY" title="Cyprus" <% if(strTxnCountryCode.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
			<option value="CZ" title="Czech Republic" <% if(strTxnCountryCode.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
			<option value="DK" title="Denmark" <% if(strTxnCountryCode.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
			<option value="DJ" title="Djibouti" <% if(strTxnCountryCode.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
			<option value="DM" title="Dominica" <% if(strTxnCountryCode.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
			<option value="DO" title="Dominican Republic" <% if(strTxnCountryCode.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
			<option value="EC" title="Ecuador" <% if(strTxnCountryCode.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
			<option value="EG" title="Egypt" <% if(strTxnCountryCode.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
			<option value="SV" title="El Ssalvador" <% if(strTxnCountryCode.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
			<option value="GQ" title="Equatorial Guinea" <% if(strTxnCountryCode.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
			<option value="ER" title="Eritrea" <% if(strTxnCountryCode.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
			<option value="EE" title="Estonia" <% if(strTxnCountryCode.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
			<option value="ET" title="Ethiopia" <% if(strTxnCountryCode.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
			<option value="FK" title="Falkland Islands (Malvinas)" <% if(strTxnCountryCode.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
			<option value="FO" title="Faroe Islands" <% if(strTxnCountryCode.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
			<option value="FJ" title="Fiji" <% if(strTxnCountryCode.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
			<option value="FI" title="Finland" <% if(strTxnCountryCode.equals("FI")) {%>selected<% } %>>FI-Finland</option>
			<option value="FR" title="France" <% if(strTxnCountryCode.equals("FR")) {%>selected<% } %>>FR-France</option>
			<option value="GF" title="French Guiana" <% if(strTxnCountryCode.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
			<option value="PF" title="French Polynesia" <% if(strTxnCountryCode.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
			<option value="TF" title="French Southern Territories" <% if(strTxnCountryCode.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
			<option value="GA" title="Gabon" <% if(strTxnCountryCode.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
			<option value="GM" title="Gambia" <% if(strTxnCountryCode.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
			<option value="GE" title="Georgia" <% if(strTxnCountryCode.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
			<option value="DE" title="Germany" <% if(strTxnCountryCode.equals("DE")) {%>selected<% } %>>DE-Germany</option>
			<option value="GH" title="Ghana" <% if(strTxnCountryCode.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
			<option value="GI" title="Gibraltar" <% if(strTxnCountryCode.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
			<option value="GR" title="Greece" <% if(strTxnCountryCode.equals("GR")) {%>selected<% } %>>GR-Greece</option>
			<option value="GL" title="Greenland" <% if(strTxnCountryCode.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
			<option value="GD" title="Grenada" <% if(strTxnCountryCode.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
			<option value="GP" title="Guadeloupe" <% if(strTxnCountryCode.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
			<option value="GU" title="Guam" <% if(strTxnCountryCode.equals("GU")) {%>selected<% } %>>GU-Guam</option>
			<option value="GT" title="Guatemala" <% if(strTxnCountryCode.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
			<option value="GG" title="Guernsey" <% if(strTxnCountryCode.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
			<option value="GN" title="Guinea" <% if(strTxnCountryCode.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
			<option value="GW" title="Guinea-Bisaau" title="Bissau" <% if(strTxnCountryCode.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
			<option value="GY" title="Guyana" <% if(strTxnCountryCode.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
			<option value="HT" title="Haiti" <% if(strTxnCountryCode.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
			<option value="HM" title="Heard Island And Mcdonald Islands" <% if(strTxnCountryCode.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
			<option value="VA" title="Vatican City State" <% if(strTxnCountryCode.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
			<option value="HN" title="Honduras" <% if(strTxnCountryCode.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
			<option value="HK" title="Hong Kong" <% if(strTxnCountryCode.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
			<option value="HU" title="Hungary" <% if(strTxnCountryCode.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
			<option value="IS" title="Iceland" <% if(strTxnCountryCode.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
			<option value="ID" title="Indonesia" <% if(strTxnCountryCode.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
			<option value="IR" title="Iran" <% if(strTxnCountryCode.equals("IR")) {%>selected<% } %>>IR-Iran</option>
			<option value="IQ" title="Iraq" <% if(strTxnCountryCode.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
			<option value="IE" title="Ireland" <% if(strTxnCountryCode.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
			<option value="IM" title="Isle Of Man" <% if(strTxnCountryCode.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
			<option value="IL" title="Israel" <% if(strTxnCountryCode.equals("IL")) {%>selected<% } %>>IL-Israel</option>
			<option value="IT" title="Italy" <% if(strTxnCountryCode.equals("IT")) {%>selected<% } %>>IT-Italy</option>
			<option value="JM" title="Jamaica" <% if(strTxnCountryCode.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
			<option value="JP" title="Japan" <% if(strTxnCountryCode.equals("JP")) {%>selected<% } %>>JP-Japan</option>
			<option value="JE" title="Jersey" <% if(strTxnCountryCode.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
			<option value="JO" title="Jordan" <% if(strTxnCountryCode.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
			<option value="KZ" title="Kazakhstan" <% if(strTxnCountryCode.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
			<option value="KE" title="Kenya" <% if(strTxnCountryCode.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
			<option value="KI" title="Kiribati" <% if(strTxnCountryCode.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
			<option value="KP" title="Korea, Democratic People's Republic" <% if(strTxnCountryCode.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
			<option value="KR" title="Korea" <% if(strTxnCountryCode.equals("KR")) {%>selected<% } %>>KR-Korea</option>
			<option value="KW" title="Kuwait" <% if(strTxnCountryCode.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
			<option value="KG" title="Kyrgyzstan" <% if(strTxnCountryCode.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
			<option value="LA" title="Lao People's Democratic Republic" <% if(strTxnCountryCode.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
			<option value="LV" title="Latvia" <% if(strTxnCountryCode.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
			<option value="LB" title="Lebanon" <% if(strTxnCountryCode.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
			<option value="LS" title="Lesotho" <% if(strTxnCountryCode.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
			<option value="LR" title="Liberia" <% if(strTxnCountryCode.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
			<option value="LY" title="Libyan Arab Jamahiriya" <% if(strTxnCountryCode.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
			<option value="LI" title="Liechtenstein" <% if(strTxnCountryCode.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
			<option value="LT" title="Lithuania" <% if(strTxnCountryCode.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
			<option value="LU" title="Luxembourg" <% if(strTxnCountryCode.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
			<option value="MO" title="Macao" <% if(strTxnCountryCode.equals("MO")) {%>selected<% } %>>MO-Macao</option>
			<option value="MK" title="Macedonia, The Former Yugoslav Repub" <% if(strTxnCountryCode.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
			<option value="MG" title="Madagascar" <% if(strTxnCountryCode.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
			<option value="MW" title="Malawi" <% if(strTxnCountryCode.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
			<option value="MY" title="Malaysia" <% if(strTxnCountryCode.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
			<option value="MV" title="Maldives" <% if(strTxnCountryCode.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
			<option value="ML" title="Mali" <% if(strTxnCountryCode.equals("ML")) {%>selected<% } %>>ML-Mali</option>
			<option value="MT" title="Malta" <% if(strTxnCountryCode.equals("MT")) {%>selected<% } %>>MT-Malta</option>
			<option value="MH" title="Marshall Islands" <% if(strTxnCountryCode.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
			<option value="MQ" title="Martinique" <% if(strTxnCountryCode.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
			<option value="MR" title="Mauritania" <% if(strTxnCountryCode.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
			<option value="MU" title="Mauritius" <% if(strTxnCountryCode.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
			<option value="YT" title="Mayotte" <% if(strTxnCountryCode.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
			<option value="MX" title="Mexico" <% if(strTxnCountryCode.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
			<option value="FM" title="Micronesia" <% if(strTxnCountryCode.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
			<option value="MD" title="Moldova" <% if(strTxnCountryCode.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
			<option value="MC" title="Monaco" <% if(strTxnCountryCode.equals("MC")) {%>selected<% } %>>MC-Monaco</option>
			<option value="MN" title="Mongolia" <% if(strTxnCountryCode.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
			<option value="ME" title="Montenegro" <% if(strTxnCountryCode.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
			<option value="MS" title="Montserrat" <% if(strTxnCountryCode.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
			<option value="MA" title="Morocco" <% if(strTxnCountryCode.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
			<option value="MZ" title="Mozambique" <% if(strTxnCountryCode.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
			<option value="MM" title="Myanmar" <% if(strTxnCountryCode.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
			<option value="NA" title="Namibia" <% if(strTxnCountryCode.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
			<option value="NR" title="Nauru" <% if(strTxnCountryCode.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
			<option value="NP" title="Nepal" <% if(strTxnCountryCode.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
			<option value="NL" title="Netherlands" <% if(strTxnCountryCode.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
			<option value="AN" title="Netherlands Antilles" <% if(strTxnCountryCode.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
			<option value="NC" title="New Caledonia" <% if(strTxnCountryCode.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
			<option value="NZ" title="New Zealand" <% if(strTxnCountryCode.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
			<option value="NI" title="Nicaragua" <% if(strTxnCountryCode.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
			<option value="NE" title="Niger" <% if(strTxnCountryCode.equals("NE")) {%>selected<% } %>>NE-Niger</option>
			<option value="NG" title="Nigeria" <% if(strTxnCountryCode.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
			<option value="NU" title="Niue" <% if(strTxnCountryCode.equals("NU")) {%>selected<% } %>>NU-Niue</option>
			<option value="NF" title="Norfolk Island" <% if(strTxnCountryCode.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
			<option value="MP" title="Northern Mariana Islands" <% if(strTxnCountryCode.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
			<option value="NO" title="Norway" <% if(strTxnCountryCode.equals("NO")) {%>selected<% } %>>NO-Norway</option>
			<option value="OM" title="Oman" <% if(strTxnCountryCode.equals("OM")) {%>selected<% } %>>OM-Oman</option>
			<option value="PK" title="Pakistan" <% if(strTxnCountryCode.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
			<option value="PW" title="Palau" <% if(strTxnCountryCode.equals("PW")) {%>selected<% } %>>PW-Palau</option>
			<option value="PS" title="Palestinian Territory, Occupied" <% if(strTxnCountryCode.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
			<option value="PA" title="Panama" <% if(strTxnCountryCode.equals("PA")) {%>selected<% } %>>PA-Panama</option>
			<option value="PG" title="Papua New Guinea" <% if(strTxnCountryCode.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
			<option value="PY" title="Paraguay" <% if(strTxnCountryCode.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
			<option value="PE" title="Peru" <% if(strTxnCountryCode.equals("PE")) {%>selected<% } %>>PE-Peru</option>
			<option value="PH" title="Philippines" <% if(strTxnCountryCode.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
			<option value="PN" title="Pitcairn" <% if(strTxnCountryCode.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
			<option value="PL" title="Poland" <% if(strTxnCountryCode.equals("PL")) {%>selected<% } %>>PL-Poland</option>
			<option value="PT" title="Portugal" <% if(strTxnCountryCode.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
			<option value="PR" title="Puerto Rico" <% if(strTxnCountryCode.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
			<option value="QA" title="Qatar" <% if(strTxnCountryCode.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
			<option value="RE" title="Réunion" <% if(strTxnCountryCode.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
			<option value="RO" title="Romania" <% if(strTxnCountryCode.equals("RO")) {%>selected<% } %>>RO-Romania</option>
			<option value="RU" title="Russian Federation" <% if(strTxnCountryCode.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
			<option value="RW" title="Rwanda" <% if(strTxnCountryCode.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
			<option value="BL" title="Saint Barthélemy" <% if(strTxnCountryCode.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
			<option value="SH" title="Saint Helena, Ascension And Tristan" <% if(strTxnCountryCode.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
			<option value="KN" title="Saint Kitts And Nevis" <% if(strTxnCountryCode.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
			<option value="LC" title="Saint Lucia" <% if(strTxnCountryCode.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
			<option value="MF" title="Saint Martin" <% if(strTxnCountryCode.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
			<option value="PM" title="Saint Pierre And Miquelon" <% if(strTxnCountryCode.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
			<option value="VC" title="Saint Vincent And The Grenadines" <% if(strTxnCountryCode.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
			<option value="WS" title="Samoa" <% if(strTxnCountryCode.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
			<option value="SM" title="San Marino" <% if(strTxnCountryCode.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
			<option value="ST" title="Sao Tome And Principe" <% if(strTxnCountryCode.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
			<option value="SA" title="Saudi Arabia" <% if(strTxnCountryCode.equals("SA")) {%>selected<% } %>>SA-Saudi Arabia</option>
			<option value="SN" title="Senegal" <% if(strTxnCountryCode.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
			<option value="RS" title="Serbia" <% if(strTxnCountryCode.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
			<option value="SC" title="Seychelles" <% if(strTxnCountryCode.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
			<option value="SL" title="Sierra Leone" <% if(strTxnCountryCode.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
			<option value="SG" title="Singapore" <% if(strTxnCountryCode.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
			<option value="SK" title="Slovakia" <% if(strTxnCountryCode.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
			<option value="SI" title="Slovenia" <% if(strTxnCountryCode.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
			<option value="SB" title="Solomon Islands" <% if(strTxnCountryCode.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
			<option value="SO" title="Somalia" <% if(strTxnCountryCode.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
			<option value="ZA" title="South Africa" <% if(strTxnCountryCode.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
			<option value="GS" title="South Georgia And The South Sandwich" <% if(strTxnCountryCode.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
			<option value="ES" title="Spain" <% if(strTxnCountryCode.equals("ES")) {%>selected<% } %>>ES-Spain</option>
			<option value="LK" title="Sri Lanka" <% if(strTxnCountryCode.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
			<option value="SD" title="Sudan" <% if(strTxnCountryCode.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
			<option value="SR" title="Suriname" <% if(strTxnCountryCode.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
			<option value="SJ" title="Svalbard And Jan Mayen" <% if(strTxnCountryCode.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
			<option value="SZ" title="Swaziland" <% if(strTxnCountryCode.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
			<option value="SE" title="Sweden" <% if(strTxnCountryCode.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
			<option value="CH" title="Switzerland" <% if(strTxnCountryCode.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
			<option value="SY" title="Syrian Arab Republic" <% if(strTxnCountryCode.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
			<option value="TW" title="Taiwan, Province Of China" <% if(strTxnCountryCode.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
			<option value="TJ" title="Tajikistan" <% if(strTxnCountryCode.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
			<option value="TZ" title="Tanzania" <% if(strTxnCountryCode.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
			<option value="TH" title="Thailand" <% if(strTxnCountryCode.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
			<option value="TL" title="Timor" title="Leste" <% if(strTxnCountryCode.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
			<option value="TG" title="Togo" <% if(strTxnCountryCode.equals("TG")) {%>selected<% } %>>TG-Togo</option>
			<option value="TK" title="Tokelau" <% if(strTxnCountryCode.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
			<option value="TO" title="Tonga" <% if(strTxnCountryCode.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
			<option value="TT" title="Trinidad And Tobago" <% if(strTxnCountryCode.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
			<option value="TN" title="Tunisia" <% if(strTxnCountryCode.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
			<option value="TR" title="Turkey" <% if(strTxnCountryCode.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
			<option value="TM" title="Turkmenistan" <% if(strTxnCountryCode.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
			<option value="TC" title="Turks And Caicos Islands" <% if(strTxnCountryCode.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
			<option value="TV" title="Tuvalu" <% if(strTxnCountryCode.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
			<option value="UG" title="Uganda" <% if(strTxnCountryCode.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
			<option value="UA" title="Ukraine" <% if(strTxnCountryCode.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
			<option value="AE" title="United Arab Emirates" <% if(strTxnCountryCode.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
			<option value="GB" title="United Kingdom" <% if(strTxnCountryCode.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
			<option value="US" title="United States" <% if(strTxnCountryCode.equals("US")) {%>selected<% } %>>US-United States</option>
			<option value="UM" title="United States Minor Outlying Islands" <% if(strTxnCountryCode.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
			<option value="UY" title="Uruguay" <% if(strTxnCountryCode.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
			<option value="UZ" title="Uzbekistan" <% if(strTxnCountryCode.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
			<option value="VU" title="Vanuatu" <% if(strTxnCountryCode.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
			<option value="VE" title="Venezuela" <% if(strTxnCountryCode.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
			<option value="VN" title="Viet Nam" <% if(strTxnCountryCode.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
			<option value="VG" title="Virgin Islands, British" <% if(strTxnCountryCode.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
			<option value="VI" title="Virgin Islands, U.S." <% if(strTxnCountryCode.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
			<option value="WF" title="Wallis And Futuna" <% if(strTxnCountryCode.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
			<option value="EH" title="Western Sahara" <% if(strTxnCountryCode.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
			<option value="YE" title="Yemen" <% if(strTxnCountryCode.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
			<option value="ZM" title="Zambia" <% if(strTxnCountryCode.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
			<option value="ZW" title="Zimbabwe" <% if(strTxnCountryCode.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
			<option value="SS" title="South Sudan" <% if(strTxnCountryCode.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
			<option value="CW" title="Curacao" <% if(strTxnCountryCode.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
			<option value="BQ" title="Bonaire, Sint Eustatius and Saba" <% if(strTxnCountryCode.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
			<option value="SX" title="Sint Marteen" <% if(strTxnCountryCode.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
			<option value="XX" title="Not available " <% if(strTxnCountryCode.equals("XX")) {%>selected<% } %>>XX-Not available </option>
			<option value="ZZ" title="Others" <% if(strTxnCountryCode.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>11. Amount in Rupees</label>
		<input type="text"  name="transactionAmount" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strTransactionAmount%>" />
	</div>
	<div class="normalTextField">
		<label>12. Amount in Foreign Currency</label>
		<input type="text"  name="transactionForeignCurrAmount" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strTransactionAmountForeignCurr%>"/>
	</div>
	<div class="normalTextField">
		<label>13. Currency of Transaction</label>
		<select name="currencyCode" >
			<option value="AFA" <% if(strTransactionCurrency.equals("AFA")) {%>selected<% } %>>AFA- Afghanistan Afghani</option>
			<option value="ALL" <% if(strTransactionCurrency.equals("ALL")) {%>selected<% } %>>ALL- Albanian Lek</option>
			<option value="DZD" <% if(strTransactionCurrency.equals("DZD")) {%>selected<% } %>>DZD- Algerian Dinar</option>
			<option value="AOR" <% if(strTransactionCurrency.equals("AOR")) {%>selected<% } %>>AOR- Angolan Kwanza Reajustado</option>
			<option value="ARS" <% if(strTransactionCurrency.equals("ARS")) {%>selected<% } %>>ARS- Argentine Peso</option>
			<option value="AMD" <% if(strTransactionCurrency.equals("AMD")) {%>selected<% } %>>AMD- Armenian Dram</option>
			<option value="AWG" <% if(strTransactionCurrency.equals("AWG")) {%>selected<% } %>>AWG- Aruban Guilder</option>
			<option value="AUD" <% if(strTransactionCurrency.equals("AUD")) {%>selected<% } %>>AUD- Australian Dollar</option>
			<option value="AZN" <% if(strTransactionCurrency.equals("AZN")) {%>selected<% } %>>AZN- Azerbaijanian New Manat</option>
			<option value="BSD" <% if(strTransactionCurrency.equals("BSD")) {%>selected<% } %>>BSD- Bahamian Dollar</option>
			<option value="BHD" <% if(strTransactionCurrency.equals("BHD")) {%>selected<% } %>>BHD- Bahraini Dinar</option>
			<option value="BDT" <% if(strTransactionCurrency.equals("BDT")) {%>selected<% } %>>BDT- Bangladeshi Taka</option>
			<option value="BBD" <% if(strTransactionCurrency.equals("BBD")) {%>selected<% } %>>BBD- Barbados Dollar</option>
			<option value="BYR" <% if(strTransactionCurrency.equals("BYR")) {%>selected<% } %>>BYR- Belarusian Ruble</option>
			<option value="BZD" <% if(strTransactionCurrency.equals("BZD")) {%>selected<% } %>>BZD- Belize Dollar</option>
			<option value="BMD" <% if(strTransactionCurrency.equals("BMD")) {%>selected<% } %>>BMD- Bermudian Dollar</option>
			<option value="BTN" <% if(strTransactionCurrency.equals("BTN")) {%>selected<% } %>>BTN- Bhutan Ngultrum</option>
			<option value="BOB" <% if(strTransactionCurrency.equals("BOB")) {%>selected<% } %>>BOB- Bolivian Boliviano</option>
			<option value="BWP" <% if(strTransactionCurrency.equals("BWP")) {%>selected<% } %>>BWP- Botswana Pula</option>
			<option value="BRL" <% if(strTransactionCurrency.equals("BRL")) {%>selected<% } %>>BRL- Brazilian Real</option>
			<option value="GBP" <% if(strTransactionCurrency.equals("GBP")) {%>selected<% } %>>GBP- British Pound</option>
			<option value="BND" <% if(strTransactionCurrency.equals("BND")) {%>selected<% } %>>BND- Brunei Dollar</option>
			<option value="BGN" <% if(strTransactionCurrency.equals("BGN")) {%>selected<% } %>>BGN- Bulgarian Lev</option>
			<option value="BIF" <% if(strTransactionCurrency.equals("BIF")) {%>selected<% } %>>BIF- Burundi Franc</option>
			<option value="KHR" <% if(strTransactionCurrency.equals("KHR")) {%>selected<% } %>>KHR- Cambodian Riel</option>
			<option value="CAD" <% if(strTransactionCurrency.equals("CAD")) {%>selected<% } %>>CAD- Canadian Dollar</option>
			<option value="CVE" <% if(strTransactionCurrency.equals("CVE")) {%>selected<% } %>>CVE- Cape Verde Escudo</option>
			<option value="KYD" <% if(strTransactionCurrency.equals("KYD")) {%>selected<% } %>>KYD- Cayman Islands Dollar</option>
			<option value="XOF" <% if(strTransactionCurrency.equals("XOF")) {%>selected<% } %>>XOF- CFA Franc BCEAO</option>
			<option value="XAF" <% if(strTransactionCurrency.equals("XAF")) {%>selected<% } %>>XAF- CFA Franc BEAC</option>
			<option value="XPF" <% if(strTransactionCurrency.equals("XPF")) {%>selected<% } %>>XPF- CFP Franc</option>
			<option value="CLP" <% if(strTransactionCurrency.equals("CLP")) {%>selected<% } %>>CLP- Chilean Peso</option>
			<option value="CNY" <% if(strTransactionCurrency.equals("CNY")) {%>selected<% } %>>CNY- Chinese Yuan Renminbi</option>
			<option value="COP" <% if(strTransactionCurrency.equals("COP")) {%>selected<% } %>>COP- Colombian Peso</option>
			<option value="KMF" <% if(strTransactionCurrency.equals("KMF")) {%>selected<% } %>>KMF- Comoros Franc</option>
			<option value="CDF" <% if(strTransactionCurrency.equals("CDF")) {%>selected<% } %>>CDF- Congolese Franc</option>
			<option value="CRC" <% if(strTransactionCurrency.equals("CRC")) {%>selected<% } %>>CRC- Costa Rican Colon</option>
			<option value="HRK" <% if(strTransactionCurrency.equals("HRK")) {%>selected<% } %>>HRK- Croatian Kuna</option>
			<option value="CUP" <% if(strTransactionCurrency.equals("CUP")) {%>selected<% } %>>CUP- Cuban Peso</option>
			<option value="CZK" <% if(strTransactionCurrency.equals("CZK")) {%>selected<% } %>>CZK- Czech Koruna</option>
			<option value="DKK" <% if(strTransactionCurrency.equals("DKK")) {%>selected<% } %>>DKK- Danish Krone</option>
			<option value="DJF" <% if(strTransactionCurrency.equals("DJF")) {%>selected<% } %>>DJF- Djibouti Franc</option>
			<option value="DOP" <% if(strTransactionCurrency.equals("DOP")) {%>selected<% } %>>DOP- Dominican Peso</option>
			<option value="XCD" <% if(strTransactionCurrency.equals("XCD")) {%>selected<% } %>>XCD- East Caribbean Dollar</option>
			<option value="EGP" <% if(strTransactionCurrency.equals("EGP")) {%>selected<% } %>>EGP- Egyptian Pound</option>
			<option value="SVC" <% if(strTransactionCurrency.equals("SVC")) {%>selected<% } %>>SVC- El Salvador Colon</option>
			<option value="ERN" <% if(strTransactionCurrency.equals("ERN")) {%>selected<% } %>>ERN- Eritrean Nakfa</option>
			<option value="EEK" <% if(strTransactionCurrency.equals("EEK")) {%>selected<% } %>>EEK- Estonian Kroon</option>
			<option value="ETB" <% if(strTransactionCurrency.equals("ETB")) {%>selected<% } %>>ETB- Ethiopian Birr</option>
			<option value="EUR" <% if(strTransactionCurrency.equals("EUR")) {%>selected<% } %>>EUR- EU Euro</option>
			<option value="FKP" <% if(strTransactionCurrency.equals("FKP")) {%>selected<% } %>>FKP- Falkland Islands Pound</option>
			<option value="FJD" <% if(strTransactionCurrency.equals("FJD")) {%>selected<% } %>>FJD- Fiji Dollar</option>
			<option value="GMD" <% if(strTransactionCurrency.equals("GMD")) {%>selected<% } %>>GMD- Gambian Dalasi</option>
			<option value="GEL" <% if(strTransactionCurrency.equals("GEL")) {%>selected<% } %>>GEL- Georgian Lari</option>
			<option value="GHS" <% if(strTransactionCurrency.equals("GHS")) {%>selected<% } %>>GHS- Ghanaian New Cedi</option>
			<option value="GIP" <% if(strTransactionCurrency.equals("GIP")) {%>selected<% } %>>GIP- Gibraltar Pound</option>
			<option value="XAU" <% if(strTransactionCurrency.equals("XAU")) {%>selected<% } %>>XAU- Gold (Ounce)</option>
			<option value="XFO" <% if(strTransactionCurrency.equals("XFO")) {%>selected<% } %>>XFO- Gold Franc</option>
			<option value="GTQ" <% if(strTransactionCurrency.equals("GTQ")) {%>selected<% } %>>GTQ- Guatemalan Quetzal</option>
			<option value="GNF" <% if(strTransactionCurrency.equals("GNF")) {%>selected<% } %>>GNF- Guinean Franc</option>
			<option value="GYD" <% if(strTransactionCurrency.equals("GYD")) {%>selected<% } %>>GYD- Guyana Dollar</option>
			<option value="HTG" <% if(strTransactionCurrency.equals("HTG")) {%>selected<% } %>>HTG- Haitian Gourde</option>
			<option value="HNL" <% if(strTransactionCurrency.equals("HNL")) {%>selected<% } %>>HNL- Honduran Lempira</option>
			<option value="HKD" <% if(strTransactionCurrency.equals("HKD")) {%>selected<% } %>>HKD- Hong Kong SAR Dollar</option>
			<option value="HUF" <% if(strTransactionCurrency.equals("HUF")) {%>selected<% } %>>HUF- Hungarian Forint</option>
			<option value="ISK" <% if(strTransactionCurrency.equals("ISK")) {%>selected<% } %>>ISK- Icelandic Krona</option>
			<option value="XDR" <% if(strTransactionCurrency.equals("XDR")) {%>selected<% } %>>XDR- IMF Special Drawing Right</option>
			<option value="INR" <% if(strTransactionCurrency.equals("INR")) {%>selected<% } %>>INR- Indian Rupee</option>
			<option value="IDR" <% if(strTransactionCurrency.equals("IDR")) {%>selected<% } %>>IDR- Indonesian Rupiah</option>
			<option value="IRR" <% if(strTransactionCurrency.equals("IRR")) {%>selected<% } %>>IRR- Iranian Rial</option>
			<option value="IQD" <% if(strTransactionCurrency.equals("IQD")) {%>selected<% } %>>IQD- Iraqi Dinar</option>
			<option value="ILS" <% if(strTransactionCurrency.equals("ILS")) {%>selected<% } %>>ILS- Israeli New Shekel</option>
			<option value="JMD" <% if(strTransactionCurrency.equals("JMD")) {%>selected<% } %>>JMD- Jamaican Dollar</option>
			<option value="JPY" <% if(strTransactionCurrency.equals("JPY")) {%>selected<% } %>>JPY- Japanese Yen</option>
			<option value="JOD" <% if(strTransactionCurrency.equals("JOD")) {%>selected<% } %>>JOD- Jordanian Dinar</option>
			<option value="KZT" <% if(strTransactionCurrency.equals("KZT")) {%>selected<% } %>>KZT- Kazakh Tenge</option>
			<option value="KES" <% if(strTransactionCurrency.equals("KES")) {%>selected<% } %>>KES- Kenyan Shilling</option>
			<option value="KWD" <% if(strTransactionCurrency.equals("KWD")) {%>selected<% } %>>KWD- Kuwaiti Dinar</option>
			<option value="KGS" <% if(strTransactionCurrency.equals("KGS")) {%>selected<% } %>>KGS- Kyrgyz Som</option>
			<option value="LAK" <% if(strTransactionCurrency.equals("LAK")) {%>selected<% } %>>LAK- Lao Kip</option>
			<option value="LVL" <% if(strTransactionCurrency.equals("LVL")) {%>selected<% } %>>LVL- Latvian Lats</option>
			<option value="LBP" <% if(strTransactionCurrency.equals("LBP")) {%>selected<% } %>>LBP- Lebanese Pound</option>
			<option value="LSL" <% if(strTransactionCurrency.equals("LSL")) {%>selected<% } %>>LSL- Lesotho Loti</option>
			<option value="LRD" <% if(strTransactionCurrency.equals("LRD")) {%>selected<% } %>>LRD- Liberian Dollar</option>
			<option value="LYD" <% if(strTransactionCurrency.equals("LYD")) {%>selected<% } %>>LYD- Libyan Dinar</option>
			<option value="LTL" <% if(strTransactionCurrency.equals("LTL")) {%>selected<% } %>>LTL- Lithuanian Litas</option>
			<option value="MOP" <% if(strTransactionCurrency.equals("MOP")) {%>selected<% } %>>MOP- Macao SAR Pataca</option>
			<option value="MKD" <% if(strTransactionCurrency.equals("MKD")) {%>selected<% } %>>MKD- Macedonian Denar</option>
			<option value="MGA" <% if(strTransactionCurrency.equals("MGA")) {%>selected<% } %>>MGA- Malagasy Ariary</option>
			<option value="MWK" <% if(strTransactionCurrency.equals("MWK")) {%>selected<% } %>>MWK- Malawi Kwacha</option>
			<option value="MYR" <% if(strTransactionCurrency.equals("MYR")) {%>selected<% } %>>MYR- Malaysian Ringgit</option>
			<option value="MVR" <% if(strTransactionCurrency.equals("MVR")) {%>selected<% } %>>MVR- Maldivian Rufiyaa</option>
			<option value="MRO" <% if(strTransactionCurrency.equals("MRO")) {%>selected<% } %>>MRO- Mauritanian Ouguiya</option>
			<option value="MUR" <% if(strTransactionCurrency.equals("MUR")) {%>selected<% } %>>MUR- Mauritius Rupee</option>
			<option value="MXN" <% if(strTransactionCurrency.equals("MXN")) {%>selected<% } %>>MXN- Mexican Peso</option>
			<option value="MDL" <% if(strTransactionCurrency.equals("MDL")) {%>selected<% } %>>MDL- Moldovan Leu</option>
			<option value="MNT" <% if(strTransactionCurrency.equals("MNT")) {%>selected<% } %>>MNT- Mongolian Tugrik</option>
			<option value="MAD" <% if(strTransactionCurrency.equals("MAD")) {%>selected<% } %>>MAD- Moroccan Dirham</option>
			<option value="MZN" <% if(strTransactionCurrency.equals("MZN")) {%>selected<% } %>>MZN- Mozambique New Metical</option>
			<option value="MMK" <% if(strTransactionCurrency.equals("MMK")) {%>selected<% } %>>MMK- Myanmar Kyat</option>
			<option value="NAD" <% if(strTransactionCurrency.equals("NAD")) {%>selected<% } %>>NAD- Namibian Dollar</option>
			<option value="NPR" <% if(strTransactionCurrency.equals("NPR")) {%>selected<% } %>>NPR- Nepalese Rupee</option>
			<option value="ANG" <% if(strTransactionCurrency.equals("ANG")) {%>selected<% } %>>ANG- Netherlands Antillian Guilder</option>
			<option value="NZD" <% if(strTransactionCurrency.equals("NZD")) {%>selected<% } %>>NZD- New Zealand Dollar</option>
			<option value="NIO" <% if(strTransactionCurrency.equals("NIO")) {%>selected<% } %>>NIO- Nicaraguan Cordoba Oro</option>
			<option value="NGN" <% if(strTransactionCurrency.equals("NGN")) {%>selected<% } %>>NGN- Nigerian Naira</option>
			<option value="KPW" <% if(strTransactionCurrency.equals("KPW")) {%>selected<% } %>>KPW- North Korean Won</option>
			<option value="NOK" <% if(strTransactionCurrency.equals("NOK")) {%>selected<% } %>>NOK- Norwegian Krone</option>
			<option value="OMR" <% if(strTransactionCurrency.equals("OMR")) {%>selected<% } %>>OMR- Omani Rial</option>
			<option value="PKR" <% if(strTransactionCurrency.equals("PKR")) {%>selected<% } %>>PKR- Pakistani Rupee</option>
			<option value="XPD" <% if(strTransactionCurrency.equals("XPD")) {%>selected<% } %>>XPD- Palladium (Ounce)</option>
			<option value="PAB" <% if(strTransactionCurrency.equals("PAB")) {%>selected<% } %>>PAB- Panamanian Balboa</option>
			<option value="PGK" <% if(strTransactionCurrency.equals("PGK")) {%>selected<% } %>>PGK- Papua New Guinea Kina</option>
			<option value="PYG" <% if(strTransactionCurrency.equals("PYG")) {%>selected<% } %>>PYG- Paraguayan Guarani</option>
			<option value="PEN" <% if(strTransactionCurrency.equals("PEN")) {%>selected<% } %>>PEN- Peruvian Nuevo Sol</option>
			<option value="PHP" <% if(strTransactionCurrency.equals("PHP")) {%>selected<% } %>>PHP- Philippine Peso</option>
			<option value="XPT" <% if(strTransactionCurrency.equals("XPT")) {%>selected<% } %>>XPT- Platinum (Ounce)</option>
			<option value="PLN" <% if(strTransactionCurrency.equals("PLN")) {%>selected<% } %>>PLN- Polish Zloty</option>
			<option value="QAR" <% if(strTransactionCurrency.equals("QAR")) {%>selected<% } %>>QAR- Qatari Rial</option>
			<option value="RON" <% if(strTransactionCurrency.equals("RON")) {%>selected<% } %>>RON- Romanian New Leu</option>
			<option value="RUB" <% if(strTransactionCurrency.equals("RUB")) {%>selected<% } %>>RUB- Russian Ruble</option>
			<option value="RWF" <% if(strTransactionCurrency.equals("RWF")) {%>selected<% } %>>RWF- Rwandan Franc</option>
			<option value="SHP" <% if(strTransactionCurrency.equals("SHP")) {%>selected<% } %>>SHP- Saint Helena Pound</option>
			<option value="WST" <% if(strTransactionCurrency.equals("WST")) {%>selected<% } %>>WST- Samoan Tala</option>
			<option value="STD" <% if(strTransactionCurrency.equals("STD")) {%>selected<% } %>>STD- Sao Tome And Principe Dobra</option>
			<option value="SAR" <% if(strTransactionCurrency.equals("SAR")) {%>selected<% } %>>SAR- Saudi Riyal</option>
			<option value="RSD" <% if(strTransactionCurrency.equals("RSD")) {%>selected<% } %>>RSD- Serbian Dinar</option>
			<option value="SCR" <% if(strTransactionCurrency.equals("SCR")) {%>selected<% } %>>SCR- Seychelles Rupee</option>
			<option value="SLL" <% if(strTransactionCurrency.equals("SLL")) {%>selected<% } %>>SLL- Sierra Leone Leone</option>
			<option value="XAG" <% if(strTransactionCurrency.equals("XAG")) {%>selected<% } %>>XAG- Silver (Ounce)</option>
			<option value="SGD" <% if(strTransactionCurrency.equals("SGD")) {%>selected<% } %>>SGD- Singapore Dollar</option>
			<option value="SBD" <% if(strTransactionCurrency.equals("SBD")) {%>selected<% } %>>SBD- Solomon Islands Dollar</option>
			<option value="SOS" <% if(strTransactionCurrency.equals("SOS")) {%>selected<% } %>>SOS- Somali Shilling</option>
			<option value="ZAR" <% if(strTransactionCurrency.equals("ZAR")) {%>selected<% } %>>ZAR- South African Rand</option>
			<option value="KRW" <% if(strTransactionCurrency.equals("KRW")) {%>selected<% } %>>KRW- South Korean Won</option>
			<option value="LKR" <% if(strTransactionCurrency.equals("LKR")) {%>selected<% } %>>LKR- Sri Lanka Rupee</option>
			<option value="SDG" <% if(strTransactionCurrency.equals("SDG")) {%>selected<% } %>>SDG- Sudanese Pound</option>
			<option value="SRD" <% if(strTransactionCurrency.equals("SRD")) {%>selected<% } %>>SRD- Suriname Dollar</option>
			<option value="SZL" <% if(strTransactionCurrency.equals("SZL")) {%>selected<% } %>>SZL- Swaziland Lilangeni</option>
			<option value="SEK" <% if(strTransactionCurrency.equals("SEK")) {%>selected<% } %>>SEK- Swedish Krona</option>
			<option value="CHF" <% if(strTransactionCurrency.equals("CHF")) {%>selected<% } %>>CHF- Swiss Franc</option>
			<option value="SYP" <% if(strTransactionCurrency.equals("SYP")) {%>selected<% } %>>SYP- Syrian Pound</option>
			<option value="TWD" <% if(strTransactionCurrency.equals("TWD")) {%>selected<% } %>>TWD- Taiwan New Dollar</option>
			<option value="TJS" <% if(strTransactionCurrency.equals("TJS")) {%>selected<% } %>>TJS- Tajik Somoni</option>
			<option value="TZS" <% if(strTransactionCurrency.equals("TZS")) {%>selected<% } %>>TZS- Tanzanian Shilling</option>
			<option value="THB" <% if(strTransactionCurrency.equals("THB")) {%>selected<% } %>>THB- Thai Baht</option>
			<option value="TOP" <% if(strTransactionCurrency.equals("TOP")) {%>selected<% } %>>TOP- Tongan Pa'anga</option>
			<option value="TTD" <% if(strTransactionCurrency.equals("TTD")) {%>selected<% } %>>TTD- Trinidad And Tobago Dollar</option>
			<option value="TND" <% if(strTransactionCurrency.equals("TND")) {%>selected<% } %>>TND- Tunisian Dinar</option>
			<option value="TRY" <% if(strTransactionCurrency.equals("TRY")) {%>selected<% } %>>TRY- Turkish Lira</option>
			<option value="TMT" <% if(strTransactionCurrency.equals("TMT")) {%>selected<% } %>>TMT- Turkmen New Manat</option>
			<option value="AED" <% if(strTransactionCurrency.equals("AED")) {%>selected<% } %>>AED- UAE Dirham</option>
			<option value="UGX" <% if(strTransactionCurrency.equals("UGX")) {%>selected<% } %>>UGX- Uganda New Shilling</option>
			<option value="XFU" <% if(strTransactionCurrency.equals("XFU")) {%>selected<% } %>>XFU- UIC Franc</option>
			<option value="UAH" <% if(strTransactionCurrency.equals("UAH")) {%>selected<% } %>>UAH- Ukrainian Hryvnia</option>
			<option value="UYU" <% if(strTransactionCurrency.equals("UYU")) {%>selected<% } %>>UYU- Uruguayan Peso Uruguayo</option>
			<option value="USD" <% if(strTransactionCurrency.equals("USD")) {%>selected<% } %>>USD- US Dollar</option>
			<option value="UZS" <% if(strTransactionCurrency.equals("UZS")) {%>selected<% } %>>UZS- Uzbekistani Sum</option>
			<option value="VUV" <% if(strTransactionCurrency.equals("VUV")) {%>selected<% } %>>VUV- Vanuatu Vatu</option>
			<option value="VEF" <% if(strTransactionCurrency.equals("VEF")) {%>selected<% } %>>VEF- Venezuelan Bolivar Fuerte</option>
			<option value="VND" <% if(strTransactionCurrency.equals("VND")) {%>selected<% } %>>VND- Vietnamese Dong</option>
			<option value="YER" <% if(strTransactionCurrency.equals("YER")) {%>selected<% } %>>YER- Yemeni Rial</option>
			<option value="ZMK" <% if(strTransactionCurrency.equals("ZMK")) {%>selected<% } %>>ZMK- Zambian Kwacha</option>
			<option value="ZWL" <% if(strTransactionCurrency.equals("ZWL")) {%>selected<% } %>>ZWL- Zimbabwe Dollar</option>
			<option value="XXX" <% if(strTransactionCurrency.equals("XXX")) {%>selected<% } %>>XXX- Not available </option>
			<option value="ZZZ" <% if(strTransactionCurrency.equals("ZZZ")) {%>selected<% } %>>ZZZ- Others </option>
		</select>
	</div>
	<div class="normalTextField">
		<label>14. Purpose of Transaction</label>
		<input type="text" name="transactionPurpose" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strTransactionPurpose%>"/>
	</div>
	<div class="normalTextField">
		<label>15. Risk Rating</label>
		<select name="riskRating">
			<option value="T1" <% if(strRiskRating.equals("T1")) {%>selected<% } %>>T1 - High Risk</option>
			<option value="T2" <% if(strRiskRating.equals("T2")) {%>selected<% } %>>T2 - Medium Risk</option>
			<option value="T3" <% if(strRiskRating.equals("T3")) {%>selected<% } %>>T3 - Low Risk</option>
			<option value="XX" <% if(strRiskRating.equals("XX")) {%>selected<% } %>>XX - Not categorised</option>
		</select>
	</div>
	<div><p style="font-weight: bolder; font-size: x-large;">Payment Instrument Details</p></div>
	<div class="normalTextField">
		<label>16. Payment instrument Number</label>
		<input type="text" name="paymentInstrumentNo" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strPaymentInstrumentNo%>"/>
	</div>
	<div class="normalTextField">
		<label>17. Payment Instrument Issue Institution Name</label>
		<input type="text" name="paymentInstrumentIssueInstName" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strPaymentInstrumentIssueInstName%>"/>
	</div>
	<div><p style="font-weight: bolder; font-size: x-large;">Customer Details</p></div>
	<div class="normalTextField">
		<label>18. Customer Name</label>
		<input type="text" name="customerName" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strCustomerName%>"/>
	</div>
	<div class="normalTextField">
		<label>19. Occupation</label>
		<input type="text" name="occupation" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strOccupation%>"/>
	</div>
	<div class="normalTextField">
		<label>20. Date of Birth</label>
		<input type="text" class="topOpenTextBox datepicker" id="dob" name="dob" placeholder="YYYY-MM-DD" <%=readOnly%> value="<%=strDateofBirth%>" />
	</div>
	<div class="normalTextField">
		<label>21. Gender</label>
		<select name="gender">
			<option value="M" <% if(strGender.equals("M")) {%>selected<% } %>>M - Male</option>
			<option value="F" <% if(strGender.equals("F")) {%>selected<% } %>>F - Female</option>
			<option value="X" <% if(strGender.equals("X")) {%>selected<% } %>>X - Not categorised</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>22. Nationality</label>
		<select name="nationality">
			<option value="IN" <% if(strNationality.equals("IN")) {%>selected<% } %> selected="selected">IN-India</option>
			<option value="AF" <% if(strNationality.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
			<option value="AX" <% if(strNationality.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
			<option value="AL" <% if(strNationality.equals("AL")) {%>selected<% } %>>AL-Albania</option>
			<option value="DZ" <% if(strNationality.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
			<option value="AS" <% if(strNationality.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
			<option value="AD" <% if(strNationality.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
			<option value="AO" <% if(strNationality.equals("AO")) {%>selected<% } %>>AO-Angola</option>
			<option value="AI" <% if(strNationality.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
			<option value="AQ" <% if(strNationality.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
			<option value="AG" <% if(strNationality.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
			<option value="AR" <% if(strNationality.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
			<option value="AM" <% if(strNationality.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
			<option value="AW" <% if(strNationality.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
			<option value="AU" <% if(strNationality.equals("AU")) {%>selected<% } %>>AU-Australia</option>
			<option value="AT" <% if(strNationality.equals("AT")) {%>selected<% } %>>AT-Austria</option>
			<option value="AZ" <% if(strNationality.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
			<option value="BS" <% if(strNationality.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
			<option value="BH" <% if(strNationality.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
			<option value="BD" <% if(strNationality.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
			<option value="BB" <% if(strNationality.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
			<option value="BY" <% if(strNationality.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
			<option value="BE" <% if(strNationality.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
			<option value="BZ" <% if(strNationality.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
			<option value="BJ" <% if(strNationality.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
			<option value="BM" <% if(strNationality.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
			<option value="BT" <% if(strNationality.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
			<option value="BO" <% if(strNationality.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
			<option value="BA" <% if(strNationality.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
			<option value="BW" <% if(strNationality.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
			<option value="BV" <% if(strNationality.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
			<option value="BR" <% if(strNationality.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
			<option value="IO" <% if(strNationality.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
			<option value="BN" <% if(strNationality.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
			<option value="BG" <% if(strNationality.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
			<option value="BF" <% if(strNationality.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
			<option value="BI" <% if(strNationality.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
			<option value="KH" <% if(strNationality.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
			<option value="CM" <% if(strNationality.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
			<option value="CA" <% if(strNationality.equals("CA")) {%>selected<% } %>>CA-Canada</option>
			<option value="CV" <% if(strNationality.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
			<option value="KY" <% if(strNationality.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
			<option value="CF" <% if(strNationality.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
			<option value="TD" <% if(strNationality.equals("TD")) {%>selected<% } %>>TD-Chad</option>
			<option value="CL" <% if(strNationality.equals("CL")) {%>selected<% } %>>CL-Chile</option>
			<option value="CN" <% if(strNationality.equals("CN")) {%>selected<% } %>>CN-China</option>
			<option value="CX" <% if(strNationality.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
			<option value="CC" <% if(strNationality.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
			<option value="CO" <% if(strNationality.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
			<option value="KM" <% if(strNationality.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
			<option value="CG" <% if(strNationality.equals("CG")) {%>selected<% } %>>CG-Congo</option>
			<option value="CD" <% if(strNationality.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
			<option value="CK" <% if(strNationality.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
			<option value="CR" <% if(strNationality.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
			<option value="CI" <% if(strNationality.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
			<option value="HR" <% if(strNationality.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
			<option value="CU" <% if(strNationality.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
			<option value="CY" <% if(strNationality.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
			<option value="CZ" <% if(strNationality.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
			<option value="DK" <% if(strNationality.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
			<option value="DJ" <% if(strNationality.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
			<option value="DM" <% if(strNationality.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
			<option value="DO" <% if(strNationality.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
			<option value="EC" <% if(strNationality.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
			<option value="EG" <% if(strNationality.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
			<option value="SV" <% if(strNationality.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
			<option value="GQ" <% if(strNationality.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
			<option value="ER" <% if(strNationality.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
			<option value="EE" <% if(strNationality.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
			<option value="ET" <% if(strNationality.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
			<option value="FK" <% if(strNationality.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
			<option value="FO" <% if(strNationality.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
			<option value="FJ" <% if(strNationality.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
			<option value="FI" <% if(strNationality.equals("FI")) {%>selected<% } %>>FI-Finland</option>
			<option value="FR" <% if(strNationality.equals("FR")) {%>selected<% } %>>FR-France</option>
			<option value="GF" <% if(strNationality.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
			<option value="PF" <% if(strNationality.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
			<option value="TF" <% if(strNationality.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
			<option value="GA" <% if(strNationality.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
			<option value="GM" <% if(strNationality.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
			<option value="GE" <% if(strNationality.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
			<option value="DE" <% if(strNationality.equals("DE")) {%>selected<% } %>>DE-Germany</option>
			<option value="GH" <% if(strNationality.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
			<option value="GI" <% if(strNationality.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
			<option value="GR" <% if(strNationality.equals("GR")) {%>selected<% } %>>GR-Greece</option>
			<option value="GL" <% if(strNationality.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
			<option value="GD" <% if(strNationality.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
			<option value="GP" <% if(strNationality.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
			<option value="GU" <% if(strNationality.equals("GU")) {%>selected<% } %>>GU-Guam</option>
			<option value="GT" <% if(strNationality.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
			<option value="GG" <% if(strNationality.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
			<option value="GN" <% if(strNationality.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
			<option value="GW" <% if(strNationality.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
			<option value="GY" <% if(strNationality.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
			<option value="HT" <% if(strNationality.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
			<option value="HM" <% if(strNationality.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
			<option value="VA" <% if(strNationality.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
			<option value="HN" <% if(strNationality.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
			<option value="HK" <% if(strNationality.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
			<option value="HU" <% if(strNationality.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
			<option value="IS" <% if(strNationality.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
			<option value="ID" <% if(strNationality.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
			<option value="IR" <% if(strNationality.equals("IR")) {%>selected<% } %>>IR-Iran</option>
			<option value="IQ" <% if(strNationality.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
			<option value="IE" <% if(strNationality.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
			<option value="IM" <% if(strNationality.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
			<option value="IL" <% if(strNationality.equals("IL")) {%>selected<% } %>>IL-Israel</option>
			<option value="IT" <% if(strNationality.equals("IT")) {%>selected<% } %>>IT-Italy</option>
			<option value="JM" <% if(strNationality.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
			<option value="JP" <% if(strNationality.equals("JP")) {%>selected<% } %>>JP-Japan</option>
			<option value="JE" <% if(strNationality.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
			<option value="JO" <% if(strNationality.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
			<option value="KZ" <% if(strNationality.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
			<option value="KE" <% if(strNationality.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
			<option value="KI" <% if(strNationality.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
			<option value="KP" <% if(strNationality.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
			<option value="KR" <% if(strNationality.equals("KR")) {%>selected<% } %>>KR-Korea</option>
			<option value="KW" <% if(strNationality.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
			<option value="KG" <% if(strNationality.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
			<option value="LA" <% if(strNationality.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
			<option value="LV" <% if(strNationality.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
			<option value="LB" <% if(strNationality.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
			<option value="LS" <% if(strNationality.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
			<option value="LR" <% if(strNationality.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
			<option value="LY" <% if(strNationality.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
			<option value="LI" <% if(strNationality.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
			<option value="LT" <% if(strNationality.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
			<option value="LU" <% if(strNationality.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
			<option value="MO" <% if(strNationality.equals("MO")) {%>selected<% } %>>MO-Macao</option>
			<option value="MK" <% if(strNationality.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
			<option value="MG" <% if(strNationality.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
			<option value="MW" <% if(strNationality.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
			<option value="MY" <% if(strNationality.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
			<option value="MV" <% if(strNationality.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
			<option value="ML" <% if(strNationality.equals("ML")) {%>selected<% } %>>ML-Mali</option>
			<option value="MT" <% if(strNationality.equals("MT")) {%>selected<% } %>>MT-Malta</option>
			<option value="MH" <% if(strNationality.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
			<option value="MQ" <% if(strNationality.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
			<option value="MR" <% if(strNationality.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
			<option value="MU" <% if(strNationality.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
			<option value="YT" <% if(strNationality.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
			<option value="MX" <% if(strNationality.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
			<option value="FM" <% if(strNationality.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
			<option value="MD" <% if(strNationality.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
			<option value="MC" <% if(strNationality.equals("MC")) {%>selected<% } %>>-Monaco</option>
			<option value="MN" <% if(strNationality.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
			<option value="ME" <% if(strNationality.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
			<option value="MS" <% if(strNationality.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
			<option value="MA" <% if(strNationality.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
			<option value="MZ" <% if(strNationality.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
			<option value="MM" <% if(strNationality.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
			<option value="NA" <% if(strNationality.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
			<option value="NR" <% if(strNationality.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
			<option value="NP" <% if(strNationality.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
			<option value="NL" <% if(strNationality.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
			<option value="AN" <% if(strNationality.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
			<option value="NC" <% if(strNationality.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
			<option value="NZ" <% if(strNationality.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
			<option value="NI" <% if(strNationality.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
			<option value="NE" <% if(strNationality.equals("NE")) {%>selected<% } %>>NE-Niger</option>
			<option value="NG" <% if(strNationality.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
			<option value="NU" <% if(strNationality.equals("NU")) {%>selected<% } %>>NU-Niue</option>
			<option value="NF" <% if(strNationality.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
			<option value="MP" <% if(strNationality.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
			<option value="NO" <% if(strNationality.equals("NO")) {%>selected<% } %>>NO-Norway</option>
			<option value="OM" <% if(strNationality.equals("OM")) {%>selected<% } %>>OM-Oman</option>
			<option value="PK" <% if(strNationality.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
			<option value="PW" <% if(strNationality.equals("PW")) {%>selected<% } %>>PW-Palau</option>
			<option value="PS" <% if(strNationality.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
			<option value="PA" <% if(strNationality.equals("PA")) {%>selected<% } %>>PA-Panama</option>
			<option value="PG" <% if(strNationality.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
			<option value="PY" <% if(strNationality.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
			<option value="PE" <% if(strNationality.equals("PE")) {%>selected<% } %>>PE-Peru</option>
			<option value="PH" <% if(strNationality.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
			<option value="PN" <% if(strNationality.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
			<option value="PL" <% if(strNationality.equals("PL")) {%>selected<% } %>>PL-Poland</option>
			<option value="PT" <% if(strNationality.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
			<option value="PR" <% if(strNationality.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
			<option value="QA" <% if(strNationality.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
			<option value="RE" <% if(strNationality.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
			<option value="RO" <% if(strNationality.equals("RO")) {%>selected<% } %>>RO-Romania</option>
			<option value="RU" <% if(strNationality.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
			<option value="RW" <% if(strNationality.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
			<option value="BL" <% if(strNationality.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
			<option value="SH" <% if(strNationality.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
			<option value="KN" <% if(strNationality.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
			<option value="LC" <% if(strNationality.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
			<option value="MF" <% if(strNationality.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
			<option value="PM" <% if(strNationality.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
			<option value="VC" <% if(strNationality.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
			<option value="WS" <% if(strNationality.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
			<option value="SM" <% if(strNationality.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
			<option value="ST" <% if(strNationality.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
			<option value="SA" <% if(strNationality.equals("AF")) {%>selected<% } %>>SA-Saudi Arabia</option>
			<option value="SN" <% if(strNationality.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
			<option value="RS" <% if(strNationality.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
			<option value="SC" <% if(strNationality.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
			<option value="SL" <% if(strNationality.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
			<option value="SG" <% if(strNationality.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
			<option value="SK" <% if(strNationality.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
			<option value="SI" <% if(strNationality.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
			<option value="SB" <% if(strNationality.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
			<option value="SO" <% if(strNationality.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
			<option value="ZA" <% if(strNationality.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
			<option value="GS" <% if(strNationality.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
			<option value="ES" <% if(strNationality.equals("ES")) {%>selected<% } %>>ES-Spain</option>
			<option value="LK" <% if(strNationality.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
			<option value="SD" <% if(strNationality.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
			<option value="SR" <% if(strNationality.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
			<option value="SJ" <% if(strNationality.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
			<option value="SZ" <% if(strNationality.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
			<option value="SE" <% if(strNationality.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
			<option value="CH" <% if(strNationality.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
			<option value="SY" <% if(strNationality.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
			<option value="TW" <% if(strNationality.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
			<option value="TJ" <% if(strNationality.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
			<option value="TZ" <% if(strNationality.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
			<option value="TH" <% if(strNationality.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
			<option value="TL" <% if(strNationality.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
			<option value="TG" <% if(strNationality.equals("TG")) {%>selected<% } %>>TG-Togo</option>
			<option value="TK" <% if(strNationality.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
			<option value="TO" <% if(strNationality.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
			<option value="TT" <% if(strNationality.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
			<option value="TN" <% if(strNationality.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
			<option value="TR" <% if(strNationality.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
			<option value="TM" <% if(strNationality.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
			<option value="TC" <% if(strNationality.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
			<option value="TV" <% if(strNationality.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
			<option value="UG" <% if(strNationality.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
			<option value="UA" <% if(strNationality.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
			<option value="AE" <% if(strNationality.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
			<option value="GB" <% if(strNationality.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
			<option value="US" <% if(strNationality.equals("US")) {%>selected<% } %>>US-United States</option>
			<option value="UM" <% if(strNationality.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
			<option value="UY" <% if(strNationality.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
			<option value="UZ" <% if(strNationality.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
			<option value="VU" <% if(strNationality.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
			<option value="VE" <% if(strNationality.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
			<option value="VN" <% if(strNationality.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
			<option value="VG" <% if(strNationality.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
			<option value="VI" <% if(strNationality.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
			<option value="WF" <% if(strNationality.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
			<option value="EH" <% if(strNationality.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
			<option value="YE" <% if(strNationality.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
			<option value="ZM" <% if(strNationality.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
			<option value="ZW" <% if(strNationality.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
			<option value="SS" <% if(strNationality.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
			<option value="CW" <% if(strNationality.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
			<option value="BQ" <% if(strNationality.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
			<option value="SX" <% if(strNationality.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
			<option value="XX" <% if(strNationality.equals("XX")) {%>selected<% } %>>XX-Not available </option>
			<option value="ZZ" <% if(strNationality.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>23. ID Type</label>
		<select name="idType">
			<option value="A" <% if(strCustIDType.equals("A")) {%>selected<% } %>>A - Passport</option>
			<option value="B" <% if(strCustIDType.equals("B")) {%>selected<% } %>>B - Election Id card</option>
			<option value="C" <% if(strCustIDType.equals("C")) {%>selected<% } %>>C - Pan card</option>
			<option value="D" <% if(strCustIDType.equals("D")) {%>selected<% } %>>D - ID card</option>
			<option value="E" <% if(strCustIDType.equals("E")) {%>selected<% } %>>E - Driving License</option>
			<option value="F" <% if(strCustIDType.equals("F")) {%>selected<% } %>>F - Account Introducer</option>
			<option value="G" <% if(strCustIDType.equals("G")) {%>selected<% } %>>G - UIDAI letter</option>
			<option value="H" <% if(strCustIDType.equals("H")) {%>selected<% } %>>H - NREGA job card</option>
			<option value="Z" <% if(strCustIDType.equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>24. ID Number</label>
		<input type="text"  name="idNumber" id="idNumber" class="txt2" size=30 maxlength=30 value="<%=strCustIDNo%>" />
	</div>
	<div class="normalTextField">
		<label>25. ID Issuing Authority</label>
		<input type="text"  name="idIssuingAuthority" id="idIssuingAuthority" class="txt2" size=30 maxlength=30 value="<%=strCustIDIssuingAuthority%>"/>
	</div>
	<div class="normalTextField">
		<label>26. ID Issuing Place</label>
		<input type="text"  name="idIssuingPlace" id="idIssuingPlace" class="txt2" size=30 maxlength=30 value="<%=strCustIDIssuingPlace%>"/>
	</div>
	<div class="normalTextField">
		<label>27. PAN</label>
		<input type="text"  name="custPAN" id="custPAN" class="txt2" size=30 maxlength=30 value="<%=strCustPAN%>"/>
	</div>
	<div class="normalTextField">
		<label>28. UIN</label>
		<input type="text"  name="custUIN" id="custUIN" class="txt2" size=30 maxlength=30 value="<%=strCustUIN%>"/>
	</div>
	<div class="normalTextField">
		<label>29. Address</label>
		<textarea name="custAddressLine" <%=readOnly%>><%=strCustAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>30. City</label>
		<input type="text"  name="custCity" id="custCity" class="txt2" size=30 maxlength=30 value="<%=strCustCity%>"/>
	</div>
	<div class="normalTextField">
		<label>31. State Code</label>
		<select name="stateCode">
			<option value="AN" title="Andaman & Nicobar" <% if(strCustState.equals("AN")) {%>selected<% } %>>AN- Andaman & Nicobar </option>
			<option value="AP" title="Andhra Pradesh" <% if(strCustState.equals("AP")) {%>selected<% } %>>AP- Andhra Pradesh</option>
			<option value="AR" title="Arunachal Pradesh" <% if(strCustState.equals("AR")) {%>selected<% } %>>AR- Arunachal Pradesh</option>
			<option value="AS" title="Assam" <% if(strCustState.equals("AS")) {%>selected<% } %>>AS- Assam</option>
			<option value="BR" title="Bihar" <% if(strCustState.equals("BR")) {%>selected<% } %>>BR- Bihar</option>
			<option value="CH" title="Chandigarh" <% if(strCustState.equals("CH")) {%>selected<% } %>>CH- Chandigarh</option>
			<option value="CG" title="Chattisgarh" <% if(strCustState.equals("CG")) {%>selected<% } %>>CG- Chattisgarh</option>
			<option value="DN" title="Dadra and Nagar Haveli" <% if(strCustState.equals("DN")) {%>selected<% } %>>DN- Dadra and Nagar Haveli</option>
			<option value="DD" title="Daman & Diu" <% if(strCustState.equals("DD")) {%>selected<% } %>>DD- Daman & Diu</option>
			<option value="DL" title="Delhi" <% if(strCustState.equals("DL")) {%>selected<% } %>>DL- Delhi</option>
			<option value="GA" title="Goa" <% if(strCustState.equals("GA")) {%>selected<% } %>>GA- Goa</option>
			<option value="GJ" title="Gujarat" <% if(strCustState.equals("GJ")) {%>selected<% } %>>GJ- Gujarat</option>
			<option value="HR" title="Haryana" <% if(strCustState.equals("HR")) {%>selected<% } %>>HR- Haryana</option>
			<option value="HP" title="Himachal Pradesh" <% if(strCustState.equals("HP")) {%>selected<% } %>>HP- Himachal Pradesh</option>
			<option value="JK" title="Jammu & Kashmir" <% if(strCustState.equals("JK")) {%>selected<% } %>>JK- Jammu & Kashmir</option>
			<option value="JH" title="Jharkhand" <% if(strCustState.equals("JH")) {%>selected<% } %>>JH- Jharkhand</option>
			<option value="KA" title="Karnataka" <% if(strCustState.equals("KA")) {%>selected<% } %>>KA- Karnataka</option>
			<option value="KL" title="Kerala" <% if(strCustState.equals("KL")) {%>selected<% } %>>KL- Kerala</option>
			<option value="LD" title="Lakshadweep" <% if(strCustState.equals("LD")) {%>selected<% } %>>LD- Lakshadweep</option>
			<option value="MP" title="Madhya Pradesh" <% if(strCustState.equals("MP")) {%>selected<% } %>>MP- Madhya Pradesh</option>
			<option value="MH" title="Maharashtra" <% if(strCustState.equals("MH")) {%>selected<% } %>>MH- Maharashtra</option>
			<option value="MN" title="Manipur" <% if(strCustState.equals("MN")) {%>selected<% } %>>MN- Manipur</option>
			<option value="ML" title="Meghalaya" <% if(strCustState.equals("ML")) {%>selected<% } %>>ML- Meghalaya</option>
			<option value="MZ" title="Mizoram" <% if(strCustState.equals("MZ")) {%>selected<% } %>>MZ- Mizoram</option>
			<option value="NL" title="Nagaland" <% if(strCustState.equals("NL")) {%>selected<% } %>>NL- Nagaland</option>
			<option value="OR" title="Orissa" <% if(strCustState.equals("OR")) {%>selected<% } %>>OR- Orissa</option>
			<option value="PY" title="Pondicherry" <% if(strCustState.equals("PY")) {%>selected<% } %>>PY- Pondicherry</option>
			<option value="PB" title="Punjab" <% if(strCustState.equals("PB")) {%>selected<% } %>>PB- Punjab</option>
			<option value="RJ" title="Rajasthan" <% if(strCustState.equals("RJ")) {%>selected<% } %>>RJ- Rajasthan</option>
			<option value="SK" title="Sikkim" <% if(strCustState.equals("SK")) {%>selected<% } %>>SK- Sikkim</option>
			<option value="TN" title="Tamil Nadu" <% if(strCustState.equals("TN")) {%>selected<% } %>>TN- Tamil Nadu</option>
			<option value="TR" title="Tripura" <% if(strCustState.equals("TR")) {%>selected<% } %>>TR- Tripura</option>
			<option value="UP" title="Uttar Pradesh" <% if(strCustState.equals("UP")) {%>selected<% } %>>UP- Uttar Pradesh</option>
			<option value="UA" title="Uttarakhand" <% if(strCustState.equals("UA")) {%>selected<% } %>>UA- Uttarakhand</option>
			<option value="WB" title="West Bengal" <% if(strCustState.equals("WB")) {%>selected<% } %>>WB- West Bengal</option>
			<option value="ZZ" title="Others" <% if(strCustState.equals("ZZ")) {%>selected<% } %>>ZZ- Others</option>
			<option value="XX" title="Not Applicable" <% if(strCustState.equals("XX")) {%>selected<% } %>>XX -Not Applicable</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>32. Country Code</label>
		<select name="countryCode">
			<option value="IN" <% if(strCustCountry.equals("IN")) {%>selected<% } %> selected="selected">IN-India</option>
			<option value="AF" <% if(strCustCountry.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
			<option value="AX" <% if(strCustCountry.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
			<option value="AL" <% if(strCustCountry.equals("AL")) {%>selected<% } %>>AL-Albania</option>
			<option value="DZ" <% if(strCustCountry.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
			<option value="AS" <% if(strCustCountry.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
			<option value="AD" <% if(strCustCountry.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
			<option value="AO" <% if(strCustCountry.equals("AO")) {%>selected<% } %>>AO-Angola</option>
			<option value="AI" <% if(strCustCountry.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
			<option value="AQ" <% if(strCustCountry.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
			<option value="AG" <% if(strCustCountry.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
			<option value="AR" <% if(strCustCountry.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
			<option value="AM" <% if(strCustCountry.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
			<option value="AW" <% if(strCustCountry.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
			<option value="AU" <% if(strCustCountry.equals("AU")) {%>selected<% } %>>AU-Australia</option>
			<option value="AT" <% if(strCustCountry.equals("AT")) {%>selected<% } %>>AT-Austria</option>
			<option value="AZ" <% if(strCustCountry.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
			<option value="BS" <% if(strCustCountry.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
			<option value="BH" <% if(strCustCountry.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
			<option value="BD" <% if(strCustCountry.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
			<option value="BB" <% if(strCustCountry.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
			<option value="BY" <% if(strCustCountry.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
			<option value="BE" <% if(strCustCountry.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
			<option value="BZ" <% if(strCustCountry.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
			<option value="BJ" <% if(strCustCountry.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
			<option value="BM" <% if(strCustCountry.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
			<option value="BT" <% if(strCustCountry.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
			<option value="BO" <% if(strCustCountry.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
			<option value="BA" <% if(strCustCountry.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
			<option value="BW" <% if(strCustCountry.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
			<option value="BV" <% if(strCustCountry.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
			<option value="BR" <% if(strCustCountry.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
			<option value="IO" <% if(strCustCountry.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
			<option value="BN" <% if(strCustCountry.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
			<option value="BG" <% if(strCustCountry.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
			<option value="BF" <% if(strCustCountry.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
			<option value="BI" <% if(strCustCountry.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
			<option value="KH" <% if(strCustCountry.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
			<option value="CM" <% if(strCustCountry.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
			<option value="CA" <% if(strCustCountry.equals("CA")) {%>selected<% } %>>CA-Canada</option>
			<option value="CV" <% if(strCustCountry.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
			<option value="KY" <% if(strCustCountry.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
			<option value="CF" <% if(strCustCountry.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
			<option value="TD" <% if(strCustCountry.equals("TD")) {%>selected<% } %>>TD-Chad</option>
			<option value="CL" <% if(strCustCountry.equals("CL")) {%>selected<% } %>>CL-Chile</option>
			<option value="CN" <% if(strCustCountry.equals("CN")) {%>selected<% } %>>CN-China</option>
			<option value="CX" <% if(strCustCountry.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
			<option value="CC" <% if(strCustCountry.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
			<option value="CO" <% if(strCustCountry.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
			<option value="KM" <% if(strCustCountry.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
			<option value="CG" <% if(strCustCountry.equals("CG")) {%>selected<% } %>>CG-Congo</option>
			<option value="CD" <% if(strCustCountry.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
			<option value="CK" <% if(strCustCountry.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
			<option value="CR" <% if(strCustCountry.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
			<option value="CI" <% if(strCustCountry.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
			<option value="HR" <% if(strCustCountry.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
			<option value="CU" <% if(strCustCountry.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
			<option value="CY" <% if(strCustCountry.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
			<option value="CZ" <% if(strCustCountry.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
			<option value="DK" <% if(strCustCountry.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
			<option value="DJ" <% if(strCustCountry.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
			<option value="DM" <% if(strCustCountry.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
			<option value="DO" <% if(strCustCountry.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
			<option value="EC" <% if(strCustCountry.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
			<option value="EG" <% if(strCustCountry.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
			<option value="SV" <% if(strCustCountry.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
			<option value="GQ" <% if(strCustCountry.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
			<option value="ER" <% if(strCustCountry.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
			<option value="EE" <% if(strCustCountry.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
			<option value="ET" <% if(strCustCountry.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
			<option value="FK" <% if(strCustCountry.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
			<option value="FO" <% if(strCustCountry.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
			<option value="FJ" <% if(strCustCountry.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
			<option value="FI" <% if(strCustCountry.equals("FI")) {%>selected<% } %>>FI-Finland</option>
			<option value="FR" <% if(strCustCountry.equals("FR")) {%>selected<% } %>>FR-France</option>
			<option value="GF" <% if(strCustCountry.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
			<option value="PF" <% if(strCustCountry.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
			<option value="TF" <% if(strCustCountry.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
			<option value="GA" <% if(strCustCountry.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
			<option value="GM" <% if(strCustCountry.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
			<option value="GE" <% if(strCustCountry.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
			<option value="DE" <% if(strCustCountry.equals("DE")) {%>selected<% } %>>DE-Germany</option>
			<option value="GH" <% if(strCustCountry.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
			<option value="GI" <% if(strCustCountry.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
			<option value="GR" <% if(strCustCountry.equals("GR")) {%>selected<% } %>>GR-Greece</option>
			<option value="GL" <% if(strCustCountry.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
			<option value="GD" <% if(strCustCountry.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
			<option value="GP" <% if(strCustCountry.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
			<option value="GU" <% if(strCustCountry.equals("GU")) {%>selected<% } %>>GU-Guam</option>
			<option value="GT" <% if(strCustCountry.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
			<option value="GG" <% if(strCustCountry.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
			<option value="GN" <% if(strCustCountry.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
			<option value="GW" <% if(strCustCountry.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
			<option value="GY" <% if(strCustCountry.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
			<option value="HT" <% if(strCustCountry.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
			<option value="HM" <% if(strCustCountry.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
			<option value="VA" <% if(strCustCountry.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
			<option value="HN" <% if(strCustCountry.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
			<option value="HK" <% if(strCustCountry.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
			<option value="HU" <% if(strCustCountry.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
			<option value="IS" <% if(strCustCountry.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
			<option value="ID" <% if(strCustCountry.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
			<option value="IR" <% if(strCustCountry.equals("IR")) {%>selected<% } %>>IR-Iran</option>
			<option value="IQ" <% if(strCustCountry.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
			<option value="IE" <% if(strCustCountry.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
			<option value="IM" <% if(strCustCountry.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
			<option value="IL" <% if(strCustCountry.equals("IL")) {%>selected<% } %>>IL-Israel</option>
			<option value="IT" <% if(strCustCountry.equals("IT")) {%>selected<% } %>>IT-Italy</option>
			<option value="JM" <% if(strCustCountry.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
			<option value="JP" <% if(strCustCountry.equals("JP")) {%>selected<% } %>>JP-Japan</option>
			<option value="JE" <% if(strCustCountry.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
			<option value="JO" <% if(strCustCountry.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
			<option value="KZ" <% if(strCustCountry.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
			<option value="KE" <% if(strCustCountry.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
			<option value="KI" <% if(strCustCountry.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
			<option value="KP" <% if(strCustCountry.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
			<option value="KR" <% if(strCustCountry.equals("KR")) {%>selected<% } %>>KR-Korea</option>
			<option value="KW" <% if(strCustCountry.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
			<option value="KG" <% if(strCustCountry.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
			<option value="LA" <% if(strCustCountry.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
			<option value="LV" <% if(strCustCountry.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
			<option value="LB" <% if(strCustCountry.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
			<option value="LS" <% if(strCustCountry.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
			<option value="LR" <% if(strCustCountry.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
			<option value="LY" <% if(strCustCountry.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
			<option value="LI" <% if(strCustCountry.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
			<option value="LT" <% if(strCustCountry.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
			<option value="LU" <% if(strCustCountry.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
			<option value="MO" <% if(strCustCountry.equals("MO")) {%>selected<% } %>>MO-Macao</option>
			<option value="MK" <% if(strCustCountry.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
			<option value="MG" <% if(strCustCountry.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
			<option value="MW" <% if(strCustCountry.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
			<option value="MY" <% if(strCustCountry.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
			<option value="MV" <% if(strCustCountry.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
			<option value="ML" <% if(strCustCountry.equals("ML")) {%>selected<% } %>>ML-Mali</option>
			<option value="MT" <% if(strCustCountry.equals("MT")) {%>selected<% } %>>MT-Malta</option>
			<option value="MH" <% if(strCustCountry.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
			<option value="MQ" <% if(strCustCountry.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
			<option value="MR" <% if(strCustCountry.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
			<option value="MU" <% if(strCustCountry.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
			<option value="YT" <% if(strCustCountry.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
			<option value="MX" <% if(strCustCountry.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
			<option value="FM" <% if(strCustCountry.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
			<option value="MD" <% if(strCustCountry.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
			<option value="MC" <% if(strCustCountry.equals("MC")) {%>selected<% } %>>-Monaco</option>
			<option value="MN" <% if(strCustCountry.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
			<option value="ME" <% if(strCustCountry.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
			<option value="MS" <% if(strCustCountry.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
			<option value="MA" <% if(strCustCountry.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
			<option value="MZ" <% if(strCustCountry.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
			<option value="MM" <% if(strCustCountry.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
			<option value="NA" <% if(strCustCountry.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
			<option value="NR" <% if(strCustCountry.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
			<option value="NP" <% if(strCustCountry.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
			<option value="NL" <% if(strCustCountry.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
			<option value="AN" <% if(strCustCountry.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
			<option value="NC" <% if(strCustCountry.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
			<option value="NZ" <% if(strCustCountry.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
			<option value="NI" <% if(strCustCountry.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
			<option value="NE" <% if(strCustCountry.equals("NE")) {%>selected<% } %>>NE-Niger</option>
			<option value="NG" <% if(strCustCountry.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
			<option value="NU" <% if(strCustCountry.equals("NU")) {%>selected<% } %>>NU-Niue</option>
			<option value="NF" <% if(strCustCountry.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
			<option value="MP" <% if(strCustCountry.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
			<option value="NO" <% if(strCustCountry.equals("NO")) {%>selected<% } %>>NO-Norway</option>
			<option value="OM" <% if(strCustCountry.equals("OM")) {%>selected<% } %>>OM-Oman</option>
			<option value="PK" <% if(strCustCountry.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
			<option value="PW" <% if(strCustCountry.equals("PW")) {%>selected<% } %>>PW-Palau</option>
			<option value="PS" <% if(strCustCountry.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
			<option value="PA" <% if(strCustCountry.equals("PA")) {%>selected<% } %>>PA-Panama</option>
			<option value="PG" <% if(strCustCountry.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
			<option value="PY" <% if(strCustCountry.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
			<option value="PE" <% if(strCustCountry.equals("PE")) {%>selected<% } %>>PE-Peru</option>
			<option value="PH" <% if(strCustCountry.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
			<option value="PN" <% if(strCustCountry.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
			<option value="PL" <% if(strCustCountry.equals("PL")) {%>selected<% } %>>PL-Poland</option>
			<option value="PT" <% if(strCustCountry.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
			<option value="PR" <% if(strCustCountry.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
			<option value="QA" <% if(strCustCountry.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
			<option value="RE" <% if(strCustCountry.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
			<option value="RO" <% if(strCustCountry.equals("RO")) {%>selected<% } %>>RO-Romania</option>
			<option value="RU" <% if(strCustCountry.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
			<option value="RW" <% if(strCustCountry.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
			<option value="BL" <% if(strCustCountry.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
			<option value="SH" <% if(strCustCountry.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
			<option value="KN" <% if(strCustCountry.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
			<option value="LC" <% if(strCustCountry.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
			<option value="MF" <% if(strCustCountry.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
			<option value="PM" <% if(strCustCountry.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
			<option value="VC" <% if(strCustCountry.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
			<option value="WS" <% if(strCustCountry.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
			<option value="SM" <% if(strCustCountry.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
			<option value="ST" <% if(strCustCountry.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
			<option value="SA" <% if(strCustCountry.equals("AF")) {%>selected<% } %>>SA-Saudi Arabia</option>
			<option value="SN" <% if(strCustCountry.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
			<option value="RS" <% if(strCustCountry.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
			<option value="SC" <% if(strCustCountry.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
			<option value="SL" <% if(strCustCountry.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
			<option value="SG" <% if(strCustCountry.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
			<option value="SK" <% if(strCustCountry.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
			<option value="SI" <% if(strCustCountry.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
			<option value="SB" <% if(strCustCountry.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
			<option value="SO" <% if(strCustCountry.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
			<option value="ZA" <% if(strCustCountry.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
			<option value="GS" <% if(strCustCountry.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
			<option value="ES" <% if(strCustCountry.equals("ES")) {%>selected<% } %>>ES-Spain</option>
			<option value="LK" <% if(strCustCountry.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
			<option value="SD" <% if(strCustCountry.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
			<option value="SR" <% if(strCustCountry.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
			<option value="SJ" <% if(strCustCountry.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
			<option value="SZ" <% if(strCustCountry.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
			<option value="SE" <% if(strCustCountry.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
			<option value="CH" <% if(strCustCountry.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
			<option value="SY" <% if(strCustCountry.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
			<option value="TW" <% if(strCustCountry.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
			<option value="TJ" <% if(strCustCountry.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
			<option value="TZ" <% if(strCustCountry.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
			<option value="TH" <% if(strCustCountry.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
			<option value="TL" <% if(strCustCountry.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
			<option value="TG" <% if(strCustCountry.equals("TG")) {%>selected<% } %>>TG-Togo</option>
			<option value="TK" <% if(strCustCountry.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
			<option value="TO" <% if(strCustCountry.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
			<option value="TT" <% if(strCustCountry.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
			<option value="TN" <% if(strCustCountry.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
			<option value="TR" <% if(strCustCountry.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
			<option value="TM" <% if(strCustCountry.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
			<option value="TC" <% if(strCustCountry.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
			<option value="TV" <% if(strCustCountry.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
			<option value="UG" <% if(strCustCountry.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
			<option value="UA" <% if(strCustCountry.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
			<option value="AE" <% if(strCustCountry.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
			<option value="GB" <% if(strCustCountry.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
			<option value="US" <% if(strCustCountry.equals("US")) {%>selected<% } %>>US-United States</option>
			<option value="UM" <% if(strCustCountry.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
			<option value="UY" <% if(strCustCountry.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
			<option value="UZ" <% if(strCustCountry.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
			<option value="VU" <% if(strCustCountry.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
			<option value="VE" <% if(strCustCountry.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
			<option value="VN" <% if(strCustCountry.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
			<option value="VG" <% if(strCustCountry.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
			<option value="VI" <% if(strCustCountry.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
			<option value="WF" <% if(strCustCountry.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
			<option value="EH" <% if(strCustCountry.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
			<option value="YE" <% if(strCustCountry.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
			<option value="ZM" <% if(strCustCountry.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
			<option value="ZW" <% if(strCustCountry.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
			<option value="SS" <% if(strCustCountry.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
			<option value="CW" <% if(strCustCountry.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
			<option value="BQ" <% if(strCustCountry.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
			<option value="SX" <% if(strCustCountry.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
			<option value="XX" <% if(strCustCountry.equals("XX")) {%>selected<% } %>>XX-Not available </option>
			<option value="ZZ" <% if(strCustCountry.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>33. PIN Code</label>
		<input type="text"  name="pinCode" id="pinCode" class="txt2" size=30 maxlength=30 value="<%=strCustPIN%>"/>
	</div>
	<div class="normalTextField">
		<label>34. Telephone</label>
		<input type="text" name="telephone" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strCustTelephone%>"/>
	</div>
	<div class="normalTextField">
		<label>35. Mobile</label>
		<input type="text" name="mobile" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strCustMobile%>"/>
	</div>
	<div class="normalTextField">
		<label>36. FAX</label>
		<input type="text" name="faxNo" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strCustFAX%>"/>
	</div>
	<div class="normalTextField">
		<label>37. E-mail Address</label>
		<input type="text" name="emailAddress" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strCustEmail%>"/>
	</div>
	<div><p style="font-weight: bolder; font-size: x-large;">Additional Details</p></div>
	<div class="normalTextField">
		<label>38. Account Number</label>
		<input type="text" name="accountNo" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strAccountNo%>"/>
	</div>
	<div class="normalTextField">
		<label>39. Account with Institution Name</label>
		<input type="text" name="accountInstName" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strAccountInstName%>"/>
	</div>
	<div class="normalTextField">
		<label>40. Institution Reference Number</label>
		<input type="text" name="instRefNo" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strInstRefNo%>"/>
	</div>
	<div class="normalTextField">
		<label>41. Related Institution Name</label>
		<input type="text" name="relatedInstName" <%=readOnly%> class="txt2" size=30 maxlength=30 value="<%=strRelatedInstName%>"/>
	</div>
	<div class="normalTextField">
		<label>42. Related Institution Flag</label>
		<select name="relatedInstFlag">
			<option value="D" <% if(strRelatedInstFlag.equals("D")) {%>selected<% } %>>D - Acquirer Institution</option>
			<option value="E" <% if(strRelatedInstFlag.equals("E")) {%>selected<% } %>>E - Sender's  Correspondent Institution</option>
			<option value="F" <% if(strRelatedInstFlag.equals("F")) {%>selected<% } %>>F - Receiver's Correspondent Institution</option>
			<option value="Z" <% if(strRelatedInstFlag.equals("Z")) {%>selected<% } %>>Z - Others</option>
			<option value="X" <% if(strRelatedInstFlag.equals("X")) {%>selected<% } %>>X - Not categorised</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>43. Transaction Remarks</label>
		<textarea name="txnRemarks" <%=readOnly%>><%=strTxnRemarks%></textarea>
	</div>
	
	<div class="mainButtons" style="padding-top: 20px; text-align: center;">
		<%-- <input type="button" value="Save" <%=disabled%> onclick="setValues()" class="diffButton"/> --%>
		<input type="submit" value="Save" <%=disabled%> />
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
	</div>
</form>
</div>
</body>
</html>

<%}catch(Exception e){e.printStackTrace();}%>
