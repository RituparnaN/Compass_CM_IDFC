<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
	HttpSession l_CHttpSession = request.getSession(true);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}
	ISTRManualDetailsVO objManualDetailsVO = (ISTRManualDetailsVO)request.getAttribute("ManualFormDTO");
	String strBankName 		= "";
	String strBankBSRCode 	= "";
	String strBankFIUINDID 	= "";
	String strBankCategory 	= "";
	String strBankMLROName 	= "";
	String strMLRODesignation = "";
	String strBankAddressBuildingNo = "";
	String strBankAddressStreet 	= "";
	String strBankAddressLocality 	= "";
	String strBankAddressCity 		= "";
	String strBankAddressState 		= "";
	String strBankAddressPinCode 	= "";
	String strBankAddressTelephoneNo = "";
	String strBankAddressMobileNo = "";
	String strBankAddressFaxNo       = "";
	String strMLROEmailId 			 = "";
	String strReadonly               = "readonly";

	strBankName = "Corporative Bank";
	strBankBSRCode = "0000089";
	strBankFIUINDID = "XXXXXXXXXX";
	strBankCategory  = "D";
	strBankMLROName  = "MR. P. REDDY";
	strMLRODesignation  = "COMPLIANCE OFFICER";
	strBankAddressBuildingNo = "NAVEEN LANE";
	strBankAddressStreet 	 = "JEEVAN BIMA ROAD";
	strBankAddressLocality 	 = "INDRA NAGAR";
	strBankAddressCity 		 = "BANGALORE";
	strBankAddressState 	 = "KARNATKA";
	strBankAddressPinCode 	 = "600987";
	strBankAddressTelephoneNo = "0659-8903245";
	strBankAddressMobileNo    = "0999090909";
	strBankAddressFaxNo 	  = "0659-6983223";
	strMLROEmailId 			  = "PREDDY@CORP.COM";

	if(objManualDetailsVO!=null){
		strBankName 	= (objManualDetailsVO.getPrincNameOfBank() == null) ? "" : objManualDetailsVO.getPrincNameOfBank();
		strBankBSRCode  = (objManualDetailsVO.getPrincBSRCode() == null) ? "" : objManualDetailsVO.getPrincBSRCode();
	    //strBankName 	= "Corporative Bank";
	    //strBankBSRCode 	= "0000089";
		
		strBankFIUINDID 		  = (objManualDetailsVO.getPrincIDFIUIND() == null) ? "" : objManualDetailsVO.getPrincIDFIUIND();
	    //strBankFIUINDID 		  = "XXXXXXXXXX";
		strBankCategory 	      = (objManualDetailsVO.getPrincBankCategory() == null) ? "" : objManualDetailsVO.getPrincBankCategory();
		strBankMLROName 	      = (objManualDetailsVO.getPrincOfficerName() == null) ? "" : objManualDetailsVO.getPrincOfficerName();
		strMLRODesignation 	      = (objManualDetailsVO.getPrincDesignation() == null) ? "" : objManualDetailsVO.getPrincDesignation();
		strBankAddressBuildingNo  = (objManualDetailsVO.getPrincBuildingNo() == null) ? "" : objManualDetailsVO.getPrincBuildingNo();
		strBankAddressStreet 	  = (objManualDetailsVO.getPrincStreet() == null) ? "" : objManualDetailsVO.getPrincStreet();
		strBankAddressLocality 	  = (objManualDetailsVO.getPrincLocality() == null) ? "" : objManualDetailsVO.getPrincLocality();
		strBankAddressCity 		  = (objManualDetailsVO.getPrincCity() == null) ? "" : objManualDetailsVO.getPrincCity();
		strBankAddressState 	  = (objManualDetailsVO.getPrincState() == null) ? "" : objManualDetailsVO.getPrincState();
		strBankAddressPinCode 	  = (objManualDetailsVO.getPrincPinCode() == null) ? "" : objManualDetailsVO.getPrincPinCode();
		strBankAddressTelephoneNo = (objManualDetailsVO.getPrincTelNo() == null) ? "" : objManualDetailsVO.getPrincTelNo();
		strBankAddressMobileNo    = (objManualDetailsVO.getPrincMobileNo() == null) ? "" : objManualDetailsVO.getPrincMobileNo();
		strBankAddressFaxNo 	  = (objManualDetailsVO.getPrincFax() == null) ? "" : objManualDetailsVO.getPrincFax();
		strMLROEmailId 		      = (objManualDetailsVO.getPrincEmail() == null) ? "" : objManualDetailsVO.getPrincEmail();
	/*	
	strBankCategory 		  = "D";
	strBankMLROName 		  = "MR. P. REDDY";
	strMLRODesignation 		  = "COMPLIANCE OFFICER";
	strBankAddressBuildingNo  = "NAVEEN LANE";
	strBankAddressStreet 	  = "JEEVAN BIMA ROAD";
	strBankAddressLocality 	  = "INDRA NAGAR";
	strBankAddressCity 		  = "BANGALORE";
	strBankAddressState 	  = "KARNATKA";
	strBankAddressPinCode 	  = "600987";
	strBankAddressTelephoneNo = "0659-8903245";
	strBankAddressFaxNo 	  = "0659-6983223";
	strMLROEmailId 			  = "PREDDY@CORP.COM";
	*/
} 

	String strBankFullAddress = strBankAddressBuildingNo;
	if(!strBankAddressStreet.trim().equals(""))
		strBankFullAddress = strBankFullAddress +", "+strBankAddressStreet;
	if(!strBankAddressLocality.trim().equals(""))
		strBankFullAddress = strBankFullAddress +", "+strBankAddressLocality;

