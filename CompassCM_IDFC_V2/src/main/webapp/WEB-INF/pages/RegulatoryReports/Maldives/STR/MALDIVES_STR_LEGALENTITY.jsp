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
<title>Maldives STR (Legal Entity)</title>
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
		<td width="40%"><h4 style="  font-weight: bold; text-align: center;">SUSPICIOUS TRANSACTION REPORT (LEGAL ENTITIES) </h4></td>
		<td width="30%">&nbsp;</td>
	</tr>
	<tr>
		<td width="30%" style="padding: 20px 0 0 10px;">
			Date:	<input type="text" class="form-control input-sm" id= "legEntSTRDate" name="LEGENTSTRDATE" placeholder="DD/MM/YYYY" value="${RECORD['LEGENTSTRDATE']}"/>
		</td>
		<td width="40%">&nbsp;</td>
		<td width="30%" style=" padding: 20px 10px 0 0;">
			Reference Number:	<input type="text" class="form-control input-sm" id= "legEntSTRRefNo" name="LEGENTSTRREFNO"  value="${RECORD['LEGENTSTRREFNO']}"/>
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
		<h4 style="font-weight: bold; text-align: center;"> SECTION A <br>PERSON CONDUCTING THE TRANSACTION<br>(Natural person who physically attends to conduct the transaction)</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="20%">Name</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legEntSTRRemtName" name="LEGENTSTRREMTNAME" value="${RECORD['LEGENTSTRREMTNAME']}"> 
				</td> 
			</tr>
			<tr>
				<td width="20%">ID No: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legEntSTRRemtIdNo" name="LEGENTSTRREMTIDNO" value="${RECORD['LEGENTSTRREMTIDNO']}"> 
				</td>
			</tr>
			<tr>
				<td width="25%">ID Type(select one of the following):</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtIDCard" value="Identity card" name="LEGENTSTRREMTIDTYPE"
								<c:if test="${RECORD['LEGENTSTRREMTIDTYPE'] eq 'Identity card'}">checked="checked"</c:if>> Identity card
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtPassport" value="Passport" name="LEGENTSTRREMTIDTYPE" checked="checked"
								<c:if test="${RECORD['LEGENTSTRREMTIDTYPE'] eq 'Passport'}">checked="checked"</c:if>> Passport
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtDL" value="Driving License" name="LEGENTSTRREMTIDTYPE"
								<c:if test="${RECORD['LEGENTSTRREMTIDTYPE'] eq 'Driving License'}">checked="checked"</c:if>> Driving License
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtWorkPermit" value="Work Permit" name="LEGENTSTRREMTIDTYPE"
								<c:if test="${RECORD['LEGENTSTRREMTIDTYPE'] eq 'Work Permit'}">checked="checked"</c:if>> Work Permit
							</td>
							<td width="5%">&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="25%">Address:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="legEntSTRRemtAddress" name="LEGENTSTRREMTADDR">${RECORD['LEGENTSTRREMTADDR']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="25%">Issuer:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="legEntSTRRemtIssuer" name="LEGENTSTRREMTISSUER" value="${RECORD['LEGENTSTRREMTISSUER']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Issued Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="legEntSTRRemtIssDate" name="LEGENTSTRREMTISSDATE" value="${RECORD['LEGENTSTRREMTISSDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Expiry Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="legEntSTRRemtExpDate" name="LEGENTSTRREMTEXPDATE" value="${RECORD['LEGENTSTRREMTEXPDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Capacity in which the transaction is being conducted:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtAgentTxn" value="Agent" name="LEGENTSTRREMTCAPACITY" 
								<c:if test="${RECORD['LEGENTSTRREMTCAPACITY'] eq 'Agent'}">checked="checked"</c:if>> Agent
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtBrokerTxn" value="Broker" name="LEGENTSTRREMTCAPACITY" checked="checked"
								<c:if test="${RECORD['LEGENTSTRREMTCAPACITY'] eq 'Broker'}">checked="checked"</c:if>> Broker
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtAliasTxn" value="Alias" name="LEGENTSTRREMTCAPACITY"
								<c:if test="${RECORD['LEGENTSTRREMTCAPACITY'] eq 'Alias'}">checked="checked"</c:if>> Alias 
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtEmpTxn" value="Employee" name="LEGENTSTRREMTCAPACITY"
								<c:if test="${RECORD['LEGENTSTRREMTCAPACITY'] eq 'Employee'}">checked="checked"</c:if>> Employee
							</td>
							<td width="5%">&nbsp;</td>
							</tr>
							<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRRemtOtherTxn" value="Others" name="LEGENTSTRREMTCAPACITY"
								<c:if test="${RECORD['LEGENTSTRREMTCAPACITY'] eq 'Others'}">checked="checked"</c:if>> Others
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">(Please specify): </td>
							<td colspan="4">
								<input type="text" class="form-control input-sm"  id="legEntSTRRemtOtherDetails" value="${RECORD['LEGENTSTRREMTOTHERDETAILS']}" name="LEGENTSTRREMTOTHERDETAILS">
							</td>	
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION B <br> LEGAL ENTITY</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="35%">Company / Organization  Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTROrgName" name="LEGENTSTRORGNAME" value="${RECORD['LEGENTSTRORGNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Date account opened (if applicable): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="legEntSTRAccOpenDate" name="LEGENTSTRACCOPENDATE" value="${RECORD['LEGENTSTRACCOPENDATE']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Country of registration (if a foreign entity): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRCountryOfReg" name="LEGENTSTRCOUNTRYOFREG" value="${RECORD['LEGENTSTRCOUNTRYOFREG']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Registration Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRRegNo" name="LEGENTSTRREGNO" value="${RECORD['LEGENTSTRREGNO']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Regulating Body: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRRegulatingBody" name="LEGENTSTRREGULATINGBODY" value="${RECORD['LEGENTSTRREGULATINGBODY']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Registered Address: </td>
				<td width="5%">&nbsp;</td> 
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRRegAddr" name="LEGENTSTRREGADDR" value="${RECORD['LEGENTSTRREGADDR']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Business Address:</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRBsnsAddr" name="LEGENTSTRBSNSADDR" value="${RECORD['LEGENTSTRBSNSADDR']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Contact Number(s):</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntSTRContactNo" name="LEGENTSTRCONTACTNO" value="${RECORD['LEGENTSTRCONTACTNO']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION C <br> TRANSACTION RECIPIENT</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="25%">
					<table>
						<tr>
							<td width="15%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpPerson" value="Natural Person" name="LEGENTSTRTNXRCPTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Natural Person'}">checked="checked"</c:if>> Natural Person
							</td>
							<td width="5%">&nbsp;</td>
							<td width="5%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpComp" value="Company" name="LEGENTSTRTNXRCPTYPE" 
								<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Company'}">checked="checked"</c:if>> Company
							</td>
						</tr>
					</table>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpPrtnrshp" value="Partnership" name="LEGENTSTRTNXRCPTYPE" checked="checked"
								<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Partnership'}">checked="checked"</c:if>> Partnership
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpCo-OpSoc" value="Co-Operative Society" name="LEGENTSTRTNXRCPTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Co-Operative Society'}">checked="checked"</c:if>> Co-Operative Society
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpxNPO" value="Non-Profit Organisation" name="LEGENTSTRTNXRCPTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Non-Profit Organisation'}">checked="checked"</c:if>> Non-Profit Organisation
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="20%">
					<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpOther" value="Others" name="LEGENTSTRTNXRCPTYPE"
					<c:if test="${RECORD['LEGENTSTRTNXRCPTYPE'] eq 'Others'}">checked="checked"</c:if>> Others
				</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					(Please specify):<input type="text" class="form-control input-sm" id="legEntSTRTnxRcpOthersDetails" name="LEGENTSTRTNXRCPOTHERSDETAILS" value="${RECORD['LEGENTSTRTNXRCPOTHERSDETAILS']}"> 
				</td>
			</tr>
			</tr>
			<tr>
				<td width="20%">Name</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legEntSTRTnxRcpName" name="LEGENTSTRTNXRCPNAME" value="${RECORD['LEGENTSTRTNXRCPNAME']}"> 
				</td> 
			</tr>
			<tr>
				<td width="20%">ID No: </td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legEntSTRTnxRcpIdNo" name="LEGENTSTRTNXRCPIDNO" value="${RECORD['LEGENTSTRTNXRCPIDNO']}"> 
				</td>
			</tr>
			<tr>
				<td width="25%">ID Type(select one of the following):</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpIdCard" value="Identity card" name="LEGENTSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPIDTYPE'] eq 'Identity card'}">checked="checked"</c:if>> Identity card
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpPassport" value="Passport" name="LEGENTSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPIDTYPE'] eq 'Passport'}">checked="checked"</c:if>> Passport
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpDL" value="Driving License" name="LEGENTSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPIDTYPE'] eq 'Driving License'}">checked="checked"</c:if>> Driving License
							</td>
							<td width="5%">&nbsp;</td>	
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpWorkPermit" value="Work Permit" name="LEGENTSTRTNXRCPIDTYPE" checked="checked"
								<c:if test="${RECORD['LEGENTSTRTNXRCPIDTYPE'] eq 'Work Permit'}">checked="checked"</c:if>> Work Permit
							</td>
							<td width="5%">&nbsp;</td>
						</tr>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRTnxRcpOther" value="Others" name="LEGENTSTRTNXRCPIDTYPE"
								<c:if test="${RECORD['LEGENTSTRTNXRCPIDTYPE'] eq 'Others'}">checked="checked"</c:if>> Others
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">(Please specify): </td>
							<td colspan="6">
								<input type="text" class="form-control input-sm"  id="legEntSTRTnxRcpOtherDetails" value="${RECORD['LEGENTSTRTNXRCPIDTYPEOTHERDETAILS']}" name="LEGENTSTRTNXRCPIDTYPEOTHERDETAILS">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="25%">Address:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="legEntSTRTnxRcpAddr" name="LEGENTSTRTNXRCPADDR">${RECORD['LEGENTSTRTNXRCPADDR']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="25%">Issuer:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="legEntSTRTnxRcpIssuer" name="LEGENTSTRTNXRCPISSUER" value="${RECORD['LEGENTSTRTNXRCPISSUER']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Issued Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="legEntSTRTnxRcpIssDate" name="LEGENTSTRTNXRCPISSDATE" value="${RECORD['LEGENTSTRTNXRCPISSDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Expiry Date:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" placeholder="DD/MM/YYYY" id="legEntSTRTnxRcpExpDate" name="LEGENTSTRTNXRCPEXPDATE" value="${RECORD['LEGENTSTRTNXRCPEXPDATE']}">
				</td>
			</tr>
			<tr>
				<td width="25%">Nationality:</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm"  id="legEntSTRTnxRcpNationality" name="LEGENTSTRTNXRCPNATIONALITY" value="${RECORD['LEGENTSTRTNXRCPNATIONALITY']}">
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION D<br> BUSINESS AFFILIATIONS</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="35%"> Is the suspected party afiliated with the institution in any way (includes customers)?</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRBsnsAffiSusPartyAffiliated" value="Yes" name="LEGENTBSNSAFFILIATION"
								<c:if test="${RECORD['LEGENTBSNSAFFILIATION'] eq 'Yes'}">checked="checked"</c:if>> Yes
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntSTRBsnsAffiSusPartyNotAffiliated" value="No" name="LEGENTBSNSAFFILIATION" checked="checked"
								<c:if test="${RECORD['LEGENTBSNSAFFILIATION'] eq 'No'}">checked="checked"</c:if>> No
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="35%">If Yes, please specify the relationship:</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntBsnsAffiRelationship" name="LEGENTBSNSAFFIRELATIONSHIP" value="${RECORD['LEGENTBSNSAFFIRELATIONSHIP']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Relationship status after reporting?</td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<table>
						<tr>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntBsnsAffiRelSuspended" value="Suspended" name="LEGENTBSNSAFFIRELSTATUS" checked="checked"
								<c:if test="${RECORD['LEGENTBSNSAFFIRELSTATUS'] eq 'Suspended'}">checked="checked"</c:if>> Suspended
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntBsnsAffiRelTerminated" value="Terminated" name="LEGENTBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['LEGENTBSNSAFFIRELSTATUS'] eq 'Terminated'}">checked="checked"</c:if>> Terminated
							</td>
							<td width="10%">
								<input type="radio" class="alignRadio"  id="legEntBsnsAffiRelResigned" value="Resigned" name="LEGENTBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['LEGENTBSNSAFFIRELSTATUS'] eq 'Resigned'}">checked="checked"</c:if>> Resigned
							</td>
							<td width="5%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="alignRadio"  id="legEntBsnsAffiRelNoAction" value="No action taken yet" name="LEGENTBSNSAFFIRELSTATUS"
								<c:if test="${RECORD['LEGENTBSNSAFFIRELSTATUS'] eq 'No action taken yet'}">checked="checked"</c:if>> No action taken yet
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
					<textarea class="form-control input-sm"  id="legEntBsnsAffiRelRemarks" name="LEGENTBSNSAFFIRELREMARKS">${RECORD['LEGENTBSNSAFFIRELREMARKS']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="fieldset2">
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
		<h4 style="font-weight: bold; text-align: center;"> SECTION E<br>ACCOUNT INFORMATION<br> ( Banks Only-accounts belonging to or controlled by the Legal Entity )</h4>
		<hr style="border-color: black; border-width: 1px;">
			<tr>
				<td width="35%" style="font-weight: bold; text-decoration: underline;">Account 01:</td>
				<td width="5%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="35%">Bank Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1BankName" name="LEGENTACCINFO1BANKNAME" value="${RECORD['LEGENTACCINFO1BANKNAME']}">
			</tr>
			<tr>
				<td width="35%">Branch Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1BranchName" name="LEGENTACCINFO1BRANCHNAME" value="${RECORD['LEGENTACCINFO1BRANCHNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Name: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1AccName" name="LEGENTACCINFO1ACCNAME" value="${RECORD['LEGENTACCINFO1ACCNAME']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Number: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1AccNo" name="LEGENTACCINFO1ACCNO" value="${RECORD['LEGENTACCINFO1ACCNO']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Opened Date: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1AccOpenDate" name="LEGENTACCINFO1ACCOPENDATE" value="${RECORD['LEGENTACCINFO1ACCOPENDATE']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Account Balance(as of Reporting Date): </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1AccBal" name="LEGENTACCINFO1ACCBAL" value="${RECORD['LEGENTACCINFO1ACCBAL']}">
				</td>
			</tr>
			<tr>
				<td width="35%">Beneficiary: </td>
				<td width="5%">&nbsp;</td>
				<td width="60%">
					<input type="text" class="form-control input-sm"  id="legEntAccInfo1Beneficiary" name="LEGENTACCINFO1BENEFICIARY" value="${RECORD['LEGENTACCINFO1BENEFICIARY']}">
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
				<td colspan="3">
					<p>
						<font style="font-weight: bold; text-decoration: underline;">NOTE :</font> <br>
						If more than 7 transactions, please provide the information in the same format above, on a separate sheet.
					</p>
				</td>
			</tr>
			
		</table>
	
</body>
</html>