<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/chart.js"></script>

<script>
	console.log("MIXED CHART SUMMARY CALLED!!")
	/* Chart.defaults.scales.linear.max = 30; //set lebel max on y axis */
	
	
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS}">
		//console.log("DATAPOINTS: ","${dataPointLabel}")
	</c:forEach>
	
	
	//TRESURY CHART CALCULATION
	var residualRiskDataPoints = []	
	var totalTresuryIR = 0.0
	<c:set var="totalIR_T" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.TreasuryInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_T" value="${totalIR_T + score}" />
	 console.log("${totalIR_T}")
	</c:forEach>
	</c:forEach>
	totalTresuryIR = ${totalIR_T};

	
	var totalTresuryIC = 0.0
	<c:set var="totalIC_T" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.TreasuryInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_T" value="${totalIC_T + score}" />
	 console.log("${totalIC_T}")
	</c:forEach>
	</c:forEach>
	totalTresuryIC = ${totalIC_T};

	
	
	
	//RL chart Calculation
	var totalRetailLiabiltiesIR = 0.0
	<c:set var="totalIR_RL" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailLiabilitiesInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_RL" value="${totalIR_RL + score}" />
	 console.log("${totalIR_RL}")
	</c:forEach>
	</c:forEach>
	totalRetailLiabiltiesIR = ${totalIR_RL};

	
	var totalRetailLiabiltiesIC = 0.0
	<c:set var="totalIC_RL" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailLiabilitiesInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_RL" value="${totalIC_RL + score}" />
	 console.log("${totalIC_RL}")
	</c:forEach>
	</c:forEach>
	totalRetailLiabiltiesIC = ${totalIC_RL};

	
	
	// RA Chart calculation
	var totalRetailAssetsIR = 0.0
	<c:set var="totalIR_RA" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailAssetsInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_RA" value="${totalIR_RA + score}" />
	 console.log("${totalIR_RA}")
	</c:forEach>
	</c:forEach>
	totalRetailAssetsIR = ${totalIR_RA};

	
	var totalRetailAssetsIC = 0.0
	<c:set var="totalIC_RA" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.RetailAssetsInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_RA" value="${totalIC_RA + score}" />
	 console.log("${totalIC_RA}")
	</c:forEach>
	</c:forEach>
	totalRetailAssetsIC = ${totalIC_RA};

	
	//WB chart calculation
	var totalWholesaleIR = 0.0
	<c:set var="totalIR_WB" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WholesaleBankingInherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIR_WB" value="${totalIR_WB + score}" />
	 console.log("${totalIR_WB}")
	</c:forEach>
	</c:forEach>
	totalWholesaleIR = ${totalIR_WB};

	
	var totalWholesaleIC = 0.0
	<c:set var="totalIC_WB" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.WholesaleBankingInternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.FINALRISKRATING}">
	 <c:set var="totalIC_WB" value="${totalIC_WB + score}" />
	 console.log("${totalIC_WB}")
	</c:forEach>
	</c:forEach>
	totalWholesaleIC = ${totalIC_WB};
	
	total_of_IR = (totalTresuryIR + totalRetailLiabiltiesIR + totalRetailAssetsIR + totalWholesaleIR)/4;
	total_of_IC = (totalTresuryIC + totalRetailLiabiltiesIC + totalRetailAssetsIC + totalWholesaleIC)/4;
	
	
	if(total_of_IR <= 2){
		if(total_of_IR == 0){
			total_of_IR = 0;
		}
		if(total_of_IR > 0 && total_of_IR < 2){
			total_of_IR = (total_of_IR * 2) + 0.5;
		}
		if(total_of_IR == 2){
			total_of_IR = 5;
		}
	}
	
	else if(total_of_IR > 2  && total_of_IR <= 5){
			total_of_IR = (total_of_IR * 2) + 0.5;
	}
	
	else if(total_of_IR > 5 && total_of_IR <= 14){
		if(total_of_IR > 5 && total_of_IR < 8){
			total_of_IR = (total_of_IR * 1.5) + 0.5;
		}
		if(total_of_IR > 8 && total_of_IR < 10){
			total_of_IR = (total_of_IR * 1.2) + 0.5;
		}
		if(total_of_IR > 10 && total_of_IR < 14){
			total_of_IR = 14;
		}
	}
	
	else if(total_of_IR > 14.5){
		total_of_IR = 14;
	}
	
	else{
		console.log("N.A")
	}
	
	
	if(total_of_IC <= 2){
		if(total_of_IC == 0){
			total_of_IC = 0;
		}
		if(total_of_IC > 0 && total_of_IC < 2){
			total_of_IC = (total_of_IC * 2) + 0.5;
		}
		if(total_of_IC == 2){
			total_of_IC = 5;
		}
	}
	
	else if(total_of_IC > 2  && total_of_IC <= 5){
			total_of_IC = (total_of_IC * 2) + 0.5;
	}
	
	else if(total_of_IC > 5 && total_of_IR <= 14){
		if(total_of_IC > 5 && total_of_IC < 8){
			total_of_IC = (total_of_IC * 1.5) + 0.5;
		}
		if(total_of_IC > 8 && total_of_IC < 10){
			total_of_IC = (total_of_IC * 1.2) + 0.5;
		}
		if(total_of_IC > 10 && total_of_IC < 14){
			total_of_IC = 14;
		}
	}
	
	else if(total_of_IC > 14.5){
		total_of_IC = 14;
	}
	
	else{
		console.log("N.A")
	}
	
	
	var bankLevelResidualRisk = [];
	bankLevelResidualRisk.push({x: total_of_IR, y: total_of_IC, r: 20});
	
	if(totalTresuryIR == 0)
	{totalTresuryIR = 0.5}
	else if(totalTresuryIR > 14.5)
	{totalTresuryIR = 14}
	
	if(totalRetailLiabiltiesIR == 0)
	{totalRetailLiabiltiesIR = 0.5}
	else if(totalRetailLiabiltiesIR > 14.5)
	{totalRetailLiabiltiesIR = 14}
	
	if(totalRetailAssetsIR == 0)
	{totalRetailAssetsIR = 0.5}
	else if(totalRetailAssetsIR > 14.5)
	{totalRetailAssetsIR = 14}
	
	if(totalWholesaleIR == 0)
	{totalWholesaleIR = 0.5}
	else if(totalWholesaleIR > 14.5)
	{totalWholesaleIR = 14}
	
	if(totalTresuryIC == 0)
	{totalTresuryIC = 0.5}
	else if(totalTresuryIC > 14.5)
	{totalTresuryIC = 14}
	
	if(totalRetailLiabiltiesIC == 0)
	{totalRetailLiabiltiesIC = 0.5}
	else if(totalRetailLiabiltiesIC > 14.5)
	{totalRetailLiabiltiesIC = 14}
	
	if(totalRetailAssetsIC == 0)
	{totalRetailAssetsIC = 0.5}
	else if(totalRetailAssetsIC > 14.5)
	{totalRetailAssetsIC = 14}
	
	if(totalWholesaleIC == 0)
	{totalWholesaleIC = 0.5}
	else if(totalWholesaleIC > 14.5)
	{totalWholesaleIC = 14}
	
	else{
		console.log()
	}

	residualRiskDataPoints.push({x: totalTresuryIR, y: totalTresuryIC, r: 20})
	residualRiskDataPoints.push({x: totalRetailLiabiltiesIR, y: totalRetailLiabiltiesIC, r: 20})
	residualRiskDataPoints.push({x: totalRetailAssetsIR, y: totalRetailAssetsIC, r: 20})
	residualRiskDataPoints.push({x: totalWholesaleIR, y: totalWholesaleIC, r: 20})
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//DEFAULT VALUE CHART CREATION STARTED
	const defalutValueCTX=document.getElementById('defalutValueCanvas').getContext('2d');
	const defalutValueDATA = {
			  datasets: [{
			    label: 'DEFAULT VALUE RISK',
			    data: [{
			      x: 0.5,
			      y: 0.5,
			      r: 20
			    },],
			    pointStyle: 'crossRot',
			    borderWidth: 6,
			    backgroundColor: 'rgba(0, 0, 0, 1)',
			    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const defalutValueCONFIG = {
		  type: 'bubble',
		  data: defalutValueDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 15,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 15,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const defalutValueChart = new Chart(defalutValueCTX, defalutValueCONFIG);
	var defalutValueIMAGE = defalutValueChart.toBase64Image();
	document.getElementById("defalutValueURL").value = defalutValueIMAGE;
	defalutValueChart.destroy();
	//DEFALUT VALUE CHART CREATION ENDED
	
	
	//RESIDUAL RISK CHART CREATION STARTED
	const residualRiskCTX=document.getElementById('residualRiskCanvas').getContext('2d');
	const residualRiskDATA = {
			  datasets: [{
			    label: 'RESIDUAL RISK',
			    data: bankLevelResidualRisk,
			    /* data: [{
				      x: 0.5,
				      y: 0.5,
				      r: 20
				    },], */
				    pointStyle: 'crossRot',
				    borderWidth: 6,
				    backgroundColor: 'rgba(0, 0, 0, 1)',
				    borderColor: 'rgba(0, 0, 0, 1)',
			  }]
			};		

	const residualRiskCONFIG = {
		  type: 'bubble',
		  data: residualRiskDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },

			  scales: {
		            x: {
		            	display: false,
		            	min: 0,
		                max: 15,
		            	ticks: { display: false},
		                grid: { display: false,},
		            	},		            			            	
		            
		            y: {
		            	display: false,
		            	min: 0,
		                max: 15,
		            	ticks: { display: false},
		                grid: { display: false,}, 
		                reverse: true,
		            	},			            
		        }
		  }
		};		

	const residualRiskChart = new Chart(residualRiskCTX,residualRiskCONFIG);
	var residualRiskIMAGE = residualRiskChart.toBase64Image();
	document.getElementById("residualRiskURL").value = residualRiskIMAGE;
	residualRiskChart.destroy();
	//RESIDUAL RISK CHART CREATION ENDED
	
	
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION STARTED
	const assessmentCatCTX=document.getElementById('assessmentCatCanvas').getContext('2d');
	const assessmentCatDATA = {
			  datasets: [{
			    label: 'ASSESSMENT UNIT WISE',
			    //data: residualRiskDataPoints,
			     data: [{
			      x: 10,
			      y: 20,
			      r: 20
			    }, {
			      x: 20,
			      y: 10,
			      r: 20
			    }, {
				   x: 5,
				   y: 15,
			       r: 20
				}, {
				   x: 15,
			       y: 5,
			       r: 20
				 }, {
				   x: 25,
			       y: 25,
		           r: 20
					 },], 
				pointStyle: ['crossRot', 'rect', 'triangle', 'circle'],
			    backgroundColor: 'rgb(0, 0, 0)'
			  }]
			};		

	const assessmentCatCONFIG = {
		  type: 'bubble',
		  data: assessmentCatDATA,
		  options: {
			  plugins: { legend: { display: false }, },
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },
			  scales: {
		            x: {
		                ticks: { display: false},
		                grid: { display: false,},
		            	},		            	
		            	
		            
		            y: {
		                ticks: { display: false},
		                grid: { display: false,}, 
		            	},			            
		        }
		  }
		};		

	const assessmentCatChart = new Chart(assessmentCatCTX,assessmentCatCONFIG);
	var assessmentCatIMAGE = assessmentCatChart.toBase64Image();
	var img = document.getElementById('assessmentCatCanvas').toDataURL("image/png");
	//console.log("assessmentCatChart:",img)
	document.getElementById("assessmentCatURL").value = assessmentCatIMAGE;
	assessmentCatChart.destroy();
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION ENDED
	
	

	//SET VALUE ON INPUT TYPE
	document.getElementById("totalTresuryIR").value = totalTresuryIR;
	document.getElementById("totalTresuryIC").value = totalTresuryIC;
	
	document.getElementById("totalRetailLiabiltiesIR").value = totalRetailLiabiltiesIR;
	document.getElementById("totalRetailLiabiltiesIC").value = totalRetailLiabiltiesIC;
	
	document.getElementById("totalRetailAssetsIR").value = totalRetailAssetsIR;
	document.getElementById("totalRetailAssetsIC").value = totalRetailAssetsIC;
	
	document.getElementById("totalWholesaleIR").value = totalWholesaleIR;
	document.getElementById("totalWholesaleIC").value = totalWholesaleIC;

		
</script>

<div>	
	<form action="imagedata" method="post" id = "chartForm">
		<div>
			<canvas id="defalutValueCanvas"></canvas>
			<canvas id="residualRiskCanvas"></canvas>
			<canvas id="assessmentCatCanvas"></canvas>
			<input type="text" id="defalutValueURL" name="defalutValueURL"/>				
			<input type="text" id="residualRiskURL" name="residualRiskURL"/>
			<input type="text" id="assessmentCatURL" name="assessmentCatURL"/>
			
			<input type="text" id="totalTresuryIR" name="totalTresuryIR"/>
			<input type="text" id="totalTresuryIC" name="totalTresuryIC"/>
			
			<input type="text" id="totalRetailLiabiltiesIR" name="totalRetailLiabiltiesIR"/>
			<input type="text" id="totalRetailLiabiltiesIC" name="totalRetailLiabiltiesIC"/>
			
			<input type="text" id="totalRetailAssetsIR" name="totalRetailAssetsIR"/>
			<input type="text" id="totalRetailAssetsIC" name="totalRetailAssetsIC"/>
			
			<input type="text" id="totalWholesaleIR" name="totalWholesaleIR"/>
			<input type="text" id="totalWholesaleIC" name="totalWholesaleIC"/>
		</div>
	</form>
</div>
