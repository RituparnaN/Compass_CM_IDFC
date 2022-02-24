<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var userRole = '${USERROLE}';
});
</script>
<div class="row compassrow${UNQID}">
	<%@ include file="../DashBoard/MostVisitedModule.jsp"%>
</div>