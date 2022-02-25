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
<title>UK SAR</title>
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
<form action="${pageContext.request.contextPath}/common/saveUKSAR" method="POST" id="ukSARForm">
<table>
	<tr><h4 style="text-align: right; padding-right: 60px; padding-top: 10px;">Version 2.2</h4>
		<td>
			<div>
				<img src="${pageContext.request.contextPath}/includes/images/NCA_LOGO.jpg"/>
			</div>
		</td>
		<td>
			<div style=" width: 1000px; text-align: right; font-weight: bold;">
				 National Crime Agency <br/> PO Box 8000 <br/> London <br/> SE11 5EN <br/> Tel: 020 7238 8282 <br/>Fax:020 7238 8286
			</div>
		</td>
	</tr>
</table>
	<h4 style="padding: 5px 10px 0 10px; margin: 20px 10px 0 10px ; font-weight: bold;">SOURCE REGISTRATION DOCUMENT</h4>
	<fieldset class="appendix1">
		<h4 style="font-weight: bold;">IMPORTANT - THE DETAILS IN THIS FORM MUST BE PROVIDED WITH YOUR FIRST DISCLOSURE TO THE NCA OR FOLLOWING ANY SUBSEQUENT CHANGE TO THOSE DETAILS.
		</h4>
		<table class="table appendix1" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Institution Name</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="institutionName" name="INSTITUTIONNAME" value="${RECORD['INSTITUTIONNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Institution Type</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="institutionType" name="INSTITUTIONTYPE" value="${RECORD['INSTITUTIONTYPE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Regulator</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="regulator" name="REGULATOR" value="${RECORD['REGULATOR']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Regulator ID</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="regulatorID" name="REGULATORID" value="${RECORD['REGULATORID']}">
				</td>
			</tr>
			<!-- cd=contact details -->
			<tr>
				<td width="15%">Contact Details (1): Forename:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Forename" name="CD1FORENAME" value="${RECORD['CD1FORENAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Surname:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Surname" name="CD1SURNAME" value="${RECORD['CD1SURNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Position:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Position" name="CD1POSITION" value="${RECORD['CD1POSITION']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Address:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<textarea class="form-control input-sm" id="cd1Address" name="CD1ADDRESS">${RECORD['CD1ADDRESS']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="15%">Telephone Details:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Telephone" name="CD1TELEPHONE" value="${RECORD['CD1TELEPHONE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Facsimile Details:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Fax" name="CD1FAX" value="${RECORD['CD1FAX']}">
				</td>
			</tr>
			<tr>
				<td width="15%">E-mail Address:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd1Email" name="CD1EMAIL" value="${RECORD['CD1EMAIL']}">
				</td>
			</tr> 	
			
			<tr>
				<td width="15%">Contact Details (2): Forename: (where applicable)</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Forename" name="CD2FORENAME" value="${RECORD['CD2FORENAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Surname:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Surname" name="CD2SURNAME" value="${RECORD['CD2SURNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Position:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Position" name="CD2POSITION" value="${RECORD['CD2POSITION']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Address:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<textarea class="form-control input-sm" id="cd2Address" name="CD2ADDRESS">${RECORD['CD2ADDRESS']}</textarea>
				</td>
			</tr>
			<tr>
				<td width="15%">Telephone Details:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Telephone" name="CD2TELEPHONE" value="${RECORD['CD2TELEPHONE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Facsimile Details:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Fax" name="CD2FAX" value="${RECORD['CD2FAX']}">
				</td>
			</tr>
			<tr>
				<td width="15%">E-mail Address:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cd2Email" name="CD2EMAIL" value="${RECORD['CD2EMAIL']}">
				</td>
			</tr> 
		</table>
	</fieldset>

	<fieldset class="appendix2a">
		<h4 style="text-align: center; text-decoration: underline; font-weight: bold;">DISCLOSURE REPORT DETAILS: STANDARD REPORT:</h4>
		<table class="table appendix2" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Reporting Institution:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="reportingInstitution" name="REPORTINGINSTITUTION" value="${RECORD['REPORTINGINSTITUTION']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Your Ref:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="yourRef" name="YOURREF" value="${RECORD['YOURREF']}">
				</td>
			</tr>
			<tr>
				<td width="20%">Disclosure Reason:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					&nbsp;
					PoCA 2002:	<input type="radio" class="alignRadio"  id="PoCA2002" value="PoCA 2002" name="DISCLOSUREREASON1"
					<c:if test="${RECORD['DISCLOSUREREASON1'] eq 'PoCA 2002'}">checked="checked"</c:if>>
					&nbsp;
					Terrorism Act 2000:<input type="radio" class="  alignRadio"  id="TerrorismAct2000" value="Terrorism Act 2000" name="DISCLOSUREREASON1"
					<c:if test="${RECORD['DISCLOSUREREASON1'] eq 'Terrorism Act 2000'}">checked="checked"</c:if>>
				</td>
				</tr>
			<tr>
				<td width="15%">Branch/Office:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="branchOffice" name="BRANCHOFFICE" value="${RECORD['BRANCHOFFICE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Consent Required:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="radio" class=" alignRadio"  id="isConsentReq" value="Yes" name="isConsentReq"	
					<c:if test="${RECORD['ISCONSENTREQ'] eq 'Yes'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Disclosure Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="disclosureDate" name="DISCLOSUREDATE" placeholder="DD-MMM-YYYY" value="${RECORD['DISCLOSUREDATE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Type: </td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					&nbsp;
					New:	<input type="radio" class="  alignRadio"  id="newType" value="New" name="DISCLOSUREREPORTTYPE"
							<c:if test="${RECORD['DISCLOSUREREPORTTYPE'] eq 'New'}">checked="checked"</c:if>>		
					&nbsp;
					OR &nbsp; Update:		<input type="radio" class="  alignRadio"  id="updateType" value="Update" name="DISCLOSUREREPORTTYPE"
											<c:if test="${RECORD['DISCLOSUREREPORTTYPE'] eq 'Update'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Existing Disclosure ID/s: (where applicable)</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="30%">
								<input type="text" class="form-control input-sm" id="disclosureID1" name="DISCLOSUREID1" value="${RECORD['DISCLOSUREID1']}">
							</td>
							<td width="5%">&nbsp;</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" id="disclosureID2" name="DISCLOSUREID2" value="${RECORD['DISCLOSUREID2']}">
							</td>
							<td width="5%">&nbsp;</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" id="disclosureID3" name="DISCLOSUREID3" value="${RECORD['DISCLOSUREID3']}">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix2b">
		<h2 style="text-align: center; color: maroon; font-weight: bold;">Please use whichever sheets you feel are necessary and indicate below how many of each you are submitting.</h4>
		<h5 style="text-align: left; text-decoration: underline; font-weight: bold;">REPORT SUMMARY:</h5>
		<table class="table appendix2" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="75%">Number of 'Subject Details' sheet appended relating to a Main Subject: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfSubDetailsMainSub" name="NOOFSUBDETAILSMAINSUB" value="${RECORD['NOOFSUBDETAILSMAINSUB']}">
				</td>
			</tr>
			<tr>
				<td width="75%"> Number of 'Additional Details' sheets appended relating to Main Subject: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfAddDetailsMainSub" name="NOOFADDDETAILSMAINSUB" value="${RECORD['NOOFADDDETAILSMAINSUB']}">
				</td>
			</tr>
			<tr>
				<td width="75%"> Number of 'Subjects Details' sheets appended relating to Associated Subject/s: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfSubDetailsAssoSub" name="NOOFSUBDETAILSASSOSUB" value="${RECORD['NOOFSUBDETAILSASSOSUB']}">
				</td>
			</tr>
			<tr>
				<td width="75%"> Number of 'Additional Details' sheets' appended relating to Associated Subject/s: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfAddDetailsAssoSub" name="NOOFADDDETAILSASSOSUB" value="${RECORD['NOOFADDDETAILSASSOSUB']}">
				</td>
			</tr>
			<tr>
				<td width="75%"> Number of 'Transaction Detail' sheet/s appended: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfTnxDetail" name="NOOFTNXDETAIL" value="${RECORD['NOOFTNXDETAIL']}">
				</td>
			</tr>
			<tr>
				<td width="75%"> Number of 'Reason For Disclosure Sheets' appended: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfReasonForDiscSheets" name="NOOFREASONFORDISCSHEETS" value="${RECORD['NOOFREASONFORDISCSHEETS']}">
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<table>
						<tr>
							<td width="100%">
								<h3 style="font-weight: bold;">Once completed please collate your sheets in the above mentioned order and then sequentially number your sheets at the bottom of each page.
				    				This will ensure that the information is processed in the correct sequence.
								</h3>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="75%" style="text-decoration: underline; font-weight: bold;"> Total number of pages submitted including this Header: </td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					<input type="text" class="form-control input-sm" id="noOfPages" name="NOOFPAGES" value="${RECORD['NOOFPAGES']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h4 style="text-decoration: underline; font-weight: bold; padding-left: 10px;" >SUBJECT DETAILS:</h4>
	<fieldset class="appendix3a">
		<table class="table appendix3" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%" style="text-decoration: underline;">Subject Type:</td>
				<td width="85%">
					<table>
						<tr>
							<td width="10%">Main Subject:</td>
							<td width="5%" >
								<input type="radio" class="alignRadio"  id="mainSubject" value="Main Subject" name="SUBJECTTYPE"
								<c:if test="${RECORD['SUBJECTTYPE'] eq 'Main Subject'}">checked="checked"</c:if>>
							</td>
							<td width="20%" style="text-decoration: underline; text-align: center;">OR</td>
							<td width="10%">Associated Subject:</td>
							<td width="5%" style="text-align: right;">
								<input type="radio" class="alignRadio" id="associatedSubject" value="Associated Subject" name="SUBJECTTYPE"
								<c:if test="${RECORD['SUBJECTTYPE'] eq 'Associated Subject'}">checked="checked"</c:if>>
							</td>
							<td width="25%" style="text-align: center;">
							( number <input type="text" class=" resizeTextBox" id="subjectTypeNum1" name="SUBJECTTYPENUM1" style="width:50px; " value="${RECORD['SUBJECTTYPENUM1']}">
								of <input type="text" class=" resizeTextBox" id="subjectTypeNum2" name="SUBJECTTYPENUM2" style="width:50px;" value="${RECORD['SUBJECTTYPENUM2']}">
								)
							</td>
						</tr>
					</table>
				</td>
			</tr>
	    </table>
	 </fieldset>
	 
	 <fieldset class="appendix3b">
	 	<h5 style="text-decoration: underline; font-weight: bold;">Individual's Details:</h5>
		<table class="table appendix3" style="margin-bottom: 0px; margin-top: 0px; border: none;">	 
			<tr>
				<td width="15%" style="text-decoration: underline;">Subject Status:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="15%">Suspect:</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class=" alignRadio"  id="indvSubStatusSuspect" value="Suspect" name="INDVSUBSTATUS"
								<c:if test="${RECORD['INDVSUBSTATUS'] eq 'Suspect'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%" style="text-decoration: underline;">OR</td>
							<td width="5%">&nbsp;</td>
							<td width="15%">Victim:</td>
							<td width="10%">
								<input type="radio" class="  alignRadio" id="indvSubStatusVictim" value="Victim" name="INDVSUBSTATUS"
								<c:if test="${RECORD['INDVSUBSTATUS'] eq 'Victim'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="15%">Surname:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
				<!-- id=individual details -->
					<input type="text" class="form-control input-sm" id="idSurname" name="IDSURNAME" value="${RECORD['IDSURNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Forename 1:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="idForename1" name="IDFORENAME1" value="${RECORD['IDFORENAME1']}" >
				</td>
			</tr>
			<tr>
				<td width="15%">Forename 2:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="idForename2" name="IDFORENAME2" value="${RECORD['IDFORENAME2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Occupation:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="occupation" name="OCCUPATION" value="${RECORD['OCCUPATION']}">
				</td>
			</tr>
			<tr>
				<td width="15%">DoB:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="doB" name="DOB" placeholder="DD-MMM-YYYY" value="${RECORD['DOB']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Gender: </td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					&nbsp;
					Male  <input type="radio" class="  alignRadio"  id="male" value="Male" name="GENDER"
					<c:if test="${RECORD['GENDER'] eq 'Male'}">checked="checked"</c:if>>		
					&nbsp;
					Female	<input type="radio" class="  alignRadio"  id="female" value="Female" name="GENDER"
					<c:if test="${RECORD['GENDER'] eq 'Female'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Title: </td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					&nbsp;
					Mr  <input type="radio" class="  alignRadio"  id="mr" value="Mr" name="TITLE"
					<c:if test="${RECORD['TITLE'] eq 'Mr'}">checked="checked"</c:if>>		
					&nbsp;
					Mrs	<input type="radio" class="  alignRadio"  id="mrs" value="Mrs" name="TITLE"
					<c:if test="${RECORD['TITLE'] eq 'Mrs'}">checked="checked"</c:if>>
					&nbsp;
					Miss	<input type="radio" class="  alignRadio"  id="miss" value="Miss" name="TITLE"
					<c:if test="${RECORD['TITLE'] eq 'Miss'}">checked="checked"</c:if>>
					&nbsp;
					Ms	<input type="radio" class="  alignRadio"  id="ms" value="Ms" name="TITLE"
					<c:if test="${RECORD['TITLE'] eq 'Ms'}">checked="checked"</c:if>>
					&nbsp;
					Other	<input type="text" class="resizeTextBox"  id="otherTitle" name="OTHERTITLE" value="${RECORD['OTHERTITLE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Reason for Association of this subject to the Main Subject (for use only with Associated Subject details)</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="reasonForAsso1" name="REASONFORASSO1">${RECORD['REASONFORASSO1']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h2 style="text-decoration: underline; font-weight: bold; text-align: center;">OR</h2>
	
	 <fieldset class="appendix3c">
	 	<h5 style="text-decoration: underline; font-weight: bold;">Legal Entity's Details</h5>
		<table class="table appendix3" style="margin-bottom: 0px; margin-top: 0px; border: none;">	 
			<tr>
				<td width="15%" style="text-decoration: underline;">Subject Status:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							
							<td width="15%">Suspect:</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">
								<input type="radio" class="  alignRadio"  id="legalEntityStatusSuspect" value="Suspect" name="LEGALENTITYSTATUS"
								<c:if test="${RECORD['LEGALENTITYSTATUS'] eq 'Suspect'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%" style="text-decoration: underline;">OR</td>
							<td width="5%">&nbsp;</td>
							<td width="15%">Victim:</td>
							<td width="10%">
								<input type="radio" class="  alignRadio" id="legalEntityStatusVictim" value="Victim" name="LEGALENTITYSTATUS"
								<c:if test="${RECORD['LEGALENTITYSTATUS'] eq 'Victim'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="15%">Legal Entity Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legalEntityName" name="LEGALENTITYNAME" value="${RECORD['LEGALENTITYNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Legal Entity No:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="legalEntityNo" name="LEGALENTITYNO" value="${RECORD['LEGALENTITYNO']}">
				</td>
			</tr>
			<tr>
				<td width="15%">VAT No:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="vatNo" name="VATNO" value="${RECORD['VATNO']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Country of Reg:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="countryOfReg" name="COUNTRYOFREG" value="${RECORD['COUNTRYOFREG']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Type of Business:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="businessType" name="BUSINESSTYPE" value="${RECORD['BUSINESSTYPE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Reason for Association of this subject to the Main Subject (for use only with Associated Subject details)</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm"  id="reasonForAsso2" name="REASONFORASSO2">${RECORD['REASONFORASSO2']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h4 style="text-decoration: underline; font-weight: bold; padding-left: 10px;">ADDITIONAL DETAILS:</h4>
	<fieldset class="appendix4a">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">	 
			<tr>
				<td width="25%" >Do these details refer to the Main Subject: </td>
			    <td width="5%">&nbsp;</td>
			    <td width="70%">
			    	<table>
			    		<tr>
				    		<td width="10%">
								<input type="radio" class="  alignRadio"  id="referToMainSubject" value="Main Subject" name="subjectRefTo"
								<c:if test="${RECORD['SUBJECTREFTO'] eq 'Main Subject'}">checked="checked"</c:if>>
							</td>
							<td width="5%">&nbsp;</td>
							<td width="10%">OR</td>
							<td width="5%">&nbsp;</td>
							<td width="15%">to an Associated Subject</td>
							<td width="10%">
								<input type="radio" class="  alignRadio" id="referToAssoSubject" value="Associated Subject" name="subjectRefTo"
								<c:if test="${RECORD['SUBJECTREFTO'] eq 'Associated Subject'}">checked="checked"</c:if>>
							</td>
			    		</tr>
			    	</table>
			    </td>			    
			</tr>
			<tr>
				<td width="25%">(Please indicate the Associate's number where applicable)</td>
				<td width="5%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="associateNo" name="ASSOCIATENO" value="${RECORD['ASSOCIATENO']}">
				</td>
			</tr>
		</table>
		</fieldset>
		
		<fieldset class="appendix4b">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Subject Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="subjectName" name="SUBJECTNAME" value="${RECORD['SUBJECTNAME']}">
				</td>
			</tr>
		</table>
		</fieldset>
		
		<fieldset class="appendix4c">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Premise No/Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="premiseNoName1" name="PREMISENONAME1" value="${RECORD['PREMISENONAME1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Current:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="radio" class=" alignRadio"  id="currentPremise1" value="Yes" name="currentPremise1"
					<c:if test="${RECORD['CURRENTPREMISE1'] eq 'Yes'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="typeOfPremise1" name="TYPEOFPREMISE1" value="${RECORD['TYPEOFPREMISE1']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Street:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="street1" name="STREET1" value="${RECORD['STREET1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">City/Town:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cityOrTown1" name="CITYORTOWN1" value="${RECORD['CITYORTOWN1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">County:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="county1" name="COUNTY1" value="${RECORD['COUNTY1']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Post Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="postCode1" name="POSTCODE1" value="${RECORD['POSTCODE1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Country:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="country1" name="COUNTRY1" value="${RECORD['COUNTRY1']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix4d">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Premise No/Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="premiseNoName2" name="premiseNoName2" value="${RECORD['PREMISENONAME2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Current:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="radio" class="alignRadio"  id="currentPremise2" value="Yes" name="CURRENTPREMISE2"
					<c:if test="${RECORD['CURRENTPREMISE2'] eq 'Yes'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="typeOfPremise2" name="TYPEOFPREMISE2" value="${RECORD['TYPEOFPREMISE2']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Street:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="street2" name="STREET2" value="${RECORD['STREET2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">City/Town:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cityOrTown2" name="CITYORTOWN2" value="${RECORD['CITYORTOWN2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">County:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="county2" name="COUNTY2" value="${RECORD['COUNTY2']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Post Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="postCode2" name="POSTCODE2" value="${RECORD['POSTCODE2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Country:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="country2" name="COUNTRY2" value="${RECORD['COUNTRY2']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix4e">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Premise No/Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="premiseNoName3" name="PREMISENONAME3" value="${RECORD['PREMISENONAME3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Current:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="radio" class="  alignRadio"  id="currentPremise3" value="Yes" name="CURRENTPREMISE3"
					<c:if test="${RECORD['CURRENTPREMISE3'] eq 'Yes'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="15%">Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="typeOfPremise3" name="TYPEOFPREMISE3" value="${RECORD['TYPEOFPREMISE3']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Street:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="street3" name="STREET3" value="${RECORD['STREET3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">City/Town:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="cityOrTown3" name="CITYORTOWN3" value="${RECORD['CITYORTOWN3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">County:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="county3" name="COUNTY3" value="${RECORD['COUNTY3']}">	
				</td>
			</tr>
			<tr>
				<td width="15%">Post Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="postCode3" name="POSTCODE3" value="${RECORD['POSTCODE3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Country:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="country3" name="COUNTRY3" value="${RECORD['COUNTRY3']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix4f">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Information Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="infoType1" name="INFOTYPE1" value="${RECORD['INFOTYPE1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Unique Information Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm" id="unqInfoIdentifier1" name="UNQINFOIDENTIFIER1">${RECORD['UNQINFOIDENTIFIER1']}</textarea>	
				</td>
			</tr>
			<tr>
				<td width="15%">Extra Information / Description</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<textarea class="form-control input-sm" id="extraInfo1" name="EXTRAINFO1">${RECORD['EXTRAINFO1']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>	
	
	<fieldset class="appendix4g">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Information Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="infoType2" name="INFOTYPE2" value="${RECORD['INFOTYPE2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Unique Information Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<textarea class="form-control input-sm" id="unqInfoIdentifier2" name="UNQINFOIDENTIFIER2">${RECORD['UNQINFOIDENTIFIER2']}</textarea>	
				</td>
			</tr>
			<tr>
				<td width="15%">Extra Information / Description</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<textarea class="form-control input-sm" id="extraInfo2" name="EXTRAINFO2">${RECORD['EXTRAINFO2']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>	
	
	<h5 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">TRANSACTION DETAILS: (Complete if applicable)</h5>
	<h5 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">MAIN SUBJECT ACCOUNT SUMMARY</h5>
	<fieldset class="appendix5a">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Institution Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="maiSubACInstitutionName" name="MAISUBACINSTITUTIONNAME" value="${RECORD['MAISUBACINSTITUTIONNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account Name:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="accountName" name="ACCOUNTNAME" value="${RECORD['ACCOUNTNAME']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Sort Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="sortCode" name="SORTCODE" value="${RECORD['SORTCODE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account No /Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="accountNo" name="ACCOUNTNO" value="${RECORD['ACCOUNTNO']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Business Relationship Commenced:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="busiRelationStart" name="BUSIRELATIONSTART" placeholder="DD-MMM-YYYY" value="${RECORD['BUSIRELATIONSTART']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Business Relationship Finished:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="busiRelationFinish" name="BUSIRELATIONFINISH" placeholder="DD-MMM-YYYY" value="${RECORD['BUSIRELATIONFINISH']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account Balance:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="accBal" name="ACCBAL" value="${RECORD['ACCBAL']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Balance Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="balDate" name="BALDATE" placeholder="DD-MMM-YYYY" value="${RECORD['BALDATE']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Turnover Period:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="turnoverPeriod" name="TURNOVERPERIOD" value="${RECORD['TURNOVERPERIOD']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Credit Turnover:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="creditTurnover" name="CREDITTURNOVER" value="${RECORD['CREDITTURNOVER']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Debit Turnover:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="debitTurnover" name="DEBITTURNOVER" value="${RECORD['DEBITTURNOVER']}">
				</td>
			</tr>
		</table>
	</fieldset>	
	
	<h5 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">TRANSACTION/S</h5>
	<fieldset class="appendix5b">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Activity Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="activityType1" name="ACTIVITYTYPE1" value="${RECORD['ACTIVITYTYPE1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Activity Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="activityDate1" name="ACTIVITYDATE1" placeholder="DD-MMM-YYYY" value="${RECORD['ACTIVITYDATE1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Amount:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="amount1" name="AMOUNT1" value="${RECORD['AMOUNT1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Currency:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="currency1" name="CURRENCY1" value="${RECORD['CURRENCY1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Credit:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxCredit1" value="Credit" name="TNXCREDITDEBIT1"
								<c:if test="${RECORD['TNXCREDITDEBIT1'] eq 'Credit'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%">or</td>
							<td width="20%">&nbsp;</td>
							<td width="15%">Debit:</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxDebit1" value="Debit" name="TNXCREDITDEBIT1"
								<c:if test="${RECORD['TNXCREDITDEBIT1'] eq 'Debit'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			<tr>
				<td width="15%">Other party name:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="otherPartyName1" name="OTHERPARTYNAME1" value="${RECORD['OTHERPARTYNAME1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Institution Name or Sort Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxInstitutionName1" name="TNXINSTITUTIONNAME1" value="${RECORD['TNXINSTITUTIONNAME1']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account No/ Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxAccNo1" name="TNXACCNO1" value="${RECORD['TNXACCNO1']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix5c">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Activity Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="activityType2" name="ACTIVITYTYPE2" value="${RECORD['ACTIVITYTYPE2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Activity Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="activityDate2" name="ACTIVITYDATE2" placeholder="DD-MMM-YYYY" value="${RECORD['ACTIVITYDATE2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Amount:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="amount2" name="AMOUNT2" value="${RECORD['AMOUNT2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Currency:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="currency2" name="CURRENCY2" value="${RECORD['CURRENCY2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Credit:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxCredit2" value="Credit2" name="tnxCreditDebit2"
								<c:if test="${RECORD['TNXCREDITDEBIT2'] eq 'Credit'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%">or</td>
							<td width="20%">&nbsp;</td>
							<td width="15%">Debit:</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxDebit2" value="Debit" name="tnxCreditDebit2"
								<c:if test="${RECORD['TNXCREDITDEBIT2'] eq 'Debit'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			<tr>
				<td width="15%">Other party name:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="otherPartyName2" name="OTHERPARTYNAME2" value="${RECORD['OTHERPARTYNAME2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Institution Name or Sort Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxInstitutionName2" name="TNXINSTITUTIONNAME2" value="${RECORD['TNXINSTITUTIONNAME2']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account No/ Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxAccNo2" name="TNXACCNO2" value="${RECORD['TNXACCNO2']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix5d">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Activity Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="activityType3" name="ACTIVITYTYPE3" value="${RECORD['ACTIVITYTYPE3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Activity Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="activityDate3" name="ACTIVITYDATE3" placeholder="DD-MMM-YYYY" value="${RECORD['ACTIVITYDATE3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Amount:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="amount3" name="AMOUNT3" value="${RECORD['AMOUNT3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Currency:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="currency3" name="CURRENCY3" value="${RECORD['CURRENCY3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Credit:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxCredit3" value="Credit" name="tnxCreditDebit3"
								<c:if test="${RECORD['TNXCREDITDEBIT3'] eq 'Credit'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%">or</td>
							<td width="20%">&nbsp;</td>
							<td width="15%">Debit:</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="  alignRadio"  id="tnxDebit3" value="Debit" name="tnxCreditDebit3"
								<c:if test="${RECORD['TNXCREDITDEBIT3'] eq 'Debit'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			<tr>
				<td width="15%">Other party name:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="otherPartyName3" name="OTHERPARTYNAME3" value="${RECORD['OTHERPARTYNAME3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Institution Name or Sort Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxInstitutionName3" name="TNXINSTITUTIONNAME3" value="${RECORD['TNXINSTITUTIONNAME3']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account No/ Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxAccNo3" name="TNXACCNO3" value="${RECORD['TNXACCNO3']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix5e">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Activity Type:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="activityType4" name="ACTIVITYTYPE4" value="${RECORD['ACTIVITYTYPE4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Activity Date:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="activityDate4" name="ACTIVITYDATE4" placeholder="DD-MMM-YYYY" value="${RECORD['ACTIVITYDATE4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Amount:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="amount4" name="AMOUNT4" value="${RECORD['AMOUNT4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Currency:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="currency4" name="CURRENCY4" value="${RECORD['CURRENCY4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Credit:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<table>
						<tr>
							<td width="20%">
								<input type="radio" class="alignRadio"  id="tnxCredit4" value="Credit" name="tnxCreditDebit4"
								<c:if test="${RECORD['TNXCREDITDEBIT4'] eq 'Credit'}">checked="checked"</c:if>>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="10%">or</td>
							<td width="20%">&nbsp;</td>
							<td width="15%">Debit:</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">
								<input type="radio" class="alignRadio"  id="tnxDebit4" value="Debit" name="tnxCreditDebit4"
								<c:if test="${RECORD['TNXCREDITDEBIT4'] eq 'Debit'}">checked="checked"</c:if>>
							</td>
						</tr>
					</table>
					
				</td>
			</tr>
			<tr>
				<td width="15%">Other party name:</td>
				<td width="10%">&nbsp;</td>
				<td width="70%">
					<input type="text" class="form-control input-sm" id="otherPartyName4" name="OTHERPARTYNAME4" value="${RECORD['OTHERPARTYNAME4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Institution Name or Sort Code:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxInstitutionName4" name="TNXINSTITUTIONNAME4" value="${RECORD['TNXINSTITUTIONNAME4']}">
				</td>
			</tr>
			<tr>
				<td width="15%">Account No/ Identifier:</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="tnxAccNo4" name="TNXACCNO4" value="${RECORD['TNXACCNO4']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h5 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">REASON FOR DISCLOSURE:</h5>
	<fieldset class="appendix6a">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Main Subject Name: (cross reference purposes)</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="mainSubName" name="MAINSUBNAME" value="${RECORD['MAINSUBNAME']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix6b">
	<h3 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">Report Activity Assessment 
	(Please use only where you know or suspect what the offence behind the reported activity may be)</h3>
	<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">	
			<tr>
				<td width="10%">Drugs:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="drugs" value="Drugs" name="DRUGS"
					<c:if test="${RECORD['DRUGS'] eq 'Drugs'}">checked="checked"</c:if>>
	    		</td>
			    <td width="20%">Missing Trader, Inter Community (VAT) Fraud:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="missingTrader" value="Missing Trader" name="MISSINGTRADER"
					<c:if test="${RECORD['MISSINGTRADER'] eq 'Missing Trader'}">checked="checked"</c:if>>
				</td>
				<td width="10%">Immigration:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="immigration" value="Immigration" name="IMMIGRATION"
					<c:if test="${RECORD['IMMIGRATION'] eq 'Missing Trader'}">checked="checked"</c:if>>
				</td>
				<td width="20%">Tobacco/Alcohol Excise Fraud:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="tobaccoExciseFraud" value="Tobacco Excise Fraud" name="TOBACCOEXCISEFRAUD"
					<c:if test="${RECORD['TOBACCOEXCISEFRAUD'] eq 'Missing Trader'}">checked="checked"</c:if>>
				</td>
			</tr>
			<tr>
				<td width="10%">Personal Tax Fraud:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="personalTaxFraud" value="Personal Tax Fraud" name="PERSONALTAXFRAUD"
					<c:if test="${RECORD['PERSONALTAXFRAUD'] eq 'Personal Tax Fraud'}">checked="checked"</c:if>>
				</td>
			    <td width="10%">Corporate Tax Fraud:</td>
				<td width="10%">
					<input type="radio" class="  alignRadio"  id="corporateTaxFraud" value="Corporate Tax Fraud" name="CORPORATETAXFRAUD"
					<c:if test="${RECORD['CORPORATETAXFRAUD'] eq 'Corporate Tax Fraud'}">checked="checked"</c:if>>
				</td>
				<td width="10%">Other Offences:</td>
				<td width="10%" colspan="3">
					<input type="text" class="form-control input-sm"  id="otherOffences" name="OTHEROFFENCES" value="${RECORD['OTHEROFFENCES']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<fieldset class="appendix6c">
	<h3 style="text-decoration: underline; font-weight: bold;">Reason for Disclosure:</h3>
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="100%">
					<textarea rows="10" cols="10" class="form-control input-sm"  id="disclosureReason2" name="DISCLOSUREREASON2">${RECORD['DISCLOSUREREASON2']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h4 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">REASON FOR DISCLOSURE CONTINUATION:</h4>
	<fieldset class="appendix7a">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="15%">Main Subject Name: (cross reference purposes)</td>
				<td width="10%">&nbsp;</td>
				<td width="75%">
					<input type="text" class="form-control input-sm" id="mainSubNameCont" name="MAINSUBNAMECONT" value="${RECORD['MAINSUBNAMECONT']}">
				</td>
			</tr>
		</table>
	</fieldset>
	
	<h5 style="text-decoration: underline; font-weight: bold; padding-left: 30px;">Reason for Disclosure - Continuation:</h5>
	<fieldset class="appendix7b">
		<table class="table appendix" style="margin-bottom: 0px; margin-top: 0px; border: none;">
			<tr>
				<td width="100%">
					<textarea rows="10" cols="10" class="form-control input-sm"  id="disclosureReasonCont" name="DISCLOSUREREASONCONT">${RECORD['DISCLOSUREREASONCONT']}</textarea>
				</td>
			</tr>
		</table>
	</fieldset>
	<input type="hidden" name = "caseNo" value="${caseNo}"> 
	<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="submit" id="saveUKSAR" class="btn btn-primary btn-sm">Save</button>
				<button type="reset" id="clearUKSAR" class="btn btn-danger btn-sm">Clear</button>
			</div>
	</div>
	<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
</form>
</body>
</html>