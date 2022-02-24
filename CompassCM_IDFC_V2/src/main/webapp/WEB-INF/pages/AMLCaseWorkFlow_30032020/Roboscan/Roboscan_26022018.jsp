<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Roboscan</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
	 
		 $(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		 
		 //for changing icon
		 $(".collapsable-div").click(function(){
			 
			 if($(this).find( "i" ).hasClass( "fa-chevron-up" ))
			{
				 $(this).find( "i" ).removeClass('fa-chevron-up');
				 $(this).find( "i" ).addClass('fa-chevron-down'); 
				
			}
			else{
				$(this).find( "i" ).removeClass('fa-chevron-down');
				$(this).find( "i" ).addClass('fa-chevron-up'); 
			}
		});
		 
	});
	</script>
	<style>
.section-heding{
	border:1px solid black;
	border-radius: 15px;
    background: #3498db;
    margin-top:20px;
    margin-bottom:20px;
    padding:5px;
}

.section-heding h4,p{
color:white;
}
		
#topheader {
	background-color: #e5e6e5;
	border: 1px solid black;
}
.custom_p p{
	line-height: 2.3;
	color:black;
}

.no-border th,.no-border td{
	 border-top: none !important; 
}

.withOutLineTable th, .withOutLineTable td {
	 border-top: none !important; 
}

 .withOutLineTable tr th:first-child, .withOutLineTable tr td:first-child {
	width:15%;
}

.withOutLineTable tr th:nth-child(3), .withOutLineTable tr td:nth-child(3){
	padding-left:30px;
	width:15%;
}




.inner-border tr td:last-child, tr th:last-child {
	border-right: none !important;
}

.inner-border tr td:first-child, tr th:first-child, tr>td:nth-child(4),
	tr>th:nth-child(4) {
	text-align: left;
}

.inner-border td, th {
	text-align: center;
	color: black;
	border-top: none !important;
	border-right: 1px solid black;
} 
	
	</style>
	
