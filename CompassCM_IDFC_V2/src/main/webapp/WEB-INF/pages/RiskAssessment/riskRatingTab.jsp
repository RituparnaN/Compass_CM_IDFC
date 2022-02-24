<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="custFinalRiskRating" value=""></c:set>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';	
		var CURRENTROLE = '${CURRENTROLE}';
		var STATUS = "${RISKTABDATA['STATUS']}";
		var total1 = 0;
		var total2 = 0;
		var total3 = 0;
		var totalInherentUnitsSysRisk;
		var totalInherentUnitsProvRisk;
		var totalInherentUnitsFinalRisk;
		
		if((CURRENTROLE == 'ROLE_CM_MANAGER') || (CURRENTROLE == 'ROLE_CM_OFFICER' && STATUS == 'CMM-A')){
			$("#riskRatingTabDiv"+id).find("input, textarea, select").prop("disabled", true);
		}
		
		var totalInherentUnitsFinalRiskRatingVal  = $("#totalInherentUnitsFinalRiskRating").val();
		var controlParamsFinalRiskRatingVal  = $("#controlParamsFinalRiskRating").val();
		//console.log("controlParamsFinalRiskRatingVal = "+controlParamsFinalRiskRatingVal);
		$("#TOTAL_SYSTEMRISKRATING"+id).val(totalInherentUnitsFinalRiskRatingVal+","+controlParamsFinalRiskRatingVal);
		
		var IRMagnitude = totalInherentUnitsFinalRiskRatingVal.split(' - ')[0];
		var CPMagnitude = controlParamsFinalRiskRatingVal.split(' - ')[0];
		
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
		
		/* $("#calculateTotalRisk"+id).click(function(){
			var totalRiskRating = "High"; //dummy for testing
			$("#TOTAL_SYSTEMRISKRATING"+id).val(totalRiskRating);		
			$("#TOTAL_PROVISIONALRISKRATING"+id).val(totalRiskRating);		
		}); */
		
		$(".systemGenRisk").each(function(){
			//var eachVal = $(this).val().split(" - ")[1];
			var eachVal = $(this).val();
			if(eachVal !== null && eachVal !== ""){
				total1 += Number(eachVal);
				totalInherentUnitsSysRisk =  (total1.toFixed(2) <= 2) ? "Low - "+total1.toFixed(2) : (total1.toFixed(2) >2 && total1.toFixed(2) <= 6) ? "Medium - "+total1.toFixed(2) : (total1.toFixed(2) > 6) ? "High - "+total1.toFixed(2) : "";
				$("#totalInherentUnitsSysRiskRating").val(totalInherentUnitsSysRisk);
			}
		});
		
		$(".provRisk").each(function(){
			var eachVal = $(this).val().split(" - ")[1];
			if(eachVal != null){
				total2 += Number(eachVal);
				totalInherentUnitsProvRisk =  (total2.toFixed(2) <= 2) ? "Low - "+total2.toFixed(2) : (total2.toFixed(2) > 2 && total2.toFixed(2) <= 6) ? "Medium - "+total2.toFixed(2) : (total2.toFixed(2) > 6) ? "High - "+total2.toFixed(2) : "";
				$("#totalInherentUnitsProvRiskRating").html(totalInherentUnitsProvRisk);
			}
		});
		
		$(".finalRisk").each(function(){
			var eachVal = $(this).val().split(" - ")[1];
			//var eachVal = $(this).val();
			//console.log(eachVal);
			if(eachVal != null){
				total3 += Number(eachVal);
				//console.log(total3.toFixed(2));
				totalInherentUnitsFinalRisk =  (total3.toFixed(2) <= 2) ? "Low - "+total3.toFixed(2) : (total3.toFixed(2) > 2 && total3.toFixed(2) <= 6) ? "Medium - "+total3.toFixed(2) : (total3.toFixed(2) > 6) ? "High - "+total3.toFixed(2) : "";
				//console.log(totalInherentUnitsFinalRisk);
				$("#totalInherentUnitsFinalRiskRating").val(totalInherentUnitsFinalRisk);
			}
		});

	});

</script>

