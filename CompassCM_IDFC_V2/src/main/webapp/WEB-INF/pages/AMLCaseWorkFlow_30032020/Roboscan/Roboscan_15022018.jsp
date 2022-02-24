<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<!doctype html>
<html lang="en">
 <head>
  
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
 
 <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
 <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
 <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
 <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>

 <script type="text/javascript">
 
	 $(".datepicker").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	 });
 
 </script>
  
  <title>Roboscan</title>

  <style>
	
	.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	
	.textbox{
		width:20%;
	}

  </style>
 </head>
 
 <body>
 
 <!-- Main container starts -->
 <div class="container" style="border:1px solid black;">

		<div>
		  <table>
				<tr>
				  <td>
					<!-- <input style="position:absolute;" type="image" src="${pageContext.request.contextPath}/includes/images/qde/qde-logo.png" alt="QDE"> -->
					 
					 <img src="${pageContext.request.contextPath}/includes/images/qde/qde-logo.png" alt="QDE">
					 
				  </td>
				</tr>
			    <tr>
				  <td>
					<h1>ROBOSCAN – Intelligent Case Summary</h1>
				  </td>
			    </tr>
		  </table>
		</div>
		
		<div class="card card-primary">
			<div class="card-header">Executive Summary:</div>
			  <div class="card-body">
					<table class="table form-inline" width="100%">
							<tr>
							 <td width='100%'>
							       The
							       <input class='form-control input-sm' style="width:55%;" placeholder='Alert Name' type='text' name='alertName' value='Cash deposits greater than INR [X1] for individuals and greater than INR [X2] for non individuals in a day' /> alert was breached for 
								   <input class='form-control input-sm textbox' placeholder='Customer name' type='text' name='caseId' value='SHINCHAN S/O SAN CHAO'/>. The account on which the alert
								   
								   breached is 
								   <input class='form-control input-sm textbox' placeholder='Account Number' type='text' name='caseId' value='50230500000565' />. A total of 
								   <input class='form-control input-sm textbox' placeholder='No. of Txn' type='text' name='caseId' value='6'/> were involved in this breach. Total of
								   
								   <input class='form-control input-sm textbox' placeholder='X No. of alerts' type='text' name='caseId' value='5'/> alerts have been combined to form this case.  This customer 
								   <input class='form-control input-sm textbox' placeholder='has or does not have' type='text' name='caseId' value='does not have' />
								   
								   historical STR cases with the bank. The risk rating of the breached alert is:
								   <input class='form-control input-sm textbox' placeholder='H/M/L' type='text' name='caseId' value='H' />.
							 </td>
						  </tr>
					</table>
					
					<br>
					
					<table class="table table-striped" >
						<tr>
							<td width="25%">
								<p>
									Compass Case ID
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="caseId" value='119855'/>
							</td>
							<td width="25%">
								<p>
									Alerts Breached:
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="alertsBreached" value='5'/>
							</td>
						</tr>
		
						<tr>
							<td colspan="1">
								<p>
									Description of Breached Alerts:
								</p>
							</td>
							<td colspan="3">
								<textarea class="form-control input-sm" name="caseId" >1) A third party appears to be using the account of customer.