</head>
<body>
<form name = "roboScan" id = "roboScan">

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
	<div class=" col-sm-offset-1 col-sm-10  custom_div">
		<div class=" col-sm-offset-1 col-sm-10">

			<table class="table no-border form-inline custom_p" >
				<tr>
					<td >
						<p>
							The <input class='form-control input-sm' style="width: 55%;"placeholder='Alert Name' type='text' name='ROBO_H_ALERTNAME' value="${HEADER['ROBO_H_ALERTNAME']}" />alert was breached for
							 <input class='form-control input-sm textbox' placeholder='Customer name' type='text' name='ROBO_H_CUST_NAME' value="${HEADER['ROBO_H_CUST_NAME']}" />. The account on which the alert breached is
							 <input class='form-control input-sm textbox' placeholder='Account Number' type='text' name='ROBO_H_ACCOUNTNO' value="${HEADER['ROBO_H_ACCOUNTNO']}" />. A total of 
							 <input class='form-control input-sm textbox' placeholder='No. of Txn' type='text' name='ROBO_H_NO_OF_TXN' value="${HEADER['ROBO_H_NO_OF_TXN']}" /> were involved in this breach. Total of 
							 <input class='form-control input-sm textbox' placeholder='X No. of alerts' type='text' name='ROBO_H_NO_OF_ALERTS' value="${HEADER['ROBO_H_NO_OF_ALERTS']}" /> alerts have been combined to form this case. This customer 
							 <input class='form-control input-sm textbox' placeholder='has or does not have' type='text' name='ROBO_H_HASORDOESNOT_HAVE' value="${HEADER['ROBO_H_HASORDOESNOT_HAVE']}" /> historical STR cases with the bank. The risk rating of the breached alert is: 
							 <input class='form-control input-sm textbox' placeholder='H/M/L' type='text' name='ROBO_H_CASE_RATING' value="${HEADER['ROBO_H_CASE_RATING']}" />.
						</p>
					</td>
				</tr>
			</table>
			<b>Executive Summary:</b>
			
			<table class="table    withOutLineTable">
				<tr>
					<td >Compass Case ID</td>
					<td ><input class="form-control input-sm" type="text" name="ROBO_H_CASE_ID" value="${HEADER['ROBO_H_CASE_ID']}" /></td>
					<td  align="right">Alerts Breached:</td>
					<td ><input class="form-control input-sm" type="text" name="ROBO_H_ALERTS_BREACHED" value="${HEADER['ROBO_H_ALERTS_BREACHED']}" /></td>
				</tr>

				<tr>
					<td >Description of Breached Alerts:</td>
					<td colspan="3"><textarea style="align-content:left; "   class="form-control input-sm" rows="6" name="ROBO_H_DESCRIPTION" value = "${HEADER['ROBO_H_DESCRIPTION']}">${HEADER["ROBO_H_DESCRIPTION"]}</textarea></td>
				</tr>
				<tr>
					<td >Is Bank Employee:</td>
					<td ><input type="radio" name="ROBO_H_ISBANK_EMPLOYEE"  ${HEADER['ROBO_H_ISBANK_EMPLOYEE']=='YES'?'checked':''} /> Yes</td>
					<td ><input type="radio" name="ROBO_H_ISBANK_EMPLOYEE" ${HEADER['ROBO_H_ISBANK_EMPLOYEE']=='NO'?'checked':''} />No</td>
					<td ><input type="radio" name="ROBO_H_ISBANK_EMPLOYEE" ${HEADER['ROBO_H_ISBANK_EMPLOYEE']=='UNKNOWN'?'checked':''}/>Unknown</td>
				</tr>
			</table>
		</div>
	</div>
	<!-- Executive Summary: End -->
	
		<!-- SECTION 1 - Customer Details (KYC) Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6 ">
					<h4><b>SECTION 1 - Customer Details (KYC)</b></h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#customerDetails">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			

			<div id="customerDetails" class="collapse in">
				<table class="table  withOutLineTable">
					<tr>
						<td>Customer Name:</td>
						<td ><input class="form-control input-sm" type="text" name="SEC_ONE_CUSTOMER_NAME" value="${SECTION_ONE['SECONE_CUSTOMER_NAME']}" /></td>
						<td >Father's Name:</td>
						<td ><input class="form-control input-sm" type="text" name="SEC_ONE_FATHER_NAME" value="${SECTION_ONE['SECONE_FATHER_NAME']}" /></td>
					</tr>

					<tr>
						<td >Mother's Name:</td>
						<td ><input class="form-control input-sm" type="text" name="SEC_ONE_MOTHER_NAME" value="${SECTION_ONE['SECONE_MOTHER_NAME']}" /></td>
						<td >Account number:</td>
						<td ><input class="form-control input-sm" type="text" name="SEC_ONE_ACCOUNT_NO" value="${SECTION_ONE['SECONE_ACCOUNT_NO']}" /></td>
					</tr>

					<tr>
						<td >Associated Accounts: (If Any)</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_ASSOCIATE_AC_NO" value="${SECTION_ONE['SECONE_ASSOCIATE_AC_NO']}" /></td>
						<td >Base Branch:</td><td ><input class="form-control input-sm" type="text" name="SECONE_BRANCH_NAME" value="${SECTION_ONE['SECONE_BRANCH_NAME']}" /></td>
					</tr>

					<tr>
						<td >Type of Account:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_ACCOUNT_TYPE" value="${SECTION_ONE['SECONE_ACCOUNT_TYPE']}" /></td>
						<td >Risk Rating of Customer:</td>
						<td><input class="form-control input-sm" type="text" name="SECONE_CUST_RISKRATING" value="${SECTION_ONE['SECONE_CUST_RISKRATING']}" /></td>
					</tr>

					<tr>
						<td >Risk Rating of Account:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_AC_RISKRATING" value="${SECTION_ONE['SECONE_AC_RISKRATING']}" /></td>
						<td >Risk Rating of related parties:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_RELPARTY_RISKRATING" value="${SECTION_ONE['SECONE_RELPARTY_RISKRATING']}" /></td>
					</tr>

					<tr>
						<td>KYC Last update date:</td>
						<td ><input class="form-control datepicker" type="date" name="SECONE_L_UPDATE"  value="${SECTION_ONE['SECONE_L_UPDATE']}" /></td>
						<td >KYC Last change date:</td>
						<td ><input class="form-control datepicker" type="date" name="SECONE_L_CHANGE"  value="${SECTION_ONE['SECONE_L_CHANGE']}"  /></td>
					</tr>

					<tr>
						<td >Guardian:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_GURDIAN"  value="${SECTION_ONE['SECONE_GURDIAN']}"/></td>
						<td >Nominee:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_NOMINEE"  value="${SECTION_ONE['SECONE_NOMINEE']}" /></td>
					</tr>

					<tr>
						<td >Other Relationships:</td>
						<td ><input class="form-control input-sm" type="text" name="SECONE_OTHERRELATIONSHIP"  value="${SECTION_ONE['SECONE_OTHERRELATIONSHIP']}" /></td>
						<td ></td>
						<td ></td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- SECTION 1 - Customer Details (KYC) End -->
	
	<!-- Real Time Screening Result Details: start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
			<div class="col-sm-6">
				<h4><b>SECTION 2 - Real-Time Screening Results:</b></h4></div>
			<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#realTimeScreeningn">
				<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
			</div>
		</div>
		
		<div class="col-sm-12 collapse in" id="realTimeScreeningn" >

			<table class="table withOutLineTable">
				<tr>
					<td >Last static data update date:</td>
					<td ><input class="form-control datepicker" type="date" name="SECTWO_L_UPDATEDATE"  value="${SECTION_TWO['SECTWO_L_UPDATEDATE']}"/></td>
					<td ><p>Last transaction update date:</p></td>
					<td ><input class="form-control datepicker" type="date" name="SECTWO_TRANSACTIONDATE"  value="${SECTION_TWO['SECTWO_TRANSACTIONDATE']}"/></td>
				</tr>
			</table>
			<div style="padding-left: 50px">
				<div class="col-sm-6">
					<h4><b>Real Time Screening Search Details:</b></h4></div>

				<hr class="whitehr col-sm-12" size="2">
				<table class="table withOutLineTable" width="100%">
					<tr>
						<td >Name</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_NAME" value="Shinchan San Chao" value="${SECTION_TWO['SECTWO_NAME']}"/></td>
						<td >Other Names</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_OTHERNAME"  value="${SECTION_TWO['SECTWO_OTHERNAME']}"/></td>
					</tr>

					<tr>
						<td >Date of Birth</td>
						<td ><input class="form-control datepicker" type="text" name="SECTWO_DOB"  value="${SECTION_TWO['SECTWO_DOB']}"/></td>
						<td >Account Number</td><td ><input class="form-control input-sm" type="text" name="SECTWO_ACCOUNTNO"  value="${SECTION_TWO['SECTWO_ACCOUNTNO']}"/></td>
					</tr>

					<tr>
						<td >Customer ID</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_CUSTOMERID"  value="${SECTION_TWO['SECTWO_CUSTOMERID']}"/></td>
						<td >Passport Number</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_PASSPORTNO"  value="${SECTION_TWO['SECTWO_PASSPORTNO']}"/></td>
					</tr>

					<tr>
						<td >Tax ID Number</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_TAXID"  value="${SECTION_TWO['SECTWO_TAXID']}"/></td>
						<td >National ID Number</td>
						<td ><input class="form-control input-sm" type="text" name="SECTWO_NATIONALID"  value="${SECTION_TWO['SECTWO_NATIONALID']}"/></td>
					</tr>
				</table>

				<div class="col-sm-6">
					<h4><b>Real Time Screening Result Details:</b></h4></div>
				<div class=" col-sm-12">
					<hr size="2">
					Customer: ${SECTION_TWO['SECTWO_FIRST_CUST_NAME']}
				</div>
				<table class="table no-border">
					<tr>
						<th >List Name</th>
						<th >List Id</th>
						<th >Match Score</th>
						<th >Matched Value</th>
						<th >Match Date</th>
					</tr>
					<tr>
						<td >${SECTION_TWO['SECTWO_FIRST_LISTNAME']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_LISTID']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHSCORE']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHEDVALUE']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHDATE']}</td>
					</tr>

					<tr>
						<td >${SECTION_TWO['SECTWO_FIRST_LISTNAME']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_LISTID']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHSCORE']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHEDVALUE']}</td>
						<td >${SECTION_TWO['SECTWO_FIRST_MATCHDATE']}</td>
					</tr>
				</table>

				Counter Party/Beneficiary : ${SECTION_TWO['SECTWO_SECOND_CUST_NAME']}
				<table class="table no-border">
					<tr>
						<th >List Name</th>

						<th >List Id</th>
						<th >Match Score</th>

						<th >Matched Value</th>

						<th >Match Date</th>
					</tr>

					<tr>
						<td >${SECTION_TWO['SECTWO_SECOND_LISTNAME']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_LISTID']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHSCORE']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHEDVALUE']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHDATE']}</td>
					</tr>
					<tr>
						<td >${SECTION_TWO['SECTWO_SECOND_LISTNAME']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_LISTID']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHSCORE']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHEDVALUE']}</td>
						<td >${SECTION_TWO['SECTWO_SECOND_MATCHDATE']}</td>
					</tr>
				</table>
				<div class="col-sm-offset-5 col-sm-1"
					style="margin-top: 20px; margin-bottom: 20px">
					<button type="button" class="btn btn-success" value="Report">Report</button>
				</div>
			</div>

		</div>
	</div>
	</div>
	<!-- Real Time Screening Result Details: end -->
	
	
	<!-- SECTION 3 - Transaction Details Start -->

	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6">
					<h4><b>SECTION 3 - Transaction Details</b></h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#transactiondetails">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="transactiondetails" class="collapse in">
				<table class="table withOutLineTable">
					<tr>
						<td >TXN Date:</td>
						<td ><input class="form-control datepicker" type="date" name="SECTHREE_TXN_DATE" value="${SECTION_THREE['SECTHREE_TXN_DATE']}" /></td>
						<td >Value:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_VALUE" value="${SECTION_THREE['SECTHREE_VALUE']}" /></td>
					</tr>

					<tr>
						<td >Counterparty:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_COUNTERPARTY" value="${SECTION_THREE['SECTHREE_COUNTERPARTY']}" /></td>
						<td >Type:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_TYPE" value="${SECTION_THREE['SECTHREE_TYPE']}" /></td>
					</tr>

					<tr>
						<td >Product:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_PRODUCT" value="${SECTION_THREE['SECTHREE_PRODUCT']}" /></td>
						<td >Channel:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_CHANNEL" value="${SECTION_THREE['SECTHREE_CHANNEL']}" /></td>
					</tr>

					<tr>
						<td >Value:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_VALUE_ONE"  value="${SECTION_THREE['SECTHREE_VALUE_ONE']}"/></td>
						<td >Time:</td>
						<td ><input class="form-control input-sm" type="text" name="SECTHREE_TIME " value="${SECTION_THREE['SECTHREE_TIME ']}" /></td>
					</tr>

					<tr>
						<td >Cross-border:</td>
						<td ><input type="radio" name="crossBorder" value="yes"  ${SECTION_THREE['SECTHREE_CROSSBORDER']=='YES'?'checked':''} /> Yes<br>
						 <input type="radio" name="crossBorder" value="no"  ${SECTION_THREE['SECTHREE_CROSSBORDER']=='NO'?'checked':''} /> No</td>
						<td ></td>
						<td ></td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- SECTION 3 - Transaction Details End -->
	
	<!-- SECTION 4 - Account Profile (Past 6 months) start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"><h4><b>SECTION 4 - Account Profile (Past 6 months)</b></h4></div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#accountprofile">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="accountprofile" class="collapse in">
				<table class="table withOutLineTable">
					<tr>
						<td >Products Used:</td>
						<td colspan="3"><textarea class="form-control input-sm" name="SECFOUR_PRODUCT_USED">${SECTION_FOUR['SECFOUR_PRODUCT_USED']}
						</textarea></td>
					</tr>
					<tr>
						<td >Total Debits:</td>
						<td ><input class="form-control input-sm" type="text" name="SECFOUR_TOTAL_DEBIT" value="${SECTION_FOUR['SECFOUR_TOTAL_DEBIT']}" /></td>
						<td >Total Credits:</td>
						<td ><input class="form-control input-sm" type="text" name="SECFOUR_TOTAL_CREDIT" value="${SECTION_FOUR['SECFOUR_TOTAL_CREDIT']}" /></td>
					</tr>

					<tr>
						<td >Account Risk:</td>
						<td ><input class="form-control input-sm" type="text" name="SECFOUR_ACCOUNTRISK" value="${SECTION_FOUR['SECFOUR_ACCOUNTRISK']}" /></td>
						<td >Risk last change date:</td>
						<td ><input class="form-control datepicker" type="date" name="SECFOUR_CHANGEDATE" value="${SECTION_FOUR['SECFOUR_CHANGEDATE']}" /></td>
					</tr>

					<tr>
						<td colspan="1">Last 5 account activities:</td>
						<td colspan="3"><textarea class="form-control input-sm" rows="6" name="SECFOUR_LAST_ACTIVITY">${SECTION_FOUR['SECFOUR_LAST_ACTIVITY']}</textarea></td>
					</tr>

					<tr>
						<td >Past CTR or SR or other regulatory reports in this account / customer:</td>
						<td >
							<input type="radio" name="report" value="yes" ${SECTION_FOUR['SECFOUR_CTR_SR_REPORT']=='YES'?'checked':''}  /> Yes<br> 
							<input type="radio"	name="report" value="no"  ${SECTION_FOUR['SECFOUR_CTR_SR_REPORT']=='NO'?'checked':''}/> No
						</td>
						<td >If Yes: Count and Date</td>
						<td >
							<input class="form-control input-sm" placeholder="Count" type="text" name="SECFOUR_IFYES_COUNT" value="${SECTION_FOUR['SECFOUR_IFYES_COUNT']}" /> <br>
							<input class="form-control datepicker" placeholder="Date" type="date" name="SECFOUR_IFYES_DATE" value="${SECTION_FOUR['SECFOUR_IFYES_DATE']}" />
						</td>
					</tr>
				</table>
			</div>


		</div>
	</div>
	<!-- SECTION 4 - Account Profile (Past 6 months) end -->
	
	
	<!-- Section 5 list Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6">
					<h4>
						<b>SECTION 5 - Links</b>
					</h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#linkes">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="linkes" style="margin-left: 20px;" class="collapse in">
				<h4>
					<b>Level 1</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_CREDITS']}</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 2</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_CREDITS']}</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 3</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_CREDITS']}</td>
					</tr>

				</table>

				<h4 style="margin-top: 20px;">
					<b>Level 4</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_CREDITS']}</td>
					</tr>

				</table>

			</div>
		</div>
	</div>
	<!-- Section 5 list end -->
	
	<!-- SECTION 6 - Past History Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"> <h4><b>SECTION 6 - Past History</b></h4></div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#pasthistory">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="pasthistory" class="collapse in">
				<table class="table form-inline no-border" >
					<tr>
						<td >This customer had: <input class="form-control input-sm" style="width: 10%;" placeholder="X" type="text" name="SECSIX_MONTHS_ALERTS" value="${SECTION_SIX['SECSIX_MONTHS_ALERTS']}" /> 
						alerts in the last 6 months and <input class="form-control input-sm" style="width: 10%;" placeholder="X" type="text" name="SECSIX_YEAR_ALERTS" value="${SECTION_SIX['SECSIX_YEAR_ALERTS']}" /> 
						alerts in the last 1 year.
						</td>
					</tr>
				</table>
				<table class="table form-inline no-border">
					<tr>
						<td width="30%">This transaction is the same as above alerts:</td>
						<td >
							<input type="radio" name="transaction" value="yes" ${SECTION_SIX['SECSIX_SAMETRANSACTION']=='YES'?'checked':''} /> Yes 
							<input type="radio" name="transaction" value="no" ${SECTION_SIX['SECSIX_SAMETRANSACTION']=='NO'?'checked':''}/> No
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>
	<!-- SECTION 6 - Past History End -->
	
	<!-- SECTION 7 - Related Parties Start -->

	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"><h4><b>SECTION 7 - Related Parties</b></h4>
					<p>The below relationships were discovered for this customer and account:</p>
				</div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#relatedparties">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="relatedparties" class="collapse in">
				<table class="table no-border form-inline">
					<tr>
						<td >Joint Holder:</td>
						<td ><input type="radio" name="SECSEVEN_JOINTHOLDER" value="yes" ${SECTION_SEVEN['SECSEVEN_JOINTHOLDER']=='YES'?'checked':''} /> Yes</td  >
						<td><input type="radio" name="SECSEVEN_JOINTHOLDER" value="no" ${SECTION_SEVEN['SECSEVEN_JOINTHOLDER']=='NO'?'checked':''} /> No
						</td>
						<td>
							Customer has other accounts:
						</td>
						<td ><input type="radio" name="SECSEVEN_OTHER_ACCOUNT" value="yes" ${SECTION_SEVEN['SECSEVEN_OTHER_ACCOUNT']=='YES'?'checked':''} /> Yes</td >
						<td><input type="radio" name="SECSEVEN_OTHER_ACCOUNT" value="no" ${SECTION_SEVEN['SECSEVEN_OTHER_ACCOUNT']=='NO'?'checked':''} /> No
						</td>
					</tr>
					<tr>
						<td >Customer's relatives have other accounts:</td>
						<td ><input type="radio" name="SECSEVEN_RELATIVE_ACCOUNT" value="yes" ${SECTION_SEVEN['SECSEVEN_RELATIVE_ACCOUNT']=='YES'?'checked':''} > Yes</input></td>
						<td ><input type="radio" name="SECSEVEN_RELATIVE_ACCOUNT" value="no" ${SECTION_SEVEN['SECSEVEN_RELATIVE_ACCOUNT']=='NO'?'checked':''} > No</input></td>
						<td >Customer is beneficiary of other accounts:</td>
						<td ><input type="radio" name="SECSEVEN_BENEFICIARY_ACCOUNT" value="yes" ${SECTION_SEVEN['SECSEVEN_BENEFICIARY_ACCOUNT']=='YES'?'checked':''} > Yes</input></td>
						<td ><input type="radio" name="SECSEVEN_BENEFICIARY_ACCOUNT" value="no" ${SECTION_SEVEN['SECSEVEN_BENEFICIARY_ACCOUNT']=='NO'?'checked':''}>No</input></td>
					</tr>
					<tr>
						<td >Customer is signing authority of Corporate Entity Account:</td>
						<td ><input type="radio" name="SECSEVEN_ENTITY_ACCOUNT" value="yes" ${SECTION_SEVEN['SECSEVEN_ENTITY_ACCOUNT']=='YES'?'checked':''} > Yes</input></td>
						<td ><input type="radio" name="SECSEVEN_ENTITY_ACCOUNT" value="no" ${SECTION_SEVEN['SECSEVEN_ENTITY_ACCOUNT']=='NO'?'checked':''}> No </input></td>
						<td ></td>

					</tr>
				</table>

			</div>

		</div>
	</div>

	<!-- SECTION 7 - Related Parties End -->
	
	<!-- SECTION 8 - Ringside View Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"><h4><b>SECTION 8 - Ringside View</b></h4>
				</div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#ringsideview">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
		
			<div id="ringsideview" class="collapse in">

				<table class="table form-inline no-border ">
					<tr>
						<td >In the last 30 days, this alert was breached
							a total of <input type="text" class="form-control input-sm" placeholder="X" name="SECEIGHT_TOTAL_ALERTBREACHED" value="${SECTION_EIGHT['SECEIGHT_TOTAL_ALERTBREACHED']}" /> times in the
							bank and <input type="text" class="form-control input-sm" placeholder="Y" name="SECEIGHT_FOR_CUSTOMER" value="${SECTION_EIGHT['SECEIGHT_FOR_CUSTOMER']}" /> times for
							customers of the same profile and <input type="text" class="form-control input-sm" placeholder="Z" name="SECEIGHT_FOR_BRANCH"
							value="${SECTION_EIGHT['SECEIGHT_FOR_BRANCH']}" /> times for the base branch of this account.

						</td>
					</tr>
				</table>
				<table class="table form-inline no-border">
					<tr>
						<td >In the last 30 days, transactions from this
							branch breached a total of <input type="text" class="form-control input-sm" placeholder="A" name="SECEIGHT_TRANSACTION_BREACH" value="${SECTION_EIGHT['SECEIGHT_TRANSACTION_BREACH']}" /> number of alerts for 
							<input type="text" class="form-control input-sm" placeholder="B" name="SECEIGHT_CUST_TRANS_BREACH" value="${SECTION_EIGHT['SECEIGHT_CUST_TRANS_BREACH']}" /> 
							sets of customers across 
							<input type="text" class="form-control input-sm" placeholder="C" name="SECEIGHT_BRANCHTRANS_BREACH" value="${SECTION_EIGHT['SECEIGHT_BRANCHTRANS_BREACH']}" /> sets of account.

						</td>
					</tr>
				</table>

			</div>
		
		</div>
	</div>
	<!-- SECTION 8 - Ringside View End -->
	
	<!-- SECTION 9 - User Comments and Notes Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"><h4><b><p>SECTION 9 - User Comments and Notes Start</p></b></h4></div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#comments">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="comments" style="margin-top: 60px;" class="collapse in">
				<textarea class="form-control input-sm" name="SECNINE_COMMENT" placeholder="Add Comments">${SECTION_NINE['SECNINE_COMMENT']}</textarea>
			</div>
		</div>
	</div>

	<!-- SECTION 9 - User Comments and Notes End -->
	
	<!-- SECTION 10 - Action Items Strat -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6"><h4><b><p>SECTION 10 - Action Items Strat</p></b></h4></div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#actionitem">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="actionitem" class="collapse in">
				<table  class="table no-border">
					<tr>
						<td >Escalate</td>
						<td ><input type="checkbox" name="SECTEN_ESCALATE" value="ESCALATE" ${SECTION_TEN['SECTEN_ESCALATE']=='ESCALATE'?'checked':''}  ></td>
						<td >Add To Watch</td>
						<td ><input type="checkbox" name="SECTEN_ADD_TO_WATCH" value="WATCH" ${SECTION_TEN['SECTEN_ADD_TO_WATCH']=='WATCH'?'checked':''}></td>
						<td >Mark as High Risk</td>
						<td ><input type="checkbox" name="SECTEN_HIGH_RISK" value="HIGH RISK" ${SECTION_TEN['SECTEN_HIGH_RISK']=='HIGH RISK'?'checked':''}></td>
					</tr>

					<tr>
						<td >Further Investigate</td>
						<td ><input type="checkbox" name="SECTEN_INVESTIGATION" value="FURTHER INVESTIGATION" ${SECTION_TEN['SECTEN_HIGH_RISK']=='FURTHER INVESTIGATION'?'checked':''}></td>
						<td >Raise CDD request to branch</td>
						<td ><input type="checkbox" name="SECTEN_CDD_REQUEST" value="RAISED CDD" ${SECTION_TEN['SECTEN_CDD_REQUEST']=='RAISED CDD'?'checked':''}></td>
						<td >Close without a case</td>
						<td ><input type="checkbox" name="SECTEN_CLOSE_WITHOUTCASE" value="CLOSE" ${SECTION_TEN['SECTEN_CLOSE_WITHOUTCASE']=='CLOSE'?'checked':''} ></td>
					</tr>

					<tr>
						<td >Mark as false positive</td>
						<td ><input type="checkbox" name="SECTEN_FALSE_POSITIVE" value="FALSE POSITIVE" ${SECTION_TEN['SECTEN_FALSE_POSITIVE']=='FALSE POSITIVE'?'checked':''}></td>
						<td >Mark for Follow up</td>
						<td ><input type="checkbox" name="SECTEN_FOLLOWUP" value="FOLLOWUP" ${SECTION_TEN['SECTEN_FOLLOWUP']=='FOLLOWUP'?'checked':''}></td>
						<td >Desktop Closure</td>
						<td ><input type="checkbox" name="SECTEN_DESKTOP_CLOSER" value="DESKTOP CLOSER" ${SECTION_TEN['SECTEN_DESKTOP_CLOSER']=='DESKTOP CLOSER'?'checked':''}></td>
					</tr>

					<tr>
						<td >Investigated</td>
						<td ><input type="checkbox" name="SECTEN_INVESTIGATED" value="INVESTIGATED" ${SECTION_TEN['SECTEN_INVESTIGATED']=='INVESTIGATED'?'checked':''}  ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- SECTION 10 - Action Items End -->
	
		<!-- Section 11 options Start -->
	<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px">
		<div class=" col-sm-offset-1 col-sm-10">
			<div class="col-sm-12 section-heding">
				<div class="col-sm-6" ><h4><b><p>Option</p></b></h4></div>
				<div class="btn btn-group pull-right col-sm-2 collapsable-div" data-toggle="collapse" data-target="#options">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div id="options" style="margin-top: 60px;" class="collapse in">
				<table class="table no-border">
					<tr>
						<td>Save Roboscan report as part of case</td>
						<td><input type="checkbox" name="OPTION_SAVE_REPORT" value="SAVEREPORT" ${OPTION['OPTION_SAVE_REPORT']=='SAVEREPORT'?'checked':''} ></td>
						<td>Flag for internal discussion</td>
						<td><input type="checkbox" name="OPTION_FLAG_DISCUSSION" value="FLAG" ${OPTION['OPTION_FLAG_DISCUSSION']=='FLAG'?'checked':''} ></td>
					</tr>

					<tr>
						<td>Remind to review in 3 days</td>
						<td><input type="checkbox" name="OPTION_REMIND" value="REMIND" ${OPTION['OPTION_REMIND']=='REMIND'?'checked':''}></td>
						<td></td>
						<td></td>
					</tr>

					<tr>
						<td>Print Roboscan report</td>
						<td>
							<button type="button" class="btn btn-primary">Print</button>
						</td>
						<td>Send as email</td>
						<td>
							<button type="button" class="btn btn-primary">Send</button>
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>

	<!-- Section 11 options ENd -->
	
	
</form>
</body>
</html>