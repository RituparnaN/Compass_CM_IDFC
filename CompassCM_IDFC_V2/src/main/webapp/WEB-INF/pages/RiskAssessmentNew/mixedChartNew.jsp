<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
	
	
	/* Chart.defaults.scales.linear.max = 30; //set lebel max on y axis */

	var chartDataPoints = []
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.labels}">
	console.log("${dataPointLabel}")
	
		chartDataPoints.push({x: '${DATAPOINTS.dataPoints[dataPointLabel]}', y: '${DATAPOINTS.dataPoints[dataPointLabel]}', r: 30})
	</c:forEach>

	
	const ctx=document.getElementById('myChartt').getContext('2d');
	//DISABLE GRIDLINE GLOBALLY
	//Chart.defaults.scale.gridLines.drawOnChartArea = false;
	//myChart.options.scales['x'].ticks.display = false;
	//myChart.options.scales['y'].ticks.display = false;


	const data = {
			  datasets: [{
			    label: 'First Dataset',
			    data: [{
			      x: 20,
			      y: 30,
			      r: 15
			    }, {
			      x: 40,
			      y: 10,
			      r: 15
			    }],
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
