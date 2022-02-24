<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Exception List Details</title>
<jsp:include page="../tags/staticFiles.jsp"/>
    
<script type="text/javascript">
$(document).ready(function() {
	var id = '${UNQID}';
	var tableClass = 'exceptionListIdDetailsModal${UNQID}';
	});

</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary exceptionListIdDetailsModal">
		<form action="javascript:void(0)" method="POST" id="exceptionListIdDetailsModal${UNQID}">
			<table class="table table-bordered table-striped exceptionListIdDetailsModal${UNQID}" style="margin-bottom: 0px;">
		<c:forEach var="record" items="${resultData['DATA']}">
			<c:forEach var="field" items="${record}" varStatus="loop">
				<tr>
					<th class="info">${resultData['HEADER'][loop.index]}</th>
					<td>${field}</td>
				</tr>
			</c:forEach>
		</c:forEach>
	</tbody>
</table>
</form>
	</div>
	</div>
</div>