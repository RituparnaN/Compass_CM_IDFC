<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<% 
	HttpSession l_CHttpSession = request.getSession(true);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	HashMap hashMapDTO = (HashMap)request.getAttribute("INDIANSTRTRFDETAILS");
	
	HashMap caseStatusDetails = (HashMap)hashMapDTO.get("CaseStatusDetails");
	String batchDisabled = "disabled";
	String disabled = "disabled";
	String readOnly = "readonly";
	String batchReadOnly = "readonly";
	
	/*
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}
	*/
	String strCaseStatus = caseStatusDetails.get("CASESTATUS").toString();	
	String strcaseUserCode = caseStatusDetails.get("USERCODE").toString();
	String strcaseUserRole = caseStatusDetails.get("USERROLE").toString();
	String exportXMLDisabled = "disabled";
	if(strcaseUserRole.equalsIgnoreCase("ROLE_AMLREP") && (strCaseStatus.equals("10") || strCaseStatus.equals("37"))){
		batchDisabled = "";
		batchReadOnly = "";
	}
	batchDisabled = "";
	batchReadOnly = "";
	
	ISTRTRFManualDetailsVO objManualDetailsVO = (ISTRTRFManualDetailsVO)request.getAttribute("ManualFormDTO");
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
	String strBankAddressFaxNo       = "";
	String strMLROEmailId 			 = "";
	String strReasonOfRevision       = "N";	
	String strReadonly               = "readonly";
	String strBatchNo = "000000001"; 
	String strDateOfReportSending 		= "";
	String strReportFlag 				= "";
	String strDateOfReportSendingReplac = "";
	String strOriginalBatchID           = "0"; 
	String strReportingBatchType        = "N"; 
	Calendar calendar = Calendar.getInstance();
	StringBuffer strBuffTemplate1 = new StringBuffer();
	
	String strCalendarDay = calendar.get(Calendar.DAY_OF_MONTH)+"";
	String strCalendarMonth = calendar.get(Calendar.MONTH)+1+"";
	String strCalendarYear = calendar.get(Calendar.YEAR)+"";
	
	if(strCalendarDay.length()==1){
		strCalendarDay = "0"+strCalendarDay;
	}
	
	if(strCalendarMonth.length()==1){
		strCalendarMonth = "0"+strCalendarMonth;
	}
	String strDefaultDate1 = (strCalendarYear+"-"+strCalendarMonth+"-"+strCalendarDay).toString();

	/*
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
	strBankAddressFaxNo 	  = "0659-6983223";
	strMLROEmailId 			  = "PREDDY@CORP.COM";
   */
	
	if(objManualDetailsVO!=null){
		strBankName 	= (objManualDetailsVO.getReportingEntityName() == null) ? "" : objManualDetailsVO.getReportingEntityName();
		strBankBSRCode  = (objManualDetailsVO.getReportingEntityCode() == null) ? "" : objManualDetailsVO.getReportingEntityCode();
	    //strBankName 	= "Corporative Bank";
	    //strBankBSRCode 	= "0000089";
		
		strBankFIUINDID 		  = (objManualDetailsVO.getReportingEntityFIUREID() == null) ? "" : objManualDetailsVO.getReportingEntityFIUREID();
	    //strBankFIUINDID 		  = "XXXXXXXXXX";
		strBankCategory 	      = (objManualDetailsVO.getReportingEntityCategory() == null) ? "" : objManualDetailsVO.getReportingEntityCategory();
		strBankMLROName 	      = (objManualDetailsVO.getPrincipalOfficersName() == null) ? "" : objManualDetailsVO.getPrincipalOfficersName();
		strMLRODesignation 	      = (objManualDetailsVO.getPrincipalOfficersDesignation() == null) ? "" : objManualDetailsVO.getPrincipalOfficersDesignation();
		strBankAddressBuildingNo  = (objManualDetailsVO.getPrincipalOfficersAddress1() == null) ? "" : objManualDetailsVO.getPrincipalOfficersAddress1();
		strBankAddressStreet 	  = (objManualDetailsVO.getPrincipalOfficersAddress2() == null) ? "" : objManualDetailsVO.getPrincipalOfficersAddress2();
		strBankAddressLocality 	  = (objManualDetailsVO.getPrincipalOfficersAddress3() == null) ? "" : objManualDetailsVO.getPrincipalOfficersAddress3();
		strBankAddressCity 		  = (objManualDetailsVO.getPrincipalOfficersCity() == null) ? "" : objManualDetailsVO.getPrincipalOfficersCity();
		strBankAddressState 	  = (objManualDetailsVO.getPrincipalOfficersState() == null) ? "" : objManualDetailsVO.getPrincipalOfficersState();
		strBankAddressPinCode 	  = (objManualDetailsVO.getPrincipalOfficersAddressPinCode() == null) ? "" : objManualDetailsVO.getPrincipalOfficersAddressPinCode();
		strBankAddressTelephoneNo = (objManualDetailsVO.getPrincipalOfficersTelephoneNo() == null) ? "" : objManualDetailsVO.getPrincipalOfficersTelephoneNo();
		strBankAddressFaxNo 	  = (objManualDetailsVO.getPrincipalOfficersFaxNo() == null) ? "" : objManualDetailsVO.getPrincipalOfficersFaxNo();
		strMLROEmailId 		      = (objManualDetailsVO.getPrincipalOfficersEmailId() == null) ? "" : objManualDetailsVO.getPrincipalOfficersEmailId();
		strReasonOfRevision       = (objManualDetailsVO.getReasonOfRevision() == null) ? "" : objManualDetailsVO.getReasonOfRevision();
		strBatchNo = (objManualDetailsVO.getReportingBatchNo() == null) ? "000000001" : objManualDetailsVO.getReportingBatchNo();
		strDefaultDate1 = (objManualDetailsVO.getReportingBatchDate() == null) ? strDefaultDate1 : objManualDetailsVO.getReportingBatchDate();
		strOriginalBatchID = (objManualDetailsVO.getReportingOriginalBatchId() == null) ? strOriginalBatchID : objManualDetailsVO.getReportingOriginalBatchId();
		strReportingBatchType = (objManualDetailsVO.getReportingBatchType() == null) ? strReportingBatchType : objManualDetailsVO.getReportingBatchType();
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

/*
	String strDateOfReportSending 		= "";
	String strReportFlag 				= "";
	String strDateOfReportSendingReplac = "";
	String strBatchNo = "000000001"; 

	Calendar calendar = Calendar.getInstance();
	StringBuffer strBuffTemplate1 = new StringBuffer();
	
	String strCalendarDay = calendar.get(Calendar.DAY_OF_MONTH)+"";
	String strCalendarMonth = calendar.get(Calendar.MONTH)+1+"";
	String strCalendarYear = calendar.get(Calendar.YEAR)+"";
	
	if(strCalendarDay.length()==1){
		strCalendarDay = "0"+strCalendarDay;
	}
	
	if(strCalendarMonth.length()==1){
		strCalendarMonth = "0"+strCalendarMonth;
	}
		
	String strDefaultDate1 = (strCalendarYear+"-"+strCalendarMonth+"-"+strCalendarDay).toString();
*/

%>
<div style="height: 760px;">
<div class="section" style="height: 270px;">
	<div class="mainHeader">
	1. Reporting Entity Details
	</div>
	<div class="normalTextField">
		<label>1.1 Reporting Entity Name</label>
		<input type="text" name="reportingEntityName" <%=readOnly%> value="<%=strBankName%>" />
	</div>
	<div class="normalTextField">
		<label>1.2 Reporting Entity Category</label>
		<select name="reportingEntityCategory" tabindex="5" <%=disabled%>>
			<option value="BADCB">BADCB - District Cooperative Banks</option>
			<option value="BAFOR" selected>BAFOR - Foreign Banks</option>
			<option value="BALAB">BALAB - Local Area Banks</option>
			<option value="BANUC">BANUC - Non Scheduled Urban Cooperative Banks</option>
			<option value="BAOTH">BAOTH - Other Banking Company</option>
			<option value="BAPUB">BAPUB - Public Sector Banks</option>
			<option value="BAPVT">BAPVT - Private Sector Banks</option>
			<option value="BARRB">BARRB - Regional Rural Banks</option>
			<option value="BASCO">BASCO - State Cooperative Banks</option>
			<option value="BASUC">BASUC - Scheduled Urban Cooperative Banks</option>
			<option value="CASIN">CASIN - Casinos</option>
			<option value="FIAD1">FIAD1 - Authorized Dealer Category I</option>
			<option value="FIAD2">FIAD2 - Authorized Dealer Category II</option>
			<option value="FIAD3">FIAD3 - Authorized Dealer Category III</option>
			<option value="FIAFI">FIAFI - All India Financial Institutions</option>
			<option value="FICCP">FICCP - Central Counter Party</option>
			<option value="FICFC">FICFC - Chit Fund Companies</option>
			<option value="FISCO">FISCO - card System Operator</option>
			<option value="FIFFM">FIFFM - Full Fledged Money Changer (FFMC)</option>
			<option value="HIFFC">BADCB - Housing Finance Companies</option>
			<option value="HIFPC">BADCB - Hire Purchase Companies</option>
			<option value="FIINL">BADCB - Life Insurance Companies</option>
			<option value="FIINN">BADCB - Non Life Insurance Companies</option>
			<option value="FIMTP">FIMTP - Money Transfer Service Principal</option>
			<option value="FIMTA">FIMTA - Money Transfer Service Agent</option>
			<option value="FINBA">FINBA - NBFC Accepting Deposits</option>
			<option value="FINBN">FINBN - NBFC Not Accepting Deposits</option>
			<option value="FIOTH">FIOTH - Other Financial Institution</option>			
			<option value="INADV">INADV - Investment Advisors</option>
			<option value="INBAN">INBAN - Bankers to an Issue</option>
			<option value="INDBS">INDBS - Derivative Members</option>
			<option value="INBRO">INBRO - Share Brokers</option>
			<option value="INCOL">INCOL - Collective Investments or MF Schemas</option>
			<option value="INCOM">INCOM - Commodity Brokers</option>
			<option value="INCRE">INCRE - Credit Rating Agencies</option>
			<option value="INCUS">INCUS - Custodian Securities</option>
			<option value="INDEP">INDEP - Depositories</option>
			<option value="INDPP">INDPP - Depository Participants</option>
			<option value="INFII">INFII - Foreign Institution Investors</option>
			<option value="INMER">INMER - Merchant Bankers</option>
			<option value="INOTH">INOTH - Other Intermediaries</option>
			<option value="INPOM">INPOM - Portfolio Managers</option>
			<option value="INREG">INREG - Registrars to Issue</option>
			<option value="INRTA">INRTA - Registrars and Transfer Agents</option>
			<option value="INSBR">INSBR - Sub Brokers</option>
			<option value="INSTA">INSTA - Share Transfer Agents</option>
			<option value="INTRU">INTRU - Trustee to Trust Deeds</option>
			<option value="INUND">INUND - Underwriters</option>
			<option value="INVCD">INVCD - Domestic Venture Capital Funds</option>
			<option value="INVCF">INVCF - Foreign Venture Capital Funds</option>
			<option value="XXXXX">XXXXX - Not Categorised</option>
			<option value="ZZZZZ">ZZZZZ - Others</option>

		</select>
	</div>
	<div class="normalTextField left">
		<label>1.3 Reporting Entity Code</label>
		<input type="text" name="reportingEntityCode" <%=readOnly%> value="<%=strBankBSRCode%>" />
	</div>
	<div class="normalTextField right">
		<label>1.4 FIUREID</label>
		<input type="text" name="reportingEntityFIUREID" <%=readOnly%> value="<%=strBankFIUINDID%>" />
	</div>
	
</div>
	<div class="clear"></div>
 
	<div class="section" style="height: 460px;">
	<div class="mainHeader">
	2. Batch Details
	</div>
	<div class="normalTextField">
		<label>2.1 Batch Number</label>
		<input type="text" name="reportingBatchNo" <%=batchReadOnly%> value="<%=strBatchNo%>"/>
	</div>
	<div class="normalTextField">
		<label>2.2 Batch Date</label>
		<input type="text" class="datepicker" name="reportingBatchDate" <%=batchReadOnly%> id="batchDate" value="<%=strDefaultDate1%>"/>
	</div>
	<div class="normalTextField">
		<label>2.3 Batch Pertaining to</label>
		<span style="margin-left: 30%">
			Month <input class="small" type="text" <%=readOnly%> name="reportingBatchPertainingToMonth" value="NA"/>
			Year <input class="small" type="text" <%=readOnly%> name="reportingBatchPertainingToYear" value="NA"/>
		</span>
	</div>
	<div class="normalTextField">
		<label>2.4 Batch Type</label>
		<select name="reportingBatchType" <%=batchDisabled%>>
		    <!-- 
			<option value="N" selected>N - New Report</option>
			<option value="N">D - Deletion Report</option>
			<option value="N">R - Replacement Report</option>
			-->
			<option value="N" <% if(strReportingBatchType.equals("N")) {%>selected<% } %>>N - New Report</option>
			<option value="D" <% if(strReportingBatchType.equals("D")) {%>selected<% } %>>D - Deletion Report</option>
			<option value="R" <% if(strReportingBatchType.equals("R")) {%>selected<% } %>>R - Replacement Report</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>2.5 Original Batch ID</label>
		<input type="text" name="reportingOriginalBatchId" <%=batchReadOnly%> value="<%= strOriginalBatchID %>"/>
	</div>
	<div class="normalTextField">
		<label>2.6 Reason Of Revision</label>
		<%-- <input type="text" name="reasonOfRevision" <%=batchReadOnly%> value="<%=strReasonOfRevision%>"/> --%>
		<select name="reasonOfRevision" <%=batchReadOnly%>>
		    <option value="A" <% if(strReasonOfRevision.equals("A")) {%>selected<% } %>>A - Acknowledgement of original batch had many fatal, non-fatal or
		    probable errors which are being resolved</option>
			<option value="B" <% if(strReasonOfRevision.equals("B")) {%>selected<% } %>>B - Operational errors in original batch have been identified and reports
			are being resolved</option>
			<option value="C" <% if(strReasonOfRevision.equals("C")) {%>selected<% } %>>C - The replacement report is on account of additional information
			being submitted</option>
			<option value="N" <% if(strReasonOfRevision.equals("N")) {%>selected<% } %>>N - Not applicable as this is a new batch</option>
			<option value="Z" <% if(strReasonOfRevision.equals("Z")) {%>selected<% } %>>Z - Other reason</option>
		</select>
	</div>
</div>
</div>