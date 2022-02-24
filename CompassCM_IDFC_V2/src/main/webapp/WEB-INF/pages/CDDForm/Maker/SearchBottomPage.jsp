<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'CDDSearch${UNQID}';
		compassDatatable.construct(tableClass, "CDD Search", true);
	});
</script>
<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable CDDSearch${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th width="10%">Compass Ref No</th>
				<th width="15%">Form Type</th>
				<th width="10%">Customer ID</th>
				<th width="15%">Status</th>
				<th width="12%">Updated By</th>
				<th width="13%">Updated On</th>
				<th width="25%">Action</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="SEARCHCDD" items="${SEARCHCDD}">
				<tr>
					<td>${SEARCHCDD['COMPASSREFNO']}</td>
					<td>${SEARCHCDD['FORMTYPELONG']}</td>
					<td>${SEARCHCDD['CUSTOMERID']}</td>
					<td>${SEARCHCDD['FULLSTATUS']}</td>
					<td>${SEARCHCDD['UPDATEBY']}</td>
					<td>${SEARCHCDD['UPDATETIMESTAMP']}</td>
					<td style="vertical-align: middle;">
						<c:choose>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'BPA-P' || SEARCHCDD['CDDSTATUS'] eq 'RECDD') && CURRENTROLE eq 'ROLE_BPAMAKER')}">
								<c:choose>
									<c:when test="${SEARCHCDD['CDDSTATUS'] eq 'RECDD'}">
										<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="reCDD(this)" class="btn btn-danger btn-xs">Initiate Re-CDD</button>
									</c:when>
									<c:otherwise>
										<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Continue Editing</button>	
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'BPD-P') && CURRENTROLE eq 'ROLE_BPDMAKER')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Continue Editing</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'BPD-A') && CURRENTROLE eq 'ROLE_BPDCHECKER')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Continue Editing</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'BPA-A') && CURRENTROLE eq 'ROLE_BPACHECKER')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Continue Editing</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'COMP-P') && CURRENTROLE eq 'ROLE_COMPLIANCEMAKER')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Authorize</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'COMP-A') && CURRENTROLE eq 'ROLE_COMPLIANCECHECKER')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Authorize</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'JGM') && CURRENTROLE eq 'ROLE_JGM')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Authorize</button>
							</c:when>
							<c:when test="${((SEARCHCDD['STATUS'] eq 'GM') && CURRENTROLE eq 'ROLE_JGM')}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">Authorize</button>
							</c:when>
							<c:when test="${SEARCHCDD['STATUS'] eq 'A' && SEARCHCDD['CDDSTATUS'] eq 'CDD'}">
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-success btn-xs">View CDD</button>
							</c:when>
							<c:otherwise>
								<button compassRefNo="${SEARCHCDD['COMPASSREFNO']}" formType="${SEARCHCDD['FORMTYPE']}" lineNo="${SEARCHCDD['LINENO']}" onclick="continueCDD(this)" class="btn btn-primary btn-xs">View CDD</button>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>