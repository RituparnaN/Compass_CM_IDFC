<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'CDDStatus${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var LINENO = '${LINENO}';
		compassDatatable.construct(tableClass, "CDD Search", true);
		
		
		$(".btnCDDFormApproveReject").click(function(){
			var action = $(this).attr("action");
			if(confirm("Before confirming your action, please make sure you have saved all the section "+
					"of the form.\n\na) CDD Form\nb) Screening\nc) Risk Rating\nd) Check List\ne) All Identification Forms\n\n"+
					"Please ignore and confirm if you already did or you are not a Maker.\nSo are you sure to "+action+"?")){
				$("#compassMediumGenericModal").modal("show");
				if(action == "APPROVE")
					$("#compassMediumGenericModal-title").html("Approve CDD Form");
				else
					$("#compassMediumGenericModal-title").html("Reject CDD Form");
				$("#compassMediumGenericModal-body").html("Loading...");
				$.ajax({
					url : "${pageContext.request.contextPath}/cddFormCommon/cddFormApproveRejectModal",
					type : "POST",
					cache : false,
					data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&ACTION="+action,
					success : function(res){
						$("#compassMediumGenericModal-body").html(res);
					},
					error : function(){
						alert("Error while saving form");
					}
				});		
			}
		});
		
		$("#viewUploadCDDDoc"+id).click(function(){
			compassFileUpload.init("cddFileUpload"+id,"${pageContext.request.contextPath}","cddFileUpload","0","Y","Y","CDD_"+COMPASSREFERENCENO);
		});
	});
	
	function loadStatusApprovalsLocal(elm,COMPASSREFERENCENO, LINENO){
		$(elm).attr("disabled","disabled");
		$(elm).html("Refreshing...")
		loadStatusApprovals(COMPASSREFERENCENO, LINENO);
	}
