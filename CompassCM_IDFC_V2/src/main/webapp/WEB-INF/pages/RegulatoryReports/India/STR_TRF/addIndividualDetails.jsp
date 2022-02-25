<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
 try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	HttpSession l_CHttpSession = request.getSession(true);
	String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}

	HashMap hmNewIndividualDetails = null;
	ISTRTRFIndividualDetailsVO objIndividualDetailsVO = null;
	String l_strRelFlag = "";
	String l_strAccountNo = "";

	String strBranchName 		= "";
	String strBranchBSRCode 	= "";
	String strEnclosedAnnexture = "";
	String strCustomerFullName 	= "";
	String strCustomerId 		= "";
	String strAccountNo 		= "";
	String strFatherName 		= "";
	String strOccupationDescription = "";
	String strDateOfBirth 			= "";
	String strSexOfIndividual 	= "";
	String strNationality 	= "";
	String strIdentificationDocument 		= "";
	String strIdentificationNumber = "";
	String strIssuingAuthority 	= "";
	String strPlaceOfIssue 		= "";
	String strPanIdNo 			= "";
	String strUINNo				= "";
	String strAddressBuildingNo = "";
	String strAddressStreet 	= "";
	String strAddressLocality 	= "";
	String strAddressCity 		= "";
	String strAddressState 		= "";
	String strAddressCountry	= "";
	String strAddressPinCode 		= "";
	String strAddressTelNo 		= "";
	String strAddressFaxNo 		= "";
	String strAddressBranchMobileNo 	= "";
	String strAddressBranchEmailId 		= "";
	String strEmployerNameOfIndividual = "";
	String strSecondAddressBuildingNo = "";
	String strSecondAddressStreet 	= "";
	String strSecondAddressLocality 	= "";
	String strSecondAddressCity 		= "";
	String strSecondAddressState 	= "";
	String strSecondAddressCountry 	= "";
	String strSecondAddressPinCode 	= "";
	String strSecondAddressTelephoneNo 	= "";
	String strRelationFlag = "A";
	String strReadOnly = "";
	String strDisabled = "";
	if((HashMap)request.getAttribute("HmAddNewIndivDTO")!=null)
	{
	  hmNewIndividualDetails = (HashMap)request.getAttribute("HmAddNewIndivDTO");
	}
	if(hmNewIndividualDetails != null)
	{
		objIndividualDetailsVO =  (ISTRTRFIndividualDetailsVO)hmNewIndividualDetails.get("ALIndvDetailsDTO");
		strRelationFlag = (String)hmNewIndividualDetails.get("RelationFlag");
		//System.out.println("CounterAccountno :   "+hmNewIndividualDetails.get("CounterAccountno"));
		l_strAccountNo = (String)hmNewIndividualDetails.get("CounterAccountno");	
	}
	
	if(objIndividualDetailsVO!=null){
		strBranchName 		 = (objIndividualDetailsVO.getNameOfBank() == null) ? "" : objIndividualDetailsVO.getNameOfBank();
		strBranchBSRCode 	 = (objIndividualDetailsVO.getBSRCode() == null) ? "" : objIndividualDetailsVO.getBSRCode();
		strEnclosedAnnexture = (objIndividualDetailsVO.getAnnexEnclosed() == null) ? "" : objIndividualDetailsVO.getAnnexEnclosed();
		strCustomerFullName  = (objIndividualDetailsVO.getFullName() == null) ? "" : objIndividualDetailsVO.getFullName();
		strCustomerId 		 = (objIndividualDetailsVO.getCustomerId() == null) ? "" : objIndividualDetailsVO.getCustomerId();
		strAccountNo         = (objIndividualDetailsVO.getAccountNo() == null) ? "" : objIndividualDetailsVO.getAccountNo();
		strFatherName 		 = (objIndividualDetailsVO.getFatherName() == null) ? "" : objIndividualDetailsVO.getFatherName();
		strOccupationDescription = (objIndividualDetailsVO.getOccupation() == null) ? "" : objIndividualDetailsVO.getOccupation();
		strDateOfBirth 			= (objIndividualDetailsVO.getDob() == null) ? "" : objIndividualDetailsVO.getDob();
		if(strDateOfBirth.length() >= 10)
			strDateOfBirth = strDateOfBirth.substring(0,10);
		strSexOfIndividual  = (objIndividualDetailsVO.getSex() == null) ? "" : objIndividualDetailsVO.getSex();
		strNationality 		= (objIndividualDetailsVO.getNationality() == null) ? "" : objIndividualDetailsVO.getNationality();
		strIdentificationDocument = (objIndividualDetailsVO.getIdDoc() == null) ? "" : objIndividualDetailsVO.getIdDoc();
		strIdentificationNumber = (objIndividualDetailsVO.getIdNumber() == null) ? "" : objIndividualDetailsVO.getIdNumber();
		strIssuingAuthority 	= (objIndividualDetailsVO.getIssuingAuth() == null) ? "" : objIndividualDetailsVO.getIssuingAuth();
		strPlaceOfIssue 		= (objIndividualDetailsVO.getPlaceOfIssue() == null) ? "" : objIndividualDetailsVO.getPlaceOfIssue();
		strPanIdNo 				= (objIndividualDetailsVO.getPanNo() == null) ? "" : objIndividualDetailsVO.getPanNo();
		strUINNo 				= (objIndividualDetailsVO.getUinNo() == null) ? "" : objIndividualDetailsVO.getUinNo();
		strAddressBuildingNo 	= (objIndividualDetailsVO.getAddBuildingNo() == null) ? "" : objIndividualDetailsVO.getAddBuildingNo();
		strAddressStreet 		= (objIndividualDetailsVO.getAddStreet() == null) ? "" : objIndividualDetailsVO.getAddStreet();
		strAddressLocality 		= (objIndividualDetailsVO.getAddLocality() == null) ? "" : objIndividualDetailsVO.getAddLocality();
		strAddressCity 			= (objIndividualDetailsVO.getAddCity() == null) ? "" : objIndividualDetailsVO.getAddCity();
		strAddressState 		= (objIndividualDetailsVO.getAddState() == null) ? "" : objIndividualDetailsVO.getAddState();
		strAddressCountry 		= (objIndividualDetailsVO.getAddCountry() == null) ? "" : objIndividualDetailsVO.getAddCountry();
		strAddressPinCode 		= (objIndividualDetailsVO.getAddPinCode() == null) ? "" : objIndividualDetailsVO.getAddPinCode();
		strAddressTelNo 		= (objIndividualDetailsVO.getAddTelNo() == null) ? "" : objIndividualDetailsVO.getAddTelNo();
		strAddressFaxNo         = (objIndividualDetailsVO.getAddFaxNo() == null) ? "" : objIndividualDetailsVO.getAddFaxNo();
		strAddressBranchMobileNo = (objIndividualDetailsVO.getAddMobileNo() == 	null) ? "" : objIndividualDetailsVO.getAddMobileNo();
		strAddressBranchEmailId = (objIndividualDetailsVO.getAddEmail() == null) ? "" : objIndividualDetailsVO.getAddEmail();
		strEmployerNameOfIndividual = (objIndividualDetailsVO.getAddEmployername() == null) ? "" : objIndividualDetailsVO.getAddEmployername();
		strSecondAddressBuildingNo 	= (objIndividualDetailsVO.getSecaddBuildingNo() == null) ? "" : objIndividualDetailsVO.getSecaddBuildingNo();
		strSecondAddressStreet 		= (objIndividualDetailsVO.getSecaddStreet() == 	null) ? "" : objIndividualDetailsVO.getSecaddStreet();
		strSecondAddressLocality 	= (objIndividualDetailsVO.getSecaddLocality() == null) ? "" : objIndividualDetailsVO.getSecaddLocality();
		strSecondAddressCity 		= (objIndividualDetailsVO.getSecaddCity() == null) ? "" : objIndividualDetailsVO.getSecaddCity();
		strSecondAddressState 		= (objIndividualDetailsVO.getSecaddState() == null) ? "" : objIndividualDetailsVO.getSecaddState();
		strSecondAddressCountry		= (objIndividualDetailsVO.getSecaddCountry() == null) ? "" : objIndividualDetailsVO.getSecaddCountry();
		strSecondAddressPinCode 	= (objIndividualDetailsVO.getSecaddPinCode() == null) ? "" : objIndividualDetailsVO.getSecaddPinCode();
		strSecondAddressTelephoneNo = (objIndividualDetailsVO.getSecaddTelNo() == null) ? "" : objIndividualDetailsVO.getSecaddTelNo();
	}
	
	String strFullAddress = strAddressBuildingNo;
	if(!strAddressStreet.trim().equals(""))
		strFullAddress = strFullAddress +", "+strAddressStreet;
	if(!strAddressLocality.trim().equals(""))
		strFullAddress = strFullAddress +", "+strAddressLocality;
	
	String strSecondFullAddress = strSecondAddressBuildingNo;
	if(!strSecondAddressStreet.trim().equals(""))
		strSecondFullAddress = strSecondFullAddress +", "+strSecondAddressStreet;
	if(!strSecondAddressLocality.trim().equals(""))
		strSecondFullAddress = strSecondFullAddress +", "+strSecondAddressLocality;

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<title>AddNewIndividuals</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
  <script src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
  <style type="text/css">
	#batchDate{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#dateOfBirth" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
	});
	
	function validate(form){
		//console.log(form);
		var customerId =  document.getElementById("newIndividualDetails").elements.namedItem("customerId").value;
		if(customerId !== ""){
			form.submit();
		}else{
			alert("Please insert customer id.");
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<%
	String IsSaved = (String) request.getAttribute("IsSaved");
	if(IsSaved!=null && IsSaved.equalsIgnoreCase("Yes")){
%>
	<script>
	//opener.document.form1.Type.value='showBlankIndianSTR';
	//opener.document.form1.caseNo.value='<%=caseNo%>';
	//opener.document.form1.submit();
	//window.opener.location.reload();
	alert('Party has been added to the individual list');
	var caseNo = '<%=caseNo%>';
	// window.opener.location.reload();
	window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRTRFReport?caseNo="+caseNo+"&canUpdated=Y&canExported=N");
	window.close();
    </script>
<%}%>
<body>
<div class="content">
<form id="newIndividualDetails" name="NewIndividualDetails" action="<%=contextPath%>/common/saveNewINDSTRTRFIndividuals?${_csrf.parameterName}=${_csrf.token}" method="post">
  <input type="hidden" name ="IDDocument" value="">
  <input type="hidden" name ="RelationFlag" value="">
  <input type="hidden" name ="CounterAccountNo" value='<%=l_strAccountNo%>'>
  <input type="hidden" name ="CounterId" value='<%=(objIndividualDetailsVO==null || objIndividualDetailsVO.getCustomerId()==null)? "":objIndividualDetailsVO.getCustomerId()%>'>
  <input type="hidden" name ="CounterName" value='<%=(objIndividualDetailsVO==null || objIndividualDetailsVO.getFullName()==null)? "":objIndividualDetailsVO.getFullName()%>'>
  <input type="hidden" name="BSRCode" value='<%=(objIndividualDetailsVO==null || objIndividualDetailsVO.getBSRCode()==null)? "":objIndividualDetailsVO.getBSRCode()%>'>

<div class="header">
			<table class="header-table">
				<tr>
					<td class="leftside">
						<div class="headerText">Individual Details</div>
					</td>
					<td class="rightside">
						<ul class="box rightAligned">
							<li>ANNEXURE</li>
							<li>INP</li>
							<li class="last">1</li>
						</ul>
					</td>
				</tr>
			</table>
			</div>

	<div class="section" style="height : 2100px;">
			
			<%-- <div class="normalTextField">
				<label>1. Name of Reporting Entity</label>
				<input type="text" name="repBranchName" <%=readOnly%> value="<%=strBranchName%>" />
			</div> --%>
			<div class="normalTextField">
				<label>1. Person Name</label>
				<input type="text" name="customerFullName" <%=readOnly%> value="<%=strCustomerFullName%>" />
			</div>
			<div class="normalTextField">
				<label>2. Customer ID</label><br/>
				<input type="text" name="customerId" <%=readOnly%> value="<%=strCustomerId%>" />
			</div>
			<%-- <div class="normalTextField">
				<label>3.1 Account No</label><br/>
				<input type="text" name="accountNo" <%=readOnly%> value="<%=strAccountNo%>" />
			</div> --%>
			
			
			<div class="normalTextField">
				<label>3. Relation Flag</label><br/>
				<select	name="individualRelationFlag" <%=disabled%>>
					<option value="A" <% if(strRelationFlag.equals("A")) {%>selected<% } %>>A - Account Holder</option>
					<option value="B" <% if(strRelationFlag.equals("B")) {%>selected<% } %>>B - Authorized Signatory</option>
					<option value="C" <% if(strRelationFlag.equals("C")) {%>selected<% } %>>C - Proprietor/Director/Partner/Member of a legal entity</option>	
					<option value="D" <% if(strRelationFlag.equals("D")) {%>selected<% } %>>D - Introducer</option>
					<option value="E" <% if(strRelationFlag.equals("E")) {%>selected<% } %>>E - Guarantor</option>
					<option value="F" <% if(strRelationFlag.equals("F")) {%>selected<% } %>>F - Guardian</option>
					<option value="G" <% if(strRelationFlag.equals("G")) {%>selected<% } %>>G - Assignee</option>	
					<option value="H" <% if(strRelationFlag.equals("H")) {%>selected<% } %>>H - Power Of Attorney</option>
					<option value="J" <% if(strRelationFlag.equals("J")) {%>selected<% } %>>J - Beneficiary</option>
					<option value="L" <% if(strRelationFlag.equals("L")) {%>selected<% } %>>L - Life Assured</option>
					<option value="N" <% if(strRelationFlag.equals("N")) {%>selected<% } %>>N - Nominee</option>
					<option value="O" <% if(strRelationFlag.equals("O")) {%>selected<% } %>>O - Beneficial Owner</option>
					<option value="P" <% if(strRelationFlag.equals("P")) {%>selected<% } %>>P - Proposer</option>
					<option value="X" <% if(strRelationFlag.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
					<option value="Z" <% if(strRelationFlag.equals("Z")) {%>selected<% } %>>Z - Others</option>
				</select>
			</div>
			<div class="normalTextField">
				<label>5. Father/Spouse Name</label></br>
				<input type="text" name="fatherName" <%=readOnly%> value="<%=strFatherName%>" />
			</div>
			<div class="normalTextField">
				<label>6. Occupation</label></br>
				<input type="text" name="occupationDescription" <%=readOnly%> value="<%=strOccupationDescription%>" />
			</div>
			<div class="normalTextField">
				<label>7. Date of Birth</label><br/>
				<input type="text" name="dateOfBirth" <%=readOnly%> id="dateOfBirth" value="<%=strDateOfBirth%>" class="medium"/>
			</div>
			<div class="normalTextField">
				<label>8. Gender</label></br>
				<select	name="sexOfIndividual" <%=disabled%>>
					<option value="M" <% if(strSexOfIndividual.equals("M")) {%>selected<% } %>>M - Male</option>
					<option value="F" <% if(strSexOfIndividual.equals("F")) {%>selected<% } %>>F - Female</option>
					<option value="X" <% if(strSexOfIndividual.equals("X")) {%>selected<% } %>>X - Not Categorised</option>	
				</select>
			</div>
			<div class="normalTextField">
				<label>9. Nationality</label></br>
				<input type="text" name="nationality" <%=readOnly%>  value="<%=strNationality%>" />
			</div>
			<div class="normalTextField">
				<label>10. Identification Type</label></br>
				<select	name="identificationDocumentType" <%=disabled%>>
					<option value="A" <% if(strIdentificationDocument.equals("A")) {%>selected<% } %>>A - Passport</option>
					<option value="B" <% if(strIdentificationDocument.equals("B")) {%>selected<% } %>>B - Election Id card</option>
					<option value="C" <% if(strIdentificationDocument.equals("C")) {%>selected<% } %>>C - Pan card</option>	
					<option value="D" <% if(strIdentificationDocument.equals("D")) {%>selected<% } %>>D - Id card</option>
					<option value="E" <% if(strIdentificationDocument.equals("E")) {%>selected<% } %>>E - Driving License</option>
					<option value="F" <% if(strIdentificationDocument.equals("F")) {%>selected<% } %>>F - Account Introducer</option>
					<option value="G" <% if(strIdentificationDocument.equals("G")) {%>selected<% } %>>G - UIDAI Letter</option>	
					<option value="H" <% if(strIdentificationDocument.equals("H")) {%>selected<% } %>>H - NREGA job card</option>
					<option value="Z" <% if(strIdentificationDocument.equals("Z")) {%>selected<% } %>>Z - Others</option>
				</select>
			</div>
			<div class="normalTextField">
				<label>11. Identification Number</label></br>
				<input type="text" name="identificationNumber" <%=readOnly%> value="<%=strIdentificationNumber%>" />
			</div>
			<div class="normalTextField">
				<label>12. Identification Issuing Authority</label></br>
				<input type="text" name="issuingAuthority" <%=readOnly%> value="<%=strIssuingAuthority%>" />
			</div>
			<div class="normalTextField">
				<label>13. Identification Issuing Place</label></br>
				<input type="text" name="placeOfIssue" <%=readOnly%> value="<%=strPlaceOfIssue%>" />
			</div>
			<div class="normalTextField">
				<label>14. PAN</label></br>
				<input type="text" name="panIdNo" <%=readOnly%> value="<%=strPanIdNo%>" />
			</div>
			<div class="normalTextField">
				<label>15. UIN</label></br>
				<input type="text" name="UINumber" <%=readOnly%> value="<%=strUINNo%>" />
			</div>
			<div class="normalTextField">
				<label>16. Place of Work</label></br>
				<input type="text" name="placeOfWork" <%=readOnly%> value="<%=strEmployerNameOfIndividual%>" />
			</div>
			<div class="normalTextField">
				<label>17. Communication Address</label></br>
				<textarea name="commAddressLine1" <%=readOnly%> ><%=strFullAddress%></textarea>
			</div>
			<div class="normalTextField">
				<label>18. City</label><br/>
				<input type="text" name="commAddressCity" <%=readOnly%> value="<%=strAddressCity%>"/>
			</div>
			<div class="normalTextField">
				<label>19. State Code</label></br>
				<%-- <input type="text" name="commAddressState" <%=readOnly%> value="<%=strAddressState%>"/> --%>
				<select name="commAddressState" <%=readOnly%>>
					<option value="AN" title="Andaman & Nicobar" <% if(strAddressState.equals("AN")) {%>selected<% } %>>AN- Andaman & Nicobar </option>
					<option value="AP" title="Andhra Pradesh" <% if(strAddressState.equals("AP")) {%>selected<% } %>>AP- Andhra Pradesh</option>
					<option value="AR" title="Arunachal Pradesh" <% if(strAddressState.equals("AR")) {%>selected<% } %>>AR- Arunachal Pradesh</option>
					<option value="AS" title="Assam" <% if(strAddressState.equals("AS")) {%>selected<% } %>>AS- Assam</option>
					<option value="BR" title="Bihar" <% if(strAddressState.equals("BR")) {%>selected<% } %>>BR- Bihar</option>
					<option value="CH" title="Chandigarh" <% if(strAddressState.equals("CH")) {%>selected<% } %>>CH- Chandigarh</option>
					<option value="CG" title="Chattisgarh" <% if(strAddressState.equals("CG")) {%>selected<% } %>>CG- Chattisgarh</option>
					<option value="DN" title="Dadra and Nagar Haveli" <% if(strAddressState.equals("DN")) {%>selected<% } %>>DN- Dadra and Nagar Haveli</option>
					<option value="DD" title="Daman & Diu" <% if(strAddressState.equals("DD")) {%>selected<% } %>>DD- Daman & Diu</option>
					<option value="DL" title="Delhi" <% if(strAddressState.equals("DL")) {%>selected<% } %>>DL- Delhi</option>
					<option value="GA" title="Goa" <% if(strAddressState.equals("GA")) {%>selected<% } %>>GA- Goa</option>
					<option value="GJ" title="Gujarat" <% if(strAddressState.equals("GJ")) {%>selected<% } %>>GJ- Gujarat</option>
					<option value="HR" title="Haryana" <% if(strAddressState.equals("HR")) {%>selected<% } %>>HR- Haryana</option>
					<option value="HP" title="Himachal Pradesh" <% if(strAddressState.equals("HP")) {%>selected<% } %>>HP- Himachal Pradesh</option>
					<option value="JK" title="Jammu & Kashmir" <% if(strAddressState.equals("JK")) {%>selected<% } %>>JK- Jammu & Kashmir</option>
					<option value="JH" title="Jharkhand" <% if(strAddressState.equals("JH")) {%>selected<% } %>>JH- Jharkhand</option>
					<option value="KA" title="Karnataka" <% if(strAddressState.equals("KA")) {%>selected<% } %>>KA- Karnataka</option>
					<option value="KL" title="Kerala" <% if(strAddressState.equals("KL")) {%>selected<% } %>>KL- Kerala</option>
					<option value="LD" title="Lakshadweep" <% if(strAddressState.equals("LD")) {%>selected<% } %>>LD- Lakshadweep</option>
					<option value="MP" title="Madhya Pradesh" <% if(strAddressState.equals("MP")) {%>selected<% } %>>MP- Madhya Pradesh</option>
					<option value="MH" title="Maharashtra" <% if(strAddressState.equals("MH")) {%>selected<% } %>>MH- Maharashtra</option>
					<option value="MN" title="Manipur" <% if(strAddressState.equals("MN")) {%>selected<% } %>>MN- Manipur</option>
					<option value="ML" title="Meghalaya" <% if(strAddressState.equals("ML")) {%>selected<% } %>>ML- Meghalaya</option>
					<option value="MZ" title="Mizoram" <% if(strAddressState.equals("MZ")) {%>selected<% } %>>MZ- Mizoram</option>
					<option value="NL" title="Nagaland" <% if(strAddressState.equals("NL")) {%>selected<% } %>>NL- Nagaland</option>
					<option value="OR" title="Orissa" <% if(strAddressState.equals("OR")) {%>selected<% } %>>OR- Orissa</option>
					<option value="PY" title="Pondicherry" <% if(strAddressState.equals("PY")) {%>selected<% } %>>PY- Pondicherry</option>
					<option value="PB" title="Punjab" <% if(strAddressState.equals("PB")) {%>selected<% } %>>PB- Punjab</option>
					<option value="RJ" title="Rajasthan" <% if(strAddressState.equals("RJ")) {%>selected<% } %>>RJ- Rajasthan</option>
					<option value="SK" title="Sikkim" <% if(strAddressState.equals("SK")) {%>selected<% } %>>SK- Sikkim</option>
					<option value="TN" title="Tamil Nadu" <% if(strAddressState.equals("TN")) {%>selected<% } %>>TN- Tamil Nadu</option>
					<option value="TR" title="Tripura" <% if(strAddressState.equals("TR")) {%>selected<% } %>>TR- Tripura</option>
					<option value="UP" title="Uttar Pradesh" <% if(strAddressState.equals("UP")) {%>selected<% } %>>UP- Uttar Pradesh</option>
					<option value="UA" title="Uttarakhand" <% if(strAddressState.equals("UA")) {%>selected<% } %>>UA- Uttarakhand</option>
					<option value="WB" title="West Bengal" <% if(strAddressState.equals("WB")) {%>selected<% } %>>WB- West Bengal</option>
					<option value="ZZ" title="Others" <% if(strAddressState.equals("ZZ")) {%>selected<% } %>>ZZ- Others</option>
					<option value="XX" title="Not Applicable" <% if(strAddressState.equals("XX")) {%>selected<% } %>>XX -Not Applicable</option>
				</select>
			</div>
			<div class="normalTextField">
				<label>20. Country Code</label></br>
				<%-- <input type="text" name="commAddressCountry" <%=readOnly%> value="<%=strAddressCountry%>" /> --%>
				<select name="commAddressCountry" <%=readOnly%>>
					<option value="IN" title="India" <% if(strAddressCountry.equals("IN")) {%>selected<% } %>>IN-India</option>		
					<option value="AF" title="Afghanistan" <% if(strAddressCountry.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
					<option value="AX" title="Aland Islands" <% if(strAddressCountry.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
					<option value="AL" title="Albania" <% if(strAddressCountry.equals("AL")) {%>selected<% } %>>AL-Albania</option>
					<option value="DZ" title="Algeria" <% if(strAddressCountry.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
					<option value="AS" title="American Samoa" <% if(strAddressCountry.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
					<option value="AD" title="Andorra" <% if(strAddressCountry.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
					<option value="AO" title="Angola" <% if(strAddressCountry.equals("AO")) {%>selected<% } %>>AO-Angola</option>
					<option value="AI" title="Anguilla" <% if(strAddressCountry.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
					<option value="AQ" title="Antarctica" <% if(strAddressCountry.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
					<option value="AG" title="Antigua And Barbuda" <% if(strAddressCountry.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
					<option value="AR" title="Argentina" <% if(strAddressCountry.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
					<option value="AM" title="Armenia" <% if(strAddressCountry.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
					<option value="AW" title="Aruba" <% if(strAddressCountry.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
					<option value="AU" title="Australia" <% if(strAddressCountry.equals("AU")) {%>selected<% } %>>AU-Australia</option>
					<option value="AT" title="Austria" <% if(strAddressCountry.equals("AT")) {%>selected<% } %>>AT-Austria</option>
					<option value="AZ" title="Azerbaijan" <% if(strAddressCountry.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
					<option value="BS" title="Bahamas" <% if(strAddressCountry.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
					<option value="BH" title="Bahrain" <% if(strAddressCountry.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
					<option value="BD" title="Bangladesh" <% if(strAddressCountry.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
					<option value="BB" title="Barbados" <% if(strAddressCountry.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
					<option value="BY" title="Belarus" <% if(strAddressCountry.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
					<option value="BE" title="Belgium" <% if(strAddressCountry.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
					<option value="BZ" title="Belize" <% if(strAddressCountry.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
					<option value="BJ" title="Benin" <% if(strAddressCountry.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
					<option value="BM" title="Bermuda" <% if(strAddressCountry.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
					<option value="BT" title="Bhutan" <% if(strAddressCountry.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
					<option value="BO" title="Bolivia" <% if(strAddressCountry.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
					<option value="BA" title="Bosnia And Herzegovina" <% if(strAddressCountry.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
					<option value="BW" title="Botswana" <% if(strAddressCountry.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
					<option value="BV" title="Bouvet Island" <% if(strAddressCountry.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
					<option value="BR" title="Brazil" <% if(strAddressCountry.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
					<option value="IO" title="British Indian Ocean Territory" <% if(strAddressCountry.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
					<option value="BN" title="Brunei Darussalam" <% if(strAddressCountry.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
					<option value="BG" title="Bulgaria" <% if(strAddressCountry.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
					<option value="BF" title="Burkina Faso" <% if(strAddressCountry.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
					<option value="BI" title="Burundi" <% if(strAddressCountry.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
					<option value="KH" title="Cambodia" <% if(strAddressCountry.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
					<option value="CM" title="Cameroon" <% if(strAddressCountry.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
					<option value="CA" title="Canada" <% if(strAddressCountry.equals("CA")) {%>selected<% } %>>CA-Canada</option>
					<option value="CV" title="Cape Verde" <% if(strAddressCountry.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
					<option value="KY" title="Cayman Islands" <% if(strAddressCountry.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
					<option value="CF" title="Central African Republic" <% if(strAddressCountry.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
					<option value="TD" title="Chad" <% if(strAddressCountry.equals("TD")) {%>selected<% } %>>TD-Chad</option>
					<option value="CL" title="Chile" <% if(strAddressCountry.equals("CL")) {%>selected<% } %>>CL-Chile</option>
					<option value="CN" title="China" <% if(strAddressCountry.equals("CN")) {%>selected<% } %>>CN-China</option>
					<option value="CX" title="Christmas Island" <% if(strAddressCountry.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
					<option value="CC" title="Cocos (Keeling) Islands" <% if(strAddressCountry.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
					<option value="CO" title="Colombia" <% if(strAddressCountry.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
					<option value="KM" title="Comoros" <% if(strAddressCountry.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
					<option value="CG" title="Congo" <% if(strAddressCountry.equals("CG")) {%>selected<% } %>>CG-Congo</option>
					<option value="CD" title="Congo,Democratic Republic" <% if(strAddressCountry.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
					<option value="CK" title="Cook Islands" <% if(strAddressCountry.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
					<option value="CR" title="Costa Rica" <% if(strAddressCountry.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
					<option value="CI" title="Côte D'ivoire" <% if(strAddressCountry.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
					<option value="HR" title="Croatia" <% if(strAddressCountry.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
					<option value="CU" title="Cuba" <% if(strAddressCountry.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
					<option value="CY" title="Cyprus" <% if(strAddressCountry.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
					<option value="CZ" title="Czech Republic" <% if(strAddressCountry.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
					<option value="DK" title="Denmark" <% if(strAddressCountry.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
					<option value="DJ" title="Djibouti" <% if(strAddressCountry.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
					<option value="DM" title="Dominica" <% if(strAddressCountry.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
					<option value="DO" title="Dominican Republic" <% if(strAddressCountry.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
					<option value="EC" title="Ecuador" <% if(strAddressCountry.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
					<option value="EG" title="Egypt" <% if(strAddressCountry.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
					<option value="SV" title="El Ssalvador" <% if(strAddressCountry.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
					<option value="GQ" title="Equatorial Guinea" <% if(strAddressCountry.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
					<option value="ER" title="Eritrea" <% if(strAddressCountry.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
					<option value="EE" title="Estonia" <% if(strAddressCountry.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
					<option value="ET" title="Ethiopia" <% if(strAddressCountry.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
					<option value="FK" title="Falkland Islands (Malvinas)" <% if(strAddressCountry.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
					<option value="FO" title="Faroe Islands" <% if(strAddressCountry.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
					<option value="FJ" title="Fiji" <% if(strAddressCountry.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
					<option value="FI" title="Finland" <% if(strAddressCountry.equals("FI")) {%>selected<% } %>>FI-Finland</option>
					<option value="FR" title="France" <% if(strAddressCountry.equals("FR")) {%>selected<% } %>>FR-France</option>
					<option value="GF" title="French Guiana" <% if(strAddressCountry.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
					<option value="PF" title="French Polynesia" <% if(strAddressCountry.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
					<option value="TF" title="French Southern Territories" <% if(strAddressCountry.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
					<option value="GA" title="Gabon" <% if(strAddressCountry.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
					<option value="GM" title="Gambia" <% if(strAddressCountry.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
					<option value="GE" title="Georgia" <% if(strAddressCountry.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
					<option value="DE" title="Germany" <% if(strAddressCountry.equals("DE")) {%>selected<% } %>>DE-Germany</option>
					<option value="GH" title="Ghana" <% if(strAddressCountry.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
					<option value="GI" title="Gibraltar" <% if(strAddressCountry.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
					<option value="GR" title="Greece" <% if(strAddressCountry.equals("GR")) {%>selected<% } %>>GR-Greece</option>
					<option value="GL" title="Greenland" <% if(strAddressCountry.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
					<option value="GD" title="Grenada" <% if(strAddressCountry.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
					<option value="GP" title="Guadeloupe" <% if(strAddressCountry.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
					<option value="GU" title="Guam" <% if(strAddressCountry.equals("GU")) {%>selected<% } %>>GU-Guam</option>
					<option value="GT" title="Guatemala" <% if(strAddressCountry.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
					<option value="GG" title="Guernsey" <% if(strAddressCountry.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
					<option value="GN" title="Guinea" <% if(strAddressCountry.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
					<option value="GW" title="Guinea-Bisaau" title="Bissau" <% if(strAddressCountry.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
					<option value="GY" title="Guyana" <% if(strAddressCountry.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
					<option value="HT" title="Haiti" <% if(strAddressCountry.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
					<option value="HM" title="Heard Island And Mcdonald Islands" <% if(strAddressCountry.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
					<option value="VA" title="Vatican City State" <% if(strAddressCountry.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
					<option value="HN" title="Honduras" <% if(strAddressCountry.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
					<option value="HK" title="Hong Kong" <% if(strAddressCountry.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
					<option value="HU" title="Hungary" <% if(strAddressCountry.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
					<option value="IS" title="Iceland" <% if(strAddressCountry.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
					<option value="ID" title="Indonesia" <% if(strAddressCountry.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
					<option value="IR" title="Iran" <% if(strAddressCountry.equals("IR")) {%>selected<% } %>>IR-Iran</option>
					<option value="IQ" title="Iraq" <% if(strAddressCountry.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
					<option value="IE" title="Ireland" <% if(strAddressCountry.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
					<option value="IM" title="Isle Of Man" <% if(strAddressCountry.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
					<option value="IL" title="Israel" <% if(strAddressCountry.equals("IL")) {%>selected<% } %>>IL-Israel</option>
					<option value="IT" title="Italy" <% if(strAddressCountry.equals("IT")) {%>selected<% } %>>IT-Italy</option>
					<option value="JM" title="Jamaica" <% if(strAddressCountry.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
					<option value="JP" title="Japan" <% if(strAddressCountry.equals("JP")) {%>selected<% } %>>JP-Japan</option>
					<option value="JE" title="Jersey" <% if(strAddressCountry.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
					<option value="JO" title="Jordan" <% if(strAddressCountry.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
					<option value="KZ" title="Kazakhstan" <% if(strAddressCountry.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
					<option value="KE" title="Kenya" <% if(strAddressCountry.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
					<option value="KI" title="Kiribati" <% if(strAddressCountry.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
					<option value="KP" title="Korea, Democratic People's Republic" <% if(strAddressCountry.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
					<option value="KR" title="Korea" <% if(strAddressCountry.equals("KR")) {%>selected<% } %>>KR-Korea</option>
					<option value="KW" title="Kuwait" <% if(strAddressCountry.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
					<option value="KG" title="Kyrgyzstan" <% if(strAddressCountry.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
					<option value="LA" title="Lao People's Democratic Republic" <% if(strAddressCountry.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
					<option value="LV" title="Latvia" <% if(strAddressCountry.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
					<option value="LB" title="Lebanon" <% if(strAddressCountry.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
					<option value="LS" title="Lesotho" <% if(strAddressCountry.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
					<option value="LR" title="Liberia" <% if(strAddressCountry.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
					<option value="LY" title="Libyan Arab Jamahiriya" <% if(strAddressCountry.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
					<option value="LI" title="Liechtenstein" <% if(strAddressCountry.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
					<option value="LT" title="Lithuania" <% if(strAddressCountry.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
					<option value="LU" title="Luxembourg" <% if(strAddressCountry.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
					<option value="MO" title="Macao" <% if(strAddressCountry.equals("MO")) {%>selected<% } %>>MO-Macao</option>
					<option value="MK" title="Macedonia, The Former Yugoslav Repub" <% if(strAddressCountry.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
					<option value="MG" title="Madagascar" <% if(strAddressCountry.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
					<option value="MW" title="Malawi" <% if(strAddressCountry.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
					<option value="MY" title="Malaysia" <% if(strAddressCountry.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
					<option value="MV" title="Maldives" <% if(strAddressCountry.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
					<option value="ML" title="Mali" <% if(strAddressCountry.equals("ML")) {%>selected<% } %>>ML-Mali</option>
					<option value="MT" title="Malta" <% if(strAddressCountry.equals("MT")) {%>selected<% } %>>MT-Malta</option>
					<option value="MH" title="Marshall Islands" <% if(strAddressCountry.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
					<option value="MQ" title="Martinique" <% if(strAddressCountry.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
					<option value="MR" title="Mauritania" <% if(strAddressCountry.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
					<option value="MU" title="Mauritius" <% if(strAddressCountry.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
					<option value="YT" title="Mayotte" <% if(strAddressCountry.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
					<option value="MX" title="Mexico" <% if(strAddressCountry.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
					<option value="FM" title="Micronesia" <% if(strAddressCountry.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
					<option value="MD" title="Moldova" <% if(strAddressCountry.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
					<option value="MC" title="Monaco" <% if(strAddressCountry.equals("MC")) {%>selected<% } %>>MC-Monaco</option>
					<option value="MN" title="Mongolia" <% if(strAddressCountry.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
					<option value="ME" title="Montenegro" <% if(strAddressCountry.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
					<option value="MS" title="Montserrat" <% if(strAddressCountry.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
					<option value="MA" title="Morocco" <% if(strAddressCountry.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
					<option value="MZ" title="Mozambique" <% if(strAddressCountry.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
					<option value="MM" title="Myanmar" <% if(strAddressCountry.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
					<option value="NA" title="Namibia" <% if(strAddressCountry.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
					<option value="NR" title="Nauru" <% if(strAddressCountry.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
					<option value="NP" title="Nepal" <% if(strAddressCountry.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
					<option value="NL" title="Netherlands" <% if(strAddressCountry.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
					<option value="AN" title="Netherlands Antilles" <% if(strAddressCountry.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
					<option value="NC" title="New Caledonia" <% if(strAddressCountry.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
					<option value="NZ" title="New Zealand" <% if(strAddressCountry.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
					<option value="NI" title="Nicaragua" <% if(strAddressCountry.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
					<option value="NE" title="Niger" <% if(strAddressCountry.equals("NE")) {%>selected<% } %>>NE-Niger</option>
					<option value="NG" title="Nigeria" <% if(strAddressCountry.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
					<option value="NU" title="Niue" <% if(strAddressCountry.equals("NU")) {%>selected<% } %>>NU-Niue</option>
					<option value="NF" title="Norfolk Island" <% if(strAddressCountry.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
					<option value="MP" title="Northern Mariana Islands" <% if(strAddressCountry.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
					<option value="NO" title="Norway" <% if(strAddressCountry.equals("NO")) {%>selected<% } %>>NO-Norway</option>
					<option value="OM" title="Oman" <% if(strAddressCountry.equals("OM")) {%>selected<% } %>>OM-Oman</option>
					<option value="PK" title="Pakistan" <% if(strAddressCountry.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
					<option value="PW" title="Palau" <% if(strAddressCountry.equals("PW")) {%>selected<% } %>>PW-Palau</option>
					<option value="PS" title="Palestinian Territory, Occupied" <% if(strAddressCountry.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
					<option value="PA" title="Panama" <% if(strAddressCountry.equals("PA")) {%>selected<% } %>>PA-Panama</option>
					<option value="PG" title="Papua New Guinea" <% if(strAddressCountry.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
					<option value="PY" title="Paraguay" <% if(strAddressCountry.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
					<option value="PE" title="Peru" <% if(strAddressCountry.equals("PE")) {%>selected<% } %>>PE-Peru</option>
					<option value="PH" title="Philippines" <% if(strAddressCountry.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
					<option value="PN" title="Pitcairn" <% if(strAddressCountry.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
					<option value="PL" title="Poland" <% if(strAddressCountry.equals("PL")) {%>selected<% } %>>PL-Poland</option>
					<option value="PT" title="Portugal" <% if(strAddressCountry.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
					<option value="PR" title="Puerto Rico" <% if(strAddressCountry.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
					<option value="QA" title="Qatar" <% if(strAddressCountry.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
					<option value="RE" title="Réunion" <% if(strAddressCountry.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
					<option value="RO" title="Romania" <% if(strAddressCountry.equals("RO")) {%>selected<% } %>>RO-Romania</option>
					<option value="RU" title="Russian Federation" <% if(strAddressCountry.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
					<option value="RW" title="Rwanda" <% if(strAddressCountry.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
					<option value="BL" title="Saint Barthélemy" <% if(strAddressCountry.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
					<option value="SH" title="Saint Helena, Ascension And Tristan" <% if(strAddressCountry.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
					<option value="KN" title="Saint Kitts And Nevis" <% if(strAddressCountry.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
					<option value="LC" title="Saint Lucia" <% if(strAddressCountry.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
					<option value="MF" title="Saint Martin" <% if(strAddressCountry.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
					<option value="PM" title="Saint Pierre And Miquelon" <% if(strAddressCountry.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
					<option value="VC" title="Saint Vincent And The Grenadines" <% if(strAddressCountry.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
					<option value="WS" title="Samoa" <% if(strAddressCountry.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
					<option value="SM" title="San Marino" <% if(strAddressCountry.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
					<option value="ST" title="Sao Tome And Principe" <% if(strAddressCountry.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
					<option value="SA" title="Saudi Arabia" <% if(strAddressCountry.equals("SA")) {%>selected<% } %>>SA-Saudi Arabia</option>
					<option value="SN" title="Senegal" <% if(strAddressCountry.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
					<option value="RS" title="Serbia" <% if(strAddressCountry.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
					<option value="SC" title="Seychelles" <% if(strAddressCountry.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
					<option value="SL" title="Sierra Leone" <% if(strAddressCountry.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
					<option value="SG" title="Singapore" <% if(strAddressCountry.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
					<option value="SK" title="Slovakia" <% if(strAddressCountry.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
					<option value="SI" title="Slovenia" <% if(strAddressCountry.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
					<option value="SB" title="Solomon Islands" <% if(strAddressCountry.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
					<option value="SO" title="Somalia" <% if(strAddressCountry.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
					<option value="ZA" title="South Africa" <% if(strAddressCountry.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
					<option value="GS" title="South Georgia And The South Sandwich" <% if(strAddressCountry.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
					<option value="ES" title="Spain" <% if(strAddressCountry.equals("ES")) {%>selected<% } %>>ES-Spain</option>
					<option value="LK" title="Sri Lanka" <% if(strAddressCountry.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
					<option value="SD" title="Sudan" <% if(strAddressCountry.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
					<option value="SR" title="Suriname" <% if(strAddressCountry.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
					<option value="SJ" title="Svalbard And Jan Mayen" <% if(strAddressCountry.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
					<option value="SZ" title="Swaziland" <% if(strAddressCountry.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
					<option value="SE" title="Sweden" <% if(strAddressCountry.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
					<option value="CH" title="Switzerland" <% if(strAddressCountry.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
					<option value="SY" title="Syrian Arab Republic" <% if(strAddressCountry.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
					<option value="TW" title="Taiwan, Province Of China" <% if(strAddressCountry.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
					<option value="TJ" title="Tajikistan" <% if(strAddressCountry.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
					<option value="TZ" title="Tanzania" <% if(strAddressCountry.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
					<option value="TH" title="Thailand" <% if(strAddressCountry.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
					<option value="TL" title="Timor" title="Leste" <% if(strAddressCountry.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
					<option value="TG" title="Togo" <% if(strAddressCountry.equals("TG")) {%>selected<% } %>>TG-Togo</option>
					<option value="TK" title="Tokelau" <% if(strAddressCountry.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
					<option value="TO" title="Tonga" <% if(strAddressCountry.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
					<option value="TT" title="Trinidad And Tobago" <% if(strAddressCountry.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
					<option value="TN" title="Tunisia" <% if(strAddressCountry.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
					<option value="TR" title="Turkey" <% if(strAddressCountry.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
					<option value="TM" title="Turkmenistan" <% if(strAddressCountry.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
					<option value="TC" title="Turks And Caicos Islands" <% if(strAddressCountry.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
					<option value="TV" title="Tuvalu" <% if(strAddressCountry.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
					<option value="UG" title="Uganda" <% if(strAddressCountry.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
					<option value="UA" title="Ukraine" <% if(strAddressCountry.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
					<option value="AE" title="United Arab Emirates" <% if(strAddressCountry.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
					<option value="GB" title="United Kingdom" <% if(strAddressCountry.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
					<option value="US" title="United States" <% if(strAddressCountry.equals("US")) {%>selected<% } %>>US-United States</option>
					<option value="UM" title="United States Minor Outlying Islands" <% if(strAddressCountry.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
					<option value="UY" title="Uruguay" <% if(strAddressCountry.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
					<option value="UZ" title="Uzbekistan" <% if(strAddressCountry.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
					<option value="VU" title="Vanuatu" <% if(strAddressCountry.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
					<option value="VE" title="Venezuela" <% if(strAddressCountry.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
					<option value="VN" title="Viet Nam" <% if(strAddressCountry.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
					<option value="VG" title="Virgin Islands, British" <% if(strAddressCountry.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
					<option value="VI" title="Virgin Islands, U.S." <% if(strAddressCountry.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
					<option value="WF" title="Wallis And Futuna" <% if(strAddressCountry.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
					<option value="EH" title="Western Sahara" <% if(strAddressCountry.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
					<option value="YE" title="Yemen" <% if(strAddressCountry.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
					<option value="ZM" title="Zambia" <% if(strAddressCountry.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
					<option value="ZW" title="Zimbabwe" <% if(strAddressCountry.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
					<option value="SS" title="South Sudan" <% if(strAddressCountry.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
					<option value="CW" title="Curacao" <% if(strAddressCountry.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
					<option value="BQ" title="Bonaire, Sint Eustatius and Saba" <% if(strAddressCountry.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
					<option value="SX" title="Sint Marteen" <% if(strAddressCountry.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
					<option value="XX" title="Not available " <% if(strAddressCountry.equals("XX")) {%>selected<% } %>>XX-Not available </option>
					<option value="ZZ" title="Others" <% if(strAddressCountry.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
				</select>
			</div>
			
			
			<div class="normalTextField">
				<label>21. PIN Code</label></br>
				<input type="text" name="commAddressPinCode" <%=readOnly%> value="<%=strAddressPinCode%>" />
			</div>
			<div class="normalTextField">
				<label>22. Telephone</label></br>
				<input type="text" name="commAddressTelephoneNo" <%=readOnly%> value="<%=strAddressTelNo%>" />
			</div>
			<div class="normalTextField">
				<label>23. Mobile</label></br>
				<input type="text" name="commAddressMobileNo" <%=readOnly%> value="<%=strAddressBranchMobileNo%>" />
			</div>
			<div class="normalTextField">
				<label>24. FAX</label></br>
				<input type="text" name="commAddressFaxNo" <%=readOnly%> value="<%=strAddressFaxNo%>" />
			</div>
			<div class="normalTextField">
				<label>25. E-mail Address</label></br>
				<input type="text" name="commAddressEmailId" <%=readOnly%> value="<%=strAddressBranchEmailId%>" />
			</div>
			
			
			<div class="normalTextField">
				<label>26. Second Address(Permanent Address / Place of Work)</label>
				<textarea name="secAddressLine1" <%=readOnly%> ><%=strSecondFullAddress%></textarea>
			</div>
			<div class="normalTextField">
				<label>27. City</label><br/>
				<input type="text" name="secAddressCity" <%=readOnly%> value="<%=strSecondAddressCity%>"/>
			</div>
			<div class="normalTextField">
				<label>28. State Code</label></br>
				<%-- <input type="text" name="secAddressState" <%=readOnly%> value="<%=strSecondAddressState%>"/> --%>
				<select name="secAddressState" <%=readOnly%>>
					<option value="AN" title="Andaman & Nicobar" <% if(strSecondAddressState.equals("AN")) {%>selected<% } %>>AN- Andaman & Nicobar </option>
					<option value="AP" title="Andhra Pradesh" <% if(strSecondAddressState.equals("AP")) {%>selected<% } %>>AP- Andhra Pradesh</option>
					<option value="AR" title="Arunachal Pradesh" <% if(strSecondAddressState.equals("AR")) {%>selected<% } %>>AR- Arunachal Pradesh</option>
					<option value="AS" title="Assam" <% if(strSecondAddressState.equals("AS")) {%>selected<% } %>>AS- Assam</option>
					<option value="BR" title="Bihar" <% if(strSecondAddressState.equals("BR")) {%>selected<% } %>>BR- Bihar</option>
					<option value="CH" title="Chandigarh" <% if(strSecondAddressState.equals("CH")) {%>selected<% } %>>CH- Chandigarh</option>
					<option value="CG" title="Chattisgarh" <% if(strSecondAddressState.equals("CG")) {%>selected<% } %>>CG- Chattisgarh</option>
					<option value="DN" title="Dadra and Nagar Haveli" <% if(strSecondAddressState.equals("DN")) {%>selected<% } %>>DN- Dadra and Nagar Haveli</option>
					<option value="DD" title="Daman & Diu" <% if(strSecondAddressState.equals("DD")) {%>selected<% } %>>DD- Daman & Diu</option>
					<option value="DL" title="Delhi" <% if(strSecondAddressState.equals("DL")) {%>selected<% } %>>DL- Delhi</option>
					<option value="GA" title="Goa" <% if(strSecondAddressState.equals("GA")) {%>selected<% } %>>GA- Goa</option>
					<option value="GJ" title="Gujarat" <% if(strSecondAddressState.equals("GJ")) {%>selected<% } %>>GJ- Gujarat</option>
					<option value="HR" title="Haryana" <% if(strSecondAddressState.equals("HR")) {%>selected<% } %>>HR- Haryana</option>
					<option value="HP" title="Himachal Pradesh" <% if(strSecondAddressState.equals("HP")) {%>selected<% } %>>HP- Himachal Pradesh</option>
					<option value="JK" title="Jammu & Kashmir" <% if(strSecondAddressState.equals("JK")) {%>selected<% } %>>JK- Jammu & Kashmir</option>
					<option value="JH" title="Jharkhand" <% if(strSecondAddressState.equals("JH")) {%>selected<% } %>>JH- Jharkhand</option>
					<option value="KA" title="Karnataka" <% if(strSecondAddressState.equals("KA")) {%>selected<% } %>>KA- Karnataka</option>
					<option value="KL" title="Kerala" <% if(strSecondAddressState.equals("KL")) {%>selected<% } %>>KL- Kerala</option>
					<option value="LD" title="Lakshadweep" <% if(strSecondAddressState.equals("LD")) {%>selected<% } %>>LD- Lakshadweep</option>
					<option value="MP" title="Madhya Pradesh" <% if(strSecondAddressState.equals("MP")) {%>selected<% } %>>MP- Madhya Pradesh</option>
					<option value="MH" title="Maharashtra" <% if(strSecondAddressState.equals("MH")) {%>selected<% } %>>MH- Maharashtra</option>
					<option value="MN" title="Manipur" <% if(strSecondAddressState.equals("MN")) {%>selected<% } %>>MN- Manipur</option>
					<option value="ML" title="Meghalaya" <% if(strSecondAddressState.equals("ML")) {%>selected<% } %>>ML- Meghalaya</option>
					<option value="MZ" title="Mizoram" <% if(strSecondAddressState.equals("MZ")) {%>selected<% } %>>MZ- Mizoram</option>
					<option value="NL" title="Nagaland" <% if(strSecondAddressState.equals("NL")) {%>selected<% } %>>NL- Nagaland</option>
					<option value="OR" title="Orissa" <% if(strSecondAddressState.equals("OR")) {%>selected<% } %>>OR- Orissa</option>
					<option value="PY" title="Pondicherry" <% if(strSecondAddressState.equals("PY")) {%>selected<% } %>>PY- Pondicherry</option>
					<option value="PB" title="Punjab" <% if(strSecondAddressState.equals("PB")) {%>selected<% } %>>PB- Punjab</option>
					<option value="RJ" title="Rajasthan" <% if(strSecondAddressState.equals("RJ")) {%>selected<% } %>>RJ- Rajasthan</option>
					<option value="SK" title="Sikkim" <% if(strSecondAddressState.equals("SK")) {%>selected<% } %>>SK- Sikkim</option>
					<option value="TN" title="Tamil Nadu" <% if(strSecondAddressState.equals("TN")) {%>selected<% } %>>TN- Tamil Nadu</option>
					<option value="TR" title="Tripura" <% if(strSecondAddressState.equals("TR")) {%>selected<% } %>>TR- Tripura</option>
					<option value="UP" title="Uttar Pradesh" <% if(strSecondAddressState.equals("UP")) {%>selected<% } %>>UP- Uttar Pradesh</option>
					<option value="UA" title="Uttarakhand" <% if(strSecondAddressState.equals("UA")) {%>selected<% } %>>UA- Uttarakhand</option>
					<option value="WB" title="West Bengal" <% if(strSecondAddressState.equals("WB")) {%>selected<% } %>>WB- West Bengal</option>
					<option value="ZZ" title="Others" <% if(strSecondAddressState.equals("ZZ")) {%>selected<% } %>>ZZ- Others</option>
					<option value="XX" title="Not Applicable" <% if(strSecondAddressState.equals("XX")) {%>selected<% } %>>XX -Not Applicable</option>
				</select>
			</div>
			<div class="normalTextField">
				<label>29. Country Code</label></br>
				<%-- <input type="text" name="secAddressCountry" <%=readOnly%> value="<%=strSecondAddressCountry%>"/> --%>
				<select name="secAddressCountry" <%=readOnly%>>
					<option value="IN" title="India" <% if(strSecondAddressCountry.equals("IN")) {%>selected<% } %>>IN-India</option>		
					<option value="AF" title="Afghanistan" <% if(strSecondAddressCountry.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
					<option value="AX" title="Aland Islands" <% if(strSecondAddressCountry.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
					<option value="AL" title="Albania" <% if(strSecondAddressCountry.equals("AL")) {%>selected<% } %>>AL-Albania</option>
					<option value="DZ" title="Algeria" <% if(strSecondAddressCountry.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
					<option value="AS" title="American Samoa" <% if(strSecondAddressCountry.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
					<option value="AD" title="Andorra" <% if(strSecondAddressCountry.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
					<option value="AO" title="Angola" <% if(strSecondAddressCountry.equals("AO")) {%>selected<% } %>>AO-Angola</option>
					<option value="AI" title="Anguilla" <% if(strSecondAddressCountry.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
					<option value="AQ" title="Antarctica" <% if(strSecondAddressCountry.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
					<option value="AG" title="Antigua And Barbuda" <% if(strSecondAddressCountry.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
					<option value="AR" title="Argentina" <% if(strSecondAddressCountry.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
					<option value="AM" title="Armenia" <% if(strSecondAddressCountry.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
					<option value="AW" title="Aruba" <% if(strSecondAddressCountry.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
					<option value="AU" title="Australia" <% if(strSecondAddressCountry.equals("AU")) {%>selected<% } %>>AU-Australia</option>
					<option value="AT" title="Austria" <% if(strSecondAddressCountry.equals("AT")) {%>selected<% } %>>AT-Austria</option>
					<option value="AZ" title="Azerbaijan" <% if(strSecondAddressCountry.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
					<option value="BS" title="Bahamas" <% if(strSecondAddressCountry.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
					<option value="BH" title="Bahrain" <% if(strSecondAddressCountry.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
					<option value="BD" title="Bangladesh" <% if(strSecondAddressCountry.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
					<option value="BB" title="Barbados" <% if(strSecondAddressCountry.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
					<option value="BY" title="Belarus" <% if(strSecondAddressCountry.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
					<option value="BE" title="Belgium" <% if(strSecondAddressCountry.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
					<option value="BZ" title="Belize" <% if(strSecondAddressCountry.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
					<option value="BJ" title="Benin" <% if(strSecondAddressCountry.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
					<option value="BM" title="Bermuda" <% if(strSecondAddressCountry.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
					<option value="BT" title="Bhutan" <% if(strSecondAddressCountry.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
					<option value="BO" title="Bolivia" <% if(strSecondAddressCountry.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
					<option value="BA" title="Bosnia And Herzegovina" <% if(strSecondAddressCountry.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
					<option value="BW" title="Botswana" <% if(strSecondAddressCountry.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
					<option value="BV" title="Bouvet Island" <% if(strSecondAddressCountry.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
					<option value="BR" title="Brazil" <% if(strSecondAddressCountry.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
					<option value="IO" title="British Indian Ocean Territory" <% if(strSecondAddressCountry.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
					<option value="BN" title="Brunei Darussalam" <% if(strSecondAddressCountry.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
					<option value="BG" title="Bulgaria" <% if(strSecondAddressCountry.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
					<option value="BF" title="Burkina Faso" <% if(strSecondAddressCountry.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
					<option value="BI" title="Burundi" <% if(strSecondAddressCountry.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
					<option value="KH" title="Cambodia" <% if(strSecondAddressCountry.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
					<option value="CM" title="Cameroon" <% if(strSecondAddressCountry.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
					<option value="CA" title="Canada" <% if(strSecondAddressCountry.equals("CA")) {%>selected<% } %>>CA-Canada</option>
					<option value="CV" title="Cape Verde" <% if(strSecondAddressCountry.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
					<option value="KY" title="Cayman Islands" <% if(strSecondAddressCountry.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
					<option value="CF" title="Central African Republic" <% if(strSecondAddressCountry.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
					<option value="TD" title="Chad" <% if(strSecondAddressCountry.equals("TD")) {%>selected<% } %>>TD-Chad</option>
					<option value="CL" title="Chile" <% if(strSecondAddressCountry.equals("CL")) {%>selected<% } %>>CL-Chile</option>
					<option value="CN" title="China" <% if(strSecondAddressCountry.equals("CN")) {%>selected<% } %>>CN-China</option>
					<option value="CX" title="Christmas Island" <% if(strSecondAddressCountry.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
					<option value="CC" title="Cocos (Keeling) Islands" <% if(strSecondAddressCountry.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
					<option value="CO" title="Colombia" <% if(strSecondAddressCountry.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
					<option value="KM" title="Comoros" <% if(strSecondAddressCountry.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
					<option value="CG" title="Congo" <% if(strSecondAddressCountry.equals("CG")) {%>selected<% } %>>CG-Congo</option>
					<option value="CD" title="Congo,Democratic Republic" <% if(strSecondAddressCountry.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
					<option value="CK" title="Cook Islands" <% if(strSecondAddressCountry.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
					<option value="CR" title="Costa Rica" <% if(strSecondAddressCountry.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
					<option value="CI" title="Côte D'ivoire" <% if(strSecondAddressCountry.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
					<option value="HR" title="Croatia" <% if(strSecondAddressCountry.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
					<option value="CU" title="Cuba" <% if(strSecondAddressCountry.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
					<option value="CY" title="Cyprus" <% if(strSecondAddressCountry.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
					<option value="CZ" title="Czech Republic" <% if(strSecondAddressCountry.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
					<option value="DK" title="Denmark" <% if(strSecondAddressCountry.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
					<option value="DJ" title="Djibouti" <% if(strSecondAddressCountry.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
					<option value="DM" title="Dominica" <% if(strSecondAddressCountry.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
					<option value="DO" title="Dominican Republic" <% if(strSecondAddressCountry.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
					<option value="EC" title="Ecuador" <% if(strSecondAddressCountry.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
					<option value="EG" title="Egypt" <% if(strSecondAddressCountry.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
					<option value="SV" title="El Ssalvador" <% if(strSecondAddressCountry.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
					<option value="GQ" title="Equatorial Guinea" <% if(strSecondAddressCountry.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
					<option value="ER" title="Eritrea" <% if(strSecondAddressCountry.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
					<option value="EE" title="Estonia" <% if(strSecondAddressCountry.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
					<option value="ET" title="Ethiopia" <% if(strSecondAddressCountry.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
					<option value="FK" title="Falkland Islands (Malvinas)" <% if(strSecondAddressCountry.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
					<option value="FO" title="Faroe Islands" <% if(strSecondAddressCountry.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
					<option value="FJ" title="Fiji" <% if(strSecondAddressCountry.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
					<option value="FI" title="Finland" <% if(strSecondAddressCountry.equals("FI")) {%>selected<% } %>>FI-Finland</option>
					<option value="FR" title="France" <% if(strSecondAddressCountry.equals("FR")) {%>selected<% } %>>FR-France</option>
					<option value="GF" title="French Guiana" <% if(strSecondAddressCountry.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
					<option value="PF" title="French Polynesia" <% if(strSecondAddressCountry.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
					<option value="TF" title="French Southern Territories" <% if(strSecondAddressCountry.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
					<option value="GA" title="Gabon" <% if(strSecondAddressCountry.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
					<option value="GM" title="Gambia" <% if(strSecondAddressCountry.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
					<option value="GE" title="Georgia" <% if(strSecondAddressCountry.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
					<option value="DE" title="Germany" <% if(strSecondAddressCountry.equals("DE")) {%>selected<% } %>>DE-Germany</option>
					<option value="GH" title="Ghana" <% if(strSecondAddressCountry.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
					<option value="GI" title="Gibraltar" <% if(strSecondAddressCountry.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
					<option value="GR" title="Greece" <% if(strSecondAddressCountry.equals("GR")) {%>selected<% } %>>GR-Greece</option>
					<option value="GL" title="Greenland" <% if(strSecondAddressCountry.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
					<option value="GD" title="Grenada" <% if(strSecondAddressCountry.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
					<option value="GP" title="Guadeloupe" <% if(strSecondAddressCountry.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
					<option value="GU" title="Guam" <% if(strSecondAddressCountry.equals("GU")) {%>selected<% } %>>GU-Guam</option>
					<option value="GT" title="Guatemala" <% if(strSecondAddressCountry.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
					<option value="GG" title="Guernsey" <% if(strSecondAddressCountry.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
					<option value="GN" title="Guinea" <% if(strSecondAddressCountry.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
					<option value="GW" title="Guinea-Bisaau" title="Bissau" <% if(strSecondAddressCountry.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
					<option value="GY" title="Guyana" <% if(strSecondAddressCountry.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
					<option value="HT" title="Haiti" <% if(strSecondAddressCountry.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
					<option value="HM" title="Heard Island And Mcdonald Islands" <% if(strSecondAddressCountry.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
					<option value="VA" title="Vatican City State" <% if(strSecondAddressCountry.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
					<option value="HN" title="Honduras" <% if(strSecondAddressCountry.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
					<option value="HK" title="Hong Kong" <% if(strSecondAddressCountry.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
					<option value="HU" title="Hungary" <% if(strSecondAddressCountry.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
					<option value="IS" title="Iceland" <% if(strSecondAddressCountry.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
					<option value="ID" title="Indonesia" <% if(strSecondAddressCountry.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
					<option value="IR" title="Iran" <% if(strSecondAddressCountry.equals("IR")) {%>selected<% } %>>IR-Iran</option>
					<option value="IQ" title="Iraq" <% if(strSecondAddressCountry.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
					<option value="IE" title="Ireland" <% if(strSecondAddressCountry.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
					<option value="IM" title="Isle Of Man" <% if(strSecondAddressCountry.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
					<option value="IL" title="Israel" <% if(strSecondAddressCountry.equals("IL")) {%>selected<% } %>>IL-Israel</option>
					<option value="IT" title="Italy" <% if(strSecondAddressCountry.equals("IT")) {%>selected<% } %>>IT-Italy</option>
					<option value="JM" title="Jamaica" <% if(strSecondAddressCountry.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
					<option value="JP" title="Japan" <% if(strSecondAddressCountry.equals("JP")) {%>selected<% } %>>JP-Japan</option>
					<option value="JE" title="Jersey" <% if(strSecondAddressCountry.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
					<option value="JO" title="Jordan" <% if(strSecondAddressCountry.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
					<option value="KZ" title="Kazakhstan" <% if(strSecondAddressCountry.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
					<option value="KE" title="Kenya" <% if(strSecondAddressCountry.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
					<option value="KI" title="Kiribati" <% if(strSecondAddressCountry.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
					<option value="KP" title="Korea, Democratic People's Republic" <% if(strSecondAddressCountry.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
					<option value="KR" title="Korea" <% if(strSecondAddressCountry.equals("KR")) {%>selected<% } %>>KR-Korea</option>
					<option value="KW" title="Kuwait" <% if(strSecondAddressCountry.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
					<option value="KG" title="Kyrgyzstan" <% if(strSecondAddressCountry.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
					<option value="LA" title="Lao People's Democratic Republic" <% if(strSecondAddressCountry.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
					<option value="LV" title="Latvia" <% if(strSecondAddressCountry.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
					<option value="LB" title="Lebanon" <% if(strSecondAddressCountry.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
					<option value="LS" title="Lesotho" <% if(strSecondAddressCountry.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
					<option value="LR" title="Liberia" <% if(strSecondAddressCountry.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
					<option value="LY" title="Libyan Arab Jamahiriya" <% if(strSecondAddressCountry.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
					<option value="LI" title="Liechtenstein" <% if(strSecondAddressCountry.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
					<option value="LT" title="Lithuania" <% if(strSecondAddressCountry.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
					<option value="LU" title="Luxembourg" <% if(strSecondAddressCountry.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
					<option value="MO" title="Macao" <% if(strSecondAddressCountry.equals("MO")) {%>selected<% } %>>MO-Macao</option>
					<option value="MK" title="Macedonia, The Former Yugoslav Repub" <% if(strSecondAddressCountry.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
					<option value="MG" title="Madagascar" <% if(strSecondAddressCountry.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
					<option value="MW" title="Malawi" <% if(strSecondAddressCountry.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
					<option value="MY" title="Malaysia" <% if(strSecondAddressCountry.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
					<option value="MV" title="Maldives" <% if(strSecondAddressCountry.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
					<option value="ML" title="Mali" <% if(strSecondAddressCountry.equals("ML")) {%>selected<% } %>>ML-Mali</option>
					<option value="MT" title="Malta" <% if(strSecondAddressCountry.equals("MT")) {%>selected<% } %>>MT-Malta</option>
					<option value="MH" title="Marshall Islands" <% if(strSecondAddressCountry.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
					<option value="MQ" title="Martinique" <% if(strSecondAddressCountry.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
					<option value="MR" title="Mauritania" <% if(strSecondAddressCountry.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
					<option value="MU" title="Mauritius" <% if(strSecondAddressCountry.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
					<option value="YT" title="Mayotte" <% if(strSecondAddressCountry.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
					<option value="MX" title="Mexico" <% if(strSecondAddressCountry.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
					<option value="FM" title="Micronesia" <% if(strSecondAddressCountry.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
					<option value="MD" title="Moldova" <% if(strSecondAddressCountry.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
					<option value="MC" title="Monaco" <% if(strSecondAddressCountry.equals("MC")) {%>selected<% } %>>MC-Monaco</option>
					<option value="MN" title="Mongolia" <% if(strSecondAddressCountry.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
					<option value="ME" title="Montenegro" <% if(strSecondAddressCountry.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
					<option value="MS" title="Montserrat" <% if(strSecondAddressCountry.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
					<option value="MA" title="Morocco" <% if(strSecondAddressCountry.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
					<option value="MZ" title="Mozambique" <% if(strSecondAddressCountry.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
					<option value="MM" title="Myanmar" <% if(strSecondAddressCountry.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
					<option value="NA" title="Namibia" <% if(strSecondAddressCountry.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
					<option value="NR" title="Nauru" <% if(strSecondAddressCountry.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
					<option value="NP" title="Nepal" <% if(strSecondAddressCountry.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
					<option value="NL" title="Netherlands" <% if(strSecondAddressCountry.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
					<option value="AN" title="Netherlands Antilles" <% if(strSecondAddressCountry.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
					<option value="NC" title="New Caledonia" <% if(strSecondAddressCountry.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
					<option value="NZ" title="New Zealand" <% if(strSecondAddressCountry.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
					<option value="NI" title="Nicaragua" <% if(strSecondAddressCountry.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
					<option value="NE" title="Niger" <% if(strSecondAddressCountry.equals("NE")) {%>selected<% } %>>NE-Niger</option>
					<option value="NG" title="Nigeria" <% if(strSecondAddressCountry.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
					<option value="NU" title="Niue" <% if(strSecondAddressCountry.equals("NU")) {%>selected<% } %>>NU-Niue</option>
					<option value="NF" title="Norfolk Island" <% if(strSecondAddressCountry.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
					<option value="MP" title="Northern Mariana Islands" <% if(strSecondAddressCountry.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
					<option value="NO" title="Norway" <% if(strSecondAddressCountry.equals("NO")) {%>selected<% } %>>NO-Norway</option>
					<option value="OM" title="Oman" <% if(strSecondAddressCountry.equals("OM")) {%>selected<% } %>>OM-Oman</option>
					<option value="PK" title="Pakistan" <% if(strSecondAddressCountry.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
					<option value="PW" title="Palau" <% if(strSecondAddressCountry.equals("PW")) {%>selected<% } %>>PW-Palau</option>
					<option value="PS" title="Palestinian Territory, Occupied" <% if(strSecondAddressCountry.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
					<option value="PA" title="Panama" <% if(strSecondAddressCountry.equals("PA")) {%>selected<% } %>>PA-Panama</option>
					<option value="PG" title="Papua New Guinea" <% if(strSecondAddressCountry.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
					<option value="PY" title="Paraguay" <% if(strSecondAddressCountry.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
					<option value="PE" title="Peru" <% if(strSecondAddressCountry.equals("PE")) {%>selected<% } %>>PE-Peru</option>
					<option value="PH" title="Philippines" <% if(strSecondAddressCountry.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
					<option value="PN" title="Pitcairn" <% if(strSecondAddressCountry.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
					<option value="PL" title="Poland" <% if(strSecondAddressCountry.equals("PL")) {%>selected<% } %>>PL-Poland</option>
					<option value="PT" title="Portugal" <% if(strSecondAddressCountry.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
					<option value="PR" title="Puerto Rico" <% if(strSecondAddressCountry.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
					<option value="QA" title="Qatar" <% if(strSecondAddressCountry.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
					<option value="RE" title="Réunion" <% if(strSecondAddressCountry.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
					<option value="RO" title="Romania" <% if(strSecondAddressCountry.equals("RO")) {%>selected<% } %>>RO-Romania</option>
					<option value="RU" title="Russian Federation" <% if(strSecondAddressCountry.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
					<option value="RW" title="Rwanda" <% if(strSecondAddressCountry.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
					<option value="BL" title="Saint Barthélemy" <% if(strSecondAddressCountry.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
					<option value="SH" title="Saint Helena, Ascension And Tristan" <% if(strSecondAddressCountry.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
					<option value="KN" title="Saint Kitts And Nevis" <% if(strSecondAddressCountry.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
					<option value="LC" title="Saint Lucia" <% if(strSecondAddressCountry.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
					<option value="MF" title="Saint Martin" <% if(strSecondAddressCountry.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
					<option value="PM" title="Saint Pierre And Miquelon" <% if(strSecondAddressCountry.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
					<option value="VC" title="Saint Vincent And The Grenadines" <% if(strSecondAddressCountry.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
					<option value="WS" title="Samoa" <% if(strSecondAddressCountry.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
					<option value="SM" title="San Marino" <% if(strSecondAddressCountry.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
					<option value="ST" title="Sao Tome And Principe" <% if(strSecondAddressCountry.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
					<option value="SA" title="Saudi Arabia" <% if(strSecondAddressCountry.equals("SA")) {%>selected<% } %>>SA-Saudi Arabia</option>
					<option value="SN" title="Senegal" <% if(strSecondAddressCountry.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
					<option value="RS" title="Serbia" <% if(strSecondAddressCountry.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
					<option value="SC" title="Seychelles" <% if(strSecondAddressCountry.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
					<option value="SL" title="Sierra Leone" <% if(strSecondAddressCountry.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
					<option value="SG" title="Singapore" <% if(strSecondAddressCountry.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
					<option value="SK" title="Slovakia" <% if(strSecondAddressCountry.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
					<option value="SI" title="Slovenia" <% if(strSecondAddressCountry.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
					<option value="SB" title="Solomon Islands" <% if(strSecondAddressCountry.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
					<option value="SO" title="Somalia" <% if(strSecondAddressCountry.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
					<option value="ZA" title="South Africa" <% if(strSecondAddressCountry.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
					<option value="GS" title="South Georgia And The South Sandwich" <% if(strSecondAddressCountry.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
					<option value="ES" title="Spain" <% if(strSecondAddressCountry.equals("ES")) {%>selected<% } %>>ES-Spain</option>
					<option value="LK" title="Sri Lanka" <% if(strSecondAddressCountry.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
					<option value="SD" title="Sudan" <% if(strSecondAddressCountry.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
					<option value="SR" title="Suriname" <% if(strSecondAddressCountry.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
					<option value="SJ" title="Svalbard And Jan Mayen" <% if(strSecondAddressCountry.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
					<option value="SZ" title="Swaziland" <% if(strSecondAddressCountry.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
					<option value="SE" title="Sweden" <% if(strSecondAddressCountry.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
					<option value="CH" title="Switzerland" <% if(strSecondAddressCountry.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
					<option value="SY" title="Syrian Arab Republic" <% if(strSecondAddressCountry.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
					<option value="TW" title="Taiwan, Province Of China" <% if(strSecondAddressCountry.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
					<option value="TJ" title="Tajikistan" <% if(strSecondAddressCountry.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
					<option value="TZ" title="Tanzania" <% if(strSecondAddressCountry.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
					<option value="TH" title="Thailand" <% if(strSecondAddressCountry.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
					<option value="TL" title="Timor" title="Leste" <% if(strSecondAddressCountry.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
					<option value="TG" title="Togo" <% if(strSecondAddressCountry.equals("TG")) {%>selected<% } %>>TG-Togo</option>
					<option value="TK" title="Tokelau" <% if(strSecondAddressCountry.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
					<option value="TO" title="Tonga" <% if(strSecondAddressCountry.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
					<option value="TT" title="Trinidad And Tobago" <% if(strSecondAddressCountry.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
					<option value="TN" title="Tunisia" <% if(strSecondAddressCountry.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
					<option value="TR" title="Turkey" <% if(strSecondAddressCountry.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
					<option value="TM" title="Turkmenistan" <% if(strSecondAddressCountry.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
					<option value="TC" title="Turks And Caicos Islands" <% if(strSecondAddressCountry.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
					<option value="TV" title="Tuvalu" <% if(strSecondAddressCountry.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
					<option value="UG" title="Uganda" <% if(strSecondAddressCountry.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
					<option value="UA" title="Ukraine" <% if(strSecondAddressCountry.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
					<option value="AE" title="United Arab Emirates" <% if(strSecondAddressCountry.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
					<option value="GB" title="United Kingdom" <% if(strSecondAddressCountry.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
					<option value="US" title="United States" <% if(strSecondAddressCountry.equals("US")) {%>selected<% } %>>US-United States</option>
					<option value="UM" title="United States Minor Outlying Islands" <% if(strSecondAddressCountry.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
					<option value="UY" title="Uruguay" <% if(strSecondAddressCountry.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
					<option value="UZ" title="Uzbekistan" <% if(strSecondAddressCountry.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
					<option value="VU" title="Vanuatu" <% if(strSecondAddressCountry.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
					<option value="VE" title="Venezuela" <% if(strSecondAddressCountry.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
					<option value="VN" title="Viet Nam" <% if(strSecondAddressCountry.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
					<option value="VG" title="Virgin Islands, British" <% if(strSecondAddressCountry.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
					<option value="VI" title="Virgin Islands, U.S." <% if(strSecondAddressCountry.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
					<option value="WF" title="Wallis And Futuna" <% if(strSecondAddressCountry.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
					<option value="EH" title="Western Sahara" <% if(strSecondAddressCountry.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
					<option value="YE" title="Yemen" <% if(strSecondAddressCountry.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
					<option value="ZM" title="Zambia" <% if(strSecondAddressCountry.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
					<option value="ZW" title="Zimbabwe" <% if(strSecondAddressCountry.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
					<option value="SS" title="South Sudan" <% if(strSecondAddressCountry.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
					<option value="CW" title="Curacao" <% if(strSecondAddressCountry.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
					<option value="BQ" title="Bonaire, Sint Eustatius and Saba" <% if(strSecondAddressCountry.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
					<option value="SX" title="Sint Marteen" <% if(strSecondAddressCountry.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
					<option value="XX" title="Not available " <% if(strSecondAddressCountry.equals("XX")) {%>selected<% } %>>XX-Not available </option>
					<option value="ZZ" title="Others" <% if(strSecondAddressCountry.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
				</select>
			</div>
			<div class="normalTextField">
				<label>30. PIN Code</label><br/>
				<input type="text" name="secAddressPinCode" <%=readOnly%> value="<%=strSecondAddressPinCode%>"/>
			</div>
			<div class="normalTextField">
				<label>31. Telephone (with STD Code)</label></br>
				<input type="text" <%=readOnly%> name="secAddressTelephoneNo" value=""/>
			</div>
   		<div class="mainButtons" style="padding-top : 15%;">
				<%-- <input type="submit" value="Save" <%=disabled%> /> --%>
				<input type="button" class="diffButton" value="Save" <%=disabled%> onClick="validate(this.form);" />
				<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div>
    </div>
	</form>
	</div>
	</body>
</html>
<%}catch(Exception e){}%>