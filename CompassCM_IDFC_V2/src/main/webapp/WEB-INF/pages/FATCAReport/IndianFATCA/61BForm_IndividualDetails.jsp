<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String caseNo = (String) request.getAttribute("CASENO");
	String action = (String) request.getAttribute("ACTION");
	String accountNo = (String) request.getAttribute("ACCOUNTNO");
	String individualId = (String) request.getAttribute("TYPEID");
	Map<String, String> individualDetails = (Map<String, String>) request.getAttribute("TYPEDETAILS");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<div style="text-align: center;">
		<span style="font-size: 20px; font-weight: bold;"> PART B: REPORT DETAILS </span>
		<br /> 
		<span> (This information should be provided for each Account being reported) </span>
	</div>
	<form action="<%=contextPath%>/common/saveUpdateINDFATCAIndividual?${_csrf.parameterName}=${_csrf.token}" method="POST">
		<input type="hidden" name="caseNo" value="<%=caseNo%>" /> 
		<input type="hidden" name="action" value="<%=action%>" />
		<input type="hidden" name=accountNo value="<%=accountNo%>" />
		<input type="hidden" name="individualId" value="<%=individualId%>" />
		
		<table class="table table-bordered">
			<tr class="table-header">
				<td width="10%">B.4</td>
				<td width="90%" colspan="2">INDIVIDUAL DETAILS (To be provided for individual account holder )</td>
			</tr>
			<tr>
				<td>B.4.1</td>
				<td width="35%">Name</td>
				<td width="55%">
					<input type="text" class="form-control input-sm" name="NAME" value="<%= individualDetails.get("NAME") != null ? individualDetails.get("NAME") : "" %>">
				</td>
			</tr>
			<tr>
				<td>B.4.2</td>
				<td>Customer ID</td>
				<td><input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%= individualDetails.get("CUSTOMERID") != null ? individualDetails.get("CUSTOMERID") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.3</td>
				<td>Father's Name</td>
				<td><input type="text" class="form-control input-sm" name="FATHERNAME" value="<%= individualDetails.get("FATHERNAME") != null ? individualDetails.get("FATHERNAME") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.4</td>
				<td>Spouse's Name</td>
				<td><input type="text" class="form-control input-sm" name="SPOUSENAME" value="<%= individualDetails.get("SPOUSENAME") != null ? individualDetails.get("SPOUSENAME") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.5</td>
				<td>Gender</td>
				<td><input type="text" class="input-sm input-ovr"  name="GENDER" value="<%= individualDetails.get("GENDER") != null ? individualDetails.get("GENDER") : "" %>"/></td>
			</tr>
			<tr>
				<td>B.4.6</td>
				<td>PAN</td>
				<td>
					<% 
					String pan = individualDetails.get("PAN");
					String pan1 = "", pan2 = "", pan3 = "", pan4 = "", pan5 = "", pan6 = "", pan7 = "", pan8 = "", pan9 = "", pan10 = "";
					if(pan != null && pan.length() == 10){
						pan1 = String.valueOf(pan.charAt(0));
						pan2 = String.valueOf(pan.charAt(1));
						pan3 = String.valueOf(pan.charAt(2));
						pan4 = String.valueOf(pan.charAt(3));
						pan5 = String.valueOf(pan.charAt(4));
						pan6 = String.valueOf(pan.charAt(5));
						pan7 = String.valueOf(pan.charAt(6));
						pan8 = String.valueOf(pan.charAt(7));
						pan9 = String.valueOf(pan.charAt(8));
						pan10 = String.valueOf(pan.charAt(9));
					}
					%>
					<input type="text" class="input-sm input-ovr"  name="PAN1" value="<%=pan1%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN2" value="<%=pan2%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN3" value="<%=pan3%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN4" value="<%=pan4%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN5" value="<%=pan5%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN6" value="<%=pan6%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN7" value="<%=pan7%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN8" value="<%=pan8%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN9" value="<%=pan9%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN10" value="<%=pan10%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.7</td>
				<td>Aadhaar Number</td>
				<td><input type="text" class="form-control input-sm" name="ADHAARNO" value="<%= individualDetails.get("ADHAARNO") != null ? individualDetails.get("ADHAARNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.8</td>
				<td>Identification Type</td>
				<td><input type="text" class="input-sm input-ovr"  name="IDTYPE" value="<%= individualDetails.get("IDTYPE") != null ? individualDetails.get("IDTYPE") : "" %>"/></td>
			</tr>
			<tr>
				<td>B.4.9</td>
				<td>Identification Number</td>
				<td><input type="text" class="form-control input-sm" name="IDNO" value="<%= individualDetails.get("IDNO") != null ? individualDetails.get("IDNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.10</td>
				<td>Occupation Type</td>
				<td><input type="text" class="input-sm input-ovr" name="OCCUPATIONTYPE" value="<%= individualDetails.get("OCCUPATIONTYPE") != null ? individualDetails.get("OCCUPATIONTYPE") : "" %>" /></td>
			</tr>
			<tr>
				<td>B.4.11</td>
				<td>Occupation</td>
				<td><input type="text" class="form-control input-sm" name="OCCUPATION" value="<%= individualDetails.get("OCCUPATION") != null ? individualDetails.get("OCCUPATION") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.12</td>
				<td>Birth Date</td>
				<td><input type="text" class="form-control input-sm" name="DATEOFBIRTH" value="<%= individualDetails.get("DATEOFBIRTH") != null ? individualDetails.get("DATEOFBIRTH") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.13</td>
				<td>Nationality</td>
				<td>
					<% 
					String nationality = individualDetails.get("NATIONALITY");
					String nationality1 = "", nationality2 = "";
					if(nationality != null && nationality.length() == 2){
						nationality1 = String.valueOf(nationality.charAt(0));
						nationality2 = String.valueOf(nationality.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="NATIONALITY1" value="<%=nationality1%>"/> 
					<input type="text" class="input-sm input-ovr" name="NATIONALITY2" value="<%=nationality2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.14</td>
				<td>Country of Residence as per tax laws</td>
				<td>
					<% 
					String countryOfResidence = individualDetails.get("COUNTRYOFRESIDENCE");
					String countryOfResidence1 = "", countryOfResidence2 = "";
					if(countryOfResidence != null && countryOfResidence.length() == 2){
						countryOfResidence1 = String.valueOf(countryOfResidence.charAt(0));
						countryOfResidence2 = String.valueOf(countryOfResidence.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE1" value="<%=countryOfResidence1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE2" value="<%=countryOfResidence2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.15</td>
				<td>Place of Birth</td>
				<td><input type="text" class="form-control input-sm" name="PLACEOFBIRTH" value="<%= individualDetails.get("PLACEOFBIRTH") != null ? individualDetails.get("PLACEOFBIRTH") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.16</td>
				<td>Country of Birth</td>
				<td>
					<% 
					String countryOfBirth = individualDetails.get("COUNTRYOFBIRTH");
					String countryOfBirth1 = "", countryOfBirth2 = "";
					if(countryOfBirth != null && countryOfBirth.length() == 2){
						countryOfBirth1 = String.valueOf(countryOfBirth.charAt(0));
						countryOfBirth2 = String.valueOf(countryOfBirth.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH1" value="<%=countryOfBirth1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH2" value="<%=countryOfBirth2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.17</td>
				<td>Tax Identification Number (TIN) allotted by tax resident
					country</td>
				<td><input type="text" class="form-control input-sm" name="TIN" value="<%= individualDetails.get("TIN") != null ? individualDetails.get("TIN") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.18</td>
				<td>TIN Issuing Country</td>
				<td>
					<% 
					String tinIssuingCountry = individualDetails.get("TINISSUNINGCOUNTRY");
					String tinIssuingCountry1 = "", tinIssuingCountry2 = "";
					if(tinIssuingCountry != null && tinIssuingCountry.length() == 2){
						tinIssuingCountry1 = String.valueOf(tinIssuingCountry.charAt(0));
						tinIssuingCountry2 = String.valueOf(tinIssuingCountry.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY1" value="<%=tinIssuingCountry1%>"/> 
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY2" value="<%=tinIssuingCountry2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.19</td>
				<td>Address Type</td>
				<td>
					<% 
					String addrType = individualDetails.get("ADDRTYPE");
					String addrType1 = "", addrType2 = "";
					if(addrType != null && addrType.length() == 2){
						addrType1 = String.valueOf(addrType.charAt(0));
						addrType2 = String.valueOf(addrType.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE1" value="<%=addrType1%>" /> 
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE2" value="<%=addrType2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.20</td>
				<td>Address</td>
				<td><textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%= individualDetails.get("ADDR") != null ? individualDetails.get("ADDR") : "" %></textarea>
				</td>
			</tr>
			<tr>
				<td>B.4.21</td>
				<td>City / Town</td>
				<td><input type="text" class="form-control input-sm" name="CITY" value="<%= individualDetails.get("CITY") != null ? individualDetails.get("CITY") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.22</td>
				<td>Postal Code</td>
				<td><input type="text" class="form-control input-sm" name="POSTALCODE" value="<%= individualDetails.get("POSTALCODE") != null ? individualDetails.get("POSTALCODE") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.23</td>
				<td>State Code</td>
				<td>
					<% 
					String stateCode = individualDetails.get("STATECODE");
					String stateCode1 = "", stateCode2 = "";
					if(stateCode != null && stateCode.length() == 2){
						stateCode1 = String.valueOf(stateCode.charAt(0));
						stateCode2 = String.valueOf(stateCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="STATECODE1" value="<%=stateCode1%>" /> 
					<input type="text" class="input-sm input-ovr" name="STATECODE2" value="<%=stateCode2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.24</td>
				<td>Country Code</td>
				<td>
					<% 
					String countryCode = individualDetails.get("COUNTRYCODE");
					String countryCode1 = "", countryCode2 = "";
					if(countryCode != null && countryCode.length() == 2){
						countryCode1 = String.valueOf(countryCode.charAt(0));
						countryCode2 = String.valueOf(countryCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE1" value="<%=countryCode1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE2" value="<%=countryCode2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.25</td>
				<td>Mobile/Telephone Number</td>
				<td><input type="text" class="form-control input-sm" name="TELEPHONE" value="<%= individualDetails.get("TELEPHONE") != null ? individualDetails.get("TELEPHONE") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.26</td>
				<td>Other Contact Number</td>
				<td><input type="text" class="form-control input-sm" name="OTHERCONTACTNO" value="<%= individualDetails.get("OTHERCONTACTNO") != null ? individualDetails.get("OTHERCONTACTNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.27</td>
				<td>Remarks</td>
				<td><input type="text" class="form-control input-sm" name="REMARKS" value="<%= individualDetails.get("REMARKS") != null ? individualDetails.get("REMARKS") : "" %>"></td>
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