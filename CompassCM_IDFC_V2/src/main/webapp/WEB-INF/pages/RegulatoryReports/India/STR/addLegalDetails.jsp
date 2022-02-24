<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	HttpSession l_CHttpSession = request.getSession(true);
	String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String readOnly = "disabled";
	String disabled = "readonly";
	if(canUpdated.equals("Y")){
		readOnly = "";
		disabled = "";
	}
	
	HashMap hmEntityDetails = null;
	ISTREntityDetailsVO objEntityDetailsVO = null;
	String l_strLegalAccountNo="";
	String l_strRefType = "";
	String l_strSecPinCode = "";
	String l_strPAN = "";
	String l_strDOI = "";
	String l_strConstitutionType = "";

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
	String strSecondAddressBuildingNo  = "";
	String strSecondAddressStreet      = "";
	String strSecondAddressLocality    = "";
	String strSecondAddressCity        = "";
	String strSecondAddressState       = "";
	String strSecondAddressCountry     = "";
	String strSecondAddressPinCode     = "";
	String strSecondAddressTelephoneNo = "";
	String strSecondAddressFaxNo       = "";
	String strRelationFlag = "A";
	
	if((HashMap)request.getAttribute("HmDto")!=null)
		hmEntityDetails = (HashMap)request.getAttribute("HmDto");
	if(hmEntityDetails!=null)
	{
		objEntityDetailsVO = (ISTREntityDetailsVO)hmEntityDetails.get("LegalEntDetailsDTO");
		l_strLegalAccountNo = (String)hmEntityDetails.get("LegalAccountNo");
		l_strRefType = (String)hmEntityDetails.get("LegalRefType");
	}

	if(objEntityDetailsVO != null){
		strBankBranchName = (objEntityDetailsVO.getNameOfBank() ==	null) ? "" : objEntityDetailsVO.getNameOfBank();
		strBranchBSRCode 			= (objEntityDetailsVO.getBSRCode() ==	null) ? "" : objEntityDetailsVO.getBSRCode();
		strEnclosedAnnexture = (objEntityDetailsVO.getAnnexEnclosed() ==	null) ? "" : objEntityDetailsVO.getAnnexEnclosed();
		strNameOfEntity 	= (objEntityDetailsVO.getNameOfLegalPerson() ==	null) ? "" : objEntityDetailsVO.getNameOfLegalPerson();
		strCustomerId 		= (objEntityDetailsVO.getCustomerID() ==	null) ? "" : objEntityDetailsVO.getCustomerID();
		strAccountNo 		= (objEntityDetailsVO.getAccountNo() ==	null) ? "" : objEntityDetailsVO.getAccountNo();
		strRelationFlag 		= (objEntityDetailsVO.getLegalRelationFlag() ==	null) ? "A" : objEntityDetailsVO.getLegalRelationFlag();
		strNatureOfBusiness 	= (objEntityDetailsVO.getNatureOfBusiness() ==	null) ? "" : objEntityDetailsVO.getNatureOfBusiness();
		strDateOfIncorporation 	= (objEntityDetailsVO.getIncorporationDate() ==	null) ? "" : objEntityDetailsVO.getIncorporationDate();
		if(strDateOfIncorporation.length() >= 10)
			strDateOfIncorporation = strDateOfIncorporation.substring(0,10);
		strTypeOfConstitution 	= (objEntityDetailsVO.getConstitutionType() ==	null) ? "" : objEntityDetailsVO.getConstitutionType();
		strRegistrarionNumber = (objEntityDetailsVO.getRegistrarionNumber() ==	null) ? "" : objEntityDetailsVO.getRegistrarionNumber();
		strRegisteringAuthority 	= (objEntityDetailsVO.getRegisteringAuth() ==	null) ? "" : objEntityDetailsVO.getRegisteringAuth();
		strPlaceOfRegistration 	= (objEntityDetailsVO.getRegisteringPlace() ==	null) ? "" : objEntityDetailsVO.getRegisteringPlace();
		strPanIdNo 				= (objEntityDetailsVO.getPanNo() ==	null) ? "" : objEntityDetailsVO.getPanNo();
		strUinNo				= (objEntityDetailsVO.getUinNO() ==	null) ? "" : objEntityDetailsVO.getUinNO();
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
		strSecondAddressBuildingNo  = (objEntityDetailsVO.getSecaddBuildingNo() ==	null) ? "" : objEntityDetailsVO.getSecaddBuildingNo();
		strSecondAddressStreet      = (objEntityDetailsVO.getSecaddStreet() ==	null) ? "" : objEntityDetailsVO.getSecaddStreet();
		strSecondAddressLocality    = (objEntityDetailsVO.getSecaddLocality() ==	null) ? "" : objEntityDetailsVO.getSecaddLocality();
		strSecondAddressCity        = (objEntityDetailsVO.getSecaddCity() ==	null) ? "" : objEntityDetailsVO.getSecaddCity();
		strSecondAddressState       = (objEntityDetailsVO.getSecaddState() ==	null) ? "" : objEntityDetailsVO.getSecaddState();
		strSecondAddressCountry     = (objEntityDetailsVO.getSecaddCountry() ==	null) ? "" : objEntityDetailsVO.getSecaddCountry();
		strSecondAddressPinCode     = (objEntityDetailsVO.getSecaddPinCode() ==	null) ? "" : objEntityDetailsVO.getSecaddPinCode();
		strSecondAddressTelephoneNo = (objEntityDetailsVO.getSecaddTelNo() ==	null) ? "" : objEntityDetailsVO.getSecaddTelNo();
		strSecondAddressFaxNo       = (objEntityDetailsVO.getSecaddFaxNo() ==	null) ? "" : objEntityDetailsVO.getSecaddFaxNo();
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
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AddNewLegal</title>
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
		$( "#repDateOfIncorporation" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
	});
	
	function validate(form){
		//console.log(form);
		var customerId =  document.getElementById("newLegalDetails").elements.namedItem("repCustomerId").value;
		var accountNo =  document.getElementById("newLegalDetails").elements.namedItem("accountNo").value;
		//alert("customerId = "+customerId);
		//alert("accountNo = "+accountNo);
		if(customerId !== "" && accountNo !== ""){
			//alert("in if");
			form.submit();
		}else{
			//alert("in else");
			alert("Please insert customer id and account number.");
		}
	}
	
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<%	
	String IsSaved = (String) request.getAttribute("IsSaved");
	System.out.println("Inside new legal:"+IsSaved);
	if(IsSaved!=null && IsSaved.equalsIgnoreCase("Yes")){
%>
	<script>
	//opener.document.form1.Type.value='showBlankIndianSTR';
	//opener.document.form1.caseNo.value='<%=caseNo%>';
	//opener.document.form1.submit();
	alert('Party has been added to the entity/legal list');
	var caseNo = '<%=caseNo%>';
	//window.opener.location.replace('<%=contextPath%>/IndianRegulatoryReport/str/strMain.jsp?caseNo='+caseNo);
	//window.opener.location.reload();
	window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRReport?caseNo="+caseNo+"&canUpdated=Y&canExported=N");
	window.close();
    </script>
<%}%>
<body>
<div class="content">
<form name="NewLegalDetails" id="newLegalDetails" action="<%=contextPath%>/common/saveNewINDSTREntity?${_csrf.parameterName}=${_csrf.token}" method="post">
  <input type="hidden" name ="RelationFlag" value="">
  <input type="hidden" name = "LegalAccountNo" value="<%=l_strLegalAccountNo%>"> 
  <input type="hidden" name = "LegalCustomerID" value="<%=strCustomerId%>">
  <input type="hidden" name = "LegalBSRCode" value="<%=strBranchBSRCode%>">
  <input type="hidden" name = "LegalPersonName" value="<%=strNameOfEntity%>">
