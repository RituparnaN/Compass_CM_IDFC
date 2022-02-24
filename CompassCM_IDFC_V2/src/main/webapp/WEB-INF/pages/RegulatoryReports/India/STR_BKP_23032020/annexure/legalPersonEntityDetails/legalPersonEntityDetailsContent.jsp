<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTREntityDetailsVO objEntityDetailsVO = (ISTREntityDetailsVO)request.getAttribute("AnnexB_LegalDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnBNo");

	String strBankBranchName 	= "";
	String strBranchBSRCode 	= "";
	String strEnclosedAnnexture = "";
	String strNameOfEntity 	    = "";
	String strCustomerId 		= "";
	String strAccountNo 		= "";
	String strNatureOfBusiness 	= "";
	String strDateOfIncorporation 	= "";
	String strTypeOfConstitution 	= "";
	String strRegistrarionNumber 	= "";
	String strRegisteringAuthority 	= "";
	String strPlaceOfRegistration 	= "";
	String strPanIdNo 				= "";
	String strUinNo 				= "";
	String strAddressBuildingNo 	= "";
	String strAddressStreet 		= "";
	String strAddressLocality 		= "";
	String strAddressCity 			= "";
	String strAddressState 			= "";
	String strAddressCountry		= "";
	String strAddressPinCode 		= "";
	String strAddressTelephoneNo 	= "";
	String strAddressFaxNo 			= "";
	String strAddressMobileNo 	    = "";
	String strAddressBranchEmailId 	= "";
    /*
	String strCommAddressBuildingNo 	= "";
	String strCommAddressStreet 		= "";
	String strCommAddressLocality 		= "";
	String strCommAddressState 			= "";
	String strCommAddressCountry		= "";
	String strCommAddressPinCode 		= "";
	String strCommAddressTelephoneNo 	= "";
	*/
	String[] strDirectorsPersonsNameArray 		= new String[25];
	String[] strDirectorsPersonsIdArray 		= new String[25];
	String[] strDirectorsPersonsRelationArray 	= new String[25];
	String[] strDirectorsAnnextureABArray 		= new String[25];
	String[] strDirectorsAnnexNoArray 		    = new String[25];
	String[] strDirectorsAnnexFlagArray 		= new String[25];
	String strRelationFlag = "A";
	if(objEntityDetailsVO != null){
		strBankBranchName = (objEntityDetailsVO.getNameOfBank() ==	null) ? "" : objEntityDetailsVO.getNameOfBank();
		strBranchBSRCode 			= (objEntityDetailsVO.getBSRCode() ==	null) ? "" : objEntityDetailsVO.getBSRCode();
		strEnclosedAnnexture = (objEntityDetailsVO.getAnnexEnclosed() ==	null) ? "" : objEntityDetailsVO.getAnnexEnclosed();
		strNameOfEntity 	= (objEntityDetailsVO.getNameOfLegalPerson() ==	null) ? "" : objEntityDetailsVO.getNameOfLegalPerson();
		strCustomerId 		= (objEntityDetailsVO.getCustomerID() ==	null) ? "" : objEntityDetailsVO.getCustomerID();
		strAccountNo 		= (objEntityDetailsVO.getAccountNo() ==	null) ? "" : objEntityDetailsVO.getAccountNo();
		strNatureOfBusiness 	= (objEntityDetailsVO.getNatureOfBusiness() ==	null) ? "" : objEntityDetailsVO.getNatureOfBusiness();
		strDateOfIncorporation 	= (objEntityDetailsVO.getIncorporationDate() ==	null) ? "" : objEntityDetailsVO.getIncorporationDate();
		if(strDateOfIncorporation.length() >= 10)
			strDateOfIncorporation = strDateOfIncorporation.substring(0,10);
		strTypeOfConstitution 	= (objEntityDetailsVO.getConstitutionType() ==	null) ? "" : objEntityDetailsVO.getConstitutionType();
		strRegistrarionNumber = (objEntityDetailsVO.getRegistrarionNumber() ==	null) ? "" : objEntityDetailsVO.getRegistrarionNumber();
		strRegisteringAuthority 	= (objEntityDetailsVO.getRegisteringAuth() ==	null) ? "" : objEntityDetailsVO.getRegisteringAuth();
		strPlaceOfRegistration 	= (objEntityDetailsVO.getRegisteringPlace() ==	null) ? "" : objEntityDetailsVO.getRegisteringPlace();
		strPanIdNo 				= (objEntityDetailsVO.getPanNo() ==	null) ? "" : objEntityDetailsVO.getPanNo();
		strUinNo 				= (objEntityDetailsVO.getUinNO() ==	null) ? "" : objEntityDetailsVO.getUinNO();
		strAddressBuildingNo 	= (objEntityDetailsVO.getAddBuildingNo() ==	null) ? "" : objEntityDetailsVO.getAddBuildingNo();
		strAddressStreet 		= (objEntityDetailsVO.getAddStreet() ==	null) ? "" : objEntityDetailsVO.getAddStreet();
		strAddressLocality 		= (objEntityDetailsVO.getAddLocality() == null) ? "" : objEntityDetailsVO.getAddLocality();
		strAddressCity 			= (objEntityDetailsVO.getAddCity() ==	null) ? "" : objEntityDetailsVO.getAddCity();
		strAddressState 		= (objEntityDetailsVO.getAddState() ==	null) ? "" : objEntityDetailsVO.getAddState();
		strAddressCountry       = (objEntityDetailsVO.getAddCountry() ==	null) ? "" : objEntityDetailsVO.getAddCountry();
		strAddressPinCode 		= (objEntityDetailsVO.getAddPinCode() ==	null) ? "" : objEntityDetailsVO.getAddPinCode();
		strAddressTelephoneNo 		= (objEntityDetailsVO.getAddTelNo() ==	null) ? "" : objEntityDetailsVO.getAddTelNo();
		strAddressFaxNo 			= (objEntityDetailsVO.getAddFaxNo() ==	null) ? "" : objEntityDetailsVO.getAddFaxNo();
		strAddressMobileNo          = (objEntityDetailsVO.getAddMobilNo() ==	null) ? "" : objEntityDetailsVO.getAddMobilNo();
		strAddressBranchEmailId 	= (objEntityDetailsVO.getAddEmail() ==	null) ? "" : objEntityDetailsVO.getAddEmail();
		strDirectorsPersonsNameArray 	= objEntityDetailsVO.getListofDirectorsPersonsName();
		strDirectorsPersonsIdArray 		= objEntityDetailsVO.getListofDirectorsPersonsID();
		strDirectorsPersonsRelationArray = objEntityDetailsVO.getListofDirectorsPersonsRelation();
		strDirectorsAnnextureABArray = objEntityDetailsVO.getListofDirectorsAnnexAB();
		strDirectorsAnnexNoArray 	 = objEntityDetailsVO.getListofDirectorsAnnexNumber();
		strDirectorsAnnexFlagArray 	 = objEntityDetailsVO.getListofDirectorsAnnexFlag();
	}
	

	String strFullAddress = strAddressBuildingNo;
	if(!strAddressStreet.trim().equals(""))
		strFullAddress = strFullAddress +", "+strAddressStreet;
	if(!strAddressLocality.trim().equals(""))
		strFullAddress = strFullAddress +", "+strAddressLocality;
