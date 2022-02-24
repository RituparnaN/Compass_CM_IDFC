<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

    <table class="instruction">
    	<tr>
	    	<td width="40%"></td>
	    	<td width="5%"></td>
	    	<td width="40%"></td>
    	</tr>
    	<tr>
	    	<td colspan="3" style="text-align: center;">
	    		<div class="headerText">Suspicious Transaction Report</div>
				<div class="semiHeaderText">Transaction Based Reporting Format</div>
	    	</td>
    	</tr>
    	<tr class="normaltext">
    		<td valign="top">
    			<h4>GENERAL INSTRUCTIONS</h4>
    		The Prevention of Money Laundering (Amendment) Act 2009 has
			included 'Authorized Persons' and 'Payment System Operators' in the
			category of 'financial institutions'.<br>
			Authorized Person' under the PMLA means 'authorized person' as
			defined in clause (c) of section 2 of the Foreign Exchange Management
			Act, 1999 (FEMA).<br>
			'Payment System Operator' has been defined under the PMLA as a
			person who operates a payment system. 'Payment System' has been
			defined to mean a system that enables payment to be effected between
			a payer and a beneficiary involving clearing, payment or settlement
			service or all of them and includes the systems enabling credit card
			operations, debit card operations, smart card operations, money transfer
			operations or similar operations.	
    		The Prevention of Money Laundering Act
			and the Rules there under requires every reporting entity to furnish
			details of suspicious transactions whether or not made in cash.
			Suspicious transaction means a transaction including an attempted
			transaction, whether or not made in cash which, to a person acting in
			good faith - <br/>(a) gives rise to a reasonable ground of suspicion that
			it may involve the proceeds of an offence specified in the Schedule
			to the Act; regardless of the value involved; or <br/>(b) appears to be
			made in circumstances of unusual or unjustified complexity; or <br/>(c)
			appears to have no economic rationale or bonafide purpose; or <br/>(d)
			gives rise to a reasonable ground of suspicion that it may involve
			financing of the activities relating to terrorism. <br/>Such transaction
			should be reported to Director, Financial Intelligence Unit - India
			not later than seven working days on being satisfied that the
			transaction is suspicious. Every reporting entity branch must submit
			this form to Director, FIU-IND only through the principal officer
			designated under PMLA.
			
			<br/>
			<h4>HOW TO FILL</h4>
			1. Reporting Entity Details - Enter details of the reporting entity.<br/>
1.4 Mention the unique 10 digit id issued to the reporting entity by FIUIND.
Use XXXXXNNNNN if the id is not available.<br/><br/>
2. Batch Details - Enter Details of the batch.<br/>
2.1 Batch number is the unique number given to the STR by the
reporting entity.<br/>
The PDF format is meant for submission of one STR per form.
Therefore each Batch number and Batch id will correspond to only one
STR.<br/>
2.4 Mention the batch type. Permissible values are -<br/>
&nbsp;&nbsp;&nbsp;N - New Report<br/>
&nbsp;&nbsp;&nbsp;R - Replacement Report<br/>
&nbsp;&nbsp;&nbsp;D - Deletion Report<br/>

