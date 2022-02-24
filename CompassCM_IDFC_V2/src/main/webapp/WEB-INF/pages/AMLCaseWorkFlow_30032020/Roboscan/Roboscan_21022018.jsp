<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Roboscan</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>

<script type="text/javascript">
 
	 $(".datepicker").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	 });
	 
	 
 
 </script>
<style>
.datepicker {
	background-image:
		url("${pageContext.request.contextPath}/includes/images/calendar.png");
	background-repeat: no-repeat;
	background-position: 98%;
}
/* .container-fluid{
		background-color:yellow;
	} */
#topheader {
	background-color: #e5e6e5;
	border: 1px solid black;
}

.blackdiv {
	background-color: black;
	padding-top: 20px;
}

.blackdiv p {
	color: white;
	font-size: 14px;
	text-align: justify;
	line-height: 2.3;
	-moz-text-align-last: right; /* Code for Firefox */
	text-align-last: left;
}

mark {
	background-color: white;
	color: black;
}

input[type="text"] {
	background-color: #e5e6e5
}

.whitehr {
	margin: 0.1em auto;
	display: block;
	height: 1px;
	border-top: 1px solid white;
	padding: 0;
	background-color: black;
}

.blackhr {
	margin: 0.1em auto;
	display: block;
	height: 1px;
	border-top: 1px solid black;
	padding: 0;
	background-color: white;
}

.collapseclass {
	background-color: white;
}

.blackheader {
	margin-top: 10px;
}

.withOutLineTable th, .withOutLineTable td {
	border-top: none !important;
}

.whitefonttable {
	color: white;
}

.innerBorder tr td:last-child, tr th:last-child {
	border-right: none !important;
}

.innerBorder tr td:first-child, tr th:first-child, tr>td:nth-child(4),
	tr>th:nth-child(4) {
	text-align: left;
}

.innerBorder td, th {
	text-align: center;
	color: white;
	border-top: none !important;
	border-right: 1px solid white;
}

.white-inner-border tr td:last-child, tr th:last-child {
	border-right: none !important;
}

.white-inner-border tr td:first-child, tr th:first-child, tr>td:nth-child(4),
	tr>th:nth-child(4) {
	text-align: left;
}

.white-inner-border td, th {
	text-align: center;
	color: black;
	border-top: none !important;
	border-right: 1px solid black;
}
</style>
</head>
<body>
	<!-- Main DIV  -->

	<!-- Top Header Start -->
	<div class=" col-sm-offset-1 col-sm-10" id="topheader">
		<div class=" col-sm-offset-1 col-sm-10">
			<table class="table ">
				<tr>
					<td><h3>RoboScan - Intelligent Case Summary</h3></td>
					<td><img class="pull-right"
						src="${pageContext.request.contextPath}/includes/images/qde/qde-logo.png"
						alt="QDE"></td>
				</tr>
			</table>
		</div>
	</div>
	<!-- Top Header End -->


	<!-- Executive Summary: start -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv">
		<div class=" col-sm-offset-1 col-sm-10">

			<table class="table withOutLineTable form-inline" width="100%">
				<tr>
					<td width='100%'>
						<p>
							The <input class='form-control input-sm' style="width: 55%;"
								placeholder='Alert Name' type='text' name='alertName'
								value='Cash deposits greater than INR [X1] for individuals and greater than INR [X2] for non individuals in a day' />
							alert was breached for <input
								class='form-control input-sm textbox'
								placeholder='Customer name' type='text' name='caseId'
								value='SHINCHAN S/O SAN CHAO' />. The account on which the alert

							breached is <input class='form-control input-sm textbox'
								placeholder='Account Number' type='text' name='caseId'
								value='50230500000565' />. A total of <input
								class='form-control input-sm textbox' placeholder='No. of Txn'
								type='text' name='caseId' value='6' /> were involved in this
							breach. Total of <input class='form-control input-sm textbox'
								placeholder='X No. of alerts' type='text' name='caseId'
								value='5' /> alerts have been combined to form this case. This
							customer <input class='form-control input-sm textbox'
								placeholder='has or does not have' type='text' name='caseId'
								value='does not have' /> historical STR cases with the bank.
							The risk rating of the breached alert is: <input
								class='form-control input-sm textbox' placeholder='H/M/L'
								type='text' name='caseId' value='H' />.
						</p>
					</td>
				</tr>
			</table>
			<b><p>Executive Summary:</p></b>
			<hr class="whitehr" size="2">
			<table class="table withOutLineTable">
				<tr>
					<td width="25%">
						<p>Compass Case ID</p>
					</td>
					<td width="25%"><input class="form-control input-sm"
						type="text" name="caseId" value='119855' /></td>
					<td width="25%">
						<p>Alerts Breached:</p>
					</td>
					<td width="25%"><input class="form-control input-sm"
						type="text" name="alertsBreached" value='5' /></td>
				</tr>

				<tr>
					<td colspan="1">
						<p>Description of Breached Alerts:</p>
					</td>
					<td colspan="3"><textarea class="form-control input-sm"
							rows="6" name="caseId">1) A third party appears to be using the account of customer.
