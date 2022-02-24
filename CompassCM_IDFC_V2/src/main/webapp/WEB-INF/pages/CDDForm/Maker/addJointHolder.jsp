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
			$("#saveJointHolder"+id).removeAttr("disabled");
		}else{
			$("#saveJointHolder"+id).attr("disabled", "disabled");
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#saveJointHolder"+id).click(function(){
			var formObj = $("#saveJointHolderForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveJointHolder",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshJointHolder();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveJointHolderForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="JOINTHOLDERNAME" id="JOINTHOLDERNAME${UNQID}" value="${JOINHOLDER[0]['JOINTHOLDERNAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Address</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="JOINTHOLDERADDRESS" id="JOINTHOLDERADDRESS${UNQID}" value="${JOINHOLDER[0]['JOINTHOLDERADDRESS']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Pan No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="JOINTHOLDERPAN" id="JOINTHOLDERPAN${UNQID}"  value="${JOINHOLDER[0]['JOINTHOLDERPAN']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Aadhar No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="JOINTHOLDERAADHAR" id="JOINTHOLDERAADHAR${UNQID}" value="${JOINHOLDER[0]['JOINTHOLDERAADHAR']}">
			</td>
		</tr>
		<tr>
			<td width="15%">Relation with Primary</td>
			<td width="33%">
				<select class="form-control input-sm" name="RELATIONWITHPRIMARY" id="RELATIONWITHPRIMARY${UNQID}">
					<option value="Father" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Father'}">selected="selected"</c:if> >Father</option>
					<option value="Mother" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Mother'}">selected="selected"</c:if>>Mother</option>
					<option value="Spouse" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Spouse'}">selected="selected"</c:if>>Spouse</option>
					<option value="Son" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Son'}">selected="selected"</c:if>>Son</option>
					<option value="Daughter" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Daughter'}">selected="selected"</c:if>>Daughter</option>
					<option value="Siblings" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Siblings'}">selected="selected"</c:if>>Siblings</option>
					<option value="Close Friend" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Close Friend'}">selected="selected"</c:if>>Close Friend</option>
					<option value="Other" <c:if test="${JOINHOLDER[0]['RELATIONWITHPRIMARY'] eq 'Other'}">selected="selected"</c:if>>Other</option>
				</select>
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Other relationship</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="RELATIONWITHPRIMARYOTHER" id="RELATIONWITHPRIMARYOTHER${UNQID}" value="${JOINHOLDER[0]['RELATIONWITHPRIMARYOTHER']}">
			</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="saveJointHolder${UNQID}">
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