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
	String readOnly = "disabled";
	String disabled = "readonly";
	if(canUpdated.equals("Y")){
		readOnly = "";
		disabled = "";
	}
	
	HashMap hmBranchDetails = null;
	ISTRTRFBranchDetailsVO objBranchDetailsVO = null;
	
	if((HashMap)request.getAttribute("HmBrnDTO")!=null)
		hmBranchDetails = (HashMap)request.getAttribute("HmBrnDTO");
	
	String strRepRole 	= "";
	String strInstitueName 	=  "";
	String strInstituteBranchName 	= "";
	String strInstituteRefNo = "";
	String strInstituteAddress 	= "";
	String strInstituteCity  = "";
	String strInstituteState  = "";
	String strInstituteCountry = "";
	String strInstitutePin 	= "";
	String strInstituteTelNo 	= "";
	String strInstituteMobNo 	= "";
	String strInstituteFaxNo 	= "";
	String strInstituteEmail 	= "";
	String strInstituteRemarks  = "";
	String strInstituteSeqNo = "";
	
	if(hmBranchDetails!=null)
	{
		objBranchDetailsVO = (ISTRTRFBranchDetailsVO)hmBranchDetails.get("BranchDetailsDTO");
	}

	if(objBranchDetailsVO != null){
	
		strRepRole  			= (objBranchDetailsVO.getRepRole() ==	null) ? "" : objBranchDetailsVO.getRepRole();
		strInstitueName 		= (objBranchDetailsVO.getInstituteName() ==	null) ? "" : objBranchDetailsVO.getInstituteName();
		strInstituteBranchName 	= (objBranchDetailsVO.getInstituteBranchName() ==	null) ? "" : objBranchDetailsVO.getInstituteBranchName();
		strInstituteRefNo 		= (objBranchDetailsVO.getInstituteRefNo() ==	null) ? "" : objBranchDetailsVO.getInstituteRefNo();
		strInstituteAddress 	= (objBranchDetailsVO.getInstituteAddress() ==	null) ? "" : objBranchDetailsVO.getInstituteAddress();
		strInstituteCity 		= (objBranchDetailsVO.getInstituteCity() ==	null) ? "" : objBranchDetailsVO.getInstituteCity();
		strInstituteState 		= (objBranchDetailsVO.getInstituteState() ==	null) ? "" : objBranchDetailsVO.getInstituteState();
		strInstituteCountry 	= (objBranchDetailsVO.getInstituteCountry() ==	null) ? "" : objBranchDetailsVO.getInstituteCountry();
		strInstitutePin 		= (objBranchDetailsVO.getInstitutePin() ==	null) ? "" : objBranchDetailsVO.getInstitutePin();
		strInstituteTelNo		= (objBranchDetailsVO.getInstituteTelNo() ==	null) ? "" : objBranchDetailsVO.getInstituteTelNo();
		strInstituteMobNo 		= (objBranchDetailsVO.getInstituteMobNo() ==	null) ? "" : objBranchDetailsVO.getInstituteMobNo();
		strInstituteFaxNo		= (objBranchDetailsVO.getInstituteFaxNo() ==	null) ? "" : objBranchDetailsVO.getInstituteFaxNo();
		strInstituteEmail 		= (objBranchDetailsVO.getInstituteEmail() ==	null) ? "" : objBranchDetailsVO.getInstituteEmail();
		strInstituteRemarks 	= (objBranchDetailsVO.getInstituteRemarks() ==	null) ? "" : objBranchDetailsVO.getInstituteRemarks();
		strInstituteSeqNo       = (objBranchDetailsVO.getInstituteSeqNo() ==	null) ? "" : objBranchDetailsVO.getInstituteSeqNo();
	}
	String l_disable =(String) request.getAttribute("disable");
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=100" >
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AddNewBranch</title>
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
	});
</script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/strStyle.css">
</head>
<%	
	String IsSaved = (String) request.getAttribute("IsSaved");
	//System.out.println("Inside new legal:"+IsSaved);
	if(IsSaved!=null && IsSaved.equalsIgnoreCase("Yes")){
%>
	<script>
	//opener.document.form1.Type.value='showBlankIndianSTR';
	//opener.document.form1.caseNo.value='<%=caseNo%>';
	//opener.document.form1.submit();
	alert('Branch has been added to the list');
	var caseNo = '<%=caseNo%>';
	//window.opener.location.replace('<%=contextPath%>/IndianRegulatoryReport/str/strMain.jsp?caseNo='+caseNo);
	window.opener.location.reload();
	window.close();
    </script>
<%}%>
<body>
<div class="content">
<form name="NewBranchDetails" action="<%=contextPath%>/common/saveNewINDSTRTRFBranch?${_csrf.parameterName}=${_csrf.token}" method="post">
  <%-- <input type="hidden" name = "BSRCode" value="<%=strBranchBSRCode%>"> --%>
<input type="hidden" name="caseNo" value="<%=caseNo%>">
<input type="hidden" name="branchSeqNo" value="<%=strInstituteSeqNo%>">
<div class="header">
		<table class="header-table">
			<tr>
				<td class="leftside">
					<div class="headerText">Branch Details</div>
				</td>
				<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>BRC</li>
					<li class="last">1</li>
				</ul>
			</td>
			</tr>
		</table>
	</div>
