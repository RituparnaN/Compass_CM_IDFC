<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRAccountDetailsVO objAccountDetailsVO = (ISTRAccountDetailsVO)request.getAttribute("AnnexC_AcctDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnCNo");
	String strBankName 							= "";
	String strBranchBSRcode 					= "";
	String strBranchAddress 					= "";
	String strEnclosedAnnexture 				= "";
	String strAccountNo 						= "";
	String strAccountType 						= "";
	String strAccountHoldertype 				= "";
	String strAccountOpenedDate 				= "";
	String[] strAccountHoldersNameArray 		= new String[25];
	String[] strAccountHoldersIdArray 			= new String[25];
	String[] strAccountHoldersAnnexABArray 		= new String[25];
	String[] strAccountHoldersAnnexNoArray 	    = new String[25];
	boolean[] boolAccountHoldersAnnexFlagArray 	= new boolean[25];
	String[] strRelatedPersonsNameArray 		= new String[25];
	String[] strRelatedPersonsIdArray 			= new String[25];
	String[] strRelatedPersonsRelationArray 	= new String[25];
	String[] strRelatedPersonsAnnexABArray 		= new String[25];
	String[] strRelatedPersonsAnnexNoArray 	    = new String[25];
	boolean[] boolRelatedPersonsAnnexFlagArray 	= new boolean[25];
	String strBranchReferenceNumberType         = "";	 
	
	int AnnxA = 0,AnnxB=0;
	if(objAccountDetailsVO != null){
		strEnclosedAnnexture 			 = (objAccountDetailsVO.getAnnexEnclosed() == null) ? "" : objAccountDetailsVO.getAnnexEnclosed();
		strAccountNo 				     = (objAccountDetailsVO.getAccountNo() == null) ? "" : objAccountDetailsVO.getAccountNo();
		strAccountType 			         = (objAccountDetailsVO.getAccountType() == null) ? "" : objAccountDetailsVO.getAccountType();
		strAccountHoldertype 		     = (objAccountDetailsVO.getAccountHoldertype() == null) ? "" : objAccountDetailsVO.getAccountHoldertype();
		strAccountOpenedDate 			 = (objAccountDetailsVO.getAccountOpenDate() == null) ? "" : objAccountDetailsVO.getAccountOpenDate();
		strAccountHoldersNameArray 		 = objAccountDetailsVO.getListofAccountHoldersName();
		strAccountHoldersIdArray 		 = objAccountDetailsVO.getListofAccountHoldersID();
		strAccountHoldersAnnexABArray 	 = objAccountDetailsVO.getListofAccountHoldersAnnexAB();
		strAccountHoldersAnnexNoArray 	 = objAccountDetailsVO.getListofAccountHoldersAnnexNumber();
		boolAccountHoldersAnnexFlagArray = objAccountDetailsVO.getListofAccountHoldersAnnexFlag();
		strRelatedPersonsNameArray 		 = objAccountDetailsVO.getListofRelatedPersonsName();
		strRelatedPersonsIdArray 		 = objAccountDetailsVO.getListofRelatedPersonsID();
		strRelatedPersonsRelationArray 	 = objAccountDetailsVO.getListofRelatedPersonsRelation();
		strRelatedPersonsAnnexABArray 	 = objAccountDetailsVO.getListofRelatedPersonsAnnexAB();
		strRelatedPersonsAnnexNoArray 	 = objAccountDetailsVO.getListofRelatedPersonsAnnexNumber();
		boolRelatedPersonsAnnexFlagArray = objAccountDetailsVO.getListofRelatedPersonsAnnexFlag();
		strBranchReferenceNumberType     = objAccountDetailsVO.getBranchReferenceNumberType();
		strBranchAddress                 = (objAccountDetailsVO.getBranchAddressLine1() == null ? "":objAccountDetailsVO.getBranchAddressLine1())+
			objAccountDetailsVO.getBranchAddressLine2() == null ? "":(", "+objAccountDetailsVO.getBranchAddressLine3())+
			objAccountDetailsVO.getBranchAddressLine3() == null ? "":(", "+objAccountDetailsVO.getBranchAddressLine3());
	}
	String l_disable =(String) request.getAttribute("disable");
%>

