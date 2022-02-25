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
		<th>Date of Birth</th>
		<th>Match?</th>
		<th>List Name</th>
		<th>Action</th>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${f:length(DIRECTORS) > 0}">
				<c:forEach var="DIRECTORS" items="${DIRECTORS}">
					<tr>
						<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')" >${DIRECTORS['NAME']}</td>
						<td width="10%">${DIRECTORS['DATEOFBIRTH']}</td>
						<td width="15%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${DIRECTORS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${DIRECTORS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="15%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="20%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'DIRECTOR','${DIRECTORS['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'DIRECTOR','${DIRECTORS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'DIRECTOR','${DIRECTORS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="5"><center>No Director Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>		
	</tbody>
</table>