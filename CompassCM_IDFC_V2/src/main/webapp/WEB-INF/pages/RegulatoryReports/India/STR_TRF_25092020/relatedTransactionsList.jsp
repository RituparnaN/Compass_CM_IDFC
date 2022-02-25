<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%try{%>
<%
HttpSession l_CHttpSession = request.getSession(true);
String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
String disabled = "disabled";
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<% 
	ISTRTRFManualDetailsVO objManualDetailsVO = (ISTRTRFManualDetailsVO)request.getAttribute("ManualFormDTO");
	String[] strTransactionSeqNoArray = null;
	String[] strTransactionDateArray = null;
	String[] strTransactionTypeArray = null;
	String[] strTransactionInstrumentTypeArray = null;
	String[] strTransactionCurrArray = null;
	String[] strTransactionAmtInRupeesArray = null;
	String[] strTransactionDataTypeArray = null;

    int intNoOfTransactions = 0;
	int intRecordsCount = 0;
	if(objManualDetailsVO!=null){
		intNoOfTransactions = objManualDetailsVO.getNoOfTransactionRec();
		intRecordsCount = intNoOfTransactions; 
		//System.out.println("intRecordsCount = "+intRecordsCount);
		if(intNoOfTransactions < 10)
			intNoOfTransactions=10;
			
		strTransactionSeqNoArray 			= new String[intNoOfTransactions];
		strTransactionDateArray 			= new String[intNoOfTransactions];
		strTransactionTypeArray 			= new String[intNoOfTransactions];
		strTransactionInstrumentTypeArray	= new String[intNoOfTransactions]; 	
		strTransactionCurrArray				= new String[intNoOfTransactions];
		strTransactionAmtInRupeesArray		= new String[intNoOfTransactions]; 	
		strTransactionDataTypeArray			= new String[intNoOfTransactions];
		
		if(intRecordsCount > 0)
		{			
		 for(int i=0; i<objManualDetailsVO.getTransactionDate().length; i++)
		 { 
		  strTransactionSeqNoArray[i]			= (objManualDetailsVO.getTransactionSeqNo()[i] == null) ?"":objManualDetailsVO.getTransactionSeqNo()[i]; 
		  strTransactionDateArray[i] 			= (objManualDetailsVO.getTransactionDate()[i] == null) ?"":objManualDetailsVO.getTransactionDate()[i];
		 // System.out.println("strTransactionDateArray = "+objManualDetailsVO.getTransactionDate()[i]);
		  strTransactionTypeArray[i]			= (objManualDetailsVO.getTransactionType()[i] == null) ?"":objManualDetailsVO.getTransactionType()[i];
		 // System.out.println("strTransactionTypeArray = "+objManualDetailsVO.getTransactionType()[i]);
		  strTransactionInstrumentTypeArray[i]	= (objManualDetailsVO.getTransactionInstrumentType()[i] == null) ?"":objManualDetailsVO.getTransactionInstrumentType()[i];  
		//  System.out.println("strTransactionInstrumentTypeArray = "+objManualDetailsVO.getTransactionInstrumentType()[i]);
		  strTransactionCurrArray[i]			= (objManualDetailsVO.getTransactionCurrency()[i] == null) ?"":objManualDetailsVO.getTransactionCurrency()[i];
		//  System.out.println("strTransactionCurrArray = "+objManualDetailsVO.getTransactionCurrency()[i]);
		  strTransactionAmtInRupeesArray[i]		= (objManualDetailsVO.getTransactionAmtInRupees()[i] == null) ?"":objManualDetailsVO.getTransactionAmtInRupees()[i];  
		//  System.out.println("strTransactionAmtInRupeesArray = "+objManualDetailsVO.getTransactionAmtInRupees()[i]);
		  strTransactionDataTypeArray[i]		= (objManualDetailsVO.getDataTypeForTransaction()[i] == null) ?"":objManualDetailsVO.getDataTypeForTransaction()[i];	
		//  System.out.println("strTransactionDataTypeArray = "+objManualDetailsVO.getDataTypeForTransaction()[i]);
		 }
		}
	}
	String strDisableFlag =(String) request.getAttribute("disable");
%>	

<script language="javascript">
<!--
var txnDate;
var txnType;
var intrumentType;
var currency;
var amtRupees;
var annexure;
var callfrom;
function addNewTransaction()
{
var caseNo = '<%= caseNo%>';
//alert('caseNo:  '+caseNo);
<%-- var win= window.open('<%=contextPath%>/RegulatoryReports/India/STR_TRF/addTransactionDetails.jsp?caseNo='+caseNo,'NEWANNEXUREA',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no"); --%>
var win= window.open('<%=contextPath%>/common/addNewTransactionDetailsInSTRTRF?caseNo='+caseNo,'NEWANNEXUREA',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}

function uploadTransactions()
{
	var caseNo = '<%= caseNo%>';
	alert('caseNo:  '+caseNo);
	window.open('<%=contextPath%>/common/uploadTransactionInSTRTRF?caseNo='+caseNo,'NEWANNEXUREA',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no")
}

function updateTransactionDetails(strTxnDate,strTxnType,strIntrumentType,strCurrency,strAmtRupees,strTxnSeqNo,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
txnDate = strTxnDate;
txnType = strTxnType;
intrumentType = strIntrumentType;
currency = strCurrency;
amtRupees = strAmtRupees;
txnSeqNo = strTxnSeqNo;
annexure = strAnnexure;
//alert(txnSeqNo);
var caseNo = '<%= caseNo%>';
window.open('<%=contextPath%>/common/getNewINDSTRTRFTransactions?txnDate='+txnDate+'&txnType='+txnType+'&intrumentType='+intrumentType+'&currency='+currency+'&amtRupees='+amtRupees+'&txnSeqNo='+txnSeqNo+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREA','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no');
}

function deleteTransactionDetails(strTxnDate,strTxnType,strIntrumentType,strCurrency,strAmtRupees,strTxnSeqNo,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
txnDate = strTxnDate;
txnType = strTxnType;
intrumentType = strIntrumentType;
currency = strCurrency;
amtRupees = strAmtRupees;
txnSeqNo = strTxnSeqNo;
annexure = strAnnexure;
alert(txnDate+" -- "+txnSeqNo+" -- "+txnType+" -- "+intrumentType+" -- "+currency+" -- "+amtRupees);
var conf=confirm('Do you want to delete the data?'); 
if(conf)
{	
	this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTRTRFTransactions?txnDate='+txnDate+'&txnType='+txnType+'&intrumentType='+intrumentType+'&currency='+currency+'&amtRupees='+amtRupees+'&txnSeqNo='+txnSeqNo+'&CallFrom='+callfrom);
}
}
-->
</script>

<div class="section">
	<div class="mainHeader">
	4. List of Transactions
	<!-- <div style="padding-left: 50%; padding-top: 0;"> -->
		<input type="button" id = "uploadTransaction" value="Upload Transaction" style="margin-left: 48%; margin-top: 5px" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="uploadTransactions()"/>
		<input type="button" id = "addTransaction" value="Add New Transaction" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewTransaction()"/>
		
	<!-- </div> -->
	<%-- <div class="uploadButton">
		<input type="button" value="Upload Transaction" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="uploadTransaction()"/>
	</div> --%>
	</div>
	<table class="info-table">
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="10%">Date</th>
			<th width="10%">Transaction Type</th>
			<th width="15%">Instrument Type</th>
			<th width="25%">Currency</th>
			<th width="20%">Amount in Rupees</th>
			<th width="10%">Annexure</th>
			<th width="5%">&nbsp;</th>
		</tr>

		<%for(int i=0; i < intNoOfTransactions; i++){ 
	  	if(strTransactionDataTypeArray!=null && strTransactionDataTypeArray[i]!=null && strTransactionDataTypeArray[i].equalsIgnoreCase("M"))
		{%>
		<tr>
			<th>4.<%=i+1%></th>
			<td><input type="text" name="transactionDate" id="transactionDate" readonly value="<%=(strTransactionDateArray[i] == null) ? "" : strTransactionDateArray[i] %>" /></td>
			<!-- <td><input type="text" readonly name="transactionDate"  class="topOpenTextBox" size=12 maxlength=12 id="transactionDate"/></td> -->
			<td>
				<select name="transactionType" <%=disabled%>>
					<option <% if(strTransactionTypeArray[i].equals("P")) {%>selected<% } %>>P -Purchase</option>
					<option <% if(strTransactionTypeArray[i].equals("R")) {%>selected<% } %>>R -Redemption</option>	
				</select>
			</td>
			<td><select name="instrumentType" <%=disabled%>>
				<!-- <option value="A">A - Currency Note</option>
				<option value="B">B - Travelers Cheque</option>
				<option value="C">C - Demand Draft</option>
				<option value="D">D - Money Order</option>
				<option value="E">E - Wire Transfers / TT</option>
				<option value="F">F - Money Transfer</option>
				<option value="G">G - Credit card</option>
				<option value="H">H - Debit card</option>
				<option value="I">I - Smart card</option>
				<option value="J">J - Prepaid card</option>	
				<option value="K">K - Gift card</option>
				<option value="L">L - Cheque</option>
				<option value="Z">Z - Others</option>
				<option value="X">X - Not Categorised</option> -->
				<option value="A" <% if(strTransactionInstrumentTypeArray[i].equals("A")) {%>selected<% } %>>A - Currency Note</option>
				<option value="B" <% if(strTransactionInstrumentTypeArray[i].equals("B")) {%>selected<% } %>>B - Travellers Cheque</option>
				<option value="C" <% if(strTransactionInstrumentTypeArray[i].equals("C")) {%>selected<% } %>>C - Demand Draft</option>
				<option value="D" <% if(strTransactionInstrumentTypeArray[i].equals("D")) {%>selected<% } %>>D - Money Order</option>
				<option value="E" <% if(strTransactionInstrumentTypeArray[i].equals("E")) {%>selected<% } %>>E - Wire Transfers / TT</option>
				<option value="F" <% if(strTransactionInstrumentTypeArray[i].equals("F")) {%>selected<% } %>>F - Money Transfer</option>
				<option value="G" <% if(strTransactionInstrumentTypeArray[i].equals("G")) {%>selected<% } %>>G - Credit card</option>
				<option value="H" <% if(strTransactionInstrumentTypeArray[i].equals("H")) {%>selected<% } %>>H - Debit card</option>
				<option value="I" <% if(strTransactionInstrumentTypeArray[i].equals("I")) {%>selected<% } %>>I - Smart card</option>
				<option value="J" <% if(strTransactionInstrumentTypeArray[i].equals("J")) {%>selected<% } %>>J - Prepaid card</option>	
				<option value="K" <% if(strTransactionInstrumentTypeArray[i].equals("K")) {%>selected<% } %>>K - Gift card</option>
				<option value="L" <% if(strTransactionInstrumentTypeArray[i].equals("L")) {%>selected<% } %>>L - Cheque</option>
				<option value="X" <% if(strTransactionInstrumentTypeArray[i].equals("X")) {%>selected<% } %>>X - Not Categorised</option>
				<option value="Z" <% if(strTransactionInstrumentTypeArray[i].equals("Z")) {%>selected<% } %>>Z - Others</option>
			</select></td>
			<td><select name="currencyCode" <%=disabled%>>
				<!-- <option value="AFA">AFA- Afghanistan Afghani</option>
				<option value="ALL">ALL- Albanian Lek</option>
				<option value="DZD">DZD- Algerian Dinar</option>
				<option value="AOR">AOR- Angolan Kwanza Reajustado</option>
				<option value="ARS">ARS- Argentine Peso</option>
				<option value="AMD">AMD- Armenian Dram</option>
				<option value="AWG">AWG- Aruban Guilder</option>
				<option value="AUD">AUD- Australian Dollar</option>
				<option value="AZN">AZN- Azerbaijanian New Manat</option>
				<option value="BSD">BSD- Bahamian Dollar</option>
				<option value="BHD">BHD- Bahraini Dinar</option>
				<option value="BDT">BDT- Bangladeshi Taka</option>
				<option value="BBD">BBD- Barbados Dollar</option>
				<option value="BYR">BYR- Belarusian Ruble</option>
				<option value="BZD">BZD- Belize Dollar</option>
				<option value="BMD">BMD- Bermudian Dollar</option>
				<option value="BTN">BTN- Bhutan Ngultrum</option>
				<option value="BOB">BOB- Bolivian Boliviano</option>
				<option value="BWP">BWP- Botswana Pula</option>
				<option value="BRL">BRL- Brazilian Real</option>
				<option value="GBP">GBP- British Pound</option>
				<option value="BND">BND- Brunei Dollar</option>
				<option value="BGN">BGN- Bulgarian Lev</option>
				<option value="BIF">BIF- Burundi Franc</option>
				<option value="KHR">KHR- Cambodian Riel</option>
				<option value="CAD">CAD- Canadian Dollar</option>
				<option value="CVE">CVE- Cape Verde Escudo</option>
				<option value="KYD">KYD- Cayman Islands Dollar</option>
				<option value="XOF">XOF- CFA Franc BCEAO</option>
				<option value="XAF">XAF- CFA Franc BEAC</option>
				<option value="XPF">XPF- CFP Franc</option>
				<option value="CLP">CLP- Chilean Peso</option>
				<option value="CNY">CNY- Chinese Yuan Renminbi</option>
				<option value="COP">COP- Colombian Peso</option>
				<option value="KMF">KMF- Comoros Franc</option>
				<option value="CDF">CDF- Congolese Franc</option>
				<option value="CRC">CRC- Costa Rican Colon</option>
				<option value="HRK">HRK- Croatian Kuna</option>
				<option value="CUP">CUP- Cuban Peso</option>
				<option value="CZK">CZK- Czech Koruna</option>
				<option value="DKK">DKK- Danish Krone</option>
				<option value="DJF">DJF- Djibouti Franc</option>
				<option value="DOP">DOP- Dominican Peso</option>
				<option value="XCD">XCD- East Caribbean Dollar</option>
				<option value="EGP">EGP- Egyptian Pound</option>
				<option value="SVC">SVC- El Salvador Colon</option>
				<option value="ERN">ERN- Eritrean Nakfa</option>
				<option value="EEK">EEK- Estonian Kroon</option>
				<option value="ETB">ETB- Ethiopian Birr</option>
				<option value="EUR">EUR- EU Euro</option>
				<option value="FKP">FKP- Falkland Islands Pound</option>
				<option value="FJD">FJD- Fiji Dollar</option>
				<option value="GMD">GMD- Gambian Dalasi</option>
				<option value="GEL">GEL- Georgian Lari</option>
				<option value="GHS">GHS- Ghanaian New Cedi</option>
				<option value="GIP">GIP- Gibraltar Pound</option>
				<option value="XAU">XAU- Gold (Ounce)</option>
				<option value="XFO">XFO- Gold Franc</option>
				<option value="GTQ">GTQ- Guatemalan Quetzal</option>
				<option value="GNF">GNF- Guinean Franc</option>
				<option value="GYD">GYD- Guyana Dollar</option>
				<option value="HTG">HTG- Haitian Gourde</option>
				<option value="HNL">HNL- Honduran Lempira</option>
				<option value="HKD">HKD- Hong Kong SAR Dollar</option>
				<option value="HUF">HUF- Hungarian Forint</option>
				<option value="ISK">ISK- Icelandic Krona</option>
				<option value="XDR">XDR- IMF Special Drawing Right</option>
				<option value="INR">INR- Indian Rupee</option>
				<option value="IDR">IDR- Indonesian Rupiah</option>
				<option value="IRR">IRR- Iranian Rial</option>
				<option value="IQD">IQD- Iraqi Dinar</option>
				<option value="ILS">ILS- Israeli New Shekel</option>
				<option value="JMD">JMD- Jamaican Dollar</option>
				<option value="JPY">JPY- Japanese Yen</option>
				<option value="JOD">JOD- Jordanian Dinar</option>
				<option value="KZT">KZT- Kazakh Tenge</option>
				<option value="KES">KES- Kenyan Shilling</option>
				<option value="KWD">KWD- Kuwaiti Dinar</option>
				<option value="KGS">KGS- Kyrgyz Som</option>
				<option value="LAK">LAK- Lao Kip</option>
				<option value="LVL">LVL- Latvian Lats</option>
				<option value="LBP">LBP- Lebanese Pound</option>
				<option value="LSL">LSL- Lesotho Loti</option>
				<option value="LRD">LRD- Liberian Dollar</option>
				<option value="LYD">LYD- Libyan Dinar</option>
				<option value="LTL">LTL- Lithuanian Litas</option>
				<option value="MOP">MOP- Macao SAR Pataca</option>
				<option value="MKD">MKD- Macedonian Denar</option>
				<option value="MGA">MGA- Malagasy Ariary</option>
				<option value="MWK">MWK- Malawi Kwacha</option>
				<option value="MYR">MYR- Malaysian Ringgit</option>
				<option value="MVR">MVR- Maldivian Rufiyaa</option>
				<option value="MRO">MRO- Mauritanian Ouguiya</option>
				<option value="MUR">MUR- Mauritius Rupee</option>
				<option value="MXN">MXN- Mexican Peso</option>
				<option value="MDL">MDL- Moldovan Leu</option>
				<option value="MNT">MNT- Mongolian Tugrik</option>
				<option value="MAD">MAD- Moroccan Dirham</option>
				<option value="MZN">MZN- Mozambique New Metical</option>
				<option value="MMK">MMK- Myanmar Kyat</option>
				<option value="NAD">NAD- Namibian Dollar</option>
				<option value="NPR">NPR- Nepalese Rupee</option>
				<option value="ANG">ANG- Netherlands Antillian Guilder</option>
				<option value="NZD">NZD- New Zealand Dollar</option>
				<option value="NIO">NIO- Nicaraguan Cordoba Oro</option>
				<option value="NGN">NGN- Nigerian Naira</option>
				<option value="KPW">KPW- North Korean Won</option>
				<option value="NOK">NOK- Norwegian Krone</option>
				<option value="OMR">OMR- Omani Rial</option>
				<option value="PKR">PKR- Pakistani Rupee</option>
				<option value="XPD">XPD- Palladium (Ounce)</option>
				<option value="PAB">PAB- Panamanian Balboa</option>
				<option value="PGK">PGK- Papua New Guinea Kina</option>
				<option value="PYG">PYG- Paraguayan Guarani</option>
				<option value="PEN">PEN- Peruvian Nuevo Sol</option>
				<option value="PHP">PHP- Philippine Peso</option>
				<option value="XPT">XPT- Platinum (Ounce)</option>
				<option value="PLN">PLN- Polish Zloty</option>
				<option value="QAR">QAR- Qatari Rial</option>
				<option value="RON">RON- Romanian New Leu</option>
				<option value="RUB">RUB- Russian Ruble</option>
				<option value="RWF">RWF- Rwandan Franc</option>
				<option value="SHP">SHP- Saint Helena Pound</option>
				<option value="WST">WST- Samoan Tala</option>
				<option value="STD">STD- Sao Tome And Principe Dobra</option>
				<option value="SAR">SAR- Saudi Riyal</option>
				<option value="RSD">RSD- Serbian Dinar</option>
				<option value="SCR">SCR- Seychelles Rupee</option>
				<option value="SLL">SLL- Sierra Leone Leone</option>
				<option value="XAG">XAG- Silver (Ounce)</option>
				<option value="SGD">SGD- Singapore Dollar</option>
				<option value="SBD">SBD- Solomon Islands Dollar</option>
				<option value="SOS">SOS- Somali Shilling</option>
				<option value="ZAR">ZAR- South African Rand</option>
				<option value="KRW">KRW- South Korean Won</option>
				<option value="LKR">LKR- Sri Lanka Rupee</option>
				<option value="SDG">SDG- Sudanese Pound</option>
				<option value="SRD">SRD- Suriname Dollar</option>
				<option value="SZL">SZL- Swaziland Lilangeni</option>
				<option value="SEK">SEK- Swedish Krona</option>
				<option value="CHF">CHF- Swiss Franc</option>
				<option value="SYP">SYP- Syrian Pound</option>
				<option value="TWD">TWD- Taiwan New Dollar</option>
				<option value="TJS">TJS- Tajik Somoni</option>
				<option value="TZS">TZS- Tanzanian Shilling</option>
				<option value="THB">THB- Thai Baht</option>
				<option value="TOP">TOP- Tongan Pa'anga</option>
				<option value="TTD">TTD- Trinidad And Tobago Dollar</option>
				<option value="TND">TND- Tunisian Dinar</option>
				<option value="TRY">TRY- Turkish Lira</option>
				<option value="TMT">TMT- Turkmen New Manat</option>
				<option value="AED">AED- UAE Dirham</option>
				<option value="UGX">UGX- Uganda New Shilling</option>
				<option value="XFU">XFU- UIC Franc</option>
				<option value="UAH">UAH- Ukrainian Hryvnia</option>
				<option value="UYU">UYU- Uruguayan Peso Uruguayo</option>
				<option value="USD">USD- US Dollar</option>
				<option value="UZS">UZS- Uzbekistani Sum</option>
				<option value="VUV">VUV- Vanuatu Vatu</option>
				<option value="VEF">VEF- Venezuelan Bolivar Fuerte</option>
				<option value="VND">VND- Vietnamese Dong</option>
				<option value="YER">YER- Yemeni Rial</option>
				<option value="ZMK">ZMK- Zambian Kwacha</option>
				<option value="ZWL">ZWL- Zimbabwe Dollar</option>
				<option value="XXX">XXX- Not available </option>
				<option value="ZZZ">ZZZ- Others </option> -->
				<option value="AFA" <% if(strTransactionCurrArray[i].equals("AFA")) {%>selected<% } %>>AFA- Afghanistan Afghani</option>
				<option value="ALL" <% if(strTransactionCurrArray[i].equals("ALL")) {%>selected<% } %>>ALL- Albanian Lek</option>
				<option value="DZD" <% if(strTransactionCurrArray[i].equals("DZD")) {%>selected<% } %>>DZD- Algerian Dinar</option>
				<option value="AOR" <% if(strTransactionCurrArray[i].equals("AOR")) {%>selected<% } %>>AOR- Angolan Kwanza Reajustado</option>
				<option value="ARS" <% if(strTransactionCurrArray[i].equals("ARS")) {%>selected<% } %>>ARS- Argentine Peso</option>
				<option value="AMD" <% if(strTransactionCurrArray[i].equals("AMD")) {%>selected<% } %>>AMD- Armenian Dram</option>
				<option value="AWG" <% if(strTransactionCurrArray[i].equals("AWG")) {%>selected<% } %>>AWG- Aruban Guilder</option>
				<option value="AUD" <% if(strTransactionCurrArray[i].equals("AUD")) {%>selected<% } %>>AUD- Australian Dollar</option>
				<option value="AZN" <% if(strTransactionCurrArray[i].equals("AZN")) {%>selected<% } %>>AZN- Azerbaijanian New Manat</option>
				<option value="BSD" <% if(strTransactionCurrArray[i].equals("BSD")) {%>selected<% } %>>BSD- Bahamian Dollar</option>
				<option value="BHD" <% if(strTransactionCurrArray[i].equals("BHD")) {%>selected<% } %>>BHD- Bahraini Dinar</option>
				<option value="BDT" <% if(strTransactionCurrArray[i].equals("BDT")) {%>selected<% } %>>BDT- Bangladeshi Taka</option>
				<option value="BBD" <% if(strTransactionCurrArray[i].equals("BBD")) {%>selected<% } %>>BBD- Barbados Dollar</option>
				<option value="BYR" <% if(strTransactionCurrArray[i].equals("BYR")) {%>selected<% } %>>BYR- Belarusian Ruble</option>
				<option value="BZD" <% if(strTransactionCurrArray[i].equals("BZD")) {%>selected<% } %>>BZD- Belize Dollar</option>
				<option value="BMD" <% if(strTransactionCurrArray[i].equals("BMD")) {%>selected<% } %>>BMD- Bermudian Dollar</option>
				<option value="BTN" <% if(strTransactionCurrArray[i].equals("BTN")) {%>selected<% } %>>BTN- Bhutan Ngultrum</option>
				<option value="BOB" <% if(strTransactionCurrArray[i].equals("BOB")) {%>selected<% } %>>BOB- Bolivian Boliviano</option>
				<option value="BWP" <% if(strTransactionCurrArray[i].equals("BWP")) {%>selected<% } %>>BWP- Botswana Pula</option>
				<option value="BRL" <% if(strTransactionCurrArray[i].equals("BRL")) {%>selected<% } %>>BRL- Brazilian Real</option>
				<option value="GBP" <% if(strTransactionCurrArray[i].equals("GBP")) {%>selected<% } %>>GBP- British Pound</option>
				<option value="BND" <% if(strTransactionCurrArray[i].equals("BND")) {%>selected<% } %>>BND- Brunei Dollar</option>
				<option value="BGN" <% if(strTransactionCurrArray[i].equals("BGN")) {%>selected<% } %>>BGN- Bulgarian Lev</option>
				<option value="BIF" <% if(strTransactionCurrArray[i].equals("BIF")) {%>selected<% } %>>BIF- Burundi Franc</option>
				<option value="KHR" <% if(strTransactionCurrArray[i].equals("KHR")) {%>selected<% } %>>KHR- Cambodian Riel</option>
				<option value="CAD" <% if(strTransactionCurrArray[i].equals("CAD")) {%>selected<% } %>>CAD- Canadian Dollar</option>
				<option value="CVE" <% if(strTransactionCurrArray[i].equals("CVE")) {%>selected<% } %>>CVE- Cape Verde Escudo</option>
				<option value="KYD" <% if(strTransactionCurrArray[i].equals("KYD")) {%>selected<% } %>>KYD- Cayman Islands Dollar</option>
				<option value="XOF" <% if(strTransactionCurrArray[i].equals("XOF")) {%>selected<% } %>>XOF- CFA Franc BCEAO</option>
				<option value="XAF" <% if(strTransactionCurrArray[i].equals("XAF")) {%>selected<% } %>>XAF- CFA Franc BEAC</option>
				<option value="XPF" <% if(strTransactionCurrArray[i].equals("XPF")) {%>selected<% } %>>XPF- CFP Franc</option>
				<option value="CLP" <% if(strTransactionCurrArray[i].equals("CLP")) {%>selected<% } %>>CLP- Chilean Peso</option>
				<option value="CNY" <% if(strTransactionCurrArray[i].equals("CNY")) {%>selected<% } %>>CNY- Chinese Yuan Renminbi</option>
				<option value="COP" <% if(strTransactionCurrArray[i].equals("COP")) {%>selected<% } %>>COP- Colombian Peso</option>
				<option value="KMF" <% if(strTransactionCurrArray[i].equals("KMF")) {%>selected<% } %>>KMF- Comoros Franc</option>
				<option value="CDF" <% if(strTransactionCurrArray[i].equals("CDF")) {%>selected<% } %>>CDF- Congolese Franc</option>
				<option value="CRC" <% if(strTransactionCurrArray[i].equals("CRC")) {%>selected<% } %>>CRC- Costa Rican Colon</option>
				<option value="HRK" <% if(strTransactionCurrArray[i].equals("HRK")) {%>selected<% } %>>HRK- Croatian Kuna</option>
				<option value="CUP" <% if(strTransactionCurrArray[i].equals("CUP")) {%>selected<% } %>>CUP- Cuban Peso</option>
				<option value="CZK" <% if(strTransactionCurrArray[i].equals("CZK")) {%>selected<% } %>>CZK- Czech Koruna</option>
				<option value="DKK" <% if(strTransactionCurrArray[i].equals("DKK")) {%>selected<% } %>>DKK- Danish Krone</option>
				<option value="DJF" <% if(strTransactionCurrArray[i].equals("DJF")) {%>selected<% } %>>DJF- Djibouti Franc</option>
				<option value="DOP" <% if(strTransactionCurrArray[i].equals("DOP")) {%>selected<% } %>>DOP- Dominican Peso</option>
				<option value="XCD" <% if(strTransactionCurrArray[i].equals("XCD")) {%>selected<% } %>>XCD- East Caribbean Dollar</option>
				<option value="EGP" <% if(strTransactionCurrArray[i].equals("EGP")) {%>selected<% } %>>EGP- Egyptian Pound</option>
				<option value="SVC" <% if(strTransactionCurrArray[i].equals("SVC")) {%>selected<% } %>>SVC- El Salvador Colon</option>
				<option value="ERN" <% if(strTransactionCurrArray[i].equals("ERN")) {%>selected<% } %>>ERN- Eritrean Nakfa</option>
				<option value="EEK" <% if(strTransactionCurrArray[i].equals("EEK")) {%>selected<% } %>>EEK- Estonian Kroon</option>
				<option value="ETB" <% if(strTransactionCurrArray[i].equals("ETB")) {%>selected<% } %>>ETB- Ethiopian Birr</option>
				<option value="EUR" <% if(strTransactionCurrArray[i].equals("EUR")) {%>selected<% } %>>EUR- EU Euro</option>
				<option value="FKP" <% if(strTransactionCurrArray[i].equals("FKP")) {%>selected<% } %>>FKP- Falkland Islands Pound</option>
				<option value="FJD" <% if(strTransactionCurrArray[i].equals("FJD")) {%>selected<% } %>>FJD- Fiji Dollar</option>
				<option value="GMD" <% if(strTransactionCurrArray[i].equals("GMD")) {%>selected<% } %>>GMD- Gambian Dalasi</option>
				<option value="GEL" <% if(strTransactionCurrArray[i].equals("GEL")) {%>selected<% } %>>GEL- Georgian Lari</option>
				<option value="GHS" <% if(strTransactionCurrArray[i].equals("GHS")) {%>selected<% } %>>GHS- Ghanaian New Cedi</option>
				<option value="GIP" <% if(strTransactionCurrArray[i].equals("GIP")) {%>selected<% } %>>GIP- Gibraltar Pound</option>
				<option value="XAU" <% if(strTransactionCurrArray[i].equals("XAU")) {%>selected<% } %>>XAU- Gold (Ounce)</option>
				<option value="XFO" <% if(strTransactionCurrArray[i].equals("XFO")) {%>selected<% } %>>XFO- Gold Franc</option>
				<option value="GTQ" <% if(strTransactionCurrArray[i].equals("GTQ")) {%>selected<% } %>>GTQ- Guatemalan Quetzal</option>
				<option value="GNF" <% if(strTransactionCurrArray[i].equals("GNF")) {%>selected<% } %>>GNF- Guinean Franc</option>
				<option value="GYD" <% if(strTransactionCurrArray[i].equals("GYD")) {%>selected<% } %>>GYD- Guyana Dollar</option>
				<option value="HTG" <% if(strTransactionCurrArray[i].equals("HTG")) {%>selected<% } %>>HTG- Haitian Gourde</option>
				<option value="HNL" <% if(strTransactionCurrArray[i].equals("HNL")) {%>selected<% } %>>HNL- Honduran Lempira</option>
				<option value="HKD" <% if(strTransactionCurrArray[i].equals("HKD")) {%>selected<% } %>>HKD- Hong Kong SAR Dollar</option>
				<option value="HUF" <% if(strTransactionCurrArray[i].equals("HUF")) {%>selected<% } %>>HUF- Hungarian Forint</option>
				<option value="ISK" <% if(strTransactionCurrArray[i].equals("ISK")) {%>selected<% } %>>ISK- Icelandic Krona</option>
				<option value="XDR" <% if(strTransactionCurrArray[i].equals("XDR")) {%>selected<% } %>>XDR- IMF Special Drawing Right</option>
				<option value="INR" <% if(strTransactionCurrArray[i].equals("INR")) {%>selected<% } %>>INR- Indian Rupee</option>
				<option value="IDR" <% if(strTransactionCurrArray[i].equals("IDR")) {%>selected<% } %>>IDR- Indonesian Rupiah</option>
				<option value="IRR" <% if(strTransactionCurrArray[i].equals("IRR")) {%>selected<% } %>>IRR- Iranian Rial</option>
				<option value="IQD" <% if(strTransactionCurrArray[i].equals("IQD")) {%>selected<% } %>>IQD- Iraqi Dinar</option>
				<option value="ILS" <% if(strTransactionCurrArray[i].equals("ILS")) {%>selected<% } %>>ILS- Israeli New Shekel</option>
				<option value="JMD" <% if(strTransactionCurrArray[i].equals("JMD")) {%>selected<% } %>>JMD- Jamaican Dollar</option>
				<option value="JPY" <% if(strTransactionCurrArray[i].equals("JPY")) {%>selected<% } %>>JPY- Japanese Yen</option>
				<option value="JOD" <% if(strTransactionCurrArray[i].equals("JOD")) {%>selected<% } %>>JOD- Jordanian Dinar</option>
				<option value="KZT" <% if(strTransactionCurrArray[i].equals("KZT")) {%>selected<% } %>>KZT- Kazakh Tenge</option>
				<option value="KES" <% if(strTransactionCurrArray[i].equals("KES")) {%>selected<% } %>>KES- Kenyan Shilling</option>
				<option value="KWD" <% if(strTransactionCurrArray[i].equals("KWD")) {%>selected<% } %>>KWD- Kuwaiti Dinar</option>
				<option value="KGS" <% if(strTransactionCurrArray[i].equals("KGS")) {%>selected<% } %>>KGS- Kyrgyz Som</option>
				<option value="LAK" <% if(strTransactionCurrArray[i].equals("LAK")) {%>selected<% } %>>LAK- Lao Kip</option>
				<option value="LVL" <% if(strTransactionCurrArray[i].equals("LVL")) {%>selected<% } %>>LVL- Latvian Lats</option>
				<option value="LBP" <% if(strTransactionCurrArray[i].equals("LBP")) {%>selected<% } %>>LBP- Lebanese Pound</option>
				<option value="LSL" <% if(strTransactionCurrArray[i].equals("LSL")) {%>selected<% } %>>LSL- Lesotho Loti</option>
				<option value="LRD" <% if(strTransactionCurrArray[i].equals("LRD")) {%>selected<% } %>>LRD- Liberian Dollar</option>
				<option value="LYD" <% if(strTransactionCurrArray[i].equals("LYD")) {%>selected<% } %>>LYD- Libyan Dinar</option>
				<option value="LTL" <% if(strTransactionCurrArray[i].equals("LTL")) {%>selected<% } %>>LTL- Lithuanian Litas</option>
				<option value="MOP" <% if(strTransactionCurrArray[i].equals("MOP")) {%>selected<% } %>>MOP- Macao SAR Pataca</option>
				<option value="MKD" <% if(strTransactionCurrArray[i].equals("MKD")) {%>selected<% } %>>MKD- Macedonian Denar</option>
				<option value="MGA" <% if(strTransactionCurrArray[i].equals("MGA")) {%>selected<% } %>>MGA- Malagasy Ariary</option>
				<option value="MWK" <% if(strTransactionCurrArray[i].equals("MWK")) {%>selected<% } %>>MWK- Malawi Kwacha</option>
				<option value="MYR" <% if(strTransactionCurrArray[i].equals("MYR")) {%>selected<% } %>>MYR- Malaysian Ringgit</option>
				<option value="MVR" <% if(strTransactionCurrArray[i].equals("MVR")) {%>selected<% } %>>MVR- Maldivian Rufiyaa</option>
				<option value="MRO" <% if(strTransactionCurrArray[i].equals("MRO")) {%>selected<% } %>>MRO- Mauritanian Ouguiya</option>
				<option value="MUR" <% if(strTransactionCurrArray[i].equals("MUR")) {%>selected<% } %>>MUR- Mauritius Rupee</option>
				<option value="MXN" <% if(strTransactionCurrArray[i].equals("MXN")) {%>selected<% } %>>MXN- Mexican Peso</option>
				<option value="MDL" <% if(strTransactionCurrArray[i].equals("MDL")) {%>selected<% } %>>MDL- Moldovan Leu</option>
				<option value="MNT" <% if(strTransactionCurrArray[i].equals("MNT")) {%>selected<% } %>>MNT- Mongolian Tugrik</option>
				<option value="MAD" <% if(strTransactionCurrArray[i].equals("MAD")) {%>selected<% } %>>MAD- Moroccan Dirham</option>
				<option value="MZN" <% if(strTransactionCurrArray[i].equals("MZN")) {%>selected<% } %>>MZN- Mozambique New Metical</option>
				<option value="MMK" <% if(strTransactionCurrArray[i].equals("MMK")) {%>selected<% } %>>MMK- Myanmar Kyat</option>
				<option value="NAD" <% if(strTransactionCurrArray[i].equals("NAD")) {%>selected<% } %>>NAD- Namibian Dollar</option>
				<option value="NPR" <% if(strTransactionCurrArray[i].equals("NPR")) {%>selected<% } %>>NPR- Nepalese Rupee</option>
				<option value="ANG" <% if(strTransactionCurrArray[i].equals("ANG")) {%>selected<% } %>>ANG- Netherlands Antillian Guilder</option>
				<option value="NZD" <% if(strTransactionCurrArray[i].equals("NZD")) {%>selected<% } %>>NZD- New Zealand Dollar</option>
				<option value="NIO" <% if(strTransactionCurrArray[i].equals("NIO")) {%>selected<% } %>>NIO- Nicaraguan Cordoba Oro</option>
				<option value="NGN" <% if(strTransactionCurrArray[i].equals("NGN")) {%>selected<% } %>>NGN- Nigerian Naira</option>
				<option value="KPW" <% if(strTransactionCurrArray[i].equals("KPW")) {%>selected<% } %>>KPW- North Korean Won</option>
				<option value="NOK" <% if(strTransactionCurrArray[i].equals("NOK")) {%>selected<% } %>>NOK- Norwegian Krone</option>
				<option value="OMR" <% if(strTransactionCurrArray[i].equals("OMR")) {%>selected<% } %>>OMR- Omani Rial</option>
				<option value="PKR" <% if(strTransactionCurrArray[i].equals("PKR")) {%>selected<% } %>>PKR- Pakistani Rupee</option>
				<option value="XPD" <% if(strTransactionCurrArray[i].equals("XPD")) {%>selected<% } %>>XPD- Palladium (Ounce)</option>
				<option value="PAB" <% if(strTransactionCurrArray[i].equals("PAB")) {%>selected<% } %>>PAB- Panamanian Balboa</option>
				<option value="PGK" <% if(strTransactionCurrArray[i].equals("PGK")) {%>selected<% } %>>PGK- Papua New Guinea Kina</option>
				<option value="PYG" <% if(strTransactionCurrArray[i].equals("PYG")) {%>selected<% } %>>PYG- Paraguayan Guarani</option>
				<option value="PEN" <% if(strTransactionCurrArray[i].equals("PEN")) {%>selected<% } %>>PEN- Peruvian Nuevo Sol</option>
				<option value="PHP" <% if(strTransactionCurrArray[i].equals("PHP")) {%>selected<% } %>>PHP- Philippine Peso</option>
				<option value="XPT" <% if(strTransactionCurrArray[i].equals("XPT")) {%>selected<% } %>>XPT- Platinum (Ounce)</option>
				<option value="PLN" <% if(strTransactionCurrArray[i].equals("PLN")) {%>selected<% } %>>PLN- Polish Zloty</option>
				<option value="QAR" <% if(strTransactionCurrArray[i].equals("QAR")) {%>selected<% } %>>QAR- Qatari Rial</option>
				<option value="RON" <% if(strTransactionCurrArray[i].equals("RON")) {%>selected<% } %>>RON- Romanian New Leu</option>
				<option value="RUB" <% if(strTransactionCurrArray[i].equals("RUB")) {%>selected<% } %>>RUB- Russian Ruble</option>
				<option value="RWF" <% if(strTransactionCurrArray[i].equals("RWF")) {%>selected<% } %>>RWF- Rwandan Franc</option>
				<option value="SHP" <% if(strTransactionCurrArray[i].equals("SHP")) {%>selected<% } %>>SHP- Saint Helena Pound</option>
				<option value="WST" <% if(strTransactionCurrArray[i].equals("WST")) {%>selected<% } %>>WST- Samoan Tala</option>
				<option value="STD" <% if(strTransactionCurrArray[i].equals("STD")) {%>selected<% } %>>STD- Sao Tome And Principe Dobra</option>
				<option value="SAR" <% if(strTransactionCurrArray[i].equals("SAR")) {%>selected<% } %>>SAR- Saudi Riyal</option>
				<option value="RSD" <% if(strTransactionCurrArray[i].equals("RSD")) {%>selected<% } %>>RSD- Serbian Dinar</option>
				<option value="SCR" <% if(strTransactionCurrArray[i].equals("SCR")) {%>selected<% } %>>SCR- Seychelles Rupee</option>
				<option value="SLL" <% if(strTransactionCurrArray[i].equals("SLL")) {%>selected<% } %>>SLL- Sierra Leone Leone</option>
				<option value="XAG" <% if(strTransactionCurrArray[i].equals("XAG")) {%>selected<% } %>>XAG- Silver (Ounce)</option>
				<option value="SGD" <% if(strTransactionCurrArray[i].equals("SGD")) {%>selected<% } %>>SGD- Singapore Dollar</option>
				<option value="SBD" <% if(strTransactionCurrArray[i].equals("SBD")) {%>selected<% } %>>SBD- Solomon Islands Dollar</option>
				<option value="SOS" <% if(strTransactionCurrArray[i].equals("SOS")) {%>selected<% } %>>SOS- Somali Shilling</option>
				<option value="ZAR" <% if(strTransactionCurrArray[i].equals("ZAR")) {%>selected<% } %>>ZAR- South African Rand</option>
				<option value="KRW" <% if(strTransactionCurrArray[i].equals("KRW")) {%>selected<% } %>>KRW- South Korean Won</option>
				<option value="LKR" <% if(strTransactionCurrArray[i].equals("LKR")) {%>selected<% } %>>LKR- Sri Lanka Rupee</option>
				<option value="SDG" <% if(strTransactionCurrArray[i].equals("SDG")) {%>selected<% } %>>SDG- Sudanese Pound</option>
				<option value="SRD" <% if(strTransactionCurrArray[i].equals("SRD")) {%>selected<% } %>>SRD- Suriname Dollar</option>
				<option value="SZL" <% if(strTransactionCurrArray[i].equals("SZL")) {%>selected<% } %>>SZL- Swaziland Lilangeni</option>
				<option value="SEK" <% if(strTransactionCurrArray[i].equals("SEK")) {%>selected<% } %>>SEK- Swedish Krona</option>
				<option value="CHF" <% if(strTransactionCurrArray[i].equals("CHF")) {%>selected<% } %>>CHF- Swiss Franc</option>
				<option value="SYP" <% if(strTransactionCurrArray[i].equals("SYP")) {%>selected<% } %>>SYP- Syrian Pound</option>
				<option value="TWD" <% if(strTransactionCurrArray[i].equals("TWD")) {%>selected<% } %>>TWD- Taiwan New Dollar</option>
				<option value="TJS" <% if(strTransactionCurrArray[i].equals("TJS")) {%>selected<% } %>>TJS- Tajik Somoni</option>
				<option value="TZS" <% if(strTransactionCurrArray[i].equals("TZS")) {%>selected<% } %>>TZS- Tanzanian Shilling</option>
				<option value="THB" <% if(strTransactionCurrArray[i].equals("THB")) {%>selected<% } %>>THB- Thai Baht</option>
				<option value="TOP" <% if(strTransactionCurrArray[i].equals("TOP")) {%>selected<% } %>>TOP- Tongan Pa'anga</option>
				<option value="TTD" <% if(strTransactionCurrArray[i].equals("TTD")) {%>selected<% } %>>TTD- Trinidad And Tobago Dollar</option>
				<option value="TND" <% if(strTransactionCurrArray[i].equals("TND")) {%>selected<% } %>>TND- Tunisian Dinar</option>
				<option value="TRY" <% if(strTransactionCurrArray[i].equals("TRY")) {%>selected<% } %>>TRY- Turkish Lira</option>
				<option value="TMT" <% if(strTransactionCurrArray[i].equals("TMT")) {%>selected<% } %>>TMT- Turkmen New Manat</option>
				<option value="AED" <% if(strTransactionCurrArray[i].equals("AED")) {%>selected<% } %>>AED- UAE Dirham</option>
				<option value="UGX" <% if(strTransactionCurrArray[i].equals("UGX")) {%>selected<% } %>>UGX- Uganda New Shilling</option>
				<option value="XFU" <% if(strTransactionCurrArray[i].equals("XFU")) {%>selected<% } %>>XFU- UIC Franc</option>
				<option value="UAH" <% if(strTransactionCurrArray[i].equals("UAH")) {%>selected<% } %>>UAH- Ukrainian Hryvnia</option>
				<option value="UYU" <% if(strTransactionCurrArray[i].equals("UYU")) {%>selected<% } %>>UYU- Uruguayan Peso Uruguayo</option>
				<option value="USD" <% if(strTransactionCurrArray[i].equals("USD")) {%>selected<% } %>>USD- US Dollar</option>
				<option value="UZS" <% if(strTransactionCurrArray[i].equals("UZS")) {%>selected<% } %>>UZS- Uzbekistani Sum</option>
				<option value="VUV" <% if(strTransactionCurrArray[i].equals("VUV")) {%>selected<% } %>>VUV- Vanuatu Vatu</option>
				<option value="VEF" <% if(strTransactionCurrArray[i].equals("VEF")) {%>selected<% } %>>VEF- Venezuelan Bolivar Fuerte</option>
				<option value="VND" <% if(strTransactionCurrArray[i].equals("VND")) {%>selected<% } %>>VND- Vietnamese Dong</option>
				<option value="YER" <% if(strTransactionCurrArray[i].equals("YER")) {%>selected<% } %>>YER- Yemeni Rial</option>
				<option value="ZMK" <% if(strTransactionCurrArray[i].equals("ZMK")) {%>selected<% } %>>ZMK- Zambian Kwacha</option>
				<option value="ZWL" <% if(strTransactionCurrArray[i].equals("ZWL")) {%>selected<% } %>>ZWL- Zimbabwe Dollar</option>
				<option value="XXX" <% if(strTransactionCurrArray[i].equals("XXX")) {%>selected<% } %>>XXX- Not available </option>
				<option value="ZZZ" <% if(strTransactionCurrArray[i].equals("ZZZ")) {%>selected<% } %>>ZZZ- Others </option>
			</select></td>
			<td><input type="text" readonly name="amtInRupees" value="<%= (strTransactionAmtInRupeesArray[i] == null) ? "" : strTransactionAmtInRupeesArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>TRN</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td style="text-align : center;">
				<a href="#1" onclick="updateTransactionDetails('<%=strTransactionDateArray[i]%>','<%=strTransactionTypeArray[i]%>','<%=strTransactionInstrumentTypeArray[i]%>','<%=strTransactionCurrArray[i]%>','<%=strTransactionAmtInRupeesArray[i]%>','<%=strTransactionSeqNoArray[i]%>','<%=i+1%>')"><img alt="update details" title="Update Details" src="${pageContext.request.contextPath}/includes/images/edit.png"/></a>
				<a href="#1" onclick="deleteTransactionDetails('<%=strTransactionDateArray[i]%>','<%=strTransactionTypeArray[i]%>','<%=strTransactionInstrumentTypeArray[i]%>','<%=strTransactionCurrArray[i]%>','<%=strTransactionAmtInRupeesArray[i]%>','<%=strTransactionSeqNoArray[i]%>','<%=i+1%>')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
			<th>4.<%=i+1%></th>
			<!-- <td><input type="text"  name="chTransactionDate"  class="topOpenTextBox" size=12 maxlength=12 id="chTransactionDate"/></td> -->
			<td><input type="text" name="transactionDate" id="transactionDate" readonly value="<%=(strTransactionDateArray[i] == null) ? "" : strTransactionDateArray[i] %>" /></td>
			<td><select name="transactionType">
				<option value="P">P -Purchase</option>
				<option value="R">R -Redemption</option>	
			</select></td>
			<td><select name="instrumentType" >
				<option value="A">A - Currency Note</option>
				<option value="B">B - Travelers Cheque</option>
				<option value="C">C - Demand Draft</option>
				<option value="D">D - Money Order</option>
				<option value="E">E - Wire Transfers / TT</option>
				<option value="F">F - Money Transfer</option>
				<option value="G">G - Credit card</option>
				<option value="H">H - Debit card</option>
				<option value="I">I - Smart card</option>
				<option value="J">J - Prepaid card</option>	
				<option value="K">K - Gift card</option>
				<option value="L">L - Cheque</option>
				<option value="Z">Z - Others</option>
				<option value="X">X - Not Categorised</option>
			</select></td>
			<td><select name="currencyCode" >
				<option value="AFA">AFA- Afghanistan Afghani</option>
				<option value="ALL">ALL- Albanian Lek</option>
				<option value="DZD">DZD- Algerian Dinar</option>
				<option value="AOR">AOR- Angolan Kwanza Reajustado</option>
				<option value="ARS">ARS- Argentine Peso</option>
				<option value="AMD">AMD- Armenian Dram</option>
				<option value="AWG">AWG- Aruban Guilder</option>
				<option value="AUD">AUD- Australian Dollar</option>
				<option value="AZN">AZN- Azerbaijanian New Manat</option>
				<option value="BSD">BSD- Bahamian Dollar</option>
				<option value="BHD">BHD- Bahraini Dinar</option>
				<option value="BDT">BDT- Bangladeshi Taka</option>
				<option value="BBD">BBD- Barbados Dollar</option>
				<option value="BYR">BYR- Belarusian Ruble</option>
				<option value="BZD">BZD- Belize Dollar</option>
				<option value="BMD">BMD- Bermudian Dollar</option>
				<option value="BTN">BTN- Bhutan Ngultrum</option>
				<option value="BOB">BOB- Bolivian Boliviano</option>
				<option value="BWP">BWP- Botswana Pula</option>
				<option value="BRL">BRL- Brazilian Real</option>
				<option value="GBP">GBP- British Pound</option>
				<option value="BND">BND- Brunei Dollar</option>
				<option value="BGN">BGN- Bulgarian Lev</option>
				<option value="BIF">BIF- Burundi Franc</option>
				<option value="KHR">KHR- Cambodian Riel</option>
				<option value="CAD">CAD- Canadian Dollar</option>
				<option value="CVE">CVE- Cape Verde Escudo</option>
				<option value="KYD">KYD- Cayman Islands Dollar</option>
				<option value="XOF">XOF- CFA Franc BCEAO</option>
				<option value="XAF">XAF- CFA Franc BEAC</option>
				<option value="XPF">XPF- CFP Franc</option>
				<option value="CLP">CLP- Chilean Peso</option>
				<option value="CNY">CNY- Chinese Yuan Renminbi</option>
				<option value="COP">COP- Colombian Peso</option>
				<option value="KMF">KMF- Comoros Franc</option>
				<option value="CDF">CDF- Congolese Franc</option>
				<option value="CRC">CRC- Costa Rican Colon</option>
				<option value="HRK">HRK- Croatian Kuna</option>
				<option value="CUP">CUP- Cuban Peso</option>
				<option value="CZK">CZK- Czech Koruna</option>
				<option value="DKK">DKK- Danish Krone</option>
				<option value="DJF">DJF- Djibouti Franc</option>
				<option value="DOP">DOP- Dominican Peso</option>
				<option value="XCD">XCD- East Caribbean Dollar</option>
				<option value="EGP">EGP- Egyptian Pound</option>
				<option value="SVC">SVC- El Salvador Colon</option>
				<option value="ERN">ERN- Eritrean Nakfa</option>
				<option value="EEK">EEK- Estonian Kroon</option>
				<option value="ETB">ETB- Ethiopian Birr</option>
				<option value="EUR">EUR- EU Euro</option>
				<option value="FKP">FKP- Falkland Islands Pound</option>
				<option value="FJD">FJD- Fiji Dollar</option>
				<option value="GMD">GMD- Gambian Dalasi</option>
				<option value="GEL">GEL- Georgian Lari</option>
				<option value="GHS">GHS- Ghanaian New Cedi</option>
				<option value="GIP">GIP- Gibraltar Pound</option>
				<option value="XAU">XAU- Gold (Ounce)</option>
				<option value="XFO">XFO- Gold Franc</option>
				<option value="GTQ">GTQ- Guatemalan Quetzal</option>
				<option value="GNF">GNF- Guinean Franc</option>
				<option value="GYD">GYD- Guyana Dollar</option>
				<option value="HTG">HTG- Haitian Gourde</option>
				<option value="HNL">HNL- Honduran Lempira</option>
				<option value="HKD">HKD- Hong Kong SAR Dollar</option>
				<option value="HUF">HUF- Hungarian Forint</option>
				<option value="ISK">ISK- Icelandic Krona</option>
				<option value="XDR">XDR- IMF Special Drawing Right</option>
				<option value="INR">INR- Indian Rupee</option>
				<option value="IDR">IDR- Indonesian Rupiah</option>
				<option value="IRR">IRR- Iranian Rial</option>
				<option value="IQD">IQD- Iraqi Dinar</option>
				<option value="ILS">ILS- Israeli New Shekel</option>
				<option value="JMD">JMD- Jamaican Dollar</option>
				<option value="JPY">JPY- Japanese Yen</option>
				<option value="JOD">JOD- Jordanian Dinar</option>
				<option value="KZT">KZT- Kazakh Tenge</option>
				<option value="KES">KES- Kenyan Shilling</option>
				<option value="KWD">KWD- Kuwaiti Dinar</option>
				<option value="KGS">KGS- Kyrgyz Som</option>
				<option value="LAK">LAK- Lao Kip</option>
				<option value="LVL">LVL- Latvian Lats</option>
				<option value="LBP">LBP- Lebanese Pound</option>
				<option value="LSL">LSL- Lesotho Loti</option>
				<option value="LRD">LRD- Liberian Dollar</option>
				<option value="LYD">LYD- Libyan Dinar</option>
				<option value="LTL">LTL- Lithuanian Litas</option>
				<option value="MOP">MOP- Macao SAR Pataca</option>
				<option value="MKD">MKD- Macedonian Denar</option>
				<option value="MGA">MGA- Malagasy Ariary</option>
				<option value="MWK">MWK- Malawi Kwacha</option>
				<option value="MYR">MYR- Malaysian Ringgit</option>
				<option value="MVR">MVR- Maldivian Rufiyaa</option>
				<option value="MRO">MRO- Mauritanian Ouguiya</option>
				<option value="MUR">MUR- Mauritius Rupee</option>
				<option value="MXN">MXN- Mexican Peso</option>
				<option value="MDL">MDL- Moldovan Leu</option>
				<option value="MNT">MNT- Mongolian Tugrik</option>
				<option value="MAD">MAD- Moroccan Dirham</option>
				<option value="MZN">MZN- Mozambique New Metical</option>
				<option value="MMK">MMK- Myanmar Kyat</option>
				<option value="NAD">NAD- Namibian Dollar</option>
				<option value="NPR">NPR- Nepalese Rupee</option>
				<option value="ANG">ANG- Netherlands Antillian Guilder</option>
				<option value="NZD">NZD- New Zealand Dollar</option>
				<option value="NIO">NIO- Nicaraguan Cordoba Oro</option>
				<option value="NGN">NGN- Nigerian Naira</option>
				<option value="KPW">KPW- North Korean Won</option>
				<option value="NOK">NOK- Norwegian Krone</option>
				<option value="OMR">OMR- Omani Rial</option>
				<option value="PKR">PKR- Pakistani Rupee</option>
				<option value="XPD">XPD- Palladium (Ounce)</option>
				<option value="PAB">PAB- Panamanian Balboa</option>
				<option value="PGK">PGK- Papua New Guinea Kina</option>
				<option value="PYG">PYG- Paraguayan Guarani</option>
				<option value="PEN">PEN- Peruvian Nuevo Sol</option>
				<option value="PHP">PHP- Philippine Peso</option>
				<option value="XPT">XPT- Platinum (Ounce)</option>
				<option value="PLN">PLN- Polish Zloty</option>
				<option value="QAR">QAR- Qatari Rial</option>
				<option value="RON">RON- Romanian New Leu</option>
				<option value="RUB">RUB- Russian Ruble</option>
				<option value="RWF">RWF- Rwandan Franc</option>
				<option value="SHP">SHP- Saint Helena Pound</option>
				<option value="WST">WST- Samoan Tala</option>
				<option value="STD">STD- Sao Tome And Principe Dobra</option>
				<option value="SAR">SAR- Saudi Riyal</option>
				<option value="RSD">RSD- Serbian Dinar</option>
				<option value="SCR">SCR- Seychelles Rupee</option>
				<option value="SLL">SLL- Sierra Leone Leone</option>
				<option value="XAG">XAG- Silver (Ounce)</option>
				<option value="SGD">SGD- Singapore Dollar</option>
				<option value="SBD">SBD- Solomon Islands Dollar</option>
				<option value="SOS">SOS- Somali Shilling</option>
				<option value="ZAR">ZAR- South African Rand</option>
				<option value="KRW">KRW- South Korean Won</option>
				<option value="LKR">LKR- Sri Lanka Rupee</option>
				<option value="SDG">SDG- Sudanese Pound</option>
				<option value="SRD">SRD- Suriname Dollar</option>
				<option value="SZL">SZL- Swaziland Lilangeni</option>
				<option value="SEK">SEK- Swedish Krona</option>
				<option value="CHF">CHF- Swiss Franc</option>
				<option value="SYP">SYP- Syrian Pound</option>
				<option value="TWD">TWD- Taiwan New Dollar</option>
				<option value="TJS">TJS- Tajik Somoni</option>
				<option value="TZS">TZS- Tanzanian Shilling</option>
				<option value="THB">THB- Thai Baht</option>
				<option value="TOP">TOP- Tongan Pa'anga</option>
				<option value="TTD">TTD- Trinidad And Tobago Dollar</option>
				<option value="TND">TND- Tunisian Dinar</option>
				<option value="TRY">TRY- Turkish Lira</option>
				<option value="TMT">TMT- Turkmen New Manat</option>
				<option value="AED">AED- UAE Dirham</option>
				<option value="UGX">UGX- Uganda New Shilling</option>
				<option value="XFU">XFU- UIC Franc</option>
				<option value="UAH">UAH- Ukrainian Hryvnia</option>
				<option value="UYU">UYU- Uruguayan Peso Uruguayo</option>
				<option value="USD">USD- US Dollar</option>
				<option value="UZS">UZS- Uzbekistani Sum</option>
				<option value="VUV">VUV- Vanuatu Vatu</option>
				<option value="VEF">VEF- Venezuelan Bolivar Fuerte</option>
				<option value="VND">VND- Vietnamese Dong</option>
				<option value="YER">YER- Yemeni Rial</option>
				<option value="ZMK">ZMK- Zambian Kwacha</option>
				<option value="ZWL">ZWL- Zimbabwe Dollar</option>
				<option value="XXX">XXX- Not available </option>
				<option value="ZZZ">ZZZ- Others </option>
			</select></td>
			<td><input type="text" readonly name="amtInRupees" value="<%= (strTransactionAmtInRupeesArray[i] == null) ? "" : strTransactionAmtInRupeesArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>TRN</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td class="leftAligned"></td>
		</tr>
		<% } } %>
	</table>
</div>

<%}catch(Exception e){e.printStackTrace();}%>