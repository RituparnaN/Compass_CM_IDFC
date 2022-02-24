<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script>
$(document).ready(function(){
	var id = '${UNQID}';
	
	$("#riskAssessmentQuestionForm"+id).submit(function(e){
		if($("#question"+id).val()== "" ){
			alert("Please enter the question");
			return false;
		}
		var formValues = $(this).serialize();
		//console.log(formValues);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/updateRiskAssessmentQuestion",
			cache: false,
			type: "POST",
			data: formValues,
			success: function(res){
				alert(res);
				//$("#riskAssessmentQuestionForm"+id).trigger('reset');
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
		
	})
});
</script>
<div class="row compassrow">
<c:set var ="OPTIONIDLIST"  value = "${QUESTIONDETAILS['OPTIONID'] }"></c:set>
<c:set var ="OPTIONVALUE"  value = "${QUESTIONDETAILS['OPTIONVALUE'] }"></c:set>
<c:set var ="OPTIONVALUE1"  value = "${QUESTIONDETAILS['OPTIONVALUE1'] }"></c:set>
 <div class="col-sm-12">
	<div class="card card-primary QuestionDetails${UNQID}">
		<div class="col-sm-12" style="margin-top:20px;">
		<form action="javascript:void(0)" method="POST" id="riskAssessmentQuestionForm${UNQID}">
			<input type="hidden" value="${QUESTIONDETAILS['ASSESSMENTUNIT']}" name="assessmentUnit"></input>
			<input type="hidden" value="${questionId}" name="questionId"></input>
			<div class="col-sm-6" style="margin-top:30px;">
				<div class="form-group">
					<label >Question*:</label>
					<input type="text" class="form-control input-sm" value ="${QUESTIONDETAILS['QUESTIONDESCRIPTION'] }" name="questionDescription" id="questionDescription${UNQID}" placeholder="Type Question"></input>
				</div>
			</div>
			<div class="col-sm-offset-2 col-sm-3" style="margin-top:30px;">
				<div class="form-group">
					<label >Is Free Text Required*:</label>
					<select class="form-control" name="isFreeTextRequired" id="isFreeTextRequired${UNQID}">
						<option value ="Y" <c:if test="${QUESTIONDETAILS['ISFREETEXTAREAREQUIRED'] eq 'Y'}">selected="selected"</c:if>>Yes</option>
						<option value ="N" <c:if test="${QUESTIONDETAILS['ISFREETEXTAREAREQUIRED'] eq 'N'}">selected="selected"</c:if>>No</option>
					</select>
				</div>
			</div>
			<div class="col-sm-11" style="margin-top:15px;" >
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
					<tr>
						<td>Option 2*</td>
						<td>
							<input type="text" class="form-control input-sm" 
							value="${OPTIONIDLIST[1]}" name="option2Id" id="option2Id${UNQID}"
							onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" ></input>
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
					<tr>
						<td>Option 3*</td>
						<td>
							<input type="text" class="form-control input-sm" 
							value="${OPTIONIDLIST[2]}" name="option3Id" id="option3Id${UNQID}"
							onkeyup="this.value=this.value.replace(/[^0-9\.><-]/g,'')" ></input>
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
				</tbody>
			</table>
			<div class="pull-${dirR}">
			<button type="submit" class="btn btn-primary btn-sm" id="updateQuestionButton${UNQID}">Update Question</button>
			</div>
		</div>
		</form>
		</div>
	</div>
	</div>
</div>