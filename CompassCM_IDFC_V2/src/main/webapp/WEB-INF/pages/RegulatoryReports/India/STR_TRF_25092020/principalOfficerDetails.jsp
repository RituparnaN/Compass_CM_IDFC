<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
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
	strBankAddressFaxNo 	  = "0659-6983223";
	strMLROEmailId 			  = "PREDDY@CORP.COM";
//System.out.println("objManualDetailsVO = "+objManualDetailsVO.getReportingEntityCategory()+" "+objManualDetailsVO.getPrincNameOfBank());
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
		<textarea name="principalOfficersAddress1" <%=readOnly%>><%=strBankAddressBuildingNo+", "+strBankAddressStreet+", "+strBankAddressLocality%></textarea>
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
		<!-- <select name="principalOfficersCountry">
			<option value="AF">AF-Afghanistan</option>
			<option value="AX">AX-Aland Islands</option>
			<option value="AL">AL-Albania</option>
			<option value="DZ">DZ-Algeria</option>
			<option value="AS">AS-American Samoa</option>
			<option value="AD">AD-Andorra</option>
			<option value="AO">AO-Angola</option>
			<option value="AI">AI-Anguilla</option>
			<option value="AQ">AQ-Antarctica</option>
			<option value="AG">AG-Antigua And Barbuda</option>
			<option value="AR">AR-Argentina</option>
			<option value="AM">AM-Armenia</option>
			<option value="AW">AW-Aruba</option>
			<option value="AU">AU-Australia</option>
			<option value="AT">AT-Austria</option>
			<option value="AZ">AZ-Azerbaijan</option>
			<option value="BS">BS-Bahamas</option>
			<option value="BH">BH-Bahrain</option>
			<option value="BD">BD-Bangladesh</option>
			<option value="BB">BB-Barbados</option>
			<option value="BY">BY-Belarus</option>
			<option value="BE">BE-Belgium</option>
			<option value="BZ">BZ-Belize</option>
			<option value="BJ">BJ-Benin</option>
			<option value="BM">BM-Bermuda</option>
			<option value="BT">BT-Bhutan</option>
			<option value="BO">BO-Bolivia</option>
			<option value="BA">BA-Bosnia And Herzegovina</option>
			<option value="BW">BW-Botswana</option>
			<option value="BV">BV-Bouvet Island</option>
			<option value="BR">BR-Brazil</option>
			<option value="IO">IO-British Indian Ocean Territory</option>
			<option value="BN">BN-Brunei Darussalam</option>
			<option value="BG">BG-Bulgaria</option>
			<option value="BF">BF-Burkina Faso</option>
			<option value="BI">BI-Burundi</option>
			<option value="KH">KH-Cambodia</option>
			<option value="CM">CM-Cameroon</option>
			<option value="CA">CA-Canada</option>
			<option value="CV">CV-Cape Verde</option>
			<option value="KY">KY-Cayman Islands</option>
			<option value="CF">CF-Central African Republic</option>
			<option value="TD">TD-Chad</option>
			<option value="CL">CL-Chile</option>
			<option value="CN">CN-China</option>
			<option value="CX">CX-Christmas Island</option>
			<option value="CC">CC-Cocos (Keeling) Islands</option>
			<option value="CO">CO-Colombia</option>
			<option value="KM">KM-Comoros</option>
			<option value="CG">CG-Congo</option>
			<option value="CD">CD-Congo,Democratic Republic</option>
			<option value="CK">CK-Cook Islands</option>
			<option value="CR">CR-Costa Rica</option>
			<option value="CI">CI-Côte D'ivoire</option>
			<option value="HR">HR-Croatia</option>
			<option value="CU">CU-Cuba</option>
			<option value="CY">CY-Cyprus</option>
			<option value="CZ">CZ-Czech Republic</option>
			<option value="DK">DK-Denmark</option>
			<option value="DJ">DJ-Djibouti</option>
			<option value="DM">DM-Dominica</option>
			<option value="DO">DO-Dominican Republic</option>
			<option value="EC">EC-Ecuador</option>
			<option value="EG">EG-Egypt</option>
			<option value="SV">SV-El Ssalvador</option>
			<option value="GQ">GQ-Equatorial Guinea</option>
			<option value="ER">ER-Eritrea</option>
			<option value="EE">EE-Estonia</option>
			<option value="ET">ET-Ethiopia</option>
			<option value="FK">FK-Falkland Islands (Malvinas)</option>
			<option value="FO">FO-Faroe Islands</option>
			<option value="FJ">FJ-Fiji</option>
			<option value="FI">FI-Finland</option>
			<option value="FR">FR-France</option>
			<option value="GF">GF-French Guiana</option>
			<option value="PF">PF-French Polynesia</option>
			<option value="TF">TF-French Southern Territories</option>
			<option value="GA">GA-Gabon</option>
			<option value="GM">GM-Gambia</option>
			<option value="GE">GE-Georgia</option>
			<option value="DE">DE-Germany</option>
			<option value="GH">GH-Ghana</option>
			<option value="GI">GI-Gibraltar</option>
			<option value="GR">GR-Greece</option>
			<option value="GL">GL-Greenland</option>
			<option value="GD">GD-Grenada</option>
			<option value="GP">GP-Guadeloupe</option>
			<option value="GU">GU-Guam</option>
			<option value="GT">GT-Guatemala</option>
			<option value="GG">GG-Guernsey</option>
			<option value="GN">GN-Guinea</option>
			<option value="GW">GW-Guinea-Bissau</option>
			<option value="GY">GY-Guyana</option>
			<option value="HT">HT-Haiti</option>
			<option value="HM">HM-Heard Island And Mcdonald Islands</option>
			<option value="VA">VA-Vatican City State</option>
			<option value="HN">HN-Honduras</option>
			<option value="HK">HK-Hong Kong</option>
			<option value="HU">HU-Hungary</option>
			<option value="IS">IS-Iceland</option>
			<option value="IN" selected="selected">IN-India</option>
			<option value="ID">ID-Indonesia</option>
			<option value="IR">IR-Iran</option>
			<option value="IQ">IQ-Iraq</option>
			<option value="IE">IE-Ireland</option>
			<option value="IM">IM-Isle Of Man</option>
			<option value="IL">IL-Israel</option>
			<option value="IT">IT-Italy</option>
			<option value="JM">JM-Jamaica</option>
			<option value="JP">JP-Japan</option>
			<option value="JE">JE-Jersey</option>
			<option value="JO">JO-Jordan</option>
			<option value="KZ">KZ-Kazakhstan</option>
			<option value="KE">KE-Kenya</option>
			<option value="KI">KI-Kiribati</option>
			<option value="KP">KP-Korea, Democratic People's Republic</option>
			<option value="KR">KR-Korea</option>
			<option value="KW">KW-Kuwait</option>
			<option value="KG">KG-Kyrgyzstan</option>
			<option value="LA">LA-Lao People's Democratic Republic</option>
			<option value="LV">LV-Latvia</option>
			<option value="LB">LB-Lebanon</option>
			<option value="LS">LS-Lesotho</option>
			<option value="LR">LR-Liberia</option>
			<option value="LY">LY-Libyan Arab Jamahiriya</option>
			<option value="LI">LI-Liechtenstein</option>
			<option value="LT">LT-Lithuania</option>
			<option value="LU">LU-Luxembourg</option>
			<option value="MO">MO-Macao</option>
			<option value="MK">MK-Macedonia, The Former Yugoslav Repub</option>
			<option value="MG">MG-Madagascar</option>
			<option value="MW">MW-Malawi</option>
			<option value="MY">MY-Malaysia</option>
			<option value="MV">MV-Maldives</option>
			<option value="ML">ML-Mali</option>
			<option value="MT">MT-Malta</option>
			<option value="MH">MH-Marshall Islands</option>
			<option value="MQ">MQ-Martinique</option>
			<option value="MR">MR-Mauritania</option>
			<option value="MU">MU-Mauritius</option>
			<option value="YT">YT-Mayotte</option>
			<option value="MX">MX-Mexico</option>
			<option value="FM">FM-Micronesia</option>
			<option value="MD">MD-Moldova</option>
			<option value="MC">-Monaco</option>
			<option value="MN">MN-Mongolia</option>
			<option value="ME">ME-Montenegro</option>
			<option value="MS">MS-Montserrat</option>
			<option value="MA">MA-Morocco</option>
			<option value="MZ">MZ-Mozambique</option>
			<option value="MM">MM-Myanmar</option>
			<option value="NA">NA-Namibia</option>
			<option value="NR">NR-Nauru</option>
			<option value="NP">NP-Nepal</option>
			<option value="NL">NL-Netherlands</option>
			<option value="AN">AN-Netherlands Antilles</option>
			<option value="NC">NC-New Caledonia</option>
			<option value="NZ">NZ-New Zealand</option>
			<option value="NI">NI-Nicaragua</option>
			<option value="NE">NE-Niger</option>
			<option value="NG">NG-Nigeria</option>
			<option value="NU">NU-Niue</option>
			<option value="NF">NF-Norfolk Island</option>
			<option value="MP">MP-Northern Mariana Islands</option>
			<option value="NO">NO-Norway</option>
			<option value="OM">OM-Oman</option>
			<option value="PK">PK-Pakistan</option>
			<option value="PW">PW-Palau</option>
			<option value="PS">PS-Palestinian Territory, Occupied</option>
			<option value="PA">PA-Panama</option>
			<option value="PG">PG-Papua New Guinea</option>
			<option value="PY">PY-Paraguay</option>
			<option value="PE">PE-Peru</option>
			<option value="PH">PH-Philippines</option>
			<option value="PN">PN-Pitcairn</option>
			<option value="PL">PL-Poland</option>
			<option value="PT">PT-Portugal</option>
			<option value="PR">PR-Puerto Rico</option>
			<option value="QA">QA-Qatar</option>
			<option value="RE">RE-Réunion</option>
			<option value="RO">RO-Romania</option>
			<option value="RU">RU-Russian Federation</option>
			<option value="RW">RW-Rwanda</option>
			<option value="BL">BL-Saint Barthélemy</option>
			<option value="SH">SH-Saint Helena, Ascension And Tristan</option>
			<option value="KN">KN-Saint Kitts And Nevis</option>
			<option value="LC">LC-Saint Lucia</option>
			<option value="MF">MF-Saint Martin</option>
			<option value="PM">PM-Saint Pierre And Miquelon</option>
			<option value="VC">VC-Saint Vincent And The Grenadines</option>
			<option value="WS">WS-Samoa</option>
			<option value="SM">SM-San Marino</option>
			<option value="ST">ST-Sao Tome And Principe</option>
			<option value="SA">SA-Saudi Arabia</option>
			<option value="SN">SN-Senegal</option>
			<option value="RS">RS-Serbia</option>
			<option value="SC">SC-Seychelles</option>
			<option value="SL">SL-Sierra Leone</option>
			<option value="SG">SG-Singapore</option>
			<option value="SK">SK-Slovakia</option>
			<option value="SI">SI-Slovenia</option>
			<option value="SB">SB-Solomon Islands</option>
			<option value="SO">SO-Somalia</option>
			<option value="ZA">ZA-South Africa</option>
			<option value="GS">GS-South Georgia And The South Sandwich</option>
			<option value="ES">ES-Spain</option>
			<option value="LK">LK-Sri Lanka</option>
			<option value="SD">SD-Sudan</option>
			<option value="SR">SR-Suriname</option>
			<option value="SJ">SJ-Svalbard And Jan Mayen</option>
			<option value="SZ">SZ-Swaziland</option>
			<option value="SE">SE-Sweden</option>
			<option value="CH">CH-Switzerland</option>
			<option value="SY">SY-Syrian Arab Republic</option>
			<option value="TW">TW-Taiwan, Province Of China</option>
			<option value="TJ">TJ-Tajikistan</option>
			<option value="TZ">TZ-Tanzania</option>
			<option value="TH">TH-Thailand</option>
			<option value="TL">TL-Timor-Leste</option>
			<option value="TG">TG-Togo</option>
			<option value="TK">TK-Tokelau</option>
			<option value="TO">TO-Tonga</option>
			<option value="TT">TT-Trinidad And Tobago</option>
			<option value="TN">TN-Tunisia</option>
			<option value="TR">TR-Turkey</option>
			<option value="TM">TM-Turkmenistan</option>
			<option value="TC">TC-Turks And Caicos Islands</option>
			<option value="TV">TV-Tuvalu</option>
			<option value="UG">UG-Uganda</option>
			<option value="UA">UA-Ukraine</option>
			<option value="AE">AE-United Arab Emirates</option>
			<option value="GB">GB-United Kingdom</option>
			<option value="US">US-United States</option>
			<option value="UM">UM-United States Minor Outlying Islands</option>
			<option value="UY">UY-Uruguay</option>
			<option value="UZ">UZ-Uzbekistan</option>
			<option value="VU">VU-Vanuatu</option>
			<option value="VE">VE-Venezuela</option>
			<option value="VN">VN-Viet Nam</option>
			<option value="VG">VG-Virgin Islands, British</option>
			<option value="VI">VI-Virgin Islands, U.S.</option>
			<option value="WF">WF-Wallis And Futuna</option>
			<option value="EH">EH-Western Sahara</option>
			<option value="YE">YE-Yemen</option>
			<option value="ZM">ZM-Zambia</option>
			<option value="ZW">ZW-Zimbabwe</option>
			<option value="SS">SS-South Sudan</option>
			<option value="CW">CW-Curacao</option>
			<option value="BQ">BQ-Bonaire, Sint Eustatius and Saba</option>
			<option value="SX">SX-Sint Marteen</option>
			<option value="XX">XX-Not available </option>
			<option value="ZZ">ZZ-Others</option> -->
		</select>
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
		<input type="text" name="principalOfficersMobileNo" <%=readOnly%> value=""/>
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