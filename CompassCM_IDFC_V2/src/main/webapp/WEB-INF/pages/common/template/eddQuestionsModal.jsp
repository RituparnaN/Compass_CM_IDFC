<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

<style>
	td {
		max-width: 550px;
		word-break: break-word;
	}
	
	textarea{
		min-height: 50px;
		overflow: auto;
		resize: vertical;
	}
	
</style>
<script type="text/javascript">
$(document).ready(function() {
	var id = "${UNQID}";
	var caseNo = "${CASENO}";
	
	$("#accountType"+id).on("change", function(){
		var accountType = $(this).val();
		//console.log(accountType);
		if(accountType != "SELECT"){
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getEddQuestions",
				data: "accountType="+accountType,
				cache:	false,
				type: "POST",
				async: false,
				success: function(response){
					//console.log("questions = "+response);
					var questionsConstruction = "";
					$.each(response, function(key, value){
						questionsConstruction += "<tr>";
						questionsConstruction += 	"<td width='25%'>";
						questionsConstruction += 		value.split("^^^")[0]+" <span style='color: red;'>*</span>";
						questionsConstruction += 	"</td>";
						questionsConstruction += 	"<td width='75%'>";
						questionsConstruction += 		"<textarea class='form-control input-sm' id='question_"+key+"' name='"
														 +key+"' minlength='"+value.split("^^^")[1]+"' placeholder='Minimum "+value.split("^^^")[1]+" Characters'></textarea>";
						questionsConstruction += 	"</td>";
						questionsConstruction += "</tr>";
					});
					$(".eddQuestionsTable"+id).html(questionsConstruction);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});	
		}else{
			$(".eddQuestionsTable"+id).html("");
		}
	});
	
	//OPEN EDD QUESTIONS
	$("#updateEddQuestionRecords"+id).click(function(){
		var caseNo = "${CASENO}";
		var eddQuestions = "";
		var allEddFilled = true;
		$(".eddQuestionsTable"+id).children("tbody").find("tr").each(function(){
			var row = $(this).children("td").children("textarea");
			eddQuestions += $(row).attr('name')+"|||"+$(row).val()+"~~~";
			if($(row).val().length < $(row).attr('minlength')){
				allEddFilled = false;
				$(row).css('border-color', 'red');
			}else{
				$(row).css('border-color', '#bdbbbb');
			}
		});
		//console.log("eddQuestions = "+eddQuestions);
		
		if(eddQuestions != ""){
			if(allEddFilled == true){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateEddQuestionRecords",
					cache: false,
					type: "POST",
					data: "caseNo="+caseNo+"&eddQuestions="+eddQuestions,
					success: function(res) {
						alert(res);
						reloadTabContent();
						$(".closeModal"+id).click();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}else{
				alert("Please fill up the EDD Questions according to the minimum input.");
			}
		}else{
			alert("Please select an account type");
		}
	});
	
});
</script>

<div class="card card-default ">
	<div class="card-body" style="padding:0px;">
		<c:if test="${(USERROLE eq 'ROLE_USER' || USERROLE eq 'ROLE_BRANCHUSER') && EDDQUESTIONRECORDS.size() eq 0}">
			<table class="table table-bordered table-striped">
				<tr>
		        	<td width="50%">Account Type</td>
		        	<td width="50%">
		        		<select class="form-control input-sm" id="accountType${UNQID}" name="accountType">
							<option value="SELECT">Select</option>
							<option value="SAVINGS">Savings</option>
							<option value="CURRENT">Current</option>
						</select>
		        	</td>
		        </tr>
			</table>
		</c:if>
		<table class="table table-bordered table-striped eddQuestionsTable${UNQID}" id="eddQuestionsTable${UNQID}" border="1" bordercolor="#a4d4f6">
			<c:choose>
				<c:when test="${EDDQUESTIONRECORDS.size() > 0}">
					<c:forEach var="EACHRECORD" items="${EDDQUESTIONRECORDS}">
					<c:set var="QUESTION" value="${f:split(EDDQUESTIONS[EACHRECORD.key], '^^^')}" />
						<tr>
							<td width="25%">
								<%-- ${EDDQUESTIONS[EACHRECORD.key]} --%>
								${QUESTION[0]} <span style='color: red;'>*</span>
							</td>
							<td width="75%">
								<c:choose>
									<c:when test="${USERROLE eq 'ROLE_USER' || USERROLE eq 'ROLE_BRANCHUSER'}">
										<textarea class='form-control input-sm' id='question_${EACHRECORD.key}' name='${EACHRECORD.key}' 
											minlength='${QUESTION[1]}' placeholder='Minimum ${QUESTION[1]} Characters'>${EACHRECORD.value}</textarea>
									</c:when>
									<c:otherwise>
										<textarea class='form-control input-sm' id='question_${EACHRECORD.key}' name='${EACHRECORD.key}' 
											minlength='${QUESTION[1]}' placeholder='Minimum ${QUESTION[1]} Characters' readonly>${EACHRECORD.value}</textarea>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${USERROLE eq 'ROLE_USER' || USERROLE eq 'ROLE_BRANCHUSER'}">
						</c:when>
						<c:otherwise>
							<tr>
					        	<td width="100%" align="center">No Record Available</td>
					        </tr>
						</c:otherwise>
					</c:choose>
			    </c:otherwise>
			</c:choose>
		</table>
	</div>
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<c:if test="${USERROLE eq 'ROLE_USER' || USERROLE eq 'ROLE_BRANCHUSER'}">
				<button type="button" class="btn btn-primary" id="updateEddQuestionRecords${UNQID}" style="font-size: 12px;">Update</button>
			</c:if>
			<button type="button" class="btn btn-danger closeModal${UNQID}" data-dismiss="modal" style="font-size: 12px;">Close</button>
		</div>
	</div>
</div>