%>

<div class="section">
	<div class="mainHeader">
	3. Principal Officer Details
	</div>
	<div class="normalTextField">
		<label>3.1 Principal Officer's Name</label>
		<input type="text" name="principalOfficersName" <%=readOnly%> value="<%=strBankMLROName%>"/>
	</div>
	<div class="normalTextField">
		<label>3.2 Designation</label>
		<input type="text" name="principalOfficersDesignation" <%=readOnly%> value="<%=strMLRODesignation%>"/>
	</div>
	<div class="normalTextField">
		<label>3.3 Address</label>
		<textarea name="principalOfficersAddress1" <%=readOnly%>><%=strBankFullAddress%></textarea>
	</div>
	
	<div class="normalTextField">
		<label>3.4 City</label>
		<input type="text" name="principalOfficersCity" <%=readOnly%> value="<%=strBankAddressCity%>"/>
	</div>
	
	<div class="normalTextField left">
		<label>3.5 State</label>
		<input type="text" name="principalOfficersState" <%=readOnly%> value="<%=strBankAddressState%>"/>
	</div>
	
	<div class="normalTextField right">
		<label>3.6 Country</label>
		<input type="text" name="principalOfficersCountry" <%=readOnly%> value="IN"/>
	</div>
	
	<div class="normalTextField left">
		<label>3.7 PIN</label>
		<input type="text" name="principalOfficersAddressPinCode" <%=readOnly%> value="<%=strBankAddressPinCode%>"/>
	</div>
	
	<div class="normalTextField right">
		<label>3.8 Telephone</label>
		<input type="text" name="principalOfficersTelephoneNo" <%=readOnly%> value="<%=strBankAddressTelephoneNo%>"/>
	</div>
	
	<div class="normalTextField left">
		<label>3.9 Mobile</label>
		<input type="text" name="principalOfficersMobileNo" <%=readOnly%> value="<%=strBankAddressMobileNo%>"/>
	</div>
	
	<div class="normalTextField right">
		<label>3.10 Fax</label>
		<input type="text" name="principalOfficersFaxNo" <%=readOnly%> value="<%=strBankAddressFaxNo%>"/>
	</div>
	
	<div class="normalTextField">
		<label>3.11 E-mail Address</label>
		<input type="text" name="principalOfficersEmailId" <%=readOnly%> value="<%=strMLROEmailId%>"/>
	</div>
	
</div>