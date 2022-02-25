<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat" %>
<%
try
{
ISTRAccountDetailsVO objAccountDetailsVO = null;
ArrayList alAccountDetails = (ArrayList) request.getAttribute("AcctDetailsDTO");		
if(alAccountDetails==null)
	alAccountDetails = new ArrayList();			
for(int m=0;m < alAccountDetails.size();m++){				
	objAccountDetailsVO = (ISTRAccountDetailsVO)alAccountDetails.get(m);
	request.setAttribute("AnnexC_AcctDetailsDTO", objAccountDetailsVO);
	request.setAttribute("AnnCNo", (m+1)+"");
%>

    <jsp:include page="annexureHeader.jsp"/>
    <jsp:include page="branchDetails.jsp"/>
    <jsp:include page="accountHolderList.jsp"/>
    <jsp:include page="relatedPersonList.jsp"/>
    <jsp:include page="cumulativeDetails.jsp"/>
    <jsp:include page="transactionDetails.jsp"/>
<% 
	}
}
catch(Exception e){}
%>
