<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		$("#confirmApproveReject").click(function(){
			var COMPASSREFFINAL = $("#COMPASSREFFINAL").val();
			var LINENOFINAL = $("#LINENOFINAL").val();
			var formData = $("#saveApproveReject").serialize();
			var CDDCOMMENT = $("#CDDCOMMENT").val();
			
			$(".datepicker").datepicker({
				changeMonth: true,
				changeYear: true,
				dateFormat: "dd/mm/yy"
			});
			
			if(CDDCOMMENT != ""){
				$.ajax({
					url : "${pageContext.request.contextPath}/cddFormCommon/confirmApproveReject",
					type : "POST",
					cache : false,
					data : formData,
					success : function(res){
						alert(res);
						$(".saveCDDForm, .cddModifyButton, .saveCDDFormBPAMaker, .saveCDDFormBPAChecker").each(function(){
							$(this).attr("disabled","disabled");
						});
						loadStatusApprovals(COMPASSREFFINAL, LINENOFINAL);
						$("#compassMediumGenericModal").modal("hide");
					},
					error : function(){
						alert("Error while saving form");
					}
				});
			}else{
				alert("Enter comment");
			}			
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveApproveReject">
	<input type="hidden" name="COMPASSREFERENCENO" id="COMPASSREFFINAL" value="${COMPASSREFERENCENO}">
	<input type="hidden" name="LINENO" id="LINENOFINAL" value="${LINENO}">
	<input type="hidden" name="ACTION" id="ACTIONFINAL" value="${ACTION}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Current Status</td>
			<td width="33%">
				<c:choose>
				<c:when test="${STATUS eq 'BPD-P'}">
					Pending with BPDMaker
				</c:when>
				<c:when test="${STATUS eq 'BPD-A'}">
					Pending with BPDChecker
				</c:when>
				<c:when test="${STATUS eq 'BPA-P'}">
					Pending with BPAMaker
				</c:when>
				<c:when test="${STATUS eq 'BPA-A'}">
					Pending with BPAChecker
				</c:when>
				<c:when test="${STATUS eq 'COMP-P'}">
					Pending with ComplianceMaker
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
			<td width="4%">&nbsp;</td>
			<td width="15%">Next Level</td>
			<td width="33%" style="text-align: center;">
				<c:choose>
					<c:when test="${ACTION eq 'REJECT'}">
						<c:forEach var="REJECTAPPROVEDEPT" items="${REJECTAPPROVEDEPT}">
							<label class="btn btn-outline btn-danger btn-sm radio-inline" for="REJECTAPPROVEDEPT${REJECTAPPROVEDEPT.key}">
							<input type="radio" id="REJECTAPPROVEDEPT${REJECTAPPROVEDEPT.key}"  name="REJECTAPPROVEDEPT" value="${REJECTAPPROVEDEPT.key}" checked="checked"/>
								${REJECTAPPROVEDEPT.value}
							</label>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:forEach var="REJECTAPPROVEDEPT" items="${REJECTAPPROVEDEPT}">
							<label class="btn btn-outline btn-success btn-sm radio-inline" for="REJECTAPPROVEDEPT${REJECTAPPROVEDEPT.key}">
							<input type="radio" id="REJECTAPPROVEDEPT${REJECTAPPROVEDEPT.key}"  name="REJECTAPPROVEDEPT" value="${REJECTAPPROVEDEPT.key}"  checked="checked"/>
								${REJECTAPPROVEDEPT.value}
							</label>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				
			</td>
		</tr>
		<c:if test="${ACTION eq 'APPROVE'}">
			<tr>
				<td width="15%">Next Review Date</td>
				<td width="85%" colspan="4">
					<c:choose>
						<c:when test="${f:length(NEXTREVIEWDATE) == 0}">
							No Set Yet. BPAChecker will first enter the Next Review Date
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${(CURRENTROLE eq 'ROLE_BPACHECKER') ||
											  (CURRENTROLE eq 'ROLE_COMPLIANCEMAKER') ||
											  (CURRENTROLE eq 'ROLE_COMPLIANCECHECKER') ||
											  (CURRENTROLE eq 'ROLE_JGM') ||
											  (CURRENTROLE eq 'ROLE_GM')}">
									<input type="text" class="form-control input-sm datepicker" name="NEXTREVIEWDATE" id="NEXTREVIEWDATE${UNQID}" value="${NEXTREVIEWDATE}">
								</c:when>
								<c:otherwise>
									${NEXTREVIEWDATE}
								</c:otherwise>
							</c:choose>
							
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:if>
		<tr>
			<td width="15%">Comment</td>
			<td width="85%" colspan="4">
				<textarea rows="3" cols="2" class="form-control" name="CDDCOMMENT" id="CDDCOMMENT"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: center;">
				<button type="button" class="btn btn-success btn-sm" onclick="confirmApproveReject();" id="confirmApproveReject">Confirm</button>
			</td>
		</tr>
	</table>
</form>