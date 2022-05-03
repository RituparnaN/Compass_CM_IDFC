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
	totalWeightedScoreIR = "${totalIR}";
	
	var totalWeightedScoreIC = 0.0
	<c:set var="totalIC" value="${0}"/>
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.InternalControl}">
	<c:forEach var = "score" items = "${dataPointLabel.WEIGHTED_SCORE}">
	 <c:set var="totalIC" value="${totalIC + score}" />
	</c:forEach>
	</c:forEach>
	totalWeightedScoreIC = "${totalIC}";

	residualRiskDataPoints.push({x: totalWeightedScoreIR, y: totalWeightedScoreIC, r: 15});
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//RESIDUAL RISK CHART CREATION STARTED
	const residualRiskCTX=document.getElementById('residualRiskCanvas').getContext('2d');
	const residualRiskDATA = {
			  datasets: [{
			    label: 'RESIDUAL RISK',
			    data: residualRiskDataPoints,
			   /*  data: [{
			      x: 20,
			      y: 30,
			      r: 15
			    }, {
			      x: 40,
			      y: 10,
			      r: 15
			    }], */
			    backgroundColor: 'rgb(0, 0, 0)'
			  }]
			};		

	const residualRiskCONFIG = {
		  type: 'bubble',
		  data: residualRiskDATA,
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
		            xAxes: [
		            	{
		                ticks: { display: false},
		                gridLines: { display: false,},
		            	},		            	
		            	],
		            
		            yAxes: [
		            	{
		                ticks: { display: false},
		                gridLines: { display: false,}, 
		            	},	
		            ]
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
		            xAxes: [
		            	{
		                ticks: { display: false},
		                gridLines: { display: false,},
		            	},		            	
		            	],
		            
		            yAxes: [
		            	{
		                ticks: { display: false},
		                gridLines: { display: false,}, 
		            	},	
		            ]
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
