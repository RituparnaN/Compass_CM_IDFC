<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.aml.model.AOFDisabledFiledsMap"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	String accountHolderType = (String) request.getAttribute("type");
	String cifNo = (String) request.getAttribute("CIF");
	String accountNo = (String) request.getAttribute("AccountNo");
	String lineNo = (String) request.getAttribute("LineNo");
	
	Map<String, String> allCountries = request.getAttribute("ALLCOUNTRIES") != null ? (Map<String, String>) request.getAttribute("ALLCOUNTRIES") : new HashMap<String, String>();
	Map<String, String> accountHolderDetails = request.getAttribute("ACCOUNTHOLDERDETAILS") != null ? (Map<String, String>) request.getAttribute("ACCOUNTHOLDERDETAILS") : new HashMap<String, String>();
	List<Map<String, String>> keyContacts = request.getAttribute("KEYCONTACTS") != null ? (List<Map<String, String>>) request.getAttribute("KEYCONTACTS") : new ArrayList<Map<String, String>>();
%>
<style>
	
	.red{
		color: #E77471;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	.fullWidthTable{
		width: 100%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#cifno").focus();
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
	});
</script>
<input type="hidden" value="<%=accountHolderType%>" name="ACCOUNT_HOLDER_TYPE">
<input type="hidden" value="<%=cifNo%>" name="CIF_NO"/>
<input type="hidden" value="<%=accountNo%>" name="ACCOUNT_NO"/>
<input type="hidden" value="<%=lineNo%>" name="LINE_NO"/>
<table class="table table-bordered table-stripped">
		<%
			if (!accountHolderType.equals("PRIMARY")) {
		%>
		<tr>
			<td width="15%"<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> class="red" <%} %>>Relationship</td>
			<td width="85%">
				<% if("1".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Director
				<% }if("2".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Authorised Signatory
				<% }if("3".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Sole Proprietor
				<% }if("4".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Partner
				<% }if("5".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Committee Member
				<% }if("6".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Office Bearers
				<% }if("7".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Trustee
				<% }if("8".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Family Relationship :
					<% if("1".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Father
					<% }if("2".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Mother
					<% }if("3".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Brother
					<% }if("4".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Sister
					<% }if("5".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Son
					<% }if("6".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %>
						Daughter
					<%} %>
					
				<% }if("9".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
					Other: <%=accountHolderDetails.get("RELATION_WITH_PRIMARY_OTR") != null ? accountHolderDetails.get("RELATION_WITH_PRIMARY_OTR") : "" %>
				<%} %>
			</td>
		</tr>
		<%
			}
		%>
		<tr>
			<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> class="red" <%} %>>Title</td>
			<td width="85%">
				<% if("1".equals(accountHolderDetails.get("TITLE"))){ %>
					Mr.
				<% }if("2".equals(accountHolderDetails.get("TITLE"))){ %>
					Mrs.
				<% }if("3".equals(accountHolderDetails.get("TITLE"))){ %>
					Miss.
				<% }if("4".equals(accountHolderDetails.get("TITLE"))){ %>
					Dr.
				<% }if("5".equals(accountHolderDetails.get("TITLE"))){ %>
					Other: <%= accountHolderDetails.get("TITLE_OTR") != null ? accountHolderDetails.get("TITLE_OTR") : "" %>
				<% }%>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("FULLNAME")){ %> class="red" <%} %>>Full Name / Name of the Company / Business / Institution</td>
			<td>
				<%= accountHolderDetails.get("FULLNAME") != null ? accountHolderDetails.get("FULLNAME") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHERNAME")){ %> class="red" <%} %>>Other Name (such as maiden name)</td>
			<td>
				<%= accountHolderDetails.get("OTHERNAME") != null ? accountHolderDetails.get("OTHERNAME") : "" %>
			</td>
		</tr>

		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("GENDER")){ %> class="red" <%} %>>Gender</td>
			<td>
				<% if("M".equals(accountHolderDetails.get("GENDER"))){ %>
					Male
				<% }if("F".equals(accountHolderDetails.get("GENDER"))){ %>
					Female
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> class="red" <%} %>>Marital Status</td>
			<td>
				<% if("S".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %>
					Single
				<% }if("M".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %>
					Married
				<% }if("W".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %>
					Widowed
				<% }if("D".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %>
					Divorced
				<%} %>
			</td>
		</tr>
		<tr>
			<td>Nationality & Citizenship</td>
			<td>
				<table width="100%">
					<tr>
						<td class="sectionbold" <% if(AOFDisabledFiledsMap.isFieldDisabled("FIRST_NATION_CODE")){ %> class="red" <%} %>>Nationality1 &nbsp;&nbsp;</td>
						<td>
							<%
								Iterator<String> countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
							%>
							<% if(countryCode.equals(accountHolderDetails.get("FIRST_NATION_CODE"))){ %> <%=countryName%> <%} %>
							<%
								}
							%>
							<% if("1".equals(accountHolderDetails.get("CURRENT_RESIDENT"))){ %>
								(Current Resident)
							<%} %>
						</td>
					</tr>
					<tr>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SECOND_NATION_CODE")){ %> class="red" <%} %>>Nationality2 &nbsp;&nbsp;</td>
						<td>
							<%
								countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
							%>
							<% if(countryCode.equals(accountHolderDetails.get("SECOND_NATION_CODE"))){ %> <%=countryName%> <%} %>
							<%
								}
							%>
							<% if("2".equals(accountHolderDetails.get("CURRENT_RESIDENT"))){ %>
								(Current Resident)
							<%} %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Previous Nationality</td>
			<td>
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_CODE")){ %> class="red" <%} %>>Country Name: &nbsp;&nbsp;</td>
						<td>
							<%
							countryItr = allCountries.keySet().iterator();
							while(countryItr.hasNext()){
								String countryCode = countryItr.next();
								String countryName = allCountries.get(countryCode);
							%>
							<% if(countryCode.equals(accountHolderDetails.get("PREV_NATION_CODE"))){ %> <%=countryName%> <%} %>
							<%
							}
							%>
						</td>
					</tr>
					<tr>
						<td>Duration</td>
						<td>
							<table width="100%">
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_FROM")){ %> class="red" <%} %>>From: &nbsp;&nbsp;</td>
									<td><%= accountHolderDetails.get("PREV_NATION_RES_FROM") != null ? accountHolderDetails.get("PREV_NATION_RES_FROM") : "" %></td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_TO")){ %> class="red" <%} %>>To: &nbsp;&nbsp;</td>
									<td><%= accountHolderDetails.get("PREV_NATION_RES_TO") != null ? accountHolderDetails.get("PREV_NATION_RES_TO") : "" %></td>
								</tr>
							</table>

						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>National Identity card / Passport / Driving License Details
				(If Sri Lankan please mention NIC No.)</td>
			<td>
				<table>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> class="red" <%} %>>ID Type: &nbsp;&nbsp;</td>
						<td>
							<% if("1".equals(accountHolderDetails.get("ID_TYPE"))){ %>
								NIC
							<% }if("2".equals(accountHolderDetails.get("ID_TYPE"))){ %>
								Passport
							<% }if("3".equals(accountHolderDetails.get("ID_TYPE"))){ %>
								Driving License
							<% }if("4".equals(accountHolderDetails.get("ID_TYPE"))){ %>
								Other: <%= accountHolderDetails.get("ID_TYPE_OTR") != null ? accountHolderDetails.get("ID_TYPE_OTR") : "" %>
							<%} %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_NO")){ %> class="red" <%} %>>No: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("ID_NO") != null ? accountHolderDetails.get("ID_NO") : "" %></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_ISSUE_DATE")){ %> class="red" <%} %>>Date of Issue: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("ID_ISSUE_DATE") != null ? accountHolderDetails.get("ID_ISSUE_DATE") : "" %></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_EXPIR_DATE")){ %> class="red" <%} %>>Date of Expiry: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("ID_EXPIR_DATE") != null ? accountHolderDetails.get("ID_EXPIR_DATE") : "" %></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Date & Place of Birth / Date of Registration / Incorporation
			</td>
			<td>
				<table>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_DATE")){ %> class="red" <%} %>>Date: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("BIRTH_DATE") != null ? accountHolderDetails.get("BIRTH_DATE") : "" %></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_PLACE")){ %> class="red" <%} %>>Place: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("BIRTH_PLACE") != null ? accountHolderDetails.get("BIRTH_PLACE") : "" %></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Permanent Address / Registered Business Address</td>
			<td>
				<table width="100%">
					<tr>
						<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_1")){ %> class="red" <%} %>>AddressLine1: &nbsp;&nbsp;</td>
						<td width="75%"><%= accountHolderDetails.get("ADDRESS_LINE_1") != null ? accountHolderDetails.get("ADDRESS_LINE_1") : "" %></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_2")){ %> class="red" <%} %>>AddressLine2: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("ADDRESS_LINE_2") != null ? accountHolderDetails.get("ADDRESS_LINE_2") : "" %></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_3")){ %> class="red" <%} %>>AddressLine3: &nbsp;&nbsp;</td>
						<td><%= accountHolderDetails.get("ADDRESS_LINE_3") != null ? accountHolderDetails.get("ADDRESS_LINE_3") : "" %></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREM_ADDRESS_STATUS")){ %> class="red" <%} %>>Status of Permanent Address (Premises)</td>
			<td>
				<% if("1".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Owner <%} %>
				<% if("2".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Rent/Lease <%} %>
				<% if("3".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Friends/Relatives <%} %>
				<% if("4".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Parents <%} %>
				<% if("5".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Official <%} %>
				<% if("6".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> Boarding/Lodging <%} %>
			</td>
		</tr>
		<tr>
			<td>Correspondence Address</td>
			<td>
				<table width="100%">
					<tr>
						<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_1")){ %> class="red" <%} %>>AddressLine1: &nbsp;&nbsp;</td>
						<td width="75%">
							<%= accountHolderDetails.get("CORS_ADDRESS_LINE_1") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_1") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_2")){ %> class="red" <%} %>>AddressLine2: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("CORS_ADDRESS_LINE_2") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_2") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_3")){ %> class="red" <%} %>>AddressLine3: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("CORS_ADDRESS_LINE_3") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_3") : "" %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("NATURE_OF_BUSINESS")){ %> class="red" <%} %>>Nature of Business / Activity</td>
			<td>
				<%= accountHolderDetails.get("NATURE_OF_BUSINESS") != null ? accountHolderDetails.get("NATURE_OF_BUSINESS") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("REG_NUMBER")){ %> class="red" <%} %>>Registration Number</td>
			<td>
				<%= accountHolderDetails.get("REG_NUMBER") != null ? accountHolderDetails.get("REG_NUMBER") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_TIN_NO")){ %> class="red" <%} %>>Tax File / TIN No.</td>
			<td>
				<%= accountHolderDetails.get("TAX_TIN_NO") != null ? accountHolderDetails.get("TAX_TIN_NO") : "" %>
			</td>
		</tr>
		<tr>
			<td>Contact No</td>
			<td>
				<table width="100%">
					<tr>
						<td width="35%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_RES_NO")){ %> class="red" <%} %>>Residence: &nbsp;&nbsp;</td>
						<td width="65%">
							<%= accountHolderDetails.get("CONTACT_RES_NO") != null ? accountHolderDetails.get("CONTACT_RES_NO") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_OFF_NO")){ %> class="red" <%} %>>Office: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("CONTACT_OFF_NO") != null ? accountHolderDetails.get("CONTACT_OFF_NO") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_MOB_NO")){ %> class="red" <%} %>>Mobile: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("CONTACT_MOB_NO") != null ? accountHolderDetails.get("CONTACT_MOB_NO") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_FAX_NO")){ %> class="red" <%} %>>Fax: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("CONTACT_FAX_NO") != null ? accountHolderDetails.get("CONTACT_FAX_NO") : "" %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMAIL")){ %> class="red" <%} %>>E-mail Adress</td>
			<td>
				<%= accountHolderDetails.get("EMAIL") != null ? accountHolderDetails.get("EMAIL") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("WEBSITE")){ %> class="red" <%} %>>Website</td>
			<td>
				<%= accountHolderDetails.get("WEBSITE") != null ? accountHolderDetails.get("WEBSITE") : "" %>
			</td>
		</tr>
		<tr>
			<td>Key Contact Person Details <%=keyContacts.size()%></td>
			<td>
				<%
					int keyContactsSize = keyContacts.size();
					if(keyContactsSize > 0){
				%>
					<table width="100%">
						<%
						for(int i = 0; i < keyContactsSize; i++){
						Map<String, String> keyContact = keyContacts.get(i);
						%>
							<tr>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> class="red" <%} %>>Name: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_NAME") != null ? keyContact.get("KEY_CONTACT_NAME") : "" %>
								</td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> class="red" <%} %>>Designation: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_DESG") != null ? keyContact.get("KEY_CONTACT_DESG") : "" %>
								</td>
							</tr>
							<tr>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> class="red" <%} %>>Tel No.: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_TEL") != null ? keyContact.get("KEY_CONTACT_TEL") : "" %>
								</td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> class="red" <%} %>>Mobile No.: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_MOB") != null ? keyContact.get("KEY_CONTACT_MOB") : "" %>
								</td>
							</tr>
							<tr>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> class="red" <%} %>>Email ID: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_EMAIL") != null ? keyContact.get("KEY_CONTACT_EMAIL") : "" %>
								</td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> class="red" <%} %>>ID No.: &nbsp;&nbsp;</td>
								<td>
									<%= keyContact.get("KEY_CONTACT_IDNO") != null ? keyContact.get("KEY_CONTACT_IDNO") : "" %>
								</td>
							</tr>
							<tr style="border-bottom: 1px solid black;">
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> class="red" <%} %>>Comments: &nbsp;&nbsp;</td>
								<td colspan="3">
									<%= keyContact.get("KEY_CONTACT_COMMENTS") != null ? keyContact.get("KEY_CONTACT_COMMENTS") : "" %>
								</td>
							</tr>
						<%}%>
					</table>
				<%}else{%>
					No Key Contact details found
				<%}%>
				<!--
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> class="red" <%} %>>Name: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_1_NAME") != null ? accountHolderDetails.get("KEY_CONTACT_1_NAME") : "" %>
						</td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> class="red" <%} %>>Designation: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_1_DESG") != null ? accountHolderDetails.get("KEY_CONTACT_1_DESG") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> class="red" <%} %>>Tel No.: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_1_TEL") != null ? accountHolderDetails.get("KEY_CONTACT_1_TEL") : "" %>
						</td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> class="red" <%} %>>Mobile No.: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_1_MOB") != null ? accountHolderDetails.get("KEY_CONTACT_1_MOB") : "" %>
						</td>
					</tr>
					<tr style="border-bottom: 1px solid black;">
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> class="red" <%} %>>Email Address: &nbsp;&nbsp;</td>
						<td colspan="3">
							<%= accountHolderDetails.get("KEY_CONTACT_1_EMAIL") != null ? accountHolderDetails.get("KEY_CONTACT_1_EMAIL") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_NAME")){ %> class="red" <%} %>>Name: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_2_NAME") != null ? accountHolderDetails.get("KEY_CONTACT_2_NAME") : "" %>
						</td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_DESG")){ %> class="red" <%} %>>Designation: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_2_DESG") != null ? accountHolderDetails.get("KEY_CONTACT_2_DESG") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_TEL")){ %> class="red" <%} %>>Tel No.: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_2_TEL") != null ? accountHolderDetails.get("KEY_CONTACT_2_TEL") : "" %>
						</td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_MOB")){ %> class="red" <%} %>>Mobile No.: &nbsp;&nbsp;</td>
						<td>
							<%= accountHolderDetails.get("KEY_CONTACT_2_MOB") != null ? accountHolderDetails.get("KEY_CONTACT_2_MOB") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_EMAIL")){ %> class="red" <%} %>>Email Address: &nbsp;&nbsp;</td>
						<td colspan="3">
							<%= accountHolderDetails.get("KEY_CONTACT_2_EMAIL") != null ? accountHolderDetails.get("KEY_CONTACT_2_EMAIL") : "" %>
						</td>
					</tr>
				</table>
				-->
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OCCUPATION")){ %> class="red" <%} %>>Occupation</td>
			<td>
				<%= accountHolderDetails.get("OCCUPATION") != null ? accountHolderDetails.get("OCCUPATION") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DESIGNATION")){ %> class="red" <%} %>>Designation</td>
			<td>
				<%= accountHolderDetails.get("DESIGNATION") != null ? accountHolderDetails.get("DESIGNATION") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OWNERSHIP_PER")){ %> class="red" <%} %>>Ownership Percentage (%)</td>
			<td>
				<%= accountHolderDetails.get("OWNERSHIP_PER") != null ? accountHolderDetails.get("OWNERSHIP_PER") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_NAME")){ %> class="red" <%} %>>Name of Employer (Please mention if Self Employed)</td>
			<td>
				<%= accountHolderDetails.get("EMPLOYER_NAME") != null ? accountHolderDetails.get("EMPLOYER_NAME") : "" %>
			</td>
		</tr>
		<tr>
			<td>Employment Period</td>
			<td>
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_FROM")){ %> class="red" <%} %>>
							From: &nbsp;&nbsp;
						</td>
						<td>
							<%= accountHolderDetails.get("EMPLOYMENT_FROM") != null ? accountHolderDetails.get("EMPLOYMENT_FROM") : "" %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_TO")){ %> class="red" <%} %>>
							To: &nbsp;&nbsp;
						</td>
						<td>
							<%= accountHolderDetails.get("EMPLOYMENT_TO") != null ? accountHolderDetails.get("EMPLOYMENT_TO") : "" %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_ADDRESS")){ %> class="red" <%} %>>Address of Employer</td>
			<td>
				<%= accountHolderDetails.get("EMPLOYER_ADDRESS") != null ? accountHolderDetails.get("EMPLOYER_ADDRESS") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")){ %> class="red" <%} %>>Income Details (Rs.)</td>
			<td>
				<% if("1".equals(accountHolderDetails.get("INCOME_DET"))){ %> Less than 15,000 <%} %>
				<% if("2".equals(accountHolderDetails.get("INCOME_DET"))){ %> 15,000 - 24,999 <%} %>
				<% if("3".equals(accountHolderDetails.get("INCOME_DET"))){ %> 25,000 - 39,999 <%} %>
				<% if("4".equals(accountHolderDetails.get("INCOME_DET"))){ %> 40,000 - 59,999 <%} %>
				<% if("5".equals(accountHolderDetails.get("INCOME_DET"))){ %> 60,000 - 79,999 <%} %>
				<% if("6".equals(accountHolderDetails.get("INCOME_DET"))){ %> 80,000 - 99,999 <%} %>
				<% if("7".equals(accountHolderDetails.get("INCOME_DET"))){ %> 100,000 and above <%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PUBLIC_POSITION_HELD")){ %> class="red" <%} %>>Public Positions Held</td>
			<td>
				<%= accountHolderDetails.get("PUBLIC_POSITION_HELD") != null ? accountHolderDetails.get("PUBLIC_POSITION_HELD") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_CONN_BUSINESS")){ %> class="red" <%} %>>Other Connected Business or Professional Activities</td>
			<td>
				<%= accountHolderDetails.get("OTHER_CONN_BUSINESS") != null ? accountHolderDetails.get("OTHER_CONN_BUSINESS") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_NAME")){ %> class="red" <%} %>>Name of Spouse</td>
			<td>
				<%= accountHolderDetails.get("SPOUSE_NAME") != null ? accountHolderDetails.get("SPOUSE_NAME") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_EMP_DESG")){ %> class="red" <%} %>>Employer of Spouse and Designation</td>
			<td>
				<%= accountHolderDetails.get("SPOUSE_EMP_DESG") != null ? accountHolderDetails.get("SPOUSE_EMP_DESG") : "" %>
			</td>
		</tr>
		<tr>
			<td width="25%">Assets held by the Account Holder & their Market
				Value</td>
			<td width="75%">
				<table>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_RES_PROP" id="assets1" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_RES_PROP"))){ %> checked="checked" <%} %>
							disabled="disabled"> 
							<label for="assets1" <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_RES_PROP")){ %> class="red" <%} %>>Residential Property</label>
						</td>
						<td>Rs. <%= accountHolderDetails.get("ASSET_RES_PROP_VAL") != null ? accountHolderDetails.get("ASSET_RES_PROP_VAL") : "" %>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_MOTOR_VECH" id="assets2" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_MOTOR_VECH"))){ %> checked="checked" <%} %>
							disabled="disabled"> 
							<label for="assets2" <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_MOTOR_VECH")){ %> class="red" <%} %>>Motor Vehicles</label>
						</td>
						<td>Rs. <%= accountHolderDetails.get("ASSET_MOTOR_VECH_VAL") != null ? accountHolderDetails.get("ASSET_MOTOR_VECH_VAL") : "" %>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_LAND_BUILD" id="assets3" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_LAND_BUILD"))){ %> checked="checked" <%} %>
							disabled="disabled"> 
							<label for="assets3" <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_LAND_BUILD")){ %> class="red" <%} %>>Land and Buildings</label>
						</td>
						<td>Rs. <%= accountHolderDetails.get("ASSET_LAND_BUILD_VAL") != null ? accountHolderDetails.get("ASSET_LAND_BUILD_VAL") : "" %>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_INSVT_SHARES" id="assets4" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_INSVT_SHARES"))){ %> checked="checked" <%} %>
							disabled="disabled"> 
							<label for="assets4" <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_INSVT_SHARES")){ %> class="red" <%} %>>Investments / Shares</label>
						</td>
						<td>Rs. <%= accountHolderDetails.get("ASSET_INSVT_SHARES_VAL") != null ? accountHolderDetails.get("ASSET_INSVT_SHARES_VAL") : "" %> 
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_OTHER_name" id="assets5" value="Y" <% if(accountHolderDetails.get("ASSET_OTHER") != null && accountHolderDetails.get("ASSET_OTHER") != ""){ %> checked="checked" <%} %>
							disabled="disabled"> 
							<label for="assets5" <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_OTHER")){ %> class="red" <%} %>> 
								Other : <input type="text" name="ASSET_OTHER" disabled="disabled"
								<% if(accountHolderDetails.get("ASSET_OTHER") != null && accountHolderDetails.get("ASSET_OTHER") != ""){ %>
									value="<%=accountHolderDetails.get("ASSET_OTHER")%>"
								<%} %>
								/>
							</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_OTHER_VAL" disabled="disabled"
						<% if(accountHolderDetails.get("ASSET_OTHER") != null && accountHolderDetails.get("ASSET_OTHER") != ""){ %>
						 value="<%= accountHolderDetails.get("ASSET_OTHER_VAL") != null ? accountHolderDetails.get("ASSET_OTHER_VAL") : "" %>"
						<%} %>
						/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_PAYER")){ %> class="red" <%} %>>Are you a Tax Payer?</td>
			<td>
				<% if("N".equals(accountHolderDetails.get("TAX_PAYER"))){ %>
					No
				<% }if("Y".equals(accountHolderDetails.get("TAX_PAYER"))){ %>
					Yes. Income Tax File No : <%= accountHolderDetails.get("TAX_FILE_NO") != null ? accountHolderDetails.get("TAX_FILE_NO") : "" %>
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_DECLR_SUBMITTED")){ %> class="red" <%} %>>Declaration Submitted</td>
			<td>
				<% if("Y".equals(accountHolderDetails.get("TAX_DECLR_SUBMITTED"))){ %>
					Yes. For Tax Year: <%= accountHolderDetails.get("TAX_DECLR_SUBMITTED_YEAR") != null ? accountHolderDetails.get("TAX_DECLR_SUBMITTED_YEAR") : "" %>
				<% }if("N".equals(accountHolderDetails.get("TAX_DECLR_SUBMITTED"))){ %>
					NO
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="45%" <% if(AOFDisabledFiledsMap.isFieldDisabled("DUAL_CITIZEN")){ %> class="red" <%} %>>Are you a Permanent Resident (Green card Holder) or a Dual Citizen of another country?</td>
			<td width="55%">
				<% if("Y".equals(accountHolderDetails.get("DUAL_CITIZEN"))){ %>
					Yes, <%
							countryItr = allCountries.keySet().iterator();
							while(countryItr.hasNext()){
								String countryCode = countryItr.next();
								String countryName = allCountries.get(countryCode);
						 %>
						 <% if(countryCode.equals(accountHolderDetails.get("DUAL_CITIZEN_NATION_CODE"))){ %> <%=countryName%> <%} %>
						 <%
						 }
						 %>
				<%}if("N".equals(accountHolderDetails.get("DUAL_CITIZEN"))){ %>
					No
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("REGULR_TRVL_RIMIT")){ %> class="red" <%} %>>Do you regularly travel, send or receive remittance to/from a foreign country/ies?</td>
			<td>
				<% if("Y".equals(accountHolderDetails.get("REGULR_TRVL_RIMIT"))){ %>
					Yes, 
					<%
						countryItr = allCountries.keySet().iterator();
						while(countryItr.hasNext()){
							String countryCode = countryItr.next();
							String countryName = allCountries.get(countryCode);
					%>
					<% if(countryCode.equals(accountHolderDetails.get("REGULR_TRVL_RIMIT_NATION_CODE"))){ %> <%=countryName%> <%} %>
					<%
						}
					%>
				<%}if("N".equals(accountHolderDetails.get("REGULR_TRVL_RIMIT"))){ %>
					No
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("FRGN_PWR_ATRNY")){ %> class="red" <%} %>>Have you granted a Power of Attorney to a person from a foreign country?</td>
			<td>
				<% if("Y".equals(accountHolderDetails.get("FRGN_PWR_ATRNY"))){ %>
					Yes,
					<%
						countryItr = allCountries.keySet().iterator();
						while(countryItr.hasNext()){
							String countryCode = countryItr.next();
							String countryName = allCountries.get(countryCode);
					%>
					<% if(countryCode.equals(accountHolderDetails.get("FRGN_PWR_ATRNY_NATION_CODE"))){ %> <%=countryName%> <%} %>
					<%
					}
					%>	
				<%} if("N".equals(accountHolderDetails.get("FRGN_PWR_ATRNY"))){ %>
					No
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PUR_IN_SL")){ %> class="red" <%} %>>If foreign citizen please specify the purpose of opening the
				account in Sri Lanka</td>
			<td>
				<%= accountHolderDetails.get("PUR_IN_SL") != null ? accountHolderDetails.get("PUR_IN_SL") : "" %>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="section">
				    	<div class="sectionHeader">
				    		EXISTING ACCOUNTS MAINTAINED WITH AMANA BANK
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    							<td><%= accountHolderDetails.get("EXIST_BANK_ACC_NO_1") != null ? accountHolderDetails.get("EXIST_BANK_ACC_NO_1") : "" %></td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    							<td>
				    								<% if("SA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Savings Account
				    								<%}if("CA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Current Account
				    								<%}if("TD".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Term Deposite
				    								<%}if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Other: <%= accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1_OTR") != null ? accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1_OTR") : "" %>
				    								<%} %>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    							<td><%= accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_1") != null ? accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_1") : "" %></td>
				    						</tr>
				    					</table>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    							<td><%= accountHolderDetails.get("EXIST_BANK_ACC_NO_2") != null ? accountHolderDetails.get("EXIST_BANK_ACC_NO_2") : "" %></td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    							<td>
							    					<% if("SA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Savings Account
							    					<%}if("CA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Current Account
							    					<%}if("TD".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Term Deposite
							    					<%}if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Other: <%= accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2_OTR") != null ? accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2_OTR") : "" %>
							    					<%} %>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    							<td><%= accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_2") != null ? accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_2") : "" %></td>
				    						</tr>
				    					</table>
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    </div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="section">
				    		<div class="sectionHeader">
				    			ACCOUNTS HELD IN OTHER BANKS
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    								<td><%= accountHolderDetails.get("EXIST_OTHER_ACC_NO_1") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_NO_1") : "" %></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
								    					<% if("SA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Savings Account
								    					<%}if("CA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Current Account
								    					<%}if("TD".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Term Deposite
								    					<%}if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Other: <%= accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1_OTR") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1_OTR") : "" %>
								    					<%} %>
					    							</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><%= accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_1") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_1") : "" %></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><%= accountHolderDetails.get("EXIST_OTHER_ACC_NO_2") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_NO_2") : "" %></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
								    					<% if("SA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Savings Account
								    					<%}if("CA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Current Account
								    					<%}if("TD".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Term Deposite
								    					<%}if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Other: <%= accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2_OTR") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2_OTR") : "" %>
								    					<%} %>
					    							</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><%= accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_2") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_2") : "" %></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
			</td>
		</tr>
</table>