<div class="header">
		<table class="header-table">
			<tr>
				<td class="leftside">
					<div class="headerText">Legal Person/Entity Details</div>
				</td>
				<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>LPE</li>
					<li class="last">1</li>
				</ul>
			</td>
			</tr>
		</table>
	</div>
<div class="section" style="height : 1800px;">
	<div class="normalTextField">
		<label>1. Name of Reporting Entity</label>
		<input type="text" name="repBranchName" <%=readOnly%> value="<%=strBankBranchName%>"/>
	</div>
	<div class="normalTextField">
		<label>2. Legal Person / Entity Name</label>
		<input type="text" name="repNameOfEntity" <%=readOnly%> value="<%=strNameOfEntity%>"/>
	</div>
	<div class="normalTextField">
		<label>3. Customer ID</label><br />
		<input type="text" name="repCustomerId" <%=readOnly%> value="<%=strCustomerId%>"/>
	</div>
	<div class="normalTextField">
		<label>3.1 Account No</label><br />
		<input type="text" name="accountNo" <%=readOnly%> value="<%=strAccountNo%>"/>
	</div>
	
	<div class="normalTextField">
		<label>4. Relation Flag</label><br />
		<select name="repLegalRelationFlag"	<%=disabled%>>
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
		<label>5. Nature of Business</label><br/>
		<input type="text" name="repNatureOfBusiness" <%=readOnly%> value="<%=strNatureOfBusiness%>"/>
	</div>
	<div class="normalTextField">
		<label>6. Date of Incorporation</label><br/>
		<input type="text" name="repDateOfIncorporation" id="repDateOfIncorporation" <%=readOnly%> value="<%=strDateOfIncorporation%>"/>
	</div>
	<div class="normalTextField">
		<label>7. Constitution Type</label><br/>
		<select name="typeOfConstitution"	<%=disabled%>>
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
		<input type="text" name="repRegistrarionNumber" <%=readOnly%> value="<%=strRegistrarionNumber%>"/>
	</div>
	<div class="normalTextField">
		<label>9. Place of Registration</label><br/>
		<input type="text" name="repPlaceOfRegistration" <%=readOnly%> value="" />
	</div>
	<div class="normalTextField">
		<label>10. Country of Registration</label><br/>
		<input type="text" name="repRegisteringAuthority" <%=readOnly%> value="<%=strPlaceOfRegistration%>"/>
