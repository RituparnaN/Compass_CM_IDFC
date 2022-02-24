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
			$("#saveNomineeDetail"+id).removeAttr("disabled");
		}else{
			$("#saveNomineeDetail"+id).attr("disabled", "disabled");
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#saveNomineeDetail"+id).click(function(){
			var formObj = $("#saveNomineeDetailForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveNomineeDetail",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshNomineeDetail();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveNomineeDetailForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NOMINEENAME" id="NOMINEENAME${UNQID}" value="${NOMINEEDETAIL[0]['NOMINEENAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Address</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NOMINEEADDRESS" id="NOMINEEADDRESS${UNQID}" value="${NOMINEEDETAIL[0]['NOMINEEADDRESS']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Date Of Birth</td>
			<td width="33%">
				<input type="text" class="form-control input-sm datepicker" name="NOMINEEDOB" id="NOMINEEDOB${UNQID}"  value="${NOMINEEDETAIL[0]['NOMINEEDOB']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Aadhar No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NOMINEEAADHAR" id="NOMINEEAADHAR${UNQID}" value="${NOMINEEDETAIL[0]['NOMINEEAADHAR']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Relation with Primary</td>
			<td width="33%">
				<select class="form-control input-sm" name="RELATIONWITHPRIMARY" id="RELATIONWITHPRIMARY${UNQID}">
					<option value="Father" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Father'}">selected="selected"</c:if> >Father</option>
					<option value="Mother" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Mother'}">selected="selected"</c:if>>Mother</option>
					<option value="Spouse" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Spouse'}">selected="selected"</c:if>>Spouse</option>
					<option value="Son" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Son'}">selected="selected"</c:if>>Son</option>
					<option value="Daughter" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Daughter'}">selected="selected"</c:if>>Daughter</option>
					<option value="Siblings" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Siblings'}">selected="selected"</c:if>>Siblings</option>
					<option value="Close Friend" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Close Friend'}">selected="selected"</c:if>>Close Friend</option>
					<option value="Other" <c:if test="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARY'] eq 'Other'}">selected="selected"</c:if>>Other</option>
				</select>
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Other relationship</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="RELATIONWITHPRIMARYOTHER" id="RELATIONWITHPRIMARYOTHER${UNQID}" value="${NOMINEEDETAIL[0]['RELATIONWITHPRIMARYOTHER']}">
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="saveNomineeDetail${UNQID}">
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