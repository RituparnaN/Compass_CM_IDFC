<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		
		$(".selectpicker").selectpicker();
	});
</script>
<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
	<thead>
		<th>Name</th>
		<th>Position Held in Government</th>
		<th>Nationality</th>
		<th>Position Held in Company</th>
		<th>Match?</th>
		<th>List Name</th>
		<th>Action</th>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${f:length(PEPDETAILS) > 0}">
				<c:forEach var="PEPDETAILS" items="${PEPDETAILS}">
					<tr>
						<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')" >${PEPDETAILS['PEPNAME']}</td>
						<td width="15%">${PEPDETAILS['PEPPOSITIONINGOVT']}</td>
						<td width="15%">${PEPDETAILS['PEPNATIONALITY']}</td>
						<td width="15%">${PEPDETAILS['PEPPOSITIONINCOMPANY']}</td>
						<td width="10%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="15%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="15%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button> -->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPDMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'PEP','${PEPDETAILS['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="7"><center>No PEP Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>