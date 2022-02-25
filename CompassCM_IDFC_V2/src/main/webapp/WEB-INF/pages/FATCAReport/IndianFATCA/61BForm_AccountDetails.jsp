<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String caseNo = (String) request.getAttribute("CASENO");
String action = (String) request.getAttribute("ACTION");
String accountNo = (String) request.getAttribute("ACCOUNTNO");
Map<String, String> statement = (Map<String, String>) request.getAttribute("ACCOUNTDETAILS");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<div style="text-align: center;">
		<span style="font-size: 20px; font-weight: bold;"> PART B:
			REPORT DETAILS </span><br /> <span> (This information should be
			provided for each Account being reported) </span>
	</div>
	<form action="<%=contextPath%>/common/saveUpdateINDFATCAAccount?${_csrf.parameterName}=${_csrf.token}" method="POST">
	<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
	<input type="hidden" name="action" value="<%=action%>"/>
	<table class="table table-bordered">
		<tr class="table-header">
			<td width="10%">B.1</td>
			<td width="90%" colspan="2">ACCOUNT DETAILS (To be provided for
				each account being reported)</td>
		</tr>
		<tr>
			<td width="10%">B.1.1</td>
			<td width="30%">Report Serial Number</td>
			<td width="60%"><input type="text" class="form-control input-sm" name="REPORTSERIALNO"  value="<%= statement.get("REPORTSERIALNO") != null ? statement.get("REPORTSERIALNO") : "" %>"/>
			</td>
		</tr>
		<tr>
			<td>B.1.2</td>
			<td>Original Report Serial Number</td>
			<td><input type="text" class="form-control input-sm" name="ORIGINALREPORTSERIALNO"  value="<%= statement.get("ORIGINALREPORTSERIALNO") != null ? statement.get("ORIGINALREPORTSERIALNO") : "" %>"></td>
		</tr>
		<tr>
			<td>B.1.3</td>
			<td>Account Type</td>
			<td>
				<% 
					String accountType = statement.get("ACCOUNTTYPE");
					String accountType1 = "", accountType2 = "";
					if(accountType != null && accountType.length() == 2){
						accountType1 = String.valueOf(accountType.charAt(0));
						accountType2 = String.valueOf(accountType.charAt(1));
					}
				%>
				<input type="text" class="input-sm input-ovr" name="ACCOUNTTYPE1" value="<%=accountType1%>"/>
				<input type="text" class="input-sm input-ovr" name="ACCOUNTTYPE2" value="<%=accountType2%>" />
			</td>
		</tr>
		<tr>
			<td>B.1.4</td>
			<td>Account Number</td>
			<td><input type="text" class="form-control input-sm" name="ACCOUNTNUMBER"  value="<%= statement.get("ACCOUNTNUMBER") != null ? statement.get("ACCOUNTNUMBER") : "" %>" <% if(("UPDATE").equals(action)){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td>B.1.5</td>
			<td>Account Number Type</td>
			<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTNUMBERTYPE"  value="<%= statement.get("ACCOUNTNUMBERTYPE") != null ? statement.get("ACCOUNTNUMBERTYPE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.6</td>
			<td>Account Holder Name</td>
			<td><input type="text" class="form-control input-sm" name="ACCOUNTHOLDERNAME"  value="<%= statement.get("ACCOUNTHOLDERNAME") != null ? statement.get("ACCOUNTHOLDERNAME") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.7</td>
			<td>Account Status</td>
			<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTSTATUS"  value="<%= statement.get("ACCOUNTSTATUS") != null ? statement.get("ACCOUNTSTATUS") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.8</td>
			<td>Account Treatment</td>
			<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTTREATMENT"  value="<%= statement.get("ACCOUNTTREATMENT") != null ? statement.get("ACCOUNTTREATMENT") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.9</td>
			<td>Self- certification</td>
			<td><input type="text" class="input-sm input-ovr"  name="SELFCERTIFICATION"  value="<%= statement.get("SELFCERTIFICATION") != null ? statement.get("SELFCERTIFICATION") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.10</td>
			<td>Documentation Status</td>
			<td><input type="text" class="input-sm input-ovr"  name="DOCSTATUS"  value="<%= statement.get("DOCSTATUS") != null ? statement.get("DOCSTATUS") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.1.11</td>
			<td>Date of closure of account, if closed during the year</td>
			<td><input type="text" class="form-control input-sm" name="ACCOUNTCLOSEDDATE"  value="<%= statement.get("ACCOUNTCLOSEDDATE") != null ? statement.get("ACCOUNTCLOSEDDATE") : "" %>"/></td>
		</tr>
		<tr class="table-header">
			<td width="10%">B.2</td>
			<td width="90%" colspan="2">BRANCH DETAILS</td>
		</tr>
		<tr>
			<td>B.2.1</td>
			<td>Branch Number Type</td>
			<td><input type="text" class="input-sm input-ovr"  name="BRANCHNUMBERTYPE"  value="<%= statement.get("BRANCHNUMBERTYPE") != null ? statement.get("BRANCHNUMBERTYPE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.2</td>
			<td>Branch Reference Number</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHREFNO"  value="<%= statement.get("BRANCHREFNO") != null ? statement.get("BRANCHREFNO") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.3</td>
			<td>Branch Name</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHNAME"  value="<%= statement.get("BRANCHNAME") != null ? statement.get("BRANCHNAME") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.4</td>
			<td>Branch Address</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHADDR"  value="<%= statement.get("BRANCHADDR") != null ? statement.get("BRANCHADDR") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.5</td>
			<td>City Town</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHCITY"  value="<%= statement.get("BRANCHCITY") != null ? statement.get("BRANCHCITY") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.6</td>
			<td>Postal Code</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHPOSTALCODE"  value="<%= statement.get("BRANCHPOSTALCODE") != null ? statement.get("BRANCHPOSTALCODE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.7</td>
			<td>State Code</td>
			<td>
				<% 
					String branchStateCode = statement.get("BRANCHSTATECODE");
					String branchStateCode1 = "", branchStateCode2 = "";
					if(branchStateCode != null && branchStateCode.length() == 2){
						branchStateCode1 = String.valueOf(branchStateCode.charAt(0));
						branchStateCode2 = String.valueOf(branchStateCode.charAt(1));
					}
				%>
				<input type="text" class="input-sm input-ovr" name="BRANCHSTATECODE1"  value="<%=branchStateCode1%>"/> 
				<input type="text" class="input-sm input-ovr" name="BRANCHSTATECODE2"  value="<%=branchStateCode2%>"/>
			</td>
		</tr>
		<tr>
			<td>B.2.8</td>
			<td>Country Code</td>
			<td>
				<% 
					String branchCountryCode = statement.get("BRANCHCOUNTRYCODE");
					String branchCountryCode1 = "", branchCountryCode2 = "";
					if(branchCountryCode != null && branchCountryCode.length() == 2){
						branchCountryCode1 = String.valueOf(branchCountryCode.charAt(0));
						branchCountryCode2 = String.valueOf(branchCountryCode.charAt(1));
					}
				%>
				<input type="text" class="input-sm input-ovr" name="BRANCHCOUNTRYCODE1"  value="<%=branchCountryCode1%>"/>
				<input type="text" class="input-sm input-ovr" name="BRANCHCOUNTRYCODE2"  value="<%=branchCountryCode2%>"/>
			</td>
		</tr>
		<tr>
			<td>B.2.9</td>
			<td>Telephone</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHTELEPHONE"  value="<%= statement.get("BRANCHTELEPHONE") != null ? statement.get("BRANCHTELEPHONE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.10</td>
			<td>Mobile</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHMOBILE"  value="<%= statement.get("BRANCHMOBILE") != null ? statement.get("BRANCHMOBILE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.11</td>
			<td>Fax</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHFAX"  value="<%= statement.get("BRANCHFAX") != null ? statement.get("BRANCHFAX") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.2.12</td>
			<td>Email</td>
			<td><input type="text" class="form-control input-sm" name="BRANCHEMAIL"  value="<%= statement.get("BRANCHEMAIL") != null ? statement.get("BRANCHEMAIL") : "" %>"/></td>
		</tr>
		<tr class="table-header">
			<td width="10%">B.3</td>
			<td width="90%" colspan="2">ACCOUNT SUMMARY</td>
		</tr>
		<tr>
			<td>B.3.1</td>
			<td>Account balance or value at the end of reporting period</td>
			<td><input type="text" class="form-control input-sm" name="ACCOUNTBALANCE"  value="<%= statement.get("ACCOUNTBALANCE") != null ? statement.get("ACCOUNTBALANCE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.2</td>
			<td>Aggregate gross interest paid or credited</td>
			<td><input type="text" class="form-control input-sm" name="AGGRGROSSINSTPAID"  value="<%= statement.get("AGGRGROSSINSTPAID") != null ? statement.get("AGGRGROSSINSTPAID") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.3</td>
			<td>Aggregate gross dividend paid or credited</td>
			<td><input type="text" class="form-control input-sm" name="AGGRGROSSDVDNTPAID"  value="<%= statement.get("AGGRGROSSDVDNTPAID") != null ? statement.get("AGGRGROSSDVDNTPAID") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.4</td>
			<td>Gross proceeds from sale of property</td>
			<td><input type="text" class="form-control input-sm" name="GROSSPROCEEDFROMSALE"  value="<%= statement.get("GROSSPROCEEDFROMSALE") != null ? statement.get("GROSSPROCEEDFROMSALE") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.5</td>
			<td>Aggregate gross amount of all other income paid or credited</td>
			<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTALLOTHINCOME"  value="<%= statement.get("AGGRGROSSAMNTALLOTHINCOME") != null ? statement.get("AGGRGROSSAMNTALLOTHINCOME") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.6</td>
			<td>Aggregate gross amount credited</td>
			<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTCRDT"  value="<%= statement.get("AGGRGROSSAMNTCRDT") != null ? statement.get("AGGRGROSSAMNTCRDT") : "" %>"/></td>
		</tr>
		<tr>
			<td>B.3.7</td>
			<td>Aggregate gross amount debited</td>
			<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTDEBT"  value="<%= statement.get("AGGRGROSSAMNTDEBT") != null ? statement.get("AGGRGROSSAMNTDEBT") : "" %>"/></td>
		</tr>
		<tr>
			<td colspan="3" style="text-align: center;">
				<button type="submit" class="btn btn-success">Save</button>
				<button type="button" onclick="closeModal()" class="btn btn-danger">Close</button>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>