<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
var viewType = '${viewType}';
var alertId = '${alertId}';
var alertName = '${alertName}';
var alertSerialNo = '${alertSerialNo}';
var id = '${UNQID}';

	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = ''+id;
		compassDatatable.construct(tableClass, "AlertBenchMarksList", true);
		compassDatatable.enableCheckBoxSelection();
	});
</script>
${resultMessage}