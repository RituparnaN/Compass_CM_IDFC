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
		<th>Nationality</th>
		<th>Match?</th>
		<th>List Name</th>
		<th>Action</th>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${f:length(INTERMEDIARIES) > 0}">
				<c:forEach var="INTERMEDIARIES" items="${INTERMEDIARIES}">
					<tr>
						<td width="20%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')" >${INTERMEDIARIES['INTERMEDIARYNAME']}</td>
						<td width="20%">${INTERMEDIARIES['INTERMEDIARYNATIONALITY']}</td>
						<td width="20%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${INTERMEDIARIES['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${INTERMEDIARIES['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="20%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="20%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button> -->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'INTERMEDIARY','${INTERMEDIARIES['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'INTERMEDIARY','${INTERMEDIARIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'INTERMEDIARY','${INTERMEDIARIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="5"><center>No Intermediary Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>