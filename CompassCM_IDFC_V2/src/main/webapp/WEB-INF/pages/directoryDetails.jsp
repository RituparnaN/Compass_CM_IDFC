<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();

%>

<center>
<button type="button" class="btn btn-primary"  onclick="openScheduledReportDownloadFolder('root','')">Go to ROOT</button>
<button type="button" class="btn btn-success" onclick="openScheduledReportDownloadFolder('${requestScope.backPath}','')">Back</button>
</center>
<br/>
<table id="logTable" class="table table-striped table-bordered"
	cellspacing="0" width="auto">
	<thead>
		<tr>
			<th width="40%">Item</th>
			<th width="15%">Modified On</th>
			<th width="15%">Size</th>
			<th width="20%">File / Directory</th>
			<th width="10%">Action</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${requestScope.itemList}" var="mainList"
			varStatus="loop">
			<tr>
				<td>${mainList.ITEMNAME}</td>
				<td>${mainList.LASTMODIFIED}</td>
				<td>${mainList.ITEMSIZE}</td>
				<c:choose>
					<c:when test="${mainList.DIRECTORY == 'y'}">
						<td>File</td>
						<td><a href="<%=contextPath%>/downloadScheduleReport?path=${mainList.ITEMPATH}&name=${mainList.ITEMNAME}" target="_blank" >Download</a></td>
					</c:when>
					<c:otherwise>
						<td>Directory</td>
						<td><a href="javascript:void(0)" onclick="openScheduledReportDownloadFolder('${mainList.ITEMPATH}','${requestScope.backPath}')">Open</a></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</tbody>
</table>