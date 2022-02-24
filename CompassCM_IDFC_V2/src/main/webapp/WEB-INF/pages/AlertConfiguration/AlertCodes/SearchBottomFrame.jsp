<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	var id = '${UNQID}';
	
});
</script>
<table class="table table-bordered table-striped alertDetails${UNQID}" style="margin-bottom: 0px;">
	<tr>
		<td width="15%">Alert Code</td>
		<td width="30%"><input type="text" class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" value="${DATAMAP.ALERTCODE}" readonly="readonly"/></td>
		<td width="10%">&nbsp;</td>
		<td width="15%">Alert Name</td>
		<td width="30%"><input type="text" class="form-control input-sm" name="alertName" id="alertName${UNQID}" value="${DATAMAP.ALERTNAME}"/></td>
	</tr>
	<tr>
		<td width="15%">Description</td>
		<td width="30%"><input type="text" class="form-control input-sm" name="description" id="description${UNQID}" value="${DATAMAP.DESCRIPTION}"/></td>
		<td width="10%">&nbsp;</td>
		<td width="15%">Alert Message</td>
		<td width="30%"><input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}" value="${DATAMAP.ALERTMESSAGE}"/></td>
	</tr>
	<tr>
		<td width="15%">Alert Priority</td>
		<td width="30%">
			<select class="form-control input-sm" name="alertPriority" id="alertPriority${UNQID}">
				<option value="1" <c:if test="${DATAMAP.PRIORITY eq 1}">selected="selected"</c:if>>1</option>
				<option value="2" <c:if test="${DATAMAP.PRIORITY eq 2}">selected="selected"</c:if>>2</option>
				<option value="3" <c:if test="${DATAMAP.PRIORITY eq 3}">selected="selected"</c:if>>3</option>
				<option value="4" <c:if test="${DATAMAP.PRIORITY eq 4}">selected="selected"</c:if>>4</option>
				<option value="5" <c:if test="${DATAMAP.PRIORITY eq 5}">selected="selected"</c:if>>5</option>
				<option value="6" <c:if test="${DATAMAP.PRIORITY eq 6}">selected="selected"</c:if>>6</option>
				<option value="7" <c:if test="${DATAMAP.PRIORITY eq 7}">selected="selected"</c:if>>7</option>
				<option value="8" <c:if test="${DATAMAP.PRIORITY eq 8}">selected="selected"</c:if>>8</option>
				<option value="9" <c:if test="${DATAMAP.PRIORITY eq 9}">selected="selected"</c:if>>9</option>
				<option value="10" <c:if test="${DATAMAP.PRIORITY eq 10}">selected="selected"</c:if>>10</option>
			</select>
		</td>
		<td width="10%">&nbsp;</td>
		<td width="15%">Alert Enabled</td>
		<td width="30%">
			<select class="form-control input-sm" name="alertEnabled" id="alertEnabled${UNQID}">
				<option value="Y" <c:if test="${DATAMAP.ISENABLED eq 'Y'}">selected="selected"</c:if>>Yes</option>
				<option value="N" <c:if test="${DATAMAP.ISENABLED eq 'N'}">selected="selected"</c:if>>No</option>
			</select>		
		</td>
	</tr>		
</table>
