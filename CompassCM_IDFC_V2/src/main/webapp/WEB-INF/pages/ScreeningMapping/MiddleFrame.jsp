<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
</script>
<table class="table table-bordered table-striped compassScreeningMappingSerachResultTable" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort"></th>
			<th class="info">Source List</th>
			<th class="info">Destination List</th>
			<th class="info">Mapping Level</th>
		</tr>
	</thead>
	<tbody>
			<tr>
				<td class="no-sort" style="text-align: center;"><input type="checkbox" id="searchLevelCheckBox" style="text-align: center;"
					<c:if test="${MIDDLEDATALIST['ISENABLE'] eq '1'}">checked="checked"</c:if>>	
				</td>
				<td>${MIDDLEDATALIST['SOURCELISTCODE']}</td>
				<td>${MIDDLEDATALIST['SEARCHLISTCODE']}</td>
				<td>
					<select class="form-control input-sm" style="width: 50%">
						<option value="Loose" <c:if test="${MIDDLEDATALIST['SEARCHLEVEL'] eq 'Loose'}">selected="selected"</c:if>>Loose</option>
						<option value="Exhaustive" <c:if test="${MIDDLEDATALIST['SEARCHLEVEL'] eq 'Exhaustive'}">selected="selected"</c:if>>Exhaustive</option>
						<option value="Typical" <c:if test="${MIDDLEDATALIST['SEARCHLEVEL'] eq 'Typical'}">selected="selected"</c:if>>Typical</option>
					</select>
				</td>
			</tr>
	</tbody>
</table>