<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, java.util.ArrayList, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% 
	HttpSession l_CHttpSession = request.getSession(true);
	String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
	String disabled = "disabled";
	String readOnly = "readonly";
	if(canUpdated.equals("Y")){
		disabled = "";
		readOnly = "";
	}
	
	ISTRTRFManualDetailsVO objManualDetailsVO = (ISTRTRFManualDetailsVO)request.getAttribute("ManualFormDTO");
	ArrayList alertIndicatorsList = (ArrayList)request.getAttribute("AlertIndicatorsList");
	String strAlertIndicator = "";
	String strAlertIndicatorsValue = "";
	String strSuspiciousReason = "";
	String strOtherReason="";
	boolean boolOthers = false;
	String[] strSuspiciousGroundsArray = new String[30];
	String[] strAlertIndicatorsArray = new String[3];
	String strSuspicionDueTo = "";
	String strProceedsOfCrime = "";
	String strUnusualComplexTransaction = "";
	String strNoEcoRatBonPurpose = "";
	String strFinancialTerrorism = "";
	String strAttemptedTransactions = "";
	String strReportCoverage = "";
	String strAdditionalDocuments = "";
	String strMainPersonName = "";
	String strSourceOfAlert = "";
	String strPriorityRating = "";
	if(objManualDetailsVO!=null){
		strSuspiciousReason = (objManualDetailsVO.getSuspReason()==null)?"":objManualDetailsVO.getSuspReason();
		strOtherReason=(objManualDetailsVO.getSuspOtherReason()==null)?"":objManualDetailsVO.getSuspOtherReason();
		strSuspiciousGroundsArray = objManualDetailsVO.getSusGroundsP7();
		strAlertIndicatorsArray = objManualDetailsVO.getAlertIndicators();
		strSuspicionDueTo = objManualDetailsVO.getSuspicionDueTo();
		if(strSuspicionDueTo != null && strSuspicionDueTo.length() > 0){
			String[] strSuspicionDueToArr = strSuspicionDueTo.split(",");
			if(strSuspicionDueToArr.length > 0){
				strProceedsOfCrime = strSuspicionDueToArr[0];
				strUnusualComplexTransaction = strSuspicionDueToArr[1];
				strNoEcoRatBonPurpose = strSuspicionDueToArr[2];
				strFinancialTerrorism = strSuspicionDueToArr[3];
			}
		}
		strAttemptedTransactions = objManualDetailsVO.getAttemptedTransactions();
		strReportCoverage = objManualDetailsVO.getReportCoverage();
		strAdditionalDocuments = objManualDetailsVO.getAdditionalDocuments();
		strMainPersonName = objManualDetailsVO.getMainPersonName() == null ? "":objManualDetailsVO.getMainPersonName();
		strSourceOfAlert = objManualDetailsVO.getSourceOfAlert() == null ? "":objManualDetailsVO.getSourceOfAlert();
		strPriorityRating = objManualDetailsVO.getPriorityRating() == null ? "XX":objManualDetailsVO.getPriorityRating();
	}
%>


