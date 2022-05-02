<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	
	/* Chart.defaults.scales.linear.max = 30; //set lebel max on y axis */

	var chartDataPoints = []
	<c:forEach var = "dataPointLabel" items = "${DATAPOINTS.labels}">
	console.log("${dataPointLabel}")
	
		chartDataPoints.push({x: '${DATAPOINTS.dataPoints[dataPointLabel]}', y: '${DATAPOINTS.dataPoints[dataPointLabel]}', r: 30})
	</c:forEach>

	
	const ctx=document.getElementById('myChartt').getContext('2d');
	
	var gradientHor = ctx.createLinearGradient(250, 0, 1200, 0);
	gradientHor.addColorStop(0, 'green');
	gradientHor.addColorStop(0.50, '#ffcc00');
	gradientHor.addColorStop(1, 'red');
	
	var gradient21 = ctx.createLinearGradient(0, 0, 0, 738);
	gradient21.addColorStop(0, 'green');
	gradient21.addColorStop(1, 'yellow');
	
	var gradient13 = ctx.createLinearGradient(0, 0, 1000, 500);
	gradient13.addColorStop(0.2, '#ffcc00');
	gradient13.addColorStop(1, '#e60000');

	
	
const data = {
  labels: [
    'Low',
    'Medium',
    'High',

  ],
 datasets: [{
    type: 'bar',
	barPercentage: 1,
	barThickness: 375,
    label: 'Bar Dataset',
    data: [30,30,30],
    borderColor: 'rgb(255, 99, 132)',
    backgroundColor: ['rgba(0,255,0,0.3)', 'rgba(255,255,0,0.3)','rgba(255,0,0,0.3)'],

	
  }, 
  {
        type: 'bubble',
        label: 'Dataset 2',
        backgroundColor: "black",
        data: chartDataPoints,
        pointStyle: (ctx) => (ctx.dataIndex === 2 ? 'triangle' : 'rectRot'),
        borderColor: 'white',
        borderWidth: 2
      },
]
};
	
	

	
const config = {
  type: 'scatter',
  data: data,
  options: {
	legend: {display: false},
	animation:false,
	plugins: {
    legend: {
      display: false
    },    
	},
	
    scales: {
      y: {
        beginAtZero: true,
		stacked: true,
		ticks: {
                    callback: function(val, index) {
					// Hide the label of every 2nd dataset
					/* return index ===1.0 ? 'HIGH' : '' || index === 3.0 ? 'MEDIUM' : '' || index === 5.0 ? 'LOW' : '' ; */
                    	return index ===1.0 ? '' : '' || index === 3.0 ? '' : '' || index === 5.0 ? '' : '' ;
					},
					color: 'black',
				},
		
		title: {
					display: false,
					text: 'Likelihood =>',
					color: 'black',
					font: {
					family: "Lucida Console",
					size: 40,
					lineHeight: 1.2,
					},
					//padding: {top: 100, left: 0, right: 0, bottom: 0}
				},
		},
		 x: {
		beginAtZero: true,
		stacked: true,
		ticks: {
                    callback: function(val, index) {
					// Hide the label of every 2nd dataset
					/* return index ===1 ? 'LOW' : '' || index === 3.0 ? 'MEDIUM' : '' || index === 5.0 ? 'HIGH' : '' ; */
                    	return index ===1 ? '' : '' || index === 3.0 ? '' : '' || index === 5.0 ? '' : '' ;
					},
					color: 'black',
				},
		
		title: {
					display: false,
					text: 'Impact =>',
					color: 'black',
					font: {
					family: "Lucida Console",
					size: 40,
					lineHeight: 1.2,
					},
					padding: {top: 50, left: 0, right: 0, bottom: 0}
				},
		},
    },
	
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

		<button type="submit">Submit</button>
	</form>
</div>
