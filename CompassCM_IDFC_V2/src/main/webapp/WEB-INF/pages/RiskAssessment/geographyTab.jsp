<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';	
		var CURRENTROLE = '${CURRENTROLE}';
		var STATUS = "${GEORISKTABDATA['STATUS']}";
		var GEOGRAPHY_WEIGHTAGE = '${GEOGRAPHY_WEIGHTAGE}';
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#geographyTabDiv"+id).find("input, textarea, select").prop("disabled", true);
		}
		
		 $(".optionSelection").each(function(){
			if($(this).val() != ''){
				var selectedOptionElm = $(this).attr('id');
				var questionId = selectedOptionElm.toString().replace('OPTION_', '');
				var impactRiskRatingId = 'IMPACTRISKRATING_'+questionId;
				var likelihoodRiskRatingId = 'LIKELIHOODRISKRATING_'+questionId;
				setSelectedGeoRiskRating($(this).val(), impactRiskRatingId, likelihoodRiskRatingId);
			} 
		}); 
		
		$("#calculateGeographyRisk"+id).click(function(){
			var geographyRiskRating = "High"; //dummy for testing
			
			var multipliedRiskArr = [];
			
			$(".riskAssessmentForm"+id+" > tbody > tr ").each(function(){
				var risk1 = $(this).find(".risk1").val();
				var risk2 = $(this).find(".risk2").val();
				var multipliedRisk = risk1 * risk2;
				multipliedRiskArr.push(multipliedRisk);
			});
			
			var questionCount = multipliedRiskArr.length;
			var totalRisk = 0;
			
			for (var i = 0; i < questionCount; i++) {
				totalRisk += multipliedRiskArr[i];
			}
			
			var averageRiskRating = (totalRisk/questionCount).toFixed(2);
			var averageRisk = "";
			var averageRiskMagnitude = "";
			
			var provisionalRiskRating = (averageRiskRating * (GEOGRAPHY_WEIGHTAGE/100)).toFixed(2);
			
			if(provisionalRiskRating <= 2){
				provisionalRiskRating = "Low - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 2 && provisionalRiskRating <= 6){
				provisionalRiskRating = "Medium - "+provisionalRiskRating;
			}else if(provisionalRiskRating > 6){
				provisionalRiskRating = "High - "+provisionalRiskRating;
			}
			
			$("#GEOGRAPHY_SYSTEMRISKRATING"+id).val(averageRiskRating);		
			$("#GEOGRAPHY_PROVISIONALRISKRATING"+id).val(provisionalRiskRating);		
			
			$("#geographySysRiskRating").val(averageRiskRating);
			$("#geographyProvRiskRating").val(provisionalRiskRating);
			
			setCalculatedTotalSystemGenRisk();
			setCalculatedTotalProvRisk();
		});
		
		function setCalculatedTotalSystemGenRisk(){
			var totalVal = 0;
			$(".systemGenRisk").each(function(){
				var eachVal = $(this).val();
				if(eachVal != null){
					totalVal += Number(eachVal);
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
	
	function getGeographyRiskRating(elm, impactRiskRatingId, likelihoodRiskRatingId){
		//alert($(elm).val());
		var fullVal = $(elm).val().split('~~');
		var bothRiskRatingVal = fullVal[0].split('~-~');
		//alert(bothRiskRatingVal);
		var optionVal = fullVal[1];
		var impactRiskRatingVal = bothRiskRatingVal[0];
		var likelihoodRiskRatingVal = bothRiskRatingVal[1];
		//alert(impactRiskRatingId+" "+likelihoodRiskRatingId+" R = "+impactRiskRatingVal+" R1 = "+likelihoodRiskRatingVal);
		
		$("#"+impactRiskRatingId).val(impactRiskRatingVal);
		$("#"+likelihoodRiskRatingId).val(likelihoodRiskRatingVal);
		
		//$("#"+riskRatingId+" option[value="+riskRatingVal+"]").attr("selected","selected");
		//$("#"+riskRatingId1+" option[value="+riskRatingVal1+"]").attr("selected","selected");
	}
	
	function setSelectedGeoRiskRating(selectedRiskVal, impactRiskRatingId, likelihoodRiskRatingId){
		var fullVal = selectedRiskVal.split('~~');
		var bothRiskRatingVal = fullVal[0].split('~-~');
		var optionVal = fullVal[1];
		var impactRiskRatingVal = bothRiskRatingVal[0];
		var likelihoodRiskRatingVal = bothRiskRatingVal[1];
		
		$("#"+impactRiskRatingId).val(impactRiskRatingVal);
		$("#"+likelihoodRiskRatingId).val(likelihoodRiskRatingVal);
	}
	
	function getGeoFinalRiskRating(elm, finalRiskRatingId1, finalRiskRatingId2){
		//var finalRisk = $("#"+finalRiskRatingId+" :selected").val();	
		//var finalRiskRatingVal = $("#"+finalRiskRatingId+" :selected").text();		
		var finalRisk = $("#"+finalRiskRatingId1+" :selected").val()+$("#"+finalRiskRatingId2+" :selected").val();	
		
		if(finalRisk <= 9){
			var finalRiskRatingVal = (finalRisk <= 2) ? "Low - "+finalRisk : (finalRisk >2 && finalRisk <= 6) ? "Medium - "+finalRisk : (finalRisk > 6) ? "High - "+finalRisk : "";	
			$("#geographyFinalRiskRating").val(finalRiskRatingVal);
			//$("#geographyFinalRiskRating").html(finalRiskRatingVal);
			
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
				}
			});
		}else{
			alert("The Final Risk should not be more than 9.");
		}
	}
	
</script>
<div class="row compassrow${UNQID}" id="geographyTabDiv${UNQID}">
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
									<c:set var="geographyFinalRiskVal" value="${f:split(GEORISKTABDATA['GEOGFINALRISK'], ' - ')}"></c:set>
									<c:set var="geographyFinalRiskRating" value="${f:split(geographyFinalRiskVal[1], '.')}"></c:set>
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
														<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="GEOGRAPHY_OPTION_${questionId}.${questionVersion}" 
																onchange="getGeographyRiskRating(this,'IMPACTRISKRATING_${questionId}_${UNQID}', 'LIKELIHOODRISKRATING_${questionId}_${UNQID}')">
															<option value="">Select Option</option>
															<c:forEach var="optionsList" items="${OPTIONSLIST}">
																<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
																<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
																<c:set var="optionsRiskList_1" value="${optionsRiskRatingList[1]}"></c:set>
																<c:set var="selectedOptionsRiskList" value="${optionsRiskRatingList[2]}"></c:set>
																<c:forEach var="optionMap" items="${optionsRiskList_0}">
																<c:forEach var="optionRiskMap" items="${optionsRiskList_1}">
																	<c:if test="${not empty optionsRiskRatingList[2]}">
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
																	<c:if test="${empty optionsRiskRatingList[2]}">
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
														<textarea class="form-control input-sm" id="REMARKS_${questionId}_${UNQID}" name="GEOGRAPHY_REMARKS_${questionId}">${remarksData}</textarea>
													</td>
													<td style="width: 10%; text-align: center;">
													<select class="form-control input-sm risk1" id="IMPACTRISKRATING_${questionId}_${UNQID}" name="GEOGRAPHY_IRR_${questionId}" 
																disabled="disabled"	>
															<option value="">Impact Risk Rating</option>
															<option value="3">High</option>
															<option value="2">Medium</option>
															<option value="1">Low</option>
														</select>
													</td>
													<td style="width: 10%; text-align: center;">
													<select class="form-control input-sm risk2" id="LIKELIHOODRISKRATING_${questionId}_${UNQID}" name="GEOGRAPHY_LRR_${questionId}" disabled="disabled">
															<option value="">Likelihood Risk Rating</option>
															<option value="3">High</option>
															<option value="2">Medium</option>
															<option value="1">Low</option>
														</select>
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
												<td colspan="2">
													<select class="form-control input-sm optionSelection" id="OPTION_${questionId}_${UNQID}" name="GEOGRAPHY_OPTION_${questionId}.${questionVersion}" 
															onchange="getCustRiskRating(this,'IMPACTRISKRATING_${questionId}_${UNQID}', 'LIKELIHOODRISKRATING_${questionId}_${UNQID}')">
														<option value="">Select Option</option>
														<c:forEach var="optionsList" items="${OPTIONSLIST}">
															<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
															<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
															<c:set var="optionsRiskList_1" value="${optionsRiskRatingList[1]}"></c:set>
															<c:set var="selectedOptionsRiskList" value="${optionsRiskRatingList[2]}"></c:set>
															<c:forEach var="optionMap" items="${optionsRiskList_0}">
																<c:forEach var="optionRiskMap" items="${optionsRiskList_1}">
																	<c:if test="${not empty optionsRiskRatingList[2]}">
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
																	<c:if test="${empty optionsRiskRatingList[2]}">
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
													<%--	<select class="form-control input-sm" id="OPTION_${questionId}_${UNQID}" name="GEOGRAPHY_${questionId}" 
																onchange="getGeographyRiskRating(this,'IMPACTRISKRATING_${questionId}_${UNQID}', 'LIKELIHOODRISKRATING_${questionId}_${UNQID}')">
															<option value="">Select Option</option>
															<c:forEach var="optionsList" items="${OPTIONSLIST}">
																<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
																<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
																<c:set var="optionsRiskList_1" value="${optionsRiskRatingList[1]}"></c:set>
																<c:forEach var="optionMap" items="${optionsRiskList_0}">
																	<c:forEach var="optionRiskMap" items="${optionsRiskList_1}">
																		<c:if test="${optionMap.value eq optionRiskMap.key}">
																			<c:set var="optionValue" value="${optionMap.value}"></c:set>
																			<c:set var="option" value="${optionMap.key}"></c:set>
																			<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																			<option value="${riskValue}">${optionValue}</option> 
																			<option value="${riskValue}~~${optionValue}">${option}</option>
																		</c:if>
																	</c:forEach>
																</c:forEach>									
															</c:forEach>
															<%-- <c:forEach var="optionsList" items="${OPTIONSLIST}">
																<c:set var="optionsRiskRatingList" value="${optionsList[questionId]}"></c:set>
																<c:set var="optionsRiskList_0" value="${optionsRiskRatingList[0]}"></c:set>
																<c:forEach var="optionRiskMap" items="${optionsRiskList_0}">
																	<c:set var="optionValue" value="${optionRiskMap.key}"></c:set>
																	<c:set var="riskValue" value="${optionRiskMap.value}"></c:set>
																	<option value="${riskValue}">${optionValue}</option>
																</c:forEach>										
															</c:forEach> 
														</select> --%>
													</td>
													<td style="width: 10%; text-align: center;">
														<select class="form-control input-sm risk1" id="IMPACTRISKRATING_${questionId}_${UNQID}" name="GEOGRAPHY_IRR_${questionId}" 
																disabled="disabled">
															<option value="">Impact Risk Rating</option>
															<option value="3">High</option>
															<option value="2">Medium</option>
															<option value="1">Low</option>
														</select>
													</td>	
													<td style="width: 10%; text-align: center;">
													<select class="form-control input-sm risk2" id="LIKELIHOODRISKRATING_${questionId}_${UNQID}" name="GEOGRAPHY_LRR_${questionId}" disabled="disabled" >
															<option value="">Likelihood Risk Rating</option>
															<option value="3">High</option>
															<option value="2">Medium</option>
															<option value="1">Low</option>
														</select>
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
		
		<div class="card card-primary panel_RiskCalculationForm" style="margin-top: 20px;  margin-bottom: 0;">
			<div class="card-header panelSlidingRiskCalculationForm${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Calculation</h6>
			</div>
			<div class="panelSearchForm">
				<%-- <form action="javascript:void(0)" method="POST" id="searchMasterForm_GeographyRiskCal_${UNQID}"> --%>
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>
									<tr>
										<td width="25%">
											System Generated Risk Rating
										</td>
										<td width="20%" style="text-align: center;">	
											<button type="button" class="btn btn-primary btn-sm" id="calculateGeographyRisk${UNQID}">Calculate</button>
										</td>
										<td width="5%">&nbsp;</td>
										<td colspan="2">
											<input type="text" class="form-control input-sm"  readonly="readonly" 
											       name="GEOGRAPHY_SYSTEMRISKRATING" id="GEOGRAPHY_SYSTEMRISKRATING${UNQID}" 
											      value="${GEORISKTABDATA['GEOGSYSTEMGENRISK']}"/>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Provisional Risk Rating
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" name="GEOGRAPHY_PROVISIONALRISKRATING" 
											       id="GEOGRAPHY_PROVISIONALRISKRATING${UNQID}" value="${GEORISKTABDATA['GEOGPROVISRISK']}">
										</td>
										<td width="5%">&nbsp;</td>
										<td width="25%">
											Final Risk Rating
										</td>
										<td width="10%">
											<select class="form-control input-sm" name="GEOGRAPHY_FINALRISKRATING1" id="GEOGRAPHY_FINALRISKRATING1${UNQID}"
												onchange="getGeoFinalRiskRating(this, 'GEOGRAPHY_FINALRISKRATING1${UNQID}', 'GEOGRAPHY_FINALRISKRATING2${UNQID}')">
												<c:forEach var="i" begin="0" end="9">
													<option value="${i}" <c:if test="${geographyFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
												</c:forEach>
											</select>
										</td>
										<td width="10%">
											 <select class="form-control input-sm" name="GEOGRAPHY_FINALRISKRATING2" id="GEOGRAPHY_FINALRISKRATING2${UNQID}"
													onchange="getGeoFinalRiskRating(this, 'GEOGRAPHY_FINALRISKRATING1${UNQID}', 'GEOGRAPHY_FINALRISKRATING2${UNQID}')">
												<c:forEach var="i" begin="00" end="99">
													<option value=".${i}" <c:if test="${geographyFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td width="25%">
											Reason(s) for Deviations between Provisional and Final Risk Rating
										</td>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="GEOGRAPHY_RISKRATINGREASON" id="GEOGRAPHY_RISKRATINGREASON${UNQID}">${GEORISKTABDATA['GEOGREMARKS']}</textarea>
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