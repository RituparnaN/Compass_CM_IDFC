<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var ="OPTIONIDLIST"  value = "${QUESTIONDETAILS['OPTIONNAME']}"></c:set>
<c:set var ="OPTIONVALUE"  value = "${QUESTIONDETAILS['OPTIONVALUE']}"></c:set>
<c:set var ="IMPACTRISK"  value = "${QUESTIONDETAILS['IMPACTRISKRATING']}"></c:set>
<c:set var ="LIKELIHOODRISK"  value = "${QUESTIONDETAILS['LIKELIHOODRISKRATING']}"></c:set>
<c:set var ="CURRENT_STATUS" value= "${QUESTIONDETAILS['STATUS']}"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var userRole = '${USERROLE}';
	var currentTimestamp = compassTopFrame.getDate(new Date(),"","");
	var searchButton = '${searchButton}';
	var assessmentSection = '${assessmentSection}';
	//console.log(assessmentSection);
	
	if(assessmentSection === "ControlParameters"){
		$("#riskRatingHeader"+id).css("display", "none");
		$("#riskRatingOptionRow1"+id).css("display", "none");
		$("#riskRatingOptionRow2"+id).css("display", "none");
		$("#riskRatingOptionRow3"+id).css("display", "none");
		
		$("#assCtrlScrHeader"+id).css("display", "table-row");
		$("#assCtrlScrOptionRow1"+id).css("display", "table-row");
		$("#assCtrlScrOptionRow2"+id).css("display", "table-row");
		$("#assCtrlScrOptionRow3"+id).css("display", "table-row");
		
	}else{
		$("#riskRatingHeader"+id).css("display", "table-row");
		$("#riskRatingOptionRow1"+id).css("display", "table-row");
		$("#riskRatingOptionRow2"+id).css("display", "table-row");
		$("#riskRatingOptionRow3"+id).css("display", "table-row");
		
		$("#assCtrlScrHeader"+id).css("display", "none");
		$("#assCtrlScrOptionRow1"+id).css("display", "none");
		$("#assCtrlScrOptionRow2"+id).css("display", "none");
		$("#assCtrlScrOptionRow3"+id).css("display", "none");
	}
	
	if(userRole == 'ROLE_CM_ADMINMAKER'){
		$("#checkerComments"+id).prop("readonly", "readonly");
		$("#makerTimestamp"+id).val(currentTimestamp);
		$("#makerCode"+id).val("${USERCODE}");
	}else{
		$("#checkerCode"+id).val("${USERCODE}");
		$("#checkerTimestamp"+id).val(currentTimestamp);
		$("#question"+id).prop("readonly", "readonly");
		$('input[type=radio]').attr('disabled', true);
		$("#option1Name"+id).prop("readonly", "readonly");
		$("#option2Name"+id).prop("readonly", "readonly");
		$("#option3Name"+id).prop("readonly", "readonly");
		$("#option1ImpactRiskValue"+id).prop("disabled", true);
		$("#option2ImpactRiskValue"+id).prop("disabled", true);
		$("#option3ImpactRiskValue"+id).prop("disabled", true);
		$("#option1LikelihoodRiskValue"+id).prop("disabled", true);
		$("#option2LikelihoodRiskValue"+id).prop("disabled", true);
		$("#option3LikelihoodRiskValue"+id).prop("disabled", true);
		$("#makerComments"+id).prop("readonly", "readonly");
	}
	
	$("button[name='updateQuestionButton']").click(function(){
		var status = $(this).val();
		var isEnabled = $("input[name='isEnabled']:checked").val();
		var question = $("#question"+id).val();
		var makerComments = $("#makerComments"+id).val();
		var checkerComments = $("#checkerComments"+id).val();
		var isFreeTextReq = $("input[name='isFreeTextRequired']:checked").val();
		var option1Name = $("#option1Name"+id).val();
		var option2Name = $("#option2Name"+id).val();
		var option3Name = $("#option3Name"+id).val();
		var allowSave = true;
				
		if(isEnabled == undefined){
			alert("Please check is enabled.");
			allowSave =  false;
		}
		
		if(question == ""){
			alert("Please enter the question.");
			allowSave =  false;
		} 
		
		if(isFreeTextReq == undefined){
			alert("Please check is free text required.");
			allowSave =  false;
		}
		
		if(makerComments == "" && userRole == "ROLE_CM_ADMINMAKER"){
			alert("Please enter the maker comments.");
			allowSave =  false;
		} 
		
		if(checkerComments == "" && userRole != "ROLE_CM_ADMINMAKER"){
			alert("Please enter the checker comments.");
			allowSave =  false;
		} 
		
		if(allowSave){ 
			var formValues = $("#riskAssessmentQuestionForm"+id).serialize();
			console.log(formValues+"&status="+status);
			$.ajax({
				url: "${pageContext.request.contextPath}/cmAdmin/saveRiskAssessmentQuestionnaire",
				cache: false,
				type: "POST",
				data: formValues+"&status="+status,
				success: function(res){
					alert(res);
					//$("#riskAssessmentQuestionForm"+id).trigger('reset');
					$("#"+searchButton).click();
					$("#compassCaseWorkFlowGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}
	})
});
</script>
<div class="row compassrow">
	<div class="col-sm-12">
	<div class="card card-primary addNewRiskParamModal">
	<form action="javascript:void(0)" method="POST" id="riskAssessmentQuestionForm${UNQID}">
	<input type="hidden" value="${QUESTIONDETAILS['ASSESSMENTUNIT']}" name="assessmentUnit"></input>
	<input type="hidden" value="${QUESTIONDETAILS['ASSESSMENTSECTIONCODE']}" name="assessmentSectionCode"></input>
	<input type="hidden" value="${QUESTIONDETAILS['ASSESSMENTSUBGROUP']}" name="assessmentSubGroup"></input>
	<input type="hidden" value="${questionId}" name="questionId"></input>
		<table class="table table-striped table-bordered" style="margin-bottom: 0px;">
			<tr>
				<td width="15%">
					Question
				</td>
				<td colspan="4">
					<textarea class="form-control input-sm" id="question${UNQID}" name="question" 
					 placeholder="Type Question">${QUESTIONDETAILS['QUESTIONDESCRIPTION']}</textarea>
				</td>
			<tr>	
			</tr>
				<td width="15%">
					Is Enabled
				</td>
				<td width="30%" style="padding-left: 20px;">
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isEnabled">
						<input type="radio" name="isEnabled" id="isEnabledYes${UNQID}" value="Y"
						<c:if test="${QUESTIONDETAILS['ISENABLED'] eq 'Y'}">checked="checked"</c:if>/>
						Yes
					</label>
					&nbsp;
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isEnabled">
						<input type="radio" name="isEnabled" id="isEnabledNo${UNQID}" value="N"
						<c:if test="${QUESTIONDETAILS['ISENABLED'] eq 'N'}">checked="checked"</c:if>/>
						No
					</label>
				</td>
				<td width="5%">&nbsp;</td>
				<td width="20%">
					Is Free Text Required
				</td>
				<td width="30%" style="padding-left: 20px;">
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isFreeTextRequired">
						<input type="radio" name="isFreeTextRequired" id="isFreeTextRequiredYes${UNQID}" value="Y"
						<c:if test="${QUESTIONDETAILS['ISFREETEXTAREAREQUIRED'] eq 'Y'}">checked="checked"</c:if>/>
						Yes
					</label>
					&nbsp;
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isFreeTextRequired">
						<input type="radio" name="isFreeTextRequired" id="isFreeTextRequiredNo${UNQID}" value="N"
						<c:if test="${QUESTIONDETAILS['ISFREETEXTAREAREQUIRED'] eq 'N'}">checked="checked"</c:if>/>
						No
					</label>
				</td>
			</tr>			
			<tr>
				<td colspan="5">
					<table class="table table-bordered">
						<thead>
							<tr id="riskRatingHeader${UNQID}" class="info">
								<th>Option No.</th>
								<th>Range</th>
								<th>Impact Risk Rating</th>
								<th>Likelihood Risk Rating</th>
							</tr>
							<tr id="assCtrlScrHeader${UNQID}" style="display: none;" class="info">
								<th>Option No.</th>
								<th>Range</th>
								<th>Assessment Control Score</th>
							</tr>
						</thead>
						<tbody>
							<tr id="riskRatingOptionRow1${UNQID}">
								<td>Option 1</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[0]}" name="option1Name" id="option1Name${UNQID}"/>
								</td>
								<td>
									<select class="form-control" name="option1ImpactRiskValue" id="option1ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[0] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${IMPACTRISK[0] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${IMPACTRISK[0] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option1LikelihoodRiskValue" id="option1LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${LIKELIHOODRISK[0] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${LIKELIHOODRISK[0] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${LIKELIHOODRISK[0] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow1${UNQID}" style="display: none;">
								<td>Option 1</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[0]}" name="acOption1Name" id="acOption1Name${UNQID}"/>
								</td>
								<td>
									<select class="form-control" name="option1AssessmentCtrlScore" id="option1AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[0] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${IMPACTRISK[0] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${IMPACTRISK[0] eq '3'}">selected="selected"</c:if>>3-No Control</option>
									</select>
								</td>
							</tr>
							<tr id="riskRatingOptionRow2${UNQID}">
								<td>Option 2</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[1]}" name="option2Name" id="option2Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option2ImpactRiskValue" id="option2ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[1] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${IMPACTRISK[1] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${IMPACTRISK[1] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option2LikelihoodRiskValue"  id="option2LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${LIKELIHOODRISK[1] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${LIKELIHOODRISK[1] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${LIKELIHOODRISK[1] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow2${UNQID}" style="display: none;">
								<td>Option 2</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[1]}" name="acOption2Name" id="acOption2Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option2AssessmentCtrlScore" id="option2AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[1] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${IMPACTRISK[1] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${IMPACTRISK[1] eq '3'}">selected="selected"</c:if>>3-No Control</option>
									</select>
								</td>
							</tr>
							<tr id="riskRatingOptionRow3${UNQID}">
								<td>Option 3</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[2]}" name="option3Name" id="option3Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option3ImpactRiskValue" id="option3ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[2] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${IMPACTRISK[2] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${IMPACTRISK[2] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option3LikelihoodRiskValue" id="option3LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${LIKELIHOODRISK[2] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${LIKELIHOODRISK[2] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${LIKELIHOODRISK[2] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow3${UNQID}" style="display: none;">
							<td>Option 3</td>
								<td>
									<input type="text" class="form-control input-sm" 
									value="${OPTIONIDLIST[2]}" name="acOption3Name" id="acOption3Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option3AssessmentCtrlScore" id="option3AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${IMPACTRISK[2] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${IMPACTRISK[2] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${IMPACTRISK[2] eq '3'}">selected="selected"</c:if>>3-No Control</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td width="15%">
					Maker Code
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="makerCode${UNQID}" name="makerCode" value="${QUESTIONDETAILS['MAKERCODE']}" readonly="readonly"/>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Maker Timestamp
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="makerTimestamp${UNQID}" name="makerTimestamp" value="${QUESTIONDETAILS['MAKERTIMESTAMP']}" readonly="readonly"/>
				</td>
			</tr>	
			<tr>
				<td width="15%">
					Maker Comments
				</td>
				<td colspan="4">
					<textarea class="form-control input-sm" id="makerComments${UNQID}" name="makerComments">${QUESTIONDETAILS['MAKERCOMMENTS']}</textarea>
				</td>
			</tr>	
			<tr>
				<td width="15%">
					Checker Code
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="checkerCode${UNQID}" name="checkerCode"  value="${QUESTIONDETAILS['CHECKERCODE']}" readonly="readonly"/>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Checker Timestamp
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="checkerTimestamp${UNQID}" name="checkerTimestamp" value="${QUESTIONDETAILS['CHECKERTIMESTAMP']}" readonly="readonly"/>
				</td>
			</tr>	
			<tr>
				<td width="15%">
					Checker Comments
				</td>
				<td colspan="4">
					<textarea class="form-control input-sm" id="checkerComments${UNQID}" name="checkerComments">${QUESTIONDETAILS['CHECKERCOMMENTS']}</textarea>
				</td>
			</tr>	
		</table>
		
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<c:if test="${USERROLE eq 'ROLE_CM_ADMINMAKER'}">
					<button type="button" class="btn btn-primary btn-sm" name="updateQuestionButton" id="saveQuestionButton${UNQID}" value="P">Save</button>
				</c:if>
				<c:if test="${USERROLE ne 'ROLE_CM_ADMINMAKER' && CURRENT_STATUS eq 'P'}">
					<button type="button" class="btn btn-success btn-sm" name="updateQuestionButton" id="approveQuestionButton${UNQID}" value="A">Approve</button>
					<button type="button" class="btn btn-danger btn-sm" name="updateQuestionButton" id="rejectQuestionButton${UNQID}" value="R">Reject</button>
				</c:if>
			</div>
		</div>
		</form>
	</div>
</div>
</div>