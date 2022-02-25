<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
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
		/*
		$("#saveMALDIVES_STR").click(function(){
			var formObj = $("#maldivesSTRForm");
			var formData = $(formObj).serialize();
			//document.write(formData);
			$.ajax({
				url: "${pageContext.request.contextPath}/common/saveMALDIVES_STR" ,
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
	});
</script>

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<title>Maldives STR</title>
</head>
<style type="text/css">
	fieldset{
	border: 1px groove #ddd !important;
    padding: 5px 10px 5px 10px !important;
    margin: 20px 10px 20px 10px !important;
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
<form action="${pageContext.request.contextPath}/common/saveMALDIVES_STR" method="POST" id="maldivesSTRForm">
<table>
	<tr>
		<td width=30%>
			<div>
				<img src="${pageContext.request.contextPath}/includes/images/FIUMMA_LOGO.png" width="20%" height="40%"/>
				<h4 style="text-align: left;  padding: 20px 0 0 10px;">Financial Intelligence Unit Maldives Monetary Authority</h4>
			</div>
		</td>
		<td width="40%">&nbsp;</td>
		<td width="30%">
			<div style=" text-align: right; padding: 20px 10px 0 0;">
				 STR Main Form and Explanatory Notes<br/> 
				 Effective Date: 01 August 2015
			</div>
		</td>
	</tr>
	<tr>
		<td width="30%">&nbsp;</td>
		<td width="40%"><h4 style="  font-weight: bold; text-align: center;">SUSPICIOUS TRANSACTION REPORT (STR) </h4></td>
		<td width="30%">&nbsp;</td>
	</tr>
	<tr>
		<td width="30%" style="padding: 20px 0 0 10px;">
			Date:	<input type="text" class="form-control input-sm" id= "maldivesSTRDate" name="MALSTRDATE" placeholder="DD/MM/YYYY" value="${RECORD['MALSTRDATE']}"/>
		</td>
		<td width="40%">&nbsp;</td>
		<td width="30%" style=" padding: 20px 10px 0 0;">
			Reference Number:	<input type="text" class="form-control input-sm" id= "maldivesSTRRefNo" name="MALSTRREFNO"  value="${RECORD['MALSTRREFNO']}"/>
		</td>
		<td
	</tr>
</table>
	<fieldset class="fieldset1">
		<h4 style="font-weight: bold; text-align: center; text-decoration: underline;">BINDING NOTE</h4>
		<p style="font-weight: bold;">Section 38(a) of Law No. 10/2014 (Prevention of Money Laundering and Terrorism Financing Act) requires reporting entities (as defined) to report all suspicious transactions to the Financial Intelligence Unit of Maldives Monetary Authority.
	 	</p>
	 	<hr style="border-color: black; border-width: 1px;">
	 	<p style="font-weight: bold;">IMPORTANT NOTE: <br/>
	 	• Please ill the form using BLOCK LETTERS. Refer to the Explanatory Notes provided on Page 4 of this form for assistance.<br/>
		• Provide clear and concise description and state all available information. <br/>
		• Never alert a customer or any unauthorized person about an STR or any investigation for that matter. <br/>
		• Reporting STRs does not obligate the author of this report to act as an eyewitness or participate in any official investigation. She/he shall be protected from liability as long as the report is made in good faith.<br/>
		• Documents supporting suspicion (e.g.: transaction records, service application forms, etc.) may be attached with this report. <br/>
		• For assistance, please contact <font style="color: blue; text-decoration: underline;" >fiu@mma.gov.mv </font> 
	 	</p>
	 </fieldset>
	 <fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;">PRELIMINARIES</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="20%">  Type of report (Please select appropriate box):</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					&nbsp;
					<input type="radio" class="alignRadio"  id="newSTR" value="NewSTR" name="MALSTRREPORTTYPE" checked="checked"
					<c:if test="${RECORD['MALSTRREPORTTYPE'] eq 'New STR'}">checked="checked"</c:if>> New STR	
					&nbsp;
					<input type="radio" class="alignRadio"  id="amendment" value="Amendment" name="MALSTRREPORTTYPE"
					<c:if test="${RECORD['MALSTRREPORTTYPE'] eq 'Amendment'}">checked="checked"</c:if>> Amendment 
				</td> 
			</tr>
			<tr>
				<td width="20%">Number of Documents attached: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="10%">
								<input type="text" class="form-control input-sm" id="noOfDoc" name="MALSTRNOOFDOC" value="${RECORD['MALSTRNOOFDOC']}"/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">Please provide list:</td>
							<td width="10%">&nbsp;</td>
							<td width="50%">
								<textarea class="form-control input-sm" id="docList" name="MALSTRDOCLIST">${RECORD['MALSTRDOCLIST']}</textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="20%">State if Reporting an Amendment:</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="40%">Previous STR reference number:</td>
							<td width="10%">&nbsp;</td>
							<td width="50%">
								<input type="text" class="form-control input-sm" placeholder="(ONLY for amendments)" id="prevSTRRefNo" name="MALSTRPREVSTRREFNO" value="${RECORD['MALSTRPREVSTRREFNO']}">
							</td>
						</tr>
						<tr>
							<td width="40%">Date:</td>
							<td width="10%">&nbsp;</td>
							<td width="50%">
								<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="amendmentDate" name="MALSTRAMENDMENTDATE" value="${RECORD['MALSTRAMENDMENTDATE']}">
							</td>
						</tr>
						<tr>
							<td width="40%"> Remarks (explain the reason for amendment): </td>
							<td width="10%">&nbsp;</td>
							<td width="50%">
								<textarea class="form-control input-sm" id="reasonForAmendment" name="MALSTRAMENDMENTRSN">${RECORD['MALSTRAMENDMENTRSN']}</textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="20%">Suspect type reported: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="35%">Individual (specify number of individuals): </td>
							<td width="5%">
								<input type="text" class="form-control input-sm" id="noOfIndividualSuspected" name="MALSTRNOOFINDVSUSPECTED" value="${RECORD['MALSTRNOOFINDVSUSPECTED']}">
							</td>
							<td width="60%">&nbsp; (attach one “Sub-Form – Individuals” for each individual being reported)</td>
						</tr>
						<tr>
							<td width="35%">Legal Entity (specify number of entities): </td>
							<td width="5%"><input type="text" class="form-control input-sm" id="noOfEntitiesSuspected" name="MALSTRNOOFLEGENTSUSPECTED" value="${RECORD['MALSTRNOOFLEGENTSUSPECTED']}"></td>
							<td width="60%">&nbsp; (attach one “Sub-Form – Legal Entities” for each legal entity being reported)</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</fieldset>
			
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
					<h4 style="font-weight: bold; text-align: center;">SECTION A - REPORTING ENTITY</h4>
					<hr style="border-color: black; border-width: 1px;">
					<tr>
						<td width="20%">Entity Name: </td>
						<td width="5%">&nbsp;</td>
						<td width="75%">
							<input type="text" class="form-control input-sm" id="reportingEntityName" name="MALSTRREPORTINGENTNAME" value="${RECORD['MALSTRREPORTINGENTNAME']}">
						</td> 
					</tr>
				<tr>
					<td width="20%">Branch (if applicable): </td>
					<td width="5%">&nbsp;</td>
					<td width="75%">
						<input type="text" class="form-control input-sm" id="reportingBranchName" name="MALSTRREPORTINGBRANCHNAME" value="${RECORD['MALSTRREPORTINGBRANCHNAME']}">
					</td>
				</tr>
				<tr>
					<td width="20%">Entity Type:</td>
					<td width="5%">&nbsp;</td>
					<td width="75%">
						<table>
							<tr>
								<td width="20%">
									<input type="radio" class="alignRadio"  id="entityTypeBank" value="Bank" name="MALSTRENTITYTYPE"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Bank'}">checked="checked"</c:if>>  Bank
								</td>
								<td width="10%">&nbsp;</td>
								<td width="70%" colspan="2">
									<input type="radio" class="  alignRadio"  id="entityTypeFincanceComp" value="Financing Company" name="MALSTRENTITYTYPE"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Financing Company'}">checked="checked"</c:if>>  Financing Company or Finance Leasing Company
								</td>
								
							</tr>
							<tr>
								<td width="20%">
									<input type="radio" class="alignRadio"  id="entityTypeMoneyChanger" value="Money Changer" name="MALSTRENTITYTYPE"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Money Changer'}">checked="checked"</c:if>>  Money Changer
								</td>
								<td width="10%">&nbsp;</td>
								<td width="30%">
									<input type="radio" class="  alignRadio"  id="entityTypeInsComp" value="Insurance Company" name="MALSTRENTITYTYPE"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Insurance Company'}">checked="checked"</c:if>>  InsuranceCompany
								</td>
								<td width="40%">	
									<input type="text" class="form-control input-sm" id="entityTypeInsCompName" name="ENTITYTYPEINSCOMPNAME" value="${RECORD['ENTITYTYPEINSCOMPNAME']}">
								</td>
							</tr>
							<tr>
								<td width="20%">
									<input type="radio" class="alignRadio"  id="entityTypeMoneyRemittance" value="Money Remittance" name="MALSTRENTITYTYPE"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Money Remittance'}">checked="checked"</c:if>>  Money Remittance
								</td>
								<td width="10%">&nbsp;</td>
								<td width="30%">
									<input type="radio" class="  alignRadio"  id="entityTypeOthers" value="Others" name="MALSTRENTITYTYPE" checked="checked"
									<c:if test="${RECORD['MALSTRENTITYTYPE'] eq 'Others'}">checked="checked"</c:if>>  Others (Please Specify): 
								</td>
								<td width="40%">	
									<input type="text" class="form-control input-sm" id="entityTypeOthersName" name="MALSTRENTTYPEINSOTHERSNAME" value="${RECORD['MALSTRENTTYPEINSOTHERSNAME']}">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					
					<td colspan="4">
					<hr style="border-color: black; border-width: 1px;">
						<p>We declare that the information provided in this form and any attachment(s) are true to the best of our knowledge.</p>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea class="form-control input-sm"  id="officialStamp" placeholder="Official Stamp Here" name="MALSTROFFICIALSTAMP">${RECORD['MALSTROFFICIALSTAMP']}</textarea>
					</td>
					
					<td width="75%">
						<table>
							<tr>
								<td>
									Date<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="reportingEntityDate" name="MALSTRREPORTINGENTDATE" value="${RECORD['MALSTRREPORTINGENTDATE']}">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</fieldset>
	
	<fieldset class="fieldset4">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
					<h4 style="font-weight: bold; text-align: center;">SECTION B - TRANSACTION DETAILS</h4>
					<hr style="border-color: black; border-width: 1px;">
					<tr>
					<td width="20%"> Types of Transactions:( select more than one, if necessary)</td>
					<td width="5%">&nbsp;</td>
					<td width="75%">
						<table>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="wireTransferInternational" value="Wire Transfer International" name="MALSTRWIRETRANSFERINTL"
									<c:if test="${RECORD['MALSTRWIRETRANSFERINTL'] eq 'Wire Transfer International'}">checked="checked"</c:if>>  01. Wire Transfer (International)
								</td>
								<td width="10%">&nbsp;</td>
								<td width="60%" colspan="2">
									<input type="checkbox" class="alignRadio"  id="wireTransferDomestic" value="Wire Transfer Domestic" name="MALSTRWIRETRANSFERDOMESTIC"
									<c:if test="${RECORD['MALSTRWIRETRANSFERDOMESTIC'] eq 'Wire Transfer Domestic'}">checked="checked"</c:if>>  02. Wire Transfer (Domestic)
								</td>
							</tr>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="letterOfCredit" value="Letter Of Credit" name="MALSTRLETTEROFCREDIT"
									<c:if test="${RECORD['MALSTRLETTEROFCREDIT'] eq 'Letter Of Credit'}">checked="checked"</c:if>>  03.  Letter of Credit
								</td>
								<td width="10%">&nbsp;</td>
								<td width="60%" colspan="2">
									<input type="checkbox" class="alignRadio"  id="deposits" value="Deposits" name="MALSTRDEPOSITS"
									<c:if test="${RECORD['MALSTRDEPOSITS'] eq 'Deposits'}">checked="checked"</c:if>>  04. Deposits (Cash/Cheque, etc.) 
								</td>
							</tr>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="cashWithdrawal" value="Cash Withdrawal" name="MALSTRCASHWITHDRAWAL" checked="checked"
									<c:if test="${RECORD['MALSTRCASHWITHDRAWAL'] eq 'Cash Withdrawa'}">checked="checked"</c:if>> 05. Cash Withdrawal (Cash/Cheque, etc.) 
								</td>
								<td width="10%">&nbsp;</td>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="insuranceTransaction " value="Insurance Transaction" name="MALSTRINSTNX"
									<c:if test="${RECORD['MALSTRINSTNX'] eq 'Insurance Transaction'}">checked="checked"</c:if>>  06.  Insurance Transaction  
								</td>
							</tr>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="purchaseOfRealEstate " value="Purchase Of Real Estate" name="MALSTRREALESTATEPURCHASE" checked="checked"
									<c:if test="${RECORD['MALSTRREALESTATEPURCHASE'] eq 'Purchase Of Real Estate'}">checked="checked"</c:if>>  07.  Purchase of Real Estate
								</td>
								<td width="10%">&nbsp;</td>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="purchaseOfOtherValuableAssets" value="Purchase Of Other Valuable Assets" name="MALSTROTHERASSETPURCHASE"
									<c:if test="${RECORD['MALSTROTHERASSETPURCHASE'] eq 'Purchase Of Other Valuable Assets'}">checked="checked"</c:if>>  08.  Purchase of Other Valuable Assets
								</td>
							</tr>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="debitCard " value="Debit card" name="MALSTRDEBITCARD"
									<c:if test="${RECORD['MALSTRDEBITCARD'] eq 'Debit card'}">checked="checked"</c:if>>  09.  Debit card
								</td>
								<td width="10%">&nbsp;</td>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="creditCard " value="Credit card" name="MALSTRCREDITCARD"
									<c:if test="${RECORD['MALSTRCREDITCARD'] eq 'Credit card'}">checked="checked"</c:if>>  10.  Credit card
								</td>
							</tr>
							<tr>
								<td width="30%">
									<input type="checkbox" class="alignRadio"  id="negotiableInstruments" value="Negotiable Instruments" name="MALSTRNEGOINSTRUMENTS"
									<c:if test="${RECORD['MALSTRNEGOINSTRUMENTS'] eq 'Negotiable Instruments'}">checked="checked"</c:if>>  11.  Negotiable Instruments (e.g.: Travelers’ cheque)  
								</td>
								<td width="10%">&nbsp;</td>
								<td width="60%" colspan="2">
									<input type="checkbox" class="alignRadio"  id="overdraft" value="Overdraft" name="MALSTROVERDRAFT"
									<c:if test="${RECORD['MALSTROVERDRAFT'] eq 'Overdraft'}">checked="checked"</c:if>>  08.  Overdraft 
								</td>
							</tr>
							<tr>
								<td width="20%">
									<input type="checkbox" class="alignRadio"  id="otherTnxType" value="Others" name="MALSTROTHERTNXTYPE"
									<c:if test="${RECORD['MALSTROTHERTNXTYPE'] eq 'Others'}">checked="checked"</c:if>>  12.  Others (Please Specify):
								</td>
								<td width="40%" colspan="3">	
									<input type="text" class="form-control input-sm" id="otherTnxTypeName" name="MALSTROTHERTNXTYPENAME" value="${RECORD['MALSTROTHERTNXTYPENAME']}">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="20%">Total amount involved in suspicious transaction: </td>
					<td width="5%">&nbsp;</td>
					<td width="75%">
						<table>
							<tr>
								<td width="10%">MVR</td>
								<td width="5%">&nbsp;</td>
								<td width="40%">
									<input type="text" class="form-control input-sm" id="mvr" name="MALSTRMVR" value="${RECORD['MALSTRMVR']}">
								</td>
								<td width="5%">&nbsp;</td>
								<td width="40%">
									<input type="checkbox" class="alignRadio"  id="amountUnknown" value="Amount Unknown" name="MALSTRAMTUNKNOWN"
									<c:if test="${RECORD['MALSTRAMTUNKNOWN'] eq 'Amount Unknown'}">checked="checked"</c:if>>  Amount Unknown
								</td>
							</tr>
						</table>
					</td>				
				</tr>
			</table>
	</fieldset>
	
	<fieldset class="appendix2b">
		<table class="table appendix2" style="margin-bottom: 0px; margin-top: 0px; ">
			<tr>
				<td width="45%" style="text-align: center; font-weight: bold;">Originating
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 01</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1Name" name="MALSTRSRCTNX1NAME" value="${RECORD['MALSTRSRCTNX1NAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1Bank" name="MALSTRSRCTNX1BANK" value="${RECORD['MALSTRSRCTNX1BANK']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1AccNo" name="MALSTRSRCTNX1ACCNO" value="${RECORD['MALSTRSRCTNX1ACCNO']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1Currency" name="MALSTRSRCTNX1CURRENCY" value="${RECORD['MALSTRSRCTNX1CURRENCY']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1Amt" name="MALSTRSRCTNX1AMT" value="${RECORD['MALSTRSRCTNX1AMT']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="srcTnx1Country" name="MALSTRSRCTNX1COUNTRY" value="${RECORD['MALSTRSRCTNX1COUNTRY']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="srcTnx1Date" name="MALSTRSRCTNX1DATE" value="${RECORD['MALSTRSRCTNX1DATE']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%" style="text-align: center; font-weight: bold;">Destination
									<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 01</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1Name" name="MALSTRDESTTNX1NAME" value="${RECORD['MALSTRDESTTNX1NAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1Bank" name="MALSTRDESTTNX1BANK" value="${RECORD['MALSTRDESTTNX1BANK']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1AccNo" name="MALSTRDESTTNX1ACCNO" value="${RECORD['MALSTRDESTTNX1ACCNO']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1Currency" name="MALSTRDESTTNX1CURRENCY" value="${RECORD['MALSTRDESTTNX1CURRENCY']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1Amt" name="MALSTRDESTTNX1AMT" value="${RECORD['MALSTRDESTTNX1AMT']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="destTnx1Country" name="MALSTRDESTTNX1COUNTRY" value="${RECORD['MALSTRDESTTNX1COUNTRY']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="destTnx1Date" name="MALSTRDESTTNX1DATE" value="${RECORD['MALSTRDESTTNX1DATE']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 02</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 02</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 03</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 03</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 04</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 04</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 05</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 05</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 06</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 06</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 07</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="45%">
					<table>
						<tr>
							<td width="25%" style="font-weight: bold;">Transaction: 07</td>
							<td colspan="2" >&nbsp;</td>
						</tr>
						<tr>
							<td width="25%">Name:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Name" name="TNX1NAME" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Bank:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Bank" name="TNX1BANK" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Account Number:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1AccNo" name="TNX1ACCNO" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Currency:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Currency" name="TNX1CURRENCY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Amount:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Amt" name="TNX1AMT" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Country:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" id="tnx1Country" name="TNX1COUNTRY" value="${RECORD['IDSURNAME']}"></td>
						</tr>
						<tr>
							<td width="25%">Date:</td>
							<td width="5%">&nbsp;</td>
							<td width="70%"><input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="tnx1Date" name="TNX1DATE" value="${RECORD['IDSURNAME']}"></td>
						</tr>
					</table>
				</td>
			</tr>
			
			<tr>
				<td colspan="3">
					<p>
						<font style="font-weight: bold; text-decoration: underline;">NOTE :</font> <br>
						If more than 7 transactions, please provide the information in the same format above, on a separate sheet.
					</p>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix3a">
		<table class="table appendix3" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td style="font-weight: bold;" >Reason for Suspicion:</td>
			</tr>
			<tr>
				<td>
					<textarea rows="20" cols="10"class="form-control input-sm"  id="reasonForSuspicion" name="MALSTRSUSPICIONRSN">${RECORD['MALSTRSUSPICIONRSN']}</textarea>
				</td>
			</tr>
	    </table>
	    <table class="table appendix3" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<hr style="border-color: black; border-width: 1px;">
			<h4 style="font-weight: bold; text-align: center;">SECTION C - TRANSACTION DETAILS <br/> FOR FINANCIAL INTELLIGENCE UNIT USE ONLY</h4>
			<tr>
				<td width="10%">STR Number: </td>
				<td width="10%">&nbsp;</td>
				<td width="80%">
					<input type="text" class="form-control input-sm" id="strNo" name="MALSTRNO" value="${RECORD['MALSTRNO']}">
				</td>
			</tr>
			<tr>
				<td width="10%">Date: </td>
				<td width="10%">&nbsp;</td>
				<td width="80%">
					<input type="text" placeholder="DD/MM/YYYY" class="form-control input-sm" id="strDate" name="MALSTRDTNXDETAILSDATE" value="${RECORD['MALSTRDTNXDETAILSDATE']}">
				</td>
			</tr>
			<tr>
				<td width="10%">Received By: </td>
				<td width="10%">&nbsp;</td>
				<td width="80%">
					<input type="text" class="form-control input-sm" id="receivedBy" name="MALSTRRECEIVEDBY" value="${RECORD['MALSTRRECEIVEDBY']}">
				</td>
			</tr>
			<tr>
				<td width="10%">Signature: </td>
				<td width="10%">&nbsp;</td>
				<td width="80%">
					<textarea class="form-control input-sm"  id="signature" name="MALSTRSIGNATURE">${RECORD['MALSTRSIGNATURE']}</textarea>
				</td>
			</tr>
	    </table>
	    <hr style="border-color: black; border-width: 1px;">
	    <p><font style="font-weight: bold;">CHECK LIST :</font><br/>
	         • Fill all the relevant fields in the form       <br/>
	         • Copies of relevant identification documents       <br/>
	         • Supporting documents       <br/>
	         • Official stamp in the relevant area given in the first page
	    </p>
	 </fieldset>
	 
	 <fieldset class="appendix3b">
	 	<h3 style="font-weight: bold; text-align: center;">EXPLANATORY NOTES</h3>
	 	
	 	<table>
	 		<tr>
	 			<td width="45%">
	 				<div>
	 					<p>BINDING NOTE AND TERMINOLOGY <br>
							WHO TO REPORT: Under Section 38(a) of Law No. 10/2014 (Prevention of Money Laundering and Terrorism Financing Act), Reporting Entities are required to report all suspicious transactions to the Financial Intelligence Unit of Maldives Monetary Authority (FIU).<br/>
							MANNER OF REPORTING: all the reports and supporting documents must be sent to the FIU via the online report submission platform designated by the FIU.<br/>
							General Help In order to ensure ease of usage, the STR form has been designed to contain 3 separate forms, i.e. Main Form, Sub-form Individuals and Sub-form Legal Entities.
							Main Form: This form must be filled whenever reporting a suspicious transaction. Each suspicious transaction must be reported using 1 (ONE) Main Form. Main Form shall be given a unique reference number which shall also be used with the relevant Sub-Forms as detailed below.
							Sub-Form Individuals: This form must be attached to the main form if reporting a suspicious transaction of  a natural person. In case of more than one individual, a separate form must be attached for each natural person linked, involved or seemingly connected to the suspicious transaction. 
							Sub-Form Legal Entities: This form must be attached to the main form if reporting a suspicious transaction of a legal entity. In case of more than one legal entity, a separate form must be attached for each legal entity linked, involved or seemingly connected to the suspicious transaction. <br/>
							STR MAIN FORM Preliminaries 1- Type of report: a. Tick (√) the appropriate box. b. If amending a previous STR provide reference number and previous STR date and reason for the amendment. 
														2- Documents Attached: indicate the number and provide the list of documents attached to the report. E.g. transfer request form.
														3- Suspect type reported: The number of natural persons and/or legal entities being reported.<br/>
							Section A (Reporting Entity) 1- Entity Name, Address/Branch:  Information regarding the Reporting Entity reporting the suspicious transaction. 
														 2- Business Category: Information regarding the Reporting Entity type reporting the suspicious transaction.
														 3- Provide the reporting date and the reporting institution's official stamp in their respective fields.<br/>
							Section B (Transaction Details) 1- Provide total amount involved in the suspicious transaction. Also indicate if the amount is unknown. Total amount involved in the suspicious transaction refers to the sum of cash or any other monetary value seemingly involved or linked in the said suspicious transaction(s). 
															2- Provide all transactions involved whether seemingly, directly or indirectly linked to the suspicious transaction. a. Originating: refers to the geographical location where the transaction starts. b. Destination: refers to the geographical location where the transaction ends. c. Provide as many details available about the transactions deemed necessary. Information may also be provided if the space provided in separate sheets and attachments if the space provided in the form is insufficient. 
															3- Type refers to the type of transaction involved as per the list provided at the beginning of this Section. Indicate the Type by providing the relevant number allocated. If “Others”, please specify the type. 4- Provide reason for suspicion in the space provided. Please provide the details in a separate document as an attachment if the space provided is insufficient.<br/>
							<font style="font-weight: bold;">Section C is to be left blank.</font><br>
							--------------------------------------------------
						</p>
					</div>
	 			</td>
	 			<td width="5%">
	 				&nbsp;
	 			</td>
	 			<td width="45%">
	 				<div>
	 					<p>SUB-FORM INDIVIDUALS<br>
	 						Section A (Person Conducting the Transaction)<br> 1- Full name of the natural person who physically attended to make the transaction or the natural person who orders the transaction.
	 																	 2- ID Number: Identification number from any legally accepted identification document provided by the natural person.
	 																	 3- ID type: tick (√) the appropriate box. 
	 																	 4- Address: Provide the available (temporary or permanant) address of the natural person
	 																	 5- Issuer: Identification document issuing government authority (E.g.:Department of Natural Registration).
	 																	 6- Issued Date: Identification Document Issued Date.
	 																	 7- Expiry Date: Identification Document Expiry Date.
	 																	 8- Nationality: Nationality of the person conducting the transaction. 
	 																	 9- State the capacity in which the person conducting the transaction. Where a third party is conducting the transaction on behalf of the customer, provide the full name of the person or legal entity on whose behalf the transaction is being conducted.<br/>
	 						Section B (Transaction Recipient)<br> 1- Tick (√) the appropriate box to state if the recipient is a natural or a legal person. 
	 															2- Name of the person: - Name of the person/entity to whom the transaction is conducted.
	 															3- ID Number: Identification number from any legally accepted identification document provided by the customer/client. Where the transaction recipient is a legal entity, provide the registration number of the enitity and select ID Type as “Other”.
	 														    4- Issuer: Identification document issuing government authority (E.g.:Department of Natural Registration).
	 														    5- Issued Date: Identification Document Issued Date.
	 														    6- Expiry Date: Identification Document Expiry Date.
	 														    7- Address: Provide the available (temporary or permanant) address of the transaction recipient. 
	 														    8- Nationality: Nationality of the person receiving the transaction.<br>
	 					   Section C (Business Affiliations)<br> 1- State if the suspected party has any affiliation with the Reporting Entity and state the relationship.
	 					   										2- State the relationship status after the report has been made.
	 					   										3- Add remarks (if any).<br>
							Section D (Account Information)<br>This Section is ONLY applicable to Banks.
										1- If there are any other accounts that the individual controls, provide the information as given in the form. Such accounts do NOT necessarily have to be directly or indirectly involved in the suspicious transaction. 2- If more than FOUR accounts, please provide the information, in the same format, in a separate sheet. <br>
										--------------------------------------------------<br>
										SUB-FORM LEGAL ENTITIES<br>
										Section A (Person Conducting the Transaction) <br>1- Full Name of the natural person who physically attendeds to conduct the transaction on behalf of the Legal Entity.<br>
																2- ID Number: Identification number from any legally accepted identification document provided by the natural person.
																3- ID type: tick (√) the appropriate box. 4- Address: Provide the available (temporary or permanant) address of the natural person.
																5-Issuer: Identification document issuing government authority (E.g.:Department of Natural Registration).
																6- Issued Date: Identification Document Issued Date.
	 															7- Expiry Date: Identification Document Expiry Date.
	 					   	 									8- State the capacity in which the transaction is being conducted (tick (√) the appropriate box).
Section B (Legal Entity Being Reported) 1- Provide the Full Name of the Entity being reported. E.g.: ProductXYZ Pvt. Ltd. 2- Date account opened: date at which the legal entity opened an account with the Reporting Entity. In case of multiple accounts, please fill out Section E of this form.
3- Country of registration: where the legal entity is a foreign company. 4- Registration number: must be checked through proper KYC channels and provide the legal entity registration number given by the regulating body. 5- Regulating body: legal authority regulating the reported legal entity. E.g.: Ministry of  Economic Development 6- Registered Address: registered address of the legal entity 7- Business address: business address or current address of the legal entity. 8- Contact Number(s): contact numbers used by the legal entity to contact the reporting institution.
Section C (Transaction Recipient) 1- Tick (√) the appropriate box to state if the recipient is a natural or a legal person. 2- Name of the person: - Name of the entity or person to whom the transaction is conducted. 
	 						3- ID Number: Identification number from any legally accepted identification document provided by the customer/client
	 														    4- Issuer: Identification document issuing government authority (E.g.:Department of Natural Registration).
	 														    5- Issued Date: Identification Document Issued Date.
	 														    6- Expiry Date: Identification Document Expiry Date.
	 														    7- Address: Provide the current address of the customer. 
	 														    8- Nationality: Nationality of the person conducting the transaction.<br>											 
	 							 Section C (Business Affiliations)<br> 1- State if the suspected party has any affiliation with the reporting institution and state the relationship.
	 					   										2- State the relationship status after the report has been made.
	 					   										3- Add remarks (if any).<br>
	 					   		Section E (Account Information)	<br>This Section is ONLY applicable to Banks.<br>
	 					   		1- If there are any other accounts that the legal entity controls, provide the information as given in the form. Such accounts do NOT necessarily have to be directly or indirectly involved in the suspicious transaction. 2- If more than THREE accounts, please provide the information, in the same format, in a separate sheet
	 					   				 
	 					</p>
	 				</div>
	 			</td>
	 		</tr>
	 	</table>
	</fieldset>
	<jsp:include page="MALDIVES_STR_INDIVIDUAL.jsp"></jsp:include>
	<jsp:include page="MALDIVES_STR_LEGALENTITY.jsp"></jsp:include>
	<input type="hidden" name = "caseNo" value="${caseNo}"> 
	<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="submit" id="saveMALDIVES_STR" class="btn btn-primary btn-sm">Save</button>
				<button type="reset" id="clearMALDIVES_STR" class="btn btn-danger btn-sm">Clear</button>
			</div>
	</div>
	<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
</form>
</body>
</html>