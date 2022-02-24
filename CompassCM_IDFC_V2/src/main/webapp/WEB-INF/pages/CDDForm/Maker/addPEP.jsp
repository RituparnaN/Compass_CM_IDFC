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
			$("#savePEP"+id).removeAttr("disabled");
		}else{
			$("#savePEP"+id).attr("disabled", "disabled");
		}
		
		$("#savePEP"+id).click(function(){
			var formObj = $("#savePEPForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/savePEP",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshPEP();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="savePEPForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PEPNAME" id="PEPNAME${UNQID}" value="${PEPDETAILS[0]['PEPNAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Nationality</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PEPNATIONALITY" id="PEPNATIONALITY${UNQID}" value="${PEPDETAILS[0]['PEPNATIONALITY']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Position Held in Government</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PEPPOSITIONINGOVT" id="PEPPOSITIONINGOVT${UNQID}" value="${PEPDETAILS[0]['PEPPOSITIONINGOVT']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Position Held in Company</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PEPPOSITIONINCOMPANY" id="PEPPOSITIONINCOMPANY${UNQID}" value="${PEPDETAILS[0]['PEPPOSITIONINCOMPANY']}">
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="savePEP${UNQID}">
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