<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var LINENO = '${LINENO}';
		var STATUS = '${STATUS}';
		var FORMLINENO = '${FORMLINENO}';
		var CURRENTROLE = '${CURRENTROLE}';
		
		if((CURRENTROLE == "ROLE_BPAMAKER" && STATUS == "BPA-P") || (CURRENTROLE == "ROLE_BPDMAKER" && STATUS == "BPD-P")){
			$("#saveBeneficialOwner"+id).removeAttr("disabled");
		}else{
			$("#saveBeneficialOwner"+id).attr("disabled", "disabled");
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#saveBeneficialOwner"+id).click(function(){
			var formObj = $("#saveBeneficialOwnerForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveBeneficialOwner",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshBeneficialOwners();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveBeneficialOwnerForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NAME" id="NAME${UNQID}" value="${BENEFICIALOWNER[0]['NAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Effective Shareholdings</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="EFFECTIVESHAREHOLDING" id="EFFECTIVESHAREHOLDING${UNQID}" value="${BENEFICIALOWNER[0]['EFFECTIVESHAREHOLDING']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Nationality</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NATIONALITY" id="NATIONALITY${UNQID}" value="${BENEFICIALOWNER[0]['NATIONALITY']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Date Of Birth</td>
			<td width="33%">
				<input type="text" class="form-control input-sm datepicker" name="DATEOFBIRTH" id="DATEOFBIRTH${UNQID}" value="${BENEFICIALOWNER[0]['DATEOFBIRTH']}">
			</td>
		</tr>
		<tr>
			<td width="15%">PAN No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PANNO" id="PANNO${UNQID}" value="${BENEFICIALOWNER[0]['PANNO']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Aadhar No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="AADHARNO" id="AADHARNO${UNQID}" value="${BENEFICIALOWNER[0]['AADHARNO']}">
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="saveBeneficialOwner${UNQID}">
				<c:choose>
					<c:when test="${LINENO eq '0'}">
						Save
					</c:when>
					<c:otherwise>
						Update
					</c:otherwise>
				</c:choose>
				</button>
			</td>
		</tr>
	</table>
</form>