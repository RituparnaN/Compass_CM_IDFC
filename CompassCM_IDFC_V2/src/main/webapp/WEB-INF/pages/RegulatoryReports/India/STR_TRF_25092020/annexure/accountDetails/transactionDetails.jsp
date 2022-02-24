<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% try{
	HttpSession l_CHttpSession = request.getSession(true);
	//String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRAccountDetailsVO objAccountDetailsVO = (ISTRAccountDetailsVO)request.getAttribute("AnnexC_AcctDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnCNo");
	String strBankName 						 = "";
	String strBranchBSRcode 				 = "";
	String strAccountNo 					 = "";
	String[] strArrayTransacdetailsNo	 	 = null;
	String[] strArrayTransactionsDate 		 = null;
	String[] strArrayModeOfTransactions 	 = null;
	String[] strArrayTransactionsCreditDebit = null;
	String[] strArrayTransactionsAmount 	 = null;
	String[] strArrayTransactionsRemark 	 = null;
	String[] strArrayTransactionsDataType 	 = null; 
	
	int intCountOfTransactions = 5;
	int intNoOfRecords = 0;
	if(objAccountDetailsVO != null){
		strBankName      = (objAccountDetailsVO.getNameOfBank() == null) ? "" : objAccountDetailsVO.getNameOfBank();
		strBranchBSRcode = (objAccountDetailsVO.getBSRcode() == null) ? "" : objAccountDetailsVO.getBSRcode();
		strAccountNo 	 = (objAccountDetailsVO.getAccountNo() == null) ? "" : objAccountDetailsVO.getAccountNo();
		intCountOfTransactions         = objAccountDetailsVO.getNoOfTransactions();
		  
		intNoOfRecords = intCountOfTransactions;
		if(intCountOfTransactions < 10)
		  intCountOfTransactions = 10; 
			
		strArrayTransacdetailsNo = new String[intCountOfTransactions];
		strArrayTransactionsDate = new String[intCountOfTransactions];
		strArrayModeOfTransactions = new String[intCountOfTransactions];
		strArrayTransactionsCreditDebit = new String[intCountOfTransactions];
		strArrayTransactionsAmount = new String[intCountOfTransactions];
		strArrayTransactionsRemark = new String[intCountOfTransactions];
		strArrayTransactionsDataType = new String[intCountOfTransactions];
		
		if (intNoOfRecords > 0)
		{
		for(int i=0; i < objAccountDetailsVO.getTransacdetailsNo().length; i++)
		{
		  strArrayTransacdetailsNo[i]	 	 = objAccountDetailsVO.getTransacdetailsNo()[i];
		  strArrayTransactionsDate[i] 		 = objAccountDetailsVO.getTransacdetailsdate()[i];
		  strArrayModeOfTransactions[i] 	 = objAccountDetailsVO.getTransacdetailsmode()[i];
		  strArrayTransactionsCreditDebit[i] = objAccountDetailsVO.getTransacdetailsDebit()[i];
		  strArrayTransactionsAmount[i] 	 = objAccountDetailsVO.getTransacdetailsAmount()[i];
		  strArrayTransactionsRemark[i] 	 = objAccountDetailsVO.getTransacdetailsRemarks()[i];
		  strArrayTransactionsDataType[i]	 = objAccountDetailsVO.getTransacdetailsDataType()[i];
		}
		}
	}
	String strDisabledFlag =(String) request.getAttribute("disable");
%>

<div class="section">
	<div class="mainHeader">6. Transaction Details
	<div class="addButton">
		<input type="button" value="Add New Transaction" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewTransaction('<%=strAccountNo%>','<%=strBankName%>','<%=strBranchBSRcode%>')"/>
	</div>
	</div>
	<table class="info-table">
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="10%">Date Of Transaction</th>
			<th width="18%">Mode</th>
			<th width="15%">Debit / Credit</th>
			<th width="17%">Amount in Rupees</th>
			<th width="27%">Remarks</th>
			<th width="8%">&nbsp;</th>
		</tr>
		<%for(int i=0; i < intCountOfTransactions; i++){ 
	  	if(strArrayTransactionsDataType!=null && strArrayTransactionsDataType[i]!=null && strArrayTransactionsDataType[i].equalsIgnoreCase("M"))
       	{%>
		<tr>
			<th>6.<%=i+1%></th>
			<td>
				<input type="text" readonly name="dateOfTransaction" value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsDate[i] == null) ? "" : strArrayTransactionsDate[i]%>" />
			</td>
			<td>
				<select name="transactionMode" disabled>
					<option value="A" title="Cheque Clearing" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("A")) {%>selected<% } %>>A - Cheque Clearing</option>
					<option value="B" title="Internal Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("B")) {%>selected<% } %>>B - Internal Transaction</option>
					<option value="C" title="Cash" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("C")) {%>selected<% } %>>C - Cash</option>
					<option value="D" title="Demand Draft / Pay Order" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("D")) {%>selected<% } %>>D - Demand Draft / Pay Order</option>
					<option value="E" title="Electronic Fund Transfer" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("E")) {%>selected<% } %>>E - Electronic Fund Transfer</option>
					<option value="F" title="Exchange Based Transfer" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("F")) {%>selected<% } %>>F - Exchange Based Transfer</option>
					<option value="G" title="Securities Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("G")) {%>selected<% } %>>G - Securities Transaction</option>
					<option value="S" title="Switching Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("S")) {%>selected<% } %>>S - Switching Transaction</option>
					<option value="X" title="Not Categorised" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("X")) {%>selected<% } %>>X - Not Categorised</option>
					<option value="Z" title="Others" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("Z")) {%>selected<% } %>>Z - Others</option>
				</select>
			</td>
			<td>
				<select name="transactionMode" disabled>
					<option value="C" <% if(((i+1) <= intNoOfRecords) && strArrayTransactionsCreditDebit[i].equals("C")) {%>selected<% } %>>C - Credit</option>
					<option value="D" <% if(((i+1) <= intNoOfRecords) && strArrayTransactionsCreditDebit[i].equals("D")) {%>selected<% } %>>D - Debit</option>
				</select>
			</td>
			<td>
				<input type="text" readonly name="amountInRupees"  value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsAmount[i] == null) ? "" : strArrayTransactionsAmount[i]%>"/>
			</td>
			<td>
				<input type="text" readonly name="remarks"  value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsRemark[i] == null) ? "" : strArrayTransactionsRemark[i]%>"/>
			</td>
			<td class="leftAligned">
				<a href="#1" onclick="updateTransactionDetails('<%=strAccountNo%>','<%=strArrayTransacdetailsNo[i]%>')"><img alt="update details" title="Update Details" src="<%=contextPath%>/images/edit.png"/></a>
				<a href="#1" onclick="deleteTransactionDetails('<%=strAccountNo%>','<%=strArrayTransacdetailsNo[i]%>')"><img alt="delete details" title="Delete Details" src="<%=contextPath%>/images/delete.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
		    <th>6.<%=i+1%></th>
			<td>
				<input type="text" readonly name="dateOfTransaction" value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsDate[i] == null) ? "" : strArrayTransactionsDate[i] == null ? "":strArrayTransactionsDate[i]%>" />
			</td>
			<td>
				<select name="transactionMode" disabled>
					<option value="A" title="Cheque Clearing" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("A")) {%>selected<% } %>>A - Cheque Clearing</option>
					<option value="B" title="Internal Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("B")) {%>selected<% } %>>B - Internal Transaction</option>
					<option value="C" title="Cash" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("C")) {%>selected<% } %>>C - Cash</option>
					<option value="D" title="Demand Draft / Pay Order" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("D")) {%>selected<% } %>>D - Demand Draft / Pay Order</option>
					<option value="E" title="Electronic Fund Transfer" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("E")) {%>selected<% } %>>E - Electronic Fund Transfer</option>
					<option value="F" title="Exchange Based Transfer" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("F")) {%>selected<% } %>>F - Exchange Based Transfer</option>
					<option value="G" title="Securities Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("G")) {%>selected<% } %>>G - Securities Transaction</option>
					<option value="S" title="Switching Transaction" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("S")) {%>selected<% } %>>S - Switching Transaction</option>
					<option value="X" title="Not Categorised" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("X")) {%>selected<% } %>>X - Not Categorised</option>
					<option value="Z" title="Others" <% if(((i+1) <= intNoOfRecords) && strArrayModeOfTransactions[i].equals("Z")) {%>selected<% } %>>Z - Others</option>
				</select>
			</td>
			<td>
				<select name="transactionMode" disabled>
					<option value="C" <% if(((i+1) <= intNoOfRecords) && strArrayTransactionsCreditDebit[i].equals("C")) {%>selected<% } %>>C - Credit</option>
					<option value="D" <% if(((i+1) <= intNoOfRecords) && strArrayTransactionsCreditDebit[i].equals("D")) {%>selected<% } %>>D - Debit</option>
				</select>
			</td>
			<td>
				<input type="text" readonly name="amountInRupees"  value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsAmount[i] == null) ? "" : strArrayTransactionsAmount[i] == null ? "":strArrayTransactionsAmount[i]%>"/>
			</td>
			<td>
				<input type="text" readonly name="remarks"  value="<%=(((i+1) <= intNoOfRecords) && strArrayTransactionsRemark[i] == null) ? "" : strArrayTransactionsRemark[i] == null ? "":strArrayTransactionsRemark[i]%>"/>
			</td>
			<td>
				<!--<ul class="box rightAligned">
					<li>INP</li>
					<li class="last"><%=(i+1) <= intNoOfRecords ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>-->
			</td>
		</tr>
		<% } } %>
	</table>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
