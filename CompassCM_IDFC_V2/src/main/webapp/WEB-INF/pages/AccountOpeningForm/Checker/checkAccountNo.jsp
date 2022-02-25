<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.aml.model.AOFDisabledFiledsMap"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	String caseNo = (String) request.getAttribute("CaseNo");
	String cifNo = (String) request.getAttribute("CIF");
	String accountNo = (String) request.getAttribute("AccountNo");
	
	
	Map<String, String> accountData = (Map<String, String>) request.getAttribute("accountData");
	Map<String, String> FORMSTATUS = (Map<String, String>) request.getAttribute("FORMSTATUS");
	List<Map<String, String>> jointHolder = (List<Map<String, String>>) request.getAttribute("JOINT_HOLDER");
%>
<style>
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	.fullWidthTable{
		width: 100%;
	}
	.red{
		color: #E77471;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$(".modalClose").click(function(){
			$('#valueAddedServiceModal').modal('hide');
		});
		
		$(".valueAddedService").click(function(){
			var cifNumber = $(this).attr("cCIF");
			var accountNo = $(this).attr("cAccountNo");
			var lineNo = $(this).attr("cLineNo");
			$('#valueAddedServiceModal').modal('show');
			$("#valueAddedService-title").html("...");
			$("#valueAddedServiceDetails").html("");
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/checkValueAddedService?AccountNo="+accountNo+"&CIF="+cifNumber+"&LineNo="+lineNo,
				cache : false,
				success : function(res){
					$("#valueAddedService-title").html("VALUE ADDED SERVICE : "+accountNo);
					$("#valueAddedServiceDetails").html(res);
				},
				error : function(){
					$('#valueAddedServiceModal').modal('hide');
					alert("error");
				}
			});
		});
		
		var rejectedFileds = parent.rejectedFileds;
		var rejectedFiledsArr = rejectedFileds.split(";");
		var arrayLength = rejectedFiledsArr.length;
		for (var i = 0; i < arrayLength; i++) {
			$('.rejectReason6[name="'+rejectedFiledsArr[i]+'"]').prop("checked", true);
			$('.rejectReason6[name="'+rejectedFiledsArr[i]+'"]').parent().removeClass("btn-success");
			$('.rejectReason6[name="'+rejectedFiledsArr[i]+'"]').parent().addClass("btn-danger");
		}
		
		$(".rejectReason6").click(function(){
			if($(this).prop("checked")){
				$(this).parent().removeClass("btn-success");
				$(this).parent().addClass("btn-danger");				
				parent.addReject($(this).attr("name"), $(this).val());			
			}else{
				$(this).parent().removeClass("btn-danger");
				$(this).parent().addClass("btn-success");
				parent.removeReject($(this).attr("name"), $(this).val());
			}
			
			var count = 0;
			$(".rejectReason6").each(function(elm){
				if($(this).prop("checked"))
					count = count + 1;
			});
			parent.updateRejectFlag(count, '<%=accountNo%>');
		})
	});
</script>
<div class="modal fade bs-example-modal-sm" id="valueAddedServiceModal" tabindex="1000" role="dialog" aria-labelledby="mySmallModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close modalClose" data-dismiss="bs-example-modal-sm" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="valueAddedService-title">...</h4>
      </div>
	  <div class="modal-body" id="valueAddedServiceDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
