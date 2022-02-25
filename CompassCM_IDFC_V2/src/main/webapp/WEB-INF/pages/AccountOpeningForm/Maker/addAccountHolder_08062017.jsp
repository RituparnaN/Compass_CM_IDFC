<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	String accountHolderType = (String) request.getAttribute("type");
	String cifNo = (String) request.getAttribute("CIF");
	String accountNo = (String) request.getAttribute("AccountNo");
	String lineNo = (String) request.getAttribute("LineNo");
	String caseNo = (String) request.getAttribute("caseNo");
	String canEdit = (String) request.getAttribute("canEdit");
	
	Map<String, String> allCountries = request.getAttribute("ALLCOUNTRIES") != null ? (Map<String, String>) request.getAttribute("ALLCOUNTRIES") : new HashMap<String, String>();
	Map<String, String> accountHolderDetails = request.getAttribute("ACCOUNTHOLDERDETAILS") != null ? (Map<String, String>) request.getAttribute("ACCOUNTHOLDERDETAILS") : new HashMap<String, String>();
	List<Map<String, String>> keyContacts = request.getAttribute("KEYCONTACTS") != null ? (List<Map<String, String>>) request.getAttribute("KEYCONTACTS") : new ArrayList<Map<String, String>>();
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
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#cifno").focus();
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$("#aof_saveAccountHolderDetails").submit(function(e){
			var formObj = $(this);
			var formData = $(formObj).serialize();
			$.ajax({
				url : '<%=contextPath%>/cpumaker/saveAccountHolderDetails',
				type : "POST",
				data : formData,
				cache : false,
				success : function(res){
					alert(res);
				},
				error : function(a,b,c){
					alert("error"+a+b+c);
				}
			});
			e.preventDefault();
		});
	});
