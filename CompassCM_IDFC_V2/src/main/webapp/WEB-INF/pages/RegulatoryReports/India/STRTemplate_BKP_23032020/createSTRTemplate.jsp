<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	String action = request.getAttribute("ACTION") != null ? (String) request.getAttribute("ACTION") : "CREATE";
	Map<String, String> templateDetails = request.getAttribute("TEMPLATEDETAILS") != null ? (Map<String, String>) request.getAttribute("TEMPLATEDETAILS") : new HashMap<String, String>();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap.min.css"/>
		<title>STR Template</title>
	</head>
	<body>
		<div class="container-fluid" >
			<div class="row">
				<div class="col-xs-12">
					<div class="card card-info">
					  <div class="card-header">STR Template</div>
					  <form action='${pageContext.request.contextPath}/common/addUpdateSTRTemplate?${_csrf.parameterName}=${_csrf.token}' method="POST">
					  <input type="hidden" name="ACTION" value="<%=action%>"/>
					  <input type="hidden" name="TEMPLATEID" value="<%=templateDetails.get("TEMPLATEID") != null ? templateDetails.get("TEMPLATEID") : "" %>"/>
					  <table class="table table-bordered table-striped">
					  	<tr>
					  		<td width="30%">
					  			Template Name
					  		</td>
					  		<td width="70%">
					  			<input class="form-control input-sm" type="text" name="TEMPLATENAME" id="TEMPLATENAME" value="<%=templateDetails.get("TEMPLATENAME") != null ? templateDetails.get("TEMPLATENAME") : "" %>">
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Ground of Suspicion
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="10" cols="5" name="GROUNDOFSUSPICION" id="GROUNDOFSUSPICION"><%=templateDetails.get("GROUNDOFSUSPICION") != null ? templateDetails.get("GROUNDOFSUSPICION") : "" %></textarea>
					  		</td>
					  	</tr>
					  	<tr>
					  		<!--<td>
					  			Source of Alert
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="SOURCEOFALERT" id="SOURCEOFALERT">
									<option value="BA" <%= "BA".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >BA - Business Associates</option>
									<option value="CV" <%= "CV".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >CV - Customer Verification</option>
									<option value="EI" <%= "EI".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >EI - Employee Initiated</option>
									<option value="LQ" <%= "LQ".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >LQ - Law Enforcement Agency Query</option>
									<option value="MR" <%= "MR".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >MR - Media Report</option>
									<option value="PC" <%= "PC".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >PC - Public Complaint (Replace CC with PC)</option>
									<option value="RM" <%= "RM".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >RM - Risk Management System</option>
									<option value="TM" <%= "TM".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >TM - Transaction Monitoring</option>
									<option value="TY" <%= "TY".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >TY - Topology</option>
									<option value="WL" <%= "WL".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >WL - Watch List</option>
									<option value="XX" <%= "XX".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >XX - Non Categorized</option>
									<option value="XX" <%= "XX".equals(templateDetails.get("SOURCEOFALERT")) ? "selected=selected" : "" %> >ZZ - Others</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Alert Red Flag Indicator
					  		</td>
					  		<td>
					  			<input type="text" class="form-control input-sm" name="ALERTREDFLAGINDICATOR" id="ALERTREDFLAGINDICATOR" value="<%=templateDetails.get("ALERTREDFLAGINDICATOR") != null ? templateDetails.get("ALERTREDFLAGINDICATOR") : "" %>"/>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Reason for Filing STR
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="STRREASON" id="STRREASON">
									<option value="A" <%= "A".equals(templateDetails.get("STRREASON")) ? "selected=selected" : "" %> >Proceeds of Crime</option>
									<option value="B" <%= "B".equals(templateDetails.get("STRREASON")) ? "selected=selected" : "" %> >Unusual or Complex Transaction</option>
									<option value="C" <%= "C".equals(templateDetails.get("STRREASON")) ? "selected=selected" : "" %> >No Economic Rationale or Bonafide Purpose</option>
									<option value="D" <%= "D".equals(templateDetails.get("STRREASON")) ? "selected=selected" : "" %> >Financing Of Terrorism</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Attempted Transactions
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="ATTEMPTEDTRANSACTIONS" id="ATTEMPTEDTRANSACTIONS">
					  				<option value="">Select One</option>
									<option value="Y" <%= "Y".equals(templateDetails.get("ATTEMPTEDTRANSACTIONS")) ? "selected=selected" : "" %>>Y - Yes</option>
									<option value="N" <%= "N".equals(templateDetails.get("ATTEMPTEDTRANSACTIONS")) ? "selected=selected" : "" %>>N - No</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Priority Rating
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="PRIORITYRATING" id="PRIORITYRATING">
									<option value="P1" <%= "P1".equals(templateDetails.get("PRIORITYRATING")) ? "selected=selected" : "" %> >P1 - Very High Priority</option>
									<option value="P2" <%= "P2".equals(templateDetails.get("PRIORITYRATING")) ? "selected=selected" : "" %> >P2 - High Priority</option>
									<option value="P3" <%= "P3".equals(templateDetails.get("PRIORITYRATING")) ? "selected=selected" : "" %> >P3 - Normal Priority</option>
									<option value="XX" <%= "XX".equals(templateDetails.get("PRIORITYRATING")) ? "selected=selected" : "" %> >XX - Non Categorized</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Report Coverage
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="REPORTCOVERAGE" id="REPORTCOVERAGE">
					  				<option value="">Select One</option>
									<option value="C" <%= "C".equals(templateDetails.get("REPORTCOVERAGE")) ? "selected=selected" : "" %>>C - Complete</option>
									<option value="P" <%= "P".equals(templateDetails.get("REPORTCOVERAGE")) ? "selected=selected" : "" %>>P - Partial</option>
								</select>
					  		</td>
					  	</tr>
						<tr>
					  		<td>
					  			Additional Documents
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="ADDITIONALDOCUMENTS" id="ADDITIONALDOCUMENTS">
					  				<option value="">Select One</option>
									<option value="Y" <%= "Y".equals(templateDetails.get("ADDITIONALDOCUMENTS")) ? "selected=selected" : "" %>>Y - Yes</option>
									<option value="N" <%= "N".equals(templateDetails.get("ADDITIONALDOCUMENTS")) ? "selected=selected" : "" %>>N - No</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Details of Investigation
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="5" cols="5" name="INVESTIGATIONDETAILS" id="INVESTIGATIONDETAILS"><%=templateDetails.get("INVESTIGATIONDETAILS") != null ? templateDetails.get("INVESTIGATIONDETAILS") : "" %></textarea>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Law Enforcement Agency Informed?
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="LEAINFORMED" id="LEAINFORMED">
									<option value="R" <%= "R".equals(templateDetails.get("LEAINFORMED")) ? "selected=selected" : "" %> >Correspondence Received from LEA</option>
									<option value="S" <%= "S".equals(templateDetails.get("LEAINFORMED")) ? "selected=selected" : "" %> >Matter Referred to LEA</option>
									<option value="N" <%= "N".equals(templateDetails.get("LEAINFORMED")) ? "selected=selected" : "" %> >No Correspondence Sent or Received</option>
								</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td>
					  			Law Enforcement Agency Details
					  		</td>
					  		<td>
					  			<textarea class="form-control" rows="5" cols="5" name="LEADETAILS" id="LEADETAILS"><%=templateDetails.get("LEADETAILS") != null ? templateDetails.get("LEADETAILS") : "" %></textarea>
					  		</td>
					  	</tr>-->
					  	<tr>
					  		<td>
					  			STATUS
					  		</td>
					  		<td>
					  			<select class="form-control input-sm" name="STATUS" id="STATUS">
					  				<option value="E" <%="E".equals(templateDetails.get("STATUS")) ? "selected=selected" : ""%>>ENABLED</option>
					  				<option value="D" <%="D".equals(templateDetails.get("STATUS")) ? "selected=selected" : ""%>>DISABLED</option>
					  			</select>
					  		</td>
					  	</tr>
					  	<tr>
					  		<td colspan="2" style="text-align: center">
					  			<button type="submit" class="btn btn-success btn-sm"><%=action%></button>
					  			&nbsp;&nbsp;
					  			<button type="button" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
					  		</td>
					  	</tr>
					  </table>
					  </form>
					  </div>
				 </div>
				</div>
			</div>
		</body>
	</html>
	