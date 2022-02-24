<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';	
		var CURRENTROLE = '${CURRENTROLE}';
		var STATUS = "${CONTROLPARAMSDATA['STATUS']}";
		
		//console.log("${CONTROLPARAMSWEIGHTAGE}");
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#controlParamsTabDiv"+id).find("input, textarea, select").prop("disabled", true);
		}
		
		$(".optionSelection").each(function(){
			if($(this).val() != ''){
				var selectedOptionElm = $(this).attr('id');
				var questionId = selectedOptionElm.toString().replace('OPTION_', '');
				var assessmentCtrlScoreId = 'ASSESSMENTCTRLSCORE_'+questionId;
				var weightageId = 'WEIGHTAGE_'+questionId;
				setSelectedControlRiskRating($(this).val(), assessmentCtrlScoreId, weightageId);
			} 
		}); 
		 
		$("#calculateControlParametersRisk"+id).click(function(){
			var controlParametersRiskRating = "High"; //dummy for testing
			
			var multipliedRiskArr = [];
			var totalAssessmentCtrlScore = 0;
			
			$(".riskAssessmentForm"+id+" > tbody > tr ").each(function(){
				var risk1 = ($(this).find(".risk1").val() == 1) ? 0 : ($(this).find(".risk1").val() == 2) ? 5 : ($(this).find(".risk1").val() == 3) ? 10 : 0;
				var weightage = $(this).find(".risk2").val();
				var multipliedRisk = (risk1 * weightage)/100;
				multipliedRiskArr.push(multipliedRisk);
				totalAssessmentCtrlScore += parseInt(risk1);
				//console.log(totalAssessmentCtrlScore);
			});
			
			var questionCount = multipliedRiskArr.length;
		
			var totalRisk = 0;
			
			for (var i = 0; i < questionCount; i++) {
				totalRisk += multipliedRiskArr[i];
			}

			var averageRiskRating = (totalAssessmentCtrlScore/questionCount).toFixed(2); 
			
			var provisionalRiskRating = (totalRisk/questionCount).toFixed(2);
			
			if(provisionalRiskRating <= 4){
				provisionalRiskRating = "Low - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 4 && provisionalRiskRating <= 7){
				provisionalRiskRating = "Medium - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 7 && provisionalRiskRating <= 10){
				provisionalRiskRating = "High - "+provisionalRiskRating;
			}
			
			$("#CONTROLPARAMETERS_SYSTEMRISKRATING"+id).val(averageRiskRating);		
			$("#CONTROLPARAMETERS_PROVISIONALRISKRATING"+id).val(provisionalRiskRating);		
			
			$("#controlParamsSysRiskRating").val(averageRiskRating);
			$("#controlParamsProvRiskRating").val(provisionalRiskRating);
		});
		
	});
	
	function getControlParamsRiskRating(elm, assessmentCtrlScoreId, weightageId){
		var optionRisk = $(elm).val().split('~~');
		var bothRiskRatingVal = optionRisk[0].split('~-~');
		var weightage = bothRiskRatingVal[1];
		$("#"+assessmentCtrlScoreId).val(optionRisk[1]);
		$("#"+weightageId).val(weightage);
	}
	
	function setSelectedControlRiskRating(selectedRiskVal, assessmentCtrlScoreId, weightageId){
		var fullVal = selectedRiskVal.split('~~');
		var bothRiskRatingVal = fullVal[0].split('~-~');
		var optionVal = fullVal[1];
		var weightage = bothRiskRatingVal[1];
		$("#"+assessmentCtrlScoreId).val(optionVal);
		$("#"+weightageId).val(weightage);
	}
	
	function getControlParamsFinalRiskRating(elm, finalRiskRatingId1, finalRiskRatingId2){
		var id = '${UNQID}';
		var finalRisk = $("#"+finalRiskRatingId1+" :selected").val()+$("#"+finalRiskRatingId2+" :selected").val();
		if(finalRisk <= 10){
			var ctrlParamsFinalRisk = (finalRisk <= 4) ? "Low - "+finalRisk : (finalRisk > 4 && finalRisk <= 7) ? "Medium - "+finalRisk : (finalRisk > 7 && finalRisk <= 10) ? "High - "+finalRisk : "";
			var totalInherentUnitsFinalRisk1 = $("#totalInherentUnitsFinalRiskRating").val();
			$("#controlParamsFinalRiskRating").val(ctrlParamsFinalRisk);
			$("input[name='TOTAL_SYSTEMRISKRATING']").val(totalInherentUnitsFinalRisk1+","+ctrlParamsFinalRisk);

			var IRMagnitude = totalInherentUnitsFinalRisk1.split(' - ')[0];
			var CPMagnitude = ctrlParamsFinalRisk.split(' - ')[0];
			
			var residualProvisionalRisk = (IRMagnitude == "Low" && CPMagnitude == "Low") ? "Low" : 
				  (IRMagnitude == "Low" && CPMagnitude == "Medium") ? "Low" : 
				  (IRMagnitude == "Low" && CPMagnitude == "High") ? "High" :
				  (IRMagnitude == "Medium" && CPMagnitude == "Low") ? "Low" :
				  (IRMagnitude == "Medium" && CPMagnitude == "Medium") ? "Medium" :
				  (IRMagnitude == "Medium" && CPMagnitude == "High") ? "High" :	  
				  (IRMagnitude == "High" && CPMagnitude == "Low") ? "Medium" :
				  (IRMagnitude == "High" && CPMagnitude == "Medium") ? "High" :
				  (IRMagnitude == "High" && CPMagnitude == "High") ? "High" : "";
					
			$("input[name='TOTAL_PROVISIONALRISKRATING']").val(residualProvisionalRisk);	
			
		}else{
			alert("The Control Parameters Final Risk should not exceed 10.");
		}
				
		
	}
	
