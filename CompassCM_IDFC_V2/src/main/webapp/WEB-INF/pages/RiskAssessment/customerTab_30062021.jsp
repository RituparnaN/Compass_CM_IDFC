<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var CURRENTROLE = '${CURRENTROLE}';
		var STATUS = "${CUSTOMERRISKTABDATA['STATUS']}";
		var CUSTOMER_WEIGHTAGE = '${CUSTOMER_WEIGHTAGE}';
		//console.log(CUSTOMER_WEIGHTAGE);
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#customerTabDiv"+id).find("input, textarea, select").prop("disabled", true);
		}
		
		 $(".optionSelection").each(function(){
			if($(this).val() != ''){
				var selectedOptionElm = $(this).attr('id');
				var questionId = selectedOptionElm.toString().replace('OPTION_', '');
				var impactRiskRatingId = 'IMPACTRISKRATING_'+questionId;
				var likelihoodRiskRatingId = 'LIKELIHOODRISKRATING_'+questionId;
				setSelectedCustRiskRating($(this).val(), impactRiskRatingId, likelihoodRiskRatingId);
			} 
		}); 
		
		$("#calculateCustomerRisk"+id).click(function(){
			var customerRiskRating = "High"; //dummy for testing
			var multipliedRiskArr = [];
			
			$(".riskAssessmentForm"+id+" > tbody > tr ").each(function(){
				var risk1 = $(this).find(".risk1").val();
				var risk2 = $(this).find(".risk2").val();
				var multipliedRisk = risk1 * risk2; //inherent risk score
				multipliedRiskArr.push(multipliedRisk);
			});
			
			var questionCount = multipliedRiskArr.length;
			
			var totalRisk = 0;
			
			for (var i = 0; i < questionCount; i++) {
				totalRisk += multipliedRiskArr[i]; //inherent risk score
			}
			
			var averageRiskRating = (totalRisk/questionCount).toFixed(2);
						
			var provisionalRiskRating = (averageRiskRating * (CUSTOMER_WEIGHTAGE/100)).toFixed(2);
			
			if(provisionalRiskRating <= 2){
				provisionalRiskRating = "Low - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 2 && provisionalRiskRating <= 6){
				provisionalRiskRating = "Medium - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 6){
				provisionalRiskRating = "High - "+provisionalRiskRating;
			}
			
			$("#CUSTOMER_SYSTEMRISKRATING"+id).val(averageRiskRating);		
			$("#CUSTOMER_PROVISIONALRISKRATING"+id).val(provisionalRiskRating); 	
			
			$("#customerSysRiskRating").val(averageRiskRating);
			$("#customerProvRiskRating").val(provisionalRiskRating);
			
			setCalculatedTotalSystemGenRisk();
			setCalculatedTotalProvRisk();
		});
		
		function setCalculatedTotalSystemGenRisk(){
			var totalVal = 0;
			//var totalInherentUnitsSysRisk1;
			$(".systemGenRisk").each(function(){
				//var eachVal = $(this).val().split(" - ")[1];
				var eachVal = $(this).val();
				if(eachVal != null){
					totalVal += Number(eachVal);
					//totalInherentUnitsSysRisk1 =  (totalVal <= 2) ? "Low" : (totalVal >2 && totalVal <= 6) ? "Medium" : (totalVal > 6) ? "High" : "";
					$("#totalInherentUnitsSysRiskRating").val(totalVal.toFixed(2));
				}
			});	
		}
				
		function setCalculatedTotalProvRisk(){
			var totalVal = 0;
			var totalInherentUnitsProvRisk;
			$(".provRisk").each(function(){
				var eachVal = $(this).val().split(" - ")[1];
				if(eachVal != null){
					totalVal += Number(eachVal);
					totalInherentUnitsProvRisk =  (totalVal.toFixed(2) <= 2) ? "Low - "+totalVal.toFixed(2) : (totalVal.toFixed(2) > 2 && totalVal.toFixed(2) <= 6) ? "Medium - "+totalVal.toFixed(2) : (totalVal.toFixed(2) > 6) ? "High - "+totalVal.toFixed(2) : "";
					$("#totalInherentUnitsProvRiskRating").val(totalInherentUnitsProvRisk);
				}
			});	
		}
	});
	
	function getCustRiskRating(elm, impactRiskRatingId, likelihoodRiskRatingId){
		var fullVal = $(elm).val().split('~~');
		var bothRiskRatingVal = fullVal[0].split('~-~');
		var optionVal = fullVal[1];
		var impactRiskRatingVal = bothRiskRatingVal[0];
		var likelihoodRiskRatingVal = bothRiskRatingVal[1];
		
		$("#"+impactRiskRatingId).val(impactRiskRatingVal);
		$("#"+likelihoodRiskRatingId).val(likelihoodRiskRatingVal);
	}
	
	function setSelectedCustRiskRating(selectedRiskVal, impactRiskRatingId, likelihoodRiskRatingId){
		var fullVal = selectedRiskVal.split('~~');
		var bothRiskRatingVal = fullVal[0].split('~-~');
		var optionVal = fullVal[1];
		var impactRiskRatingVal = bothRiskRatingVal[0];
		var likelihoodRiskRatingVal = bothRiskRatingVal[1];
		
		$("#"+impactRiskRatingId).val(impactRiskRatingVal);
		$("#"+likelihoodRiskRatingId).val(likelihoodRiskRatingVal);
	}
	
	function getCustFinalRiskRating(elm, finalRiskRatingId1, finalRiskRatingId2){
		var finalRisk = $("#"+finalRiskRatingId1+" :selected").val()+$("#"+finalRiskRatingId2+" :selected").val();	
		if(finalRisk <= 9){
			var finalRiskRatingVal = (finalRisk <= 2) ? "Low - "+finalRisk : (finalRisk >2 && finalRisk <= 6) ? "Medium - "+finalRisk : (finalRisk > 6) ? "High - "+finalRisk : "";	
			
			$("#customerFinalRiskRating").val(finalRiskRatingVal);
	
			var total2 = 0;
			var totalInherentUnitsFinalRisk1;
			$(".finalRisk").each(function(){
				var eachVal = $(this).val().split(" - ")[1];
				if(eachVal != null){
					total2+= Number(eachVal);
					totalInherentUnitsFinalRisk1 =  (total2 <= 2) ? "Low - "+total2.toFixed(2) : (total2 >2 && total2 <= 6) ? "Medium - "+total2.toFixed(2) : (total2 > 6) ? "High - "+total2.toFixed(2) : "";
					$("#totalInherentUnitsFinalRiskRating").val(totalInherentUnitsFinalRisk1);
					var ctrlParamsFinalRisk = $("#controlParamsFinalRiskRating").val();
					$("input[name='TOTAL_SYSTEMRISKRATING']").val(totalInherentUnitsFinalRisk1+","+ctrlParamsFinalRisk);
					
					var IRMagnitude = totalInherentUnitsFinalRisk1.split(" - ")[0];
					var CPMagnitude = ctrlParamsFinalRisk.split(" - ")[0];
					
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
					
				}
			});
		}else{
			alert("The Final Risk should not be more than 9.");
		}
	}
	