2) Unusual applications for DD/TT/PO against cash.	
3) Number of locker operations greater than [4] times in [3] days.
4) Long Distance Customer Opening Account.
5) Transaction involving a location prior to or immediately after a terrorist incident. 
								</textarea></td>
				</tr>
				<tr>
					<td width="25%">
						<p>Is Bank Employee:</p>
					</td>
					<td width="25%"><input type="radio" name="employee"
						value="Yes" /><font color="white"> Yes</font></td>
					<td width="25%"><input type="radio" name="employee" value="No" />
						<font color="white">No</font></td>
					<td width="25%"><input type="radio" name="employee"
						value="Unknown" checked="checked" /> <font color="white">Unknown</font></td>
				</tr>
			</table>
		</div>
	</div>
	<!-- Executive Summary: End -->


	<!-- SECTION 1 - Customer Details (KYC) Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12">
				<div class="col-sm-6">
					<h4>
						<b>SECTION 1 - Customer Details (KYC)</b>
					</h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2"
					data-toggle="collapse" data-target="#customerDetails">
					<span class="pull-right"><i
						class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<hr class="blackhr col-sm-12" size="20">
			<!-- 
					
		 -->

			<div id="customerDetails" class="collapse in">
				<table class="table withOutLineTable">
					<tr>
						<td width="25%">
							<p>Customer Name:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="customerName" value="Shinchan San Chao" /></td>
						<td width="25%">
							<p>Father's Name:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="fatherName" value="San Chao" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Mother's Name:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="motherName" value="Akia San Chao" /></td>
						<td width="25%">
							<p>Account number:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="accountNumber" value="50230500000565" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Associated Accounts: (If Any)</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="associateAccounts" value="50230100002282" /></td>
						<td width="25%">
							<p>Base Branch:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="baseBranch" value="Marina View (5024)" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Type of Account:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="accountType" value="CCA" /></td>
						<td width="25%">
							<p>Risk Rating of Customer:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="customerRisk" value="Medium" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Risk Rating of Account:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="accountRisk" value="High" /></td>
						<td width="25%">
							<p>Risk Rating of related parties:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="partyRisk" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>KYC Last update date:</p>
						</td>
						<td width="25%"><input class="form-control datepicker"
							type="date" name="lastUpdatedate" value="20/01/2013" /></td>
						<td width="25%">
							<p>KYC Last change date:</p>
						</td>
						<td width="25%"><input class="form-control datepicker"
							type="date" name="lastChangedate" value="05/09/2010" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Guardian:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="guardian" value="San Chao (Father)" /></td>
						<td width="25%">
							<p>Nominee:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="nominee" value="Akia San Chao (Mother)" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Other Relationships:</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="otherRelation" value="None" /></td>
						<td width="25%"></td>
						<td width="25%"></td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- SECTION 1 - Customer Details (KYC) End -->



	<!-- Real Time Screening Result Details: start -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv"
		style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10 blackheader">
			<div class="col-sm-6"
				<h4><b><p>SECTION 2 - Real-Time Screening Results:</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#realTimeScreeningn">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
		</div>
		<div class="col-sm-offset-1 col-sm-10">
			<hr class=" whitehr " size="2">

		</div>
		<div class=" col-sm-offset-1 col-sm-10" id="realTimeScreeningn">

			<table class="table withOutLineTable">
				<tr>
					<td width="25%"><p>Last static data update date:</p></td>
					<td width="25%"><input class="form-control datepicker"
						type="date" name="staticDate" value="19/11/2017" /></td>
					<td width=25%"><p>Last transaction update date:</p></td>
					<td width="25%"><input class="form-control datepicker"
						type="date" name="transactionDate" value="20/11/2017" /></td>
				</tr>
			</table>
			<div style="padding-left: 50px">
				<div class="col-sm-6"
					<h4><b><p>Real Time Screening Search Details::</p></b></h4></div>

				<hr class="whitehr col-sm-12" size="2">
				<table class="table withOutLineTable" width="100%">
					<tr>
						<td width="25%">
							<p>Name</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="name" value="Shinchan San Chao" /></td>
						<td width="25%">
							<p>Other Names</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="otherNames" value=" " /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Date of Birth</p>
						</td>
						<td width="25%"><input class="form-control datepicker"
							type="text" name="dateofBirth" value=" " /></td>
						<td width="25%">
							<p>Account Number</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="accountNumber" value="50230100002282" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Customer ID</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="customerId" value="610360974" /></td>
						<td width="25%">
							<p>Passport Number</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="passportNumber" value="SI83628323" /></td>
					</tr>

					<tr>
						<td width="25%">
							<p>Tax ID Number</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="taxId" value=" " /></td>
						<td width="25%">
							<p>National ID Number</p>
						</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="nationalId" value="6562323552" /></td>
					</tr>
				</table>

				<div class="col-sm-6"
					<h4><b><p>Real Time Screening Result Details:</p></b></h4></div>
				<div class=" col-sm-12">
					<hr class=" whitehr " size="2">
					<p>Customer: Shinchan San Chao</p>
				</div>
				<table class="table innerBorder">
					<tr>
						<th width='20%'>List Name</th>

						<th width='15%'>List Id</th>
						<th width='15%'>Match Score</th>

						<th width='35%'>Matched Value</th>

						<th width='15%'>Match Date</th>
					</tr>

					<tr>
						<td width='20%'>OFACSDNLIST</td>
						<td width='15%'>7898</td>
						<td width='15%'>75</td>
						<td width='35%'>Sin Chan Choo</td>
						<td width='15%'>10-Nov-2017</td>
					</tr>

					<tr>
						<td width='20%'>OFACSDNLIST</td>
						<td width='15%'>4198</td>
						<td width='15%'>61</td>
						<td width='35%'>Seen Choo Chan</td>
						<td width='15%'>10-Nov-2017</td>
					</tr>
				</table>

				<p>Counter Party/Beneficiary : Jovia Satanisic</p>
				<table class="table innerBorder">
					<tr>
						<th width='20%'>List Name</th>

						<th width='15%'>List Id</th>
						<th width='15%'>Match Score</th>

						<th width='35%'>Matched Value</th>

						<th width='15%'>Match Date</th>
					</tr>

					<tr>
						<td width='20%'>OFACSDNLIST</td>
						<td width='15%'>7796</td>
						<td width='15%'>97</td>
						<td width='35%'>Jovica SATANISIC</td>
						<td width='15%'>10-Nov-2017</td>
					</tr>
					<tr>
						<td width='20%'>OFACSDNLIST</td>
						<td width='15%'>11142</td>
						<td width='15%'>76</td>
						<td width='35%'>Joviya</td>
						<td width='15%'>10-Nov-2017</td>
					</tr>
				</table>
				<div class="col-sm-offset-5 col-sm-1"
					style="margin-top: 20px; margin-bottom: 20px">
					<button type="button" class="btn btn-default" value="Report">Report</button>
				</div>
			</div>

		</div>
	</div>
	<!-- Real Time Screening Result Details: end -->

	<!-- SECTION 3 - Transaction Details Start -->

	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 30px;">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12">
				<div class="col-sm-6">
					<h4>
						<b>SECTION 3 - Transaction Details</b>
					</h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2"
					data-toggle="collapse" data-target="#transactiondetails">
					<span class="pull-right"><i
						class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<hr class="blackhr col-sm-12" size="20">
			<div id="transactiondetails">
				<table class="table withOutLineTable">
					<tr>
						<td width="25%">TXN Date:</td>
						<td width="25%"><input class="form-control datepicker"
							type="date" name="txnDate" value="10-Sep-2017" /></td>
						<td width="25%">Value:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="value" value="12123120" /></td>
					</tr>

					<tr>
						<td width="25%">Counterparty:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="counterParty" value="Jovia Satanisic" /></td>
						<td width="25%">Type:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="type" value="C/NR" /></td>
					</tr>

					<tr>
						<td width="25%">Product:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="product" value="Diamond Dealer" /></td>
						<td width="25%">Channel:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="channel" value="Cash" /></td>
					</tr>

					<tr>
						<td width="25%">Value:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="value" /></td>
						<td width="25%">Time:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="time" value="12:05 am" /></td>
					</tr>

					<tr>
						<td width="25%">Cross-border:</td>
						<td width="25%"><input type="radio" name="crossBorder"
							value="yes" checked="checked" /> Yes<br> <input
							type="radio" name="crossBorder" value="no" /> No</td>
						<td width="25%"></td>
						<td width="25%"></td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- SECTION 3 - Transaction Details End -->

	<!-- SECTION 4 - Account Profile (Past 6 months) start -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">


			<div class="col-sm-6"
				<h4><b><p>SECTION 4 - Account Profile (Past 6 months)</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#accountprofile">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" whitehr " size="2">

			</div>
			<div id="accountprofile">
				<table class="table withOutLineTable whitefonttable">
					<tr>
						<td colspan="1">Products Used:</td>
						<td colspan="3"><textarea class="form-control input-sm"
								name="productUsed">SBNRO - NRO SAVINGS ACCOUNT							
