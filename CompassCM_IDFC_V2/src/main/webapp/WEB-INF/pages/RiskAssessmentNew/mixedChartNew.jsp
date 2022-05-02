<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
	
	
	/* Chart.defaults.scales.linear.max = 30; //set lebel max on y axis */

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
	
	//alert(totalWeightedScoreIR+" "+totalWeightedScoreIC)
	residualRiskDataPoints.push({x: totalWeightedScoreIR, y: totalWeightedScoreIC, r: 15})
	alert(residualRiskDataPoints);

	
	
	
	
	
	//CHART CREATION STARTED
	const ctx=document.getElementById('myChartt').getContext('2d');
	const data = {
			  datasets: [{
			    label: 'ResidualRisk-AssessmentWise',
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
			    pointStyle: 'crossRot',
			    backgroundColor: 'rgb(0, 0, 0)'
			  }]
			};	

	

const config = {
		  type: 'bubble',
		  data: data,
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
		                min: 0,
		                max: 30, 
		                ticks: { display: false},
		                gridLines: { display: false,},
		            	},		            	
		            	],
		            
		            yAxes: [
		            	{
		                min: 0,
		                max: 30, 
		                ticks: { display: false},
		                gridLines: { display: false,}, 
		            	},	
		            ]
		        }
		  }
		};

	

// render init block
const myChart = new Chart(ctx,config);

var image = myChart.toBase64Image();
var img = document.getElementById('myChartt').toDataURL("image/png");
console.log("img:",img)
document.getElementById("demo").value = image;



//document.getElementById("savegraph").href = myChart.toBase64Image();
</script>
<div>
	
	<form action="imagedata" method="post" id = "chartForm">
		<div>
			<canvas id="myChartt"></canvas>
			
			<input type="text" id="demo" name="demo"/ >
		</div>
	</form>
</div>
