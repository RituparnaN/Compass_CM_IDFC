<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String caseNo = (String) request.getAttribute("CASENO");
	String action = (String) request.getAttribute("ACTION");
	String accountNo = (String) request.getAttribute("ACCOUNTNO");
	String controllingPersonId = (String) request.getAttribute("TYPEID");
	Map<String, String> controllingPersonDetails = (Map<String, String>) request.getAttribute("TYPEDETAILS");
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
	<form action="<%=contextPath%>/common/saveUpdateINDFATCAControllingPerson?${_csrf.parameterName}=${_csrf.token}" method="POST">
		<input type="hidden" name="caseNo" value="<%=caseNo%>" /> 
		<input type="hidden" name="action" value="<%=action%>" />
		<input type="hidden" name=accountNo value="<%=accountNo%>" />
		<input type="hidden" name="controllingPersonId" value="<%=controllingPersonId%>" />
		
		<table class="table table-bordered">
			<tr class="table-header">
					<td width="10%">B.6</td>
					<td  width="90%" colspan="2">
						CONTROLLING PERSON DETAILS (To be provided for each controlling person of the entity)
					</td>
				</tr>
				<tr>
					<td>B.6.1</td>
					<td width="35%">Controlling Person Type</td>
					<% 
					String personType = controllingPersonDetails.get("PERSONTYPE");
					String personType1 = "", personType2 = "", personType3 = "";
					if(personType != null && personType.length() == 3){
						personType1 = String.valueOf(personType.charAt(0));
						personType2 = String.valueOf(personType.charAt(1));
						personType3 = String.valueOf(personType.charAt(2));
					}
					%>
					<td width="55%">
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE1" value="<%=personType1%>"/>
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE2" value="<%=personType2%>"/>
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE3" value="<%=personType3%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.2</td>
					<td>Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="NAME" value="<%= controllingPersonDetails.get("NAME") != null ? controllingPersonDetails.get("NAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.3</td>
					<td>Customer ID</td>
					<td>
						<input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%= controllingPersonDetails.get("CUSTOMERID") != null ? controllingPersonDetails.get("CUSTOMERID") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.4</td>
					<td>Father's Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="FATHERNAME" value="<%= controllingPersonDetails.get("FATHERNAME") != null ? controllingPersonDetails.get("FATHERNAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.5</td>
					<td>Spouse's Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="SPOUSENAME" value="<%= controllingPersonDetails.get("SPOUSENAME") != null ? controllingPersonDetails.get("SPOUSENAME") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.6</td>
					<td>Gender</td>
					<td>
						<input type="text" class="input-sm input-ovr"  name="GENDER" value="<%= controllingPersonDetails.get("GENDER") != null ? controllingPersonDetails.get("GENDER") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.7</td>
					<td>PAN</td>
					<td>
					<% 
					String pan = controllingPersonDetails.get("PAN");
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
					<td>B.6.8</td>
					<td>Aadhaar Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="ADHAARNO" value="<%= controllingPersonDetails.get("ADHAARNO") != null ? controllingPersonDetails.get("ADHAARNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.9</td>
					<td>Identification Type</td>
					<td>
						<input type="text" class="input-sm input-ovr"  name="IDTYPE" value="<%= controllingPersonDetails.get("IDTYPE") != null ? controllingPersonDetails.get("IDTYPE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.10</td>
					<td>Identification Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="IDNO" value="<%= controllingPersonDetails.get("IDNO") != null ? controllingPersonDetails.get("IDNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.11</td>
					<td>Occupation Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="OCCUPATIONTYPE" value="<%= controllingPersonDetails.get("OCCUPATIONTYPE") != null ? controllingPersonDetails.get("OCCUPATIONTYPE") : "" %>" />
					</td>
				</tr>
				<tr>
					<td>B.6.12</td>
					<td>Occupation</td>
					<td>
						<input type="text" class="form-control input-sm" name="OCCUPATION" value="<%= controllingPersonDetails.get("OCCUPATION") != null ? controllingPersonDetails.get("OCCUPATION") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.13</td>
					<td>Birth Date</td>
					<td>
						<input type="text" class="form-control input-sm" name="DATEOFBIRTH" value="<%= controllingPersonDetails.get("DATEOFBIRTH") != null ? controllingPersonDetails.get("DATEOFBIRTH") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.14</td>
					<td>Nationality</td>
					<td>
					<% 
					String nationality = controllingPersonDetails.get("NATIONALITY");
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
					<td>B.6.15</td>
					<td>Country of Residence as per tax laws</td>
					<td>
					<% 
					String countryOfResidence = controllingPersonDetails.get("COUNTRYOFRESIDENCE");
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
					<td>B.6.16</td>
					<td>Place of Birth</td>
					<td>
						<input type="text" class="form-control input-sm" name="PLACEOFBIRTH" value="<%= controllingPersonDetails.get("PLACEOFBIRTH") != null ? controllingPersonDetails.get("PLACEOFBIRTH") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.17</td>
					<td>Country of Birth</td>
					<td>
					<% 
					String countryOfBirth = controllingPersonDetails.get("COUNTRYOFBIRTH");
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
					<td>B.6.18</td>
					<td>Tax Identification Number (TIN) allotted by tax resident country</td>
					<td>
						<input type="text" class="form-control input-sm" name="TIN" value="<%= controllingPersonDetails.get("TIN") != null ? controllingPersonDetails.get("TIN") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.19</td>
					<td>TIN Issuing Country</td>
					<td>
					<% 
					String tinIssuingCountry = controllingPersonDetails.get("TINISSUNINGCOUNTRY");
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
					<td>B.6.20</td>
					<td>Address Type</td>
					<td>
					<% 
					String addrType = controllingPersonDetails.get("ADDRTYPE");
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
					<td>B.6.21</td>
					<td>Address</td>
					<td>
						<textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%= controllingPersonDetails.get("ADDR") != null ? controllingPersonDetails.get("ADDR") : "" %></textarea>
					</td>
				</tr>
				<tr>
					<td>B.6.22</td>
					<td>City / Town</td>
					<td>
						<input type="text" class="form-control input-sm" name="CITY" value="<%= controllingPersonDetails.get("CITY") != null ? controllingPersonDetails.get("CITY") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.23</td>
					<td>Postal Code</td>
					<td>
						<input type="text" class="form-control input-sm" name="POSTALCODE" value="<%= controllingPersonDetails.get("POSTALCODE") != null ? controllingPersonDetails.get("POSTALCODE") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.24</td>
					<td>State Code</td>
					<td>
					<% 
					String stateCode = controllingPersonDetails.get("STATECODE");
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
					<td>B.6.25</td>
					<td>Country Code</td>
					<td>
					<% 
					String countryCode = controllingPersonDetails.get("COUNTRYCODE");
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
					<td>B.6.26</td>
					<td>Mobile/Telephone Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="TELEPHONE" value="<%= controllingPersonDetails.get("TELEPHONE") != null ? controllingPersonDetails.get("TELEPHONE") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.27</td>
					<td>Other Contact Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="OTHERCONTACTNO" value="<%= controllingPersonDetails.get("OTHERCONTACTNO") != null ? controllingPersonDetails.get("OTHERCONTACTNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.28</td>
					<td>Remarks</td>
					<td>
						<input type="text" class="form-control input-sm" name="REMARKS" value="<%= controllingPersonDetails.get("REMARKS") != null ? controllingPersonDetails.get("REMARKS") : "" %>">
					</td>
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