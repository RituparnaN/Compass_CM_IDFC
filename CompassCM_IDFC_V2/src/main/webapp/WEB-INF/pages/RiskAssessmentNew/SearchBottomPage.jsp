<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'RASearch${UNQID}';
		compassDatatable.construct(tableClass, "RA Search", true);

});	
</script>
<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable RASearch${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th width="10%">Compass Reference No</th>
				<th width="15%">Assessment Unit</th>
				<th width="10%">Assessment Period</th>
				<th width="15%">Status</th>
				<th width="12%">Updated By</th>
				<th width="13%">Updated On</th>
				<th width="25%">Action</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RISKASSESSMENTDATA" items="${RISKASSESSMENTDATA}">
				<tr>
					<td>${RISKASSESSMENTDATA['COMPASSREFNO']}</td>
					<td>${RISKASSESSMENTDATA['ASSESSMENTUNIT']}</td>
					<td>${RISKASSESSMENTDATA['ASSESSMENTPERIOD']}</td>
					<td>${RISKASSESSMENTDATA['STATUS']}</td>
					<td>${RISKASSESSMENTDATA['UPDATEBY']}</td>
					<td>${RISKASSESSMENTDATA['UPDATETIMESTAMP']}</td>
					
					<td style="vertical-align: middle;">
						<c:choose>
							<c:when test="${(RISKASSESSMENTDATA['STATUSCODE'] eq 'CMO-P') && (CURRENTROLE eq 'ROLE_CM_OFFICER')}">
								<button compassRefNo="${RISKASSESSMENTDATA['COMPASSREFNO']}" assessmentUnit="${RISKASSESSMENTDATA['ASSESSMENTUNIT']}" onclick="continueRA(this)" class="btn btn-warning btn-xs">Continue Editing</button>
							</c:when>
							<c:when test="${(RISKASSESSMENTDATA['STATUSCODE'] eq 'CMM-P') && (CURRENTROLE eq 'ROLE_CM_MANAGER')}">
								<button compassRefNo="${RISKASSESSMENTDATA['COMPASSREFNO']}" assessmentUnit="${RISKASSESSMENTDATA['ASSESSMENTUNIT']}" onclick="continueRA(this)" class="btn btn-success btn-xs">Authorize</button>
							</c:when>
							<c:otherwise>
								<button compassRefNo="${RISKASSESSMENTDATA['COMPASSREFNO']}" assessmentUnit="${RISKASSESSMENTDATA['ASSESSMENTUNIT']}" onclick="continueRA(this)" class="btn btn-primary btn-xs">View</button>
							</c:otherwise>
						</c:choose>
						<button compassRefNo="${RISKASSESSMENTDATA['COMPASSREFNO']}" assessmentUnit="${RISKASSESSMENTDATA['ASSESSMENTUNIT']}" onclick="generateRAReport(this)" class="btn btn-info btn-xs">Generate Report</button>
					</td>
					
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>