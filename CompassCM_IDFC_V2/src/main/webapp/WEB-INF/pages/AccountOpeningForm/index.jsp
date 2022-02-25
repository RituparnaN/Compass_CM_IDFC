<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Account Opening Form</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!--[if lt IE 9]>
	<script src="<%=contextPath%>/scripts/html5shiv.js"></script>
	<script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
	<script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css">
<style type="text/css">
	.section{
		width: 100%;
		margin: 2px 0 10px 0;
		border: 1px solid #000000;
	}
	.sectionHeader{
		background: gray;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
	}
	.sectionBody{
		padding: 3px;
	}
	.sectionFooter{
		background: gray;
		padding-left: 95%;
	}
	ul.inlineUL{
		line-height: 0px;
		margin-bottom: 0px;
		list-style-type: none;
	}
	ul.inlineUL li{
		display: inline;
		padding: 0 5px;
		line-height: 0px;
		margin-bottom: 3px;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	input[tyep=text] {
		border:1px solid #ccc;
		text-align: justify;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#cifno").focus();
		$(".datepicker").datepicker({
			 dateFormat : "mm/dd/yy",
			 changeMonth: true,
		     changeYear: true
		 });
	});
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-default">
				<div class="card-header">
					<div class="row">
						<div class="col-sm-6">
							<i class="fa fa-bar-chart-o fa-fw"></i>Account Opening Form
						</div>
					</div>
					<div class="input-group" style="margin-left: 70%">
						<input type="text" class="form-control input-sm" id="cifno" name="cifno">
						<span class="input-group-btn">
							<button class="btn btn-primary btn-sm" type="button">CIF Search</button>
						</span>
					</div>
				</div>
				<div class="card-body">
					<ul class="nav nav-tabs" role="tablist">
				    	<li role="presentation" class="active">
				    		<a class="nav-link active" href="#category1" aria-controls="category1" role="tab" data-toggle="tab">Category 1</a>
				    	</li>
				    	<li role="presentation">
				    		<a class="nav-link" href="#category2" aria-controls="category2" role="tab" data-toggle="tab">Category 2</a>
				    	</li>
				    	<li role="presentation">
				    		<a class="nav-link" href="#category3" aria-controls="category3" role="tab" data-toggle="tab">Category 3</a>
				    	</li>
				    	<li role="presentation">
				    		<a class="nav-link" href="#category4" aria-controls="category4" role="tab" data-toggle="tab">Category 4</a>
				    	</li>
				    	<li role="presentation">
				    		<a class="nav-link" href="#category5" aria-controls="category5" role="tab" data-toggle="tab">Category 5</a>
				    	</li>
				  	</ul>
				
				  <!-- Tab panes -->
				  <div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="category1">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			TYPE OF ACCOUNT
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr>
				    					<td>
				    						<table>
				    							<tr>
				    								<td>
				    									<input type="radio" name="typeOfAccount1" id="typeOfAccount11" value="Individual">
							    						<label for="typeOfAccount11">Individual&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="typeOfAccount1" id="typeOfAccount12" value="Joint">
								    					<label for="typeOfAccount12">
								    						Joint (Please fill in details of Joint Applicant in the space provided)
								    					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="typeOfAccount1" id="typeOfAccount13" value="IndividualBusiness">
								    					<label for="typeOfAccount13">
								    						Individual Business&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								    					</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="typeOfAccount1" id="typeOfAccount14" value="JointBusiness">
							    						<label for="typeOfAccount14">Joint Business&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table>
					    						<tr>
					    							<td>
					    								<input type="radio" name="typeOfAccount2" id="typeOfAccount21" value="Current">
							    						<label for="typeOfAccount21">Current&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					    							</td>
					    							<td>
					    								<input type="radio" name="typeOfAccount2" id="typeOfAccount22" value="Savings">
							    						<label for="typeOfAccount22">Savings&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					    							</td>
					    							<td>
						    							<input type="radio" name="typeOfAccount2" id="typeOfAccount23" value="TermInvestment">
								    					<label for="typeOfAccount23">Term Investment&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					    							</td>
					    							<td>
					    								<input type="radio" name="typeOfAccount2" id="typeOfAccount24" value="Other">
								    					<label for="typeOfAccount24">
								    						Other: <input type="text" name="typeOfAccount2Other"> 
								    					</label>
					    							</td>
					    						</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    					<table>
				    						<tr>
				    							<td colspan="4">If foreign country account, please state currency: <input type="text" name="foreignCurrency">
				    							</td>
				    						</tr>
				    						<tr>
				    							<td>
				    								<input type="radio" name="typeOfAccount3" id="typeOfAccount31" value="RFC">
							    					<label for="typeOfAccount31">RFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    							</td>
				    							<td>
				    								<input type="radio" name="typeOfAccount3" id="typeOfAccount32" value="NRFC">
							    					<label for="typeOfAccount32">NRFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    							</td>
				    							<td>
				    								<input type="radio" name="typeOfAccount3" id="typeOfAccount33" value="RNNFC">
							    					<label for="typeOfAccount33">RNNFC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
				    							</td>
				    							<td>
				    								<input type="radio" name="typeOfAccount3" id="typeOfAccount34" value="Other">
							    					<label for="typeOfAccount34">
							    						Other: <input type="text" name="typeOfAccount3Other">
							    					</label>
				    							</td>
				    						</tr>
				    					</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	
				    	<div class="section">
				    		<div class="sectionHeader">
				    			BAISC INFORMATION OF ACCOUNT HOLDER/S
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="50%">
				    						Primary Account Holder
				    					</td>
				    					<td width="50%">
				    						Joint Account Holder
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('addAccountHolder.jsp?type=PRIMARY','BAISC INFORMATION OF ACCOUNT HOLDER','height=600, width=1200, resizable=Yes, scrollbars=Yes')">Add a new Primary Account Holder</a>
				    					</td>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('addAccountHolder.jsp?type=JOINT','BAISC INFORMATION OF ACCOUNT HOLDER','height=600, width=1200, resizable=Yes, scrollbars=Yes')">Add a new Joint Account Holder</a>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category2">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			OTHER INFORMATION
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="25%">
				    						Purpose of Opening Account
				    					</td>
				    					<td width="75%">
				    						<table width="100%">
				    							<tr>
				    								<td>
										    			<input type="radio" name="purposeOfAccount" id="purposeOfAccount1" value="Savings">
										    			<label for="purposeOfAccount1">Savings</label>
										    			
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount2" value="BusinessTransaction">
										    			<label for="purposeOfAccount2">Business Transaction</label>
										    		</td>
										    		<td>
										    			<input type="radio" name="purposeOfAccount" id="purposeOfAccount3" value="LoanRepayment">
										    			<label for="purposeOfAccount3">Loan Re-payment</label>
										    		</td>
										    		<td>
										    			<input type="radio" name="purposeOfAccount" id="purposeOfAccount4" value="SocialCharityWork">
										    			<label for="purposeOfAccount4">Social Charity Work</label>
										    		</td>
				    							</tr>
				    							<tr>
				    								<td>
										    			<input type="radio" name="purposeOfAccount" id="purposeOfAccount5" value="SalaryProfessionalIncome">
										    			<label for="purposeOfAccount5">Salary Professional Income</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount6" value="FamilyInwardRemittance">
										    			<label for="purposeOfAccount6">Family Inward Remittance</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount7" value="InvestmentPurpose">
										    			<label for="purposeOfAccount7">Investment Purpose</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount8" value="ShareTransactions">
										    			<label for="purposeOfAccount8">Share Transactions</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
										    			<input type="radio" name="purposeOfAccount" id="purposeOfAccount9" value="UtilityBillPayment">
										    			<label for="purposeOfAccount9">Utility Bill Payment</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount10" value="UpkeepFamily">
										    			<label for="purposeOfAccount10">Upkeep of Family/Person</label>
				    								</td>
				    								<td>
				    									<input type="radio" name="purposeOfAccount" id="purposeOfAccount11" value="Other">
										    			<label for="purposeOfAccount11">
										    			Other: <input type="text" name="purposeOfAccount10">
										    			</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Source of Funds
				    					</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund1" value="Salary">
										    			<label for="sourceOfFund1">Salary</label>
				    								</td>
				    								<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund2" value="Business">
										    			<label for="sourceOfFund2">Business</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund3" value="FamilyRemittances">
										    			<label for="sourceOfFund3">Family Remittances</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund4" value="ExportProceeds">
										    			<label for="sourceOfFund4">Export Proceeds</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund5" value="InvestmentsProceeds">
										    			<label for="sourceOfFund5">Investments Proceeds</label>
				    								</td>
				    								<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund6" value="Donation">
										    			<label for="sourceOfFund6">Donations / Charities</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund7" value="CommissionIncome">
										    			<label for="sourceOfFund7">Commission Income</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="sourceOfFund" id="sourceOfFund8" value="Others">
										    			<label for="sourceOfFund8">
										    				Others : <input type="text" name="sourceOfFund8"/>
										    			</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Anticipated Deposits to the Account
				    					</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount1" value="1">
										    			<label for="depositAmountInAccount1">Less than 100,000</label>
				    								</td>
				    								<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount2" value="2">
										    			<label for="depositAmountInAccount2">100,000 - 500,000</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount3" value="3">
										    			<label for="depositAmountInAccount3">500,000 - 1,000,000</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount4" value="4">
										    			<label for="depositAmountInAccount4">1,000,000 - 2,000,000</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount5" value="5">
										    			<label for="depositAmountInAccount5">2,000,000 - 3,000,000</label>
				    								</td>
				    								<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount6" value="6">
										    			<label for="depositAmountInAccount6">3,000,000 - 4,000,000</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount7" value="7">
										    			<label for="depositAmountInAccount7">4,000,000 - 5,000,000</label>
				    								</td>
										    		<td>
										    			<input type="radio" name="depositAmountInAccount" id="depositAmountInAccount8" value="8">
										    			<label for="depositAmountInAccount8">5,000,000 and above</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Initial Deposit Amount
				    					</td>
				    					<td>
				    						<input type="text" name="initialDepositAmount" class="form-control imput-sm">
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('assetsTax.jsp?type=PRIMARY', 'Add Assets and Tax Declaration of Primary Account Holder', 'height=600,width=1200,resizable=No,scrollbars=Yes')">Add Assets and Tax Declaration of Primary Account Holder</a>
				    					</td>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('assetsTax.jsp?type=JOINT', 'Add Assets and Tax Declaration of Joint Account Holder', 'height=600,width=1200,resizable=No,scrollbars=Yes')">Add Assets and Tax Declaration of Joint Account Holder</a>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			FOR TERM INVESTMENT ACCOUNTS ONLY
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="25%">
				    						Investment Period
				    					</td>
				    					<td width="75%">
				    						<input type="text" name="investmentPeriodMonths"> Months	
				    						<input type="text" name="investmentPeriodYears"> Years				    						
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						Investment Amount Details
				    					</td>
				    					<td width="75%">
				    						Amount : <input type="text" name="investmentPeriod"><br/>
				    						Mode of Deposit: <input type="radio" name="modeOfDeposit" id="modeOfDepositCash" value="Cash"> <label for="modeOfDepositCash">Cash</label>
				    						<input type="radio" name="modeOfDeposit" id="modeOfDepositCheque" value="cheque"> <label for="modeOfDepositCheque">Cheque No:<input type="text" name="modeOfDepositChequeNo"/></label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						Profit Payment
				    					</td>
				    					<td width="75%">
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="profitPayment" id="profitPayment1" value="1">
				    								<label for="profitPayment1">Paid at Maturity</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="profitPayment" id="profitPayment2" value="2">
				    								<label for="profitPayment2">Paid at Monthly</label>
				    							</li>
				    						</ul>	    						
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						Please credit/remit profilts at maturity/monthly to
				    					</td>
				    					<td width="75%">
				    						Account No: <input type="text" name="maturityAccountNo"><br/>
				    						Account Name: <input type="text" name="maturityAccountName">				    						
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			CORRESPONDENCE
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="25%">
				    						Bank Correspondence
				    					</td>
				    					<td width="75%">
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="bankCorrespondence" id="bankCorrespondence1" value="1">
				    								<label for="bankCorrespondence1">Primary Account Holder</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="bankCorrespondence" id="bankCorrespondence2" value="2">
				    								<label for="bankCorrespondence2">Joint Account Holder</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						For Savings Account
				    					</td>
				    					<td width="75%">
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="forSavingsAccount" id="forSavingsAccount1" value="1">
				    								<label for="forSavingsAccount1">Passbook</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="forSavingsAccount" id="forSavingsAccount2" value="2">
				    								<label for="forSavingsAccount2">Account Statement</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						Statement Frequencys
				    					</td>
				    					<td width="75%">
				    						<table>
				    							<tr>
				    								<td width="25%">For Current Account</td>
				    								<td width="75%">
				    									<ul class="inlineUL">
							    							<li>
							    								<input type="radio" name="statementFrequencyCurr" id="statementFrequencyCurr1" value="1">
							    								<label for="statementFrequencyCurr1">Monthly</label>
							    							</li>
							    							<li>
							    								<input type="radio" name="statementFrequencyCurr" id="statementFrequencyCurr2" value="2">
							    								<label for="statementFrequencyCurr2">Quarterly</label>
							    							</li>
							    							<li>
							    								<input type="radio" name="statementFrequencyCurr" id="statementFrequencyCurr3" value="3">
							    								<label for="statementFrequencyCurr3">
							    									Other : <input type="text" name="statementFrequencyCurr3"/>
							    								</label>
							    							</li>
							    						</ul>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td width="25%">For Savings Account</td>
				    								<td width="75%">
				    									<ul class="inlineUL">
							    							<li>
							    								<input type="radio" name="statementFrequencySav" id="statementFrequencySav1" value="1">
							    								<label for="statementFrequencySav1">Monthly</label>
							    							</li>
							    							<li>
							    								<input type="radio" name="statementFrequencySav" id="statementFrequencySav2" value="2">
							    								<label for="statementFrequencySav2">Quarterly</label>
							    							</li>
							    							<li>
							    								<input type="radio" name="statementFrequencySav" id="statementFrequencySav3" value="3">
							    								<label for="statementFrequencySav3">
							    									Other : <input type="text" name="statementFrequencySav3"/>
							    								</label>
							    							</li>
							    						</ul>
				    								</td>
				    							</tr>
				    						</table>				
				    					</td>
				    				</tr>
				    				<tr>
				    					<td width="25%">
				    						Mode of Dispatch
				    					</td>
				    					<td width="75%">
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="modeOfDispatch" id="modeOfDispatch1" value="1">
				    								<label for="modeOfDispatch2">by Post</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="modeOfDispatch" id="modeOfDispatch2" value="2">
				    								<label for="modeOfDispatch2">Collect at Branch</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="modeOfDispatch" id="modeOfDispatch3" value="3">
				    								<label for="modeOfDispatch3">
				    									by Email. Email Address: <input type="text" name="modeOfDispatch3">
				    								</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			CHEQUE BOOK REQUISITION (for Current Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="25%">
				    						Please issue me / us a Cheque Book with
				    					</td>
				    					<td width="75%">
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="chequeBook" id="chequeBook1" value="1">
				    								<label for="chequeBook1">25 Leaves</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="chequeBook" id="chequeBook2" value="2">
				    								<label for="chequeBook2">50 Leaves</label>
				    							</li>
				    						</ul>			    						
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			VALUE ADDED SERVICES
				    		</div>
				    		<div class="sectionBody">
				    			<table width="100%">
				    				<tr>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('addValueAddedService.jsp?type=PRIMARY','ADD VALUE ADDED SERVICE','height=600, width=1200, resizable=Yes, scrollbars=Yes')">ADD VALUE ADDED SERVICE FOR THIS</a>
				    					</td>
				    					<td>
				    						<a class="nav-link" href="javascript:void(0)" onclick="window.open('addValueAddedService.jsp?type=PRIMARY','ADD VALUE ADDED SERVICE','height=600, width=1200, resizable=Yes, scrollbars=Yes')">ADD VALUE ADDED SERVICE FOR THIS</a>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category3">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			Mudaraba Agreement (For all Savings and Term Investment Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			This Mudaraba Agreement is made and entered into on this <input type="text" name="mudarabaagreement1" class="datepicker"/>
				    			at <input type="text" name="mudarabaagreement2"/> by and between <input type="text" name="mudarabaagreement3"/> of <input type="text" name="mudarabaagreement4"/>
				    			herein referred to as the Investor/s (which expression where the context shall so admit, mean ans include the said 
				    			<input type="text" name="mudarabaagreement5"/> his/her/their heirs executors administrators successors in interest and assign) of
				    			the ONE PART and Amana Bank PLC (hereinafter sometimes referred to as the "Mudarib" or the Bank) a company duly incorporated
				    			under the Companies Act No. 7 of 2007 and a Licensed Commercial Bank having its registered office at No. 480, Galle Road, Colombo 03, Sri Lanka (
				    			Which expression where the context shall so admit mean and include Amana Bank Limited its successors in interest and assigns) of the OTHER PART.
				    			<br/>
				    			AND WHEREAS the Investor/s is/are desirous of opening a savings account/term investment account with the Bank for the purpose pf investing from time to time
				    			in the Mudaraba Fund of the Bank to invest in the Bank's business activities that are expected to generate profits.
				    			<br/>
				    			AND WHEREAS the Bank is willing to accept such funds for investment in the Bank's business activities that are excepted to generate profits and share such
				    			profits on the following Terms and Condition
				    			<br/><br/>
				    			<table>
				    				<tr>
				    					<td colspan="2">Profit Sharing Ratio</td>
				    				</tr>
				    				<tr>
				    					<td>Account Type</td>
				    					<td><input type="text" name="mudarabaagreementAccountType1"/></td>
				    					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    					<td>Account Type</td>
				    					<td><input type="text" name="mudarabaagreementAccountType2"/></td>
				    				</tr>
				    				<tr>
				    					<td>Amana Bank</td>
				    					<td><input type="text" name="mudarabaagreementAmanaBankRatio1"/> %</td>
				    					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    					<td>Amana Bank</td>
				    					<td><input type="text" name="mudarabaagreementAmanaBankRatio2"/> %</td>
				    				</tr>
				    				<tr>
				    					<td>Customer</td>
				    					<td><input type="text" name="mudarabaagreementCustomerRatio1"/> %</td>
				    					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    					<td>Customer</td>
				    					<td><input type="text" name="mudarabaagreementCustomerRatio2"/> %</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			INTRODUCTION (for Current Accounts Only)
				    		</div>
				    		<div class="sectionBody">
				    			I certify that I am well acquainted with the above person for the past <input type="text" name="introduction1"/> years and I confirm
				    			and further certify that the above person is suitable to open and maintain a current account with Amana Bank
				    			<table width="100%" class="table table-bordered">
				    				<tr>
				    					<td width="25%">Name</td>
				    					<td width="75%">
				    						<input type="text" name="introductionName" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>NIC/Passport/DL No</td>
				    					<td>
				    						<input type="text" name="introductionIDNo" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Address</td>
				    					<td>
				    						<input type="text" name="introductionAddress" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Account No at Amana Bank</td>
				    					<td>
				    						<input type="text" name="introductionAccountNo" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Designation</td>
				    					<td>
				    						<input type="text" name="introductionDesignation" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Tel No</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="15%">Res.</td>
				    								<td width="85%">
				    									<input type="text" name="introductionTelRes" class="form-control input-sm">
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Off.</td>
				    								<td>
				    									<input type="text" name="introductionTelOff" class="form-control input-sm">
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Mob.</td>
				    								<td>
				    									<input type="text" name="introductionTelMob" class="form-control input-sm">
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			OPERATING INSTRUCTIONS (For Savings and Current Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>Signature Requirement</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="signatureRequirement" id="signatureRequirement1" value="1">
				    								<label for="signatureRequirement1">Self</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="signatureRequirement" id="signatureRequirement2" value="2">
				    								<label for="signatureRequirement2">Anyone of us</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="signatureRequirement" id="signatureRequirement3" value="3">
				    								<label for="signatureRequirement3">Both of us</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="signatureRequirement" id="signatureRequirement4" value="4">
				    								<label for="signatureRequirement4">
				    									Other: <input type="text" name="signatureRequirement4"/>
				    								</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			SPECIAL DECLARATION
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="45%">Are you a Permanent Resident (Green card Holder) or a Dual Citizen of another country?</td>
				    					<td width="55%">
				    						<ul class="inlineUL">				    							
				    							<li>
				    								<input type="radio" name="specialDeclaration1" id="specialDeclaration12" value="2">
				    								<label for="specialDeclaration12">
				    									Yes. Specify Country/ies <input type="text" name="specialDeclaration12"/>
				    								</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="specialDeclaration1" id="specialDeclaration11" value="1">
				    								<label for="specialDeclaration11">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>DO you regularly travel, send or receive remittance to/from a foreign country/ies?</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="specialDeclaration2" id="specialDeclaration22" value="2">
				    								<label for="specialDeclaration22">Yes</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="specialDeclaration2" id="specialDeclaration21" value="1">
				    								<label for="specialDeclaration21">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Have you granted a Power of Attorney to a person from a foreign country?</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="specialDeclaration3" id="specialDeclaration32" value="2">
				    								<label for="specialDeclaration32">Yes</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="specialDeclaration3" id="specialDeclaration31" value="1">
				    								<label for="specialDeclaration31">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>If foreign citizen please specify the purpose of opening the account in Sri Lanka</td>
				    					<td>
				    						<input type="text" name="purposeOfOpeningAccountSL" class="form-control input-sm">
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category4">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			FOR BANK USE ONLY 
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bodered">
				    				<tr>
				    					<td width="25%">Name, Date of Birth and Nationality Verification By</td>
				    					<td width="75%">
				    						<table width="100%">
				    							<tr>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy1" value="1">
				    								<label for="nameDobNationalityVerificationBy1">National Identity card</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy2" value="2">
				    								<label for="nameDobNationalityVerificationBy2">Official Armed Forces Service card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy3" value="3">
				    								<label for="nameDobNationalityVerificationBy3">Passport / Visa</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy4" value="4">
				    								<label for="nameDobNationalityVerificationBy4">Official Driving License</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy5" value="5">
				    								<label for="nameDobNationalityVerificationBy5">Postal ID (for person under 18 years of age)</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy6" value="6">
				    								<label for="nameDobNationalityVerificationBy6">Marriage Certificate (for only Name Change purpose)</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="nameDobNationalityVerificationBy" id="nameDobNationalityVerificationBy7" value="7">
				    								<label for="nameDobNationalityVerificationBy7">
				    									Other: <input type="text" name="nameDobNationalityVerificationBy7">
				    								</label>
				    								</td>
				    								<td>&nbsp;</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Address Verification By
				    					</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy1" value="1">
				    								<label for="addressVerificationBy1">
				    									Utility Bill: <input type="text" name="addressVerificationBy1"/>
				    								</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy2" value="2">
				    								<label for="addressVerificationBy2">Statement of Other Bank</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy3" value="3">
				    								<label for="addressVerificationBy3">Tenancy Agreement</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy4" value="4">
				    								<label for="addressVerificationBy4">Employment Contract</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy5" value="5">
				    								<label for="addressVerificationBy5">National Identity card</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy6" value="6">
				    								<label for="addressVerificationBy6">Letter from a Public Authority</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy7" value="7">
				    								<label for="addressVerificationBy7">Income Tax Receipts / Assessment Notice</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="addressVerificationBy" id="addressVerificationBy8" value="8">
				    								<label for="addressVerificationBy8">
				    									Other: <input type="text" name="addressVerificationBy8">
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Documents to be obtained</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained1" value="1">
				    								<label for="documentsObtained1">Completed Account Opoening Mandate</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained2" value="2">
				    								<label for="documentsObtained2">Specimen Signature card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained3" value="3">
				    								<label for="documentsObtained3">Copy of NIC/PP/DL</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained4" value="4">
				    								<label for="documentsObtained4">Signed Mudaraba Agreement</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained5" value="5">
				    								<label for="documentsObtained5">Copy of Address Verification Document</label>
				    								</td>
				    								<td>
				    								<input type="radio" name="documentsObtained" id="documentsObtained6" value="6">
				    								<label for="documentsObtained6">
				    									Other: <input type="text" name="documentsObtained6">
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Account Canvassed by</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="25%">Employee Name</td>
				    								<td width="75%"><input type="text" name="accountCanvassedByEmpName" class="form-control input-sm"/></td>
				    							</tr>
				    							<tr>
				    								<td>Employee No</td>
				    								<td><input type="text" name="accountCanvassedByEmpNo" class="form-control input-sm"/></td>
				    							</tr>
				    							<tr>
				    								<td>Branch</td>
				    								<td><input type="text" name="accountCanvassedByBranch" class="form-control input-sm"/></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Does the client/s appear in any know suspected terrorist list or any other alert list</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="clientInBlackList" id="clientInBlackListY" value="Y">
				    								<label for="clientInBlackListY">Yes</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="clientInBlackList" id="clientInBlackListN" value="N">
				    								<label for="clientInBlackListN">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>For Term Investment Account Only</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="45%">Term Investment Certificate No</td>
				    								<td width="55%"><input type="text" name="termInvestmentCertNo" class="form-control input-sm"/> </td>
				    							</tr>
				    							<tr>
				    								<td>Certificate Issued On</td>
				    								<td><input type="text" name="termInvestmentCertIssueDate" class="form-control input-sm datepicker"/> </td>
				    							</tr>
				    							<tr>
				    								<td>Investment Txn No</td>
				    								<td><input type="text" name="termInvestmentTxnNo" class="form-control input-sm"/> </td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Priority</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="priority" id="priority1" value="1">
				    								<label for="priority1">Ordinary</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="priority" id="priority2" value="2">
				    								<label for="priority2">Prime</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="priority" id="priority3" value="3">
				    								<label for="priority3">VIP</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>CIF Type</td>
				    					<td>
				    						<input type="text" name="cifType" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Economic Sector</td>
				    					<td>
				    						<input type="text" name="economicSector" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Division</td>
				    					<td>
				    						<input type="text" name="division" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Department</td>
				    					<td>
				    						<input type="text" name="department" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Account Type</td>
				    					<td>
				    						<input type="text" name="accountType" class="form-control input-sm"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>For Branch Approval</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%">Account Opened On</td>
				    								<td width="70%">
				    									<input type="text" name="accountOpenedOn" class="form-control input-sm datdepicker"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Account Opened By</td>
				    								<td>
				    									<input type="text" name="accountOpenedBy" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="branchAuthorisedOfficer" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Audited By</td>
				    								<td>
				    									<input type="text" name="branchAuditedby" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>For Central Operation</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%">Received Date</td>
				    								<td width="70%">
				    									<input type="text" name="receivedDate" class="form-control input-sm datdepicker"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td colspan="2">
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="cpuCifCompleted" id="cpuCifCompleted" value="Y">
				    												<label for="cpuCifCompleted">CIF Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="cpuDocumentsChecked" id="cpuDocumentsChecked" value="Y">
				    												<label for="cpuDocumentsChecked">Documents Checked</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="cpuStandingOrdersSetup" id="cpuStandingOrdersSetup" value="Y">
				    												<label for="cpuStandingOrdersSetup">Standing Orders Setup</label>
				    											</td>
				    										</tr>
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="cpuMandatesCompleted" id="cpuMandatesCompleted" value="Y">
				    												<label for="cpuMandatesCompleted">Mandates Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="cpuSignatureScanned" id="cpuSignatureScanned" value="Y">
				    												<label for="cpuSignatureScanned">Signature Scanned</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="cpuStatementSetup" id="cpuStatementSetup" value="Y">
				    												<label for="cpuStatementSetup">Statement Setup</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Data Input By</td>
				    								<td>
				    									<input type="text" name="dataInputby" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="cpuAuthorisedOfficer1" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Authorised Officer</td>
				    								<td>
				    									<input type="text" name="cpuAuthorisedOfficer2" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>Audited By</td>
				    								<td>
				    									<input type="text" name="cpuAuditedby" class="form-control input-sm"/>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Save" class="btn btn-success"/>
				    		</div>
				    	</div>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="category5">
				    	<div class="section">
				    		<div class="sectionHeader">
				    			UPLOAD DOCUMENT
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr class="table table-bordered">
				    					<td>Document Name</td>
				    					<td><input type="text" class="form-control input-sm"/> </td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Choose file
				    					</td>
				    					<td>
				    						<input type="file" name="filename">
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		<div class="sectionFooter">
				    			<input type="submit" value="Upload" class="btn btn-success"/>
				    		</div>
				    	</div>
				    </div>
				  </div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</HTML>