2) Unusual applications for DD/TT/PO against cash.	
3) Number of locker operations greater than [4] times in [3] days.
4) Long Distance Customer Opening Account.
5) Transaction involving a location prior to or immediately after a terrorist incident. 
								</textarea>
							</td>
						</tr>
						<tr>
							<td width="25%">
								<p>
									Is Bank Employee:
								</p>
							</td>
							<td width="25%">
								<input type="radio" name="employee" value="Yes" /> Yes
							</td>
							<td width="25%">
								<input type="radio" name="employee" value="No"  /> No
							</td>
							<td width="25%">
								<input type="radio" name="employee" value="Unknown" checked ="checked"/> Unknown
							</td>
						</tr>
					</table>
				</div>
		</div>

		<!--Section 1-->

		<div class="card card-primary">
			<div class="card-header">SECTION 1 - Customer Details (KYC)</div>
			  <div class="card-body">

				<table class="table table-striped" >
					<tr>
						<td width="25%">
							<p>
								Customer Name:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="customerName" value="Shinchan San Chao"/>
						</td>
						<td width="25%">
							<p>
								Father's Name:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="fatherName" value= "San Chao"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Mother's Name:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="motherName" value="Akia San Chao" />
						</td>
						<td width="25%">
							<p>
								Account number:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="accountNumber" value="50230500000565"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Associated Accounts: (If Any)
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="associateAccounts" value="50230100002282"/>
						</td>
						<td width="25%">
							<p>
								Base Branch:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="baseBranch" value="Marina View (5024)"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Type of Account:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="accountType" value="CCA"/>
						</td>
						<td width="25%">
							<p>
								Risk Rating of Customer:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="customerRisk" value="Medium"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Risk Rating of Account:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="accountRisk" value="High"/>
						</td>
						<td width="25%">
							<p>
								Risk Rating of related parties:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="partyRisk" />
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								KYC Last update date:
							</p>
						</td>
						<td width="25%">
							<input class="form-control datepicker" type="date" name="lastUpdatedate" value="20/01/2013"/>
						</td>
						<td width="25%">
							<p>
								KYC Last change date:
							</p>
						</td>
						<td width="25%">
							<input class="form-control datepicker" type="date" name="lastChangedate" value="05/09/2010"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Guardian:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="guardian" value="San Chao (Father)" />
						</td>
						<td width="25%">
							<p>
								Nominee:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="nominee" value="Akia San Chao (Mother)"/>
						</td>
					</tr>
	
					<tr>
						<td width="25%">
							<p>
								Other Relationships:
							</p>
						</td>
						<td width="25%">
							<input class="form-control input-sm" type="text" name="otherRelation" value="None" />
						</td>
						<td width="25%">
						</td>
						<td width="25%">
						</td>
					</tr>
				</table>
		  	</div>
		</div>
		


		<!--Section 2-->

		<div class="card card-primary">
			<div class="card-header">SECTION 2 - Real-Time Screening Results</div>
			  <div class="card-body">
				 <table class="table">
				  <tr>
				  	<td width="25%">
				  		Last static data update date:
				  	</td>
				    <td width="25%">
						 <input class="form-control datepicker" type="date" name="staticDate" value="19/11/2017"/>
					</td>
					<td width=25%">
						Last transaction update date:
					</td>
					<td width="25%">
						<input class="form-control datepicker" type="date" name="transactionDate" value="20/11/2017"/>
				  	</td>	
				  </tr>
				</table>
			
			<br>
		<div class="card card-primary">
			<div class="card-header">Real Time Screening Search Details:</div>
			  <div class="card-body">

					<table class="table table-striped" width="100%" >
						<tr>
							<td width="25%">
								<p>
									Name
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="name" value="Shinchan San Chao"/>
							</td>
							<td width="25%">
								<p>
									Other Names
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="otherNames" value=" "/>
							</td>
						</tr>
		
						<tr>
							<td width="25%">
								<p>
									Date of Birth
								</p>
							</td>
							<td width="25%">
								<input class="form-control datepicker" type="text" name="dateofBirth" value=" "/>
							</td>
							<td width="25%">
								<p>
									Account Number
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="accountNumber" value="50230100002282"/>
							</td>
						</tr>
		
						<tr>
							<td width="25%">
								<p>
									Customer ID
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="customerId" value="610360974"/>
							</td>
							<td width="25%">
								<p>
									Passport Number
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="passportNumber" value="SI83628323"/>
							</td>
						</tr>
		
						<tr>
							<td width="25%">
								<p>
									Tax ID Number
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="taxId" value=" "/>
							</td>
							<td width="25%">
								<p>
									National ID Number
								</p>
							</td>
							<td width="25%">
								<input class="form-control input-sm" type="text" name="nationalId" value="6562323552"/>
							</td>
						</tr>
						</table>
					</div>
				</div>


					<!--Customer 1-->
			<div class="card card-primary">
			<div class="card-header">Real Time Screening Result Details:</div>
			  <div class="card-body">
				<table class="table table-striped">
					<tr>
					 <td>
					   <h5>&nbsp;&nbsp;&nbsp;<b>Customer: Shinchan San Chao</b></h5>
					 </td>
					</tr>
					
					<table class="table table-striped table-bordered">
						<tr>
							<td width='20%'>
								<p><b>List Name</b></p>
							</td>

							<td width='15%'>
								<p><b>List Id</b></p>
							</td>

							<td width='15%'>
								<p><b>Match Score</b></p>
							</td>

							<td width='35%'>
								<p><b>Matched Value</b></p>
							</td>

							<td width='15%'>
								<p><b>Match Date</b></p>
							</td>
						</tr>

						<tr>
							<td width='20%'>
								OFACSDNLIST
							</td>
							<td width='15%'>
								7898
							</td>
							<td width='15%'>
								75
							</td>
							<td width='35%'>
								Sin Chan Choo
							</td>
							<td width='15%'>
								10-Nov-2017
							</td>
						</tr>

						<tr>
							<td width='20%'>
								OFACSDNLIST
							</td>
							<td width='15%'>
								4198
							</td>
							<td width='15%'>
								61
							</td>
							<td width='35%'>
								Seen Choo Chan
							</td>
							<td width='15%'>
								10-Nov-2017
							</td>
						</tr>
					</table>

					<br>


					<!--Counter Party-->
					<table class="table table-striped">
						<tr>
						 <td>
						   <h5>&nbsp;&nbsp;&nbsp;<b>Counter Party/Beneficiary : Jovia Satanisic</b></h5>
						 </td>
						</tr>
					</table>
					<table class="table table-striped table-bordered">
						<tr>
							<td width='20%'>
								<p><b>List Name</b></p>
							</td>

							<td width='15%'>
								<p><b>List Id</b></p>
							</td>

							<td width='15%'>
								<p><b>Match Score</b></p>
							</td>

							<td width='35%'>
								<p><b>Matched Value</b></p>
							</td>

							<td width='15%'>
								<p><b>Match Date</b></p>
							</td>
						</tr>

						<tr>
							<td width='20%'>
								OFACSDNLIST
							</td>
							<td width='15%'>
								7796
							</td>
							<td width='15%'>
								97
							</td>
							<td width='35%'>
								Jovica SATANISIC
							</td>
							<td width='15%'>
								10-Nov-2017
							</td>
						</tr>

						<tr>
							<td width='20%'>
								OFACSDNLIST
							</td>
							<td width='15%'>
								11142
							</td>
							<td width='15%'>
								76
							</td>
							<td width='35%'>
								Joviya
							</td>
							<td width='15%'>
								10-Nov-2017
							</td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td style="float:right; width:100%;">
								<button type="button" style="float:right; margin-top:2%; margin-right:50%;">Report</button>
							</td>
						</tr>
					</table>
			</table>
			</div>
			</div>
			</div>
			<br>
			<br>
			</div>
		
	


		<!--Section 3-->
		<div class="card card-primary">
			<div class="card-header">SECTION 3 - Transaction Details</div>
			  <div class="card-body">

			<table class="table table-striped">
				<tr>
					<td width="25%">
						TXN Date:
					</td>
					<td width="25%">
						<input class="form-control datepicker" type="date" name="txnDate" value="10-Sep-2017"/>
					</td>
					<td width="25%">
						Value:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="value" value="12123120"/>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Counterparty:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="counterParty" value="Jovia Satanisic"/>
					</td>
					<td width="25%">
						Type:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="type" value="C/NR"/>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Product:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="product" value="Diamond Dealer"/>
					</td>
					<td width="25%">
						Channel:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="channel" value="Cash"/>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Value:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="value" />
					</td>
					<td width="25%">
						Time:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="time" value="12:05 am"/>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Cross-border:
					</td>
					<td width="25%">
						<input type="radio" name="crossBorder" value="yes" checked="checked" /> Yes<br>
						<input type="radio" name="crossBorder" value="no" /> No
					</td>
					<td width="25%">
					</td>
					<td width="25%">
					</td>
				</tr>
			</table>
		</div>
		</div>


		<!--Section 4-->

		<div class="card card-primary">
			<div class="card-header">SECTION 4 - Account Profile (Past 6 months)</div>
			  <div class="card-body">
			  	<table class="table table-striped">
				<tr>
					<td colspan="1">
						Products Used:
					</td>
					<td colspan="3">
						<textarea class="form-control input-sm" name="productUsed">SBNRO - NRO SAVINGS ACCOUNT							
