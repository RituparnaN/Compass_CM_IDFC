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
			$("#saveAuthorizedSignatory"+id).removeAttr("disabled");
		}else{
			$("#saveAuthorizedSignatory"+id).attr("disabled", "disabled");
		}
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});

		$("#checkAuthroziedSignatoryPANNo"+id).click(function(){
			$("#checkAuthroziedSignatoryPANNo"+id).attr("disabled", true);
			$("#checkAuthroziedSignatoryPANNo"+id).html("Validating");
			
			var PANNO = $("#AUTH_PANNO"+id).val();
			var fullData =  "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO+"&PANNO="+PANNO;
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/validateCustomerPANNo",
				type : "POST",
				cache : false,
				data : fullData,
				success : function(res){
					//var panValidationResponse = res['validationResult'];
					$("#AUTH_PANNSDLRESPONSE"+id).val(res);
					$("#checkAuthroziedSignatoryPANNo"+id).removeAttr("disabled");
					$("#checkAuthroziedSignatoryPANNo"+id).html("Check Pan");
					/*
					$("#calculateCDDRisk"+id).removeAttr("disabled");
					$("#calculateCDDRisk"+id).html("Calculate");
					
					var DUEDILIGENCE = res['DUEDILIGENCE'];
					var RISKRATING = res['RISKRATING'];
					var RISKRATINGTEXT = res['RISKRATINGTEXT'];
					var riskRating = RISKRATING+" - "+RISKRATINGTEXT+" ("+DUEDILIGENCE+")";
					$("#SYSTEMRISKRATING"+id).val(riskRating);
					
					var isChecked = $("#RR_CHARACTERISTICS_1"+id).prop("checked");
					if(!isChecked){
						$("#PROVISIONALRISKRATING"+id).val(riskRating);
					}
					*/
				},
				error : function(){
					var panValidationResponse = "Error while validation PAN No";
					$("#AUTH_PANNSDLRESPONSE"+id).val(panValidationResponse);
					
					alert("Error while saving form");
					$("#checkAuthroziedSignatoryPANNo"+id).removeAttr("disabled");
					$("#checkAuthroziedSignatoryPANNo"+id).html("Check Pan");
				}
			});
		});
		
		$("#saveAuthorizedSignatory"+id).click(function(){
			var formObj = $("#saveAuthorizedSignatoryForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveAuthorizedSignatory",
				type : "POST",
				cache : false,
				data : formData+"&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&FORMLINENO="+FORMLINENO,
				success : function(res){
					alert(res);
					refreshAuthorizedSignatories();
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#authSignRAAddress"+id).click(function(){
			$("#ADDRESS"+id).val($("#RESIDENTIALADDRESS"+id).val());
		});
		$("#authSignMAAddress"+id).click(function(){
			$("#ADDRESS"+id).val($("#MAILINGADDRESS"+id).val());
		});
	});
</script>
<form action="javascript:void(0)" method="POST" id="saveAuthorizedSignatoryForm${UNQID}">
	<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
		<tr>
			<td width="15%">Full Name</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NAME" id="NAME${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['NAME']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">
				Passport No. / Other ID Proof
			</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="ADDRESS" id="ADDRESS${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['ADDRESS']}"/>
				<br/>
				<!--<button type="button" class="btn btn-primary btn-xs" id="authSignRAAddress${UNQID}">Customer's Registered Address</button>-->
				<!--<button type="button" class="btn btn-primary btn-xs" id="authSignMAAddress${UNQID}">Customer's Mailing Address</button>-->
			</td>
		</tr>
		<tr>
			<td width="15%">Nationality</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="NATIONALITY" id="NATIONALITY${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['NATIONALITY']}">
			</td>
			<td width="4%">&nbsp;</td>
			<td width="15%">Date Of Birth</td>
			<td width="33%">
				<input type="text" class="form-control input-sm datepicker" name="DATEOFBIRTH" id="DATEOFBIRTH${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['DATEOFBIRTH']}">
			</td>
		</tr>
		<tr>
			<td width="15%">PAN No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="AUTH_PANNO" id="AUTH_PANNO${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['PANNO']}">
			</td>
			<td>
				<button type="button" class="btn btn-primary btn-sm" id="checkAuthroziedSignatoryPANNo${UNQID}">Check PAN</button>
			</td>
			<td width="15%">NSDL Response</td>
			<td width="33%">
				<textarea rows="2" cols="2" class="form-control" name="AUTH_PANNSDLRESPONSE" id="AUTH_PANNSDLRESPONSE${UNQID}" readOnly>${AUTHORIZEDSIGNATORY[0]['PANNSDLRESPONSE']}</textarea>
			</td>
		</tr>
		<tr>
			<td width="15%">Aadhar No</td>
			<td width="33%">
				<input type="text" class="form-control input-sm" name="AADHARNO" id="AADHARNO${UNQID}" value="${AUTHORIZEDSIGNATORY[0]['AADHARNO']}">
			</td>
			<td colspan = "3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="5" style="text-align: right;">
				<button type="button" class="btn btn-success btn-sm" id="saveAuthorizedSignatory${UNQID}">
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