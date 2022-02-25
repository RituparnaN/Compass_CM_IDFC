<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'riskAssessmentQuestionList', 'dd/mm/yy');
		
		$('.panelSlidingQuestionList'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'riskAssesssmentQuestionListmaster');
	    });
		
		$("#saveWeightage"+id).click(function(){
			var fullData = "";
			var controlArea = $("#controlArea"+id).val();
			var weightage = $("#weightage"+id).val();
			var totalWeightage = 0;
			
			$(".weightageConfigTable").children("tbody").children("tr").each(function(){
				var controlArea = $(this).children("td:first-child").html();
				var weightage = $(this).children("td:nth-child(2)").children("select").val();
				
				totalWeightage += Number(weightage);
				fullData = fullData + controlArea+"="+weightage+",";
			});

			if(totalWeightage === 100){
				$.ajax({
					url: "${pageContext.request.contextPath}/cmAdmin/saveWeightage",
					cache: false,
					type: "POST",
					data: "fullData="+fullData,
					success: function(res){
						alert(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}else{
				fullData = "";
				alert("The sum of weightage should be 100.");
			}
			
		});
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_riskAssessmentQuestionList">
			<div class="card-header panelSlidingQuestionList${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Weightage Configuration</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped weightageConfigTable" style="margin-bottom: 0px;">
					<thead>
						<tr>
							<th class="info">Control Area</th>
							<th class="info">Weightage</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="WEIGHTAGEMAP" items="${WEIGHTAGELIST}">
							<tr>
								<c:forEach var="WEIGHTAGE" items="${WEIGHTAGEMAP}">
									<td id="controlArea${UNQID}">${WEIGHTAGE.key}</td>
									<td id="weightage${UNQID}">
										<select class="form-control input-sm" style="width: 50%">
											<c:forEach var="i" begin="1" end="100">
												<option value="${i}" <c:if test="${WEIGHTAGE.value eq i}">selected="selected"</c:if>>${i}</option>
											</c:forEach>
										</select>
									</td>
								</c:forEach>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="submit" id="saveWeightage${UNQID}" class="btn btn-success btn-sm">Update</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


