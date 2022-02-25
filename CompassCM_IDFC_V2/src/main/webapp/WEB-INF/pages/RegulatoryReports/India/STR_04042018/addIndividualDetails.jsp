<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
 try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	HttpSession l_CHttpSession = request.getSession(true);
	String l_strAlertNo = request.getParameter("l_strAlertNo") == null?(String)l_CHttpSession.getAttribute("alertNo"):request.getParameter("l_strAlertNo").toString();
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}

	HashMap hmNewIndividualDetails = null;
	ISTRIndividualDetailsVO objIndividualDetailsVO = null;
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
		objIndividualDetailsVO =  (ISTRIndividualDetailsVO)hmNewIndividualDetails.get("ALIndvDetailsDTO");
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
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<%
	String IsSaved = (String) request.getAttribute("IsSaved");
	if(IsSaved!=null && IsSaved.equalsIgnoreCase("Yes")){
%>
	<script>
	//opener.document.form1.Type.value='showBlankIndianSTR';
	//opener.document.form1.alertno.value='<%=l_strAlertNo%>';
	//opener.document.form1.submit();
	//window.opener.location.reload();
	alert('Party has been added to the individual list');
	var l_strAlertNo = '<%=l_strAlertNo%>';
	// window.opener.location.reload();
	window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRReport?l_strAlertNo="+l_strAlertNo+"&canUpdated=Y&canExported=N");
	window.close();
    </script>
<%}%>
<body>
<div class="content">
<form name="NewIndividualDetails" action="<%=contextPath%>/common/saveNewINDSTRIndividuals?${_csrf.parameterName}=${_csrf.token}" method="post">
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
			
			<div class="normalTextField">
				<label>1. Name of Reporting Entity</label>
				<input type="text" name="repBranchName" <%=readOnly%> value="<%=strBranchName%>" />
			</div>
			<div class="normalTextField">
				<label>2. Individual's Name</label>
				<input type="text" name="customerFullName" <%=readOnly%> value="<%=strCustomerFullName%>" />
			</div>
			<div class="normalTextField">
				<label>3. Customer ID</label><br/>
				<input type="text" name="customerId" <%=readOnly%> value="<%=strCustomerId%>" />
			</div>
			<div class="normalTextField">
				<label>3.1 Account No</label><br/>
				<input type="text" name="accountNo" <%=readOnly%> value="<%=strAccountNo%>" />
			</div>
			
			
			<div class="normalTextField">
				<label>4. Relation Flag</label><br/>
				<select	name="individualRelationFlag" <%=disabled%>>
					<option value="A" <% if(strRelationFlag.equals("A")) {%>selected<% } %>>A - Account Holder</option>
					<option value="B" <% if(strRelationFlag.equals("B")) {%>selected<% } %>>B - Authorized Signatory</option>
					<option value="C" <% if(strRelationFlag.equals("C")) {%>selected<% } %>>C - Proprietor/Director/Partner/Legal Member</option>	
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
				<label>10. ID Type</label></br>
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
				<label>11. ID Number</label></br>
				<input type="text" name="identificationNumber" <%=readOnly%> value="<%=strIdentificationNumber%>" />
			</div>
			<div class="normalTextField">
				<label>12. ID Issuing Authority</label></br>
				<input type="text" name="issuingAuthority" <%=readOnly%> value="<%=strIssuingAuthority%>" />
			</div>
			<div class="normalTextField">
				<label>13. ID Issuing Place</label></br>
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
				<input type="text" name="commAddressState" <%=readOnly%> value="<%=strAddressState%>"/>
			</div>
			<div class="normalTextField">
				<label>20. Country Code</label></br>
				<input type="text" name="commAddressCountry" <%=readOnly%> value="<%=strAddressCountry%>" />
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
				<input type="text" name="secAddressState" <%=readOnly%> value="<%=strSecondAddressState%>"/>
			</div>
			<div class="normalTextField">
				<label>29. Country Code</label></br>
				<input type="text" name="secAddressCountry" <%=readOnly%> value="<%=strSecondAddressCountry%>"/>
			</div>
			<div class="normalTextField">
				<label>30. PIN Code</label><br/>
				<input type="text" name="secAddressPinCode" <%=readOnly%> value="<%=strSecondAddressPinCode%>"/>
			</div>
			<div class="normalTextField">
				<label>31. Tel (with STD Code)</label></br>
				<input type="text" <%=readOnly%> name="secAddressTelephoneNo" value=""/>
			</div>
   		<div class="mainButtons" style="padding-top : 15%;">
				<input type="submit" value="Save" <%=disabled%> />
				<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
		</div>
    </div>
	</form>
	</div>
	</body>
</html>
<%}catch(Exception e){}%>