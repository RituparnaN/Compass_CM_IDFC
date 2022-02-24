<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<title>Maldives STR (Individual)</title>
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
<form action="${pageContext.request.contextPath}/common/saveMaldivesSTR" method="POST" id="maldivesSTRForm">

<fieldset>
	<table>
	<tr>
		<td width=30%>
			<div>
				<img src="${pageContext.request.contextPath}/includes/images/FIUMMA_LOGO.png" width="20%" height="30%"/>
				<h4 style="text-align: left;  padding: 20px 0 0 10px;">Financial Intelligence Unit Maldives Monetary Authority</h4>
			</div>
		</td>
		<td width="40%">&nbsp;</td>
		<td width="30%">
			<div style=" text-align: right; padding: 20px 10px 0 0;">
				 Sub-Form Individuals <br/> 
				 Effective Date: 01 August 2015
			</div>
		</td>
	</tr>
	<tr>
		<td width="30%">&nbsp;</td>
		<td width="40%"><h4 style="  font-weight: bold; text-align: center;">SUSPICIOUS TRANSACTION REPORT (INDIVIDUAL) </h4></td>
		<td width="30%">&nbsp;</td>
	</tr>
	<tr>
		<td width="30%" style="padding: 20px 0 0 10px;">
			Date:	<input type="text" class="form-control input-sm" id= "indvSTRDate" name="INDVSTRDATE" placeholder="DD/MM/YYYY" value=${RECORD['INDVSTRDATE']}/>
		</td>
		<td width="40%">&nbsp;</td>
		<td width="30%" style=" padding: 20px 10px 0 0;">
			Reference Number:	<input type="text" class="form-control input-sm" id= "indvSTRRefNo" name="INDVSTRREFNO"  value=${RECORD['INDVSTRREFNO']}/>
		</td>
		<td
	</tr>
