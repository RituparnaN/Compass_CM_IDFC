<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.*,java.text.SimpleDateFormat" %>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	HttpSession l_CHttpSession = request.getSession(true);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}

	HashMap hmAccountDetails = null;
	String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();

	ISTRAccountDetailsVO objAccountDetailsVO = null;
	if((HashMap)request.getAttribute("HmDto")!=null)
		hmAccountDetails = (HashMap)request.getAttribute("HmDto");

	String strBankName 							= "";
	String strBranchBSRcode 					= "";
	String strBranchAddress 					= "";
	String strEnclosedAnnexture 				= "";
	String strAccountNo 						= "";
	String strAccountType 						= "";
	String strAccountRiskCategory               = "";
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
	if(hmAccountDetails != null)
	{
		objAccountDetailsVO = (ISTRAccountDetailsVO)hmAccountDetails.get("ALAcctDetailsDTO");
	}	

	
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
				(objAccountDetailsVO.getBranchAddressLine2() == null ? "": objAccountDetailsVO.getBranchAddressLine2())+
				(objAccountDetailsVO.getBranchAddressLine3() == null ? "": objAccountDetailsVO.getBranchAddressLine3());

		strAccountRiskCategory =objAccountDetailsVO.getAccountRiskCategory() == null ? "A":(String)objAccountDetailsVO.getAccountRiskCategory();
		strBranchBSRcode = objAccountDetailsVO.getBSRcode();
	}
	String l_disable =(String) request.getAttribute("disable");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<title>AddNewAccount</title>
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
		$( "#repAccountOpenDate" ).datepicker({
			 dateFormat : "yy-mm-dd"
		 });
	});
	
	function validate(form){
		//console.log(form);
		var accountNo =  document.getElementById("newAccountDetails").elements.namedItem("repAccountNo").value;
		//alert("accountNo = '"+accountNo+"'");
		if(accountNo !== ""){
			form.submit();
		}else{
			//alert("in else");
			alert("Please insert account number.");
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
	alert('Party has been added to the account list');
	var caseNo = '<%=caseNo%>';
	//window.opener.location.reload();
	window.opener.location.replace("${pageContext.request.contextPath}/common/getINDSTRReport?caseNo="+caseNo+"&canUpdated=Y&canExported=N");
	window.close();
	
    </script>
<%}%>

<script  type="text/javascript">

</script>

<body>
<div class="content">
<form id="newAccountDetails" name="NewAccountDetails" action="<%=contextPath%>/common/saveNewINDSTRAccount?${_csrf.parameterName}=${_csrf.token}" method="post">
  <input type="hidden" name ="AccountType" value="">
  <input type="hidden" name ="AccountHolderType" value="">
  <input type="hidden" name ="RiskCategory" value="">
  <input type="hidden" name="keyAcctNo" value="<%=strAccountNo%>" >	
  <input type="hidden" name="keyBSRCode" value="<%=strBranchBSRcode%>" >
  <input type="hidden" name="keyCustomerName" value="<%=(objAccountDetailsVO==null || objAccountDetailsVO.getStrCustName()==null)?"": objAccountDetailsVO.getStrCustName()%>" > 

<div class="header">
	<table class="header-table">
		<tr>
			<td class="leftside">
				<div class="headerText">Account Details</div>
			</td>
			<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>ACC</li>
					<li class="last">1</li>
				</ul>
			</td>
		</tr>
	</table>
</div>
<div class="section">
	<div class="mainHeader">1. Branch Details</div>
	<div class="normalTextField">
		<label>1.1 Name of Reporting Entity</label>
		<input type="text" name="repBankName" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBankName()%>" />
	</div>
	<div class="normalTextField">
		<label>1.2 Name of the Branch</label>
		<input type="text" name="repBranchName" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchName()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.3 Branch Reference Number Type</label>
		<select name="repBranchReferenceNumberType" <%=disabled%>>
			<option value="R" <% if(strBranchReferenceNumberType.equals("R")) {%>selected<% } %>>R - Regulator Issued</option>
			<option value="B" <% if(strBranchReferenceNumberType.equals("B")) {%>selected<% } %>>B - BIC</option>			
			<option value="I" <% if(strBranchReferenceNumberType.equals("I")) {%>selected<% } %>>I - IFSC</option>
			<option value="M" <% if(strBranchReferenceNumberType.equals("M")) {%>selected<% } %>>M - MICR</option>
			<option value="S" <% if(strBranchReferenceNumberType.equals("S")) {%>selected<% } %>>S - Self Generated</option>			
			<option value="Z" <% if(strBranchReferenceNumberType.equals("Z")) {%>selected<% } %>>Z - Other Sources</option>
			<option value="X" <% if(strBranchReferenceNumberType.equals("X")) {%>selected<% } %>>X - Not Categorised</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>1.4 Branch Reference Number</label>
		<input type="text" name="repBranchReferenceNumber" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchBsrCode()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.5 Address</label>
		<input type="text" name="repBranchBuildingNo" <%=readOnly%> value="<%=strBranchAddress%>" />
	</div>
	<div class="normalTextField">
		<label>1.6 City</label>
		<input type="text" name="repBranchCity" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchCity()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.7 State Code</label>
		<input type="text" name="repBranchState" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchState()%>" />
	</div>
	<div class="normalTextField">
		<label>1.8 Country Code</label>
		<input type="text" name="repBranchCountry" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchCountry()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.9 PIN Code</label>
		<input type="text" name="repBranchPincode" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchPinCode()%>" />
	</div>
	<div class="normalTextField">
		<label>1.10 Telephone</label>
		<input type="text" name="repBranchTelephoneNo" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchTelephoneNo()%>" />
	</div>
	
	<div class="normalTextField">
		<label>1.11 Mobile</label>
		<input type="text" name="repBranchMobile" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchMobileNo()%>" />
	</div>
	<div class="normalTextField">
		<label>1.12 FAX</label>
		<input type="text" name="repBranchFaxNo" <%=readOnly%>  value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchFaxNo()%>" />
	</div>
	<div class="normalTextField">
		<label>1.13 E-mail Address</label>
		<input type="text" name="repBranchEmail" <%=readOnly%>  value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getBranchEmailId()%>" />
	</div>
</div>


<div class="section" style="height : 420px;">
	<div class="mainHeader">2. Account Details</div>
	<div class="normalTextField">
		<label>2.1 Account Number</label>
		<input type="text" name="repAccountNo" <%=readOnly%>  value="<%=strAccountNo%>" />
	</div>
	<div class="normalTextField">
		<label>2.2 Account Holder Name</label>
		<input type="text" name="repAccountHolderName" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountHolderName()%>" />
	</div>
	<div class="normalTextField">
		<label>2.3 Account Type</label>
		<select name="repAccountType" <%=disabled%>>
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
	<div class="normalTextField">
		<label>2.4 Account Holder Type</label>
		<select name="repAccountHolderType" <%=disabled%>>
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
	
	<div class="normalTextField">
		<label>2.5 Account Opening Date</label>
		<input type="text" name="repAccountOpenDate" <%=readOnly%> id="repAccountOpenDate"  value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountOpenDate()%>" />
	</div>
	<div class="normalTextField">
		<label>2.6 Account Status</label>
		<select name="repAccountStatus" <%=disabled%>>
			<option value="A" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("A")) {%>selected<% } %>>A - Active</option>
			<option value="C" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("C")) {%>selected<% } %>>C - Closed</option>	
			<option value="D" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("D")) {%>selected<% } %>>D - Dormant</option>
			<option value="F" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("F")) {%>selected<% } %>>F - Frozen</option>
			<option value="I" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("I")) {%>selected<% } %>>I - Inactive</option>
			<option value="S" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("S")) {%>selected<% } %>>S - Suspended</option>	
			<option value="X" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("X")) {%>selected<% } %>>X - Not Categorised</option>
			<option value="Z" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountStatus().equals("Z")) {%>selected<% } %>>Z - Others</option>
		</select>
	</div>
	</div>

	<div class="section">

	<div class="mainHeader">3. Cumulative Details in the bank account in the financial year</div>
	<div class="normalTextField">
		<label>3.1 Total Credits</label>
		<input type="text" name="repAccountTotalCredit" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountTotalCredit()%>" />
	</div>
	<div class="normalTextField">
		<label>3.2 Total Debits</label>
		<input type="text" name="repAccountTotalDebit" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountTotalDebit()%>" />
	</div>

	<div class="normalTextField">
		<label>3.3 Total Cash Deposited</label>
		<input type="text" name="repAccountTotalCashCredit" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountTotalCashCredit()%>" />
	</div>
	<div class="normalTextField">
		<label>3.4 Total Cash Withdrawn</label>
		<input type="text" name="repAccountTotalCashDebit" <%=readOnly%> value="<%=objAccountDetailsVO == null ? "":objAccountDetailsVO.getAccountTotalCashDebit()%>" />
	</div>
	<div class="normalTextField">
		<label>3.5 Risk Category</label>
		<select name="repAccountRiskCategory" <%=disabled%>>
			<option value="A1" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountRiskCategory().equals("A1")) {%>selected<% } %>>A1 - High Risk Account</option>
			<option value="A2" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountRiskCategory().equals("A2")) {%>selected<% } %>>A2 - Medium Risk Account</option>	
			<option value="A3" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountRiskCategory().equals("A3")) {%>selected<% } %>>A3 - Low Risk Account</option>
			<option value="XX" <% if(objAccountDetailsVO != null && objAccountDetailsVO.getAccountRiskCategory().equals("XX")) {%>selected<% } %>>XX - Not Categorised</option>
		</select>
	</div>
	<div class="mainButtons">
		<%-- <input type="submit" value="Save" <%=disabled%> /> --%>
		<input type="button" class="diffButton" value="Save" <%=disabled%>  onClick="validate(this.form);" />
		<input type="button" class="diffButton" value="Close" onclick="window.close();"/>
	</div>
</div>
</form>
</div>
</body>
</html>
<% }catch(Exception e){e.printStackTrace();} %>
