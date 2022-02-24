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
		<th>Pan No</th>
		<th>Relation</th>
		<th>Match?</th>
		<th>List Name</th>
		<th>Action</th>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${f:length(JOINTHOLDERS) > 0}">
				<c:forEach var="JOINTHOLDERS" items="${JOINTHOLDERS}">
					<tr>
						<td width="20%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')" >${JOINTHOLDERS['JOINTHOLDERNAME']}</td>
						<td width="15%">${JOINTHOLDERS['JOINTHOLDERPAN']}</td>
						<td width="15%">${JOINTHOLDERS['RELATIONWITHPRIMARY']}</td>
						<td width="15%" class="match">
							<select class="form-control input-sm selectpicker">
								<option value="N" <c:if test="${JOINTHOLDERS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
								<option value="Y" <c:if test="${JOINTHOLDERS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
							</select>
						</td>
						<td width="15%" class="listname">
							<select class="form-control input-sm selectpicker" multiple>
								<option value="">None</option>
								<option value="DJ" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
								<option value="RBI" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
								<option value="EXP" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
								<option value="FIU" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
								<option value="OFC" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
								<option value="UNC" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
							</select>
						</td>
						<td width="20%">
							<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button> -->
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
									<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'JOINTHOLDER','${JOINTHOLDERS['LINENO']}')">Screen</button>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'JOINTHOLDER','${JOINTHOLDERS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'JOINTHOLDER','${JOINTHOLDERS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Update</button>
							<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Remove</button>
						</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="6"><center>No Joint Holder Added</center></td>
				</tr>
			</c:otherwise>
		</c:choose>		
	</tbody>
</table>