<div class="section">
	<div class="mainHeader">
	6. Suspicion Details
	</div>
	<div class="normalTextField">
		<label>6.1 Main Person Name</label>
		<input type="text" name="mainPersonName" <%=readOnly%> value="<%=strMainPersonName%>"/>
	</div>
	<div class="normalTextField">
		<label>6.2 Source of Alert</label>
		<select name="sourceOfAlert" tabindex="5" <%=disabled%> >
			<option value="BA" <% if(strSourceOfAlert.equals("BA")) {%>selected<% } %> >BA - Business Associates</option>
			<option value="CV" <% if(strSourceOfAlert.equals("CV")) {%>selected<% } %> >CV - Customer Verification</option>
			<option value="EI" <% if(strSourceOfAlert.equals("EI")) {%>selected<% } %> >EI - Employee Initiated</option>
			<option value="LQ" <% if(strSourceOfAlert.equals("LQ")) {%>selected<% } %> >LQ - Law Enforcement Agency Query</option>
			<option value="MR" <% if(strSourceOfAlert.equals("MR")) {%>selected<% } %> >MR - Media Report</option>
			<option value="PC" <% if(strSourceOfAlert.equals("PC")) {%>selected<% } %> >PC - Public Complaint (Replace CC with PC)</option>
			<option value="RM" <% if(strSourceOfAlert.equals("RM")) {%>selected<% } %> >RM - Risk Management System</option>
			<option value="TM" <% if(strSourceOfAlert.equals("TM")) {%>selected<% } %> >TM - Transaction Monitoring</option>
			<option value="TY" <% if(strSourceOfAlert.equals("TY")) {%>selected<% } %> >TY - Typology</option>
			<option value="WL" <% if(strSourceOfAlert.equals("WL")) {%>selected<% } %> >WL - Watch List</option>
			<option value="XX" <% if(strSourceOfAlert.equals("XX")) {%>selected<% } %> >XX - Non Categorised</option>
			<option value="ZZ" <% if(strSourceOfAlert.equals("ZZ")) {%>selected<% } %> >ZZ - Others</option>
		</select>
	</div>
	<div class="normalTextField">
		<label>6.3.1 Alert Indicator</label>
		<select name="alertIndicators0" tabindex="6" <%=disabled%> >
			<% for(int i = 0; i < alertIndicatorsList.size(); i++) { 
				strAlertIndicator = alertIndicatorsList.get(i).toString();
				strAlertIndicatorsValue = (strAlertIndicatorsArray[0] == null? "":strAlertIndicatorsArray[0]);
			%>
			<option value="<%= strAlertIndicator %>" <% if(strAlertIndicatorsValue.equals(strAlertIndicator)) {%>selected<% } %> ><%= strAlertIndicator %></option>
			<% } %>
		</select>
		<label>6.3.2 Alert Indicator</label>
		<select name="alertIndicators1" tabindex="6" <%=disabled%> >
		<% for(int i = 0; i < alertIndicatorsList.size(); i++) { 
			strAlertIndicator = alertIndicatorsList.get(i).toString();
			strAlertIndicatorsValue = (strAlertIndicatorsArray[1] == null? "":strAlertIndicatorsArray[1]);
		%>
		<option value="<%= strAlertIndicator %>" <% if(strAlertIndicatorsValue.equals(strAlertIndicator)) {%>selected<% } %> ><%= strAlertIndicator %></option>
		<% } %>
		</select>
		<label>6.3.3 Alert Indicator</label>
		<select name="alertIndicators2" tabindex="6" <%=disabled%> >
		<% for(int i = 0; i < alertIndicatorsList.size(); i++) { 
			strAlertIndicator = alertIndicatorsList.get(i).toString();
			strAlertIndicatorsValue = (strAlertIndicatorsArray[2] == null? "":strAlertIndicatorsArray[2]);
		%>
		<option value="<%= strAlertIndicator %>" <% if(strAlertIndicatorsValue.equals(strAlertIndicator)) {%>selected<% } %> ><%= strAlertIndicator %></option>
		<% } %>
		</select>
	</div>
	<!-- 
	<div class="normalTextField">
		<label>6.3 Alert Indicator(s)</label>
		<!--<input type="text" name="alertIndicators1"/>
		<input type="text" name="alertIndicators2"/>
		<input type="text" name="alertIndicators3"/>-->
		<!-- 	
		<textarea name="alertIndicators0" <%=readOnly%> style="height: 20px"><%=(strAlertIndicatorsArray[0] == null)? "":strAlertIndicatorsArray[0]%></textarea>
		<textarea name="alertIndicators1" <%=readOnly%> style="height: 20px"><%=(strAlertIndicatorsArray[1] == null)? "":strAlertIndicatorsArray[1]%></textarea>
		<textarea name="alertIndicators2" <%=readOnly%> style="height: 20px"><%=(strAlertIndicatorsArray[2] == null)? "":strAlertIndicatorsArray[2]%></textarea>
	</div>
	-->
	
	<div class="normalTextField">
		<label>6.4 Suspicion Due To</label>
		<div class="checkBoxDiv">
			<label for="proceedsOfCrime">Proceeds of Crime</label>
				<%-- <input id="proceedsOfCrime" type="checkbox" <%=disabled%> name="suspicionDueTo1" <%if(strSuspicionDueTo != null && strSuspicionDueTo.indexOf("A") != -1){%>checked<%}%> value="A" /> --%>
			<!-- <span> -->		
				<select name="proceedsOfCrime" id="proceedsOfCrime" style="width: 10%" <%=disabled%>>
					<option value="Y" <% if(strProceedsOfCrime.equals("Y")) {%>selected<% } %> >Y - Yes</option>
					<option value="N" <% if(strProceedsOfCrime.equals("N")) {%>selected<% } %> selected>N - No</option>
					<option value="X" <% if(strProceedsOfCrime.equals("X")) {%>selected<% } %> >X - Not Categorised</option>
				</select>
			<!-- </span> -->
			<!-- <span> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
				<label for="UnusualComplexTransaction">Complex Transaction</label>
				<%-- <input id="UnusualComplexTransaction" type="checkbox" <%=disabled%> name="suspicionDueTo2" <%if(strSuspicionDueTo != null && strSuspicionDueTo.indexOf("B") != -1){%>checked<%}%> value="B" /> --%>
				<select name="unusualComplexTransaction" id="unusualComplexTransaction" style="width: 10%" <%=disabled%>>
					<option value="Y" <% if(strUnusualComplexTransaction.equals("Y")) {%>selected<% } %> >Y - Yes</option>
					<option value="N" <% if(strUnusualComplexTransaction.equals("N")) {%>selected<% } %> selected>N - No</option>
					<option value="X" <% if(strUnusualComplexTransaction.equals("X")) {%>selected<% } %> >X - Not Categorised</option>
				</select>
			<!-- </span> -->
			<!-- <span> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="noEcoRatBonPurpose">No Economic Rationale</label>
				<%-- <input id="noEcoRatBonPurpose" type="checkbox" <%=disabled%> name="suspicionDueTo3" <%if(strSuspicionDueTo != null && strSuspicionDueTo.indexOf("C") != -1){%>checked<%}%> value="C" /> --%>
				<select name="noEcoRatBonPurpose" id="noEcoRatBonPurpose" style="width: 10%" <%=disabled%>>
					<option value="Y" <% if(strNoEcoRatBonPurpose.equals("Y")) {%>selected<% } %> >Y - Yes</option>
					<option value="N" <% if(strNoEcoRatBonPurpose.equals("N")) {%>selected<% } %> selected>N - No</option>
					<option value="X" <% if(strNoEcoRatBonPurpose.equals("X")) {%>selected<% } %> >X - Not Categorised</option>
				</select>
			<!-- </span> -->
			<!-- <span> -->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="financialTerrorism">Financing Of Terrorism</label>
				<%-- <input id="financialTerrorism" type="checkbox" <%=disabled%> name="suspicionDueTo4" <%if(strSuspicionDueTo != null && strSuspicionDueTo.indexOf("D") != -1){%>checked<%}%> value="D" /> --%>
				<select name="financialTerrorism" id="financialTerrorism" style="width: 10%" <%=disabled%>>
					<option value="Y" <% if(strFinancialTerrorism.equals("Y")) {%>selected<% } %> >Y - Yes</option>
					<option value="N" <% if(strFinancialTerrorism.equals("N")) {%>selected<% } %> selected>N - No</option>
					<option value="X" <% if(strFinancialTerrorism.equals("X")) {%>selected<% } %> >X - Not Categorised</option>
				</select>
			</span>
		</div>
	</div>
	
	<div class="normalTextField left">
		<label>6.5 Attempted Transactions</label>
		<div class="checkBoxDiv">
			<span>
				<label for="attemptedTransactionY">Yes</label>
				<input id="attemptedTransactionY" type="radio" <%=disabled%> name="attemptedTransactions1" <%if(strAttemptedTransactions != null && strAttemptedTransactions.indexOf("Y") != -1){%>checked<%}%> value="Y" />
			</span>
			<span>
				<label for="attemptedTransactionN">No</label>
				<input id="attemptedTransactionN" type="radio" <%=disabled%> name="attemptedTransactions1" <%if(strAttemptedTransactions == null || strAttemptedTransactions.indexOf("N") != -1){%>checked<%}%> value="N" />
			</span>
			<span>
				<label for="attemptedTransactionX">Not Categorised</label>
				<input id="attemptedTransactionX" type="radio" <%=disabled%> name="attemptedTransactions1" <%if(strAttemptedTransactions == null || strAttemptedTransactions.indexOf("X") != -1){%>checked<%}%> value="X" />
			</span>
		</div>
	</div>
	
	<div class="normalTextField right">
	<label>6.6 Priority Rating</label>
		<select name="priorityRating" tabindex="5" <%=disabled%>>
			<option value="P1" <% if(strPriorityRating.equals("P1")) {%>selected<% } %> >P1 - Very High Priority</option>
			<option value="P2" <% if(strPriorityRating.equals("P2")) {%>selected<% } %> >P2 - High Priority</option>
			<option value="P3" <% if(strPriorityRating.equals("P3")) {%>selected<% } %> >P3 - Normal Priority</option>
			<option value="XX" <% if(strPriorityRating.equals("XX")) {%>selected<% } %> >XX - Not Categorised</option>
		</select>
	</div>
	<br/><br/><br/><br/><br/>
	<div class="normalTextField left">
		<label>6.7 Report Coverage</label>
		<div class="checkBoxDiv">
			<span>
				<label for="complete">Complete</label>
				<input id="complete" type="radio" <%=disabled%> name="reportCoverage1"  <% if(strReportCoverage == null || strReportCoverage.indexOf("C") != -1){ %> checked <% } %>  value="C" />
			</span>
			<span>
				<label for="partial">Partial</label>
				<input id="partial" type="radio" <%=disabled%> name="reportCoverage1"  <% if(strReportCoverage != null && strReportCoverage.indexOf("P") != -1){ %> checked <% } %>  value="P" />
			</span>
			<span>
				<label for="notCategorised">Not Categorised</label>
				<input id="notCategorised" type="radio" <%=disabled%> name="reportCoverage1"  <% if(strReportCoverage != null && strReportCoverage.indexOf("X") != -1){ %> checked <% } %>  value="X" />
			</span>
		</div>
	</div>
	
	<div class="normalTextField right">
		<label>6.8 Additional Documents</label>
		<div class="checkBoxDiv">
			<span>
				<label for="additionalDocY">Yes</label>
				<input id="additionalDocY" type="radio" <%=disabled%> name="additionalDocuments1" <% if(strAdditionalDocuments != null && strAdditionalDocuments.indexOf("Y") != -1){ %> checked <% } %> value="Y" />
			</span>
			<span>
				<label for="additionalDocN">No</label>
				<input id="additionalDocN" type="radio" <%=disabled%> name="additionalDocuments1" <% if(strAdditionalDocuments == null || strAdditionalDocuments.indexOf("N") != -1){ %> checked <% } %> value="N" />
			</span>
			<span>
				<label for="additionalDocX">Not Categorised</label>
				<input id="additionalDocX" type="radio" <%=disabled%> name="additionalDocuments1" <% if(strAdditionalDocuments == null || strAdditionalDocuments.indexOf("X") != -1){ %> checked <% } %> value="X" />
			</span>
		</div>
	</div>
	<br/><br/><br/><br/><br/>
	<div class="normalTextField">
		<label>6.9 Grounds of Suspicion</label>
		<textarea id="Part7susGrounds0" onkeyup="countChar(this,'Part7susGrounds0')" name="Part7susGrounds0" <%=readOnly%> 
			style="height: 200px" maxlength="4000"><%=(strSuspiciousGroundsArray[0] == null)? "" :strSuspiciousGroundsArray[0]%></textarea>
		 <span id="charsGOS" style="margin-left: 4px;">4000 characters remaining out of 4000</span> 
	</div>
</div>