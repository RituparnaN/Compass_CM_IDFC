<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String accountHolderType = (String) request.getAttribute("type");
String cifNo = (String) request.getAttribute("CIF");
String accountNo = (String) request.getAttribute("AccountNo");
String lineNo = (String) request.getAttribute("LineNo");
String caseNo = (String) request.getAttribute("caseNo");
String canEdit = (String) request.getAttribute("canEdit");

Map<String, String> valueAddedDetails = request.getAttribute("VALUEADDEDDETAILS") != null ? (Map<String, String>) request.getAttribute("VALUEADDEDDETAILS") : new HashMap<String, String>();
%>
<html>
<head>
<style>
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
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
</head>
<body style="z-index: 9999">
<form action="<%=contextPath%>/saveValueAddedService" method="POST">
<input type="hidden" value="<%=cifNo%>" name="CIF_NO"/>
<input type="hidden" value="<%=accountNo%>" name="ACCOUNT_NO"/>
<input type="hidden" value="<%=lineNo%>" name="LINE_NO"/>
<input type="hidden" value="<%=caseNo%>" name="CASE_NO"/>
<table class="table table-bordered table-stripped">
	<tbody>
		<tr>
			<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CARD_TYPE")){ %> class="red" <%} %>>
				card Type
			</td>
			<td width="75%">
				<table width="100%">
					<tr>
						<td>
							<input type="radio" name="CARD_TYPE" id="cardType1" value="1" <% if("1".equals(valueAddedDetails.get("CARD_TYPE"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CARD_TYPE")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("CARD_TYPE")%>')" <%} %>>
							<label for="cardType1"> VISA Debit card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						</td>
						<td>
							<input type="radio" name="CARD_TYPE" id="cardType2" value="2"  <% if("2".equals(valueAddedDetails.get("CARD_TYPE"))){ %> checked="checked" <%} %>
							<% if(AOFDisabledFiledsMap.isFieldDisabled("CARD_TYPE")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("CARD_TYPE")%>')" <%} %>>
							<label for="cardType2"> ATM card</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_ON_CARD")){ %> class="red" <%} %>>
				Name to Appear in card
			</td>
			<td>
				<input type="text" name="NAME_ON_CARD" class="form-control input-sm" value="<%= valueAddedDetails.get("NAME_ON_CARD") != null ? valueAddedDetails.get("NAME_ON_CARD") : "" %>"
				<% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_ON_CARD")){ %> readonly="readonly" <%} %>/>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_LINKED_ACCOUNT_NO")){ %> class="red" <%} %>>
				Other Accounts to be linked
			</td>
			<td>
				<input type="text" name="OTHER_LINKED_ACCOUNT_NO" class="form-control imput-sm"  value="<%= valueAddedDetails.get("OTHER_LINKED_ACCOUNT_NO") != null ? valueAddedDetails.get("OTHER_LINKED_ACCOUNT_NO") : "" %>"
				<% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_LINKED_ACCOUNT_NO")){ %> readonly="readonly" <%} %>/>
			</td>
		</tr>
		<tr>
			<td>
				E-Banking
			</td>
			<td>
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_EBANKING")){ %> class="red" <%} %>>E-Banking Enabled</td>
						<td>
							<ul class="inlineUL">
								<li>
									<input type="radio" name="ENABLE_EBANKING" id="ebankingenabledY" value="Y"  <% if("Y".equals(valueAddedDetails.get("ENABLE_EBANKING"))){ %> checked="checked" <%} %>
									<% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_EBANKING")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("ENABLE_EBANKING")%>')" <%} %>>
									<label for="ebankingenabledY">Yes</label>
								</li>
								<li>
									<input type="radio" name="ENABLE_EBANKING" id="ebankingenabledN" value="N"  <% if("N".equals(valueAddedDetails.get("ENABLE_EBANKING"))){ %> checked="checked" <%} %>
									<% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_EBANKING")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("ENABLE_EBANKING")%>')" <%} %>>
									<label for="ebankingenabledN">No</label>
								</li>
							</ul>
						</td>
					</tr>
					<tr>
						<td>UserName for E-Banking</td>
						<td>
							<table>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_1")){ %> class="red" <%} %>>1st Preference</td>
									<td><input type="text" name="EBANKING_USERNAME_1" class="form-control input-sm" value="<%= valueAddedDetails.get("EBANKING_USERNAME_1") != null ? valueAddedDetails.get("EBANKING_USERNAME_1") : "" %>"
									<% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_1")){ %> readonly="readonly" <%} %> /> </td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_2")){ %> class="red" <%} %>>2nd Preference</td>
									<td><input type="text" name="EBANKING_USERNAME_2" class="form-control input-sm" value="<%= valueAddedDetails.get("EBANKING_USERNAME_2") != null ? valueAddedDetails.get("EBANKING_USERNAME_2") : "" %>" 
									<% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_2")){ %> readonly="readonly" <%} %>/> </td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_3")){ %> class="red" <%} %>>3rd Preference</td>
									<td><input type="text" name="EBANKING_USERNAME_3" class="form-control input-sm" value="<%= valueAddedDetails.get("EBANKING_USERNAME_3") != null ? valueAddedDetails.get("EBANKING_USERNAME_3") : "" %>" 
									<% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_3")){ %> readonly="readonly" <%} %>/> </td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				SMS Alerts
			</td>
			<td>
				<table width="100%">
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> class="red" <%} %>>SMS Alerts Enabled</td>
						<td>
							<ul class="inlineUL">
								<li>
									<input type="radio" name="ENABLE_SMS_ALERT" id="smsAlertEnabledY" value="Y"  <% if("Y".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %> checked="checked" <%} %>
									<% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("ENABLE_SMS_ALERT")%>')" <%} %>>
									<label for="smsAlertEnabledY">Yes</label>
								</li>
								<li>
									<input type="radio" name="ENABLE_SMS_ALERT" id="smsAlertEnabledN" value="N"  <% if("N".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %> checked="checked" <%} %>
									<% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> onclick="return forceCheck(this,'<%=valueAddedDetails.get("ENABLE_SMS_ALERT")%>')" <%} %>>
									<label for="smsAlertEnabledN">No</label>
								</li>
							</ul>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> class="red" <%} %>>Mobile No.</td>
						<td>
							+94<input type="text" name="SMS_ALERT_MOBILE_NO" class="input-ovr"
							<% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> readonly="readonly" <%} %>
							<% if("Y".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %>
								value="<%= valueAddedDetails.get("SMS_ALERT_MOBILE_NO") != null ? valueAddedDetails.get("SMS_ALERT_MOBILE_NO") : "" %>"
							<%} %>
							/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ACC_HLDR_MOTHER_MAIDEN_NAME")){ %> class="red" <%} %>>
				Account Holder's Mother's Maiden Name
			</td>
			<td>
				<input type="text" class="form-control input-sm" name="ACC_HLDR_MOTHER_MAIDEN_NAME" value="<%= valueAddedDetails.get("ACC_HLDR_MOTHER_MAIDEN_NAME") != null ? valueAddedDetails.get("ACC_HLDR_MOTHER_MAIDEN_NAME") : "" %>"
				<% if(AOFDisabledFiledsMap.isFieldDisabled("ACC_HLDR_MOTHER_MAIDEN_NAME")){ %> readonly="readonly" <%} %>/>
			</td>
		</tr>
	</tbody>
</table>
<% if(canEdit.equals("Y")){ %>
<div class="modal-footer" style="background: #E6E6FA">
	<button type="submit" class="btn btn-success">Save changes</button>
    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
</div>
<%} %>
 </form>
 </body>
 </html>