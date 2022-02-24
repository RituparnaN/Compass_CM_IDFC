<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
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
%> --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat" %>

<div id="content" class="container" style="width:1510px; padding-left: 0; margin-left: 0; padding-right: 40px; margin-top: 5px;">
	<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
		<%
		try
		{
		ISTRIndividualDetailsVO objIndividualDetailsVO = null;
		ArrayList alIndividualDetails = (ArrayList) request.getAttribute("ALIndvDetailsDTO");
		if(alIndividualDetails==null)
			alIndividualDetails = new ArrayList();
		
		for(int x=0; x<alIndividualDetails.size(); x++){
			objIndividualDetailsVO = (ISTRIndividualDetailsVO)alIndividualDetails.get(x);
			request.setAttribute("AnnexA_IndividualDetailsDTO", objIndividualDetailsVO);
		    request.setAttribute("AnnANo", (x+1)+"");
			String annxANo = (String)request.getAttribute("AnnANo");
		%>
				<li><a data-toggle="tab" href="#individualDetails<%=annxANo%>">Individual Details<%=annxANo%></a></li>
			<% 
		}
		%>
		<% }
		catch(Exception e){}
		%>
	</ul>

<%
try
{
ISTRIndividualDetailsVO objIndividualDetailsVO = null;
ArrayList alIndividualDetails = (ArrayList) request.getAttribute("ALIndvDetailsDTO");
if(alIndividualDetails==null)
	alIndividualDetails = new ArrayList();

for(int x=0; x<alIndividualDetails.size(); x++){
	objIndividualDetailsVO = (ISTRIndividualDetailsVO)alIndividualDetails.get(x);
	request.setAttribute("AnnexA_IndividualDetailsDTO", objIndividualDetailsVO);
    request.setAttribute("AnnANo", (x+1)+"");
    String annxANo = (String) request.getAttribute("AnnANo");
%>

<div class="tab-content compass-tab-content">
	<%
try
{
ISTRIndividualDetailsVO objIndividualDetailsVO1 = null;
ArrayList alIndividualDetails1 = (ArrayList) request.getAttribute("ALIndvDetailsDTO");
if(alIndividualDetails1==null)
	alIndividualDetails1 = new ArrayList();

for(int x1=0; x1 < alIndividualDetails1.size(); x1++){
	objIndividualDetailsVO1 = (ISTRIndividualDetailsVO)alIndividualDetails1.get(x1);
	request.setAttribute("AnnexA_IndividualDetailsDTO", objIndividualDetailsVO1);
    request.setAttribute("AnnANo", (x1+1)+"");
    String annxANo1 = (String) request.getAttribute("AnnANo");
%>
		<div role="tabpanel" class="tab-pane fade in" id="individualDetails<%=annxANo1%>" >
	  <jsp:include page="annexureHeader.jsp"/>
		<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
			<li class="active"><a data-toggle="tab" href="#individualDetailsContent<%=annxANo1%>">Individual Details</a></li>
		</ul>
		<div class="tab-content compass-tab-content">
			<div role="tabpanel" class="tab-pane fade in active" id="individualDetailsContent<%=annxANo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="individualDetailsContent">
							    <jsp:include page="individualDetailsContent.jsp"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
 </div>
 <% 
}
%>
<% }
catch(Exception e){}
%>
</div>	
<% 
}
%>
<% }
catch(Exception e){}
%>
</div>

