<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
	List<Map<String, String>> accountDetails = request.getAttribute("ACCOUNTDETAILS") != null ? (List<Map<String, String>>) request.getAttribute("ACCOUNTDETAILS") : new ArrayList<Map<String, String>>();
%>

<%
	if(accountDetails.size() > 0){
%>
	<table class="table table-bordered table-striped">
		<tr>
			<th style="text-align: center;">
				<input type="checkbox" onclick="checkAll(this)"/>
			</th>
			<th>
				Customer ID
			</th>
			<th>
				Customer Name
			</th>
			<th>
				Account Number
			</th>
			<th>
				Product Code
			</th>
			<th>
				Source System
			</th>
		</tr>
		<%
		for(int i = 0; i < accountDetails.size(); i++){
			Map<String, String> account = accountDetails.get(i);
			%>
			<tr>
				<td style="text-align: center;">
					<input type="checkbox" class="accountNumberCheck" value="<%=account.get("ACCOUNTNUMBER")%>">
				</td>
				<td>
					<%=account.get("CUSTOMERID")%>
				</td>
				<td>
					<%=account.get("CUSTOMERNAME")%>
				</td>
				<td>
					<%=account.get("ACCOUNTNUMBER")%>
				</td>
				<td>
					<%=account.get("PRODUCTCODE")%>
				</td>
				<td>
					<%=account.get("SOURCESYSTEM")%>
				</td>
			</tr>
			<%
		}
		%>
	</table>
<% }else{ %>
	<center>No Account Details found for specified Customer Ids</center>
<% } %>
