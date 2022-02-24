<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	String strAnnexureNo = (String)request.getAttribute("AnnCNo");
%>

<div class="header">
	<table class="header-table">
		<tr>
			<td class="leftside">
				<div class="headerText">Account Details</div>
			</td>
			<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>ACC</li>
					<li class="last"><%=strAnnexureNo%></li>-
					<li class="last">1</li>
				</ul>
			</td>
		</tr>
	</table>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
