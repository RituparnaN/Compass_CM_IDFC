<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<% 
try{
String contextPath = request.getContextPath()==null?"":request.getContextPath();
ISTREntityDetailsVO objEntityDetailsVO = null;
ArrayList alEntityDetails = (ArrayList) request.getAttribute("ALLegPerDetailsDTO");

if(alEntityDetails==null)
	alEntityDetails = new ArrayList();

for(int x=0; x<alEntityDetails.size(); x++){
	objEntityDetailsVO = (ISTREntityDetailsVO)alEntityDetails.get(x);
	request.setAttribute("AnnexB_LegalDetailsDTO", objEntityDetailsVO);
	request.setAttribute("AnnBNo", (x+1)+"");
%>
    <jsp:include page="annexureHeader.jsp"/>
    <jsp:include page="legalPersonEntityDetailsContent.jsp"/>
<% 
 }}catch(Exception e){}
%>