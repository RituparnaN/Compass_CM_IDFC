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
			$("#saveDirector"+id).removeAttr("disabled");
		}else{
			$("#saveDirector"+id).attr("disabled", "disabled");
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#saveDirector"+id).click(function(){
			var formObj = $("#saveDirectorForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveDirector",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshDirectors();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveDirectorForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NAME" id="NAME${UNQID}" value="${DIRECTOR[0]['NAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Address</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="ADDRESS" id="ADDRESS${UNQID}" value="${DIRECTOR[0]['ADDRESS']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Nationality</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NATIONALITY" id="NATIONALITY${UNQID}" value="${DIRECTOR[0]['NATIONALITY']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Date Of Birth</td>
			<td width="33%">
				<input type="text" class="form-control input-sm datepicker" name="DATEOFBIRTH" id="DATEOFBIRTH${UNQID}" value="${DIRECTOR[0]['DATEOFBIRTH']}">
			</td>
		</tr>
		<tr>
			<td width="15%">PAN No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="PANNO" id="PANNO${UNQID}" value="${DIRECTOR[0]['PANNO']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Aadhar No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="AADHARNO" id="AADHARNO${UNQID}" value="${DIRECTOR[0]['AADHARNO']}">
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="saveDirector${UNQID}">
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