<div class="section" style="height : auto;">
	<div class="normalTextField">
		<label>1. Reporting Role</label>
		<select name="repRole" <%=disabled%>>
			<option value="A" <% if(strRepRole.equals("A")) {%>selected<% } %>>A - Reporting entity itself</option>
			<option value="B" <% if(strRepRole.equals("B")) {%>selected<% } %>>B - Other than reporting entity</option>
			<option value="X" <% if(strRepRole.equals("X")) {%>selected<% } %>>X - Not categorised</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>2. Institution Name</label>
		<input type="text" name="instituteName" <%=readOnly%> value="<%=strInstitueName%>"/>
	</div>
	<div class="normalTextField">
		<label>3. Institution Branch Name</label><br />
		<input type="text" name="instituteBranchName" <%=readOnly%> value="<%=strInstituteBranchName%>"/>
	</div>
	<div class="normalTextField">
		<label>4. Institution Reference Number</label><br />
		<input type="text" name="instituteRefNo" <%=readOnly%> value="<%=strInstituteRefNo%>"/>
	</div>
	<div class="normalTextField">
		<label>5. Address</label>
		<textarea name="instituteAddress" <%=readOnly%>><%=strInstituteAddress%></textarea>
	</div>
	<div class="normalTextField left">
		<label>6. City</label>
		<input type="text" name="instituteCity" <%=readOnly%> value="<%=strInstituteCity%>"/>
	</div>
	<div class="normalTextField right">
		<label>7. State Code</label>
		<%-- <input type="text" name="instituteState" <%=readOnly%> value="<%=strInstituteState%>"/> --%>
		<select name="instituteState">
			<option value="AN" title="Andaman & Nicobar" <% if(strInstituteState.equals("AN")) {%>selected<% } %>>AN- Andaman & Nicobar </option>
			<option value="AP" title="Andhra Pradesh" <% if(strInstituteState.equals("AP")) {%>selected<% } %>>AP- Andhra Pradesh</option>
			<option value="AR" title="Arunachal Pradesh" <% if(strInstituteState.equals("AR")) {%>selected<% } %>>AR- Arunachal Pradesh</option>
			<option value="AS" title="Assam" <% if(strInstituteState.equals("AS")) {%>selected<% } %>>AS- Assam</option>
			<option value="BR" title="Bihar" <% if(strInstituteState.equals("BR")) {%>selected<% } %>>BR- Bihar</option>
			<option value="CH" title="Chandigarh" <% if(strInstituteState.equals("CH")) {%>selected<% } %>>CH- Chandigarh</option>
			<option value="CG" title="Chattisgarh" <% if(strInstituteState.equals("CG")) {%>selected<% } %>>CG- Chattisgarh</option>
			<option value="DN" title="Dadra and Nagar Haveli" <% if(strInstituteState.equals("DN")) {%>selected<% } %>>DN- Dadra and Nagar Haveli</option>
			<option value="DD" title="Daman & Diu" <% if(strInstituteState.equals("DD")) {%>selected<% } %>>DD- Daman & Diu</option>
			<option value="DL" title="Delhi" <% if(strInstituteState.equals("DL")) {%>selected<% } %>>DL- Delhi</option>
			<option value="GA" title="Goa" <% if(strInstituteState.equals("GA")) {%>selected<% } %>>GA- Goa</option>
			<option value="GJ" title="Gujarat" <% if(strInstituteState.equals("GJ")) {%>selected<% } %>>GJ- Gujarat</option>
			<option value="HR" title="Haryana" <% if(strInstituteState.equals("HR")) {%>selected<% } %>>HR- Haryana</option>
			<option value="HP" title="Himachal Pradesh" <% if(strInstituteState.equals("HP")) {%>selected<% } %>>HP- Himachal Pradesh</option>
			<option value="JK" title="Jammu & Kashmir" <% if(strInstituteState.equals("JK")) {%>selected<% } %>>JK- Jammu & Kashmir</option>
			<option value="JH" title="Jharkhand" <% if(strInstituteState.equals("JH")) {%>selected<% } %>>JH- Jharkhand</option>
			<option value="KA" title="Karnataka" <% if(strInstituteState.equals("KA")) {%>selected<% } %>>KA- Karnataka</option>
			<option value="KL" title="Kerala" <% if(strInstituteState.equals("KL")) {%>selected<% } %>>KL- Kerala</option>
			<option value="LD" title="Lakshadweep" <% if(strInstituteState.equals("LD")) {%>selected<% } %>>LD- Lakshadweep</option>
			<option value="MP" title="Madhya Pradesh" <% if(strInstituteState.equals("MP")) {%>selected<% } %>>MP- Madhya Pradesh</option>
			<option value="MH" title="Maharashtra" <% if(strInstituteState.equals("MH")) {%>selected<% } %>>MH- Maharashtra</option>
			<option value="MN" title="Manipur" <% if(strInstituteState.equals("MN")) {%>selected<% } %>>MN- Manipur</option>
			<option value="ML" title="Meghalaya" <% if(strInstituteState.equals("ML")) {%>selected<% } %>>ML- Meghalaya</option>
			<option value="MZ" title="Mizoram" <% if(strInstituteState.equals("MZ")) {%>selected<% } %>>MZ- Mizoram</option>
			<option value="NL" title="Nagaland" <% if(strInstituteState.equals("NL")) {%>selected<% } %>>NL- Nagaland</option>
			<option value="OR" title="Orissa" <% if(strInstituteState.equals("OR")) {%>selected<% } %>>OR- Orissa</option>
			<option value="PY" title="Pondicherry" <% if(strInstituteState.equals("PY")) {%>selected<% } %>>PY- Pondicherry</option>
			<option value="PB" title="Punjab" <% if(strInstituteState.equals("PB")) {%>selected<% } %>>PB- Punjab</option>
			<option value="RJ" title="Rajasthan" <% if(strInstituteState.equals("RJ")) {%>selected<% } %>>RJ- Rajasthan</option>
			<option value="SK" title="Sikkim" <% if(strInstituteState.equals("SK")) {%>selected<% } %>>SK- Sikkim</option>
			<option value="TN" title="Tamil Nadu" <% if(strInstituteState.equals("TN")) {%>selected<% } %>>TN- Tamil Nadu</option>
			<option value="TR" title="Tripura" <% if(strInstituteState.equals("TR")) {%>selected<% } %>>TR- Tripura</option>
			<option value="UP" title="Uttar Pradesh" <% if(strInstituteState.equals("UP")) {%>selected<% } %>>UP- Uttar Pradesh</option>
			<option value="UA" title="Uttarakhand" <% if(strInstituteState.equals("UA")) {%>selected<% } %>>UA- Uttarakhand</option>
			<option value="WB" title="West Bengal" <% if(strInstituteState.equals("WB")) {%>selected<% } %>>WB- West Bengal</option>
			<option value="ZZ" title="Others" <% if(strInstituteState.equals("ZZ")) {%>selected<% } %>>ZZ- Others</option>
			<option value="XX" title="Not Applicable" <% if(strInstituteState.equals("XX")) {%>selected<% } %>>XX -Not Applicable</option>
		</select>
	</div>
	<div class="normalTextField left">
		<label>8. Country Code</label>
		<%-- <input type="text" name="repAddressCountry" <%=readOnly%> value="IN"/> --%>
			<select name="instituteCountry">
				<option value="IN" title="India" <% if(strInstituteCountry.equals("IN")) {%>selected<% } %>>IN-India</option>		
				<option value="AF" title="Afghanistan" <% if(strInstituteCountry.equals("AF")) {%>selected<% } %>>AF-Afghanistan</option>
				<option value="AX" title="Aland Islands" <% if(strInstituteCountry.equals("AX")) {%>selected<% } %>>AX-Aland Islands</option>
				<option value="AL" title="Albania" <% if(strInstituteCountry.equals("AL")) {%>selected<% } %>>AL-Albania</option>
				<option value="DZ" title="Algeria" <% if(strInstituteCountry.equals("DZ")) {%>selected<% } %>>DZ-Algeria</option>
				<option value="AS" title="American Samoa" <% if(strInstituteCountry.equals("AS")) {%>selected<% } %>>AS-American Samoa</option>
				<option value="AD" title="Andorra" <% if(strInstituteCountry.equals("AD")) {%>selected<% } %>>AD-Andorra</option>
				<option value="AO" title="Angola" <% if(strInstituteCountry.equals("AO")) {%>selected<% } %>>AO-Angola</option>
				<option value="AI" title="Anguilla" <% if(strInstituteCountry.equals("AI")) {%>selected<% } %>>AI-Anguilla</option>
				<option value="AQ" title="Antarctica" <% if(strInstituteCountry.equals("AQ")) {%>selected<% } %>>AQ-Antarctica</option>
				<option value="AG" title="Antigua And Barbuda" <% if(strInstituteCountry.equals("AG")) {%>selected<% } %>>AG-Antigua And Barbuda</option>
				<option value="AR" title="Argentina" <% if(strInstituteCountry.equals("AR")) {%>selected<% } %>>AR-Argentina</option>
				<option value="AM" title="Armenia" <% if(strInstituteCountry.equals("AM")) {%>selected<% } %>>AM-Armenia</option>
				<option value="AW" title="Aruba" <% if(strInstituteCountry.equals("AW")) {%>selected<% } %>>AW-Aruba</option>
				<option value="AU" title="Australia" <% if(strInstituteCountry.equals("AU")) {%>selected<% } %>>AU-Australia</option>
				<option value="AT" title="Austria" <% if(strInstituteCountry.equals("AT")) {%>selected<% } %>>AT-Austria</option>
				<option value="AZ" title="Azerbaijan" <% if(strInstituteCountry.equals("AZ")) {%>selected<% } %>>AZ-Azerbaijan</option>
				<option value="BS" title="Bahamas" <% if(strInstituteCountry.equals("BS")) {%>selected<% } %>>BS-Bahamas</option>
				<option value="BH" title="Bahrain" <% if(strInstituteCountry.equals("BH")) {%>selected<% } %>>BH-Bahrain</option>
				<option value="BD" title="Bangladesh" <% if(strInstituteCountry.equals("BD")) {%>selected<% } %>>BD-Bangladesh</option>
				<option value="BB" title="Barbados" <% if(strInstituteCountry.equals("BB")) {%>selected<% } %>>BB-Barbados</option>
				<option value="BY" title="Belarus" <% if(strInstituteCountry.equals("BY")) {%>selected<% } %>>BY-Belarus</option>
				<option value="BE" title="Belgium" <% if(strInstituteCountry.equals("BE")) {%>selected<% } %>>BE-Belgium</option>
				<option value="BZ" title="Belize" <% if(strInstituteCountry.equals("BZ")) {%>selected<% } %>>BZ-Belize</option>
				<option value="BJ" title="Benin" <% if(strInstituteCountry.equals("BJ")) {%>selected<% } %>>BJ-Benin</option>
				<option value="BM" title="Bermuda" <% if(strInstituteCountry.equals("BM")) {%>selected<% } %>>BM-Bermuda</option>
				<option value="BT" title="Bhutan" <% if(strInstituteCountry.equals("BT")) {%>selected<% } %>>BT-Bhutan</option>
				<option value="BO" title="Bolivia" <% if(strInstituteCountry.equals("BO")) {%>selected<% } %>>BO-Bolivia</option>
				<option value="BA" title="Bosnia And Herzegovina" <% if(strInstituteCountry.equals("BA")) {%>selected<% } %>>BA-Bosnia And Herzegovina</option>
				<option value="BW" title="Botswana" <% if(strInstituteCountry.equals("BW")) {%>selected<% } %>>BW-Botswana</option>
				<option value="BV" title="Bouvet Island" <% if(strInstituteCountry.equals("BV")) {%>selected<% } %>>BV-Bouvet Island</option>
				<option value="BR" title="Brazil" <% if(strInstituteCountry.equals("BR")) {%>selected<% } %>>BR-Brazil</option>
				<option value="IO" title="British Indian Ocean Territory" <% if(strInstituteCountry.equals("IO")) {%>selected<% } %>>IO-British Indian Ocean Territory</option>
				<option value="BN" title="Brunei Darussalam" <% if(strInstituteCountry.equals("BN")) {%>selected<% } %>>BN-Brunei Darussalam</option>
				<option value="BG" title="Bulgaria" <% if(strInstituteCountry.equals("BG")) {%>selected<% } %>>BG-Bulgaria</option>
				<option value="BF" title="Burkina Faso" <% if(strInstituteCountry.equals("BF")) {%>selected<% } %>>BF-Burkina Faso</option>
				<option value="BI" title="Burundi" <% if(strInstituteCountry.equals("BI")) {%>selected<% } %>>BI-Burundi</option>
				<option value="KH" title="Cambodia" <% if(strInstituteCountry.equals("KH")) {%>selected<% } %>>KH-Cambodia</option>
				<option value="CM" title="Cameroon" <% if(strInstituteCountry.equals("CM")) {%>selected<% } %>>CM-Cameroon</option>
				<option value="CA" title="Canada" <% if(strInstituteCountry.equals("CA")) {%>selected<% } %>>CA-Canada</option>
				<option value="CV" title="Cape Verde" <% if(strInstituteCountry.equals("CV")) {%>selected<% } %>>CV-Cape Verde</option>
				<option value="KY" title="Cayman Islands" <% if(strInstituteCountry.equals("KY")) {%>selected<% } %>>KY-Cayman Islands</option>
				<option value="CF" title="Central African Republic" <% if(strInstituteCountry.equals("CF")) {%>selected<% } %>>CF-Central African Republic</option>
				<option value="TD" title="Chad" <% if(strInstituteCountry.equals("TD")) {%>selected<% } %>>TD-Chad</option>
				<option value="CL" title="Chile" <% if(strInstituteCountry.equals("CL")) {%>selected<% } %>>CL-Chile</option>
				<option value="CN" title="China" <% if(strInstituteCountry.equals("CN")) {%>selected<% } %>>CN-China</option>
				<option value="CX" title="Christmas Island" <% if(strInstituteCountry.equals("CX")) {%>selected<% } %>>CX-Christmas Island</option>
				<option value="CC" title="Cocos (Keeling) Islands" <% if(strInstituteCountry.equals("CC")) {%>selected<% } %>>CC-Cocos (Keeling) Islands</option>
				<option value="CO" title="Colombia" <% if(strInstituteCountry.equals("CO")) {%>selected<% } %>>CO-Colombia</option>
				<option value="KM" title="Comoros" <% if(strInstituteCountry.equals("KM")) {%>selected<% } %>>KM-Comoros</option>
				<option value="CG" title="Congo" <% if(strInstituteCountry.equals("CG")) {%>selected<% } %>>CG-Congo</option>
				<option value="CD" title="Congo,Democratic Republic" <% if(strInstituteCountry.equals("CD")) {%>selected<% } %>>CD-Congo,Democratic Republic</option>
				<option value="CK" title="Cook Islands" <% if(strInstituteCountry.equals("CK")) {%>selected<% } %>>CK-Cook Islands</option>
				<option value="CR" title="Costa Rica" <% if(strInstituteCountry.equals("CR")) {%>selected<% } %>>CR-Costa Rica</option>
				<option value="CI" title="Côte D'ivoire" <% if(strInstituteCountry.equals("CI")) {%>selected<% } %>>CI-Côte D'ivoire</option>
				<option value="HR" title="Croatia" <% if(strInstituteCountry.equals("HR")) {%>selected<% } %>>HR-Croatia</option>
				<option value="CU" title="Cuba" <% if(strInstituteCountry.equals("CU")) {%>selected<% } %>>CU-Cuba</option>
				<option value="CY" title="Cyprus" <% if(strInstituteCountry.equals("CY")) {%>selected<% } %>>CY-Cyprus</option>
				<option value="CZ" title="Czech Republic" <% if(strInstituteCountry.equals("CZ")) {%>selected<% } %>>CZ-Czech Republic</option>
				<option value="DK" title="Denmark" <% if(strInstituteCountry.equals("DK")) {%>selected<% } %>>DK-Denmark</option>
				<option value="DJ" title="Djibouti" <% if(strInstituteCountry.equals("DJ")) {%>selected<% } %>>DJ-Djibouti</option>
				<option value="DM" title="Dominica" <% if(strInstituteCountry.equals("DM")) {%>selected<% } %>>DM-Dominica</option>
				<option value="DO" title="Dominican Republic" <% if(strInstituteCountry.equals("DO")) {%>selected<% } %>>DO-Dominican Republic</option>
				<option value="EC" title="Ecuador" <% if(strInstituteCountry.equals("EC")) {%>selected<% } %>>EC-Ecuador</option>
				<option value="EG" title="Egypt" <% if(strInstituteCountry.equals("EG")) {%>selected<% } %>>EG-Egypt</option>
				<option value="SV" title="El Ssalvador" <% if(strInstituteCountry.equals("SV")) {%>selected<% } %>>SV-El Ssalvador</option>
				<option value="GQ" title="Equatorial Guinea" <% if(strInstituteCountry.equals("GQ")) {%>selected<% } %>>GQ-Equatorial Guinea</option>
				<option value="ER" title="Eritrea" <% if(strInstituteCountry.equals("ER")) {%>selected<% } %>>ER-Eritrea</option>
				<option value="EE" title="Estonia" <% if(strInstituteCountry.equals("EE")) {%>selected<% } %>>EE-Estonia</option>
				<option value="ET" title="Ethiopia" <% if(strInstituteCountry.equals("ET")) {%>selected<% } %>>ET-Ethiopia</option>
				<option value="FK" title="Falkland Islands (Malvinas)" <% if(strInstituteCountry.equals("FK")) {%>selected<% } %>>FK-Falkland Islands (Malvinas)</option>
				<option value="FO" title="Faroe Islands" <% if(strInstituteCountry.equals("FO")) {%>selected<% } %>>FO-Faroe Islands</option>
				<option value="FJ" title="Fiji" <% if(strInstituteCountry.equals("FJ")) {%>selected<% } %>>FJ-Fiji</option>
				<option value="FI" title="Finland" <% if(strInstituteCountry.equals("FI")) {%>selected<% } %>>FI-Finland</option>
				<option value="FR" title="France" <% if(strInstituteCountry.equals("FR")) {%>selected<% } %>>FR-France</option>
				<option value="GF" title="French Guiana" <% if(strInstituteCountry.equals("GF")) {%>selected<% } %>>GF-French Guiana</option>
				<option value="PF" title="French Polynesia" <% if(strInstituteCountry.equals("PF")) {%>selected<% } %>>PF-French Polynesia</option>
				<option value="TF" title="French Southern Territories" <% if(strInstituteCountry.equals("TF")) {%>selected<% } %>>TF-French Southern Territories</option>
				<option value="GA" title="Gabon" <% if(strInstituteCountry.equals("GA")) {%>selected<% } %>>GA-Gabon</option>
				<option value="GM" title="Gambia" <% if(strInstituteCountry.equals("GM")) {%>selected<% } %>>GM-Gambia</option>
				<option value="GE" title="Georgia" <% if(strInstituteCountry.equals("GE")) {%>selected<% } %>>GE-Georgia</option>
				<option value="DE" title="Germany" <% if(strInstituteCountry.equals("DE")) {%>selected<% } %>>DE-Germany</option>
				<option value="GH" title="Ghana" <% if(strInstituteCountry.equals("GH")) {%>selected<% } %>>GH-Ghana</option>
				<option value="GI" title="Gibraltar" <% if(strInstituteCountry.equals("GI")) {%>selected<% } %>>GI-Gibraltar</option>
				<option value="GR" title="Greece" <% if(strInstituteCountry.equals("GR")) {%>selected<% } %>>GR-Greece</option>
				<option value="GL" title="Greenland" <% if(strInstituteCountry.equals("GL")) {%>selected<% } %>>GL-Greenland</option>
				<option value="GD" title="Grenada" <% if(strInstituteCountry.equals("GD")) {%>selected<% } %>>GD-Grenada</option>
				<option value="GP" title="Guadeloupe" <% if(strInstituteCountry.equals("GP")) {%>selected<% } %>>GP-Guadeloupe</option>
				<option value="GU" title="Guam" <% if(strInstituteCountry.equals("GU")) {%>selected<% } %>>GU-Guam</option>
				<option value="GT" title="Guatemala" <% if(strInstituteCountry.equals("GT")) {%>selected<% } %>>GT-Guatemala</option>
				<option value="GG" title="Guernsey" <% if(strInstituteCountry.equals("GG")) {%>selected<% } %>>GG-Guernsey</option>
				<option value="GN" title="Guinea" <% if(strInstituteCountry.equals("GN")) {%>selected<% } %>>GN-Guinea</option>
				<option value="GW" title="Guinea-Bisaau" title="Bissau" <% if(strInstituteCountry.equals("GW")) {%>selected<% } %>>GW-Guinea-Bissau</option>
				<option value="GY" title="Guyana" <% if(strInstituteCountry.equals("GY")) {%>selected<% } %>>GY-Guyana</option>
				<option value="HT" title="Haiti" <% if(strInstituteCountry.equals("HT")) {%>selected<% } %>>HT-Haiti</option>
				<option value="HM" title="Heard Island And Mcdonald Islands" <% if(strInstituteCountry.equals("HM")) {%>selected<% } %>>HM-Heard Island And Mcdonald Islands</option>
				<option value="VA" title="Vatican City State" <% if(strInstituteCountry.equals("VA")) {%>selected<% } %>>VA-Vatican City State</option>
				<option value="HN" title="Honduras" <% if(strInstituteCountry.equals("HN")) {%>selected<% } %>>HN-Honduras</option>
				<option value="HK" title="Hong Kong" <% if(strInstituteCountry.equals("HK")) {%>selected<% } %>>HK-Hong Kong</option>
				<option value="HU" title="Hungary" <% if(strInstituteCountry.equals("HU")) {%>selected<% } %>>HU-Hungary</option>
				<option value="IS" title="Iceland" <% if(strInstituteCountry.equals("IS")) {%>selected<% } %>>IS-Iceland</option>
				<option value="ID" title="Indonesia" <% if(strInstituteCountry.equals("ID")) {%>selected<% } %>>ID-Indonesia</option>
				<option value="IR" title="Iran" <% if(strInstituteCountry.equals("IR")) {%>selected<% } %>>IR-Iran</option>
				<option value="IQ" title="Iraq" <% if(strInstituteCountry.equals("IQ")) {%>selected<% } %>>IQ-Iraq</option>
				<option value="IE" title="Ireland" <% if(strInstituteCountry.equals("IE")) {%>selected<% } %>>IE-Ireland</option>
				<option value="IM" title="Isle Of Man" <% if(strInstituteCountry.equals("IM")) {%>selected<% } %>>IM-Isle Of Man</option>
				<option value="IL" title="Israel" <% if(strInstituteCountry.equals("IL")) {%>selected<% } %>>IL-Israel</option>
				<option value="IT" title="Italy" <% if(strInstituteCountry.equals("IT")) {%>selected<% } %>>IT-Italy</option>
				<option value="JM" title="Jamaica" <% if(strInstituteCountry.equals("JM")) {%>selected<% } %>>JM-Jamaica</option>
				<option value="JP" title="Japan" <% if(strInstituteCountry.equals("JP")) {%>selected<% } %>>JP-Japan</option>
				<option value="JE" title="Jersey" <% if(strInstituteCountry.equals("JE")) {%>selected<% } %>>JE-Jersey</option>
				<option value="JO" title="Jordan" <% if(strInstituteCountry.equals("JO")) {%>selected<% } %>>JO-Jordan</option>
				<option value="KZ" title="Kazakhstan" <% if(strInstituteCountry.equals("KZ")) {%>selected<% } %>>KZ-Kazakhstan</option>
				<option value="KE" title="Kenya" <% if(strInstituteCountry.equals("KE")) {%>selected<% } %>>KE-Kenya</option>
				<option value="KI" title="Kiribati" <% if(strInstituteCountry.equals("KI")) {%>selected<% } %>>KI-Kiribati</option>
				<option value="KP" title="Korea, Democratic People's Republic" <% if(strInstituteCountry.equals("KP")) {%>selected<% } %>>KP-Korea, Democratic People's Republic</option>
				<option value="KR" title="Korea" <% if(strInstituteCountry.equals("KR")) {%>selected<% } %>>KR-Korea</option>
				<option value="KW" title="Kuwait" <% if(strInstituteCountry.equals("KW")) {%>selected<% } %>>KW-Kuwait</option>
				<option value="KG" title="Kyrgyzstan" <% if(strInstituteCountry.equals("KG")) {%>selected<% } %>>KG-Kyrgyzstan</option>
				<option value="LA" title="Lao People's Democratic Republic" <% if(strInstituteCountry.equals("LA")) {%>selected<% } %>>LA-Lao People's Democratic Republic</option>
				<option value="LV" title="Latvia" <% if(strInstituteCountry.equals("LV")) {%>selected<% } %>>LV-Latvia</option>
				<option value="LB" title="Lebanon" <% if(strInstituteCountry.equals("LB")) {%>selected<% } %>>LB-Lebanon</option>
				<option value="LS" title="Lesotho" <% if(strInstituteCountry.equals("LS")) {%>selected<% } %>>LS-Lesotho</option>
				<option value="LR" title="Liberia" <% if(strInstituteCountry.equals("LR")) {%>selected<% } %>>LR-Liberia</option>
				<option value="LY" title="Libyan Arab Jamahiriya" <% if(strInstituteCountry.equals("LY")) {%>selected<% } %>>LY-Libyan Arab Jamahiriya</option>
				<option value="LI" title="Liechtenstein" <% if(strInstituteCountry.equals("LI")) {%>selected<% } %>>LI-Liechtenstein</option>
				<option value="LT" title="Lithuania" <% if(strInstituteCountry.equals("LT")) {%>selected<% } %>>LT-Lithuania</option>
				<option value="LU" title="Luxembourg" <% if(strInstituteCountry.equals("LU")) {%>selected<% } %>>LU-Luxembourg</option>
				<option value="MO" title="Macao" <% if(strInstituteCountry.equals("MO")) {%>selected<% } %>>MO-Macao</option>
				<option value="MK" title="Macedonia, The Former Yugoslav Repub" <% if(strInstituteCountry.equals("MK")) {%>selected<% } %>>MK-Macedonia, The Former Yugoslav Repub</option>
				<option value="MG" title="Madagascar" <% if(strInstituteCountry.equals("MG")) {%>selected<% } %>>MG-Madagascar</option>
				<option value="MW" title="Malawi" <% if(strInstituteCountry.equals("MW")) {%>selected<% } %>>MW-Malawi</option>
				<option value="MY" title="Malaysia" <% if(strInstituteCountry.equals("MY")) {%>selected<% } %>>MY-Malaysia</option>
				<option value="MV" title="Maldives" <% if(strInstituteCountry.equals("MV")) {%>selected<% } %>>MV-Maldives</option>
				<option value="ML" title="Mali" <% if(strInstituteCountry.equals("ML")) {%>selected<% } %>>ML-Mali</option>
				<option value="MT" title="Malta" <% if(strInstituteCountry.equals("MT")) {%>selected<% } %>>MT-Malta</option>
				<option value="MH" title="Marshall Islands" <% if(strInstituteCountry.equals("MH")) {%>selected<% } %>>MH-Marshall Islands</option>
				<option value="MQ" title="Martinique" <% if(strInstituteCountry.equals("MQ")) {%>selected<% } %>>MQ-Martinique</option>
				<option value="MR" title="Mauritania" <% if(strInstituteCountry.equals("MR")) {%>selected<% } %>>MR-Mauritania</option>
				<option value="MU" title="Mauritius" <% if(strInstituteCountry.equals("MU")) {%>selected<% } %>>MU-Mauritius</option>
				<option value="YT" title="Mayotte" <% if(strInstituteCountry.equals("YT")) {%>selected<% } %>>YT-Mayotte</option>
				<option value="MX" title="Mexico" <% if(strInstituteCountry.equals("MX")) {%>selected<% } %>>MX-Mexico</option>
				<option value="FM" title="Micronesia" <% if(strInstituteCountry.equals("FM")) {%>selected<% } %>>FM-Micronesia</option>
				<option value="MD" title="Moldova" <% if(strInstituteCountry.equals("MD")) {%>selected<% } %>>MD-Moldova</option>
				<option value="MC" title="Monaco" <% if(strInstituteCountry.equals("MC")) {%>selected<% } %>>MC-Monaco</option>
				<option value="MN" title="Mongolia" <% if(strInstituteCountry.equals("MN")) {%>selected<% } %>>MN-Mongolia</option>
				<option value="ME" title="Montenegro" <% if(strInstituteCountry.equals("ME")) {%>selected<% } %>>ME-Montenegro</option>
				<option value="MS" title="Montserrat" <% if(strInstituteCountry.equals("MS")) {%>selected<% } %>>MS-Montserrat</option>
				<option value="MA" title="Morocco" <% if(strInstituteCountry.equals("MA")) {%>selected<% } %>>MA-Morocco</option>
				<option value="MZ" title="Mozambique" <% if(strInstituteCountry.equals("MZ")) {%>selected<% } %>>MZ-Mozambique</option>
				<option value="MM" title="Myanmar" <% if(strInstituteCountry.equals("MM")) {%>selected<% } %>>MM-Myanmar</option>
				<option value="NA" title="Namibia" <% if(strInstituteCountry.equals("NA")) {%>selected<% } %>>NA-Namibia</option>
				<option value="NR" title="Nauru" <% if(strInstituteCountry.equals("NR")) {%>selected<% } %>>NR-Nauru</option>
				<option value="NP" title="Nepal" <% if(strInstituteCountry.equals("NP")) {%>selected<% } %>>NP-Nepal</option>
				<option value="NL" title="Netherlands" <% if(strInstituteCountry.equals("NL")) {%>selected<% } %>>NL-Netherlands</option>
				<option value="AN" title="Netherlands Antilles" <% if(strInstituteCountry.equals("AN")) {%>selected<% } %>>AN-Netherlands Antilles</option>
				<option value="NC" title="New Caledonia" <% if(strInstituteCountry.equals("NC")) {%>selected<% } %>>NC-New Caledonia</option>
				<option value="NZ" title="New Zealand" <% if(strInstituteCountry.equals("NZ")) {%>selected<% } %>>NZ-New Zealand</option>
				<option value="NI" title="Nicaragua" <% if(strInstituteCountry.equals("NI")) {%>selected<% } %>>NI-Nicaragua</option>
				<option value="NE" title="Niger" <% if(strInstituteCountry.equals("NE")) {%>selected<% } %>>NE-Niger</option>
				<option value="NG" title="Nigeria" <% if(strInstituteCountry.equals("NG")) {%>selected<% } %>>NG-Nigeria</option>
				<option value="NU" title="Niue" <% if(strInstituteCountry.equals("NU")) {%>selected<% } %>>NU-Niue</option>
				<option value="NF" title="Norfolk Island" <% if(strInstituteCountry.equals("NF")) {%>selected<% } %>>NF-Norfolk Island</option>
				<option value="MP" title="Northern Mariana Islands" <% if(strInstituteCountry.equals("MP")) {%>selected<% } %>>MP-Northern Mariana Islands</option>
				<option value="NO" title="Norway" <% if(strInstituteCountry.equals("NO")) {%>selected<% } %>>NO-Norway</option>
				<option value="OM" title="Oman" <% if(strInstituteCountry.equals("OM")) {%>selected<% } %>>OM-Oman</option>
				<option value="PK" title="Pakistan" <% if(strInstituteCountry.equals("PK")) {%>selected<% } %>>PK-Pakistan</option>
				<option value="PW" title="Palau" <% if(strInstituteCountry.equals("PW")) {%>selected<% } %>>PW-Palau</option>
				<option value="PS" title="Palestinian Territory, Occupied" <% if(strInstituteCountry.equals("PS")) {%>selected<% } %>>PS-Palestinian Territory, Occupied</option>
				<option value="PA" title="Panama" <% if(strInstituteCountry.equals("PA")) {%>selected<% } %>>PA-Panama</option>
				<option value="PG" title="Papua New Guinea" <% if(strInstituteCountry.equals("PG")) {%>selected<% } %>>PG-Papua New Guinea</option>
				<option value="PY" title="Paraguay" <% if(strInstituteCountry.equals("PY")) {%>selected<% } %>>PY-Paraguay</option>
				<option value="PE" title="Peru" <% if(strInstituteCountry.equals("PE")) {%>selected<% } %>>PE-Peru</option>
				<option value="PH" title="Philippines" <% if(strInstituteCountry.equals("PH")) {%>selected<% } %>>PH-Philippines</option>
				<option value="PN" title="Pitcairn" <% if(strInstituteCountry.equals("PN")) {%>selected<% } %>>PN-Pitcairn</option>
				<option value="PL" title="Poland" <% if(strInstituteCountry.equals("PL")) {%>selected<% } %>>PL-Poland</option>
				<option value="PT" title="Portugal" <% if(strInstituteCountry.equals("PT")) {%>selected<% } %>>PT-Portugal</option>
				<option value="PR" title="Puerto Rico" <% if(strInstituteCountry.equals("PR")) {%>selected<% } %>>PR-Puerto Rico</option>
				<option value="QA" title="Qatar" <% if(strInstituteCountry.equals("QA")) {%>selected<% } %>>QA-Qatar</option>
				<option value="RE" title="Réunion" <% if(strInstituteCountry.equals("RE")) {%>selected<% } %>>RE-Réunion</option>
				<option value="RO" title="Romania" <% if(strInstituteCountry.equals("RO")) {%>selected<% } %>>RO-Romania</option>
				<option value="RU" title="Russian Federation" <% if(strInstituteCountry.equals("RU")) {%>selected<% } %>>RU-Russian Federation</option>
				<option value="RW" title="Rwanda" <% if(strInstituteCountry.equals("RW")) {%>selected<% } %>>RW-Rwanda</option>
				<option value="BL" title="Saint Barthélemy" <% if(strInstituteCountry.equals("BL")) {%>selected<% } %>>BL-Saint Barthélemy</option>
				<option value="SH" title="Saint Helena, Ascension And Tristan" <% if(strInstituteCountry.equals("SH")) {%>selected<% } %>>SH-Saint Helena, Ascension And Tristan</option>
				<option value="KN" title="Saint Kitts And Nevis" <% if(strInstituteCountry.equals("KN")) {%>selected<% } %>>KN-Saint Kitts And Nevis</option>
				<option value="LC" title="Saint Lucia" <% if(strInstituteCountry.equals("LC")) {%>selected<% } %>>LC-Saint Lucia</option>
				<option value="MF" title="Saint Martin" <% if(strInstituteCountry.equals("MF")) {%>selected<% } %>>MF-Saint Martin</option>
				<option value="PM" title="Saint Pierre And Miquelon" <% if(strInstituteCountry.equals("PM")) {%>selected<% } %>>PM-Saint Pierre And Miquelon</option>
				<option value="VC" title="Saint Vincent And The Grenadines" <% if(strInstituteCountry.equals("VC")) {%>selected<% } %>>VC-Saint Vincent And The Grenadines</option>
				<option value="WS" title="Samoa" <% if(strInstituteCountry.equals("WS")) {%>selected<% } %>>WS-Samoa</option>
				<option value="SM" title="San Marino" <% if(strInstituteCountry.equals("SM")) {%>selected<% } %>>SM-San Marino</option>
				<option value="ST" title="Sao Tome And Principe" <% if(strInstituteCountry.equals("ST")) {%>selected<% } %>>ST-Sao Tome And Principe</option>
				<option value="SA" title="Saudi Arabia" <% if(strInstituteCountry.equals("SA")) {%>selected<% } %>>SA-Saudi Arabia</option>
				<option value="SN" title="Senegal" <% if(strInstituteCountry.equals("SN")) {%>selected<% } %>>SN-Senegal</option>
				<option value="RS" title="Serbia" <% if(strInstituteCountry.equals("RS")) {%>selected<% } %>>RS-Serbia</option>
				<option value="SC" title="Seychelles" <% if(strInstituteCountry.equals("SC")) {%>selected<% } %>>SC-Seychelles</option>
				<option value="SL" title="Sierra Leone" <% if(strInstituteCountry.equals("SL")) {%>selected<% } %>>SL-Sierra Leone</option>
				<option value="SG" title="Singapore" <% if(strInstituteCountry.equals("SG")) {%>selected<% } %>>SG-Singapore</option>
				<option value="SK" title="Slovakia" <% if(strInstituteCountry.equals("SK")) {%>selected<% } %>>SK-Slovakia</option>
				<option value="SI" title="Slovenia" <% if(strInstituteCountry.equals("SI")) {%>selected<% } %>>SI-Slovenia</option>
				<option value="SB" title="Solomon Islands" <% if(strInstituteCountry.equals("SB")) {%>selected<% } %>>SB-Solomon Islands</option>
				<option value="SO" title="Somalia" <% if(strInstituteCountry.equals("SO")) {%>selected<% } %>>SO-Somalia</option>
				<option value="ZA" title="South Africa" <% if(strInstituteCountry.equals("ZA")) {%>selected<% } %>>ZA-South Africa</option>
				<option value="GS" title="South Georgia And The South Sandwich" <% if(strInstituteCountry.equals("GS")) {%>selected<% } %>>GS-South Georgia And The South Sandwich</option>
				<option value="ES" title="Spain" <% if(strInstituteCountry.equals("ES")) {%>selected<% } %>>ES-Spain</option>
				<option value="LK" title="Sri Lanka" <% if(strInstituteCountry.equals("LK")) {%>selected<% } %>>LK-Sri Lanka</option>
				<option value="SD" title="Sudan" <% if(strInstituteCountry.equals("SD")) {%>selected<% } %>>SD-Sudan</option>
				<option value="SR" title="Suriname" <% if(strInstituteCountry.equals("SR")) {%>selected<% } %>>SR-Suriname</option>
				<option value="SJ" title="Svalbard And Jan Mayen" <% if(strInstituteCountry.equals("SJ")) {%>selected<% } %>>SJ-Svalbard And Jan Mayen</option>
				<option value="SZ" title="Swaziland" <% if(strInstituteCountry.equals("SZ")) {%>selected<% } %>>SZ-Swaziland</option>
				<option value="SE" title="Sweden" <% if(strInstituteCountry.equals("SE")) {%>selected<% } %>>SE-Sweden</option>
				<option value="CH" title="Switzerland" <% if(strInstituteCountry.equals("CH")) {%>selected<% } %>>CH-Switzerland</option>
				<option value="SY" title="Syrian Arab Republic" <% if(strInstituteCountry.equals("SY")) {%>selected<% } %>>SY-Syrian Arab Republic</option>
				<option value="TW" title="Taiwan, Province Of China" <% if(strInstituteCountry.equals("TW")) {%>selected<% } %>>TW-Taiwan, Province Of China</option>
				<option value="TJ" title="Tajikistan" <% if(strInstituteCountry.equals("TJ")) {%>selected<% } %>>TJ-Tajikistan</option>
				<option value="TZ" title="Tanzania" <% if(strInstituteCountry.equals("TZ")) {%>selected<% } %>>TZ-Tanzania</option>
				<option value="TH" title="Thailand" <% if(strInstituteCountry.equals("TH")) {%>selected<% } %>>TH-Thailand</option>
				<option value="TL" title="Timor" title="Leste" <% if(strInstituteCountry.equals("TL")) {%>selected<% } %>>TL-Timor-Leste</option>
				<option value="TG" title="Togo" <% if(strInstituteCountry.equals("TG")) {%>selected<% } %>>TG-Togo</option>
				<option value="TK" title="Tokelau" <% if(strInstituteCountry.equals("TK")) {%>selected<% } %>>TK-Tokelau</option>
				<option value="TO" title="Tonga" <% if(strInstituteCountry.equals("TO")) {%>selected<% } %>>TO-Tonga</option>
				<option value="TT" title="Trinidad And Tobago" <% if(strInstituteCountry.equals("TT")) {%>selected<% } %>>TT-Trinidad And Tobago</option>
				<option value="TN" title="Tunisia" <% if(strInstituteCountry.equals("TN")) {%>selected<% } %>>TN-Tunisia</option>
				<option value="TR" title="Turkey" <% if(strInstituteCountry.equals("TR")) {%>selected<% } %>>TR-Turkey</option>
				<option value="TM" title="Turkmenistan" <% if(strInstituteCountry.equals("TM")) {%>selected<% } %>>TM-Turkmenistan</option>
				<option value="TC" title="Turks And Caicos Islands" <% if(strInstituteCountry.equals("TC")) {%>selected<% } %>>TC-Turks And Caicos Islands</option>
				<option value="TV" title="Tuvalu" <% if(strInstituteCountry.equals("TV")) {%>selected<% } %>>TV-Tuvalu</option>
				<option value="UG" title="Uganda" <% if(strInstituteCountry.equals("UG")) {%>selected<% } %>>UG-Uganda</option>
				<option value="UA" title="Ukraine" <% if(strInstituteCountry.equals("UA")) {%>selected<% } %>>UA-Ukraine</option>
				<option value="AE" title="United Arab Emirates" <% if(strInstituteCountry.equals("AE")) {%>selected<% } %>>AE-United Arab Emirates</option>
				<option value="GB" title="United Kingdom" <% if(strInstituteCountry.equals("GB")) {%>selected<% } %>>GB-United Kingdom</option>
				<option value="US" title="United States" <% if(strInstituteCountry.equals("US")) {%>selected<% } %>>US-United States</option>
				<option value="UM" title="United States Minor Outlying Islands" <% if(strInstituteCountry.equals("UM")) {%>selected<% } %>>UM-United States Minor Outlying Islands</option>
				<option value="UY" title="Uruguay" <% if(strInstituteCountry.equals("UY")) {%>selected<% } %>>UY-Uruguay</option>
				<option value="UZ" title="Uzbekistan" <% if(strInstituteCountry.equals("UZ")) {%>selected<% } %>>UZ-Uzbekistan</option>
				<option value="VU" title="Vanuatu" <% if(strInstituteCountry.equals("VU")) {%>selected<% } %>>VU-Vanuatu</option>
				<option value="VE" title="Venezuela" <% if(strInstituteCountry.equals("VE")) {%>selected<% } %>>VE-Venezuela</option>
				<option value="VN" title="Viet Nam" <% if(strInstituteCountry.equals("VN")) {%>selected<% } %>>VN-Viet Nam</option>
				<option value="VG" title="Virgin Islands, British" <% if(strInstituteCountry.equals("VG")) {%>selected<% } %>>VG-Virgin Islands, British</option>
				<option value="VI" title="Virgin Islands, U.S." <% if(strInstituteCountry.equals("VI")) {%>selected<% } %>>VI-Virgin Islands, U.S.</option>
				<option value="WF" title="Wallis And Futuna" <% if(strInstituteCountry.equals("WF")) {%>selected<% } %>>WF-Wallis And Futuna</option>
				<option value="EH" title="Western Sahara" <% if(strInstituteCountry.equals("EH")) {%>selected<% } %>>EH-Western Sahara</option>
				<option value="YE" title="Yemen" <% if(strInstituteCountry.equals("YE")) {%>selected<% } %>>YE-Yemen</option>
				<option value="ZM" title="Zambia" <% if(strInstituteCountry.equals("ZM")) {%>selected<% } %>>ZM-Zambia</option>
				<option value="ZW" title="Zimbabwe" <% if(strInstituteCountry.equals("ZW")) {%>selected<% } %>>ZW-Zimbabwe</option>
				<option value="SS" title="South Sudan" <% if(strInstituteCountry.equals("SS")) {%>selected<% } %>>SS-South Sudan</option>
				<option value="CW" title="Curacao" <% if(strInstituteCountry.equals("CW")) {%>selected<% } %>>CW-Curacao</option>
				<option value="BQ" title="Bonaire, Sint Eustatius and Saba" <% if(strInstituteCountry.equals("BQ")) {%>selected<% } %>>BQ-Bonaire, Sint Eustatius and Saba</option>
				<option value="SX" title="Sint Marteen" <% if(strInstituteCountry.equals("SX")) {%>selected<% } %>>SX-Sint Marteen</option>
				<option value="XX" title="Not available " <% if(strInstituteCountry.equals("XX")) {%>selected<% } %>>XX-Not available </option>
				<option value="ZZ" title="Others" <% if(strInstituteCountry.equals("ZZ")) {%>selected<% } %>>ZZ-Others</option>
		</select>
	</div>
	<div class="normalTextField right">
		<label>9. PIN Code</label>
		<input type="text" name="institutePin" <%=readOnly%> value="<%=strInstitutePin%>"/>
	</div>
	<div class="normalTextField left">
		<label>10. Telephone</label>
		<input type="text" name="instituteTelNo" <%=readOnly%> value="<%=strInstituteTelNo%>"/>
	</div>
	<div class="normalTextField right">
		<label>11. Mobile</label>
		<input type="text" name="instituteMobNo" <%=readOnly%> value="<%=strInstituteMobNo%>"/>
	</div>
	<div class="normalTextField left">
		<label>12. FAX</label>
		<input type="text" name="instituteFaxNo" <%=readOnly%> value="<%=strInstituteFaxNo%>"/>
	</div>
	<div class="normalTextField right">
		<label>13. E-mail Address</label>
		<input type="text" name="instituteEmail" <%=readOnly%> value="<%=strInstituteEmail%>"/>
	</div>
	</br></br></br></br></br></br></br></br></br></br></br></br></br></br></br>
	<div class="normalTextField">
		<label>14. Branch Remarks</label>
		<textarea name="instituteRemarks" <%=readOnly%>><%=strInstituteRemarks%></textarea>
	</div>
	<div class="mainButtons">
		<%-- <input type="submit" value="Save" <%if(canUpdated.equals("N")){%> disabled <%}%> /> --%>
		<input type="submit" value="Save" <%=disabled%> />
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
