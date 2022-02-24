<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<% 
String caseNo = (request.getAttribute("caseNo") == null?"N.A":(String)request.getAttribute("caseNo"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		var caseNo = '${caseNo}';
	
		/*$("#saveNEPAL_STR").click(function(){
			var formObj = $("#nepalSTRForm");
			var formData = $(formObj).serialize();
			//document.write(formData);
			$.ajax({
				url: "${pageContext.request.contextPath}/common/saveNEPAL_STR" ,
				cache: false,
				data: formData+"&caseNo="+caseNo,
				type: "POST",
				success: function(res){
					alert(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		*/

		$("#exportXMLNEPAL_STR").click(function(){
		//var formObj = $("#nepalSTRForm");
		//var formData = $(formObj).serialize();
		//document.write(formData);
		//alert(caseNo);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/exportXMLNEPAL_STR" ,
			cache: false,
			data: "caseNo="+caseNo,
			type: "POST",
			success: function(res){
				alert(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});

	});

	function exportXML(caseNo){
		if(confirm("DO you want to Save this STR as XML ?")){
			window.open('${pageContext.request.contextPath}/common/exportXMLNEPAL_STR?caseNo='+caseNo);
		}
	}
		
</script>

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<title>Nepal STR</title>
</head>
<style type="text/css">
	fieldset{
	border: 1px groove #ddd !important;
    padding: 5px 10px 5px 10px !important;
    margin: 20px 40px 20px 40px !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	.alignRadio{
 	position: relative;
 	top: 1px;
	}
	
	.resizeTextBox{
		text-align: justify;
		padding:2px 5px;
		height: 28px;
		font-size:14px;
		font-weight: normal;
		line-height:1.42857143;
		color:#555;
		border:1px solid #ccc;
		border-radius:4px;
		-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	}
</style>

<body>
<form action="${pageContext.request.contextPath}/common/saveNEPAL_STR" method="POST" id="nepalSTRForm">

		<h4 style="font-weight: bold; text-align: center; padding-top: 15px;">Suspicious Transaction Report (STR) Form</h4></td>
<table>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 0 0 0 10px; font-weight: bold;">
			A.Reporting Institution:	
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 0 10px 0 20px;">
			1. Name of the Institution/Branch:	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRRepInstName" name="NEPSTRREPINSTNAME"  value="${RECORD['NEPSTRREPINSTNAME']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 0 0 0 10px; font-weight: bold;">
			B. Details of Customer:	
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			1. Name of the account holder/s/customer:	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustName" name="NEPSTRCUSTNAME"  value="${RECORD['NEPSTRCUSTNAME']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			2. Address:	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustAddress" name="NEPSTRCUSTADDRESS"  value="${RECORD['NEPSTRCUSTADDRESS']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			3. Profession (if applicable):	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustProfession" name="NEPSTRCUSTPROFESSION"  value="${RECORD['NEPSTRCUSTPROFESSION']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			4. Nationality (if applicable):	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustNationality" name="NEPSTRCUSTNATIONALITY"  value="${RECORD['NEPSTRCUSTNATIONALITY']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			5. Other account(s) number (if any):	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustOtherAccNo" name="NEPSTRCUSTOTHERACCNO"  value="${RECORD['NEPSTRCUSTOTHERACCNO']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			6. Other business (if any):	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustOtherBsns" name="NEPSTRCUSTOTHERBSNS"  value="${RECORD['NEPSTRCUSTOTHERBSNS']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			7. Father/Mother's name (if applicable):	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustGuardianName" name="NEPSTRCUSTGUARDIANNAME"  value="${RECORD['NEPSTRCUSTGUARDIANNAME']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			8. Date of birth/establishment:	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRCustDOB" name="NEPSTRCUSTDOB"  value="${RECORD['NEPSTRCUSTDOB']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; font-weight: bold;">
			B. Account/Transaction Details :	
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			1. Account number/transaction:	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRAccOrTxnNo" name="NEPSTRACCORTXNNO"  value="${RECORD['NEPSTRACCORTXNNO']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			2. Nature of the account/transaction<span style="color: red;">*</span>:	</br>
			(Current/savings/loan/other, pls. specify)
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRAccOrTxnNature" name="NEPSTRACCORTXNNATURE"  value="${RECORD['NEPSTRACCORTXNNATURE']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			3. Nature of ownership:</br>
			(Individual/proprietorship/Partnership/company/other, pls. specify)	
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTROwnershipNature" name="NEPSTROWNERSHIPNATURE"  value="${RECORD['NEPSTROWNERSHIPNATURE']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			4. Date of opening/transaction:
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRTxnDate" name="NEPSTRTXNDATE"  value="${RECORD['NEPSTRTXNDATE']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			5. Other account(s) number/transaction (if any):
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTROtherAccTxnNo" name="NEPSTROTHERACCTXNNO"  value="${RECORD['NEPSTROTHERACCTXNNO']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			6. Amount:
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRAmount" name="NEPSTRAMOUNT"  value="${RECORD['NEPSTRAMOUNT']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style=" padding: 10px 10px 0 20px;">
			7. Others<span style="color: red;">*</span>:	</br>
			Cash/Transfer/Clearing/TT/etc. Add paper if necessary 
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTROtherAccTxnDetail" name="NEPSTROTHERACCTXNDETAIL"  value="${RECORD['NEPSTROTHERACCTXNDETAIL']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; font-weight: bold;">
			B. Reasons for considering the transaction(s) as unusual/suspicious?	
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusClientIdentity" value="Identity of clients" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Identity of clients'}">checked="checked"</c:if>> Identity of clients
		</td>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="50%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusAccActivity" value="Activity in account" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Activity in account'}">checked="checked"</c:if>> Activity in account
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusClientBackground" value="Background of client" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Background of client'}">checked="checked"</c:if>> Background of client
		</td>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="50%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusMulAcc" value="Multiple accounts" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Multiple accounts'}">checked="checked"</c:if>> Multiple accounts
		</td>
	</tr>	
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusTxnNature" value="Nature of transaction" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Nature of transaction'}">checked="checked"</c:if>> Nature of transaction
		</td>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="50%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusTxnVal" value="Value of transaction" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Value of transaction'}">checked="checked"</c:if>> Value of transaction
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			<input type="radio" class="alignRadio"  id="rsnSusOtherRsn" value="Other reason" name="NEPSTRREASONFORSUSPICION"
			<c:if test="${RECORD['NEPSTRREASONFORSUSPICION'] eq 'Other reason'}">checked="checked"</c:if>> Other reason(Please Specify)
		</td>
		<td colspan ="2" style=" padding: 10px 20px 0 0;">
			<input type="text" class="form-control input-sm" id= "nepalSTRSusReasonOtherDetails" name="NEPSTROTHERSUSRSNDETAIL"  value="${RECORD['NEPSTROTHERSUSRSNDETAIL']}"/>
		</td>
	</tr>
	<tr>
		<td width="5%" >&nbsp;</td>
		<td colspan ="3" style=" padding: 10px 20px 0 20px;">
			<textarea rows="10" cols="130" class="form-control input-sm" id="rsnSummary" name="NEPSTRRSNSUMMARY" placeholder="(Mention summary of suspicious and consequence of events)">${RECORD['REASONSUMMARY']}</textarea>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; font-weight: bold;">
			E. Suspicious Activity Information	<br>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; ">
			Summary characterization of suspicious activity:
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			a. <input type="radio" class="alignRadio"  id="susActInfoCorruption" value="Corruption" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Corruption'}">checked="checked"</c:if>> Corruption/Gratuity
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			b. <input type="radio" class="alignRadio"  id="susActInfoChqFraud" value="Cheque Fraud" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Cheque Fraud'}">checked="checked"</c:if>> Cheque Fraud
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			c. <input type="radio" class="alignRadio"  id="susActInfoTaxEvasion" value="Tax Evasion" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Tax Evasion'}">checked="checked"</c:if>> Tax Evasion
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			d. <input type="radio" class="alignRadio"  id="susActInfoLoanFraud" value="Loan Fraud" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Loan Fraud'}">checked="checked"</c:if>> Loan Fraud
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			e. <input type="radio" class="alignRadio"  id="susActInfoFalseStatement" value="False Statement" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'False Statement'}">checked="checked"</c:if>> False Statement
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			f. <input type="radio" class="alignRadio"  id="susActInfoWireFrauds" value="Wire Frauds" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'WireFrauds'}">checked="checked"</c:if>> E or wire frauds (debit/credit or other card)
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			g. <input type="radio" class="alignRadio"  id="susActInfoIdTheft" value="Identity Theft" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Identity Theft'}">checked="checked"</c:if>> Identity Theft
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			h. <input type="radio" class="alignRadio"  id="susActInfoTerroristFinancing" value="Terrorist Financing" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Terrorist Financing'}">checked="checked"</c:if>> Terrorist Financing
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			i. <input type="radio" class="alignRadio"  id="susActInfoStructuring" value="Structuring" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Structuring'}">checked="checked"</c:if>> Structuring
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			j. <input type="radio" class="alignRadio"  id="susActInfoMysteriousDisappearance" value="Mysterious Disappearance" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Mysterious Disappearance'}">checked="checked"</c:if>> Mysterious Disappearance/Behaviour
		</td>
	</tr>
	<tr>
		<td width="5%" style="padding: 10px 0 0 10px;">&nbsp;</td>
		<td width="40%" style=" padding: 10px 0 0 20px;">
			k. <input type="radio" class="alignRadio"  id="susActInfoCounterfeitInstrument" value="Counterfeit Instrument" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Counterfeit Instrument'}">checked="checked"</c:if>> Counterfeit Instrument
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" style=" padding: 10px 20px 0 0;">
			l. <input type="radio" class="alignRadio"  id="susActInfoMisuseOfPositionOrSelf" value="Misuse of Position or Self" name="NEPSTRSUSACTINFO"
			<c:if test="${RECORD['NEPSTRSUSACTINFO'] eq 'Misuse of Position or Self'}">checked="checked"</c:if>> Misuse of Position or Self
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; font-weight: bold;">
			F.  Has the suspicious,transaction/activity had a material impact on or otherwise affected the financial soundness of the Bank/FI? 	
		</td>
		<td width="5%">&nbsp;</td>
		<td width ="50%" style=" padding: 10px 20px 0 0;">
			Yes <input type="radio" class="alignRadio"  id="impactOnBankYes" value="Y" name="NEPSTRIMPACTONBANK"
			<c:if test="${RECORD['NEPSTRIMPACTONBANK'] eq 'Y'}">checked="checked"</c:if>>  
			No <input type="radio" class="alignRadio"  id="impactOnBankNo" value="N" name="NEPSTRIMPACTONBANK"
			<c:if test="${RECORD['NEPSTRIMPACTONBANK'] eq 'N'}">checked="checked"</c:if>>
		</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" style="padding: 10px 0 0 10px; font-weight: bold;">
			G.   Has the Bank/FI taken any action in this context? If yes, give details 	
		</td>
	</tr>	
	</table>
	<fieldset>
		<table>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Signature(Compliance Officer or Authorized Officer) :
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRComplOffiSign" name="NEPSTRCOMPLOFFISIGN"  value="${RECORD['NEPSTRCOMPLOFFISIGN']}"/>
				</td>
			</tr>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Name:
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRComplOffiName" name="NEPSTRNEPSTRCOMPLOFFINAME"  value="${RECORD['NEPSTRNEPSTRCOMPLOFFINAME']}"/>
				</td>
			</tr>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Date:
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRActionDate" name="NEPSTRACTIONDATE"  value="${RECORD['NEPSTRACTIONDATE']}"/>
				</td>
			</tr>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Phone:
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRComplOffiPhNo" name="NEPSTRCOMPLOFFIPHNO"  value="${RECORD['NEPSTRCOMPLOFFIPHNO']}"/>
				</td>
			</tr>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Email:
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRComplOffiEmail" name="NEPSTRCOMPLOFFIEMAIL"  value="${RECORD['NEPSTRCOMPLOFFIEMAIL']}"/>
				</td>
			</tr>
			<tr>
				<td width="40%" style="padding: 10px 0 0 10px; ">
					Fax:
				</td>
				<td width="5%">&nbsp;</td>
				<td width ="45%" style=" padding: 10px 20px 0 0;">
					<input type="text" class="form-control input-sm" id= "nepalSTRComplOffiFax" name="NEPSTRCOMPLOFFIFAX"  value="${RECORD['NEPSTRCOMPLOFFIFAX']}"/>
				</td>
			</tr>
		</table>
	 </fieldset>
	<input type="hidden" name = "caseNo" value="${caseNo}"> 
	<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="submit" id="saveNEPAL_STR" class="btn btn-primary btn-sm">Save</button>
				<!-- <button type="button" id="exportXMLNEPAL_STR" class="btn btn-primary btn-sm">Export XML</button> -->
				<input type="button" class="btn btn-primary btn-sm" value="Export XML" onclick="exportXML('<%= caseNo%>')"/>
				<button type="reset" id="clearNEPAL_STR" class="btn btn-danger btn-sm">Clear</button>
			</div>
	</div>
	<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
</form>
</body>
</html>