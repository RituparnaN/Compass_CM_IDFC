<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<HTML><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<!--
<frameset rows="35%,*" frameborder="no" border="0" framespacing="0" noresize>
  <frame src="${pageContext.request.contextPath}/admin/getSchedulerTopFrame" name="searchFormFrame" scrolling="auto" noresize>
  <frame src="${pageContext.request.contextPath}/admin/getSchedulerBottomFrame" scrolling="auto" name="searchResultFrame" noresize>
</frameset>
-->
<div>
  <iframe height="50%" width="100%" src="${pageContext.request.contextPath}/admin/getSchedulerTopFrame" name="searchFormFrame" scrolling="auto"></iframe>
</div>
<div>  
  <iframe height="100%" width="100%" src="${pageContext.request.contextPath}/admin/getSchedulerBottomFrame" scrolling="auto" name="searchResultFrame"></iframe>
</div>
</html>