<!--<%=strRegisteringAuthority%>-->
	</div>
	<div class="normalTextField">
		<label>11. PAN</label><br/>
		<input type="text" name="repPanIdNo" <%=readOnly%> value="<%=strPanIdNo%>"/>
	</div>
	<div class="normalTextField">
		<label>12. UIN</label><br/>
		<input type="text" name="repUINNO" <%=readOnly%> value="<%=strUinNo%>"/>
	</div>
	<div class="normalTextField">
		<label>13. Address</label>
		<textarea name="repAddressLine1" <%=readOnly%>><%=strFullAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>14. City</label><br/>
		<input type="text" name="repAddressCity" <%=readOnly%> value="<%=strAddressCity%>"/>
	</div>
	<div class="normalTextField">
		<label>15. State Code</label><br/>
		<input type="text" name="repAddressState" <%=readOnly%> value="<%=strAddressState%>"/>
	</div>
	<div class="normalTextField">
		<label>16. Country Code</label><br/>
		<input type="text" name="repAddressCountry" <%=readOnly%> value="<%=strAddressCountry%>"/>
	</div>
	<div class="normalTextField">
		<label>17. PIN Code</label><br/>
		<input type="text" name="repAddressPinCode" <%=readOnly%> value="<%=strAddressPinCode%>"/>
	</div>
	<div class="normalTextField">
		<label>18. Telephone</label><br/>
		<input type="text" name="repAddressTelephoneNo" <%=readOnly%> value="<%=strAddressTelephoneNo%>"/>
	</div>
	<div class="normalTextField">
		<label>19. Mobile</label><br/>
		<input type="text" name="repAddressMobileNo" <%=readOnly%> value="<%=strAddressMobileNo%>"/>
	</div>
	<div class="normalTextField">
		<label>20. FAX</label><br/>
		<input type="text" name="repAddressFaxNo" <%=readOnly%> value="<%=strAddressFaxNo%>"/>
	</div>
	<!-- <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> -->
	<div class="normalTextField">
		<label>21. E-mail Address</label><br/>
		<input type="text" name="repAddressEMailAddress" <%=readOnly%> value="<%=strAddressBranchEmailId%>"/>
	</div>
	<div class="normalTextField">
		<label>22. Second Address(Permanent Address / Place of Work)</label>
		<textarea name="repSecAddressLine1" <%=readOnly%>><%=strSecondFullAddress%></textarea>
	</div>
	<div class="normalTextField">
		<label>23. City</label><br/>
		<input type="text" name="repSecAddressCity" <%=readOnly%> value="<%=strSecondAddressCity%>"/>
	</div>
	<div class="normalTextField">
		<label>24. State Code</label><br/>
		<input type="text" name="repSecAddressState" <%=readOnly%> value="<%=strSecondAddressState%>"/>
	</div>
	<div class="normalTextField">
		<label>25. Country Code</label><br/>
		<input type="text" name="repSecAddressCountry" <%=readOnly%> value="<%=strSecondAddressCountry%>"/>
	</div>
	<div class="normalTextField">
		<label>26. PIN Code</label><br/>
		<input type="text" name="repSecAddressPinCode" <%=readOnly%> value="<%=strSecondAddressPinCode%>"/>
	</div>
	<div class="normalTextField">
		<label>27. Tel (with STD Code)</label><br/>
		<input type="text" name="repSecAddressTelephoneNo" <%=readOnly%> value=""/>
	</div>
	<div class="mainButtons" style="padding-top : 12%;">
		<%-- <input type="submit" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> /> --%>
		<input type="button" value="Save" class="diffButton" <%if(canUpdated.equals("N")){%> disabled <%}%> onClick="validate(this.form);" />
		<input type="button" class="diffButton close" value="Close" onclick="window.close();"/>
	</div>

</div>
</form>
</div>
</body>
</html>
<%
}catch(Exception e){e.printStackTrace();}
	
%>
