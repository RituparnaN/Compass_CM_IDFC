<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<!DOCTYPE html>
<script>
$(document).ready(function(){
	var id = '${UNQID}';
	var currentRole = '${USERROLE}';
	
	var currentTimestamp = compassTopFrame.getDate(new Date(),"","");
	$("#makerTimestamp"+id).val(currentTimestamp);
	
	let questionCategory = {};
	<c:forEach var = "assesmentUnit" items="${QUESTIONCATEGORY}">
		questionCategory["${assesmentUnit.key}"] = {};
		<c:forEach var="assesmentSectionCode" items="${assesmentUnit.value}">
			questionCategory["${assesmentUnit.key}"]["${assesmentSectionCode.key}"] = [];
			<c:forEach var="subGroup" items = "${assesmentSectionCode.value}">
				questionCategory["${assesmentUnit.key}"]["${assesmentSectionCode.key}"].push("${subGroup}");
			</c:forEach>
		</c:forEach>
	</c:forEach>
	//console.log(questionCategory);
	
	function generateSelectOption(arr){
		let optionHtml = "";
		for (var i=0;i<arr.length;i++) {
			optionHtml += '<option value = "'+arr[i]+'">'+arr[i]+' </option>';
		}
		return optionHtml;
	}
	
	//let assessmentUnit = Object.keys(questionCategory);
	let assessmentUnitSelectOptions = generateSelectOption(Object.keys(questionCategory));
	//debugger;
	$("#assessmentUnit"+id).append(assessmentUnitSelectOptions);
	
	// section code
	$("#assessmentUnit"+id).on('change', function() {
		//alert($(this).val());
		//console.log(Object.keys(questionCategory[$(this).val()]));
		let assessmentSectionCodeOptions = generateSelectOption(Object.keys(questionCategory[$(this).val()]));
		$("#assessmentSectionCode"+id).html("");
		$("#assessmentSectionCode"+id).html(assessmentSectionCodeOptions);
		$("#assessmentSectionCode"+id).prop("disabled", false);
		$("#assessmentSectionCode"+id).change();
		
	}) 
	
	//sub group 
	$("#assessmentSectionCode"+id).on('change',function(){
		let selectedAssessmentUnit = $("#assessmentUnit"+id).val();
		let selectedAssessmentSectionCode = $(this).val();
		let subGroupArr = questionCategory[selectedAssessmentUnit][selectedAssessmentSectionCode];
		$("#assessmentSubGroup"+id).html(generateSelectOption(subGroupArr));
		$("#assessmentSubGroup"+id).prop("disabled", false);
		
		if(selectedAssessmentSectionCode === "ControlParameters"){
			$("#riskRatingHeader").css("display", "none");
			$("#riskRatingOptionRow1").css("display", "none");
			$("#riskRatingOptionRow2").css("display", "none");
			$("#riskRatingOptionRow3").css("display", "none");
			
			$("#assCtrlScrHeader").css("display", "table-row");
			$("#assCtrlScrOptionRow1").css("display", "table-row");
			$("#assCtrlScrOptionRow2").css("display", "table-row");
			$("#assCtrlScrOptionRow3").css("display", "table-row");
			
		}else{
			$("#riskRatingHeader").css("display", "table-row");
			$("#riskRatingOptionRow1").css("display", "table-row");
			$("#riskRatingOptionRow2").css("display", "table-row");
			$("#riskRatingOptionRow3").css("display", "table-row");
			
			$("#assCtrlScrHeader").css("display", "none");
			$("#assCtrlScrOptionRow1").css("display", "none");
			$("#assCtrlScrOptionRow2").css("display", "none");
			$("#assCtrlScrOptionRow3").css("display", "none");
		}
	});
	
	
	//submit form

	$("#addQuestionButton"+id).click(function(){
		/* if($("#question"+id).val()== "" ){
			alert("Plese Enter the question");
			return false;
		} */
		var isEnabled = $("input[name='isEnabled']:checked").val();
		var assessmentUnit = $("#assessmentUnit"+id).val();
		var assessmentSectionCode = $("#assessmentSectionCode"+id).val();
		var assessmentSubGroup = $("#assessmentSubGroup"+id).val();
		var question = $("#question"+id).val();
		var isFreeTextReq = $("input[name='isFreeTextRequired']:checked").val();
		var option1Name = $("#option1Name"+id).val();
		var option2Name = $("#option2Name"+id).val();
		var option3Name = $("#option3Name"+id).val();
		var option1ImpactRiskValue = $("#option1ImpactRiskValue"+id).val();
		var option2ImpactRiskValue = $("#option2ImpactRiskValue"+id).val();
		var option3ImpactRiskValue = $("#option3ImpactRiskValue"+id).val();
		var option1LikelihoodRiskValue = $("#option1LikelihoodRiskValue"+id).val();
		var option2LikelihoodRiskValue = $("#option2LikelihoodRiskValue"+id).val();
		var option3LikelihoodRiskValue = $("#option3LikelihoodRiskValue"+id).val();
		var option1AssCtrlScore = $("#option1AssessmentCtrlScore"+id).val();
		var option2AssCtrlScore = $("#option2AssessmentCtrlScore"+id).val();
		var option3AssCtrlScore = $("#option3AssessmentCtrlScore"+id).val();
		var makerComments = $("#makerComments"+id).val();
		var allowSave = true;
	//	alert(isEnabled+" "+isFreeTextReq);
		
		if(isEnabled == undefined){
			alert("Please check is enabled.");
			allowSave =  false;
		}
		
		if(assessmentUnit == ""){
			alert("Please enter the assessment unit.");
			allowSave =  false;
		}
		
		if(assessmentSectionCode == ""){
			alert("Please enter the assessment section code.");
			allowSave =  false;
		}
		
		if(assessmentSubGroup == ""){
			alert("Please enter the assessment sub group.");
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
		
		if((option1Name == "" || option2Name == "" || option3Name == "")  && (assessmentSectionCode !== "ControlParameters")){
			alert("Please enter value for Options.");
			allowSave =  false;
		}
		
		if(option1ImpactRiskValue == "" || option2ImpactRiskValue == "" || option3ImpactRiskValue == ""){
			alert("Please enter value for Impact Risk Ratings.");
			allowSave =  false;
		}
		
		if(option1LikelihoodRiskValue == "" || option2LikelihoodRiskValue == "" || option3LikelihoodRiskValue == ""){
			alert("Please enter value for Likelihood Risk Ratings.");
			allowSave =  false;
		}
		
		if((option1AssCtrlScore == "" || option2AssCtrlScore == "" || option3AssCtrlScore == "") && (assessmentSectionCode === "ControlParameters")){
			alert("Please enter value for Assessment Control Score.");
			allowSave =  false;
		}
		
		if(makerComments == ""){
			alert("Please enter the maker comments.");
			allowSave =  false;
		} 
		
		if(allowSave){ 
			var formValues = $("#riskAssessmentQuestionForm"+id).serialize();
			//alert(formValues);
			$.ajax({
				url: "${pageContext.request.contextPath}/cmAdmin/saveRiskAssessmentQuestionnaire",
				cache: false,
				type: "POST",
				data: formValues+"&status=P",
				success: function(res){
					alert(res);			
					reloadTabContent();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});	
		}
	});
	
});
</script>
<style type="text/css">
	fieldset.suspicion{
	border: 1px groove #ddd !important;
    padding: -5px 10px 5px 10px!important;
    margin: 5px 0 0 0 !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.suspicion {
	text-align: left !important;
	width:inherit; 
    border-bottom:none;
    margin: 0px;
    margin-left: 10px;
    margin-bottom : 5px;
    padding: 0px;
}
</style>
<div class="row compassrow">
	<div class="col-sm-12">
	<div class="card card-primary addNewQuestions">
	<div class="card-header panelAddQuestionnaire${UNQID} clearfix">
		<h6 class="card-title pull-${dirL}">Add Questionnaire</h6>
	</div>
	<form action="javascript:void(0)" method="POST" id="riskAssessmentQuestionForm${UNQID}">
		<table class="table table-striped table-bordered" style="margin-bottom: 0px;">
			<!-- <fieldset class="suspicion">
		<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Subject Matter of Suspicion</legend> -->
			<tr>
				<td width="20%">
					Is Enabled
				</td>
				<td width="25%" style="padding-left: 20px;">
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isEnabled">
						<input type="radio" name="isEnabled" id="isEnabledYes${UNQID}" value="Y"/>
						Yes
					</label>
					&nbsp;
					<label class="btn btn-outline btn-primary btn-sm radio-inline" for="isEnabled">
						<input type="radio" name="isEnabled" id="isEnabledNo${UNQID}" value="N"/>
						No
					</label>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="20%">
					Assessment Unit
				</td>
				<td width="25%">
			      <select class="form-control input-sm" name="assessmentUnit" id="assessmentUnit${UNQID}">
			      	<option value = "Select">Select</option>
			      </select>
			     </td>
			</tr>
			<tr>
				<td width="20%">
					Assessment Section Code
				</td>
				<td width="25%">
			      <select class="form-control input-sm" name="assessmentSectionCode" id="assessmentSectionCode${UNQID}" disabled></select>
			    </td>
				<td width="10%">&nbsp;</td>
				<td width="20%">
					Assessment Sub Group
				</td>
				<td width="25%">
			      <select class="form-control input-sm" name="assessmentSubGroup" id="assessmentSubGroup${UNQID}" disabled></select>
			    </td>
			</tr>
			<tr>
				<td width="20%">
					Question
				</td>
				<td width="25%">
					<textarea class="form-control input-sm" id="question${UNQID}" name="question" 
					 placeholder="Type Question"></textarea>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="20%">
					Is Free Text Required
				</td>
				<td width="25%" style="padding-left: 20px;">
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
							<tr id="riskRatingHeader" class="info">
								<th>Option No.</th>
								<th>Range</th>
								<th>Impact Risk Rating</th>
								<th>Likelihood Risk Rating</th>
							</tr>
							<tr id="assCtrlScrHeader" style="display: none;" class="info">
								<th>Option No.</th>
								<th>Range</th>
								<th>Assessment Control Score</th>
							</tr>
						</thead>
						<tbody>
							<tr id="riskRatingOptionRow1">
								<td>Option 1</td>
								<td>
									<input type="text" class="form-control input-sm" 
									 name="option1Name" id="option1Name${UNQID}"/>
									<%-- onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')"  --%>
								</td>
								<td>
									<select class="form-control" name="option1ImpactRiskValue" id="option1ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[0] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE[0] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE[0] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option1LikelihoodRiskValue" id="option1LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE1[0] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE1[0] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE1[0] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow1" style="display: none;">
								<td>Option 1</td>
								<td>
									<input type="text" class="form-control input-sm" 
									 name="acOption1Name" id="acOption1Name${UNQID}"/>
								</td>
								<td>
									<select class="form-control" name="option1AssessmentCtrlScore" id="option1AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[0] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${OPTIONVALUE[0] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${OPTIONVALUE[0] eq '3'}">selected="selected"</c:if>>3-No Control</option>
									</select>
								</td>
							</tr>
							<tr id="riskRatingOptionRow2">
								<td>Option 2</td>
								<td>
									<input type="text" class="form-control input-sm" 
									 name="option2Name" id="option2Name${UNQID}" />
									<%-- onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')"  --%>
								</td>
								<td>
									<select class="form-control" name="option2ImpactRiskValue" id="option2ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[1] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE[1] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE[1] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option2LikelihoodRiskValue"  id="option2LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE1[1] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE1[1] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE1[1] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow2" style="display: none;">
								<td>Option 2</td>
								<td>
									<input type="text" class="form-control input-sm" 
									 name="acOption2Name" id="acOption2Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option2AssessmentCtrlScore" id="option2AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[1] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${OPTIONVALUE[1] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${OPTIONVALUE[1] eq '3'}">selected="selected"</c:if>>3-No Control</option>
									</select>
								</td>
							</tr>
							<tr id="riskRatingOptionRow3">
								<td>Option 3</td>
								<td>
									<input type="text" class="form-control input-sm" 
									name="option3Name" id="option3Name${UNQID}" />
									<%-- onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" --%>
								</td>
								<td>
									<select class="form-control" name="option3ImpactRiskValue" id="option3ImpactRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[2] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE[2] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE[2] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
								<td>
									<select class="form-control" name="option3LikelihoodRiskValue" id="option3LikelihoodRiskValue${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE1[2] eq '1'}">selected="selected"</c:if>>1-Low</option>
										<option value ="2" <c:if test="${OPTIONVALUE1[2] eq '2'}">selected="selected"</c:if>>2-Medium</option>
										<option value ="3" <c:if test="${OPTIONVALUE1[2] eq '3'}">selected="selected"</c:if>>3-High</option>
									</select>
								</td>
							</tr>
							<tr id="assCtrlScrOptionRow3" style="display: none;">
								<td>Option 3</td>
								<td>
									<input type="text" class="form-control input-sm" 
									name="acOption3Name" id="acOption3Name${UNQID}" />
								</td>
								<td>
									<select class="form-control" name="option3AssessmentCtrlScore" id="option3AssessmentCtrlScore${UNQID}">
										<option value ="1" <c:if test="${OPTIONVALUE[2] eq '1'}">selected="selected"</c:if>>1-Effective</option>
										<option value ="2" <c:if test="${OPTIONVALUE[2] eq '2'}">selected="selected"</c:if>>2-Needs improvement</option>
										<option value ="3" <c:if test="${OPTIONVALUE[2] eq '3'}">selected="selected"</c:if>>3-No Control</option>
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
					<input type="text" class="form-control input-sm" id="makerCode${UNQID}" name="makerCode" value="${USERCODE}" readonly="readonly"/>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Maker Timestamp
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="makerTimestamp${UNQID}" name="makerTimestamp" readonly="readonly"/>
				</td>
			</tr>	
			<tr>
				<td width="15%">
					Maker Comments
				</td>
				<td colspan="4">
					<textarea class="form-control input-sm" id="makerComments${UNQID}" name="makerComments"></textarea>
				</td>
			</tr>	
			<%-- <tr>
				<td width="15%">
					Checker Code
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="checkerCode${UNQID}" name="checkerCode" value="${QUESTIONDETAILS['CHECKERCODE']}"/>
				</td>
				<td width="10%">&nbsp;</td>
				<td width="15%">
					Checker Timestamp
				</td>
				<td width="30%">
					<input type="text" class="form-control input-sm" id="checkerTimestamp${UNQID}" name="checkerTimestamp" value="${QUESTIONDETAILS['CHECKERTIMESTAMP']}"/>
				</td>
			</tr>	
			<tr>
				<td width="15%">
					Checker Comments
				</td>
				<td colspan="4">
					<textarea class="form-control input-sm" id="checkerComments${UNQID}" name="checkerComments">${QUESTIONDETAILS['CHECKERCOMMENTS']}</textarea>
				</td>
			</tr> --%>	
		</table>
		
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="button" class="btn btn-primary btn-sm" id="addQuestionButton${UNQID}">Add</button>
			</div>
		</div>
		</form>
	</div>
</div>
</div>
<%-- <div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
		<div class="card-header clearfix">
			<h6 class="card-title pull-${dirL}">Add Questions</h6>
		</div>
		<div class="col-sm-12" style="margin-top:20px;">
		<form action="javascript:void(0)" method="POST" id="riskAssessmentQuestionForm${UNQID}">
			<div class="col-sm-4">
				<div class="form-group">
			      <label for="sel1">Select Assessment Unit*:</label>
			      <select class="form-control" name="assessmentUnit" id="assessmentUnit${UNQID}">
			      	<option value = "Select">Select</option>
			      </select>
			    </div>
			</div>
			<div class="col-sm-4">
				<div class="form-group">
			      <label for="sel1">Select Assessment Section Code*:</label>
			      <select class="form-control" name="assessmentSectionCode" id="assessmentSectionCode${UNQID}" disabled>
			      </select>
			    </div>
			</div>
			<div class="col-sm-4">
				<div class="form-group">
			      <label for="sel1">Select Assessment Sub Group*:</label>
			      <select class="form-control" name="assessmentSubGroup" id="assessmentSubGroup${UNQID}" disabled>
			      </select>
			    </div>
			</div>
			<div class="col-sm-7" style="margin-top:30px;">
				<div class="form-group">
					<label for="sel1">Question*:</label>
					<input type="text" class="form-control input-sm" name="questionDescription" id="questionDescription${UNQID}" placeholder="Type Question"></input>
				</div>
			</div>
			<div class="col-sm-offset-1 col-sm-3" style="margin-top:30px;">
				<div class="form-group">
					<label for="sel1">Is Free Text Required*:</label>
					<select class="form-control" name="isFreeTextRequired" id="isFreeTextRequired${UNQID}">
						<option value ="Y">Yes</option>
						<option value ="N">No</option>
					</select>
				</div>
			</div>
			<div class="col-sm-6" >
			<table class="table table-bordered">
				<thead >
					<tr>
						<th>Option No.</th>
						<th>Range</th>
						<th>Impact Risk Rating</th>
						<th>Likelihood Risk Rating</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Option 1*</td>
						<td>
							<input type="text" class="form-control input-sm" 
							value="${OPTIONIDLIST[0]}" name="option1Id" id="option1Id${UNQID}"
							onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" ></input>
						</td>
						<td>
							<select class="form-control" name="option1ImpactRiskValue" id="option1ImpactRiskValue${UNQID}">
								<option value ="1">1-Low</option>
								<option value ="2">2-Medium</option>
								<option value ="3">3-High</option>
							</select>
						</td>
						<td>
							<select class="form-control" name="option1LikelihoodRiskValue" id="option1LikelihoodRiskValue${UNQID}">
								<option value ="1" >1-Low</option>
								<option value ="2" >2-Medium</option>
								<option value ="3" >3-High</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Option 2*</td>
						<td>
							<input type="text" class="form-control input-sm" 
							value="${OPTIONIDLIST[1]}" name="option2Id" id="option2Id${UNQID}"
							onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" ></input>
						</td>
						<td>
							<select class="form-control" name="option2ImpactRiskValue" id="option2ImpactRiskValue${UNQID}">
								<option value ="1" >1-Low</option>
								<option value ="2" >2-Medium</option>
								<option value ="3" >3-High</option>
							</select>
						</td>
						<td>
							<select class="form-control" name="option2LikelihoodRiskValue"  id="option2LikelihoodRiskValue${UNQID}">
								<option value ="1" >1-Low</option>
								<option value ="2" >2-Medium</option>
								<option value ="3" >3-High</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Option 3*</td>
						<td>
							<input type="text" class="form-control input-sm" 
							value="${OPTIONIDLIST[2]}" name="option3Id" id="option3Id${UNQID}"
							onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" ></input>
						</td>
						<td>
							<select class="form-control" name="option3ImpactRiskValue" id="option3ImpactRiskValue${UNQID}">
								<option value ="1" >1-Low</option>
								<option value ="2" >2-Medium</option>
								<option value ="3" >3-High</option>
							</select>
						</td>
						<td>
							<select class="form-control" name="option3LikelihoodRiskValue" id="option3LikelihoodRiskValue${UNQID}">
								<option value ="1" >1-Low</option>
								<option value ="2" >2-Medium</option>
								<option value ="3" >3-High</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<button type="submit" class="btn btn-primary btn-sm" id="addQuestionButton${UNQID}">Add Questions</button>
		</div>
		</form>
		</div>
		
	</div>	
	</div>
</div>
 --%>
