<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	String strAnnexureNo = (String)request.getAttribute("AnnBNo");
%>
<div class="header">
	<table class="header-table">
		<tr>
			<td class="leftside">
				<div class="headerText">Legal Person/Entity Details</div>
			</td>
			<td class="rightside">
				<ul class="box rightAligned">
					<li>ANNEXURE</li>
					<li>LPE</li>
					<li class="last"><%=strAnnexureNo%></li>
				</ul>
			</td>
		</tr>
	</table>
</div>
<% }catch(Exception e){e.printStackTrace();} %>