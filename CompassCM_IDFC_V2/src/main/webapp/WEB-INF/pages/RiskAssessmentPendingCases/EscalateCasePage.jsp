<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script>
	try{
		
	document.getElementById('lastReviedDateMakerForm').valueAsDate = new Date();
	}catch(e){}
	
	var userRole = '${USERROLE}'
	if(userRole.includes("MAKER")){
		$("#cmMakerTab").click();
	}
	if(userRole.includes("CHECKER")){
		$("#cmCheckerTab").click();
	}
	
	$("#escalateForm").submit(function(){
		var data = $("#escalateForm").serialize()
		/* alert(data) */
		 $.ajax({
			url: "${pageContext.request.contextPath}/common/escalateCase",
			cache: false,
			type: "POST",
			data: data,
			success: function(res) {
				$("#compassMediumGenericModal").modal("hide");
				alert("Case Escalated SuccessFully")
				reloadTabContent();
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		}); 
	})
		
		function approveCase(){
			var data = $("#checkerForm").serialize()
			if($("#checkerComments").val().length == 0){
				alert("Please provide comments")
			}
			else{
				
				 $.ajax({
					url: "${pageContext.request.contextPath}/common/approveCase",
					cache: false,
					type: "POST",
					data: data,
					success: function(res) {
						$("#compassMediumGenericModal").modal("hide");
						alert("Approved SuccessFully")
						reloadTabContent();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				}); 
			}
		}
	
		function rejectCase(){
			var data = $("#checkerForm").serialize()
			if($("#checkerComments").val().length == 0){
				alert("Please provide comments")
			}
			else{
				
				 $.ajax({
					url: "${pageContext.request.contextPath}/common/rejectCase",
					cache: false,
					type: "POST",
					data: data,
					success: function(res) {
						$("#compassMediumGenericModal").modal("hide");
						alert("Case Rejected")
						reloadTabContent();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				}); 
			}
		}
	
	function handleTab(tab){
		if(tab === "cmOfficer"){
			$('#forOfficerForm').css("display","block");
			$('#forMakerForm').css("display","none");
			$('#forCheckerForm').css("display","none");
			$('#commentLogs').css("display","none");
			
			$("#cmOfficerTab").addClass("activeTab");
			$("#cmMakerTab").removeClass("activeTab");
			$("#cmCheckerTab").removeClass("activeTab");
			$("#commentLogsTab").removeClass("activeTab");
		}
		if(tab === "cmMaker"){
			$('#forOfficerForm').css("display","none");
			$('#forMakerForm').css("display","block");
			$('#forCheckerForm').css("display","none");
			$('#commentLogs').css("display","none");

			$("#cmOfficerTab").removeClass("activeTab");
			$("#cmMakerTab").addClass("activeTab");
			$("#cmCheckerTab").removeClass("activeTab");
			$("#commentLogsTab").removeClass("activeTab");
			
			 $('.selectpicker').selectpicker();
		}
		if(tab === "cmChecker"){
			$('#forOfficerForm').css("display","none");
			$('#forMakerForm').css("display","none");
			$('#forCheckerForm').css("display","block");
			$('#commentLogs').css("display","none");

			$("#cmOfficerTab").removeClass("activeTab");
			$("#cmMakerTab").removeClass("activeTab");
			$("#cmCheckerTab").addClass("activeTab");
			$("#commentLogsTab").removeClass("activeTab");
			try{
				
			document.getElementById('lastReviedDateCheckerForm').valueAsDate = new Date();
			}
			catch(e){}
		
		}
		if(tab === "commentLogs"){
			$('#forOfficerForm').css("display","none");
			$('#forMakerForm').css("display","none");
			$('#forCheckerForm').css("display","none");
			$('#commentLogs').css("display","block");

			$("#cmOfficerTab").removeClass("activeTab");
			$("#cmMakerTab").removeClass("activeTab");
			$("#cmCheckerTab").removeClass("activeTab");
			$("#commentLogsTab").addClass("activeTab");
			
			 $.ajax({
					url: "${pageContext.request.contextPath}/common/getCommentLogs",
					cache: false,
					type: "POST",
					data: "caseNo="+ '${CASEDETAILS.FORMAKERFORM.CASENO}',
					success: function(res) {
						$("#commentLogs").html(res)
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				}); 
			
		
		}
	}
</script>
<style>
	.tab{
		height:25px;
		width:120px;
		text-align:center;
		color:#337ab7;
		padding-top:5px
		
	}
	.tab:hover,.activeTab:hover{
	cursor:pointer}
	.activeTab{
		height:25px;
		width:120px;
		border-right:1px solid black;
		text-align:center;
		color:white;
		border-radius:5px;
		background-color:#337ab7;
		padding-top:5px
	}
</style>
<div id="escalateCase" >
	<div class='card card-primary' style = "height:60px">
		<div class='panelSearchForm'>
			<table class='table ' style="width:30%;margin:auto">
				<tbody>
					<tr>
						<td width:"30%">
							Case No.
						</td>
						<td width:"30%">
							<input class = "input-sm form-control"  readonly value = ${CASEDETAILS.FORMAKERFORM.CASENO} />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div> 
	<div class='card card-primary'>
		<div class='panelSearchForm'>
			
			<div id = "userSelection" style = "display:flex;flex-direction:row;margin-bottom:1%;">
				<div class="tab" id = "cmOfficerTab" onClick="handleTab('cmOfficer')">
					CMOFFICER
				</div>
				<div class="tab" id = "cmMakerTab" onClick="handleTab('cmMaker')">
					CM_MAKER
				</div>
				<div class="tab" id = "cmCheckerTab" onClick="handleTab('cmChecker')">
					CM_CHECKER
				</div>
				<div class="tab" id = "commentLogsTab" onClick="handleTab('commentLogs')">
					COMMENT_LOGS
				</div>
			</div>
			<div id = "forMakerForm" style="display:none">
				<c:choose>
				<c:when test="${USERROLE eq 'ROLE_CM_MAKER' }">
				<div class="card card-primary" style = "width:98%;margin:auto;margin-bottom:1.5%;" >
					<div class="card-header  clearfix" >
						<h6 class="card-title ">add comments</h6>
						<!-- <div class="btn-group  clearfix">
							<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
						</div> -->
					</div>
					<div>
					<form id = "escalateForm" action='javascript:void(0)' >
						<div class='card-search-card' >
							<table class='table table-striped  ' style='margin-bottom: 0px;'>
								<tbody>
										<input name = "caseNo" style='display:none;' value = "${CASEDETAILS.FORMAKERFORM.CASENO}">
									</tr>
									<tr>
										<td width="15%">
											Question Id
										</td>
										<td width="30%">
											<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONID }.${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.VERSION_SEQNO}" />
										</td>
										<td width="10%">
										</td>
										<td width="15%" >
											Last Reviewed Date
										</td>
										<td width="30%">
											<input class = "form-control input-sm" type = 'date' readonly id = "lastReviedDateMakerForm" />
										</td>
										
									</tr>
									<tr>
										<td width="15%" >
											Question
										</td>
										<td colspan="4">
											<textarea  name = "question" style='margin-bottom:10px;min-height:50px' class='form-control' disabled>${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONDESCRIPTION }</textarea>
											
										</td>
									</tr>
									<tr>
										<td width="15%">
											Options
										</td>
										<td width="30%">
											<select  name = "options" class='form-control selectpicker'>
												<c:forEach var = "option" items="${CASEDETAILS.FORMAKERFORM.OPTIONSLIST }">
													<option value = "${CASEDETAILS.FORMAKERFORM.OPTIONSVALUELIST[option]  }||${option}">${option}</option>
												</c:forEach>
											</select>
										</td>
										<td width="10%">
										</td>
										<td width="15%">
											Remarks
										</td>
										<td width="30%">
											<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'Y' }">
				            
												<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' ></textarea>
								            	
							            	</c:if> 
											<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'N' }">
				            
												<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled > No remarks needed to this question</textarea>
								            	
							            	</c:if> 
											
										</td>
									</tr>
									<tr>
										<td width="15%">
											List of Users
										</td>
										<td colSpan="4">
											<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
											<select name ="checkerList" class='form-control selectpicker' required >
												<c:forEach var = "checker" items="${CASEDETAILS.FORMAKERFORM.CHECKERLIST }">
													<option value = "${checker }">${checker }</option>
												</c:forEach>
											</select>
										</td>
										
									</tr>
									<tr>
										<td width="15%">
											Comments:
										</td>
										<td colspan="4">
											<textarea name="comments" style='margin-bottom:10px' class='form-control' required ></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											<div style="float:right">
												<button class= "form-control btn-success" type="submit">Escalate</button>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</form>
					</div>
				</div>
				</c:when>
				<c:otherwise>
					<div class='card-search-card' >
						<div class="card card-primary" style = "width:98%;margin:auto;margin-bottom:1.5%;" >
						<div class="card-header  clearfix" >
							<h6 class="card-title ">maker comments</h6>
							<!-- <div class="btn-group  clearfix">
								<span class="pull-right"><i class="fa fa-chevron-up"></i></span>
							</div> -->
						</div>
						<div>
						<table class='table table-striped  ' style='margin-bottom: 0px;'>
							<tbody>
									<input name = "caseNo" style='display:none;' value = "${CASEDETAILS.FORMAKERFORM.CASENO}">
								</tr>
								<tr>
									<td width="15%">
										Question Id
									</td>
									<td width="30%">
										<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONID }.${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.VERSION_SEQNO}" />
									</td>
									<td width="10%">
									</td>
									<td width="15%" >
										Last Reviewed Date
									</td>
									<td width="30%">
										<input class = "form-control input-sm"  readonly value = ${CASEDETAILS.FORMAKERFORM.LASTREVIEWEDDATE } >
									</td>
									
								</tr>
								<tr>
									<td width="15%" >
										Question
									</td>
									<td colspan="4">
										<textarea  name = "question" style='margin-bottom:10px;min-height:50px' class='form-control' disabled>${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONDESCRIPTION }</textarea>
										
									</td>
								</tr>
								<tr>
									<td width="15%">
										Options
									</td>
									<td width="30%">
										<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATIONOPTIONS}" />
									</td>
									<td width="10%">
									</td>
									<td width="15%">
										Remarks
									</td>
									<td width="30%">
										<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'Y' }">
			            
											<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' readonly> ${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATIONREMARKS }</textarea>
							            	
						            	</c:if> 
										<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'N' }">
			            
											<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled > No remarks needed to this question</textarea>
							            	
						            	</c:if> 
										
									</td>
								</tr>
								<tr>
									<td width="15%">
										List of Users
									</td>
									<td colSpan="4">
										<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
										<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATEDTO}" />
									
									</td>
									
								</tr>
								<tr>
									<td width="15%">
										Comments:
									</td>
									<td colspan="4">
										<textarea name="comments"  readonly style='margin-bottom:10px' class='form-control' >${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATIONCOMMETNS }</textarea>
									</td>
								</tr>
								<!-- <tr>
									<td colspan="5">
										<div style="float:right">
											<button class= "form-control btn-success" type="submit">Escalate</button>
										</div>
									</td>
								</tr> -->
							</tbody>
						</table>
					</div>
					</div>
					</div>
					
				</c:otherwise>
				</c:choose>
			</div>
			<div id = "forCheckerForm" style="display:none">
				<div class="card card-primary" style = "width:98%;margin:auto;margin-bottom:1.5%;" >
				<div class="card-header  clearfix" >
					<h6 class="card-title ">add comments</h6>
					<!-- <div class="btn-group  clearfix">
						<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
					</div> -->
				</div>
				<div>
				<form id = "checkerForm" action='javascript:void(0)' >
					<div class='card-search-card' >
						<c:choose>
						<c:when test="${USERROLE eq 'ROLE_CM_CHECKER' }">
							<table class='table table-striped  ' style='margin-bottom: 0px;'>
								<tbody>
									<tr style="display:none;">
										<input name = "caseNo" style='display:none;' value = "${CASEDETAILS.FORMAKERFORM.CASENO}">
									</tr>
									<tr>
										<td width="15%">
											Question Id
										</td>
										<td width="30%">
											<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONID }.${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.VERSION_SEQNO}" />
										</td>
										<td width="10%">
										</td>
										<td width="15%" >
											Last Reviewed Date
										</td>
										<td width="30%">
											<input class = "form-control input-sm" type = 'date' readonly id = "lastReviedDateCheckerForm" />
										</td>
										
									</tr>
									<tr>
										<td width="15%" >
											Question
										</td>
										<td colspan="4">
											<textarea  name = "question" style='margin-bottom:10px;min-height:50px' class='form-control' disabled>${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONDESCRIPTION }</textarea>
											
										</td>
									</tr>
									<tr>
										<td width="15%">
											Options
										</td>
										<td width="30%">
											<input type='text' disabled  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATIONOPTIONS}" />
										</td>
										<td width="10%">
										</td>
										<td width="15%">
											Remarks
										</td>
										<td width="30%">
											<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'Y' }">
				            
												<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled> ${CASEDETAILS.FORMAKERFORM.PREVIOUSCASEDATA.ESCALATIONREMARKS }</textarea>
								            	
							            	</c:if> 
											<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'N' }">
				            
												<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled > No remarks needed to this question</textarea>
								            	
							            	</c:if> 
											
										</td>
									</tr>
									<%--<tr>
										<td width="15%">
											List of Users
										</td>
										<td colSpan="4">
											<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
											<select name ="checkerList" class='form-control selectpicker' required >
												<c:forEach var = "checker" items="${CASEDETAILS.FORMAKERFORM.CHECKERLIST }">
													<option value = "${checker }">${checker }</option>
												</c:forEach>
											</select>
										</td>
										
									</tr> --%>
									<tr>
										<td width="15%">
											Comments:
										</td>
										<td colspan="4">
											<textarea name="comments" style='margin-bottom:10px' id = "checkerComments" class='form-control' ></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											<div style="float:right">
												<button class= "form-control btn-danger" onClick = "rejectCase()">Reject</button>
											</div>
											<div style="float:right;margin-right:10px">
												<button class= "form-control btn-success" onClick = "approveCase()">Approve</button>
											</div>
										</td>
										<!-- <td colspan="5">
											
										</td> -->
									</tr>
								</tbody>
							</table>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test = "${CASEDETAILS.FORCHECKERFORM.COMMENTS != '' }">
									<table class='table table-striped  ' style='margin-bottom: 0px;'>
										<tbody>
											<tr style="display:none;">
												<input name = "caseNo" style='display:none;' value = "${CASEDETAILS.FORMAKERFORM.CASENO}">
											</tr>
											<tr>
												<td width="15%">
													Question Id
												</td>
												<td width="30%">
													<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONID }.${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.VERSION_SEQNO}" />
												</td>
												<td width="10%">
												</td>
												<td width="15%" >
													Last Reviewed Date
												</td>
												<td width="30%">
													<input class = "form-control input-sm" readonly value = ${CASEDETAILS.FORCHECKERFORM.LASTREVIEWEDDATE }  >
												</td>
												
											</tr>
											<tr>
												<td width="15%" >
													Question
												</td>
												<td colspan="4">
													<textarea  name = "question" style='margin-bottom:10px;min-height:50px' class='form-control' disabled>${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONDESCRIPTION }</textarea>
													
												</td>
											</tr>
											<%-- <tr>
												<td width="15%">
													Options
												</td>
												<td width="30%">
													<select  name = "options" class='form-control selectpicker'>
														<c:forEach var = "option" items="${CASEDETAILS.FORMAKERFORM.OPTIONSLIST }">
															<option value = "${CASEDETAILS.FORMAKERFORM.OPTIONSVALUELIST.option  }">${option}</option>
														</c:forEach>
													</select>
												</td>
												<td width="10%">
												</td>
												<td width="15%">
													Remarks
												</td>
												<td width="30%">
													<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'Y' }">
						            
														<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' ></textarea>
										            	
									            	</c:if> 
													<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'N' }">
						            
														<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled > No remarks needed to this question</textarea>
										            	
									            	</c:if> 
													
												</td>
											</tr>
											<tr>
												<td width="15%">
													List of Users
												</td>
												<td colSpan="4">
													<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
													<select name ="checkerList" class='form-control selectpicker' required >
														<c:forEach var = "checker" items="${CASEDETAILS.FORMAKERFORM.CHECKERLIST }">
															<option value = "${checker }">${checker }</option>
														</c:forEach>
													</select>
												</td>
												
											</tr> --%>
											<tr>
												<td width="15%">
													Comments:
												</td>
												<td colspan="4">
													<textarea name="comments" style='margin-bottom:10px' class='form-control' readonly >${CASEDETAILS.FORCHECKERFORM.COMMENTS }</textarea>
												</td>
											</tr>
											<!-- <tr>
												<td colspan="5">
													<div style="float:right">
														<button class= "form-control btn-danger" >Reject</button>
													</div>
													<div style="float:right;margin-right:10px">
														<button class= "form-control btn-success" >Accept</button>
													</div>
												</td>
												
											</tr> -->
										</tbody>
									</table>
								</c:when>
								<c:otherwise>
									<table class='table table-striped  ' style='margin-bottom: 0px;'>
										<tbody>
											<tr>
												<td>
												
													<div style = "text-align:center;padding-top:2%">
														<p>No Checker Actions Yet</p>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
						</c:choose>
					</div>
				</form>
				</div>
				</div>
			</div>
			<div id = "forOfficerForm" style="display:none">
				<div class="card card-primary" style = "width:98%;margin:auto;margin-bottom:1.5%;" >
					<div class="card-header  clearfix" >
						<h6 class="card-title ">officer comments</h6>
						<!-- <div class="btn-group  clearfix">
							<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
						</div> -->
					</div>
					<div>
				<form id = "officerForm" action='javascript:void(0)' >
					<div class='card-search-card' >
						<table class='table table-striped  ' style='margin-bottom: 0px;'>
							<tbody>
								<tr style="display:none;">
									<input name = "caseNo" style='display:none;' value = "${CASEDETAILS.FORMAKERFORM.CASENO}">
								</tr>
								<tr>
									<td width="15%">
										Question Id
									</td>
									<td width="30%">
										<input type='text' readonly  name = "caseId" class='form-control input-sm'  value = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONID }.${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.VERSION_SEQNO}" />
									</td>
									<td width="10%">
									</td>
									<td width="15%" >
										Last Reviewed Date
									</td>
									<td width="30%">
										<input class = "form-control input-sm" readonly id = "" value = ${CASEDETAILS.FOROFFICERFORM.LASTREVIEWEDDATE } >
									</td>
									
								</tr>
								<tr>
									<td width="15%" >
										Question
									</td>
									<td colspan="4">
										<textarea  name = "question" style='margin-bottom:10px;min-height:50px' class='form-control' disabled>${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.QUESTIONDESCRIPTION }</textarea>
										
									</td>
								</tr>
								<%-- <tr>
									<td width="15%">
										Options
									</td>
									<td width="30%">
										<select  name = "options" class='form-control selectpicker'>
											<c:forEach var = "option" items="${CASEDETAILS.FORMAKERFORM.OPTIONSLIST }">
												<option value = "${CASEDETAILS.FORMAKERFORM.OPTIONSVALUELIST.option  }">${option}</option>
											</c:forEach>
										</select>
									</td>
									<td width="10%">
									</td>
									<td width="15%">
										Remarks
									</td>
									<td width="30%">
										<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'Y' }">
			            
											<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' ></textarea>
							            	
						            	</c:if> 
										<c:if test  = "${CASEDETAILS.FORMAKERFORM.QUESTIONSMAP.ISFREETEXTAREAREQUIRED == 'N' }">
			            
											<textarea  name = "remarks" style='margin-bottom:10px' class='form-control' disabled > No remarks needed to this question</textarea>
							            	
						            	</c:if> 
										
									</td>
								</tr> --%>
								<%-- <tr>
									<td width="15%">
										List of Users
									</td>
									<td colSpan="4">
										<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
										<select name ="checkerList" class='form-control selectpicker' required >
											<c:forEach var = "checker" items="${CASEDETAILS.FORMAKERFORM.CHECKERLIST }">
												<option value = "${checker }">${checker }</option>
											</c:forEach>
										</select>
									</td>
									
								</tr> --%>
								<tr>
									<td width="15%">
										Comments:
									</td>
									<td colspan="4">
										<textarea name="comments" style='margin-bottom:10px' class='form-control' readonly >${CASEDETAILS.FOROFFICERFORM.COMMENTS }</textarea>
									</td>
								</tr>
								<!-- <tr>
									<td colspan="5">
										<div style="float:right">
											<button class= "form-control btn-success" type="submit">Save</button>
										</div>
									</td>
								</tr> -->
							</tbody>
						</table>
					</div>
				</form>
			</div>
			</div>
			</div>
		</div>
		<div id = "commentLogs" style= "display:none">
		
		</div>
	</div>
																
																
	
</div>