<div class="section">
	<div class="mainHeader">1. Branch Details</div>
	<div class="normalTextField">
		<label>1.1 Name of Reporting Entity</label>
		<input type="text" readonly name="nameOfReportingEntity"  value="<%=objAccountDetailsVO.getBankName()%>" />
	</div>
	<div class="normalTextField">
		<label>1.2 Name of the Branch</label>
		<input type="text" readonly name="nameOfBranch"  value="<%=objAccountDetailsVO.getBranchName()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.3 Branch Reference Number Type</label>
		<select name="branchReferenceNumberType" disabled>
			<option value="R" <% if(strBranchReferenceNumberType.equals("R")) {%>selected<% } %>>R - Regulator Issued</option>
			<option value="B" <% if(strBranchReferenceNumberType.equals("B")) {%>selected<% } %>>B - BIC</option>			
			<option value="I" <% if(strBranchReferenceNumberType.equals("I")) {%>selected<% } %>>I - IFSC</option>
			<option value="M" <% if(strBranchReferenceNumberType.equals("M")) {%>selected<% } %>>M - MICR</option>
			<option value="S" <% if(strBranchReferenceNumberType.equals("S")) {%>selected<% } %>>S - Self Generated</option>			
			<option value="Z" <% if(strBranchReferenceNumberType.equals("Z")) {%>selected<% } %>>Z - Other Sources</option>
			<option value="X" <% if(strBranchReferenceNumberType.equals("X")) {%>selected<% } %>>X - Not Catgorised</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>1.4 Branch Reference Number</label>
		<input type="text" name="branchRefNumber" readonly value="<%=objAccountDetailsVO.getBranchBsrCode()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.5 Address</label>
		<input type="text" name="accAddress" readonly value="<%=strBranchAddress%>" />
	</div>
	<div class="normalTextField">
		<label>1.6 City</label>
		<input type="text" name="accCity" readonly value="<%=objAccountDetailsVO.getBranchCity()%>" />
	</div>
	
	<div class="normalTextField left">
		<label>1.7 State Code</label>
		<input type="text" name="stateCode" readonly value="<%=objAccountDetailsVO.getBranchState()%>" />
	</div>
	<div class="normalTextField right">
		<label>1.8 Country Code</label>
		<input type="text" name="countryCode" readonly value="<%=objAccountDetailsVO.getBranchCountry()%>" />
	</div>
	
	<div class="normalTextField left">
		<label>1.9 PIN Code</label>
		<input type="text" name="accPin" readonly value="<%=objAccountDetailsVO.getBranchPinCode()%>" />
	</div>
	<div class="normalTextField right">
		<label>1.10 Telephone</label>
		<input type="text" name="accTelephone" readonly value="<%=objAccountDetailsVO.getBranchTelephoneNo()%>" />
	</div>
	
	<div class="normalTextField left">
		<label>1.11 Mobile</label>
		<input type="text" name="accmobile" readonly value="<%=objAccountDetailsVO.getBranchMobileNo()%>" />
	</div>
	<div class="normalTextField right">
		<label>1.12 FAX</label>
		<input type="text" name="accFax" readonly value="<%=objAccountDetailsVO.getBranchFaxNo()%>" />
	</div>
	<div class="normalTextField">
		<label>1.13 E-mail Address</label>
		<input type="text" name="accEmail" readonly value="<%=objAccountDetailsVO.getBranchEmailId()%>" />
	</div>
</div>


