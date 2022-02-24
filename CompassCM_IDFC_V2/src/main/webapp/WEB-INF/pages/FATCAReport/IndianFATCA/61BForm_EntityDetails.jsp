<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String caseNo = (String) request.getAttribute("CASENO");
	String action = (String) request.getAttribute("ACTION");
	String accountNo = (String) request.getAttribute("ACCOUNTNO");
	String entityId = (String) request.getAttribute("TYPEID");
	Map<String, String> entityDetails = (Map<String, String>) request.getAttribute("TYPEDETAILS");
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
	<form action="<%=contextPath%>/common/saveUpdateINDFATCAEntity?${_csrf.parameterName}=${_csrf.token}" method="POST">
		<input type="hidden" name="caseNo" value="<%=caseNo%>" /> 
		<input type="hidden" name="action" value="<%=action%>" />
		<input type="hidden" name=accountNo value="<%=accountNo%>" />
		<input type="hidden" name="entityId" value="<%=entityId%>" />
		
		<table class="table table-bordered">
			<tr class="table-header">
					<td width="10%">B.5</td>
					<td  width="90%" colspan="2">
						LEGAL ENTITY DETAILS (To be provided for entity account holder)
					</td>
				</tr>
				<tr>
					<td>B.5.1</td>
					<td width="35%">Name of the Entity</td>
					<td width="55%">
						<input type="text" class="form-control input-sm" name="NAME" value="<%=entityDetails.get("NAME") != null ? entityDetails.get("NAME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.2</td>
					<td>Customer ID</td>
					<td>
						<input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%=entityDetails.get("CUSTOMERID") != null ? entityDetails.get("CUSTOMERID") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.3</td>
					<td>Account Holder Type for US Reportable Person</td>
					<td>
						<% 
						String usAccountHolderType = entityDetails.get("USACCOUNTHOLDERTYPE");
						String usAccountHolderType1 = "", usAccountHolderType2 = "";
						if(usAccountHolderType != null && usAccountHolderType.length() == 2){
							usAccountHolderType1 = String.valueOf(usAccountHolderType.charAt(0));
							usAccountHolderType2 = String.valueOf(usAccountHolderType.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="USACCOUNTHOLDERTYPE1" value="<%=usAccountHolderType1%>"/>
						<input type="text" class="input-sm input-ovr" name="USACCOUNTHOLDERTYPE2" value="<%=usAccountHolderType2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.4</td>
					<td>Account Holder Type for Other Reportable Person</td>
					<td>
						<% 
						String otherAccountHolderType = entityDetails.get("OTHACCOUNTHOLDERTYPE");
						String otherAccountHolderType1 = "", otherAccountHolderType2 = "";
						if(otherAccountHolderType != null && otherAccountHolderType.length() == 2){
							otherAccountHolderType1 = String.valueOf(otherAccountHolderType.charAt(0));
							otherAccountHolderType2 = String.valueOf(otherAccountHolderType.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="OTHACCOUNTHOLDERTYPE1" value="<%=otherAccountHolderType1%>"/>
						<input type="text" class="input-sm input-ovr" name="OTHACCOUNTHOLDERTYPE2" value="<%=otherAccountHolderType2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.5</td>
					<td>Entity Constitution Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="CONSTITUTIONTYPE" value="<%=entityDetails.get("CONSTITUTIONTYPE") != null ? entityDetails.get("CONSTITUTIONTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.6</td>
					<td>Date of Incorporation</td>
					<td>
						<input type="text" class="form-control input-sm" name="DATEOFINCORPORATION" value="<%=entityDetails.get("DATEOFINCORPORATION") != null ? entityDetails.get("DATEOFINCORPORATION") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.7</td>
					<td>Nature of Business</td>
					<td>
						<input type="text" class="form-control input-sm" name="NATUREOFBUSINESS" value="<%=entityDetails.get("NATUREOFBUSINESS") != null ? entityDetails.get("NATUREOFBUSINESS") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.8</td>
					<td>PAN</td>
					<td>
						<% 
					String pan = entityDetails.get("PAN");
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
					<td>B.5.9</td>
					<td>Identification Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="IDTYPE" value="<%=entityDetails.get("IDTYPE") != null ? entityDetails.get("IDTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.10</td>
					<td>Identification No</td>
					<td>
						<input type="text" class="form-control input-sm" name="IDNO" value="<%=entityDetails.get("IDNO") != null ? entityDetails.get("IDNO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.11</td>
					<td>Identification issuing Country</td>
					<td>
						<% 
						String idIssuingCountry = entityDetails.get("IDISSUINGCOUNTRY");
						String idIssuingCountry1 = "", idIssuingCountry2 = "";
						if(idIssuingCountry != null && idIssuingCountry.length() == 2){
							idIssuingCountry1 = String.valueOf(idIssuingCountry.charAt(0));
							idIssuingCountry2 = String.valueOf(idIssuingCountry.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="IDISSUINGCOUNTRY1" value="<%=idIssuingCountry1%>"/>
						<input type="text" class="input-sm input-ovr" name="IDISSUINGCOUNTRY2" value="<%=idIssuingCountry2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.12</td>
					<td>Place of Incorporation</td>
					<td>
						<input type="text" class="form-control input-sm" name="PLACEOFINCORPORATION" value="<%=entityDetails.get("PLACEOFINCORPORATION") != null ? entityDetails.get("PLACEOFINCORPORATION") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.13</td>
					<td>Country of Incorporation</td>
					<td>
						<% 
						String countryOfIncorp = entityDetails.get("COUNTRYOFINCORPORATION");
						String countryOfIncorp1 = "", countryOfIncorp2 = "";
						if(countryOfIncorp != null && countryOfIncorp.length() == 2){
							countryOfIncorp1 = String.valueOf(countryOfIncorp.charAt(0));
							countryOfIncorp2 = String.valueOf(countryOfIncorp.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="COUNTRYOFINCORPORATION1" value="<%=countryOfIncorp1%>"/>
						<input type="text" class="input-sm input-ovr" name="COUNTRYOFINCORPORATION2" value="<%=countryOfIncorp2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.14</td>
					<td>Country of Residence as per tax laws</td>
					<td>
					<% 
					String countryOfResidence = entityDetails.get("COUNTRYOFRESIDENCE");
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
					<td>B.5.15</td>
					<td>Tax Identification Number (TIN) allotted by tax resident country</td>
					<td>
						<input type="text" class="form-control input-sm" name="TIN" value="<%=entityDetails.get("TIN") != null ? entityDetails.get("TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.16</td>
					<td>TIN Issuing Country</td>
					<td>
					<% 
					String tinIssuingCountry = entityDetails.get("TINISSUNINGCOUNTRY");
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
					<td>B.5.17</td>
					<td>Address Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="ADDRTYPE" value="<%=entityDetails.get("ADDRTYPE") != null ? entityDetails.get("ADDRTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.18</td>
					<td>Address</td>
					<td>
						<textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%=entityDetails.get("ADDR") != null ? entityDetails.get("ADDR") : ""%></textarea>
					</td>
				</tr>
				<tr>
					<td>B.5.19</td>
					<td>City / Town</td>
					<td>
						<input type="text" class="form-control input-sm" name="CITY" value="<%=entityDetails.get("CITY") != null ? entityDetails.get("CITY") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.20</td>
					<td>Postal Code</td>
					<td>
						<input type="text" class="form-control input-sm" name="POSTALCODE" value="<%=entityDetails.get("POSTALCODE") != null ? entityDetails.get("POSTALCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.21</td>
					<td>State Code</td>
					<td>
					<% 
					String stateCode = entityDetails.get("STATECODE");
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
					<td>B.5.22</td>
					<td>Country Code</td>
					<td>
						<% 
						String countryCode = entityDetails.get("COUNTRYCODE");
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
					<td>B.5.23</td>
					<td>Mobile/Telephone Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="TELEPHONENO" value="<%=entityDetails.get("TELEPHONENO") != null ? entityDetails.get("TELEPHONENO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.24</td>
					<td>Other Contact Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="OTHCONTACTNO" value="<%=entityDetails.get("OTHCONTACTNO") != null ? entityDetails.get("OTHCONTACTNO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.25</td>
					<td>Remarks</td>
					<td>
						<input type="text" class="form-control input-sm" name="REMARKS" value="<%=entityDetails.get("REMARKS") != null ? entityDetails.get("REMARKS") : ""%>"/>
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