COFFD - CORPORATE FLEXI FIXED DEPOSIT
						</textarea>
					</td>
				</tr>
				<tr>
					<td width="25%">
						Total Debits:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="totalDebit" value="3"/>
					</td>
					<td width="25%">
						Total Credits:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="totalCredit" value="5"/>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Account Risk:
					</td>
					<td width="25%">
						<input class="form-control input-sm" type="text" name="accountRisk" value="High"/>
					</td>
					<td width="25%">
						Risk last change date:
					</td>
					<td width="25%">
						<input class="form-control datepicker" type="date" name="changeDate" value="16/11/2017"/>
					</td>
				</tr>

				<tr>
					<td colspan="1">
						Last 5 account activities:
					</td>
					<td colspan="3">
						<textarea class="form-control input-sm" name="accountActivities">1) S$ 1250000 debited to account number XXXXXXXXX125.
2) S$ 250000 credited to account number XXXXXXXXX880.
3) S$ 10000000 credited to account number XXXXXXXXX100.
4) Account number XXXXXXXXX888 is debited for S$ 9250000 on 15-11-17 and account number XXXXXXXXX100 credited.
5) Account number XXXXXXXXX125 debited with S$ 1250000 by ATM POS/978764/01:25:48/979.
						</textarea>
					</td>
				</tr>

				<tr>
					<td width="25%">
						Past CTR or SR or other regulatory reports in this account / customer:
					</td>
					<td width="25%">
						<input type="radio" name="report" value="yes" checked= "checked"/> Yes<br>
						<input type="radio" name="report" value="no" /> No
					</td>
					<td width="25%">
						If Yes: Count and Date
					</td>
					<td width="25%">
						<input class="form-control input-sm" placeholder="Count" type="text" name="count" value="2" />
						<br>
						<input class="form-control datepicker" placeholder="Date" type="date" name="date" value="18/11/2017"/>
					</td>
				</tr>
				</table>
			  </div>
			</div>

			


		<!--Section 5-->


		<div class="card card-primary">
			<div class="card-header">SECTION 5 - Links</div>
			  <div class="card-body">

			<!--Level 1-->
			<table class='table'>
				 <thead>
					<b>Level 1:</b>
				 </thead>
			</table>

			<table class="table table-striped table-bordered">
				<tr>
					<td width='20%'>
						<b>Total Transactions</b>
					</td>
					<td width='20%'>
						<b>Any alerted TXN</b>
					</td>
					<td width='20%'>
						<b>Total Cumulative Value</b>
						<br>
						(Txn count and cumulative value)
					</td>
					<td width='20%'>
						<b>Total Debits</b>
						<br>
						(Txn count and cumulative value)
					</td>
					<td width='20%'>
						<b>Total Credits</b>
						<br>
						(Txn count and cumulative value)
					</td>
				</tr>

				<tr>
					<td width='20%'>
						8
					</td>
					<td width='20%'>
					    5
					</td>
					<td width='20%'>
						8 and 35420000
					</td>
					<td width='20%'>
						3 and 4561231
					</td>
					<td width='20%'>
						5 and 30858769
					</td>
				</tr>
