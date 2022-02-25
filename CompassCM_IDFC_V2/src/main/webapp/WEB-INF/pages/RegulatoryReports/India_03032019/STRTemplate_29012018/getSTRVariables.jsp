<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<String> strVariables = request.getAttribute("STRVARIABLES") != null ? (List<String>) request.getAttribute("STRVARIABLES") : new ArrayList<String>();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap.min.css"/>
		<title>STR Variables</title>
	</head>
	<body>
		<div class="container-fluid" style="margin-left: 10px;">
			<div class="row">
				<div class="col-xs-12">
					<div class="card card-info">
					  <div class="card-header">STR Variables</div>
					  <% if(strVariables.size() > 0){ %>
					  <table class="table table-bordered table-striped">
					  	<% for(int i = 0; i < strVariables.size(); i = i + 2 ){ %>
					  	<tr>
					  		<td>
					  			<%= strVariables.get(i)%>
					  		</td>
							<td>
					  			<%= strVariables.get(i+1)%>
					  		</td>
					  	</tr>
					  	<% } %>
					  </table>
					  <% }else{ %>
					  	<br/>
					  	<center>
					  		No STR Variable created
					  	</center>
					  	<br/>
					  <%} %>
					 </div>
				</div>
			</div>
		</div>
	</body>
</html>