COFFD - CORPORATE FLEXI FIXED DEPOSIT
						</textarea></td>
					</tr>
					<tr>
						<td width="25%">Total Debits:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="totalDebit" value="3" /></td>
						<td width="25%">Total Credits:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="totalCredit" value="5" /></td>
					</tr>

					<tr>
						<td width="25%">Account Risk:</td>
						<td width="25%"><input class="form-control input-sm"
							type="text" name="accountRisk" value="High" /></td>
						<td width="25%">Risk last change date:</td>
						<td width="25%"><input class="form-control datepicker"
							type="date" name="changeDate" value="16/11/2017" /></td>
					</tr>

					<tr>
						<td colspan="1">Last 5 account activities:</td>
						<td colspan="3"><textarea class="form-control input-sm"
								rows="6" name="accountActivities">1) S$ 1250000 debited to account number XXXXXXXXX125.
2) S$ 250000 credited to account number XXXXXXXXX880.
3) S$ 10000000 credited to account number XXXXXXXXX100.
4) Account number XXXXXXXXX888 is debited for S$ 9250000 on 15-11-17 and account number XXXXXXXXX100 credited.
5) Account number XXXXXXXXX125 debited with S$ 1250000 by ATM POS/978764/01:25:48/979.
						</textarea></td>
					</tr>

					<tr>
						<td width="25%">Past CTR or SR or other regulatory reports in
							this account / customer:</td>
						<td width="25%"><input type="radio" name="report" value="yes"
							checked="checked" /> Yes<br> <input type="radio"
							name="report" value="no" /> No</td>
						<td width="25%">If Yes: Count and Date</td>
						<td width="25%"><input class="form-control input-sm"
							placeholder="Count" type="text" name="count" value="2" /> <br>
							<input class="form-control datepicker" placeholder="Date"
							type="date" name="date" value="18/11/2017" /></td>
					</tr>
				</table>
			</div>


		</div>
	</div>
	<!-- SECTION 4 - Account Profile (Past 6 months) end -->



	<!-- Section 5 list Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 30px;">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12">
				<div class="col-sm-6">
					<h4>
						<b>SECTION 5 - Links</b>
					</h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2"
					data-toggle="collapse" data-target="#linkes">
					<span class="pull-right"><i
						class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<hr class="blackhr col-sm-12" size="20">
			<div id="linkes" style="margin-left: 20px;">
				<h4>
					<b>Level 1</b>
				</h4>
				<table class="table white-inner-border">
					<tr>
						<th width='20%'>Total Transactions</th>
						<th width='20%'>Any alerted TXN</th>
						<th width='20%'>Total Cumulative Value <br> (Txn count
							and cumulative value)
						</th>
						<th width='20%'>Total Debits <br> (Txn count and
							cumulative value)
						</th>
						<th width='20%'>Total Credits <br> (Txn count and
							cumulative value)
						</th>
					</tr>

					<tr>
						<td width='20%'>8</td>
						<td width='20%'>5</td>
						<td width='20%'>8 and 35420000</td>
						<td width='20%'>3 and 4561231</td>
						<td width='20%'>5 and 30858769</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 2</b>
				</h4>
				<table class="table white-inner-border">
					<tr>
						<th width='20%'>Total Transactions</th>
						<th width='20%'>Any alerted TXN</th>
						<th width='20%'>Total Cumulative Value <br> (Txn count
							and cumulative value)
						</th>
						<th width='20%'>Total Debits <br> (Txn count and
							cumulative value)
						</th>
						<th width='20%'>Total Credits <br> (Txn count and
							cumulative value)
						</th>
					</tr>

					<tr>
						<td width='20%'>2</td>
						<td width='20%'>3</td>
						<td width='20%'>5 and 766443</td>
						<td width='20%'>2 and 66990</td>
						<td width='20%'>3 and 709660</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 3</b>
				</h4>
				<table class="table white-inner-border">
					<tr>
						<th width='20%'>Total Transactions</th>
						<th width='20%'>Any alerted TXN</th>
						<th width='20%'>Total Cumulative Value <br> (Txn count
							and cumulative value)
						</th>
						<th width='20%'>Total Debits <br> (Txn count and
							cumulative value)
						</th>
						<th width='20%'>Total Credits <br> (Txn count and
							cumulative value)
						</th>
					</tr>

					<tr>
						<td width='20%'>4</td>
						<td width='20%'>3</td>
						<td width='20%'>7 and 9111223</td>
						<td width='20%'>4 and 669900</td>
						<td width='20%'>3 and 8441323</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 4</b>
				</h4>
				<table class="table white-inner-border">
					<tr>
						<th width='20%'>Total Transactions</th>
						<th width='20%'>Any alerted TXN</th>
						<th width='20%'>Total Cumulative Value <br> (Txn count
							and cumulative value)
						</th>
						<th width='20%'>Total Debits <br> (Txn count and
							cumulative value)

						</th>
						<th width='20%'>Total Credits <br> (Txn count and
							cumulative value)

						</th>
					</tr>

					<tr>
						<td width='20%'>4</td>
						<td width='20%'>3</td>
						<td width='20%'>7 and 9111223</td>
						<td width='20%'>4 and 669900</td>
						<td width='20%'>3 and 8441323</td>
					</tr>

				</table>

			</div>
		</div>
	</div>

	<!-- Section 5 list end -->


	<!-- SECTION 6 - Past History Start -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">


			<div class="col-sm-6" <h4><b><p>SECTION 6 - Past History</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#pasthistory">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" whitehr " size="2">
			</div>
			<div id="pasthistory">
				<table class="table form-inline withOutLineTable whitefonttable">
					<tr>
						<td width="100%">This customer had: <input
							class="form-control input-sm" style="width: 10%;" placeholder="X"
							type="text" name="noOfAlerts" value="5" /> alerts in the last 6
							months and <input class="form-control input-sm"
							style="width: 10%;" placeholder="X" type="text" name="noOfAlerts"
							value="15" /> alerts in the last 1 year.
						</td>
					</tr>
				</table>
				<table class="table form-inline withOutLineTable whitefonttable">
					<tr>
						<td width="25%">This transaction is the same as above alerts:
						</td>
						<td width="25%"><input type="radio" name="transaction"
							value="yes" checked="checked" /> Yes <input type="radio"
							name="transaction" value="no" /> No</td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- SECTION 6 - Past History End -->


	<!-- SECTION 7 - Related Parties Start -->

	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 30px;">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12">
				<div class="col-sm-6">
					<h4>
						<b>SECTION 7 - Related Parties</b>
					</h4>
					<p>The below relationships were discovered for this customer
						and account:</p>

				</div>
				<div class="btn btn-group pull-right col-sm-2"
					data-toggle="collapse" data-target="#relatedparties">
					<span class="pull-right"><i
						class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<hr class="blackhr col-sm-12" size="20">
			<div id="relatedparties">
				<table class="table withOutLineTable form-inline">
					<tr>
						<td width="25%">
							<p>Joint Holder:</p>
						</td>
						<td width="12%"><input type="radio" name="jointHolder"
							value="yes" checked="checked" /> Yes</td width="12%" >
						<td><input type="radio" name="jointHolder" value="no" /> No
						</td>
						<td width="25%">
							<p>Customer has other accounts:</p>
						</td>
						<td width="12%"><input type="radio" name="otherAccount"
							value="yes" checked="checked" /> Yes</td width="12%">
						<td><input type="radio" name="otherAccount" value="no" /> No
						</td>
					</tr>
					<tr>
						<td width="25%">
							<p>Customer's relatives have other accounts:</p>
						</td>
						<td width="12%"><input type="radio" name="relativeAccounts"
							value="yes" checked="checked"> Yes</input></td>
						<td width="12%"><input type="radio" name="relativeAccounts"
							value="no"> No</input></td>
						<td width="25%">
							<p>Customer is beneficiary of other accounts:</p>
						</td>
						<td width="12%"><input type="radio"
							name="beneficiaryAccounts" value="yes"> Yes</input></td>
						<td width="12%"><input type="radio"
							name="beneficiaryAccounts" value="no" checked="checked">
							No</input></td>
					</tr>
					<tr>
						<td width="25%">
							<p>Customer is signing authority of Corporate Entity Account:
							</p>
						</td>
						<td width="12%"><input type="radio" name="entityAccount"
							value="yes" checked="checked"> Yes</input></td>
						<td width="12%"><input type="radio" name="entityAccount"
							value="no"> No </input></td>
						<td width="25%"></td>

					</tr>
				</table>

			</div>

		</div>
	</div>

	<!-- SECTION 7 - Related Parties End -->


	<!-- SECTION 8 - Ringside View Start -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">
			<div class="col-sm-6"
				<h4><b><p>SECTION 8 - Ringside View</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#ringsideview">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" whitehr " size="2">
			</div>
			<div id="ringsideview">

				<table class="table form-inline withOutLineTable whitefonttable">
					<tr>
						<td width="100%">In the last 30 days, this alert was breached
							a total of <input type="text" class="form-control input-sm"
							placeholder="X" name="alertsBreach" value="5" /> times in the
							bank and <input type="text" class="form-control input-sm"
							placeholder="Y" name="alertsBreach" value="3" /> times for
							customers of the same profile and <input type="text"
							class="form-control input-sm" placeholder="Z" name="alertsBreach"
							value="2" /> times for the base branch of this account.

						</td>
					</tr>
				</table>
				<table class="table form-inline withOutLineTable whitefonttable">
					<tr>
						<td width="100%">In the last 30 days, transactions from this
							branch breached a total of <input type="text"
							class="form-control input-sm" placeholder="A"
							name="transitionsBreach" value="10" /> number of alerts for <input
							type="text" class="form-control input-sm" placeholder="B"
							name="transitionsBreach" value="7" /> sets of customers across <input
							type="text" class="form-control input-sm" placeholder="C"
							name="transitionsBreach" value="9" /> sets of account.

						</td>
					</tr>
				</table>

			</div>

		</div>
	</div>
	<!-- SECTION 8 - Ringside View End -->


	<!-- SECTION 9 - User Comments and Notes Start -->
	<div class=" col-sm-offset-1 col-sm-10 ">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">


			<div class="col-sm-6"
				<h4><b><p>SECTION 9 - User Comments and Notes Start</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#comments">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" blackhr " size="2">
			</div>
			<div id="comments" style="margin-top: 60px;">
				<textarea class="form-control input-sm" name="comment"
					placeholder="Add Comments">Severely suspicious transactions witnessed against the customer. Needs to file STR.</textarea>
			</div>
		</div>
	</div>

	<!-- SECTION 9 - User Comments and Notes End -->

	<!-- SECTION 10 - Action Items Strat -->
	<div class=" col-sm-offset-1 col-sm-10 blackdiv">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">
			<div class="col-sm-6"
				<h4><b><p>SECTION 10 - Action Items Strat</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#actionitem">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" whitehr " size="2">
			</div>
			<div id="actionitem">
				<table cellpadding="10"
					class="table withOutLineTable whitefonttable">
					<tr>
						<td width="20%">Escalate</td>
						<td width="10%"><input type="checkbox" name="actionItem"
							value="escalate"></td>
						<td width="20%">Add To Watch</td>
						<td width="10%"><input type="checkbox" name="actionItem"
							value="watch" checked="checked"></td>
						<td width="20%">Mark as High Risk</td>
						<td width="10%"><input type="checkbox" name="actionItem"
							value="highRisk" checked="checked"></td>
					</tr>

					<tr>
						<td width="20%">Further Investigate</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="furtherInvestigate" checked="checked"></td>
						<td width="20%">Raise CDD request to branch</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="raiseCdd" checked="checked"></td>
						<td width="20%">Close without a case</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="close"></td>
					</tr>

					<tr>
						<td width="20%">Mark as false positive</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="falsePositive"></td>
						<td width="20%">Mark for Follow up</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="followUp" checked="checked"></td>
						<td width="20%">Desktop Closure</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="desktopClosure"></td>
					</tr>

					<tr>
						<td width="20%">Investigated</td>
						<td width="13%"><input type="checkbox" name="actionItem"
							value="investigated"></td>
						<td width="20%"></td>
						<td width="13%"></td>
						<td width="20%"></td>
						<td width="13%"></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- SECTION 10 - Action Items End -->


	<!-- Section 11 options Start -->
	<div class=" col-sm-offset-1 col-sm-10 ">
		<div class=" col-sm-offset-1 col-sm-10" style="margin-top: 20px">


			<div class="col-sm-6" <h4><b><p>Option</p></b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapseclass"
				data-toggle="collapse" data-target="#options">
				<span class="pull-right"><i
					class="collapsable fa fa-chevron-up"></i></span>
			</div>
			<div class=" col-sm-12">
				<hr class=" blackhr " size="2">
			</div>
			<div id="options" style="margin-top: 60px;">
				<table class="table withOutLineTable">
					<tr>
						<td width="35%">Save Roboscan report as part of case</td>
						<td width="15%"><input type="checkbox" name="options"
							value="saveReport" checked="checked"></td>
						<td width="35%">Flag for internal discussion</td>
						<td width="15%"><input type="checkbox" name="options"
							value="flag" checked="checked"></td>
					</tr>

					<tr>
						<td width="35%">Remind to review in 3 days</td>
						<td width="15%"><input type="checkbox" name="options"
							value="remind" checked="checked"></td>
						<td width="25%"></td>
						<td width="25%"></td>
					</tr>

					<tr>
						<td width="25%">Print Roboscan report</td>
						<td width="25%">
							<button type="button" class="btn btn-primary">Print</button>
						</td>
						<td width="25%">Send as email</td>
						<td width="25%">
							<button type="button" class="btn btn-primary">Send</button>
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- Section 11 options ENd -->




</body>
</html>