<!--
				<tr>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
				</tr>-->
			</table>

			<br>
			<br>
			
			<!--Level 2-->
			<table class='table'>
				 <thead>
					<b>Level 2:</b>
				 </thead>
			</table>

			<table class="table table-striped table-bordered">
				<tr>
					<td width='20%'>
						<b>Total Transactions</b>
					</td>
					<td width='20%'>
						<b>Any alerted TXN</b>
					</td>
					<td width='20%'>
						<b>Total Cumulative Value</b>
						<br>
						(Txn count and cumulative value)
					</td>
					<td width='20%'>
						<b>Total Debits</b>
						<br>
						(Txn count and cumulative value)
					</td>
					<td width='20%'>
						<b>Total Credits</b>
						<br>
						(Txn count and cumulative value)
					</td>
				</tr>

				<tr>
					<td width='20%'>
						2
					</td>
					<td width='20%'>
					    3
					</td>
					<td width='20%'>
						5 and 766443
					</td>
					<td width='20%'>
						2 and 66990
					</td>
					<td width='20%'>
						3 and 709660
					</td>
				</tr>
<!--
				<tr>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
				</tr>-->
			</table>

			<br>
			<br>
			
			<!--Level 3-->
			<table class='table'>
				 <thead>
					<b>Level 3:</b>
				  </thead>
			</table>

			<table class="table table-striped table-bordered">
				<tr>
					<td width='20%'>
						Total Transactions
					</td>
					<td width='20%'>
						Any alerted TXN
					</td>
					<td width='20%'>
						Total Cumulative Value
					</td>
					<td width='20%'>
						Total Debits
					</td>
					<td width='20%'>
						Total Credits
					</td>
				</tr>

				<tr>
					<td width='20%'>
						4
					</td>
					<td width='20%'>
					    3
					</td>
					<td width='20%'>
						7 and 9111223
					</td>
					<td width='20%'>
						4 and 669900
					</td>
					<td width='20%'>
						3 and 8441323
					</td>
				</tr>
