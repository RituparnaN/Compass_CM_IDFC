<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat" %>

<div id="content" class="container" style="width:1510px; padding-left: 0; margin-left: 0; padding-right: 40px; margin-top: 5px;">
	<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
		<%
		try
		{
		ISTRAccountDetailsVO objAccountDetailsVO = null;
		ArrayList alAccountDetails = (ArrayList) request.getAttribute("AcctDetailsDTO");		
		if(alAccountDetails==null)
			alAccountDetails = new ArrayList();			
		for(int m=0; m < alAccountDetails.size(); m++){				
			objAccountDetailsVO = (ISTRAccountDetailsVO)alAccountDetails.get(m);
			request.setAttribute("AnnexC_AcctDetailsDTO", objAccountDetailsVO);
			request.setAttribute("AnnCNo", (m+1)+"");
			String annxNo = (String)request.getAttribute("AnnCNo");
		%>
				<li><a data-toggle="tab" href="#accountDetails<%=annxNo%>">Account Details<%=annxNo%></a></li>
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
ISTRAccountDetailsVO objAccountDetailsVO = null;
ArrayList alAccountDetails = (ArrayList) request.getAttribute("AcctDetailsDTO");		
if(alAccountDetails==null)
	alAccountDetails = new ArrayList();			
for(int m=0; m < alAccountDetails.size(); m++){				
	objAccountDetailsVO = (ISTRAccountDetailsVO)alAccountDetails.get(m);
	request.setAttribute("AnnexC_AcctDetailsDTO", objAccountDetailsVO);
	request.setAttribute("AnnCNo", (m+1)+"");
	String annxNo = (String) request.getAttribute("AnnCNo");
%>

<div class="tab-content compass-tab-content">
	<%
try
{
ISTRAccountDetailsVO objAccountDetailsVO1 = null;
ArrayList alAccountDetails1 = (ArrayList) request.getAttribute("AcctDetailsDTO");		
if(alAccountDetails1==null)
	alAccountDetails1 = new ArrayList();			
for(int m1=0; m1 < alAccountDetails1.size(); m1++){				
	objAccountDetailsVO1 = (ISTRAccountDetailsVO)alAccountDetails1.get(m1);
	request.setAttribute("AnnexC_AcctDetailsDTO", objAccountDetailsVO1);
	request.setAttribute("AnnCNo", (m1+1)+"");
	String annxNo1 = (String) request.getAttribute("AnnCNo");
%>
		<div role="tabpanel" class="tab-pane fade in" id="accountDetails<%=annxNo1%>" >
	  <jsp:include page="annexureHeader.jsp"/>
		<ul class="nav nav-tabs compass-nav-tabs" role="tablist" >
			<li class="active"><a data-toggle="tab" href="#branchDetails<%=annxNo1%>">Branch Details</a></li>
	    	<li><a data-toggle="tab" href="#accountHolderList<%=annxNo1%>">Account Holder List</a></li>
	    	<li><a data-toggle="tab" href="#relatedPersonList<%=annxNo1%>">Related Person List</a></li>
	    	<li><a data-toggle="tab" href="#cumulativeDetails<%=annxNo1%>">Cumulative Details</a></li>
	    	<li><a data-toggle="tab" href="#transactionDetails<%=annxNo1%>">Transaction Details</a></li>
		</ul>
		<div class="tab-content compass-tab-content">
			<div role="tabpanel" class="tab-pane fade in active" id="branchDetails<%=annxNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="branchDetails">
							    <jsp:include page="branchDetails.jsp"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		
			<div role="tabpanel" class="tab-pane fade" id="accountHolderList<%=annxNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="accountHolderList">
							    <jsp:include page="accountHolderList.jsp"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		
			<div role="tabpanel" class="tab-pane fade" id="relatedPersonList<%=annxNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="relatedPersonList">
							    <jsp:include page="relatedPersonList.jsp"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		
			<div role="tabpanel" class="tab-pane fade" id="cumulativeDetails<%=annxNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="cumulativeDetails">
							    <jsp:include page="cumulativeDetails.jsp"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		
			<div role="tabpanel" class="tab-pane fade" id="transactionDetails<%=annxNo1%>" >
				<div class="row">
					<div class="col-sm-12">
						<div class="card card-primary">
							<div id="transactionDetails">
							    <jsp:include page="transactionDetails.jsp"/>
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