<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
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
		
		
		$("#addAssessmentGroupForm"+id).submit(function(e){
			var formValues = $(this).serialize();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/riskAssessmentSubGroup",
				cache: false,
				type: "POST",
				data: formValues,
				success: function(res){
					alert(res);
					//$("#riskAssessmentQuestionForm"+id).trigger('reset');
					
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_addAssessmentSubGroup">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Add Assessment Sub Group</h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="addAssessmentGroupForm${UNQID}">
			<div class="card-search-card" >
				<table class="table">
				<tr>
					<td width="15%">Select Assessment Unit*:</td>
					<td width="30%">
					 <select class="form-control" name="assessmentUnit" id="assessmentUnit${UNQID}">
				      	<option value = "Select">Select</option>
				      </select>
					</td>
					<td width="7%">&nbsp;</td>
					<td width="15%">Select Assessment Section Code*:</td>
					<td width="30%">
					<select class="form-control" name="assessmentSectionCode" id="assessmentSectionCode${UNQID}" disabled>
				      </select>
					</td>
				</tr>
				<tr>
					<td width="15%">Sub Group*:</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" name="assessmentSubGroup" id="subGroup${UNQID}"/>
					</td>
					<td width="7%">&nbsp;</td>
					<td width="15%">Weightage*:</td>
					<td width="30%">
						<input type="text" class="input-sm form-control" name="weightage" id="weightage${UNQID}"/>
					</td>
				</tr>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="submit" id="createAssessmentSubGroup${UNQID}" class="btn btn-success btn-sm">Create SubGroup</button>
				</div>
			</div>
			</form>
			</div>
		</div>
		
	</div>
</div>

