<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
 try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRIndividualDetailsVO objIndividualDetailsVO = (ISTRIndividualDetailsVO)request.getAttribute("AnnexA_IndividualDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnANo");

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
	String strPlaceOfIssue 	= "";
	String strPanIdNo 		= "";
	String strUINNo			= "";
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
	if(objIndividualDetailsVO!=null){
		strBranchName 		 = (objIndividualDetailsVO.getNameOfBank() == null) ? "" : objIndividualDetailsVO.getNameOfBank();
		strBranchBSRCode 	 = (objIndividualDetailsVO.getBSRCode() == null) ? "" : objIndividualDetailsVO.getBSRCode();
		strEnclosedAnnexture = (objIndividualDetailsVO.getAnnexEnclosed() == null) ? "" : objIndividualDetailsVO.getAnnexEnclosed();
		strRelationFlag = strEnclosedAnnexture;
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
		strUINNo				= (objIndividualDetailsVO.getUinNo() == null) ? "" : objIndividualDetailsVO.getUinNo();
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

<div class="section">
	<div class="normalTextField">
		<label>1. Name of Reporting Entity</label>
		<input type="text" name="nameOfReportingEntity" readonly value="<%=strBranchName%>" />
	</div>
	<div class="normalTextField">
		<label>2. Individual's Name</label>
		<input type="text" name="individualName" readonly value="<%=strCustomerFullName%>" />
	</div>
	<div class="normalTextField">
		<label>3. Customer ID</label><br/>
		<input type="text" name="customerID" class="medium" readonly value="<%=strCustomerId%>" />
	</div>
	<div class="normalTextField">
	    <label>3.1 Account No</label><br/>
		<input type="text" name="accountNo" class="medium" readonly value="<%=strAccountNo%>" />
	</div>
	<div class="normalTextField">
		<label>4. Relation Flag</label><br/>
		<select	name="relationFlag" class="medium" disabled>
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
		<label>5. Father/Spouse Name</label>
		<input type="text" name="fatherSpouseName" readonly value="<%=strFatherName%>" />
	</div>
	<div class="normalTextField">
		<label>6. Occupation</label>
		<input type="text" name="occupation" readonly value="<%=strOccupationDescription%>" />
	</div>
	<div class="normalTextField">
		<label>7. Date of Birth</label>
		<input type="text" name="dateOfBirth" readonly value="<%=strDateOfBirth%>" />
	</div>
	<div class="normalTextField left">
		<label>8. Gender</label>
		<select	name="gender" disabled>
			<option value="M" <% if(strSexOfIndividual.equals("M")) {%>selected<% } %>>M - Male</option>
			<option value="F" <% if(strSexOfIndividual.equals("F")) {%>selected<% } %>>F - Female</option>
			<option value="X" <% if(strSexOfIndividual.equals("X")) {%>selected<% } %>>X - Not Categorised</option>	
		</select>
	</div>
	<div class="normalTextField right">
		<label>9. Nationality</label>
		<input type="text" name="nationality"  readonly value="<%=strNationality%>" />
	</div>
	<div class="normalTextField left">
		<label>10. ID Type</label>
		<select	name="IDType" disabled>
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
	<div class="normalTextField right">
		<label>11. ID Number</label>
		<input type="text" name="IDNumber" readonly value="<%=strIdentificationNumber%>" />
	</div>
	<div class="normalTextField left">
		<label>12. ID Issuing Authority</label>
		<input type="text" name="IDIssuingAuthority" readonly value="<%=strIssuingAuthority%>" />
	</div>
	<div class="normalTextField right">
		<label>13. ID Issuing Place</label>
		<input type="text" name="IDIssuingPlace" readonly value="<%=strPlaceOfIssue%>" />
	</div>
	<div class="normalTextField left">
		<label>14. PAN</label>
		<input type="text" name="pan" readonly value="<%=strPanIdNo%>" />
	</div>
	<div class="normalTextField right">
		<label>15. UIN</label>
		<input type="text" name="uin" readonly value="<%=strUINNo%>" />
	</div>
	
	
	<div class="normalTextField">
		<label>16. Place of Work</label>
		<input type="text" name="placeOfWork" readonly value="<%=strEmployerNameOfIndividual%>" />
	</div>
	<div class="normalTextField">
		<label>17. Communication Address</label>
		<textarea name="communicationAddress" readonly><%=strFullAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>18. City</label><br/>
		<input type="text" name="city" class="medium" readonly value="<%=strAddressCity%>"/>
	</div>
	<div class="normalTextField left">
		<label>19. State Code</label>
		<input type="text" name="stateCode" readonly value="<%=strAddressState%>"/>
	</div>
	<div class="normalTextField right">
		<label>20. Country Code</label>
		<input type="text" name="countryCode" readonly value="<%=strAddressCountry%>" />
	</div>
	
	
	<div class="normalTextField left">
		<label>21. PIN Code</label>
		<input type="text" name="pinCode" readonly value="<%=strAddressPinCode%>" />
	</div>
	<div class="normalTextField right">
		<label>22. Telephone</label>
		<input type="text" name="telephone" readonly value="<%=strAddressTelNo%>" />
	</div>
	<div class="normalTextField left">
		<label>23. Mobile</label>
		<input type="text" name="mobile" readonly value="<%=strAddressBranchMobileNo%>" />
	</div>
	<div class="normalTextField right">
		<label>24. FAX</label>
		<input type="text" name="stateCode" readonly value="<%=strAddressFaxNo%>" />
	</div>
	<div class="normalTextField">
		<label>25. E-mail Address</label>
		<input type="text" name="countryCode" readonly value="<%=strAddressBranchEmailId%>" />
	</div>
	
	
	<div class="normalTextField">
		<label>26. Second Address(Permanent Address / Place of Work)</label>
		<textarea name="placeOfWork" readonly><%=strSecondFullAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>27. City</label><br/>
		<input type="text" name="city" class="medium" readonly value="<%=strSecondAddressCity%>"/>
	</div>
	<div class="normalTextField left">
		<label>28. State Code</label>
		<input type="text" name="stateCode" readonly value="<%=strSecondAddressState%>"/>
	</div>
	<div class="normalTextField right">
		<label>29. Country Code</label>
		<input type="text" name="countryCode" readonly value="<%=strSecondAddressCountry%>"/>
	</div>
	<div class="normalTextField">
		<label>30. PIN Code</label><br/>
		<input type="text" name="pinCode" class="medium" readonly value="<%=strSecondAddressPinCode%>"/>
	</div>
</div>

<%}catch(Exception e){}%>