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
		<th>Effective Shareholding</th>
		<th>Nationality</th>
		<th>Date of Birth</th>
		<th>Match?</th>
		<th>List Name</th>
		<th>Action</th>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${f:length(BENEFICIALOWNERS) > 0}">
				<c:forEach var="BENEFICIALOWNER" items="${BENEFICIALOWNERS}">
					<tr>
						<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')" >${BENEFICIALOWNER['NAME']}</td>
						<td width="15%">${BENEFICIALOWNER['EFFECTIVESHAREHOLDING']}</td>
						<td width="10%">${BENEFICIALOWNER['NATIONALITY']}</td>
						<td width="10%">${BENEFICIALOWNER['DATEOFBIRTH']}</td>
						<td width="15%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${BENEFICIALOWNER['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${BENEFICIALOWNER['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="15%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="20%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPDMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'BENEFICIALOWNER','${BENEFICIALOWNER['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'BENEFICIALOWNER','${BENEFICIALOWNER['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'BENEFICIALOWNER','${BENEFICIALOWNER['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="7"><center>No Beneficial Owner Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>		
	</tbody>
</table>