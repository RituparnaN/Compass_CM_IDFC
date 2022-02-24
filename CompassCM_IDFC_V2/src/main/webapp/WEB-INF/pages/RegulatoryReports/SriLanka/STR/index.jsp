<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	String caseNo = (String) request.getAttribute("CASENO");
	Map<String, String> SLSTR = request.getAttribute("SLSTR") != null ? (Map<String, String>) request.getAttribute("SLSTR") : new HashMap<String, String>();
	String message = request.getParameter("M") != null ? (String) request.getParameter("M") : "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Srilanka STR</title>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/html5shiv.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/html5shiv.min.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css">
<link rel="Stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/slstrStyle.css" />
<style type="text/css">
	.date{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
 <script>
  $(function() {
    $(".date").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	 });
    
    var msg = '<%=message%>';
    if(msg != '')
    	alert(msg);

	$(".submitSTR").click(function(){
		var groundofsuspicion = "";
		$(".groundofsuspicion").each(function(){
			if($(this).prop("checked")){
				groundofsuspicion = groundofsuspicion+$(this).val();
			}
		});
		$("#GROUNDOFSUSPICION").val(groundofsuspicion);
		return true;
	});
    
  });
  </script>
</head>
<body>
	<div class="content">
	<form action="${pageContext.request.contextPath}/common/saveSLSTR" method="GET">
		<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
		<div class="box">
			<div class="header header-main">
				SUSPICIOUS TRANSACTIONS REPORT (STR) IN TERMS OF 
				FINANCIAL TRANSACTIONS REPORTING ACT NO. 6 OF 2006
			</div>
			<div class="section">
				<strong>
					Please note that to be accepted as a STR, this form must be completed in all material detail
				</strong>
				<br/>
				<br/>
				<p>a. This report is made pursuant to the requirement to report suspicious
				   transactions under the Financial Transactions Reporting Act No.6 of 2006 (FTRA). 
				</p>
				<p>
				b. Under section 12 of the FTRA, no civil, criminal or disciplinary proceedings 
				shall be brought against a person who makes a report unless it was made in bad faith. 
				</p>
				<br/>
				In accordance with Section 7 of the Financial Transactions Reporting Act No. 6 of 2006,
				the reporting entity is obliged to report suspicious transactions as soon as is practicable 
				but no later than 2 working days to the Financial Intelligence Unit.
				<br/>
				<br/>
				Please take note of the following prior to completing the Suspicious Transaction Report ("STR") 
				<ul>
					<li>
						<strong>Provide</strong> a clear and concise description of the STR, and 
						<strong>state</strong> all available information.
					</li>
					<li>
						<strong>Document</strong> in detail why the <strong>transaction</strong>
						 is considered extraordinary, irregular or <strong>suspicious</strong>.
					</li>
					<li>
						<strong>Provide</strong> supporting documents where it is necessary to explain the STR.
					</li>					
					<li>
						<strong>Indicate</strong> if the potential violation is an initial report
						or if it relates to a previous transaction or <strong>transactions</strong> reported.
					</li>
					<li>
						<strong>Complete</strong> this STR in Block letters.
					</li>
					<li>
						Take reference to the explanatory notes at page 5.
					</li>
				</ul> 
			</div>
		</div>
		<center>1</center>
		<br/>
		<br/>
		<h2>CONFIDENTIAL</h2>
		<h4>Kindly fill in CAPITAL. Read the instructions before filling the form</h4>
		<div class="box">
			<div class="header header-main">
				PART A: DETAILS OF REPORT
			</div>
			<div class="section">
				<table style="text-align: left;">
						<tr>
							<td width="3%">1.1</td>
							<th width="37%">Date of sending report</th>
							<td>
								<input type="text" name="DATEOFSENDINGREPORT" id="datepicker" class="date" value="<%= SLSTR.get("DATEOFSENDINGREPORT") != null ? SLSTR.get("DATEOFSENDINGREPORT") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>1.2</td>
							<th>Is this a replacement to an earlier report? </th>
							<td>
								<input type="checkbox" name="EARLIERREPORTREPLACEMENT" id="replacementOfEarlier" value="N" <% if("N".equals(SLSTR.get("EARLIERREPORTREPLACEMENT"))){ %> checked="checked" <%} %>/>
								<label for="replacementOfEarlier">NO</label>
							</td>
						</tr>
						<tr>
							<td>1.3</td>
							<th>Date of sending original report if this is a replacement report</th>
							<td>
								<input type="text" name="ORIGINALREPORTDATE" id="datepicker1" class="date" value="<%= SLSTR.get("ORIGINALREPORTDATE") != null ? SLSTR.get("ORIGINALREPORTDATE") : ""%>"/>
							</td>
						</tr>
				</table>
			</div>
			<div class="header header-main">
				PART B: INFORMATION ON CUSTOMERS 
			</div>
			<div class="header header-sub">
				a) Account Holder
			</div>			 
			<div class="section">
				<table style="text-align: left;">
						<tr>
							<td width="3%">1</td>
							<th width="37%">
								Name in full
								(if organization, provide registered 
								business/organization name)
							</th>
							<td>
								<input type="text" name="FULLNAME" id="fullname" value="<%= SLSTR.get("FULLNAME") != null ? SLSTR.get("FULLNAME") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>2</td>
							<th>
								NIC No./ Passport No./Nationality/Business
								Registration No
							</th>
							<td>
								<input type="text" name="NICPASSPORTNATBUSSNO" id="nicPassportNatBusinessNo" value="<%= SLSTR.get("NICPASSPORTNATBUSSNO") != null ? SLSTR.get("NICPASSPORTNATBUSSNO") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>3</td>
							<th>Gender</th>
							<td>
								<input type="radio" name="GENDER" id="male1" value="M" <% if("M".equals(SLSTR.get("GENDER"))){ %> checked="checked" <%} %>>
								<label for="male1">MALE</label>
								<input type="radio" name="GENDER" id="female1" value="F" <% if("F".equals(SLSTR.get("GENDER"))){ %> checked="checked" <%} %>>
								<label for="female1">FEMALE</label>								
							</td>
						</tr>
						<tr>
							<td>4</td>
							<th>Country of Residence </th>
							<td>
								<input type="text" name="RESIDENCECOUNTRY" id="countryResidence" value="<%= SLSTR.get("RESIDENCECOUNTRY") != null ? SLSTR.get("RESIDENCECOUNTRY") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>5</td>
							<!--<th>Business/ Employment Type</th>-->
							<th>Customer Type</th>
							<td>
								<input type="text" name="BUSINESSEMPLOYMENTTYPE" id="businessEmploymentType" value="<%= SLSTR.get("BUSINESSEMPLOYMENTTYPE") != null ? SLSTR.get("BUSINESSEMPLOYMENTTYPE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>6</td>
							<th>
								Occupation (Where appropriate, principle activity 
								of the person conducting transaction
							</th>
							<td>
								<input type="text" name="OCCUPATION" id="occupation"  value="<%= SLSTR.get("OCCUPATION") != null ? SLSTR.get("OCCUPATION") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>7</td>
							<th>Occupation Description </th>
							<td>
								<input type="text" name="OCCUPATIONDESC" id="occupationDesc"  value="<%= SLSTR.get("OCCUPATIONDESC") != null ? SLSTR.get("OCCUPATIONDESC") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>8</td>
							<th>Name of Employer (Where applicable) </th>
							<td>
								<input type="text" name="EMPLOYERNAME" id="employerName"  value="<%= SLSTR.get("EMPLOYERNAME") != null ? SLSTR.get("EMPLOYERNAME") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>9</td>
							<th>Residential/Registered Address </th>
							<td>
								<input type="text" name="RESREGADDRESS" id="resRegAddress"  value="<%= SLSTR.get("RESREGADDRESS") != null ? SLSTR.get("RESREGADDRESS") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>10</td>
							<th>Country</th>
							<td>
								<input type="text" name="COUNTRY" id="country"  value="<%= SLSTR.get("COUNTRY") != null ? SLSTR.get("COUNTRY") : ""%>"/>
							</td>
						</tr>
						<!--
						<tr>
							<td>11</td>
							<th>Details of Other Business/Related Accounts </th>
							<td>
								<input type="text" name="OTHERBUSSRELETEDACCDETAILS" id="otherBusinessDetails"  value="<%= SLSTR.get("OTHERBUSSRELETEDACCDETAILS") != null ? SLSTR.get("OTHERBUSSRELETEDACCDETAILS") : ""%>"/>
							</td>
						</tr>
						-->
						<input type="hidden" name="OTHERBUSSRELETEDACCDETAILS" id="otherBusinessDetails"  value="<%= SLSTR.get("OTHERBUSSRELETEDACCDETAILS") != null ? SLSTR.get("OTHERBUSSRELETEDACCDETAILS") : ""%>"/>

						<tr>
							<td>11</td>
							<th>Telephone No. </th>
							<td>
								<input type="text" name="TELEPHONENO" id="telephoneNo"  value="<%= SLSTR.get("TELEPHONENO") != null ? SLSTR.get("TELEPHONENO") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>12</td>
							<th>Date of last review of customer details </th>
							<td>
								<input type="text" name="LASTREVIEWDATE" id="lastReviewDate" class="date"  value="<%= SLSTR.get("LASTREVIEWDATE") != null ? SLSTR.get("LASTREVIEWDATE") : ""%>"/>
							</td>
						</tr>
				</table>
				Brief description of customer's relationship with the bank
				<textarea rows="" cols="" name="CUSTOMERRELATION"><%= SLSTR.get("CUSTOMERRELATION") != null ? SLSTR.get("CUSTOMERRELATION") : ""%></textarea>
			</div>			
			<div class="header header-sub">
				b. Person conducting suspicious transactions (If not, the holder in what capacity)
			</div>
			<div class="section">
				<table style="text-align: left;">
					<tbody>
						<tr>
							<td width="3%">13</td>
							<th width="37%">
								Name in Full (If organization, provide registered
								business/organization name) 
							</th>
							<td>
								<input type="text" name="FULLNAME1" id="fullName1"  value="<%= SLSTR.get("FULLNAME1") != null ? SLSTR.get("FULLNAME1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>14</td>
							<th>
								NIC No./ Passport No./Nationality/Business Registration No. 
							</th>
							<td>
								<input type="text" name="NICPASSPORTNATBUSSNO1" id="nicPassportNatBusinessNo1"  value="<%= SLSTR.get("NICPASSPORTNATBUSSNO1") != null ? SLSTR.get("NICPASSPORTNATBUSSNO1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>15</td>
							<th>Gender</th>
							<td>
								<input type="radio" name="GENDER1" id="male" value="M" <% if("M".equals(SLSTR.get("GENDER1"))){ %> checked="checked" <%} %>>
								<label for="male">MALE</label>
								<input type="radio" name="GENDER1" id="female" value="F" <% if("F".equals(SLSTR.get("GENDER1"))){ %> checked="checked" <%} %>>
								<label for="female">FEMALE</label>	
							</td>
						</tr>
						<tr>
							<td>16</td>
							<th>Country of Residence</th>
							<td>
								<input type="text" name="RESIDENCECOUNTRY1" id="countryResidence1"  value="<%= SLSTR.get("RESIDENCECOUNTRY1") != null ? SLSTR.get("RESIDENCECOUNTRY1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>17</td>
							<!--<th>Business/ Employment Type</th>-->
							<th>Customer Type</th>
							<td>
								<input type="text" name="BUSINESSEMPLOYMENTTYPE1" id="businessEmploymentType1"  value="<%= SLSTR.get("BUSINESSEMPLOYMENTTYPE1") != null ? SLSTR.get("BUSINESSEMPLOYMENTTYPE1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>18</td>
							<th>
								Occupation (Where appropriate, principle activity of the
								person conducting transaction) 
							</th>
							<td>
								<input type="text" name="OCCUPATION1" id="occupation1"  value="<%= SLSTR.get("OCCUPATION1") != null ? SLSTR.get("OCCUPATION1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>19</td>
							<th>Occupation Description </th>
							<td>
								<input type="text" name="OCCUPATIONDESC1" id="occupationDesc1" value="<%= SLSTR.get("OCCUPATIONDESC1") != null ? SLSTR.get("OCCUPATIONDESC1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>20</td>
							<th>Name of Employer (Where applicable)</th>
							<td>
								<input type="text" name="EMPLOYERNAME1" id="employerName1" value="<%= SLSTR.get("EMPLOYERNAME1") != null ? SLSTR.get("EMPLOYERNAME1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>21</td>
							<th>Residential/Registered Address </th>
							<td>
								<input type="text" name="RESREGADDRESS1" id="resRegAddress1" value="<%= SLSTR.get("RESREGADDRESS1") != null ? SLSTR.get("RESREGADDRESS1") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>22</td>
							<th>Town</th>
							<td>
								<input type="text" name="TOWN" id="town" value="<%= SLSTR.get("TOWN") != null ? SLSTR.get("TOWN") : ""%>"/>
							</td>
						</tr>
						<!--<tr>
							<td>24</td>
							<th>Details of Other Business/related Accounts</th>
							<td>
								<input type="text" name="OTHERBUSSRELETEDACCDETAILS1" id="otherBusinessDetails1" value="<%= SLSTR.get("OTHERBUSSRELETEDACCDETAILS1") != null ? SLSTR.get("OTHERBUSSRELETEDACCDETAILS1") : ""%>"/>
							</td>
						</tr>-->
						<input type="hidden" name="OTHERBUSSRELETEDACCDETAILS1" id="otherBusinessDetails1" value="<%= SLSTR.get("OTHERBUSSRELETEDACCDETAILS1") != null ? SLSTR.get("OTHERBUSSRELETEDACCDETAILS1") : ""%>"/>

					</tbody>
				</table>
			</div>
		</div>
		<center>2</center>
		<br/><br/>
		<div class="box">
			<div class="header header-main">
				PART C: TRANSACTION DETAILS
			</div>
			<div class="section">
				<table style="text-align: left;">
					<tbody>
						<tr>
							<td width="3%">23</td>
							<th width="37%">Account Number</th>
							<td>
								<input type="text" name="ACCOUNTNUMBER" id="accountNo" value="<%= SLSTR.get("ACCOUNTNUMBER") != null ? SLSTR.get("ACCOUNTNUMBER") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>24</td>
							<th>Account Type</th>
							<td>
								<input type="text" name="ACCOUNTTYPE" id="accountType" value="<%= SLSTR.get("ACCOUNTTYPE") != null ? SLSTR.get("ACCOUNTTYPE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>25</td>
							<th>Branch</th>
							<td>
								<input type="text" name="BRANCH" id="branch" value="<%= SLSTR.get("BRANCH") != null ? SLSTR.get("BRANCH") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>26</td>
							<th>Branch Address</th>
							<td>
								<input type="text" name="BRANCHADDRESS" id="branchAddress" value="<%= SLSTR.get("BRANCHADDRESS") != null ? SLSTR.get("BRANCHADDRESS") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>27</td>
							<th>Account Opened Date</th>
							<td>
								<input type="text" name="ACCOUNTOPENEDDATE" class="date" id="accountOpenedDate" value="<%= SLSTR.get("ACCOUNTOPENEDDATE") != null ? SLSTR.get("ACCOUNTOPENEDDATE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>28</td>
							<th>Account Status</th>
							<td>
								<input type="text" name="ACCOUNTSTATUS" id="accountStatus" value="<%= SLSTR.get("ACCOUNTSTATUS") != null ? SLSTR.get("ACCOUNTSTATUS") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>29</td>
							<th>Frequency</th>
							<td>
								<input type="text" name="FREQUENCY" id="frequency" value="<%= SLSTR.get("FREQUENCY") != null ? SLSTR.get("FREQUENCY") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>30</td>
							<th>Date of Transaction</th>
							<td>
								<input type="text" name="TRANSACTIONDATE" class="date" id="transactionDate" value="<%= SLSTR.get("TRANSACTIONDATE") != null ? SLSTR.get("TRANSACTIONDATE") : ""%>"/>
							</td>
						</tr>
						<!--
						<tr>
							<td>31</td>
							<th>Total Amount</th>
							<td>
								<input type="text" name="TOTALAMOUNT" id="totalAmount" value="<%= SLSTR.get("TOTALAMOUNT") != null ? SLSTR.get("TOTALAMOUNT") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>32</td>
							<th>Amount in Foreign Currency</th>
							<td>
								<input type="text" name="AMOUNTFOREIGNCURRENCY" id="amountForeignCurrency" value="<%= SLSTR.get("AMOUNTFOREIGNCURRENCY") != null ? SLSTR.get("AMOUNTFOREIGNCURRENCY") : ""%>"/>
							</td>
						</tr>
						-->
						<input type="hidden" name="TOTALAMOUNT" id="totalAmount" value="<%= SLSTR.get("TOTALAMOUNT") != null ? SLSTR.get("TOTALAMOUNT") : ""%>"/>
						<input type="hidden" name="AMOUNTFOREIGNCURRENCY" id="amountForeignCurrency" value="<%= SLSTR.get("AMOUNTFOREIGNCURRENCY") != null ? SLSTR.get("AMOUNTFOREIGNCURRENCY") : ""%>"/>
						<tr>
							<td>31</td>
							<th>Beneficiary of Transaction</th>
							<td>
								<input type="text" name="TRANSACTIONBENEFICIARY" id="benefTransaction" value="<%= SLSTR.get("TRANSACTIONBENEFICIARY") != null ? SLSTR.get("TRANSACTIONBENEFICIARY") : ""%>"/>
							</td>
						</tr>
						<!--
						<tr>
							<td>34</td>
							<th>Type of Suspicious Transaction </th>
							<td>
								<input type="text" name="SUSPICIOUSTXTTYPE" id="suspiciousTxnType" value="<%= SLSTR.get("SUSPICIOUSTXTTYPE") != null ? SLSTR.get("SUSPICIOUSTXTTYPE") : ""%>"/>
							</td>
						</tr>
						-->
						<input type="hidden" name="SUSPICIOUSTXTTYPE" id="suspiciousTxnType" value="<%= SLSTR.get("SUSPICIOUSTXTTYPE") != null ? SLSTR.get("SUSPICIOUSTXTTYPE") : ""%>"/>
						<tr>
							<td>32</td>
							<th>Currency Code </th>
							<td>
								<input type="text" name="CURRENCYCODE" id="currencyCode" value="<%= SLSTR.get("CURRENCYCODE") != null ? SLSTR.get("CURRENCYCODE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>33</td>
							<th>Current Balance (In LKR) </th>
							<td>
								<input type="text" name="CURRENTBALANCE" id="currentBalance" value="<%= SLSTR.get("CURRENTBALANCE") != null ? SLSTR.get("CURRENTBALANCE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>34</td>
							<th>Current Balance Foreign Currency </th>
							<td>
								<input type="text" name="CURRENTBALANCEFOREIGNCURRENCY" id="currentBalanceForeignCurrency" value="<%= SLSTR.get("CURRENTBALANCEFOREIGNCURRENCY") != null ? SLSTR.get("CURRENTBALANCEFOREIGNCURRENCY") : ""%>"/>
							</td>
						</tr>

					</tbody>
				</table>
			</div>
			<div class="header header-main">
				PART D: DESCRIPTION OF SUSPICIOUS TRANSACTION
			</div>
			<div class="section">
				<table style="text-align: left;">
					<tbody>
						<tr>
							<td width="3%">35</td>
							<th width="37%">Ground for suspicion (Please CHECK where relevant</th>
							<td><input type="hidden" name="GROUNDOFSUSPICION" id="GROUNDOFSUSPICION" value=""/></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
							<td>
								<ul>
									<li>
										<input type="checkbox" id="gs1" class="groundofsuspicion" name="GROUNDOFSUSPICION_A" value="A"  <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("A")){ %> checked="checked" <%} %>/>
										<label for="gs1">Activating of dormant account</label>
									</li>
									<li>
										<input type="checkbox" id="gs2" class="groundofsuspicion" name="GROUNDOFSUSPICION_B" value="B" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("B")){ %> checked="checked" <%} %>/>
										<label for="gs2">
											<strong>
												 Large/Unusual cash deposit/withdrawal not consistent
												  with the known pattern of transaction
											</strong>
										</label>
									</li>
									<li>
										<input type="checkbox" id="gs3" class="groundofsuspicion" name="GROUNDOFSUSPICION_C" value="C" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("C")){ %> checked="checked" <%} %>/>
										<label for="gs3">
											Frequent transactions below the mandatory reporting threshold
											level (LKR 1,000,000)
										</label>
									</li>
									<li>
										<input type="checkbox" id="gs4" class="groundofsuspicion" name="GROUNDOFSUSPICION_D" value="D" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("D")){ %> checked="checked" <%} %>/>
										<label for="gs4">Customer suspected of having terrorist links. </label>
									</li>
									<li>
										<input type="checkbox" id="gs5" class="groundofsuspicion" name="GROUNDOFSUSPICION_E" value="E" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("E")){ %> checked="checked" <%} %>/>
										<label for="gs5">
											Funds originating from a suspicious organization/individual/
											(known terrorist front organizations, shell companies etc.) 
										</label>
									</li>
									<li>
										<input type="checkbox" id="gs6" class="groundofsuspicion" name="GROUNDOFSUSPICION_F" value="F" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("F")){ %> checked="checked" <%} %>/>
										<label for="gs6">Reluctance to divulge identification and other information. </label>
									</li>
									<li>
										<input type="checkbox" id="gs7" class="groundofsuspicion" name="GROUNDOFSUSPICION_G" value="G" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("G")){ %> checked="checked" <%} %>/>
										<label for="gs7">Regular unusual offshore activity. </label>
									</li>
									<li>
										<input type="checkbox" id="gs8" class="groundofsuspicion" name="GROUNDOFSUSPICION_H" value="H" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("H")){ %> checked="checked" <%} %>/>
										<label for="gs8">
											<strong>
												Large/Unusual inward/outward remittance
											</strong>
										</label>
									</li>
									<li>
										<input type="checkbox" id="gs9" class="groundofsuspicion" name="GROUNDOFSUSPICION_I" value="I" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("I")){ %> checked="checked" <%} %>/>
										<label for="gs9">
											<strong>
												Transaction without an economic rationale
											</strong>
										</label>
									</li>
									<li>
										<input type="checkbox" id="gs10" class="groundofsuspicion" name="GROUNDOFSUSPICION_J" value="J" <% if(SLSTR.get("GROUNDOFSUSPICION") != null && SLSTR.get("GROUNDOFSUSPICION").contains("J")){ %> checked="checked" <%} %>/>
										<label for="gs10">
											Others (please specify)<br/>
											<textarea rows="10" cols="10" name="GROUNDOFSUSPICIONOTHER" style="width:500px;" ><%= SLSTR.get("GROUNDOFSUSPICIONOTHER") != null ? SLSTR.get("GROUNDOFSUSPICIONOTHER") : ""%></textarea>
										</label>
									</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td>36</td>
							<th>Give details of nature and the circumstances surrounding it:</th>
							<td>
								<textarea rows="" cols="" name="NATUREDETAILS"><%= SLSTR.get("NATUREDETAILS") != null ? SLSTR.get("NATUREDETAILS") : ""%></textarea><br/>
								(Could be included as additional attachments)
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<center>3</center>
		<br/><br/>
		<div class="box">
			<div class="header header-main">
				PART E: DETAILS OF REPORTING OFFICER &amp; COMPLIANCE OFFICER
			</div>
			<div class="section">
				<table style="text-align: center; width: 100%;">
					<tbody>
						<tr>
							<td>Date of Reporting:</td>
							<td colspan="2">
								<input type="text" name="REPORTINGDATE" id="reportingDate" class="date" value="<%= SLSTR.get("REPORTINGDATE") != null ? SLSTR.get("REPORTINGDATE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								Reporting Officer:
								<input type="text" name="REPORTINGOFFICER" id="reportingOfficer" style="width: 60%" value="<%= SLSTR.get("REPORTINGOFFICER") != null ? SLSTR.get("REPORTINGOFFICER") : ""%>"/>
							</td>
							<td>
							<input type="text" name="COMPLIANCEOFFICERNAME" id="complianceOfficer" value="<%= SLSTR.get("COMPLIANCEOFFICERNAME") != null ? SLSTR.get("COMPLIANCEOFFICERNAME") : ""%>"/><br/>
							-----------------------------------------<br/>
							Name of Compliance Officer 
							</td>
						</tr>
						<tr>
							<td>Name: </td>
							<td colspan="2">
								<input type="text" name="NAME" id="name" value="<%= SLSTR.get("NAME") != null ? SLSTR.get("NAME") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>Designation:</td>
							<td colspan="2">
								<input type="text" name="DESIGNATION" id="designation" value="<%= SLSTR.get("DESIGNATION") != null ? SLSTR.get("DESIGNATION") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>Address:</td>
							<td colspan="2">
								<input type="text" name="ADDRESS" id="address" value="<%= SLSTR.get("ADDRESS") != null ? SLSTR.get("ADDRESS") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td width="33%">
								Contact No:
								<input type="text" name="CONTACTNO" id="contactNo" value="<%= SLSTR.get("CONTACTNO") != null ? SLSTR.get("CONTACTNO") : ""%>"/>
							</td>
							<td width="33%">
								E-mail
								<input type="text" name="EMAIL" id="email" value="<%= SLSTR.get("EMAIL") != null ? SLSTR.get("EMAIL") : ""%>"/>
							</td>
							<td width="34%">
								Fax
								<input type="text" name="FAX" id="fax" value="<%= SLSTR.get("FAX") != null ? SLSTR.get("FAX") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2"></td>
							<td>
								------------------------------------------------<br/>
								<strong>Signature of Compliance Officer</strong>
							</td>
						</tr>
					</tbody>
				</table>
				<br/>
			</div>
				<center>
					<input name="formSave" type="submit" value="Save" class="btn btn-success btn-sm submitSTR"/>
					&nbsp;&nbsp;&nbsp;
					<!--<input name="exportXML" type="submit" value="Export XML"  class="btn btn-primary btn-sm submitSTR"/>-->
					<input name="closeWindow" type="button" value="Close"  class="btn btn-primary btn-sm" onClick="window.close();"/>
				</center>
				<br/>
			<div class="header header-main">
				PART F: FOR FIU OF SRI LANKA USE ONLY 
			</div>
			<div class="section">
				<table style="text-align: left; width: 100%;">
					<tbody>
						<tr>
							<td>Receiving Officer </td>
							<td colspan="2">
								
							</td>
						</tr>
						<tr>
							<td>Date Received: </td>
							<td colspan="2">
								
							</td>
						</tr>
						<tr>
							<td>STR No: </td>
							<td colspan="2">
								
							</td>
						</tr>
						<tr>
							<td>Date of Acknowledgement:</td>
							<td colspan="2">
								
							</td>
						</tr>
						<tr>
							<td colspan="3" style="text-align: center;">
								<strong>FIU ACKNOWLEDGEMENT</strong><br/>
								Received by the Financial Intelligence Unit of the Central Bank,
								STR No : dated from 
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
							<td colspan="2">&nbsp;</td>
							<td>
							..............................................<br/>
							<strong>Director/FIU</strong>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<br/>
		<center>
			<strong>SUSPICIOUS TRANSACTION REPORT (STR) IN TERMS OF 
			FINANCIAL TRANSACTIONS REPORTING ACT NO. 6 OF 2006</strong>
			<br/><br/>
			4 
		</center>
		<br/><br/>
		<div class="box">
			<center><h3>INSTRUCTIONS</h3></center>
			<div class="section">
				<table style="text-align: left; width: 100%;">
					<tbody>
						<tr>
							<td width="50%">
								<h4>GENERAL INSTRUCTIONS</h4>
								<br/>
								Under the <strong>FINANCIAL TRANSACTIONS REPORTING 
								ACT, NO. 6 OF 2006 (FTRA)</strong>, every reporting institution 
								shall furnish details of suspicious transactions defined in 
								Section 7 (1) of the FTRA Act .
								<br/><br/>
								<div style="margin-left: 5%">7 (1) Where an Institution - 
									<div style="margin-left: 5%">
									(a) has reasonable grounds to suspect that any 
										transaction or attempted transaction may be 
										related to the commission of any unlawful activity 
										or any other criminal offence; or 
									</div>
									<br/>
									<div style="margin-left: 5%">	
									(b) has information that it suspects may be relevant --- 
									<div style="margin-left: 3%">
										(i) to an act preparatory to an offence under the 
											provision of the Convention on the Suppression
											of Financing of Terrorism Act, No. of 2005. 
									</div><br/>
									<div style="margin-left: 3%">
										(ii) to an investigation or prosecution of a person 
											or persons for an act constituting an unlawful 
											activity, or may otherwise be of assistance in 
											the enforcement of the Money laundering 
											Act. No.5 of 2006 and the Convention on the 
											Suppression of Terrorist Financing Act, No. 25 of 2005. 
										</div>
									</div>
								</div>
								<br/>
								<h4>How to submit </h4>
									Every institution must submit this form to the Director, FIU 
									only through the Compliance Officer of the reporting 
									institution designated under the FTRA. In urgent cases, the 
									form should also be sent by fax: 
									<br/><br/>
								Address: 
									<div style="margin-left: 10%">
										<address>
											Director <br/>
											Financial Intelligence Unit <br/>
											Central Bank of Sri Lanka <br/>
											30, Janadhipathi Mawatha <br/>
											Colombo 1. <br/>
											Fax. 94 11 2477692<br/> 
										</address>
									</div>
									<br/><br/>
								<h4>EXPLANATION OF SPECIFIC TERMS</h4> 
								
								<h3>PART A: DETAILS OF REPORT</h3> 
									<div style="margin-left: 5%">
									1.1 Date of sending report is the date on which the 
										compliance officer sends the report to Director (FIU).
									</div>
									<div style="margin-left: 5%"> 
									1.2 Replacement report is a report submitted in replacement 
										of an earlier STR. When a replacement report is 
										submitted, date of submitting original STR may be 
										mentioned and the complete STR has to be submitted again. 
									</div>
									
								<h3>PART B (24) List out all related/connected accounts where links are evident.</h3> 
								
								<h3>PART E: DETAILS OF COMPLIANCE OFFICER</h3>
								<div style="margin-left: 5%">
										Compliance officer is the officer designated by the reporting 
										institution under the FTRA.
								</div>
							</td>
							<td width="50%;" valign="top">
								<h4>
								PART C: TYPE OF TRANSACTION- WHETHER 
								DEPOSIT OR WITHDRAWAL IN CASH ETC. 
								</h4>
								Reasons for suspicion
								<br/>
								<table width="98%" style="border: 1px solid black;">
									<tr>
										<th width="30%">Reasons</th>
										<th width="30%">Examples of suspicious transactions</th>
									</tr>
									<tr>
										<td>Identity of clients</td>
										<td>
											<ul>
												<li style="list-style: circle;">
													False identification of documents 
												</li>
												<li style="list-style: circle;">
													Identification of documents which could 
													not be verified within reasonable time
												</li>
												<li style="list-style: circle;">
													Accounts opened with names very close 
													to other established business entities
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<td>Background of client</td>
										<td>
											<ul>
												<li style="list-style: circle;">
													Suspicious background or links with known criminals.
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<td>Multiple accounts</td>
										<td>
											<ul>
												<li style="list-style: circle;">
													Large number of accounts having a common account holder,
													introducer or authorized signatory with no rationale.
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<td>Activity in accounts </td>
										<td>
											<ul>
												<li style="list-style: circle;">
													Unusual activity compared with past transactions
												</li>
												<li style="list-style: circle;">
													Sudden activity in dormant accounts
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<td>Nature of transactions</td>
										<td>
											<ul>
												<li style="list-style: circle;">
													Unusual or unjustified complexity
												</li>
												<li style="list-style: circle;">
													No economic rationale or bonafide purpose
												</li>
												<li style="list-style: circle;">
													Frequent purchases of drafts or other negotiable 
													instruments with cash
												</li>
												<li style="list-style: circle;">
													Nature of transactions inconsistent with what
													would be expected from declared business
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<td>Value of transactions</td>
										<td>
											<ul>
												<li style="list-style: circle;">
													Value just under the reporting threshold amount in an
													 apparent attempt to avoid reporting.
												</li>
												<li style="list-style: circle;">
													Value inconsistent with the client's apparent 
													financial standing
												</li>
											</ul>
										</td>
									</tr>
								</table>
								<br/><br/>
								<h4>ALL ANNEXURES MUST BE ENCLOSED</h4>
								<ul>
									<li>Account opening mandate </li>
									<li>Statements evidencing suspicious transactions </li>
									<li>Detailed description of circumstances
										surrounding transaction.</li>
								</ul>
								All other relevant documentation
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<center>5</center>
	</form>
	</div>
</body>
</html>