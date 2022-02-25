<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%@page import="java.util.*"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
ArrayList l_List=null;
String Listname = null;
String l_strFurtherInfo ="";
	if(request.getAttribute("BlackListDetails") != null)
		l_List = (ArrayList)request.getAttribute("BlackListDetails");
	if(request.getAttribute("listname") != null)
		Listname = (String)request.getAttribute("listname");
		
String l_strRegulatoryListName = "";	
String ListId = (String)request.getAttribute("listid");

String l_strNewListName = Listname ;
String l_strRank = "0";
if(Listname.indexOf("^") > 0) 
{	
l_strNewListName = Listname.substring(0,Listname.indexOf("^"));
l_strRank = Listname.substring(Listname.indexOf("~")+1,Listname.length());
}

%>

<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

   		 
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

</style>
<script>
function Export(type)
{
   window.open('/showBlackListDetails?listname=<%=Listname%>&listid=<%=ListId%>&ViewType='+type,'BlacklistPDF','') 
}
</script>

  </head>
  
  <body  bgcolor="#F2F2F1" topmargin="0" leftmargin="0">

<table width="100%" height="100%" align="center" valign="top" border="0" cellpadding="4" cellspacing="2">
<tr valign="middle">
  <th align="left" class="rightMainSearch" scope="col">
  <table width="100%" height="100%"  border="0" cellpadding="10" cellspacing="0">      
  <tr>
    <th align="left" valign="top" class="forContentSearch" scope="row">
    <form name='BlackListDetail' method='Post'>
   
   <% if(l_List == null || l_List.size() < 2 ) { %>
   <BR>
		<table BORDER=1 cellspacing="1" cellpadding="1">
		<tr bordercolor="black"><td align=center><B> NO Records To Display </B></tr></table>
   <% } else { 
   String l_Column_Name [] =(String []) l_List.get(0);
    %>
   <BR>
   <TABLE id="tableid" BORDER=0 cellspacing="1" cellpadding="2" bgcolor="#606062">
   <tr><td><font face="verdana" size="2" color="white"><b>Black List Details : </b></font></td><td><font face="verdana" size="2" color="white"><B><%=Listname==null?"&nbsp;":l_strNewListName%></font></td></tr>
  <%
  if(!Listname.equals("NonCustomer"))
  {
  %>
   <tr><td><font face="verdana" size="2" color="white"><b>MatchScore : </b></font></td><td><font face="verdana" size="2" color="white"><B><%=Listname==null?"&nbsp;":l_strRank%></font></td></tr>
  <%}%>

   <%for(int i=0;i < l_Column_Name.length;i++) {
   if(l_Column_Name[i].toString().equals("FURTHERINFORMATION1") || l_Column_Name[i].toString().equals("FURTHERINFORMATION2") || l_Column_Name[i].toString().equals("FURTHERINFORMATION3") || l_Column_Name[i].toString().equals("FURTHERINFORMATION"))
   {
           l_strFurtherInfo = l_strFurtherInfo+(l_List.get(i+1)==null?"":l_List.get(i+1).toString());
   }
   if(!l_Column_Name[i].toString().equals("FURTHERINFORMATION1") && !l_Column_Name[i].toString().equals("FURTHERINFORMATION2") && !l_Column_Name[i].toString().equals("FURTHERINFORMATION3"))
   {
     if(l_Column_Name[i].toString().equals("REGULATORYLISTNAME"))     
     {  
       %>
        <TR  bordercolor="black" bgcolor="#F3E2D1">
        <TD  nowrap width='10%'><font face="verdana" size="2" ><%= l_Column_Name[i].toString().equals("DATEOFBIRTH")?"DATEOFBIRTH(YYYY/MM/DD)":l_Column_Name[i] %></font></TD>
        <TD align='left' wrap width='25%'>
       <% 
         l_strRegulatoryListName = l_List.get(i+1).toString();
         StringTokenizer l_StrTokens = new StringTokenizer(l_strRegulatoryListName,";");
         //String[] l_strDataFieldArry = new String[l_StrTokens.countTokens()];
         while(l_StrTokens.hasMoreTokens())
         {
         //l_StrTokens.nextToken(); 
         String l_strCompleteValue = l_StrTokens.nextToken();
          if(l_strCompleteValue.length() > 2) {
         String l_strRegulatoryName = l_strCompleteValue.substring(0,l_strCompleteValue.indexOf("^")) ;  
         //l_strRank.substring(l_strRank.length()-1,l_strRank.length());
         String l_strIsBold = l_strCompleteValue.substring(l_strCompleteValue.indexOf("^")+1,l_strCompleteValue.length()) ;
         //String l_strIsBold = "Y" ;
         //if(l_strRegulatoryName != null || !l_strRegulatoryName.equals(""))
         //{
           if(l_strIsBold.trim().equals("Y")) {
         %> 
         <li><font face="verdana" size="2" color="#FF0000"><b><%=l_strRegulatoryName%></b></font><br>
         <%
          } else { %>
         <li><font face="verdana" size="2" ><b><%=l_strRegulatoryName%></b></font><br>
         <% } }
	   }
        %>
        </font></TD>
        </tr>
    <%
     }
     else
     { 
    %>
   <TR  bordercolor="black" bgcolor="#F2F2F1">
   <TD  nowrap width='10%'><font face="verdana" size="2"><%= l_Column_Name[i].toString().equals("DATEOFBIRTH")?"DATEOFBIRTH(YYYY/MM/DD)":l_Column_Name[i] %></font></TD>

   <TD align='left' wrap width='25%'><font face="verdana" size="2"><b><%=l_List.get(i+1)==null?"&nbsp;":l_Column_Name[i].toString().equals("FURTHERINFORMATION")?l_strFurtherInfo:l_List.get(i+1).toString()%></b></font></TD>
   </tr>
   <%}}} %>

   </table>
   <br>
   <center>
   <input type='button' name='close' value='Close' class="but1" OnClick='window.close();'>
   </center>
   <%}%>
  </body>
</html>