<div class="section" style="height: 300px;">
	<div class="mainHeader">2. Account Details</div>
	<div class="normalTextField">
		<label>2.1 Account Number</label>
		<input type="text" name="accountNumber" readonly value="<%=strAccountNo%>" />
	</div>
	<div class="normalTextField">
		<label>2.2 Account Holder Name</label>
		<input type="text" name="accountHolderName" readonly value="<%=objAccountDetailsVO.getAccountHolderName()%>" />
	</div>
	<div class="normalTextField left">
		<label>2.3 Account Type</label>
		<select name="accountType" disabled>
			<option value="BC" <% if(strAccountType.equals("BC")) {%>selected<% } %>>BC - Current Account</option>
			<option value="BD" <% if(strAccountType.equals("BD")) {%>selected<% } %>>BD - Credit card Account</option>	
			<option value="BG" <% if(strAccountType.equals("BG")) {%>selected<% } %>>BG - Letter Of Credit/Bank Guarantee</option>
			<option value="BL" <% if(strAccountType.equals("BL")) {%>selected<% } %>>BL - Loan Account</option>
			<option value="BP" <% if(strAccountType.equals("BP")) {%>selected<% } %>>BP - Prepaid card Account</option>
			<option value="BR" <% if(strAccountType.equals("BR")) {%>selected<% } %>>BR - Cash Credit Account</option>	
			<option value="BS" <% if(strAccountType.equals("BS")) {%>selected<% } %>>BS - Saving Account</option>
			<option value="BT" <% if(strAccountType.equals("BT")) {%>selected<% } %>>BT - Term Deposit Account</option>
			<option value="DB" <% if(strAccountType.equals("DB")) {%>selected<% } %>>DB - Beneficiary Demat Account</option>
			<option value="DC" <% if(strAccountType.equals("DC")) {%>selected<% } %>>DC - Clearing Member Pool Account</option>
			<option value="DH" <% if(strAccountType.equals("DH")) {%>selected<% } %>>DH - Beneficiary House Account</option>
			<option value="IA" <% if(strAccountType.equals("IA")) {%>selected<% } %>>IA - Annuity Policy Account</option>	
			<option value="IB" <% if(strAccountType.equals("IB")) {%>selected<% } %>>IB - Money Back Policy</option>
			<option value="IE" <% if(strAccountType.equals("IE")) {%>selected<% } %>>IE - Endowment Policy</option>
			<option value="IH" <% if(strAccountType.equals("IH")) {%>selected<% } %>>IH - Health Insurance Policy</option>
			<option value="IL" <% if(strAccountType.equals("IL")) {%>selected<% } %>>IL - Term Insurance Policy</option>
			<option value="IM" <% if(strAccountType.equals("IM")) {%>selected<% } %>>IM - Motor Insurance Policy</option>
			<option value="IT" <% if(strAccountType.equals("IT")) {%>selected<% } %>>IT - Travel Insurance Policy</option>	
			<option value="IU" <% if(strAccountType.equals("IU")) {%>selected<% } %>>IU - ULIP Policy</option>
			<option value="IW" <% if(strAccountType.equals("IW")) {%>selected<% } %>>IW - Whole Life  Policy</option>
			<option value="MF" <% if(strAccountType.equals("MF")) {%>selected<% } %>>MF - Mutual fund Folio</option>
			<option value="ST" <% if(strAccountType.equals("ST")) {%>selected<% } %>>ST - Trading Account</option>
			<option value="XX" <% if(strAccountType.equals("XX")) {%>selected<% } %>>XX - Not Categorised</option>
			<option value="ZZ" <% if(strAccountType.equals("ZZ")) {%>selected<% } %>>ZZ - Others</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>2.4 Account Holder Type</label>
		<select name="accountHolderType" disabled>
			<option value="A" <% if(strAccountHoldertype.equals("A")) {%>selected<% } %>>A - Resident Individual</option>
			<option value="B" <% if(strAccountHoldertype.equals("B")) {%>selected<% } %>>B - Legal Person/Entity</option>	
			<option value="C" <% if(strAccountHoldertype.equals("C")) {%>selected<% } %>>C - Central/State Government</option>
			<option value="D" <% if(strAccountHoldertype.equals("D")) {%>selected<% } %>>D - Central/State Government Undertaking</option>
			<option value="E" <% if(strAccountHoldertype.equals("E")) {%>selected<% } %>>E - Reporting Entity</option>
			<option value="F" <% if(strAccountHoldertype.equals("F")) {%>selected<% } %>>F - Non Profit Organization</option>	
			<option value="G" <% if(strAccountHoldertype.equals("G")) {%>selected<% } %>>G - Non-resident Individual</option>
			<option value="H" <% if(strAccountHoldertype.equals("H")) {%>selected<% } %>>H - Overseas cooprate body/FII</option>
			<option value="X" <% if(strAccountHoldertype.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
			<option value="Z" <% if(strAccountHoldertype.equals("Z")) {%>selected<% } %>>X - Others</option>
		</select>
	</div>
	
	<div class="normalTextField left">
		<label>2.5 Account Opening Date</label>
		<input type="text" name="accountOpeningDate" readonly value="<%=objAccountDetailsVO.getAccountOpenDate()%>" />
	</div>
	<div class="normalTextField right">
		<label>2.6 Account Status</label>
		<select name="" disabled>
			<option value="A" <% if(objAccountDetailsVO.getAccountStatus().equals("A")) {%>selected<% } %>>A - Active</option>
			<option value="C" <% if(objAccountDetailsVO.getAccountStatus().equals("C")) {%>selected<% } %>>C - Closed</option>	
			<option value="D" <% if(objAccountDetailsVO.getAccountStatus().equals("D")) {%>selected<% } %>>D - Dormant</option>
			<option value="F" <% if(objAccountDetailsVO.getAccountStatus().equals("F")) {%>selected<% } %>>F - Frozen</option>
			<option value="I" <% if(objAccountDetailsVO.getAccountStatus().equals("I")) {%>selected<% } %>>I - Inactive</option>
			<option value="S" <% if(objAccountDetailsVO.getAccountStatus().equals("S")) {%>selected<% } %>>S - Suspended</option>	
			<option value="X" <% if(objAccountDetailsVO.getAccountStatus().equals("X")) {%>selected<% } %>>X - Not Categorised</option>
			<option value="Z" <% if(objAccountDetailsVO.getAccountStatus().equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