</table>
	<fieldset class="fieldset1">
	 	<p style="font-weight: bold;">IMPORTANT NOTES: <br/>
	 	•This form and its supporting documents must be accompanied with the Main STR form.<br>
	 	• Provide clear and concise description and state all available information. <br>
	 	• Attach supporting documents <br>
	 	• Use BLOCK letters.<br>
	 	</p>
	 </fieldset>
	 <fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION A <br>PERSON CONDUCTING THE TRANSACTION</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="20%">Name</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="indvSTRRemtName" name="INDVSTRREMTNAME" value=${RECORD['INDVSTRREMTNAME']}> 
				</td> 
			</tr>
			<tr>
				<td width="20%">ID No: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="indvSTRRemtIdNo" name="INDVSTRREMTIDNO" value=${RECORD['INDVSTRREMTIDNO']}> 
				</td>
			</tr>
			<tr>
				<td width="25%">ID Type(select one of the following):</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtIdCard" value="Identity card" name="INDVSTRREMTIDTYPE"
								<c:if test="${RECORD['INDVSTRREMTIDTYPE'] eq 'Identity card'}">checked="checked"</c:if>> Identity card
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtPassport" value="Passport" name="INDVSTRREMTIDTYPE"
								<c:if test="${RECORD['INDVSTRREMTIDTYPE'] eq 'Passport'}">checked="checked"</c:if>> Passport
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtDL" value="Driving License" name="INDVSTRREMTIDTYPE" checked="checked"
								<c:if test="${RECORD['INDVSTRREMTIDTYPE'] eq 'Driving License'}">checked="checked"</c:if>> Driving License
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtWorkPermit" value="Work Permit" name="INDVSTRREMTIDTYPE"
								<c:if test="${RECORD['INDVSTRREMTIDTYPE'] eq 'Work Permit'}">checked="checked"</c:if>> Work Permit
							</td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtOther" value="Other" name="INDVSTRREMTIDTYPE"
								<c:if test="${RECORD['INDVSTRREMTIDTYPE'] eq 'Other'}">checked="checked"</c:if>> Other
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">(Please specify): </td>
							<td colspan="6">
								<input type="text" class="form-control input-sm"  id="indvSTRRemtOtherDetails" value="${RECORD['INDVSTRREMTIDTYPEOTHERDETAILS']}" name="INDVSTRREMTIDTYPEOTHERDETAILS">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="25%">Address:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="indvSTRRemtAddr" name="INDVSTRREMTADDR">${RECORD['INDVSTRREMTADDR']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="25%">Issuer:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="indvSTRRemtIssuer" name="INDVSTRREMTISSUER" value="${RECORD['INDVSTRREMTISSUER']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Issued Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="indvSTRRemtIssDate" name="INDVSTRREMTISSDATE" value="${RECORD['INDVSTRREMTISSDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Expiry Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="indvSTRRemtExpDate" name="INDVSTRREMTEXPDATE" value="${RECORD['INDVSTRREMTEXPDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Capacity in which the transaction is being conducted:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtPersonalTnx" value="Personal" name="INDVSTRREMTTNXCAPACITY"
								<c:if test="${RECORD['INDVSTRREMTTNXCAPACITY'] eq 'Personal'}">checked="checked"</c:if>> Personal
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtAgentTnx" value="Agent" name="INDVSTRREMTTNXCAPACITY" checked="checked"
								<c:if test="${RECORD['INDVSTRREMTTNXCAPACITY'] eq 'Agent'}">checked="checked"</c:if>> Agent
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtBrokerTnx" value="Broker" name="INDVSTRREMTTNXCAPACITY"
								<c:if test="${RECORD['INDVSTRREMTTNXCAPACITY'] eq 'Broker'}">checked="checked"</c:if>> Broker
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtEmpTxn" value="Employee" name="INDVSTRREMTTNXCAPACITY"
								<c:if test="${RECORD['INDVSTRREMTTNXCAPACITY'] eq 'Employee'}">checked="checked"</c:if>> Employee
							</td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtAliasTxn" value="Alias" name="INDVSTRREMTTNXCAPACITY"
								<c:if test="${RECORD['DISCLOSUREREASON1'] eq 'Alias'}">checked="checked"</c:if>> Alias
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRRemtOnBehalfTxn" value="On Behalf" name="INDVSTRREMTTNXCAPACITY"
								<c:if test="${RECORD['DISCLOSUREREASON1'] eq 'On Behalf'}">checked="checked"</c:if>> On Behalf
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">(Please specify): </td>
							<td colspan="4">
								<input type="text" class="form-control input-sm"  id="indvSTRRemtTxnCapacityDetails" value="${RECORD['INDVSTRREMTTNXCAPACITYDETAILS']}" name="INDVSTRREMTTNXCAPACITYDETAILS">
							</td>	
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION B <br> TRANSACTION RECIPIENT</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="25%">
					<table>
						<tr>
							<td width="15%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpPerson" value="Natural Person" name="INDVSTRTNXRCPTYPE" checked="checked"
								<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Natural Person'}">checked="checked"</c:if>> Natural Person
							</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpCompany" value="Company" name="INDVSTRTNXRCPTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Company'}">checked="checked"</c:if>> Company
							</td>
						</tr>
					</table>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpPartnership" value="Partnership" name="INDVSTRTNXRCPTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Partnership'}">checked="checked"</c:if>> Partnership
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpCo-OpSociety" value="Co-Operative Society" name="INDVSTRTNXRCPTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Co-Operative Society'}">checked="checked"</c:if>> Co-Operative Society
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpNPO" value="Non-Profit Organisation" name="INDVSTRTNXRCPTYPE" 
								<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Non-Profit Organisation'}">checked="checked"</c:if>> Non-Profit Organisation
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<input type="radio" class="alignRadio"  id="indvSTRTxnRcpOthers" value="Bank" name="INDVSTRTNXRCPTYPE"
					<c:if test="${RECORD['INDVSTRTNXRCPTYPE'] eq 'Bank'}">checked="checked"</c:if>> Others
				</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					(Please specify):<input type="text" class="form-control input-sm" id="indvSTRTxnRcpPersonOthersDetails" name="INDVSTRTNXRCPTYPEOTHERSDETAILS" value="${RECORD['INDVSTRTNXRCPTYPEOTHERSDETAILS']}"> 
				</td>
			</tr>
			</tr>
			<tr>
				<td width="20%">Name</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="indvSTRTxnRcpName" name="INDVSTRTXNRCPNAME" value=${RECORD['INDVSTRTXNRCPNAME']}> 
				</td> 
			</tr>
			<tr>
				<td width="20%">ID No: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="indvSTRTxnRcpIDNo" name="INDVSTRTXNRCPIDNO" value=${RECORD['INDVSTRTXNRCPIDNO']}> 
				</td>
			</tr>
			<tr>
				<td width="25%">ID Type(select one of the following):</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpIDCard" value="Identity card" name="INDVSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPIDTYPE'] eq 'Identity card'}">checked="checked"</c:if>> Identity card
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpPassport" value="Passport" name="INDVSTRTNXRCPIDTYPE" checked="checked"
								<c:if test="${RECORD['INDVSTRTNXRCPIDTYPE'] eq 'Passport'}">checked="checked"</c:if>> Passport
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpDL" value="Driving License" name="INDVSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPIDTYPE'] eq 'Driving License'}">checked="checked"</c:if>> Driving License
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpWorkPermit" value="Work Permit" name="INDVSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPIDTYPE'] eq 'Work Permit'}">checked="checked"</c:if>> Work Permit
							</td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvSTRTxnRcpOther" value="Other" name="INDVSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['INDVSTRTNXRCPIDTYPE'] eq 'Other'}">checked="checked"</c:if>> Other
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">(Please specify): </td>
							<td colspan="6">
								<input type="text" class="form-control input-sm"  id="indvSTRTxnRcpOtherDetails" value="${RECORD['INDVSTRTNXRCPOTHERDETAILS']}" name="INDVSTRTNXRCPOTHERDETAILS">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="25%">Address:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="indvSTRTxnRcpAddr" name="INDVSTRTNXRCPADDR">${RECORD['INDVSTRTNXRCPADDR']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="25%">Issuer:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="indvSTRTxnRcpIssuer" name="INDVSTRTNXRCPISSUER" value="${RECORD['INDVSTRTNXRCPISSUER']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Issued Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="indvSTRTxnRcpIssDate" name="INDVSTRTNXRCPISSDATE" value="${RECORD['INDVSTRTNXRCPISSDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Expiry Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="indvSTRTxnRcpExpDate" name="INDVSTRTNXRCPEXPDATE" value="${RECORD['INDVSTRTNXRCPEXPDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Nationality:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="indvSTRTxnRcpNationality" name="INDVSTRTNXRCPNATIONALITY" value="${RECORD['INDVSTRTNXRCPNATIONALITY']}">
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION C<br> BUSINESS AFFILIATIONS</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="35%"> Is the suspected party afiliated with the institution in any way (includes customers)?</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiSusPartyAffiliated" value="Yes" name="INDVBSNSAFFILIATION" checked="checked"
								<c:if test="${RECORD['INDVBSNSAFFILIATION'] eq 'Yes'}">checked="checked"</c:if>> Yes
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiSusPartyNotAffiliated" value="No" name="INDVBSNSAFFILIATION"
								<c:if test="${RECORD['INDVBSNSAFFILIATION'] eq 'No'}">checked="checked"</c:if>> No
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="35%">If Yes, please specify the relationship:</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvBsnsAffiRelationship" name="INDVBSNSAFFIRELATIONSHIP" value="${RECORD['INDVBSNSAFFIRELATIONSHIP']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Relationship status after reporting?</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiRelSuspended" value="Suspended" name="INDVBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['INDVBSNSAFFIRELSTATUS'] eq 'Suspended'}">checked="checked"</c:if>> Suspended
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiRelTerminated" value="Terminated" name="INDVBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['INDVBSNSAFFIRELSTATUS'] eq 'Terminated'}">checked="checked"</c:if>> Terminated
							</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiRelResigned" value="Resigned" name="INDVBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['INDVBSNSAFFIRELSTATUS'] eq 'Resigned'}">checked="checked"</c:if>> Resigned
							</td>
							<td width="5%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="alignRadio"  id="indvBsnsAffiRelNoAction" value="No action taken yet" name="INDVBSNSAFFIRELSTATUS" checked="checked"
								<c:if test="${RECORD['INDVBSNSAFFIRELSTATUS'] eq 'No action taken yet'}">checked="checked"</c:if>> No action taken yet
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Remarks:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3">
					<textarea class="form-control input-sm"  id="indvBsnsAffiRemarks" name="INDVBSNSAFFIREMARKS">${RECORD['INDVBSNSAFFIREMARKS']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION D<br>ACCOUNT INFORMATION<br> ( Banks Only-accounts belonging to or controlled by the Legal Entity )</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Account 01:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="35%">Bank Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1BankName" name="INDVACCINFO1BANKNAME" value="${RECORD['INDVACCINFO1BANKNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Branch Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1BranchName" name="INDVACCINFO1BRANCHNAME" value="${RECORD['INDVACCINFO1BRANCHNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1AccName" name="INDVACCINFO1ACCNAME" value="${RECORD['INDVACCINFO1ACCNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1AccNo" name="INDVACCINFO1ACCNO" value="${RECORD['INDVACCINFO1ACCNO']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Opened Date: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1AccOpenDate" name="INDVACCINFO1ACCOPENDATE" value="${RECORD['INDVACCINFO1ACCOPENDATE']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Balance(as of Reporting Date): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1AccBal" name="INDVACCINFO1ACCBAL" value="${RECORD['INDVACCINFO1ACCBAL']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Beneficiary: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="indvAccInfo1Beneficiary" name="INDVACCINFO1BENEFICIARY" value="${RECORD['INDVACCINFO1BENEFICIARY']}">
				</td>
			</tr>
			
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Account 02:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="35%">Bank Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDR" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Branch Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDR" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Opened Date: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Balance(as of Reporting Date): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Beneficiary: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Account 03:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="35%">Bank Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Branch Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Opened Date: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Balance(as of Reporting Date): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Beneficiary: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Account 04:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="35%">Bank Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Branch Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Opened Date: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Balance(as of Reporting Date): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Beneficiary: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="address" name="ADDRESS" value="${RECORD['REASONFORASSO1']}">
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
</body>
</html>