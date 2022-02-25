<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%@page import="java.util.*"%>
<% 
String contextPath = request.getContextPath()==null?"":request.getContextPath();

LinkedHashMap l_hmReportData = null;
String l_strFurtherInfo = "";
int totalRecords = 0;
int counter = 0;
String l_strKey ="";
String LOGGEDUSER = request.getParameter("LOGGEDUSER") == null ? "AMLUser":(String)request.getParameter("LOGGEDUSER");

	
if(request.getAttribute("MatchRecords") != null)
{
	l_hmReportData = (LinkedHashMap)request.getAttribute("MatchRecords");
}

if(request.getAttribute("counter") != null)
	counter= Integer.parseInt((String)request.getAttribute("counter"));
if(l_hmReportData.get("TotalRecords") != null)
	totalRecords=((Integer)l_hmReportData.get("TotalRecords")).intValue();

%>
<HTML>
	<HEAD>
		<TITLE>
			Customer DeDup Match Details
		</TITLE>
		 
<style>
.rightMainSearch {		
		background-color: #606062;
}
.forContentSearch {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	background-color: #F2F2F1;
	padding-left: 10px;
}
.but1 {  font-size: 10px; color: #000000; text-align: center; background-color: #F2F2F1; background-repeat: no-repeat;height: 17px; width: 140px;border: 1px #000000 solid; clip:  rect(   )}
table{
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
}
</style>
</HEAD>
<BODY  bgcolor="#F2F2F1" >  
<FORM METHOD='POST'>
<%
if(l_hmReportData != null && l_hmReportData.size()>4)
	{
		String l_ColumnName [] = (String [])l_hmReportData.get("ColumnName");
		Set l_set = l_hmReportData.keySet();
		Iterator l_it = l_set.iterator();
		while(l_it.hasNext())
		{
		
					Date trialTime = new Date(); 
					l_strKey = (String)l_it.next();
					
			if(!(l_strKey.equals("ColumnName")) && !(l_strKey.equals("TotalRecords")) && !(l_strKey.equals("FileName")) && !(l_strKey.equals("FileImport")) ){
			ArrayList l_alListData  = (ArrayList)l_hmReportData.get(l_strKey);
			int l_iteration=(int)Math.ceil((double)(l_alListData.size())/11);
%>

	<B><U><font face="verdana" size="2">Source Name : <%=l_strKey.substring(l_strKey.indexOf("~")+1,l_strKey.length())%></font></U>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U><font  face="verdana" size=2 align='right'><b>Dated On : <%=trialTime%></b></U>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U></font><font  face="verdana" size=2 align='right'><b>UserCode : <%=LOGGEDUSER %> </b></U></font></B>
		<BR><BR>
   <% 
   for(int j=0;j < l_iteration;j++) {
   l_strFurtherInfo ="";	
   %>
   <TABLE id="tableid" BORDER=0 cellspacing="1" cellpadding="2" bgcolor="#606062">
   <tr><td><font face="verdana" size="2" color="white"><b>Black List Details : </b></font></td><td><font face="verdana" size="2" color="white"><B></font></td></tr>
   <% for(int i=2;i < l_ColumnName.length-2;i++) {
   if(l_ColumnName[i].toString().equals("FURTHERINFORMATION1") || l_ColumnName[i].toString().equals("FURTHERINFORMATION2") || l_ColumnName[i].toString().equals("FURTHERINFORMATION3") || l_ColumnName[i].toString().equals("FURTHERINFORMATION"))
   {
           l_strFurtherInfo = l_strFurtherInfo+l_alListData.get((j*12)+i-1);
   }
   if(!l_ColumnName[i].toString().equals("FURTHERINFORMATION1") && !l_ColumnName[i].toString().equals("FURTHERINFORMATION2") && !l_ColumnName[i].toString().equals("FURTHERINFORMATION3"))
   {     
    %>
   <TR  bordercolor="black" bgcolor="#F3E2D1">
   <TD  nowrap width='150'><font face="verdana" size="2"><%= l_ColumnName[i] %></font></TD>
    
    <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=l_alListData.get((j*11)+i-1)==null?"&nbsp;":l_ColumnName[i].toString().equals("FURTHERINFORMATION")?l_strFurtherInfo:l_alListData.get((j*11)+i-1).toString()%></b></font></TD>
   </tr>

   <%}} %>
				</table>	
				<%}}}}else{ %>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#606062">
			<tr>
			<td>
										<div class="span1">
											<font  face="verdana" size=2 align='center'><b>No Processed Records</b></font>
										</div>	
			</td>
			</tr>
		</table>
				<%}%>
				<BR><BR>
		<table border=0 width="100%"><TR>
		
					
		<TD align="center" colspan="7">
		<INPUT TYPE='button' NAME='Print' VALUE='PRINT' class="btn btn-sm btn-warning" onClick="window.print();">
		<table>
		</FORM>
	</BODY>
</HTML>