%>
<div class="section">
	<div class="normalTextField">
		<label>1. Name of Reporting Entity</label>
		<input type="text" name="nameOfReportingEntity" readonly value="<%=strBankBranchName%>"/>
	</div>
	<div class="normalTextField">
		<label>2. Legal Person / Entity Name</label>
		<input type="text" name="legalPersonEntityName" readonly value="<%=strNameOfEntity%>"/>
	</div>
	<div class="normalTextField">
		<label>3. Customer ID</label><br />
		<input type="text" name="customerID" class="medium" readonly value="<%=strCustomerId%>"/>
	</div>
	<div class="normalTextField">
		<label>3.1 Account No</label><br />
		<input type="text" name="accountNo" class="medium" readonly value="<%=strAccountNo%>"/>
	</div>
	<div class="normalTextField">
		<label>4. Relation Flag</label><br />
		<select name="relationFlag"	class="medium" disabled>
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
		<label>5. Nature of Business</label>
		<input type="text" name="businessNature" readonly value="<%=strNatureOfBusiness%>"/>
	</div>
	<div class="normalTextField">
		<label>6. Date of Incorporation</label><br/>
		<input type="text" name="dateOfIncorporation" class="medium" readonly value="<%=strDateOfIncorporation%>"/>
	</div>
	<div class="normalTextField">
		<label>7. Constitution Type</label><br/>
		<select name="relationFlag"	class="medium" disabled>
			<option value="A" <% if(strTypeOfConstitution.equals("A")) {%>selected<% } %>>A - Sole Proprietorship</option>
			<option value="B" <% if(strTypeOfConstitution.equals("B")) {%>selected<% } %>>B - Partnership Firm</option>
			<option value="C" <% if(strTypeOfConstitution.equals("C")) {%>selected<% } %>>C - HUF</option>	
			<option value="D" <% if(strTypeOfConstitution.equals("D")) {%>selected<% } %>>D - Private Limited Company</option>
			<option value="E" <% if(strTypeOfConstitution.equals("E")) {%>selected<% } %>>E - Public Limited Company</option>
			<option value="F" <% if(strTypeOfConstitution.equals("F")) {%>selected<% } %>>F - Society</option>
			<option value="G" <% if(strTypeOfConstitution.equals("G")) {%>selected<% } %>>G - Association</option>	
			<option value="H" <% if(strTypeOfConstitution.equals("H")) {%>selected<% } %>>H - Trust</option>
			<option value="I" <% if(strTypeOfConstitution.equals("I")) {%>selected<% } %>>I - Liquidator</option>
			<option value="J" <% if(strTypeOfConstitution.equals("J")) {%>selected<% } %>>J - LLP</option>
			<option value="X" <% if(strTypeOfConstitution.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
			<option value="Z" <% if(strTypeOfConstitution.equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>8. Registration Number</label><br/>
		<input type="text" name="registrationNumber" class="medium" readonly value="<%=strRegistrarionNumber%>"/>
	</div>
	<div class="normalTextField">
		<label>9. Place of Registration</label>
		<input type="text" name="registrationPlace" readonly value="" />
	</div>
	<div class="normalTextField">
		<label>10. Country of Registration</label><br/>
		<input type="text" name="registrationCountry" class="medium" readonly value="<%=strPlaceOfRegistration%>"/>
<!--<%=strRegisteringAuthority%>-->
	</div>
	<div class="normalTextField left">
		<label>11. PAN</label>
		<input type="text" name="pan" readonly value="<%=strPanIdNo%>"/>
	</div>
	<div class="normalTextField right">
		<label>12. UIN</label>
		<input type="text" name="uin" readonly value="<%=strUinNo%>"/>
	</div>
	<div class="normalTextField">
		<label>13. Address</label>
		<textarea name="address" readonly><%=strFullAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>14. City</label>
		<input type="text" name="city" readonly value="<%=strAddressCity%>"/>
	</div>
	<div class="normalTextField left">
		<label>15. State Code</label>
		<input type="text" name="stateCode" readonly value="<%=strAddressState%>"/>
	</div>
	<div class="normalTextField right">
		<label>16. Country Code</label>
		<input type="text" name="countryCode" readonly value="<%=strAddressCountry%>"/>
	</div>
	<div class="normalTextField left">
		<label>17. PIN Code</label>
		<input type="text" name="pinCode" readonly value="<%=strAddressPinCode%>"/>
	</div>
	<div class="normalTextField right">
		<label>18. Telephone</label>
		<input type="text" name="telephone" readonly value="<%=strAddressTelephoneNo%>"/>
	</div>
	<div class="normalTextField left">
		<label>19. Mobile</label>
		<input type="text" name="mobile" readonly value="<%=strAddressMobileNo%>"/>
	</div>
	<div class="normalTextField right">
		<label>20. FAX</label>
		<input type="text" name="stateCode" readonly value="<%=strAddressFaxNo%>"/>
	</div>
	<div class="normalTextField">
		<label>21. E-mail Address</label>
		<input type="text" name="countryCode" readonly value="<%=strAddressBranchEmailId%>"/>
	</div>
	
	<div class="normalTextField">
		<label>22. List of directors / partners / members / and other related persons</label>
		<table class="info-table">
			<tr>
				<th width="10%">&nbsp;</th>
				<th width="90%">Name Of Individual / Legal Person / Entity</th>
			</tr>
            <% for(int i=0; i<5; i++){ %>
			<tr>
				<th>22.<%= i+1 %></th>
				<td>
					<input type="text" name="nameOfIndvLegalEntityRP1" readonly value="<%= (strDirectorsPersonsNameArray[i] == null) ? "" : strDirectorsPersonsNameArray[i]  %>"/>
				</td>
			</tr>
			<% } %>
           <!--
			<tr>
				<th>22.2</th>
				<td>
					<input type="text" name="nameOfIndvLegalEntityRP1" />
				</td>
			</tr>
			<tr>
				<th>22.3</th>
				<td>
					<input type="text" name="nameOfIndvLegalEntityRP1" />
				</td>
			</tr>
			<tr>
				<th>22.4</th>
				<td>
					<input type="text" name="nameOfIndvLegalEntityRP1" />
				</td>
			</tr>
			<tr>
				<th>22.5</th>
				<td>
					<input type="text" name="nameOfIndvLegalEntityRP1" />
				</td>
			</tr>
			-->
		</table>
	</div>
</div>
<%
}catch(Exception e){e.printStackTrace();}
	
%>
