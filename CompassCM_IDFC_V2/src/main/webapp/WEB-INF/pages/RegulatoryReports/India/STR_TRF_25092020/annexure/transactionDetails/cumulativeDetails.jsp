<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRAccountDetailsVO objAccountDetailsVO = (ISTRAccountDetailsVO)request.getAttribute("AnnexC_AcctDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnCNo");
	String l_disable =(String) request.getAttribute("disable");
%>

<div class="section">
	<div class="mainHeader">5. Cumulative Details in the bank account in the financial year</div>
	<div class="normalTextField">
		<label>5.1 Total Credits</label>
		<input type="text" name="totalCredits" readonly value="<%=objAccountDetailsVO.getAccountTotalCredit()%>" />
	</div>
	<div class="normalTextField">
		<label>5.2 Total Debits</label>
		<input type="text" name="totalDebits" readonly value="<%=objAccountDetailsVO.getAccountTotalDebit()%>" />
	</div>

	<div class="normalTextField">
		<label>5.3 Total Cash Deposited</label>
		<input type="text" name="totalCashDeposited" readonly value="<%=objAccountDetailsVO.getAccountTotalCashCredit()%>" />
	</div>
	<div class="normalTextField">
		<label>5.4 Total Cash Withdrawn</label>
		<input type="text" name="totalCashWithdrawn" readonly value="<%=objAccountDetailsVO.getAccountTotalCashDebit()%>" />
	</div>
	<div class="normalTextField">
		<label>5.5 Risk Category</label>
		<select name="riskCategory" disabled>
			<option value="A1" <% if(objAccountDetailsVO.getAccountRiskCategory().equals("A1")) {%>selected<% } %>>A1 - High Risk Account</option>
			<option value="A2" <% if(objAccountDetailsVO.getAccountRiskCategory().equals("A2")) {%>selected<% } %>>A2 - Medium Risk Account</option>	
			<option value="A3" <% if(objAccountDetailsVO.getAccountRiskCategory().equals("A3")) {%>selected<% } %>>A3 - Low Risk Account</option>
			<option value="XX" <% if(objAccountDetailsVO.getAccountRiskCategory().equals("XX")) {%>selected<% } %>>XX - Not Categorised</option>
		</select>
	</div>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
