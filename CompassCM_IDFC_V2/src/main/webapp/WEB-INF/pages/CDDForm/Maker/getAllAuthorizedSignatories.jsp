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
			<c:when test="${f:length(AUTHORIZEDSIGNATORIES) > 0}">
				<c:forEach var="AUTHORIZEDSIGNATORIES" items="${AUTHORIZEDSIGNATORIES}">
					<tr>
						<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')" >${AUTHORIZEDSIGNATORIES['NAME']}</td>
						<td width="10%">${AUTHORIZEDSIGNATORIES['DATEOFBIRTH']}</td>
						<td width="15%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${AUTHORIZEDSIGNATORIES['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${AUTHORIZEDSIGNATORIES['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="15%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="20%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="5"><center>No Authorized Signatory Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>		
	</tbody>
</table>