<div class="row compassrow${UNQID}" id="riskRatingTabDiv${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary panel_RiskCalculationForm" style="margin-top: 10px; margin-bottom: 0;">
			<div class="card-header panelSlidingRiskMatrix${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Risk Matrix</h6>
			</div>
			<div class="panelSearchForm">
				<%-- <form action="javascript:void(0)" method="POST" id="searchMasterForm_RiskMatrix_${UNQID}"> --%>
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable riskMatrixForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<%-- <c:set var="residualFinalRiskVal" value="${f:split(RISKTABDATA['RESIDUALFINALRISK'], ' - ')}"></c:set> --%>
							<c:set var="residualFinalRiskRating" value="${f:split(RISKTABDATA['RESIDUALFINALRISK'], '.')}"></c:set>
							<tbody>
									<tr class="info">
										<td colspan="5" style="text-align: left; font-weight: bolder;">
											Inherent Risk Ratings
										</td>
									</tr>
									<tr style="text-align: left; font-weight: bolder;">
										<td width="30%">
											Assessment Unit
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 System Generated Risk Rating
										</td>
										<td width="20%">
											 Provisional Risk Rating
										</td>
										<td width="20%">
											 Final Risk Rating
										</td>
									</tr>
									<tr>
										<td width="30%">
											Customer
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "customerSysRiskRating"
											 value="${RISKTABDATA['CUSTOMERSYSTEMGENRISK']}" >
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "customerProvRiskRating"
											 value="${RISKTABDATA['CUSTOMERPROVISRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "customerFinalRiskRating"
											 value="${RISKTABDATA['CUSTOMERFINALRISK']}">
										</td>
									</tr>
									<tr>
										<td width="30%">
											Geography
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "geographySysRiskRating"
											 value="${RISKTABDATA['GEOGSYSTEMGENRISK']}">
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "geographyProvRiskRating"
											 value="${RISKTABDATA['GEOGPROVISRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "geographyFinalRiskRating"
											 value="${RISKTABDATA['GEOGFINALRISK']}">
										</td>
									</tr>
									<tr>
										<td width="30%">
											Products & Services
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "prodServSysRiskRating"
											 value="${RISKTABDATA['PRODUCTSSYSTEMGENRISK']}">
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "prodServProvRiskRating"
											 value="${RISKTABDATA['PRODUCTSPROVISRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "prodServFinalRiskRating"
											 value="${RISKTABDATA['PRODUCTSFINALRISK']}">
										</td>
									</tr>
									<tr>
										<td width="30%">
											Transactions
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "txnSysRiskRating"
											 value="${RISKTABDATA['TRANSACTIONSSYSTEMGENRISK']}">
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "txnProvRiskRating"
											 value="${RISKTABDATA['TRANSACTIONSPROVISRISK']}">
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "txnFinalRiskRating"
											 value="${RISKTABDATA['TRANSACTIONSFINALRISK']}">
										</td>
									</tr>
									<tr>
										<td width="30%">
											Delivery Channels
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm systemGenRisk" id = "deliveryChannelsSysRiskRating"
											 value="${RISKTABDATA['DELIVERYSYSTEMGENRISK']}">
										</td>
										<td width="20%">
											 <input type="text" readonly="readonly" class="form-control input-sm provRisk" id = "deliveryChannelsProvRiskRating"
											 value="${RISKTABDATA['DELIVERYPROVISRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm finalRisk" id = "deliveryChannelsFinalRiskRating"
											 value="${RISKTABDATA['DELIVERYFINALRISK']}">
										</td>
									</tr>
									<tr>
										<td width="30%">
											Total Inherent Assessment Units Risk Rating
										</td>
										<td width="10%">&nbsp;</td>
										<td>
										 	<input type="text" readonly="readonly" class="form-control input-sm" 
										 		name ="TOTAL_INHERENTSYSTEMRISKRATING" id = "totalInherentUnitsSysRiskRating"
											 value="${RISKTABDATA['TOTINHSYSGENRISK']}">
										</td>
										<td>
											 <input type="text" readonly="readonly" class="form-control input-sm" 
											 	name ="TOTAL_INHERENTPROVRISKRATING" id = "totalInherentUnitsProvRiskRating"
											 value="${RISKTABDATA['TOTINHPROVISRISK']}">
										</td>
										<td>
											 <input type="text" readonly="readonly" class="form-control input-sm" 
											 name ="TOTAL_INHERENTFINALRISKRATING" id = "totalInherentUnitsFinalRiskRating"
											 value="${RISKTABDATA['TOTINHFINALRISK']}">
										</td>
									</tr>
									
									<tr class="info">
										<td colspan="5" style="text-align: left; font-weight: bolder;">
											Control Parameters Risk Rating
										</td>
									</tr>
									<tr style="text-align: left; font-weight: bolder;">
										<td width="30%">
											Sub Group
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											 System Generated Risk Rating
										</td>
										<td width="20%">
											 Provisional Risk Rating
										</td>
										<td width="20%">
											 Final Risk Rating
										</td>
									</tr>
									<tr>
										<td width="30%">
											Control Parameters
										</td>
										<td width="10%">&nbsp;</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" id = "controlParamsSysRiskRating"
											 value="${RISKTABDATA['CONTROLSYSTEMGENRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" id = "controlParamsProvRiskRating"
											 value="${RISKTABDATA['CONTROLPROVISRISK']}">
										</td>
										<td width="20%">
											<input type="text" readonly="readonly" class="form-control input-sm" id = "controlParamsFinalRiskRating"
											 value="${RISKTABDATA['CONTROLFINALRISK']}">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- </form> -->
					</div>
				</div>
			<div class="card card-primary panel_RiskCalculationForm" style="margin-top: 10px; margin-bottom: 0;">	
				<div class="card-header panelSlidingRiskCalculation${UNQID} clearfix">
					<h6 class="card-title pull-${dirL}">Risk Calculation</h6>
				</div>
				<div class="panelSearchForm">
				<%-- <form action="javascript:void(0)" method="POST" id="searchMasterForm_TotalRiskCal_${UNQID}"> --%>
					<div class="card-search-card" >
						<table class="table table-striped formSearchTable riskCalculationForm${UNQID}" style="margin-bottom: 0px;border-collapse:collapse;">
							<tbody>					
								<tr>
									<td width="25%">
										System Generated Risk Rating
									</td>
									<%-- <td width="20%" style="text-align: center;">	
										<button type="button" class="btn btn-primary btn-sm" id="calculateTotalRisk${UNQID}">Calculate</button>
									</td> --%>
									<td width="25%">&nbsp;</td>
									<td colspan="4">
										<input type="text" class="form-control input-sm"  readonly="readonly" 
										       name="TOTAL_SYSTEMRISKRATING" id="TOTAL_SYSTEMRISKRATING${UNQID}" 
										       value="${RISKTABDATA['RESIDUALSYSTEMGENRISK']}"/>
										       
									</td>
								</tr>	
								<tr>
									<td width="25%">
										Provisional Risk Rating
									</td>
									<td width="20%">
										<input type="text" readonly="readonly" class="form-control input-sm" name="TOTAL_PROVISIONALRISKRATING" 
										       id="TOTAL_PROVISIONALRISKRATING${UNQID}" value="${RISKTABDATA['RESIDUALPROVRISK']}"/>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="15%">
										Final Risk Rating
									</td>
									<td width="15%">
										<select class="form-control input-sm" name="TOTAL_RESIDUALFINALRISKRATING1" id="TOTAL_RESIDUALFINALRISKRATING1${UNQID}">
											<c:forEach var="i" begin="0" end="10">
												<option value="${i}" <c:if test="${residualFinalRiskRating[0] eq i}">selected="selected"</c:if>>${i}</option>
											</c:forEach>
										</select>
									</td>
									<td width="15%">
										 <select class="form-control input-sm" name="TOTAL_RESIDUALFINALRISKRATING2" id="TOTAL_RESIDUALFINALRISKRATING2${UNQID}">
											<c:forEach var="i" begin="00" end="99">
												<option value=".${i}" <c:if test="${residualFinalRiskRating[1] eq i}">selected="selected"</c:if>>.${i}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<td width="25%">
										Reason(s) for Deviations between Provisional and Final Risk Rating
									</td>
									<td colspan="5">
										<textarea rows="2" cols="2" class="form-control" name="TOTAL_RISKRATINGREASON" 
										          id="TOTAL_RISKRATINGREASON${UNQID}">${RISKTABDATA['RESIDUALREMARKS']}</textarea>
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