</script>

<div class="row compassrow${UNQID}" id="controlParamsTabDiv${UNQID}">
	<div class="col-sm-12">
	<%-- <c:forEach var="subGroupcode" items="${SUBGROUPSLIST}"> --%>
		<c:forEach var="subGroups" items="${QUESTIONNAIRESLIST}">
			<c:forEach var="subGroup" items="${subGroups}">
			<c:set var="subGroupCode" value="${subGroup.key}"></c:set>
				<c:set var="questionnaireSet" value="${subGroup.value}"></c:set>
			
				<div class="card card-primary panel_RiskAssessmentForm" style="margin-top: 10px;">
					<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
						<h6 class="card-title pull-${dirL}">${subGroupCode}</h6>
					</div>
					<div class="panelSearchForm">
						<%-- <form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}_${subGroupCode}"> --%>
							<div class="card-search-card" >
								<table class="table table-bordered table-striped formSearchTable riskAssessmentForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
									<c:forEach var="questionSet" items="${questionnaireSet}">
									<c:set var="questionId" value="${questionSet['QUESTIONID']}"></c:set>
									<c:set var="questionVersion" value="${questionSet['VERSION_SEQNO']}"></c:set>
									<c:set var="isFreeTextReq" value="${questionSet['ISFREETEXTAREAREQUIRED']}"></c:set>
									<c:set var="remarksDataField" value="REMARKS_${questionId}"></c:set>
									<c:set var="ctrlParamsFinalRiskVal" value="${f:split(CONTROLPARAMSDATA['CONTROLFINALRISK'], ' - ')}"></c:set>
									<c:set var="ctrlParamsFinalRiskRating" value="${f:split(ctrlParamsFinalRiskVal[1], '.')}"></c:set>
									<c:set var = "checkboxState" value = "disabled"></c:set>
									<c:if test = "${questionSet['RFISTATUS'] eq 'PE'}">
										<c:set var = "rowColor" value = "#FF7F7F"></c:set>
									</c:if>
									<c:if test = "${questionSet['RFISTATUS'] eq 'IP'}">
										<c:set var = "rowColor" value = "lightyellow"></c:set>
									</c:if>
									<c:if test = "${questionSet['RFISTATUS'] eq 'CO'}">
										<c:set var = "rowColor" value = "lightgreen"></c:set>
									</c:if>
									<c:if test = "${questionSet['RFISTATUS'] eq 'NA'}">
										<c:set var = "rowColor" value = "transparent"></c:set>
										<c:set var = "checkboxState" value = ""></c:set>
									</c:if>
									<c:choose>
										<c:when test = "${questionSet[remarksDataField] eq 'NA'}">
											<c:set var="remarksData" value=""></c:set>
										</c:when>
										<c:otherwise>
											<c:set var="remarksData" value="${questionSet[remarksDataField]}"></c:set>
										</c:otherwise>
									</c:choose>
										<tbody>
											<c:if test="${isFreeTextReq eq 'Y'}">
											<tr>
												<td style="width:1%;background-color:${rowColor }" id = "${questionId}.${questionVersion}"><input type="checkbox" ${checkboxState } id = "chk${questionId}.${questionVersion}" name = "${questionId}.${questionVersion}"  onchange="rfiCaseWorkFlowActions.handleCheckBoxChange(this)"/></td>
												<td style="width: 5%; text-align: center;" id="questionId${UNQID}">
													${questionId}.${questionVersion}
												</td>
												<td style="width: 40%">
													${questionSet['QUESTIONDESCRIPTION']}
												</td>
												<td style="width: 15%">
													<%-- <select class="form-control input-sm" id="OPTION_${questionId}_${UNQID}" name="CONTROLPARAMETERS_${questionId}" 
															onchange="getControlParamsRiskRating(this,'RISKRATING_${questionId}_${UNQID}', 'RISKRATING1_${questionId}_${UNQID}')">
														<option value="">Select Option</option>
														<c:forEach var="optionsList" items="${OPTIONSLIST}">
															<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
															<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
															<c:forEach var="optionRiskMap" items="${optionsRiskList_0}">
																<c:set var="optionValue" value="${optionRiskMap.key}"></c:set>
																<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																<option value="${riskValue}">${optionValue}</option>
															</c:forEach>									
														</c:forEach>
													</select> --%>
													<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="CONTROLPARAMETERS_${questionId}.${questionVersion}" 
															onchange="getControlParamsRiskRating(this,'ASSESSMENTCTRLSCORE_${questionId}_${UNQID}', 'WEIGHTAGE_${questionId}_${UNQID}')">
														<option value="">Select Option</option>
														<c:forEach var="optionsList" items="${OPTIONSLIST}">
															<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
															<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
															<c:set var="optionsRiskList_1" value="${optionsRiskRatingList[1]}"></c:set>
															<c:set var="selectedOptionsRiskList" value="${optionsRiskRatingList[2]}"></c:set>
															<c:forEach var="optionMap" items="${optionsRiskList_0}">
																<c:forEach var="optionRiskMap" items="${optionsRiskList_1}">
																	<c:if test="${not empty selectedOptionsRiskList}">
																		<c:forEach var="selectedOptionRiskMap" items="${selectedOptionsRiskList}">
																			<c:if test="${optionMap.value eq optionRiskMap.key}">
																				<c:set var="option" value="${optionMap.key}"></c:set>
																				<c:set var="optionValue" value="${optionMap.value}"></c:set>
																				<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																				<c:set var="questionOptionVal" value="${riskValue}~~${optionValue}"></c:set>
																				<c:set var="selectedOptionRiskValue" value="${selectedOptionRiskMap.value}"></c:set>
																				<c:set var="selectedOptionValue" value="${selectedOptionRiskMap.key}"></c:set>
																				<c:set var="selectedVal" value="${selectedOptionRiskValue}~~${selectedOptionValue}"></c:set>
																				<option value="${questionOptionVal}" <c:if test="${questionOptionVal eq selectedVal}">selected="selected"</c:if>>${option}</option>
																			</c:if>
																		</c:forEach>
																	</c:if>
																	<c:if test="${empty selectedOptionsRiskList}">
																		<c:if test="${optionMap.value eq optionRiskMap.key}">
																			<c:set var="optionValue" value="${optionMap.value}"></c:set>
																			<c:set var="option" value="${optionMap.key}"></c:set>
																			<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																			<option value="${riskValue}~~${optionValue}">${option}</option>
																		</c:if>
																	</c:if>
																</c:forEach>
															</c:forEach>									
														</c:forEach>
													</select>
												</td>
													<td style="width: 10%">
														<textarea class="form-control input-sm" id="REMARKS_${questionId}_${UNQID}" name="CONTROLPARAMETERS_REMARKS_${questionId}">${remarksData}</textarea>
													</td>
													<td style="width: 10%; text-align: center;">
														<select class="form-control input-sm risk1" id="ASSESSMENTCTRLSCORE_${questionId}_${UNQID}" name="CONTROLPARAMETERS_ACS_${questionId}" disabled="disabled">
															<option value="">Assessment Control Score</option>
															<option value="1">Effective</option>
															<option value="2">Needs improvement</option>
															<option value="3">No Control</option>
														</select>
													</td>
													<td style="width: 10%; text-align: center; display: none;" >
														<input class="form-control input-sm risk2" id="WEIGHTAGE_${questionId}_${UNQID}" name="WEIGHTAGE_${questionId}" disabled="disabled">
														<%-- <select class="form-control input-sm risk2" id="RISKRATING1_${questionId}_${UNQID}" name="RISKRATING1_${questionId}" disabled="disabled">
															<option value="">Likelihood Risk Rating</option>
															<option value="3">High</option>
															<option value="2">Medium</option>
															<option value="1">Low</option>
														</select> --%>
													</td>	
													<td style="width: 9%">
														<button type="button" name = "${questionId}.${questionVersion }||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActions.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI" class="btn btn-primary btn-sm" id="raiseToRFIIndividual${questionId}${UNQID}"> <i class="fa fa-share" style="font-size:14px;padding-top:1%;color:black"></i></button>
														<button type="button" name = "${questionId}.${questionVersion }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${UNQID}${questionId}" onclick="rfiCaseWorkFlowActions.handleViewComments(this)"><i class="fa fa-eye" style="font-size:14px;padding-top:1%;color:black"></i></button>
													</td>
												</tr>	
											</c:if>
											<c:if test="${isFreeTextReq eq 'N'}">
											<tr>
												<td style="width:1%;background-color:${rowColor }" id = "${questionId}.${questionVersion}"><input type="checkbox" ${checkboxState } id = "chk${questionId}.${questionVersion}" name = "${questionId}.${questionVersion}"  onchange="rfiCaseWorkFlowActions.handleCheckBoxChange(this)"/></td>
												<td style="width: 5%; text-align: center;">
													${questionId}.${questionVersion}
												</td>
												<td style="width: 40%">
													${questionSet['QUESTIONDESCRIPTION']}
												</td>
												<td style = "width: 25%">
													<%-- <select class="form-control input-sm" id="OPTION_${questionId}_${UNQID}" name="CONTROLPARAMETERS_${questionId}" 
															onchange="getControlParamsRiskRating(this,'RISKRATING_${questionId}_${UNQID}', 'RISKRATING1_${questionId}_${UNQID}')">
														<option value="">Select Option</option>
														<c:forEach var="optionsList" items="${OPTIONSLIST}">
															<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
															<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
															<c:forEach var="optionRiskMap" items="${optionsRiskList_0}">
																<c:set var="optionValue" value="${optionRiskMap.key}"></c:set>
																<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																<option value="${riskValue}">${optionValue}</option>
															</c:forEach>										
														</c:forEach>
													</select> --%>
													<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="CONTROLPARAMETERS_${questionId}.${questionVersion}" 
															onchange="getControlParamsRiskRating(this,'ASSESSMENTCTRLSCORE_${questionId}_${UNQID}', 'WEIGHTAGE_${questionId}_${UNQID}')">
														<option value="">Select Option</option>
														<c:forEach var="optionsList" items="${OPTIONSLIST}">
															<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
															<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
															<c:set var="optionsRiskList_1" value="${optionsRiskRatingList[1]}"></c:set>
															<c:set var="selectedOptionsRiskList" value="${optionsRiskRatingList[2]}"></c:set>
															<c:forEach var="optionMap" items="${optionsRiskList_0}">
																<c:forEach var="optionRiskMap" items="${optionsRiskList_1}">
																	<c:if test="${not empty selectedOptionsRiskList}">
																		<c:forEach var="selectedOptionRiskMap" items="${selectedOptionsRiskList}">
																			<c:if test="${optionMap.value eq optionRiskMap.key}">
																				<c:set var="option" value="${optionMap.key}"></c:set>
																				<c:set var="optionValue" value="${optionMap.value}"></c:set>
																				<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																				<c:set var="questionOptionVal" value="${riskValue}~~${optionValue}"></c:set>
																				<c:set var="selectedOptionRiskValue" value="${selectedOptionRiskMap.value}"></c:set>
																				<c:set var="selectedOptionValue" value="${selectedOptionRiskMap.key}"></c:set>
																				<c:set var="selectedVal" value="${selectedOptionRiskValue}~~${selectedOptionValue}"></c:set>
																				<option value="${questionOptionVal}" <c:if test="${questionOptionVal eq selectedVal}">selected="selected"</c:if>>${option}</option>
																			</c:if>
																		</c:forEach>
																	</c:if>
																	<c:if test="${empty selectedOptionsRiskList}">
																		<c:if test="${optionMap.value eq optionRiskMap.key}">
																			<c:set var="optionValue" value="${optionMap.value}"></c:set>
																			<c:set var="option" value="${optionMap.key}"></c:set>
																			<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																			<option value="${riskValue}~~${optionValue}">${option}</option>
																		</c:if>
																	</c:if>
																</c:forEach>
															</c:forEach>									
														</c:forEach>
													</select>
												</td>
												<td style="width: 10%; text-align: center;">
													<select class="form-control input-sm risk1" id="ASSESSMENTCTRLSCORE_${questionId}_${UNQID}" name="CONTROLPARAMETERS_ACS_${questionId}" disabled="disabled">
														<option value="">Assessment Control Score</option>
														<option value="1">Effective</option>
														<option value="2">Needs improvement</option>
														<option value="3">No Control</option>
													</select>
												</td>
												<td style="width: 10%; text-align: center; display: none;" >
													<input class="form-control input-sm risk2" id="WEIGHTAGE_${questionId}_${UNQID}" name="WEIGHTAGE_${questionId}" disabled="disabled">
													<%-- <select class="form-control input-sm risk2" id="RISKRATING1_${questionId}_${UNQID}" name="RISKRATING1_${questionId}" disabled="disabled">
														<option value="">Likelihood Risk Rating</option>
														<option value="3">High</option>
														<option value="2">Medium</option>
														<option value="1">Low</option>
													</select> --%>
												</td>	
												<td style="width: 9%">
														<button type="button" name = "${questionId}.${questionVersion }||rtrfibutton||${COMPASSREFERENCENO}" onclick="document.getElementById('bulk').value = '';rfiCaseWorkFlowActions.handleRaiseForRFIPage(this)" data-toggle="tooltip" title="Raise to RFI" class="btn btn-primary btn-sm" id="raiseToRFIIndividual${questionId}${UNQID}"> <i class="fa fa-share" style="font-size:14px;padding-top:1%;color:black"></i></button>
														<button type="button" name = "${questionId}.${questionVersion }||vcbutton||${COMPASSREFERENCENO}" class="btn btn-primary btn-sm" data-toggle="tooltip" title="View Comments" id="viewComments${UNQID}${questionId}" onclick="rfiCaseWorkFlowActions.handleViewComments(this)"><i class="fa fa-eye" style="font-size:14px;padding-top:1%;color:black"></i></button>
													</td>
											</tr>
											</c:if>
									</tbody>
									</c:forEach>
								</table>
							</div>
						<!-- </form> -->
					</div>
				</div>
			</c:forEach>
		</c:forEach>
		
		<div class="card card-primary panel_RiskCalculationForm" style="margin-top: 20px; margin-bottom: 0;">
			<div class="card-header panelSlidingRiskCalculationForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Calculation</h6>
			</div>
			<div class="panelSearchForm">
				<%-- <form action="javascript:void(0)" method="POST" id="searchMasterForm_ControlParametersRiskCal_${UNQID}"> --%>
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
									<tr>
										<td width="25%">
											System Generated Risk Rating
										</td>
										<td width="20%" style="text-align: center;">	
											<button type="button" class="btn btn-primary btn-sm" id="calculateControlParametersRisk${UNQID}">Calculate</button>
										</td>
										<td width="5%">&nbsp;</td>
										<td colspan="2">
											<input type="text" class="form-control input-sm"  readonly="readonly" 
											       name="CONTROLPARAMETERS_SYSTEMRISKRATING" id="CONTROLPARAMETERS_SYSTEMRISKRATING${UNQID}" 
											       value="${CONTROLPARAMSDATA['CONTROLSYSTEMGENRISK']}"/>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Provisional Risk Rating
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" name="CONTROLPARAMETERS_PROVISIONALRISKRATING" 
											       id="CONTROLPARAMETERS_PROVISIONALRISKRATING${UNQID}" 
											       value="${CONTROLPARAMSDATA['CONTROLPROVISRISK']}">
										</td>
										<td width="5%">&nbsp;</td>
										<td width="25%">
											Final Risk Rating
										</td>
										<td width="10%">
											<select class="form-control input-sm" name="CONTROLPARAMETERS_FINALRISKRATING1" id="CONTROLPARAMETERS_FINALRISKRATING1${UNQID}"
													onchange="getControlParamsFinalRiskRating(this, 'CONTROLPARAMETERS_FINALRISKRATING1${UNQID}', 'CONTROLPARAMETERS_FINALRISKRATING2${UNQID}')">
													<c:forEach var="i" begin="0" end="10">
														<option value="${i}" <c:if test="${ctrlParamsFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
													</c:forEach>
												</select>
											</td>
										<td width="10%">
											 <select class="form-control input-sm" name="CONTROLPARAMETERS_FINALRISKRATING2" id="CONTROLPARAMETERS_FINALRISKRATING2${UNQID}"
													onchange="getControlParamsFinalRiskRating(this, 'CONTROLPARAMETERS_FINALRISKRATING1${UNQID}', 'CONTROLPARAMETERS_FINALRISKRATING2${UNQID}')">
												<c:forEach var="i" begin="00" end="99">
													<option value=".${i}" <c:if test="${ctrlParamsFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Reason(s) for Deviations between Provisional and Final Risk Rating
										</td>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="CONTROLPARAMETERS_RISKRATINGREASON" id="CONTROLPARAMETERS_RISKRATINGREASON${UNQID}">${CONTROLPARAMSDATA['CONTROLREMARKS']}</textarea>
										</td>
									</tr>
							</tbody>
						</table>
					</div>
				<!-- </form> -->
			</div>
			<%-- <c:if test="${CURRENTROLE ne 'ROLE_CM_MANAGER'}">
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button  type="button" id="saveRiskAssessment${UNQID}" class="btn btn-success btn-sm">Save</button>
						<button  type="button" id="draftRiskAssessment${UNQID}" class="btn btn-warning btn-sm">Save as draft</button>
					</div>
				</div>
			</c:if> --%>
		</div>
	</div>
</div>