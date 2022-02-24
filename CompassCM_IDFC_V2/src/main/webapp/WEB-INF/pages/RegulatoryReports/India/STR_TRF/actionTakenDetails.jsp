<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<% 
	HttpSession l_CHttpSession = request.getSession(true);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}

	ISTRTRFManualDetailsVO objManualDetailsVO = (ISTRTRFManualDetailsVO)request.getAttribute("ManualFormDTO");
	String[] strSuspiciousGroundsPart8Array = new String[30];
	String l_strBankMLROsName ="";
	String[] strLawAgencyDetailsArray = new String[5];
	String strLawEnforcementInformed = "";

	if(objManualDetailsVO!=null){
		strSuspiciousGroundsPart8Array = objManualDetailsVO.getSusGroundsP8();
        l_strBankMLROsName = (objManualDetailsVO.getPrincipalOfficersName() == null) ? "" : objManualDetailsVO.getPrincipalOfficersName();
		strLawEnforcementInformed = objManualDetailsVO.getLawEnforcementInformed(); 
		strLawAgencyDetailsArray = objManualDetailsVO.getLawEnforcementAgencyDetails();
		if(objManualDetailsVO.getSignatureName() != null) 
		  l_strBankMLROsName = objManualDetailsVO.getSignatureName();
	}
	
%>

    <div class="section">
	<div class="mainHeader">
	7. Details of Action Taken
	</div>
	<div class="normalTextField">
		<label>7.1 Details of Investigation</label>
		<textarea name="Part8susGrounds0" id="Part8susGrounds0" onkeyup="countChar(this,'Part8susGrounds0')" <%=readOnly%> style="height: 400px;"
				maxlength="4000" ><%=(strSuspiciousGroundsPart8Array[0] == null)? "":strSuspiciousGroundsPart8Array[0] %></textarea>
		 <span id="charsDOI" style="margin-left: 4px;">4000 characters remaining out of 4000</span> 
	</div>
	<div class="normalTextField">
		<label>7.2 Was Law Enforcement Agency Informed?</label>
		<div class="checkBoxDiv">
			<span>
				<label for="inre">Information Received</label>
				<input id="inre" type="radio" <%=disabled%> name="lawEnforcementInformed1" <% if(strLawEnforcementInformed != null && strLawEnforcementInformed.indexOf("R") != -1){ %> checked <% } %> value="R" />
			</span>
			<span>
				<label for="inse">Information Sent</label>
				<input id="inse" type="radio" <%=disabled%> name="lawEnforcementInformed1" <% if(strLawEnforcementInformed != null && strLawEnforcementInformed.indexOf("S") != -1){ %> checked <% } %> value="S" />
			</span>
			<span>
				<label for="ncsr">No Correspondence Sent or Received</label>
				<input id="ncsr" type="radio" <%=disabled%> name="lawEnforcementInformed1" <% if(strLawEnforcementInformed == null || strLawEnforcementInformed.indexOf("N") != -1){ %> checked <% } %> value="N" />
			</span>
			<span>
				<label for="noca">Not Categorised</label>
				<input id="noca" type="radio" <%=disabled%> name="lawEnforcementInformed1" <% if(strLawEnforcementInformed == null || strLawEnforcementInformed.indexOf("X") != -1){ %> checked <% } %> value="X" />
			</span>
		</div>
	</div>
	<div class="normalTextField">
		<label>7.3 Law Enforcement Agency Details</label>
		<textarea name="LawEnforcementAgencyDetails0" <%=readOnly%> style="height: 400px;"><%=(strLawAgencyDetailsArray[0] == null)?"":strLawAgencyDetailsArray[0]%></textarea>
	</div>
	
	<div class="normalTextField" style="padding: 20px 0;">
		<span style="float: right; border-top: 1px solid black; margin-right: 30px; width: 300px; text-align: center">
		Signature
		</span>
	</div>
</div>