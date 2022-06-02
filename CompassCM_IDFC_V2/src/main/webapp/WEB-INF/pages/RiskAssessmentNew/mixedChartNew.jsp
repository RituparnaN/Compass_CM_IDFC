<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/chart.js"></script>

<script>
	
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
	
	var totalWeightedScoreIC = 0.0;
	<c:set var="totalIC" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.InternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.WEIGHTED_SCORE}">
	 <c:set var="totalIC" value="${totalIC + score}" />
	</c:forEach>
	</c:forEach>
	totalWeightedScoreIC = ${totalIC};
	
	var totalWeightedScoreIR_x = totalWeightedScoreIR;
	var totalWeightedScoreIC_y = totalWeightedScoreIC;
	
	/////////////////
	if(totalWeightedScoreIR_x <= 5){
		if(totalWeightedScoreIR_x == 0){
			totalWeightedScoreIR_x = 0.8;
		}
		else if(totalWeightedScoreIR_x > 0 && totalWeightedScoreIR_x < 5){
			totalWeightedScoreIR_x = totalWeightedScoreIR_x * 2;
		}
		else if(totalWeightedScoreIR_x == 5){
			totalWeightedScoreIR_x = 10;
		}
	}
	
	else if(totalWeightedScoreIR_x > 5  && totalWeightedScoreIR_x <= 15){
		
		if(totalWeightedScoreIR_x > 5 && totalWeightedScoreIR_x <= 7.5){
			totalWeightedScoreIR_x = totalWeightedScoreIR_x * 2.1;
		}
		
		else if(totalWeightedScoreIR_x > 7.5 && totalWeightedScoreIR_x <= 12){
			totalWeightedScoreIR_x = totalWeightedScoreIR_x * 1.5;
		}
		
		else if(totalWeightedScoreIR_x > 12 && totalWeightedScoreIR_x < 15){
			totalWeightedScoreIR_x = totalWeightedScoreIR_x * 1.3;
		}
		
		else if(totalWeightedScoreIR_x == 15){
			totalWeightedScoreIR_x = 20;
		}
			
	}
	
	else if(totalWeightedScoreIR_x > 15 && totalWeightedScoreIR_x < 20){
		totalWeightedScoreIR_x = totalWeightedScoreIR_x * 1.4;		
	}
	
	else if(totalWeightedScoreIR_x > 20){
		totalWeightedScoreIR_x = 29.5;
	}
	
////////
	
	
	if(totalWeightedScoreIC_y <= 3){
		if(totalWeightedScoreIC_y == 0){
			totalWeightedScoreIC_y = 0.8;
		}
		else if(totalWeightedScoreIC_y > 0 && totalWeightedScoreIC_y < 3){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 3;
		}
		else if(totalWeightedScoreIC_y == 3){
			totalWeightedScoreIC_y = 10;
		}
	}
	
	else if(totalWeightedScoreIC_y > 3  && totalWeightedScoreIC_y <= 7){
		
		if(totalWeightedScoreIC_y > 3 && totalWeightedScoreIC_y <= 3.5){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 4;
		}
		
		else if(totalWeightedScoreIC_y > 3.5 && totalWeightedScoreIC_y <= 4.5){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 3.5;
		}
		
		else if(totalWeightedScoreIC_y > 4.5 && totalWeightedScoreIC_y < 5.5){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 3.5;
		}
		
		else if(totalWeightedScoreIC_y > 5.5 && totalWeightedScoreIC_y < 6.5){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 3;
		}
		
		else if(totalWeightedScoreIC_y > 6.5 && totalWeightedScoreIC_y < 7){
			totalWeightedScoreIC_y = totalWeightedScoreIC_y * 2.5;
		}
		else if(totalWeightedScoreIC_y == 7){
			totalWeightedScoreIC_y = 20;
		}
			
	}
	
	else if(totalWeightedScoreIC_y > 7 && totalWeightedScoreIC_y < 8){
		totalWeightedScoreIC_y = totalWeightedScoreIC_y * 3;		
	}
	
	else if(totalWeightedScoreIC_y > 8){
		totalWeightedScoreIC_y = 29.5;
	}
//////////////////////////
	
	residualRiskDataPoints.push({x: totalWeightedScoreIR_x, y: totalWeightedScoreIC_y, r: 20});
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//RESIDUAL RISK CHART CREATION STARTED
	const residualRiskCTX=document.getElementById('residualRiskNewCanvas').getContext('2d');
	const residualRiskDATA = {
			  datasets: [{
			    label: 'RESIDUAL RISK',
			    //data: residualRiskDataPoints,
			    data: [
				  	{
					  x: totalWeightedScoreIR_x,
					  y: totalWeightedScoreIC_y,
					  r: 20
				  	},
				  	{
					  x: totalWeightedScoreIR_x,
					  y: totalWeightedScoreIC_y,
					  r: 20
				  	},],
			    pointStyle: ['crossRot', 'cross'],
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
			                max: 30,
			            	ticks: { display: false},
			                grid: { display: false,},
			            	},		            			            	
			            
			            y: {
			            	display: false,
			            	min: 0,
			                max: 30,
			            	ticks: { display: false},
			                grid: { display: false,}, 
			                reverse: true,
			            	},			            
			        }
			  }
		};		

	const residualRiskChart = new Chart(residualRiskCTX,residualRiskCONFIG);
	var residualRiskIMAGE = residualRiskChart.toBase64Image();
	document.getElementById("residualRiskNewURL").value = residualRiskIMAGE;
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
	//console.log("assessmentCatChart:",img)
	document.getElementById("assessmentCatURL").value = assessmentCatIMAGE;
	assessmentCatChart.destroy();
	//ASSESSMENT UNITWISE CHART (EACH IR CATEGORY) CREATION ENDED
	
	

	
	document.getElementById("totalWeightedScoreIR").value = totalWeightedScoreIR;
	document.getElementById("totalWeightedScoreIC").value = totalWeightedScoreIC;

		
</script>

<div>	
	<form action="imagedata" method="post" id = "chartForm">
		<div>
			<canvas id="residualRiskNewCanvas"></canvas>
			<canvas id="assessmentCatCanvas"></canvas>				
			<input type="text" id="residualRiskNewURL" name="residualRiskNewURL"/>
			<input type="text" id="assessmentCatURL" name="assessmentCatURL"/>
			
			<input type="text" id="totalWeightedScoreIR" name="totalWeightedScoreIR"/>
			<input type="text" id="totalWeightedScoreIC" name="totalWeightedScoreIC"/>
		</div>
	</form>
</div>
