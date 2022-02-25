<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.*,java.text.SimpleDateFormat" %>
<% 
 try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRIndividualDetailsVO objIndividualDetailsVO = null;
	ArrayList alIndividualDetails = (ArrayList) request.getAttribute("ALIndvDetailsDTO");
	if(alIndividualDetails==null)
		alIndividualDetails = new ArrayList();
	
	for(int x=0; x<alIndividualDetails.size(); x++){
		objIndividualDetailsVO = (ISTRIndividualDetailsVO)alIndividualDetails.get(x);
		request.setAttribute("AnnexA_IndividualDetailsDTO", objIndividualDetailsVO);
	    request.setAttribute("AnnANo", (x+1)+"");
%>
    <jsp:include page="annexureHeader.jsp"/>
    <jsp:include page="individualDetailsContent.jsp"/>
<% 
 }}catch(Exception e){}
%>