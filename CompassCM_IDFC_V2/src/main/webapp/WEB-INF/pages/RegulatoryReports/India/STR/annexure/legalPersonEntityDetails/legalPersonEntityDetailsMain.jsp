<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
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
		ISTREntityDetailsVO objEntityDetailsVO = null;
		ArrayList alEntityDetails = (ArrayList) request.getAttribute("ALLegPerDetailsDTO");

		if(alEntityDetails==null)
		alEntityDetails = new ArrayList();

		for(int x=0; x<alEntityDetails.size(); x++){
		objEntityDetailsVO = (ISTREntityDetailsVO)alEntityDetails.get(x);
		request.setAttribute("AnnexB_LegalDetailsDTO", objEntityDetailsVO);
		request.setAttribute("AnnBNo", (x+1)+"");
		String annxBNo = (String)request.getAttribute("AnnBNo");
		%>
				<li><a class="nav-link active" data-toggle="tab" href="#legalPersonEntityDetails<%=annxBNo%>">Legal Person Entity Details<%=annxBNo%></a></li>
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
ISTREntityDetailsVO objEntityDetailsVO = null;
ArrayList alEntityDetails = (ArrayList) request.getAttribute("ALLegPerDetailsDTO");

if(alEntityDetails==null)
alEntityDetails = new ArrayList();

for(int x=0; x<alEntityDetails.size(); x++){
objEntityDetailsVO = (ISTREntityDetailsVO)alEntityDetails.get(x);
request.setAttribute("AnnexB_LegalDetailsDTO", objEntityDetailsVO);
request.setAttribute("AnnBNo", (x+1)+"");
String annxBNo = (String)request.getAttribute("AnnBNo");
%>

<div class="tab-content compass-tab-content">
	<%
try
{
ISTREntityDetailsVO objEntityDetailsVO1 = null;
ArrayList alEntityDetails1 = (ArrayList) request.getAttribute("ALLegPerDetailsDTO");

if(alEntityDetails1==null)
alEntityDetails1 = new ArrayList();

for(int x1=0; x1 < alEntityDetails1.size(); x1++){
objEntityDetailsVO1 = (ISTREntityDetailsVO)alEntityDetails1.get(x1);
request.setAttribute("AnnexB_LegalDetailsDTO", objEntityDetailsVO1);
request.setAttribute("AnnBNo", (x1+1)+"");
String annxBNo1 = (String)request.getAttribute("AnnBNo");
%>
	<div role="tabpanel" class="tab-pane fade in" id="legalPersonEntityDetails<%=annxBNo1%>" >
	  <jsp:include page="annexureHeader.jsp"/>
		<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
			<li class="active"><a class="nav-link active show" data-toggle="tab" href="#legalPersonEntityDetailsContent<%=annxBNo1%>">Legal Person Entity Details</a></li>
		</ul>
		<div class="tab-content compass-tab-content">
			<div role="tabpanel" class="tab-pane fade in active" id="legalPersonEntityDetailsContent<%=annxBNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="legalPersonEntityDetailsContent">
							    <jsp:include page="legalPersonEntityDetailsContent.jsp"/>
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
</div>