</script>

<div class="row compassrow${UNQID}" id="customerTabDiv${UNQID}">
	<div class="col-sm-12">
		<c:forEach var="subGroups" items="${QUESTIONNAIRESLIST}">
			<c:forEach var="subGroup" items="${subGroups}">
				<c:set var="subGroupCode" value="${subGroup.key}"></c:set>
				<c:set var="questionnaireSet" value="${subGroup.value}"></c:set>					
				<div class="card card-primary panel_RiskAssessmentForm" style="margin-top: 10px;">
					<div class="card-header panelSlidingRiskAssessmentForm${UNQID} clearfix">
						<h6 class="card-title pull-${dirL}">${subGroupCode}</h6>
					</div>
					<div class="panelSearchForm">
							<div class="card-search-card" >
								<table class="table table-bordered table-striped formSearchTable riskAssessmentForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
									<c:forEach var="questionSet" items="${questionnaireSet}">
									<c:set var="questionId" value="${questionSet['QUESTIONID']}"></c:set>
									<c:set var="questionVersion" value="${questionSet['VERSION_SEQNO']}"></c:set>
									<c:set var="isFreeTextReq" value="${questionSet['ISFREETEXTAREAREQUIRED']}"></c:set>
									<c:set var="remarksDataField" value="REMARKS_${questionId}"></c:set>
									<c:set var="custFinalRiskVal" value="${f:split(CUSTOMERRISKTABDATA['CUSTOMERFINALRISK'], ' - ')}"></c:set>
									<c:set var="custFinalRiskRating" value="${f:split(custFinalRiskVal[1], '.')}"></c:set>
									
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
												<td style="width: 5%; text-align: center;" id="questionId${UNQID}">
													${questionId}.${questionVersion}
												</td>
												<td style="width: 40%">
													${questionSet['QUESTIONDESCRIPTION']}
												</td>
												<td style="width: 15%">
													<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="CUSTOMER_OPTION_${questionId}.${questionVersion}" 
															onchange="getCustRiskRating(this,'IMPACTRISKRATING_${questionId}_${UNQID}', 'LIKELIHOODRISKRATING_${questionId}_${UNQID}')">
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
													<textarea class="form-control input-sm" id="REMARKS_${questionId}_${UNQID}" name="CUSTOMER_REMARKS_${questionId}">${remarksData}</textarea>
												</td>
												<td style="width: 15%; text-align: center;">
													<select class="form-control input-sm risk1" id="IMPACTRISKRATING_${questionId}_${UNQID}" name="CUSTOMER_IRR_${questionId}" 
															disabled="disabled"	>
														<option value="">Impact Risk Rating</option>
														<option value="3">High</option>
														<option value="2">Medium</option>
														<option value="1">Low</option>
													</select>
												</td>
												<td style="width: 15%; text-align: center;">
													<select class="form-control input-sm risk2" id="LIKELIHOODRISKRATING_${questionId}_${UNQID}" name="CUSTOMER_LRR_${questionId}" disabled="disabled">
														<option value="">Likelihood Risk Rating</option>
														<option value="3">High</option>
														<option value="2">Medium</option>
														<option value="1">Low</option>
													</select>
												</td>
												<%-- <td style="width: 6%">
													<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">C</button>
													<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">C</button>
												</td> --%>
											</tr>	
											</c:if>
											<c:if test="${isFreeTextReq eq 'N'}">
											<tr>
												<td style="width: 5%; text-align: center;">
													${questionId}.${questionVersion}
												</td>
												<td style="width: 40%">
													${questionSet['QUESTIONDESCRIPTION']}
												</td>
												<td colspan="2">
													<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="CUSTOMER_OPTION_${questionId}.${questionVersion}" 
															onchange="getCustRiskRating(this,'IMPACTRISKRATING_${questionId}_${UNQID}', 'LIKELIHOODRISKRATING_${questionId}_${UNQID}')">
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
												<td style="width: 15%; text-align: center;">
													<select class="form-control input-sm risk1" id="IMPACTRISKRATING_${questionId}_${UNQID}" name="CUSTOMER_IRR_${questionId}" 
															disabled="disabled">
														<option value="">Impact Risk Rating</option>
														<option value="3">High</option>
														<option value="2">Medium</option>
														<option value="1">Low</option>
													</select>
												</td>	
												<td style="width: 15%; text-align: center;">
													<select class="form-control input-sm risk2" id="LIKELIHOODRISKRATING_${questionId}_${UNQID}" name="CUSTOMER_LRR_${questionId}" disabled="disabled" >
														<option value="">Likelihood Risk Rating</option>
														<option value="3">High</option>
														<option value="2">Medium</option>
														<option value="1">Low</option>
													</select>
												</td>	
												<%-- <td style="width: 6%">
													<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">C</button>
													<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">C</button>
												</td> --%>
											</tr>
											</c:if>
										</tbody>
									</c:forEach>
								</table>
							</div>
					</div>
				</div>
			</c:forEach>
		</c:forEach>
		
		<div class="card card-primary panel_RiskCalculationForm" style="margin-top: 20px; margin-bottom: 0;">
			<div class="card-header panelSlidingRiskCalculationForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Calculation</h6>
			</div>
			<div class="panelSearchForm">
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
									<tr>
										<td width="25%">
											System Generated Risk Rating
										</td>
										<td width="20%" style="text-align: center;">	
											<button type="button" class="btn btn-primary btn-sm" id="calculateCustomerRisk${UNQID}">Calculate</button>
										</td>
										<td width="5%">&nbsp;</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm"  readonly="readonly" 
											       name="CUSTOMER_SYSTEMRISKRATING" id="CUSTOMER_SYSTEMRISKRATING${UNQID}" 
											      value="${CUSTOMERRISKTABDATA['CUSTOMERSYSTEMGENRISK']}"/>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Provisional Risk Rating
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" name="CUSTOMER_PROVISIONALRISKRATING" 
											       id="CUSTOMER_PROVISIONALRISKRATING${UNQID}" value="${CUSTOMERRISKTABDATA['CUSTOMERPROVISRISK']}">
										</td>
										<td width="5%">&nbsp;</td>
										<td width="15%">
											Final Risk Rating
										</td>
										<td width="15%">
											<%-- <select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING" id="CUSTOMER_FINALRISKRATING${UNQID}"
													onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING${UNQID}')">
												<option value="">Select Risk Rating</option>
												<option value="3" <c:if test="${CUSTOMERRISKTABDATA['CUSTOMERFINALRISK'] eq 'High - 3'}">selected="selected"</c:if>>High</option>
												<option value="2" <c:if test="${CUSTOMERRISKTABDATA['CUSTOMERFINALRISK'] eq 'Medium - 2'}">selected="selected"</c:if>>Medium</option>
												<option value="1" <c:if test="${CUSTOMERRISKTABDATA['CUSTOMERFINALRISK'] eq 'Low - 1'}">selected="selected"</c:if>>Low</option>
											</select> --%>
											<select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING1" id="CUSTOMER_FINALRISKRATING1${UNQID}"
												onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
												<c:forEach var="i" begin="0" end="9">
													<option value="${i}" <c:if test="${custFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
												</c:forEach>
											</select>
										</td>
										<td width="15%">
											 <select class="form-control input-sm" name="CUSTOMER_FINALRISKRATING2" id="CUSTOMER_FINALRISKRATING2${UNQID}"
													onchange="getCustFinalRiskRating(this, 'CUSTOMER_FINALRISKRATING1${UNQID}', 'CUSTOMER_FINALRISKRATING2${UNQID}')">
												<c:forEach var="i" begin="00" end="99">
													<option value=".${i}" <c:if test="${custFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
													<%-- <c:if test="${custFinalRiskVal[0] eq i}">selected="selected"</c:if> --%>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Reason(s) for Deviations between Provisional and Final Risk Rating
										</td>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="CUSTOMER_RISKRATINGREASON" id="CUSTOMER_RISKRATINGREASON${UNQID}">${CUSTOMERRISKTABDATA['CUSTOMERREMARKS']}</textarea>
										</td>
									</tr>
							</tbody>
						</table>
					</div>
			</div>
		</div>
	</div>
</div>