<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.aml.model.AOFDisabledFiledsMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String cifNo = (String) request.getAttribute("CIF");
String accountNo = (String) request.getAttribute("AccountNo");
String lineNo = (String) request.getAttribute("LineNo");

Map<String, String> valueAddedDetails = request.getAttribute("VALUEADDEDDETAILS") != null ? (Map<String, String>) request.getAttribute("VALUEADDEDDETAILS") : new HashMap<String, String>();
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
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
	});
</script>
<input type="hidden" value="<%=cifNo%>" name="CIF_NO"/>
<input type="hidden" value="<%=accountNo%>" name="ACCOUNT_NO"/>
<input type="hidden" value="<%=lineNo%>" name="LINE_NO"/>
<table class="table table-bordered table-stripped">
	<tbody>
		<tr>
			<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CARD_TYPE")){ %> class="red" <%} %>>
				card Type
			</td>
			<td width="75%">
				<% if("1".equals(valueAddedDetails.get("CARD_TYPE"))){ %>
					VISA Debit card
				<%} if("2".equals(valueAddedDetails.get("CARD_TYPE"))){ %>
					ATM card
				<%} %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("NAME_ON_CARD")){ %> class="red" <%} %>>
				Name to Appear in card
			</td>
			<td>
				<%= valueAddedDetails.get("NAME_ON_CARD") != null ? valueAddedDetails.get("NAME_ON_CARD") : "" %>
			</td>
		</tr>
		<tr>
			<td <% if(AOFDisabledFiledsMap.isFieldDisabled("OTHER_LINKED_ACCOUNT_NO")){ %> class="red" <%} %>>
				Other Accounts to be linked
			</td>
			<td>
				<%= valueAddedDetails.get("OTHER_LINKED_ACCOUNT_NO") != null ? valueAddedDetails.get("OTHER_LINKED_ACCOUNT_NO") : "" %>
			</td>
		</tr>
		<tr>
			<td>
				E-Banking
			</td>
			<td>
				<table width="100%">
					<tr>
						<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_EBANKING")){ %> class="red" <%} %>>E-Banking Enabled?</td>
						<td width="75%">
							<% if("Y".equals(valueAddedDetails.get("ENABLE_EBANKING"))){ %>
								Yes
							<%}if("N".equals(valueAddedDetails.get("ENABLE_EBANKING"))){ %>
								No
							<%} %>
						</td>
					</tr>
					<tr>
						<td>UserName for E-Banking</td>
						<td>
							<table width="100%">
								<tr>
									<td width="45%" <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_1")){ %> class="red" <%} %>>1st Preference</td>
									<td width="55%">
										<%= valueAddedDetails.get("EBANKING_USERNAME_1") != null ? valueAddedDetails.get("EBANKING_USERNAME_1") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_2")){ %> class="red" <%} %>>2nd Preference</td>
									<td>
										<%= valueAddedDetails.get("EBANKING_USERNAME_2") != null ? valueAddedDetails.get("EBANKING_USERNAME_2") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EBANKING_USERNAME_3")){ %> class="red" <%} %>>3rd Preference</td>
									<td>
										<%= valueAddedDetails.get("EBANKING_USERNAME_3") != null ? valueAddedDetails.get("EBANKING_USERNAME_3") : "" %>
									</td>
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
							<% if("Y".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %>
								Yes
							<% }if("N".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %>
								No
							<%} %>
						</td>
					</tr>
					<tr>
						<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ENABLE_SMS_ALERT")){ %> class="red" <%} %>>Mobile No.</td>
						<td>
							<% if("Y".equals(valueAddedDetails.get("ENABLE_SMS_ALERT"))){ %>
								+94<%= valueAddedDetails.get("SMS_ALERT_MOBILE_NO") != null ? valueAddedDetails.get("SMS_ALERT_MOBILE_NO") : "" %>
							<%} %>
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
				<%= valueAddedDetails.get("ACC_HLDR_MOTHER_MAIDEN_NAME") != null ? valueAddedDetails.get("ACC_HLDR_MOTHER_MAIDEN_NAME") : "" %>
			</td>
		</tr>
	</tbody>
</table>