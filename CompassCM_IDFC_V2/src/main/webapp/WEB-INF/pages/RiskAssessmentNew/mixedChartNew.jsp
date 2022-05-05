<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/chart.js"></script>

<script>
	
	/* Chart.defaults.scales.linear.max = 30; //set lebel max on y axis */
	
	//RESIDUAL RISK CHART CALCULATION
	var residualRiskDataPoints = []	
	var totalWeightedScoreIR = 0.0
	<c:set var="totalIR" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.InherentRisk}">
	<c:forEach var = "score" items = "${dataPointLabel.WEIGHTED_SCORE}">
	 <c:set var="totalIR" value="${totalIR + score}" />
	</c:forEach>
	</c:forEach>
	totalWeightedScoreIR = ${totalIR};
	
	var totalWeightedScoreIC = 0.0
	<c:set var="totalIC" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.InternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.WEIGHTED_SCORE}">
	 <c:set var="totalIC" value="${totalIC + score}" />
	</c:forEach>
	</c:forEach>
	totalWeightedScoreIC = ${totalIC};
	
	var totalWeightedScoreIR_x = totalWeightedScoreIR;
	var totalWeightedScoreIC_y = totalWeightedScoreIC;
	
		
/* 	if(totalWeightedScoreIR < 1){
		totalWeightedScoreIR = totalWeightedScoreIR+0.5;
	} */
	
/* 	if(totalWeightedScoreIC < 1){
		totalWeightedScoreIC = totalWeightedScoreIC+0.5;
	} */
	
/* 	if(totalWeightedScoreIR_x > 14.5){
		totalWeightedScoreIR_x = 14;
	} */
	
	/* if(totalWeightedScoreIC > 14.5){
		totalWeightedScoreIC = 14;
	} */
	
	///
	if(totalWeightedScoreIR_x <= 2){
		if(totalWeightedScoreIR_x == 0){
			totalWeightedScoreIR_x = 0;
		}
		if(totalWeightedScoreIR_x > 0 && totalWeightedScoreIR_x < 2){
			totalWeightedScoreIR_x = (totalWeightedScoreIR_x * 2) + 0.5;
		}
		if(totalWeightedScoreIR_x == 2){
			totalWeightedScoreIR_x = 5;
		}
	}
	
	else if(totalWeightedScoreIR_x > 2  && totalWeightedScoreIR_x <= 5){
			totalWeightedScoreIR_x = (totalWeightedScoreIR_x * 2) + 0.5;
	}
	
	else if(totalWeightedScoreIR_x > 5){
		if(totalWeightedScoreIR_x > 5 && totalWeightedScoreIR_x < 14){
			totalWeightedScoreIR_x = (totalWeightedScoreIR_x * 3) + 0.5;
		}
	}
	
	else if(totalWeightedScoreIR_x > 14.5){
		totalWeightedScoreIR_x = 14;
	}
	
	else{
		console.log("N.A")
	}
	
	
	if(totalWeightedScoreIC_y <= 2){
		if(totalWeightedScoreIC_y == 0){
			totalWeightedScoreIC_y = 0;
		}
		if(totalWeightedScoreIC_y > 0 && totalWeightedScoreIC_y < 2){
			totalWeightedScoreIC_y = (totalWeightedScoreIC_y * 2) + 0.5;
		}
		if(totalWeightedScoreIC_y == 2){
			totalWeightedScoreIC_y = 5;
		}
	}
	
	else if(totalWeightedScoreIC_y > 2  && totalWeightedScoreIC_y <= 5){
			totalWeightedScoreIC_y = (totalWeightedScoreIC_y * 2) + 0.5;
	}
	
	else if(totalWeightedScoreIC_y > 5){
		if(totalWeightedScoreIC_y > 5 && totalWeightedScoreIC_y < 14){
			totalWeightedScoreIC_y = (totalWeightedScoreIC_y * 3) + 0.5;
		}
	}
	
	else if(totalWeightedScoreIC_y > 14.5){
		totalWeightedScoreIC_y = 14;
	}
	
	else{
		console.log("N.A")
	}
	///

	alert(totalWeightedScoreIR_x+" "+totalWeightedScoreIC_y)
	
	residualRiskDataPoints.push({x: totalWeightedScoreIR_x, y: totalWeightedScoreIC_y, r: 15});
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//RESIDUAL RISK CHART CREATION STARTED
	const residualRiskCTX=document.getElementById('residualRiskCanvas').getContext('2d');
	const residualRiskDATA = {
			  datasets: [{
			    label: 'RESIDUAL RISK',
			    data: residualRiskDataPoints,
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
			    data: [{
			      x: 10,
			      y: 20,
			      r: 15
			    }, {
			      x: 20,
			      y: 10,
			      r: 15
			    }, {
				   x: 5,
				   y: 15,
			       r: 15
				}, {
				   x: 15,
			       y: 5,
			       r: 15
				 }, {
				   x: 25,
			       y: 25,
		           r: 15
					 },],
				pointStyle: ['crossRot', 'rect', 'triangle', 'dash', 'circle'],
			    backgroundColor: 'rgb(0, 0, 0)'
			  }]
			};		

	const assessmentCatCONFIG = {
		  type: 'bubble',
		  data: assessmentCatDATA,
		  options: {
			  animation: { duration: 0},
			  layout: {
		            padding: {
		                left: 15,
		                bottom: 15,
		                right: 15,
		                top: 15
		            }
		        },
		        legend: {
		            display: false
		          },
			  scales: {
		            x: {
		                ticks: { display: false},
		                gridLines: { display: false,},
		            	},		            	
		            
		            y:{
		                ticks: { display: false},
		                gridLines: { display: false,}, 
		            	},	
		        }
		  }
		};		

	const assessmentCatChart = new Chart(assessmentCatCTX,assessmentCatCONFIG);
	var assessmentCatIMAGE = assessmentCatChart.toBase64Image();
	var img = document.getElementById('assessmentCatCanvas').toDataURL("image/png");
	console.log("assessmentCatChart:",img)
	document.getElementById("assessmentCatURL").value = assessmentCatIMAGE;
	assessmentCatChart.destroy();
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION ENDED
	
	

	
	document.getElementById("totalWeightedScoreIR").value = totalWeightedScoreIR;
	document.getElementById("totalWeightedScoreIC").value = totalWeightedScoreIC;

		
</script>

<div>	
	<form action="imagedata" method="post" id = "chartForm">
		<div>
			<canvas id="residualRiskCanvas"></canvas>
			<canvas id="assessmentCatCanvas"></canvas>				
			<input type="text" id="residualRiskURL" name="residualRiskURL"/>
			<input type="text" id="assessmentCatURL" name="assessmentCatURL"/>
			
			<input type="text" id="totalWeightedScoreIR" name="totalWeightedScoreIR"/>
			<input type="text" id="totalWeightedScoreIC" name="totalWeightedScoreIC"/>
		</div>
	</form>
</div>