</script>
<form action="javascript:void(0)" id="aof_saveAccountHolderDetails" method="post">
<input type="hidden" value="<%=accountHolderType%>" name="ACCOUNT_HOLDER_TYPE">
<input type="hidden" value="<%=cifNo%>" name="CIF_NO"/>
<input type="hidden" value="<%=accountNo%>" name="ACCOUNT_NO"/>
<input type="hidden" value="<%=lineNo%>" name="LINE_NO"/>
<input type="hidden" value="<%=caseNo%>" name="CASE_NO"/>
<table class="table table-bordered table-stripped">
		<%
			if (!accountHolderType.equals("PRIMARY")) {
		%>
		<tr>
			<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> class="red" <%} %>>Relationship</td>
			<td width="85%">
				<table class="fullWidthTable" width="100%">
					<tr>
						<td width="33%">
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary1" value="1" <% if("1".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>> 
							<label for="relationshipToPrimary1">Director</label></td>
						<td width="34%">
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary2" value="2" <% if("2".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>> 
							<label for="relationshipToPrimary2">Authorised Signatory</label></td>
						<td width="33%">
						 	<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary3" value="3" <% if("3".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
						 	<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>> 
						 	<label for="relationshipToPrimary3">Sole Proprietor</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary4" value="4" <% if("4".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
							<label for="relationshipToPrimary4">Partner</label>
						</td>
						<td>
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary5" value="5" <% if("5".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
							<label for="relationshipToPrimary5">Committee Member</label>
						</td>
						<td>
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary6" value="6" <% if("6".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
							<label for="relationshipToPrimary6">Office Bearers</label></td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary7" value="7" <% if("7".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
							<label for="relationshipToPrimary7">Trustee</label>
						</td>
						<td>
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary8" value="8" <% if("8".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
							<label for="relationshipToPrimary8">Family Relationship : </label>
								<select name="FMLY_RELATION_WITH_PRIMARY" class="form-control input-sm" style="width: 85%" <% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>>
									<option value=""></option>
									<option value="1" <% if("1".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Father</option>
									<option value="2" <% if("2".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Mother</option>
									<option value="3" <% if("3".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Brother</option>
									<option value="4" <% if("4".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Sister</option>
									<option value="5" <% if("5".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Son</option>
									<option value="6" <% if("6".equals(accountHolderDetails.get("FMLY_RELATION_WITH_PRIMARY"))){ %> selected="selected" <%} %>>Daughter</option>
								</select>							
						</td>
						<td colspan="1">
							<input type="radio" name="RELATION_WITH_PRIMARY" id="relationshipToPrimary9" value="9" <% if("9".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("RELATION_WITH_PRIMARY")%>')" <%} %>> 
							<label for="relationshipToPrimary9">
								Other : <input type="text" name="RELATION_WITH_PRIMARY_OTR" class="input-ovr"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("RELATION_WITH_PRIMARY")){ %> readonly="readonly" <%} %>
								<% if("9".equals(accountHolderDetails.get("RELATION_WITH_PRIMARY"))){ %>
									value="<%=accountHolderDetails.get("RELATION_WITH_PRIMARY_OTR") != null ? accountHolderDetails.get("RELATION_WITH_PRIMARY_OTR") : "" %>"
								<%} %>
								/>
							</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<%
			}
		%>
		<tr>
			<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> class="red" <%} %>>Title</td>
			<td width="85%">
				<ul class="inlineUL">
					<li>
						<input type="radio" name="TITLE" id="titleMr" value="1" <% if("1".equals(accountHolderDetails.get("TITLE"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TITLE")%>')" <%} %>>
						<label for="titleMr">Mr.</label>
					</li>
					<li>
						<input type="radio" name="TITLE" id="titleMrs" value="2" <% if("2".equals(accountHolderDetails.get("TITLE"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TITLE")%>')" <%} %>> 
						<label for="titleMrs">Mrs.</label>
					</li>
					<li>
						<input type="radio" name="TITLE" id="titleMiss" value="3" <% if("3".equals(accountHolderDetails.get("TITLE"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TITLE")%>')" <%} %>> 
						<label for="titleMiss">Miss.</label>
					</li>
					<li>
						<input type="radio" name="TITLE" id="titleDr" value="4" <% if("4".equals(accountHolderDetails.get("TITLE"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TITLE")%>')" <%} %>>
						<label for="titleDr">Dr.</label>
					</li>
					<li>
						<input type="radio" name="TITLE" id="titleOther" value="5" <% if("5".equals(accountHolderDetails.get("TITLE"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TITLE")%>')" <%} %>> 
						<label for="titleOther"> 
							Other : <input type="text" name="TITLE_OTR" class="input-ovr"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("TITLE")){ %> readonly="readonly" <%} %>
								<% if("5".equals(accountHolderDetails.get("TITLE"))){ %> 
									value="<%= accountHolderDetails.get("TITLE_OTR") != null ? accountHolderDetails.get("TITLE_OTR") : "" %>"
								<%} %>
							/>
						</label>
					</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("FULLNAME")){ %> class="red" <%} %>>Full Name / Name of the Company / Business / Institution</td>
			<td><input type="text" class="form-control input-sm"
				name="FULLNAME" value="<%= accountHolderDetails.get("FULLNAME") != null ? accountHolderDetails.get("FULLNAME") : "" %>"
				<% if(AOFDisabledFiledsMap.isFieldDisabled("FULLNAME")){ %> readonly="readonly" <%} %>></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHERNAME")){ %> class="red" <%} %>>Other Name (such as maiden name)</td>
			<td><input type="text" class="form-control input-sm"
				name="OTHERNAME" value="<%= accountHolderDetails.get("OTHERNAME") != null ? accountHolderDetails.get("OTHERNAME") : "" %>"
				<% if(AOFDisabledFiledsMap.isFieldDisabled("OTHERNAME")){ %> readonly="readonly" <%} %>></td>
		</tr>

		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("GENDER")){ %> class="red" <%} %>>Gender</td>
			<td>
				<table width="100%">
					<tr>
						<td><input type="radio" name="GENDER" id="genderM" value="M" <% if("M".equals(accountHolderDetails.get("GENDER"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("GENDER")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("GENDER")%>')" <%} %>/>
							<label for="genderM"> &nbsp;&nbsp;Male</label></td>
						<td><input type="radio" name="GENDER" id="genderF" value="F" <% if("F".equals(accountHolderDetails.get("GENDER"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("GENDER")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("GENDER")%>')" <%} %>/>
							<label for="genderF"> &nbsp;&nbsp;Female</label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> class="red" <%} %>>Marital Status</td>
			<td>
				<table width="100%">
					<tr>
						<td><input type="radio" name="MARITAL_STATUS"
							id="maritalStatusS" value="S" <% if("S".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("MARITAL_STATUS")%>')" <%} %>/>
							 <label for="maritalStatusS">&nbsp;&nbsp;Single</label>
						</td>
						<td><input type="radio" name="MARITAL_STATUS"
							id="maritalStatusM" value="M" <% if("M".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("MARITAL_STATUS")%>')" <%} %>/> 
							<label for="maritalStatusM">&nbsp;&nbsp;Married</label>
						</td>
						<td><input type="radio" name="MARITAL_STATUS"
							id="maritalStatusW" value="W" <% if("W".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("MARITAL_STATUS")%>')" <%} %>/> 
							<label for="maritalStatusW">&nbsp;&nbsp;Widowed</label>
						</td>
						<td><input type="radio" name="MARITAL_STATUS"
							id="maritalStatusD" value="D" <% if("D".equals(accountHolderDetails.get("MARITAL_STATUS"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("MARITAL_STATUS")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("MARITAL_STATUS")%>')" <%} %>/> 
							<label for="maritalStatusD">&nbsp;&nbsp;Divorced</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Nationality & Citizenship</td>
			<td>
				<table width="100%">
					<tr>
						<td<% if(AOFDisabledFiledsMap.isFieldDisabled("FIRST_NATION_CODE")){ %> class="red" <%} %>>Nationality1 &nbsp;&nbsp;</td>
						<td>
							<table>
								<tr>
									<td>
										<select name="FIRST_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("FIRST_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("FIRST_NATION_CODE")%>')" <%} %>>
											<option value=""></option>
											<%
											Iterator<String> countryItr = allCountries.keySet().iterator();
											while(countryItr.hasNext()){
												String countryCode = countryItr.next();
												String countryName = allCountries.get(countryCode);
											%>
											<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("FIRST_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
											<%
												}
											%>
										</select>
									</td>
									<td>
										<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CURRENT_RESIDENT")){ %> class="red" <%} %> for="currentResident1">&nbsp;&nbsp;&nbsp;Current Resident&nbsp;&nbsp;</label>
									</td>
									<td>
										<input type="radio" name="CURRENT_RESIDENT" value="1" id="currentResident1" <% if("1".equals(accountHolderDetails.get("CURRENT_RESIDENT"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("CURRENT_RESIDENT")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("CURRENT_RESIDENT")%>')" <%} %>/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SECOND_NATION_CODE")){ %> class="red" <%} %>>Nationality2 &nbsp;&nbsp;</td>
						<td>
							<table>
								<tr>
									<td>
										<select name="SECOND_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("SECOND_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("SECOND_NATION_CODE")%>')" <%} %>>
											<option value=""></option>
											<%
											countryItr = allCountries.keySet().iterator();
											while(countryItr.hasNext()){
												String countryCode = countryItr.next();
												String countryName = allCountries.get(countryCode);
											%>
											<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("SECOND_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
											<%
												}
											%>
										</select>
									</td>
									<td>
										<label <% if(AOFDisabledFiledsMap.isFieldDisabled("CURRENT_RESIDENT")){ %> class="red" <%} %> for="currentResident2">&nbsp;&nbsp;&nbsp;Current Resident&nbsp;&nbsp;</label>
									</td>
									<td>
										<input id="currentResident2" type="radio" name="CURRENT_RESIDENT" value="2" <% if("2".equals(accountHolderDetails.get("CURRENT_RESIDENT"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("CURRENT_RESIDENT")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("CURRENT_RESIDENT")%>')" <%} %>/>
									</td>
								</tr>
							</table>
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
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_CODE")){ %> class="red" <%} %>>Country Name</td>
						<td>
							<select name="PREV_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("PREV_NATION_CODE")%>')" <%} %>>
								<option value=""></option>
								<%
								countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
								%>
								<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("PREV_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
								<%
								}
								%>	
							</select>
						</td>
					</tr>
					<tr>
						<td>Duration</td>
						<td>
							<table width="100%">
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_FROM")){ %> class="red" <%} %>>From</td>
									<td><input type="text" name="PREV_NATION_RES_FROM" value="<%= accountHolderDetails.get("PREV_NATION_RES_FROM") != null ? accountHolderDetails.get("PREV_NATION_RES_FROM") : "" %>"
										<% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_FROM")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>></td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_TO")){ %> class="red" <%} %>>To</td>
									<td><input type="text" name="PREV_NATION_RES_TO" value="<%= accountHolderDetails.get("PREV_NATION_RES_TO") != null ? accountHolderDetails.get("PREV_NATION_RES_TO") : "" %>"
										<% if(AOFDisabledFiledsMap.isFieldDisabled("PREV_NATION_RES_TO")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>></td>
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
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> class="red" <%} %>>ID Type</td>
						<td>
							<table width="100%">
								<tr>
									<td>
										<input type="radio" name="ID_TYPE" id="IDtypenic" value="1" <% 
										if("1".equals(accountHolderDetails.get("ID_TYPE"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ID_TYPE")%>')" <%} %>>
										<label for="IDtypenic">NIC</label>
									</td>
									<td>
										<input type="radio" name="ID_TYPE" id="IDtypepassport" value="2" <% if("2".equals(accountHolderDetails.get("ID_TYPE"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ID_TYPE")%>')" <%} %>> 
										<label for="IDtypepassport">Passport</label>
									</td>
									<td>
										<input type="radio" name="ID_TYPE" id="IDtypedrivinglicense" value="3" <% if("3".equals(accountHolderDetails.get("ID_TYPE"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ID_TYPE")%>')" <%} %>> 
										<label for="IDtypedrivinglicense">Driving License</label>
									</td>
									<td>
										<input type="radio" name="ID_TYPE" id="IDtypeOther" value="4" <% if("4".equals(accountHolderDetails.get("ID_TYPE"))){ %> checked="checked" <%} %>
										<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ID_TYPE")%>')" <%} %>>
										<label for="IDtypeOther">
											Other: <input type="text" name="ID_TYPE_OTR" class="input-ovr"
											<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_TYPE")){ %> readonly="readonly" <%} %>
											<% if("4".equals(accountHolderDetails.get("ID_TYPE"))){ %> 
												value="<%= accountHolderDetails.get("ID_TYPE_OTR") != null ? accountHolderDetails.get("ID_TYPE_OTR") : "" %>"
											<%} %>
										/>
										</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_NO")){ %> class="red" <%} %>>No</td>
						<td><input type="text" name="ID_NO"
							class="form-control input-sm" value="<%= accountHolderDetails.get("ID_NO") != null ? accountHolderDetails.get("ID_NO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_NO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_ISSUE_DATE")){ %> class="red" <%} %>>Date of Issue</td>
						<td><input type="text" name="ID_ISSUE_DATE" value="<%= accountHolderDetails.get("ID_ISSUE_DATE") != null ? accountHolderDetails.get("ID_ISSUE_DATE") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_ISSUE_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ID_EXPIR_DATE")){ %> class="red" <%} %>>Date of Expiry</td>
						<td><input type="text" name="ID_EXPIR_DATE" value="<%= accountHolderDetails.get("ID_EXPIR_DATE") != null ? accountHolderDetails.get("ID_EXPIR_DATE") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ID_EXPIR_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>></td>
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
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_DATE")){ %> class="red" <%} %>>Date</td>
						<td><input type="text" name="BIRTH_DATE" value="<%= accountHolderDetails.get("BIRTH_DATE") != null ? accountHolderDetails.get("BIRTH_DATE") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_DATE")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_PLACE")){ %> class="red" <%} %>>Place</td>
						<td><input type="text" name="BIRTH_PLACE"
							class="form-control input-sm" value="<%= accountHolderDetails.get("BIRTH_PLACE") != null ? accountHolderDetails.get("BIRTH_PLACE") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("BIRTH_PLACE")){ %> readonly="readonly" <%} %>></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Permanent Address / Registered Business Address</td>
			<td>
				<table width="100%">
					<tr>
						<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_1")){ %> class="red" <%} %>>AddressLine1</td>
						<td width="85%"><input type="text" name="ADDRESS_LINE_1"
							class="form-control input-sm"  value="<%= accountHolderDetails.get("ADDRESS_LINE_1") != null ? accountHolderDetails.get("ADDRESS_LINE_1") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_1")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_2")){ %> class="red" <%} %>>AddressLine2</td>
						<td><input type="text" name="ADDRESS_LINE_2"
							class="form-control input-sm" value="<%= accountHolderDetails.get("ADDRESS_LINE_2") != null ? accountHolderDetails.get("ADDRESS_LINE_2") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_2")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_3")){ %> class="red" <%} %>>AddressLine3</td>
						<td><input type="text" name="ADDRESS_LINE_3"
							class="form-control input-sm" value="<%= accountHolderDetails.get("ADDRESS_LINE_3") != null ? accountHolderDetails.get("ADDRESS_LINE_3") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ADDRESS_LINE_3")){ %> readonly="readonly" <%} %>></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PREM_ADDRESS_STATUS")){ %> class="red" <%} %>>Status of Permanent Address (Premises)</td>
			<td><select name="PREM_ADDRESS_STATUS" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("PREM_ADDRESS_STATUS")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("PREM_ADDRESS_STATUS")%>')" <%} %>>
					<option value=""></option>
					<option value="1" <% if("1".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %> >Owner</option>
					<option value="2" <% if("2".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %>>Rent/Lease</option>
					<option value="3" <% if("3".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %>>Friends/Relatives</option>
					<option value="4" <% if("4".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %>>Parents</option>
					<option value="5" <% if("5".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %>>Official</option>
					<option value="6" <% if("6".equals(accountHolderDetails.get("PREM_ADDRESS_STATUS"))){ %> selected="selected" <%} %>>Boarding/Lodging</option>
			</select></td>
		</tr>
		<tr>
			<td>Correspondence Address</td>
			<td>
				<table width="100%">
					<tr>
						<td width="15%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_1")){ %> class="red" <%} %>>AddressLine1</td>
						<td width="85%"><input type="text" name="CORS_ADDRESS_LINE_1" 
							class="form-control input-sm" value="<%= accountHolderDetails.get("CORS_ADDRESS_LINE_1") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_1") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_1")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_2")){ %> class="red" <%} %>>AddressLine2</td>
						<td><input type="text" name="CORS_ADDRESS_LINE_2"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CORS_ADDRESS_LINE_2") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_2") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_2")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_3")){ %> class="red" <%} %>>AddressLine3</td>
						<td><input type="text" name="CORS_ADDRESS_LINE_3"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CORS_ADDRESS_LINE_3") != null ? accountHolderDetails.get("CORS_ADDRESS_LINE_3") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CORS_ADDRESS_LINE_3")){ %> readonly="readonly" <%} %>></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("REG_NUMBER")){ %> class="red" <%} %>>Registration Number</td>
			<td><input type="text" class="form-control input-sm" name="REG_NUMBER" value="<%= accountHolderDetails.get("REG_NUMBER") != null ? accountHolderDetails.get("REG_NUMBER") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("REG_NUMBER")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_TIN_NO")){ %> class="red" <%} %>>Tax File / TIN No.</td>
			<td><input type="text" class="form-control input-sm" name="TAX_TIN_NO" value="<%= accountHolderDetails.get("TAX_TIN_NO") != null ? accountHolderDetails.get("TAX_TIN_NO") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_TIN_NO")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td>Contact No</td>
			<td>
				<table>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_RES_NO")){ %> class="red" <%} %>>Residence</td>
						<td><input type="text" name="CONTACT_RES_NO"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CONTACT_RES_NO") != null ? accountHolderDetails.get("CONTACT_RES_NO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_RES_NO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_OFF_NO")){ %> class="red" <%} %>>Office</td>
						<td><input type="text" name="CONTACT_OFF_NO"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CONTACT_OFF_NO") != null ? accountHolderDetails.get("CONTACT_OFF_NO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_OFF_NO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_MOB_NO")){ %> class="red" <%} %>>Mobile</td>
						<td><input type="text" name="CONTACT_MOB_NO"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CONTACT_MOB_NO") != null ? accountHolderDetails.get("CONTACT_MOB_NO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_MOB_NO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_FAX_NO")){ %> class="red" <%} %>>Fax</td>
						<td><input type="text" name="CONTACT_FAX_NO"
							class="form-control input-sm" value="<%= accountHolderDetails.get("CONTACT_FAX_NO") != null ? accountHolderDetails.get("CONTACT_FAX_NO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CONTACT_FAX_NO")){ %> readonly="readonly" <%} %>></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMAIL")){ %> class="red" <%} %>>E-mail Adress</td>
			<td><input type="text" name="EMAIL" class="form-control input-sm"  value="<%= accountHolderDetails.get("EMAIL") != null ? accountHolderDetails.get("EMAIL") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("EMAIL")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("WEBSITE")){ %> class="red" <%} %>>Website</td>
			<td><input type="text" name="WEBSITE" class="form-control input-sm"  value="<%= accountHolderDetails.get("WEBSITE") != null ? accountHolderDetails.get("WEBSITE") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("WEBSITE")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td>Key Contact Person Details</td>
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
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> class="red" <%} %>>Name</td>
								<td><input type="text" name="KEY_CONTACT_1_NAME" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_NAME") != null ? keyContact.get("KEY_CONTACT_NAME") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> readonly="readonly" <%} %>></td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> class="red" <%} %>>Designation</td>
								<td><input type="text" name="KEY_CONTACT_1_DESG" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_DESG") != null ? keyContact.get("KEY_CONTACT_DESG") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> readonly="readonly" <%} %>></td>
							</tr>
							<tr>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> class="red" <%} %>>Tel No.</td>
								<td><input type="text" name="KEY_CONTACT_1_TEL" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_TEL") != null ? keyContact.get("KEY_CONTACT_TEL") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> readonly="readonly" <%} %>></td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> class="red" <%} %>>Mobile No.</td>
								<td><input type="text" name="KEY_CONTACT_1_MOB" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_MOB") != null ? keyContact.get("KEY_CONTACT_MOB") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> readonly="readonly" <%} %>></td>
							</tr>
							<tr>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> class="red" <%} %>>Email Address</td>
								<td><input type="text" name="KEY_CONTACT_1_EMAIL" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_EMAIL") != null ? keyContact.get("KEY_CONTACT_EMAIL") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> readonly="readonly" <%} %>></td>
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_IDNO")){ %> class="red" <%} %>>ID No.</td>
								<td><input type="text" name="KEY_CONTACT_1_IDNO" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_IDNO") != null ? keyContact.get("KEY_CONTACT_IDNO") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_IDNO")){ %> readonly="readonly" <%} %>></td>
							</tr>
							<tr style="border-bottom: 1px solid black;">
								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_COMMENTS")){ %> class="red" <%} %>>Comments</td>
								<td colspan="3"><input type="text" name="KEY_CONTACT_1_COMMENTS" class="form-control input-sm" value="<%= keyContact.get("KEY_CONTACT_COMMENTS") != null ? keyContact.get("KEY_CONTACT_COMMENTS") : "" %>"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_COMMENTS")){ %> readonly="readonly" <%} %>></td>
							</tr>
						<%}%>
					</table>
				<%}else{%>
					No Key Contact Details Found
				<%}%>
				
				<!--
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> class="red" <%} %>>Name</td>
						<td><input type="text" name="KEY_CONTACT_1_NAME" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_NAME") != null ? accountHolderDetails.get("KEY_CONTACT_1_NAME") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_NAME")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> class="red" <%} %>>Designation</td>
						<td><input type="text" name="KEY_CONTACT_1_DESG" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_DESG") != null ? accountHolderDetails.get("KEY_CONTACT_1_DESG") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_DESG")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> class="red" <%} %>>Tel No.</td>
						<td><input type="text" name="KEY_CONTACT_1_TEL" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_TEL") != null ? accountHolderDetails.get("KEY_CONTACT_1_TEL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_TEL")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> class="red" <%} %>>Mobile No.</td>
						<td><input type="text" name="KEY_CONTACT_1_MOB" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_MOB") != null ? accountHolderDetails.get("KEY_CONTACT_1_MOB") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_MOB")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> class="red" <%} %>>Email Address</td>
						<td><input type="text" name="KEY_CONTACT_1_EMAIL" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_EMAIL") != null ? accountHolderDetails.get("KEY_CONTACT_1_EMAIL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_EMAIL")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_IDNO")){ %> class="red" <%} %>>ID No.</td>
						<td><input type="text" name="KEY_CONTACT_1_IDNO" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_IDNO") != null ? accountHolderDetails.get("KEY_CONTACT_1_IDNO") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_IDNO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr style="border-bottom: 1px solid black;">
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_COMMENTS")){ %> class="red" <%} %>>Comments</td>
						<td colspan="3"><input type="text" name="KEY_CONTACT_1_COMMENTS" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_1_COMMENTS") != null ? accountHolderDetails.get("KEY_CONTACT_1_COMMENTS") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_1_COMMENTS")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_NAME")){ %> class="red" <%} %>>Name</td>
						<td><input type="text" name="KEY_CONTACT_2_NAME" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_NAME") != null ? accountHolderDetails.get("KEY_CONTACT_2_NAME") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_NAME")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_DESG")){ %> class="red" <%} %>>Designation</td>
						<td><input type="text" name="KEY_CONTACT_2_DESG" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_DESG") != null ? accountHolderDetails.get("KEY_CONTACT_2_DESG") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_DESG")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_TEL")){ %> class="red" <%} %>>Tel No.</td>
						<td><input type="text" name="KEY_CONTACT_2_TEL" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_TEL") != null ? accountHolderDetails.get("KEY_CONTACT_2_TEL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_TEL")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_MOB")){ %> class="red" <%} %>>Mobile No.</td>
						<td><input type="text" name="KEY_CONTACT_2_MOB" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_MOB") != null ? accountHolderDetails.get("KEY_CONTACT_2_MOB") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_MOB")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_EMAIL")){ %> class="red" <%} %>>Email Address</td>
						<td><input type="text" name="KEY_CONTACT_2_EMAIL" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_EMAIL") != null ? accountHolderDetails.get("KEY_CONTACT_2_EMAIL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_EMAIL")){ %> readonly="readonly" <%} %>></td>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_IDNO")){ %> class="red" <%} %>>ID No.</td>
						<td><input type="text" name="KEY_CONTACT_2_IDNO" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_IDNO") != null ? accountHolderDetails.get("KEY_CONTACT_2_IDNO") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_IDNO")){ %> readonly="readonly" <%} %>></td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_COMMENTS")){ %> class="red" <%} %>>Comments</td>
						<td colspan="3"><input type="text" name="KEY_CONTACT_2_COMMENTS" class="form-control input-sm" value="<%= accountHolderDetails.get("KEY_CONTACT_2_COMMENTS") != null ? accountHolderDetails.get("KEY_CONTACT_2_COMMENTS") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("KEY_CONTACT_2_COMMENTS")){ %> readonly="readonly" <%} %>></td>
					</tr>
				</table>
				-->
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OCCUPATION")){ %> class="red" <%} %>>Occupation</td>
			<td><input type="text" name="OCCUPATION" class="form-control input-sm"  value="<%= accountHolderDetails.get("OCCUPATION") != null ? accountHolderDetails.get("OCCUPATION") : "" %>" 
			<% if(AOFDisabledFiledsMap.isFieldDisabled("OCCUPATION")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DESIGNATION")){ %> class="red" <%} %>>Designation</td>
			<td><input type="text" name="DESIGNATION" class="form-control input-sm"  value="<%= accountHolderDetails.get("DESIGNATION") != null ? accountHolderDetails.get("DESIGNATION") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("DESIGNATION")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OWNERSHIP_PER")){ %> class="red" <%} %>>Ownership Percentage (%)</td>
			<td><input type="text" name="OWNERSHIP_PER" class="input-ovr"  value="<%= accountHolderDetails.get("OWNERSHIP_PER") != null ? accountHolderDetails.get("OWNERSHIP_PER") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("OWNERSHIP_PER")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_NAME")){ %> class="red" <%} %>>Name of Employer (Please mention if Self Employed)</td>
			<td><input type="text" name="EMPLOYER_NAME" class="form-control input-sm"  value="<%= accountHolderDetails.get("EMPLOYER_NAME") != null ? accountHolderDetails.get("EMPLOYER_NAME") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_NAME")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td>Employment Period</td>
			<td>
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_FROM")){ %> class="red" <%} %>>
							From
						</td>
						<td>
							<input type="text" name="EMPLOYMENT_FROM" value="<%= accountHolderDetails.get("EMPLOYMENT_FROM") != null ? accountHolderDetails.get("EMPLOYMENT_FROM") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_FROM")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>/>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_TO")){ %> class="red" <%} %>>
							To
						</td>
						<td>
							<input type="text" name="EMPLOYMENT_TO" class="input-ovr datepicker"  value="<%= accountHolderDetails.get("EMPLOYMENT_TO") != null ? accountHolderDetails.get("EMPLOYMENT_TO") : "" %>"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYMENT_TO")){ %> readonly="readonly" class="input-ovr" <%}else{ %> class="datepicker input-ovr" <% } %>/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_ADDRESS")){ %> class="red" <%} %>>Address of Employer</td>
			<td><input type="text" name="EMPLOYER_ADDRESS" class="form-control input-sm"  value="<%= accountHolderDetails.get("EMPLOYER_ADDRESS") != null ? accountHolderDetails.get("EMPLOYER_ADDRESS") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("EMPLOYER_ADDRESS")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("NATURE_OF_BUSINESS")){ %> class="red" <%} %>>Nature of business</td>
			<td><input type="text" name="NATURE_OF_BUSINESS" class="form-control input-sm"  value="<%= accountHolderDetails.get("NATURE_OF_BUSINESS") != null ? accountHolderDetails.get("NATURE_OF_BUSINESS") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("NATURE_OF_BUSINESS")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<%
			if(!"4".equals(accountHolderDetails.get("CIF_TYPE"))) {
		%>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")){ %> class="red" <%} %>>Income Details (Rs.)</td>
			<td>
			<select class="form-control input-sm" name="INCOME_DET" <% if(AOFDisabledFiledsMap.isFieldDisabled("INCOME_DET")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("INCOME_DET")%>')" <%} %>>
					<option value=""></option>
					<option value="1" <% if("1".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>Less than 14,999</option>
					<option value="2" <% if("2".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>15,000 - 24,999</option>
					<option value="3" <% if("3".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>25,000 - 39,999</option>
					<option value="4" <% if("4".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>40,000 - 59,999</option>
					<option value="5" <% if("5".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>60,000 - 79,999</option>
					<option value="6" <% if("6".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>80,000 - 99,999</option>
					<option value="7" <% if("7".equals(accountHolderDetails.get("INCOME_DET"))){ %> selected="selected" <%} %>>100,000 and above</option>
			</select>
			</td>
		</tr>
		<%}%>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PUBLIC_POSITION_HELD")){ %> class="red" <%} %>>Public Positions Held</td>
			<td><input type="text" name="PUBLIC_POSITION_HELD" class="form-control input-sm"  value="<%= accountHolderDetails.get("PUBLIC_POSITION_HELD") != null ? accountHolderDetails.get("PUBLIC_POSITION_HELD") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("PUBLIC_POSITION_HELD")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_CONN_BUSINESS")){ %> class="red" <%} %>>Other Connected Business or Professional Activities</td>
			<td><input type="text" name="OTHER_CONN_BUSINESS" class="form-control input-sm"  value="<%= accountHolderDetails.get("OTHER_CONN_BUSINESS") != null ? accountHolderDetails.get("OTHER_CONN_BUSINESS") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_CONN_BUSINESS")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_NAME")){ %> class="red" <%} %>>Name of Spouse</td>
			<td><input type="text" name="SPOUSE_NAME" class="form-control input-sm"  value="<%= accountHolderDetails.get("SPOUSE_NAME") != null ? accountHolderDetails.get("SPOUSE_NAME") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_NAME")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_EMP_DESG")){ %> class="red" <%} %>>Employer of Spouse and Designation</td>
			<td><input type="text" name="SPOUSE_EMP_DESG" class="form-control input-sm"  value="<%= accountHolderDetails.get("SPOUSE_EMP_DESG") != null ? accountHolderDetails.get("SPOUSE_EMP_DESG") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("SPOUSE_EMP_DESG")){ %> readonly="readonly" <%} %>/></td>
		</tr>
		<tr>
			<td width="25%">Assets held by the Account Holder & their Market
				Value</td>
			<td width="75%">
				<table>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_RES_PROP" id="assets1" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_RES_PROP"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_RES_PROP")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ASSET_RES_PROP")%>')" <%} %>> 
							<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_RES_PROP")){ %> class="red" <%} %> for="assets1">Residential Property</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_RES_PROP_VAL" value="<%= accountHolderDetails.get("ASSET_RES_PROP_VAL") != null ? accountHolderDetails.get("ASSET_RES_PROP_VAL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_RES_PROP_VAL")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_MOTOR_VECH" id="assets2" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_MOTOR_VECH"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_MOTOR_VECH")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ASSET_MOTOR_VECH")%>')" <%} %>> 
							<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_MOTOR_VECH")){ %> class="red" <%} %> for="assets2">Motor Vehicles</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_MOTOR_VECH_VAL" value="<%= accountHolderDetails.get("ASSET_MOTOR_VECH_VAL") != null ? accountHolderDetails.get("ASSET_MOTOR_VECH_VAL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_MOTOR_VECH_VAL")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_LAND_BUILD" id="assets3" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_LAND_BUILD"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_LAND_BUILD")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ASSET_LAND_BUILD")%>')" <%} %>> 
							<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_LAND_BUILD")){ %> class="red" <%} %> for="assets3">Land and Buildings</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_LAND_BUILD_VAL" value="<%= accountHolderDetails.get("ASSET_LAND_BUILD_VAL") != null ? accountHolderDetails.get("ASSET_LAND_BUILD_VAL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_LAND_BUILD_VAL")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_INSVT_SHARES" id="assets4" value="Y" <% if("Y".equals(accountHolderDetails.get("ASSET_INSVT_SHARES"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_INSVT_SHARES")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ASSET_INSVT_SHARES")%>')" <%} %>> 
							<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_INSVT_SHARES")){ %> class="red" <%} %> for="assets4">Investments / Shares</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_INSVT_SHARES_VAL" value="<%= accountHolderDetails.get("ASSET_INSVT_SHARES_VAL") != null ? accountHolderDetails.get("ASSET_INSVT_SHARES_VAL") : "" %>"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_INSVT_SHARES_VAL")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>> 
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="ASSET_OTHER_name" id="assets5" value="Y" <% if(accountHolderDetails.get("ASSET_OTHER") != null && accountHolderDetails.get("ASSET_OTHER") != ""){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_OTHER")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("ASSET_OTHER")%>')" <%} %>> 
							<label <% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_OTHER")){ %> class="red" <%} %> for="assets5"> 
								Other : <input type="text" name="ASSET_OTHER"
								<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_OTHER")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
								<% if(accountHolderDetails.get("ASSET_OTHER") != null && accountHolderDetails.get("ASSET_OTHER") != ""){ %>
									value="<%=accountHolderDetails.get("ASSET_OTHER")%>"
								<%} %>
								/>
							</label>
						</td>
						<td>Rs. <input type="text" name="ASSET_OTHER_VAL"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("ASSET_OTHER")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
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
				<ul class="inlineUL">
					<li>
						<input type="radio" name="TAX_PAYER" id="taxPayerN" value="N"  <% if("N".equals(accountHolderDetails.get("TAX_PAYER"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_PAYER")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TAX_PAYER")%>')" <%} %>> 
						<label for="taxPayerN">No</label>
					</li>
					<li>
						<input type="radio" name="TAX_PAYER" id="taxPayerY" value="Y" <% if("Y".equals(accountHolderDetails.get("TAX_PAYER"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_PAYER")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TAX_PAYER")%>')" <%} %>> 
						<label for="taxPayerY">Yes</label> 
						<br />
						Income Tax File No : <input type="text" name="TAX_FILE_NO"
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_PAYER")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
						<% if("Y".equals(accountHolderDetails.get("TAX_PAYER"))){ %>
						 value="<%= accountHolderDetails.get("TAX_FILE_NO") != null ? accountHolderDetails.get("TAX_FILE_NO") : "" %>"
						<%} %>
						/>
					</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_DECLR_SUBMITTED")){ %> class="red" <%} %>>Declaration Submitted</td>
			<td>
				<ul class="inlineUL">
					<li>
						<input type="radio" name="TAX_DECLR_SUBMITTED" id="declarationSubmittedY" value="Y" <% if("Y".equals(accountHolderDetails.get("TAX_DECLR_SUBMITTED"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_DECLR_SUBMITTED")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TAX_DECLR_SUBMITTED")%>')" <%} %>> 
						<label for="declarationSubmittedY">Yes</label>
					</li>
					<li>
						<input type="radio" name="TAX_DECLR_SUBMITTED" id="declarationSubmittedN" value="N" <% if("N".equals(accountHolderDetails.get("TAX_DECLR_SUBMITTED"))){ %> checked="checked" <%} %>
						<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_DECLR_SUBMITTED")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("TAX_DECLR_SUBMITTED")%>')" <%} %>> 
						<label for="declarationSubmittedN">NO</label>
					</li>
				</ul>
				<ul class="inlineUL">
					<li>for Tax Year: <input type="text" name="TAX_DECLR_SUBMITTED_YEAR" 
					<% if(AOFDisabledFiledsMap.isFieldDisabled("TAX_DECLR_SUBMITTED")){ %> readonly="readonly" class="input-ovr bacred" <%}else{ %> class="input-ovr" <%} %>
					 <% if("Y".equals(accountHolderDetails.get("TAX_DECLR_SUBMITTED"))){ %> 
					 	value="<%= accountHolderDetails.get("TAX_DECLR_SUBMITTED_YEAR") != null ? accountHolderDetails.get("TAX_DECLR_SUBMITTED_YEAR") : "" %>"
					 <%} %>
					/>
					</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td width="45%" <% if(AOFDisabledFiledsMap.isFieldDisabled("DUAL_CITIZEN")){ %> class="red" <%} %>>Are you a Permanent Resident (Green card Holder)
				or a Dual Citizen of another country?</td>
			<td width="55%">
				<table width="100%">
					<tr>
						<td>
							<input type="radio" name="DUAL_CITIZEN" id="dualCitizenShipY" value="Y" <% if("Y".equals(accountHolderDetails.get("DUAL_CITIZEN"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("DUAL_CITIZEN")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("DUAL_CITIZEN")%>')" <%} %>> 
							<label for="dualCitizenShipY"> Yes. Specify Country </label>
						</td>
						<td>
							<select name="DUAL_CITIZEN_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("DUAL_CITIZEN_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("DUAL_CITIZEN_NATION_CODE")%>')" <%} %>>
								<option value=""></option>
								<%
								countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
								%>
								<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("DUAL_CITIZEN_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
								<%
								}
								%>	
							</select>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="radio" name="DUAL_CITIZEN" id="dualCitizenShipN" value="N" <% if("N".equals(accountHolderDetails.get("DUAL_CITIZEN"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("DUAL_CITIZEN")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("DUAL_CITIZEN")%>')" <%} %>> 
							<label for="dualCitizenShipN">No</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("REGULR_TRVL_RIMIT")){ %> class="red" <%} %>>DO you regularly travel, send or receive remittance to/from
				a foreign country/ies?</td>
			<td>
				<table width="100%">
					<tr>
						<td>
							<input type="radio" name="REGULR_TRVL_RIMIT" id="regularTravelRemitY" value="Y" <% if("Y".equals(accountHolderDetails.get("REGULR_TRVL_RIMIT"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("REGULR_TRVL_RIMIT")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("REGULR_TRVL_RIMIT")%>')" <%} %>> 
							<label for="regularTravelRemitY"> Yes. Specify Country </label>
						</td>
						<td>
							<select name="REGULR_TRVL_RIMIT_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("REGULR_TRVL_RIMIT_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("REGULR_TRVL_RIMIT_NATION_CODE")%>')" <%} %>>
								<option value=""></option>
								<%
								countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
								%>
								<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("REGULR_TRVL_RIMIT_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
								<%
								}
								%>	
							</select>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="radio" name="REGULR_TRVL_RIMIT" id="regularTravelRemitN" value="N" <% if("N".equals(accountHolderDetails.get("REGULR_TRVL_RIMIT"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("REGULR_TRVL_RIMIT")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("REGULR_TRVL_RIMIT")%>')" <%} %>> 
							<label for="regularTravelRemitN">No</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("FRGN_PWR_ATRNY")){ %> class="red" <%} %>>Have you granted a Power of Attorney to a person from a
				foreign country?</td>
			<td>
				<table width="100%">
					<tr>
						<td>
							<input type="radio" name="FRGN_PWR_ATRNY" id="foreignPowerOfAttorneyY" value="Y" <% if("Y".equals(accountHolderDetails.get("FRGN_PWR_ATRNY"))){ %> checked="checked" <%} %>>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("FRGN_PWR_ATRNY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("FRGN_PWR_ATRNY")%>')" <%} %> 
							<label for="foreignPowerOfAttorneyY"> Yes. Specify Country </label>
						</td>
						<td>
							<select name="FRGN_PWR_ATRNY_NATION_CODE" class="form-control input-sm" <% if(AOFDisabledFiledsMap.isFieldDisabled("FRGN_PWR_ATRNY_NATION_CODE")){ %> onchange="return forceCheckSelect(this,'<%=accountHolderDetails.get("FRGN_PWR_ATRNY_NATION_CODE")%>')" <%} %>>
								<option value=""></option>
								<%
								countryItr = allCountries.keySet().iterator();
								while(countryItr.hasNext()){
									String countryCode = countryItr.next();
									String countryName = allCountries.get(countryCode);
								%>
								<option value="<%=countryCode%>" <% if(countryCode.equals(accountHolderDetails.get("FRGN_PWR_ATRNY_NATION_CODE"))){ %> selected="selected" <%} %>><%=countryName%></option>
								<%
								}
								%>	
							</select>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="radio" name="FRGN_PWR_ATRNY" id="foreignPowerOfAttorneyN" value="N" <% if("N".equals(accountHolderDetails.get("FRGN_PWR_ATRNY"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("FRGN_PWR_ATRNY")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("FRGN_PWR_ATRNY")%>')" <%} %>> 
							<label for="foreignPowerOfAttorneyN">No</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("PUR_IN_SL")){ %> class="red" <%} %>>If foreign citizen please specify the purpose of opening the
				account in Sri Lanka</td>
			<td><input type="text" name="PUR_IN_SL" class="form-control input-sm" value="<%= accountHolderDetails.get("PUR_IN_SL") != null ? accountHolderDetails.get("PUR_IN_SL") : "" %>"
			<% if(AOFDisabledFiledsMap.isFieldDisabled("PUR_IN_SL")){ %> readonly="readonly" <%} %>></td>
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
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_NO_1" value="<%= accountHolderDetails.get("EXIST_BANK_ACC_NO_1") != null ? accountHolderDetails.get("EXIST_BANK_ACC_NO_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana11" value="SA" <% if("SA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana11">Savings Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana12" value="CA" <% if("CA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana12">Current Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana13" value="TD" <% if("TD".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana13">Term Deposite</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_1" id="existingAccountTypeAmana14" value="OT" <% if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana14">
				    													Other: <input type="text" name="EXIST_BANK_ACC_TYPE_1_OTR" class="input-ovr"
				    													<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1"))){ %>
							    											value="<%= accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1_OTR") != null ? accountHolderDetails.get("EXIST_BANK_ACC_TYPE_1_OTR") : "" %>"
							    										<% }%>
							    										/>
				    												</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_BRANCH_1" value="<%= accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_1") != null ? accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_NO_2" value="<%= accountHolderDetails.get("EXIST_BANK_ACC_NO_2") != null ? accountHolderDetails.get("EXIST_BANK_ACC_NO_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana21" value="SA" <% if("SA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana21">Savings Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana22" value="CA" <% if("CA".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana22">Current Account</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana23" value="TD" <% if("TD".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana23">Term Deposite</label>
				    											</td>
				    											<td>
				    												<input type="radio" name="EXIST_BANK_ACC_TYPE_2" id="existingAccountTypeAmana24" value="OT" <% if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %> checked="checked" <% }%>
				    												<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2")%>')" <%} %>>
				    												<label for="existingAccountTypeAmana24">
				    													Other: <input type="text" name="EXIST_BANK_ACC_TYPE_2_OTR" class="input-ovr"
				    													<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    											value="<%= accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2_OTR") != null ? accountHolderDetails.get("EXIST_BANK_ACC_TYPE_2_OTR") : "" %>"
							    										<% }%>
							    										/>
				    												</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_BANK_ACC_BRANCH_2" value="<%= accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_2") != null ? accountHolderDetails.get("EXIST_BANK_ACC_BRANCH_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %> readonly="readonly" <%} %>/></td>
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
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_NO_1"  value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_NO_1") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_NO_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_1")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
							    							<tr>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther11" value="SA" <% if("SA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther11">Savings Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther12" value="CA" <% if("CA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther12">Current Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther13" value="TD" <% if("TD".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther13">Term Deposite</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_1" id="existingAccountTypeOther14" value="OT" <% if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1")%>')" <%} %>>
							    									<label for="existingAccountTypeOther14">
							    										Other: <input type="text" name="EXIST_OTHER_ACC_TYPE_1_OTR" class="input-ovr"
							    										<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
							    											value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1_OTR") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_1_OTR") : "" %>"
							    										<% }%>
							    										/>
							    									</label>
							    								</td>
							    							</tr>
							    						</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_BRANCH_1" value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_1") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_1") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %> readonly="readonly" <%} %>/>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_NO_2" value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_NO_2") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_NO_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %> readonly="readonly" <%} %>/></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
				    									<table width="100%">
							    							<tr>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther21" value="SA" <% if("SA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther21">Savings Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther22" value="CA" <% if("CA".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther22">Current Account</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther23" value="TD" <% if("TD".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther23">Term Deposite</label>
							    								</td>
							    								<td>
							    									<input type="radio" name="EXIST_OTHER_ACC_TYPE_2" id="existingAccountTypeOther24" value="OT" <% if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %> checked="checked" <% }%>
							    									<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> onclick="return forceCheck(this,'<%=accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2")%>')" <%} %>>
							    									<label for="existingAccountTypeOther24">
							    										Other: <input type="text" name="EXIST_OTHER_ACC_TYPE_2_OTR" class="input-ovr"
							    										<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %> readonly="readonly" <%} %>
							    										<% if("OT".equals(accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
							    											value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2_OTR") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_TYPE_2_OTR") : "" %>"
							    										<% }%>
							    										/>
							    									</label>
							    								</td>
							    							</tr>
							    						</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><input type="text" class="form-control input-sm" name="EXIST_OTHER_ACC_BRANCH_2" value="<%= accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_2") != null ? accountHolderDetails.get("EXIST_OTHER_ACC_BRANCH_2") : "" %>"
				    								<% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %> readonly="readonly" <%} %>/></td>
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
<% if(canEdit.equals("Y")){ %>
<div class="modal-footer" style="background: #E6E6FA">
	<button type="submit" class="btn btn-success">Save changes</button>
	<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
</div>
<%} %>
</form>