<!--
				<tr>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
				</tr>-->
			</table>

			<br>
			<br>
			
			<!--Level 4-->
			<table class='table'>
				<thead>
					<b>Level 4:</b>
				</thead>
			</table>

			<table class="table table-striped table-bordered">
				<tr>
					<td width='20%'>
						Total Transactions
					</td>
					<td width='20%'>
						Any alerted TXN
					</td>
					<td width='20%'>
						Total Cumulative Value
					</td>
					<td width='20%'>
						Total Debits
					</td>
					<td width='20%'>
						Total Credits
					</td>
				</tr>

				<tr>
					<td width='20%'>
						4
					</td>
					<td width='20%'>
					    3
					</td>
					<td width='20%'>
						7 and 9111223
					</td>
					<td width='20%'>
						4 and 669900
					</td>
					<td width='20%'>
						3 and 8441323
					</td>
				</tr>
<!--
				<tr>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
					<td width='20%'>
						
					</td>
				</tr>-->
			</table>
		</div>
		</div>


		<!--Section 6-->

		<div class="card card-primary">
			<div class="card-header">SECTION 6 - Past History</div>
			  <div class="card-body">
				 <table class="table form-inline">
				    <tr>
						<td width="100%">
						   This customer had:
						   <input class="form-control input-sm" style="width:10%;" placeholder="X" type="text" name="noOfAlerts" value="5"/> alerts in the last 6 months and
						   <input class="form-control input-sm" style="width:10%;" placeholder="X" type="text" name="noOfAlerts" value="15"/>  alerts in the last 1 year.
						</td>
					</tr>
				 
					<!-- <tr>
						<td width="25%">
							<input class="form-control input-sm" style="width:50%;" placeholder="X" type="text" name="noOfAlerts" value="5"/> alerts in the last 6 months and
						</td>
						<td width="25%">
							<input class="form-control input-sm" style="width:50%;" placeholder="X" type="text" name="noOfAlerts" value="15"/>  alerts in the last 1 year.
						</td>
					</tr> -->
					<table class="table">
					<tr>
						<td width="25%">
							This transaction is the same as above alerts:
						</td>
						<td width="25%">
							<input type="radio" name="transaction" value="yes" checked = "checked" /> Yes<br>
							<input type="radio" name="transaction" value="no" /> No
						</td>
					</tr>
					</table>
			</table>
		</div>
	</div>



		<!--Section 7-->

		<div class="card card-primary">
			<div class="card-header">SECTION 7 - Related Parties</div>
			  <div class="card-body">
				<table>
					<tr>
						<td>
						   <p>The below relationships were discovered for this customer and account:</p>
						</td>
					</tr>
				</table>

			<table class="table table-striped">
				<tr>
					<td width="25%">
						<p>
							Joint Holder:
						</p>
					</td>
					<td width="25%">
						<input type="radio" name="jointHolder" value="yes" checked="checked" /> Yes<br>
						<input type="radio" name="jointHolder" value="no" /> No
					</td>
					<td width="25%">
						<p>
							Customer has other accounts:
						</p>
					</td>
					<td width="25%">
						<input type="radio" name="otherAccount" value="yes" checked="checked" /> Yes<br>
						<input type="radio" name="otherAccount" value="no" /> No
					</td>
				</tr>
				<tr>
					<td width="25%">
						<p>
							Customer's relatives have other accounts:
						</p>
					</td>
					<td width="25%">
						<input type="radio" name="relativeAccounts" value="yes" checked= "checked"> Yes<br></input>
						<input type="radio" name="relativeAccounts" value="no"> No</input>
					</td>
					<td width="25%">
						<p>
							Customer is beneficiary of other accounts:
						</p>
					</td>
					<td width="25%">
						<input type="radio" name="beneficiaryAccounts" value="yes" > Yes<br></input>
						<input type="radio" name="beneficiaryAccounts" value="no" checked="checked"> No</input>
					</td>
				</tr>
				<tr>
					<td width="25%">
						<p>
							Customer is signing authority of Corporate Entity Account:
						</p>
					</td>
					<td width="25%">
						<input type="radio" name="entityAccount" value="yes" checked="checked"> Yes<br></input>
						<input type="radio" name="entityAccount" value="no"> No </input>
					</td>
					<td width="25%">
					</td>
					<td width="25%">
					</td>
				</tr>
			</table>
		</div>
	</div>



		<!--Section 8-->

		<div class="card card-primary">
			<div class="card-header">SECTION 8 - Ringside View</div>
			  <div class="card-body">
				<table class="table form-inline">
					<tr>
						<td width="100%">
							
								In the last 30 days, this alert was breached a total of
								<input type="text" class="form-control input-sm" placeholder="X" name="alertsBreach" value="5"/> times in the bank and
								<input type="text" class="form-control input-sm" placeholder="Y" name="alertsBreach" value="3"/> times for customers of the same profile and
								<input type="text" class="form-control input-sm" placeholder="Z" name="alertsBreach" value="2"/> times for the base branch of this account.
						
						</td>
					</tr>
				</table>
				<table class="table form-inline">
					<tr>
						<td width="100%">
						
								In the last 30 days, transactions from this branch breached a total of
								<input type="text" class="form-control input-sm" placeholder="A" name="transitionsBreach" value="10"/> number of alerts for
								<input type="text" class="form-control input-sm" placeholder="B" name="transitionsBreach" value="7"/> sets of customers across
								<input type="text" class="form-control input-sm" placeholder="C" name="transitionsBreach" value="9"/> sets of account.
						
						</td>
					</tr>
				</table>
			</div>
		</div>



		<!--Section 9-->

		<div class="card card-primary">
			<div class="card-header">SECTION 9 - User Comments and Notes</div>
			  <div class="card-body">
			  	<table style="width:100%;">
					<tr>
						<td>
							<textarea class="form-control input-sm" name="comment" placeholder="Add Comments" >Severely suspicious transactions witnessed against the customer. Needs to file STR.
							</textarea>
						</td>
					</tr>
				</table>
			  </div>
		</div>


		<!--Section 10-->

		<div class="card card-primary">
			<div class="card-header">SECTION 10 - Action Items</div>
			  <div class="card-body">
			  	<table class="table table-striped">
				<tr>
					<td width="20%">
						Escalate
					</td>
					<td width="10%">
						<input type="checkbox" name="actionItem" value="escalate" >
					</td>
					<td width="20%">
						Add To Watch
					</td>
					<td width="10%">
						<input type="checkbox" name="actionItem" value="watch" checked="checked">
					</td>
					<td width="20%">
						Mark as High Risk
					</td>
					<td width="10%">
						<input type="checkbox" name="actionItem" value="highRisk" checked="checked">
					</td>
				</tr>

				<tr>
					<td width="20%">
						Further Investigate
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="furtherInvestigate" checked="checked">
					</td>
					<td width="20%">
						Raise CDD request to branch
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="raiseCdd" checked="checked">
					</td>
					<td width="20%">
						Close without a case
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="close">
					</td>
				</tr>

				<tr>
					<td width="20%">
						Mark as false positive
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="falsePositive" >
					</td>
					<td width="20%">
						Mark for Follow up
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="followUp" checked="checked">
					</td>
					<td width="20%">
						Desktop Closure
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="desktopClosure">
					</td>
				</tr>

				<tr>
					<td width="20%">
						Investigated
					</td>
					<td width="13%">
						<input type="checkbox" name="actionItem" value="investigated">
					</td>
					<td width="20%">
					</td>
					<td width="13%">
					</td>
					<td width="20%">
					</td>
					<td width="13%">
					</td>
				</tr>
				</table>
			  </div>
		</div>


		<!--Options Part-->

		<div class="card card-primary">
			<div class="card-header">OPTIONS</div>
			  <div class="card-body">
			  	<table class="table table-striped">
				<tr>
					<td width="25%">
						Save Roboscan report as part of case
					</td>
					<td width="25%">
						<input type="checkbox" name="options" value="saveReport" checked="checked"> 
					</td>
					<td width="25%">
						Flag for internal discussion
					</td>
					<td width="25%">
						<input type="checkbox" name="options" value="flag" checked="checked">
					</td>
				</tr>

				<tr>
					<td width="25%">
						Remind to review in 3 days
					</td>
					<td width="25%">
						<input type="checkbox" name="options" value="remind" checked="checked">
					</td>
					<td width="25%">
					</td>
					<td width="25%">
					</td>
				</tr>

				<tr>
					<td width="25%">
						Print Roboscan report
					</td>
					<td width="25%">
						<button type="button">Print</button>
					</td>
					<td width="25%">
						Send as email
					</td>
					<td width="25%">
						<button type="button">Send</button>
					</td>
				</tr>
				</table>
			  </div>
		</div>
  
  	<div class="card card-info">
		<div class="card-header">
			<table width="100%">
			<tr>
			  <td width="5%">
				<input type="image" src="${pageContext.request.contextPath}/includes/images/qde/qde-favicon.png" alt="QDE">
			  </td>
			  <td width="95%">
				Copyright Quantum Data Engines. 2016-17
			  </td>
			</tr>
			</table>
		</div>
	</div>
  </div>
  
  <!-- Main container ends -->
 </div>
 </body>
 </html>