<div class="section">
				    	<div class="sectionHeader">
				    		Account Information
				    	</div>
				    	<div class="sectionBody">
				    		<table width="100%">
					    		<tr>
					    			<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE_CODE")) {%> class="red" <%}%>>Account Type</td>
					    			<td>
					    				<% if("C".equals(accountData.get("ACCOUNT_TYPE_CODE"))){ %>
					    					Current
					    				<%}if("S".equals(accountData.get("ACCOUNT_TYPE_CODE"))){ %>
					    					Savings
					    				<%}if("TI".equals(accountData.get("ACCOUNT_TYPE_CODE"))){ %>
					    					Term Investment
					    				<%}if("OT".equals(accountData.get("ACCOUNT_TYPE_CODE"))){ %>
					    					Other: <%= accountData.get("PRODUCT_NAME") != null ? accountData.get("PRODUCT_NAME") : "" %>
					    				<%} %>
					    			</td>
					    		</tr>
					    		<tr>
						   			<td <%if (AOFDisabledFiledsMap.isFieldDisabled("GL_CODE")) {%> class="red" <%}%>>GL CODE</td>
						   			<td>
						   				 <%=accountData.get("GL_CODE") != null ? accountData.get("GL_CODE") : ""%>
						   			</td>
						   		</tr>
						   		<tr>
						   			<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_CURRENCY")) {%> class="red" <%}%>>Account Currency Code &amp; Name: </td>
						   			<td>
						   				<%= accountData.get("ACCOUNT_CURRENCY") != null ? accountData.get("ACCOUNT_CURRENCY") : ""%> (
						   				<%= accountData.get("CURRENCY_NAME") != null ? accountData.get("CURRENCY_NAME") : ""%>
						   				)
						   			</td>
						   		</tr>
						   		<tr>
						   			<td <%if (AOFDisabledFiledsMap.isFieldDisabled("SPECIAL_ACC_TYPE")) {%> class="red" <%}%>>Spacial Account: </td>
						   			<td>
						   				<% if("OT".equals(accountData.get("SPECIAL_ACC_TYPE"))){ %>
						   					Other: <%=accountData.get("PRODUCT_NAME") != null ? accountData.get("PRODUCT_NAME") : "" %>
						   				<%}else{ %>
						   					<%=accountData.get("SPECIAL_ACC_TYPE") != null ? accountData.get("SPECIAL_ACC_TYPE") : "" %>
						   				<%}%>
						   			</td>
						   		</tr>
				    		</table>
				    	</div>
				    </div>
				    <div class="section">
				    	<div class="sectionHeader">
					    	<div class="sectionRight">				    			
					    		<label for="section61<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
					    			<input type="checkbox" class="rejectReason6" name="reject_section61<%=accountNo%>" id="section61<%=accountNo%>" value="Account (<%=accountNo%>) : Other Information"/>
					    		</label>
				    		</div>
				    		OTHER INFORMATION
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("PORPOSE_OF_ACCOUNT")) {%> class="red" <%}%>>
				    					Purpose of Opening Account
				    				</td>
				    				<td width="75%">
				    					<% if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SA"))){ %>
				    						Savings, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_BT"))){ %>
				    						Business Transaction, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_LR"))){ %>
				    						Loan Re-payment, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SCW"))){ %>
				    						Social Charity Work, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_SPI"))){ %>
				    						Salary Professional Income, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_FIR"))){ %>
				    						Family Inward Remittance, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_IP"))){ %>
				    						Investment Purpose, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_ST"))){ %>
				    						Share Transactions, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_UBP"))){ %>
				    						Utility Bill Payment, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_UF"))){ %>
				    						Upkeep of Family/Person, 
				    					<%}if("Y".equals(accountData.get("PORPOSE_OF_ACCOUNT_OT"))){ %>
				    						Other: <%= accountData.get("PORPOSE_OF_ACCOUNT_OTR") != null ? accountData.get("PORPOSE_OF_ACCOUNT_OTR") : ""%>
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("SOURCE_OF_FUND")) {%> class="red" <%}%>>
				    					Source of Funds
				    				</td>
				    				<td>
				    					<% if("Y".equals(accountData.get("SOURCE_OF_FUND_S"))){ %>
				    						Salary, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_B"))){ %>
				    						Business, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_FR"))){ %>
				    						Family Remittances, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_EP"))){ %>
				    						Export Proceeds, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_IP"))){ %>
				    						Investments Proceeds, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_D"))){ %>
				    						Donations / Charities, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_CI"))){ %>
				    						Commission Income, 
				    					<% }if("Y".equals(accountData.get("SOURCE_OF_FUND_OT"))){ %>
				    						Others : <%=accountData.get("SOURCE_OF_FUND_OTR") != null ? accountData.get("SOURCE_OF_FUND_OTR") : ""%>
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_DEPOSITE")) {%> class="red" <%}%>>
				    					Anticipated Deposits to the Account
				    				</td>
				    				<td>
				    					<% if("1".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						Less than 100,000
				    					<%} if("2".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						100,000 - 500,000
				    					<%} if("3".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						500,000 - 1,000,000
				    					<%} if("4".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						1,000,000 - 2,000,000
				    					<%} if("5".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						2,000,000 - 3,000,000
				    					<%} if("6".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						3,000,000 - 4,000,000
				    					<%} if("7".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						4,000,000 - 5,000,000
				    					<%} if("8".equals(accountData.get("ACCOUNT_DEPOSITE"))){ %>
				    						5,000,000 and above
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INITIAL_DEPOSITE")) {%> class="red" <%}%>>
				    					Initial Deposit Amount
				    				</td>
				    				<td>
				    					<%= accountData.get("INITIAL_DEPOSITE") != null ? accountData.get("INITIAL_DEPOSITE") : ""%>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")) {%> class="red" <%}%>>
				    					Minor's Gurdian Income Details (Rs.)
				    				</td>
				    				<td>
									<% if("1".equals(accountData.get("INCOME_DET"))){ %>
										Less than 14,999
									<%} if("2".equals(accountData.get("INCOME_DET"))){ %>
										15,000 - 24,999
									<%} if("3".equals(accountData.get("INCOME_DET"))){ %>
										25,000 - 39,999
									<%} if("4".equals(accountData.get("INCOME_DET"))){ %>
										40,000 - 59,999
									<% } if("5".equals(accountData.get("INCOME_DET"))){ %>
										60,000 - 79,999
									<%} if("6".equals(accountData.get("INCOME_DET"))){ %>
										80,000 - 99,999
									<%} if("7".equals(accountData.get("INCOME_DET"))){ %>
										100,000 and above
									<%} %>
				    					
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    </div>
				     <div class="section">
				    	<div class="sectionHeader">
				    		<div class="sectionRight">				    			
				    			<label for="section62<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
				    				<input type="checkbox" class="rejectReason6" name="reject_section62<%=accountNo%>" id="section62<%=accountNo%>" value="Account (<%=accountNo%>) : Mudaraba Agreement"/>
				    			</label>
				    		</div>
				    		Mudaraba Agreement (For all Savings and Term Investment Accounts only)
				    	</div>
				    	<div class="sectionBody">
				    		This Mudaraba Agreement is made and entered into on this <strong><%= accountData.get("MUDARABA_AAGGR_DATE") != null ? accountData.get("MUDARABA_AAGGR_DATE") : "__________"%></strong>
				    		at <strong><%= accountData.get("MUDARABA_AGGR_PLCE") != null ? accountData.get("MUDARABA_AGGR_PLCE") : "__________"%></strong> by and between 
				    		<strong><%= accountData.get("MUDARABA_AGGR_1") != null ? accountData.get("MUDARABA_AGGR_1") : "__________"%></strong> of <strong><%= accountData.get("MUDARABA_AGGR_2") != null ? accountData.get("MUDARABA_AGGR_2") : "__________"%> </strong>
				    		herein referred to as the Investor/s (which expression where the context shall so admit, mean ans include the said 
				    		<strong><%= accountData.get("MUDARABA_AGGR_3") != null ? accountData.get("MUDARABA_AGGR_3") : "__________"%></strong> his/her/their heirs
				    		 executors administrators successors in interest and assign) of the ONE PART and Amana Bank PLC (hereinafter sometimes referred to as
				    		  the "Mudarib" or the Bank) a company duly incorporated under the Companies Act No. 7 of 2007 and a Licensed Commercial Bank having 
				    		  its registered office at No. 480, Galle Road, Colombo 03, Sri Lanka (Which expression where the context shall so admit mean and include 
				    		  Amana Bank Limited its successors in interest and assigns) of the OTHER PART.
				    		<br/>
				    		AND WHEREAS the Investor/s is/are desirous of opening a savings account/term investment account with the Bank for the purpose pf investing from time to time
				    		in the Mudaraba Fund of the Bank to invest in the Bank's business activities that are expected to generate profits.
				    		<br/>
				    		AND WHEREAS the Bank is willing to accept such funds for investment in the Bank's business activities that are excepted to generate profits and share such
				    		profits on the following Terms and Condition
				    		<br/><br/>
				    		<table width="100%">
				    			<tr>
				    				<td colspan="5">Profit Sharing Ratio</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_1")) {%> class="red" <%}%>>Account Type</td>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td>
				    							<% if("SA".equals(accountData.get("PSR_ACC_TYPE_1"))){ %>
				    								Savings Account
				    							<%}if("CA".equals(accountData.get("PSR_ACC_TYPE_1"))){ %>
				    								Current Account
				    							<%}if("TD".equals(accountData.get("PSR_ACC_TYPE_1"))){ %>
				    								Term Deposite
				    							<%}if("OT".equals(accountData.get("PSR_ACC_TYPE_1"))){ %>
				    								Other: <%= accountData.get("PSR_ACC_TYPE_1_OTR") != null ? accountData.get("PSR_ACC_TYPE_1_OTR") : "" %>
				    							<%} %>
				    							</td>
				    						</tr>
				    					</table>
				    				</td>
				    				<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<!--
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_ACC_TYPE_2")) {%> class="red" <%}%>>Account Type</td>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td>
				    							<% if("SA".equals(accountData.get("PSR_ACC_TYPE_2"))){ %>
				    								Savings Account
				    							<%}if("CA".equals(accountData.get("PSR_ACC_TYPE_2"))){ %>
				    								Current Account
				    							<%}if("TD".equals(accountData.get("PSR_ACC_TYPE_2"))){ %>
				    								Term Deposite
				    							<%}if("OT".equals(accountData.get("PSR_ACC_TYPE_2"))){ %>
				    								Other: <%= accountData.get("PSR_ACC_TYPE_2_OTR") != null ? accountData.get("PSR_ACC_TYPE_2_OTR") : "" %>
				    							<%} %>
				    							</td>
				    						</tr>
				    					</table>
				    				</td>
									-->
				    			</tr>
				    			<tr>
				    				<td  <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_1")) {%> class="red" <%}%>>Amana Bank</td>
				    				<td><%=accountData.get("PSR_BANK_1") != null ? accountData.get("PSR_BANK_1") : "__" %>%</td>
				    				<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<!--
				    				<td  <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_BANK_2")) {%> class="red" <%}%>>Amana Bank</td>
				    				<td><%=accountData.get("PSR_BANK_2") != null ? accountData.get("PSR_BANK_2") : "__" %>%</td>
									-->
				    			</tr>
				    			<tr>
				    				<td  <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_1")) {%> class="red" <%}%>>Customer</td>
				    				<td><%=accountData.get("PSR_CUSTOMER_1") != null ? accountData.get("PSR_CUSTOMER_1") : "__" %>%</td>
				    				<td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<!--
				    				<td  <%if (AOFDisabledFiledsMap.isFieldDisabled("PSR_CUSTOMER_2")) {%> class="red" <%}%>>Customer</td>
				    				<td><%=accountData.get("PSR_CUSTOMER_2") != null ? accountData.get("PSR_CUSTOMER_2") : "__" %>%</td>
									-->
				    			</tr>
				    		</table>
				    	</div>
				    </div>
				    <div class="section">
				    	<div class="sectionHeader">
					    	<div class="sectionRight">				    			
					    		<label for="section63<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
					    			<input type="checkbox" class="rejectReason6" name="reject_section63<%=accountNo%>" id="section63<%=accountNo%>" value="Account (<%=accountNo%>) : Term Investment"/>
					    		</label>
				    		</div>
				    		FOR TERM INVESTMENT ACCOUNTS ONLY
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("INVST_PERIOD_YEAR")) {%> class="red" <%}%>>
				    					Investment Period
				    				</td>
				    				<td width="75%">
				    					<%= accountData.get("INVST_PERIOD_YEAR") != null ? accountData.get("INVST_PERIOD_YEAR") : "___"%> Year  
				    					<%= accountData.get("INVST_PERIOD_MONTH") != null ? accountData.get("INVST_PERIOD_MONTH") : "___"%> Months
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%">
				    					Investment Amount Details
				    				</td>
				    				<td width="75%">
				    				  	<span <%if (AOFDisabledFiledsMap.isFieldDisabled("INVST_AMOUNT")) {%> class="red" <%}%>>
				    				  	Amount : <%= accountData.get("INVST_AMOUNT") != null ? accountData.get("INVST_AMOUNT") : "______"%><br/>
				    				  	</span>
				    					<span <%if (AOFDisabledFiledsMap.isFieldDisabled("DEPOSIT_MODE")) {%> class="red" <%}%>>
				    					Mode of Deposit: 
				    					<% if("CSH".equals(accountData.get("DEPOSIT_MODE"))){ %>
				    						Cash
				    					<%}if("CHQ".equals(accountData.get("DEPOSIT_MODE"))){ %>
				    						Cheque, No: <%= accountData.get("DEPOSIT_CHQ_NO") != null ? accountData.get("DEPOSIT_CHQ_NO") : ""%>
				    					<%} %>
				    					</span>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_METHOD")) {%> class="red" <%}%>>
				    					Profit Payment
				    				</td>
				    					<td width="75%">
				    					<% if("1".equals(accountData.get("PROFIT_PAYMENT_METHOD"))){ %>
				    						Paid at Maturity
				    					<%} if("2".equals(accountData.get("PROFIT_PAYMENT_METHOD"))){%>
				    						Paid at Monthly
				    					<%} %>	    						
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%" >
				    					Please credit/remit profilts at maturity/monthly to
				    				</td>
				    				<td width="75%">
				    					<table width="100%">
				    						<tr>
				    							<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NO")) {%> class="red" <%}%>>
				    								Account No
				    							</td>
				    							<td> <%= accountData.get("PROFIT_PAYMENT_ACC_NO") != null ? accountData.get("PROFIT_PAYMENT_ACC_NO") : ""%>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_ACC_NAME")) {%> class="red" <%}%>>
				    								Account Holder Name
				    							</td>
				    							<td> <%= accountData.get("PROFIT_PAYMENT_ACC_NAME") != null ? accountData.get("PROFIT_PAYMENT_ACC_NAME") : ""%>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BANK")) {%> class="red" <%}%>>
				    								Bank Name
				    							</td>
				    							<td> <%= accountData.get("PROFIT_PAYMENT_BANK") != null ? accountData.get("PROFIT_PAYMENT_BANK") : ""%>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <%if (AOFDisabledFiledsMap.isFieldDisabled("PROFIT_PAYMENT_BRANCH")) {%> class="red" <%}%>>
				    								Branch Name
				    							</td>
				    							<td><%= accountData.get("PROFIT_PAYMENT_BRANCH") != null ? accountData.get("PROFIT_PAYMENT_BRANCH") : ""%>
				    							</td>
				    						</tr>
				    					</table>		    						
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    </div>
				    <div class="section">
				    	<div class="sectionHeader">
					    	<div class="sectionRight">				    			
					    		<label for="section64<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
					    			<input type="checkbox" class="rejectReason6" name="reject_section64<%=accountNo%>" id="section64<%=accountNo%>" value="Account (<%=accountNo%>) : Correspondence"/>
					    		</label>
				    		</div>
				    		CORRESPONDENCE
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("CORRESPONDENCE_TYPE")) {%> class="red" <%}%>>
				    					Bank Correspondence
				    				</td>
				    				<td width="75%">
					    				<% 
					    					if(jointHolder.size() > 0) {
					    						for(int i = 0; i < jointHolder.size(); i++){
						    						String lineNo = jointHolder.get(i).get("LINE_NO");
													if(lineNo != null){
						    						String jointHolderName = jointHolder.get(i).get("FULLNAME");
						    						if(lineNo.equals(accountData.get("CORRESPONDENCE_TYPE"))){
						    			%>
						    				<%=jointHolderName%>
						    			<% } }}}%>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_TYPE")) {%> class="red" <%}%>>
				    					For Savings Account
				    				</td>
				    				<td width="75%">
				    					<% if("1".equals(accountData.get("SAVINGS_ACC_STMNT_TYPE"))){ %>
				    						Passbook
				    					<%} if("2".equals(accountData.get("SAVINGS_ACC_STMNT_TYPE"))){  %>
				    						Account Statement
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("CURRENT_ACC_STMNT_FREQ")) {%> class="red" <%}%>>
				    					Statement Frequencys (For Current Account)
				    				</td>
				    				<td width="75%">
				    					<% if("1".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))){ %>
				    						Monthly
				    					<%}if("2".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))){ %>
				    						Quarterly
				    					<%}if("3".equals(accountData.get("CURRENT_ACC_STMNT_FREQ"))){ %>
				    						Other : <%= accountData.get("CURRENT_ACC_STMNT_FREQ_OTR") != null ? accountData.get("CURRENT_ACC_STMNT_FREQ_OTR") : ""%>
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td <%if (AOFDisabledFiledsMap.isFieldDisabled("SAVINGS_ACC_STMNT_FREQ")) {%> class="red" <%}%>>
				    					Statement Frequencys (For Savings Account)
				    				</td>
				    				<td>
				    					<% if("1".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))){ %>
				    						Monthly
				    					<%}if("2".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))){ %>
				    						Quarterly
				    					<%}if("3".equals(accountData.get("SAVINGS_ACC_STMNT_FREQ"))){ %>
				    						Other : <%= accountData.get("SAVINGS_ACC_STMNT_FREQ_OTR") != null ? accountData.get("SAVINGS_ACC_STMNT_FREQ_OTR") : ""%>
				    					<%} %>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("STMNT_DISPTCH_MODE")) {%> class="red" <%}%>>
				    					Mode of Dispatch
				    				</td>
				    				<td width="75%">
				    					<% if("1".equals(accountData.get("STMNT_DISPTCH_MODE"))){ %>
				    						by Post
				    					<%}if("2".equals(accountData.get("STMNT_DISPTCH_MODE"))){ %>
				    						Collect at Branch
				    					<%}if("3".equals(accountData.get("STMNT_DISPTCH_MODE"))){ %>
				    						by Email. Email Address: <%= accountData.get("STMNT_DISPTCH_EMAIL") != null ? accountData.get("STMNT_DISPTCH_EMAIL") : ""%>
				    					<%} %>
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    	<div class="section">
					    		<div class="sectionHeader">
						    		<div class="sectionRight">				    			
						    		<label for="section65<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason6" name="reject_section65<%=accountNo%>" id="section65<%=accountNo%>" value="Account (<%=accountNo%>) : Cheque Book"/>
						    		</label>
					    		</div>
				    			CHEQUE BOOK REQUISITION (for Current Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("CHEQUE_BOOK_PAGE")) {%> class="red" <%}%>>
				    						Please issue me / us a Cheque Book with
				    					</td>
				    					<td width="75%">
				    						<% if("1".equals(accountData.get("CHEQUE_BOOK_PAGE"))){ %>
				    							25 Leaves
				    						<% } if("2".equals(accountData.get("CHEQUE_BOOK_PAGE"))){ %>
				    							50 Leaves
				    						<% } if("3".equals(accountData.get("CHEQUE_BOOK_PAGE"))){ %>
				    							100 Leaves
				    						<%} %>		    						
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
				    			VALUE ADDED SERVICES
				    		</div>
				    		<div class="sectionBody">
				    			<table width="100%">
				    				<tr>
				    					<% if(jointHolder.size() > 0){
				    						for(int i = 0; i < jointHolder.size(); i++){
				    							String lineNo = jointHolder.get(i).get("LINE_NO");
				    							String jointHolderName = jointHolder.get(i).get("FULLNAME");
				    							%>
				    							<td>
				    								<div class="btn-group" style="margin: 2px;">
								    					<label title="Reason for Rejection" class="btn btn-sm btn-success" aria-haspopup="true" aria-expanded="false" for="section66<%=lineNo%><%=accountNo%>">
													    	<input class="rejectReason6" id="section66<%=lineNo%><%=accountNo%>" name="reject_section66<%=lineNo%><%=accountNo%>" value="Account (<%=accountNo %>): Value Added Service (<%=jointHolderName%>)" type="checkbox" style="line-height: 0px; padding: 0px; margin: 0px;"/>&nbsp;
													  	</label>
								    					<button type="button" class="btn btn-sm btn-primary valueAddedService" cSector="VAS" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="<%=lineNo%>"><%=jointHolderName%></button>
													</div>	
						    					</td>
				    							<%
				    							if(i % 3 == 0){
				    								%>
				    								</tr>
				    								<tr>
				    								<%
				    							}
				    						}
				    					}
				    					%>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
						    	<div class="sectionRight">				    			
						    		<label for="section67<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason6" name="reject_section67<%=accountNo%>" id="section67<%=accountNo%>" value="Account (<%=accountNo%>) : Introduction"/>
						    		</label>
					    		</div>
				    			INTRODUCTION (for Current Accounts Only)
				    		</div>
				    		<div class="sectionBody">
				    			I certify that I am well acquainted with the above person for the past <%= accountData.get("INTRODUCTOR_RELN_YEAR") != null ? accountData.get("INTRODUCTOR_RELN_YEAR") : "__" %> years and I confirm
				    			and further certify that the above person is suitable to open and maintain a current account with Amana Bank
				    			<table width="100%" class="table table-bordered">
				    				<tr>
				    					<td width="25%"  <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_NAME")) {%> class="red" <%}%>>Name</td>
				    					<td width="75%">
				    						<%= accountData.get("INTRODUCTOR_NAME") != null ? accountData.get("INTRODUCTOR_NAME") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ID_NO")) {%> class="red" <%}%>>NIC/Passport/DL No</td>
				    					<td>
				    						<%= accountData.get("INTRODUCTOR_ID_NO") != null ? accountData.get("INTRODUCTOR_ID_NO") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ADDR")) {%> class="red" <%}%>>Address</td>
				    					<td>
				    						<%= accountData.get("INTRODUCTOR_ADDR") != null ? accountData.get("INTRODUCTOR_ADDR") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_ACC_NO")) {%> class="red" <%}%>>Account No at Amana Bank</td>
				    					<td>
				    						<%= accountData.get("INTRODUCTOR_ACC_NO") != null ? accountData.get("INTRODUCTOR_ACC_NO") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_DESG")) {%> class="red" <%}%>>Designation</td>
				    					<td>
				    						<%= accountData.get("INTRODUCTOR_DESG") != null ? accountData.get("INTRODUCTOR_DESG") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Tel No</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="15%" <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_TEL_NO")) {%> class="red" <%}%>>Res.</td>
				    								<td width="85%">
				    									<%= accountData.get("INTRODUCTOR_TEL_NO") != null ? accountData.get("INTRODUCTOR_TEL_NO") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_OFF_NO")) {%> class="red" <%}%>>Off.</td>
				    								<td>
				    									<%= accountData.get("INTRODUCTOR_OFF_NO") != null ? accountData.get("INTRODUCTOR_OFF_NO") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("INTRODUCTOR_MOB_NO")) {%> class="red" <%}%>>Mob.</td>
				    								<td>
				    									<%= accountData.get("INTRODUCTOR_MOB_NO") != null ? accountData.get("INTRODUCTOR_MOB_NO") : "" %>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
						    	<div class="sectionRight">				    			
						    		<label for="section68<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason6" name="reject_section68<%=accountNo%>" id="section68<%=accountNo%>" value="Account (<%=accountNo%>) : Operating Instruction"/>
						    		</label>
					    		</div>
				    			OPERATING INSTRUCTIONS (For Savings and Current Accounts only)
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_SIGN_TYPE")) {%> class="red" <%}%>>Signature Requirement</td>
				    					<td>
				    						<% if("1".equals(accountData.get("ACC_SIGN_TYPE"))){ %>
				    							Self
				    						<% }if("2".equals(accountData.get("ACC_SIGN_TYPE"))){ %>
				    							Anyone of us
				    						<% }if("3".equals(accountData.get("ACC_SIGN_TYPE"))){ %>
				    							Both of us
				    						<% }if("4".equals(accountData.get("ACC_SIGN_TYPE"))){ %>
				    							Other: <%= accountData.get("ACC_SIGN_TYPE_OTR") != null ? accountData.get("ACC_SIGN_TYPE_OTR") : "" %>
				    						<%} %>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
						    	<div class="sectionRight">				    			
						    		<label for="section69<%=accountNo%>" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason6" name="reject_section69<%=accountNo%>" id="section69<%=accountNo%>" value="Account (<%=accountNo%>) : Bank Use"/>
						    		</label>
					    		</div>
				    			BANK USE (Only Account Level)
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">				    				
				    				<tr>
				    					<td>For Term Investment Account Only</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="45%" <%if (AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_CERT_NO")) {%> class="red" <%}%>>Term Investment Certificate No</td>
				    								<td width="55%">
				    									<%= accountData.get("TERM_INVST_CERT_NO") != null ? accountData.get("TERM_INVST_CERT_NO") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_CERT_ISS_DATE")) {%> class="red" <%}%>>Certificate Issued On</td>
				    								<td>
				    									<%= accountData.get("TERM_INVST_CERT_ISS_DATE") != null ? accountData.get("TERM_INVST_CERT_ISS_DATE") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("TERM_INVST_TAX_NO")) {%> class="red" <%}%>>Investment Txn No</td>
				    								<td>
				    									<%= accountData.get("TERM_INVST_TAX_NO") != null ? accountData.get("TERM_INVST_TAX_NO") : "" %>
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
				    								<td width="25%" <%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_EMP_NAME")) {%> class="red" <%}%>>Employee Name</td>
				    								<td width="75%">
				    									<%= accountData.get("ACC_CANVASSED_BY_EMP_NAME") != null ? accountData.get("ACC_CANVASSED_BY_EMP_NAME") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_EMP_NO")) {%> class="red" <%}%>>Employee No</td>
				    								<td>
				    									<%= accountData.get("ACC_CANVASSED_BY_EMP_NO") != null ? accountData.get("ACC_CANVASSED_BY_EMP_NO") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <%if (AOFDisabledFiledsMap.isFieldDisabled("ACC_CANVASSED_BY_BRANCH")) {%> class="red" <%}%>>Branch</td>
				    								<td>
				    									<%= accountData.get("ACC_CANVASSED_BY_BRANCH") != null ? accountData.get("ACC_CANVASSED_BY_BRANCH") : "" %>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>For Branch Approval</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> class="red" <%} %>>Account Opened On</td>
				    								<td width="70%">
				    									<%= accountData.get("BRNCH_APPROVL_ACC_OPND_DATE") != null ? accountData.get("BRNCH_APPROVL_ACC_OPND_DATE") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> class="red" <%} %>>Account Opened By</td>
				    								<td>
				    									<%= accountData.get("BRNCH_APPROVL_ACC_OPND_BY") != null ? accountData.get("BRNCH_APPROVL_ACC_OPND_BY") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<%= accountData.get("BRNCH_APPROVL_AUTH_OFF") != null ? accountData.get("BRNCH_APPROVL_AUTH_OFF") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> class="red" <%} %>>Audited By</td>
				    								<td>
				    									<%= accountData.get("BRNCH_APPROVL_AUDT_OFF") != null ? accountData.get("BRNCH_APPROVL_AUDT_OFF") : "" %>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    </div>