</script>
<c:set var="UPDATESTATUS" value="${AUDITLOG['UPDATESTATUS']}"/>
<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
	<tr>
		<td>Form Status</td>
		<td>
			<c:choose>
				<c:when test="${STATUS eq 'BPA-P'}">
					Pending with BPAMaker
				</c:when>
				<c:when test="${STATUS eq 'BPD-P'}">
					Pending with BPDMaker
				</c:when>
				<c:when test="${STATUS eq 'COMP-P'}">
					Pending with ComplianceMaker
				</c:when>
				<c:when test="${STATUS eq 'BPA-A'}">
					Pending with BPAChecker
				</c:when>
				<c:when test="${STATUS eq 'BPD-A'}">
					Pending with BPDChecker
				</c:when>
				<c:when test="${STATUS eq 'COMP-A'}">
					Pending with ComplianceChecker
				</c:when>
				<c:when test="${STATUS eq 'JGM'}">
					Pending with JGM
				</c:when>
				<c:when test="${STATUS eq 'GM'}">
					Pending with GM
				</c:when>
				<c:when test="${STATUS eq 'A'}">
					Approved. CDD Complete.
				</c:when>
				<c:otherwise>
					Rejected
				</c:otherwise>
			</c:choose>
		</td>
		<td>&nbsp;</td>
		<td colspan="2" style="text-align: center;">
			<c:if test="${(STATUS eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') ||
						(STATUS eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER') ||
						(STATUS eq 'BPD-A' && CURRENTROLE eq 'ROLE_BPDCHECKER') || 
						(STATUS eq 'BPA-A' && CURRENTROLE eq 'ROLE_BPACHECKER') || 
						(STATUS eq 'COMP-P' && CURRENTROLE eq 'ROLE_COMPLIANCEMAKER') || 
						(STATUS eq 'COMP-A' && CURRENTROLE eq 'ROLE_COMPLIANCECHECKER') || 
						(STATUS eq 'JGM' && CURRENTROLE eq 'ROLE_JGM') || 
						(STATUS eq 'GM' && CURRENTROLE eq 'ROLE_GM')}">
				<button type="button" class="btn btn-success btn-sm btnCDDFormApproveReject" id="btnApprove" action="APPROVE">Approve</button>
				<c:if test="${CURRENTROLE ne 'ROLE_BPAMAKER'}">
					<button type="button" class="btn btn-danger btn-sm btnCDDFormApproveReject" id="btnReject" action="REJECT">Reject</button>
				</c:if>
			</c:if>
		</td>
	</tr>
	<tr>
		<td>
			Next Review Date
		</td>
		<td colspan="2">
			<c:choose>
				<c:when test="${f:length(NEXTREVIEWDATE) == 0}">
					Not Set Yet. BPAChecker will first enter the Next Review Date
				</c:when>
				<c:otherwise>
					${NEXTREVIEWDATE}
				</c:otherwise>
			</c:choose>
		</td>
		<td colspan="2" style="text-align: center;">
			<button type="button" class="btn btn-warning btn-sm" id="viewUploadCDDDoc${UNQID}">View / Upload CDD Documents</button>
			<button type="button" class="btn btn-info btn-sm" id="refresh${UNQID}" onclick="loadStatusApprovalsLocal(this,'${COMPASSREFERENCENO}','${LINENO}')">Refresh Status</button>
		</td>
	</tr>
	<tr>
		<td width="15%">
			Last BPA Maker Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['BPAMAKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['BPAMAKER']['USERCODE']) gt 0}">(${UPDATESTATUS['BPAMAKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			Last BPA Maker Updated Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['BPAMAKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="20%">
			Last BPD Maker Updated
		</td>
		<td width="28%">
			${UPDATESTATUS['BPDMAKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['BPDMAKER']['USERCODE']) gt 0}">(${UPDATESTATUS['BPDMAKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td width="20%">
			Last BPD Maker Updated Timestamp
		</td>
		<td width="28%">
			${UPDATESTATUS['BPDMAKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			Last Compliance Maker Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['COMPLIANCEMAKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['COMPLIANCEMAKER']['USERCODE']) gt 0}">(${UPDATESTATUS['COMPLIANCEMAKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			Last Compliance Maker Updated Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['COMPLIANCEMAKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			Last BPA Checker Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['BPACHECKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['BPACHECKER']['USERCODE']) gt 0}">(${UPDATESTATUS['BPACHECKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			Last BPA Checker Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['BPACHECKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			Last BPD Checker Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['BPDCHECKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['BPDCHECKER']['USERCODE']) gt 0}">(${UPDATESTATUS['BPDCHECKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			Last BPD Checker Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['BPDCHECKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			Last Compliance Checker Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['COMPLIANCECHECKER']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['COMPLIANCECHECKER']['USERCODE']) gt 0}">(${UPDATESTATUS['COMPLIANCECHECKER']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			Last Compliance Checker Updated Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['COMPLIANCECHECKER']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			JGM Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['JGM']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['JGM']['USERCODE']) gt 0}">(${UPDATESTATUS['JGM']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			JGM Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['JGM']['MAXTIMESTAMP']}
		</td>
	</tr>
	<tr>
		<td width="15%">
			GM Updated
		</td>
		<td width="33%">
			${UPDATESTATUS['GM']['USERNAME']} <c:if test="${f:length(UPDATESTATUS['GM']['USERCODE']) gt 0}">(${UPDATESTATUS['GM']['USERCODE']})</c:if>
		</td>
		<td width="4%">&nbsp;</td>
		<td>
			GM Timestamp
		</td>
		<td width="33%">
			${UPDATESTATUS['GM']['MAXTIMESTAMP']}
		</td>
	</tr>
</table>
<br/>
<c:set var="AUDITLOGLIST" value="${AUDITLOG['AUDITLOGLIST']}"/>
<div id="searchResultGenericDiv">
	<table class="table table-bordered table-striped searchResultGenericTable CDDStatus${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th width="15%">User Name</th>
				<th width="10%">User ROLE</th>
				<th width="10%">Last Status</th>
				<th width="10%">Current Status</th>
				<th width="15%">Timestamp</th>
				<th width="40%">View Comments</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="AUDITLOGLIST" items="${AUDITLOGLIST}">
				<tr>
					<td>${AUDITLOGLIST['USERNAME']}</td>
					<td>${AUDITLOGLIST['ROLEID']}</td>
					<td>${AUDITLOGLIST['CURRENTSTATUS']}</td>
					<td>${AUDITLOGLIST['UPDATEDSTATUS']}</td>
					<td>${AUDITLOGLIST['UPDATETIMESTAMP']}</td>
					<td>${AUDITLOGLIST['USERCOMMENT']}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>