2.5 Batch id is given by FIU-IND on receipt of STR. Mention the batch
id of the original batch, if the current batch is a replacement or deletion
batch. If the batch is new and unrelated to any previous batch,
mention '0' here.<br/><br/>
3. Principal Officer Details - Enter details of principal officer.<br/>
3.2. Designation as given by the institution (not to be filled
as Principal Officer).<br/><br/>
4. List of transactions<br/>
Enter the list of transactions. Click on '+' button on the first row, to
navigate to the first annexure for transaction (TRN). Add additional
annexure for each transaction by clicking on '+' button adjacent to each
row.<br/><br/>
5. List of branches/locations related to transactions<br/>
Enter the list of branches/locations related to transactions. Click on '+'
button on the first row, to navigate to first annexure for branch details
(LPE). Add additional annexure for each related branch by clicking on '+'
button adjacent to each row.<br/><br/>
6. Details of suspicion
This section contains details of suspicion.<br/>
6.1 Mention the name of main person related to suspicion.<br>
</td>
<td width="5%">&nbsp;</td>
<td>
<br><br><br>
6.2 Mention the source of alert. Refer reporting format guide for further
details of enumeration.<br>
6.3 Mention the details of alert indicator for the suspicious transaction.
Refer reporting format guide for further details on alert indicator.<br>
6.5 Mention if a transaction was attempted or completed.<br>
6.6 Mention the priority rating assessed by the reporting entity.<br>
Permissible values are -<br>
&nbsp;&nbsp;&nbsp;P1 - Very High Priority&nbsp;&nbsp;&nbsp;P2 - High Priority
&nbsp;&nbsp;&nbsp;P3 - Normal Priority&nbsp;&nbsp;&nbsp;XX - Not Categorized.
6.7 Mention if all transactions are reported, or if reported transactions are
sample transactions and there are many more similar transactions.<br>
Permissible values are -<br>
&nbsp;&nbsp;&nbsp;C - Complete<br>
&nbsp;&nbsp;&nbsp;P - Partial
6.8 Mention if additional documents related to the suspicious transaction
would be separately submitted by reporting entity.<br>
7. Details of action taken.<br>
This section contains details of action taken by reporting entity on the
suspicious transaction.<br>

<h4>ANNEXURE ACC - TRANSACTION DETAILS</h4>
This annexure contains details of the transactions.<br>
5. Mention the transaction type. Permissible values are -<br>
&nbsp;&nbsp;&nbsp;P - Purchase<br>
&nbsp;&nbsp;&nbsp;R - Redemption<br>
6. Mention the instrument type. Refer reporting format guide for further
details of enumeration.<br>
15. Mention the risk rating of the transaction .Permissible values are -<br>
&nbsp;&nbsp;&nbsp;T1 - High Risk&nbsp;&nbsp;&nbsp;T2 - Medium Risk<br>
&nbsp;&nbsp;&nbsp;T3 - Low Risk&nbsp;&nbsp;&nbsp;XX - Not Categorized<br>
42. Mention the related institution flag. Permissible values are -<br>
&nbsp;&nbsp;&nbsp;D - Acquirer Institution<br>
&nbsp;&nbsp;&nbsp;E - Sender's Correspondent institution<br>
&nbsp;&nbsp;&nbsp;F - Receiver's correspondent institution<br>
&nbsp;&nbsp;&nbsp;Z - Others<br>
&nbsp;&nbsp;&nbsp;X - Not Categorized<br>
<h4>ANNEXURE BRC - BRANCH/INSTITUTION DETAILS</h4>
This annexure contains detail of the related branch.
1. Mention the reporting role of the institution. Permissible values are -<br>
&nbsp;&nbsp;&nbsp;A - Reporting entity itself<br>
&nbsp;&nbsp;&nbsp;B - Other than Reporting entity<br>
&nbsp;&nbsp;&nbsp;X -Not Categorized<br/>
<h4>HOW TO SUBMIT</h4>
Validation of form - After entering all details, use `Validate' to ensure that
all mandatory fields and correct data types are filled.<br/>

<h4>ELECTRONIC SUBMISSION</h4>
The reporting entity should use `Export XML' to create the report in XML
format. The XML report should be validated using the Report Validation
Utility. After validation, reporting entity should login to FINnet Gateway
portal and upload the XML report.<br/>
Note: Download the Report Validation Utility from the Downloads section
of the Resources module of the FINnet Gateway portal.<br/>
Use 'Non-editable PDF' to convert and save the report as a non-editable
PDF document.<br/>
<h4>PAPER BASED SUBMISSION</h4>
If the reporting entity faces difficulty in generating and uploading the XML
report, print the report using the `Print' option in the menu bar. Send the
paper-based report to the following address:<br/>
Address :
<div style="margin-left: 20%">
Director,<br/>
Financial Intelligence Unit - India<br/>
6th Floor, Hotel Samrat,<br/>
Chanakyapuri, New Delhi - 110021<br/>
India
</div> 
In urgent cases, the form should also be sent by fax.<br/>
Fax: +91-11-26874459
    		</td>
    	</tr>
    </table>