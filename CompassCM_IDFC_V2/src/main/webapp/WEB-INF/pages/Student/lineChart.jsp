<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>LIne Chart with all feature </title>
<style>
		.gap { 
			margin-top:40px; 
		}
		
		.shadow{
			border-radius:10px;
  			
 			 background: #fff;
 
				
		}
		.shadow:hover{
				border-style:solid;
				border-color: green blue;
				box-shadow: 0 0 100px rgba(33,33,33,.2);
				 transform: translateX(-3px);
				 transition:  1000ms linear;
				
		}

		</style>
</head>
<body>
	<!-- Linae and bar graphs div start -->
	<div class="row gap">
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentLineChart" ></canvas>
			<button class="btn" id="addDataSet"> Add DataSet</button>
			<button class="btn btn-danger" id="removeDataSet"> Remove Dats Set</button>
		</div>
		<!-- <div class="col-sm-offset-1 col-sm-5">
			<table class="table bordered shadow" >
			<thead>
				<tr>
					<th>Student Name</th>
					<th>Student Age</th>
					<th>Student Class</th>
					<th>Pocket Money</th>
				</tr>
			</thead>
			<c:forEach items="${DATA}" var="student" varStatus="status" >
				<tr>
					<td>${student.NAME}</td>
					<td>${student['AGE']}</td>
					<td>${student['CLASS']}</td>
					<td>${student['POCKETMONEY']}</td>
				</tr>
			</c:forEach>
			</table>
		</div> -->
		
		<div class="chart-container   col-sm-6 shadow " >
			<canvas id="studentBarChart" ></canvas>
		</div>
	</div>
	<!-- Line and bar graphs div end -->
	
	<!-- Pie and doughnut graphs div start -->
	<div class="row gap">
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentPieChart" ></canvas>
			<button class="btn" id="addPieDataSet" > Add DataSet</button>
			<button class="btn btn-danger" id="removePieDataSet" > Remove DataSet</button>
		</div>
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentDoughnutChart" ></canvas>
			<button class="btn" id="addDouughnutDataSet" > Add DataSet</button>
			<button class="btn btn-danger" id="removeDouughnutDataSet" > Remove DataSet</button>
		</div>
	</div>
	<!-- Pie and doughnut graphs div end -->
	
	<!-- polar and radar   -->
	<div class="row gap">
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentPolarChart" ></canvas>
			
		</div>
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentRadarChart" ></canvas>
		</div>
	</div>
	
	<!-- polar and Radar graphs div end -->
	
	
	<!-- mixed line and bar -->
	<div class="row gap">
		<div class="chart-container   col-sm-6 shadow"  >
			<canvas id="studentMixedChart" ></canvas>
		</div>
		
	</div>
	
	
	
</body>
<script>
var i;

var dataSets = new Array();


var scatterData = new Array();


var count= 0;

<c:forEach items="${DATASET}" var="sets" varStatus="status1" >
	<c:set var="setName" value="${sets}" />
	dataSets[count] = new Array();
	dataSets[count]['Name'] = '${sets}';
	dataSets[count]['Data']=[
		<c:forEach items="${DATA}"  varStatus="status" >
	
			'${DATA[status.index][setName]}'
			<c:if test="${!status.last}">
            ,
          </c:if>

		</c:forEach>
	];
	count++;
</c:forEach>

	
	
	var studentChart = document.getElementById("studentLineChart").getContext("2d");
	var studentBarChart = document.getElementById("studentBarChart").getContext("2d");
	var studentPieChart = document.getElementById("studentPieChart").getContext("2d");
	var studentDoughnutChart = document.getElementById("studentDoughnutChart").getContext("2d");
	var studentPolarChart = document.getElementById("studentPolarChart").getContext("2d");
	var studentRadarChart = document.getElementById("studentRadarChart").getContext("2d");
	var studentMixedChart = document.getElementById("studentMixedChart").getContext("2d");
	
		var studentData = {
			labels: dataSets[0]['Data'],
			datasets: [{
				label: dataSets[1]['Name'],
				borderColor: "#3e95cd",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[1]['Data'],
			},
			{
				label: dataSets[2]['Name'],
				fill: true,//false,
				borderColor: "#8e5ea2",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[2]['Data'],
			},
			{
				label: dataSets[3]['Name'],
				fill: true,//false,
				borderColor: "#3cba9f",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[3]['Data'],
			}]
		};

		var chartOptions = {
			responsive: true,
			datasetFill : true,
			pointDotRadius: 20,
			title:{
					display:true,
					text:'Student Report',
					fontcolor:'blue',
					fontSize:20
	        },
			
			scales: {
				yAxes: [{
					//stacked: true,
					gridLines: {
						display: true,
						color: "rgba(0,255,0,0.3)"
					},
					scaleLabel: {
						display: true,
						labelString: 'Age'
					},
					ticks: {
						beginAtZero:true
					}
				}],
				xAxes: [{
					gridLines: {
						display: false
					},
					scaleLabel: {
						display: true,
						labelString: 'Student Name'
					},
					ticks: {
						
					}
				}],
				animation: {
					duration: 3000,
					easing: 'easeInQuint'
					},
					scaleShowGridLines : true
			}
			
		};
		 
		var lineChart = new Chart(studentChart, {
			type: 'line',
			data: studentData,
			options: chartOptions
		});
		
		
		//for adding new dataset in line chart
		var dataSet1 = studentData['datasets'].slice();
		$("#addDataSet").click(function(){
			count = studentData['datasets'].length;
			if(count < 3 && count >= 0)
			{
				studentData['datasets'].push(dataSet1[count]);
				lineChart.update();
				
			}
			else
			{
				alert("No More Data Set To Add");
			}
		});
		
		
		
		dataSetIndex = studentData['datasets'].length-1;
		//For Removing Dataset
		 $("#removeDataSet").click(function(){
			count = studentData['datasets'].length-1;
			if(count >= 0 && count <= dataSetIndex)
			{
			 	studentData['datasets'].splice(count);
				lineChart.update();
			}
			else
			{
				alert("NO More DataSet to Remove");	
			}
		});
		
		
		// Bar Chart start for here
		
		var studentBarData =  {
			    labels:dataSets[0]['Data'],
			    datasets: [
			        {
			            label: dataSets[1]['Name'],
			            fill:true,
			            backgroundColor: "yellow",
			            data:dataSets[1]['Data']
			        },
			        {
			            label: dataSets[2]['Name'],
			            fill:true,
			            backgroundColor: 'red',
			            data: dataSets[2]['Data']
			        },
			        {
			            label: dataSets[3]['Name'],
			            fill:true,
			            fillColor: '#7BC225',
			            data: dataSets[3]['Data']
			        }
			    ]
			};
		var barChartOption = {
				 responsive: true,
					datasetFill : true,
					pointDotRadius: 10,
					title:{
							display:true,
							text:'Student Report',
							fontcolor:'red',
							fontSize:20
			        },
					
					scales: {
						yAxes: [{
							//stacked: true,
							gridLines: {
								display: true,
								color: "rgba(0,255,0,0.3)"
							},
							scaleLabel: {
								display: true,
								labelString: 'Age'
							},
							ticks: {
								beginAtZero:true
							}
						}],
						xAxes: [{
							gridLines: {
								display: false
							},
							scaleLabel: {
								display: true,
								labelString: 'Student Name'
							},
							ticks: {
								
							}
						}],
						animation: {
							duration: 3000,
							easing: 'easeInQuint'
							}
					}
				 
		 };
		
		var BarChart = new Chart(studentBarChart, {
			type: 'bar',
			data: studentBarData,
			options: barChartOption
		});
		
		
		
		// pie chart start from here 
		
			var studentPieData = {
			datasets: [{
				label: 'Age',
		        data: dataSets[1]['Data'],
		        backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
		    },
		    {
				label: 'Class',
				labelColor : 'yellow',
		        data: dataSets[2]['Data'],
		        
		        hoverBackgroundColor:'white',
		        backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
		    },
		    {
				label: 'PocketMoney',
		        data: dataSets[3]['Data'],
		        
		        hoverBackgroundColor:'white',
		        backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
		    }],
		    labels:dataSets[0]['Data']
	};
	
	var studentPieOption = {
			title: {
		        display: true,
		        text: 'Student Report',
		        fontSize:20
		      },
		      showAllTooltips: true,
		      animateScale : true,
		      animateRotate: true,
		      duration: 3000
		      
		
			
	};
	
	//mixed chart
	var mixedData = {
			labels: dataSets[0]['Data'],
			datasets: [{
				label: dataSets[1]['Name'],
				type: "line",
				borderColor: "#3e95cd",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[1]['Data'],
			},
			{
				label: dataSets[2]['Name'],
				type: "line",
				fill: true,//false,
				borderColor: "#8e5ea2",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[2]['Data'],
			},
			{
				label: dataSets[3]['Name'],
				type: "line",
				fill: true,//false,
				borderColor: "#3cba9f",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: dataSets[3]['Data'],
			},{
				label: dataSets[1]['Name'],
				type: "bar",
				fill:true,
	            backgroundColor: "yellow",
				data: dataSets[1]['Data'],
			},
			{
				label: dataSets[2]['Name'],
				type: "bar",
				fill:true,
	            backgroundColor: "red",
				data: dataSets[2]['Data'],
			},
			{
				label: dataSets[3]['Name'],
				type: "bar",
				fill:true,
	            backgroundColor: "#7BC225",
				data: dataSets[3]['Data'],
			}]
			
	};

	var PieChart = new Chart(studentPieChart, {
		type: 'pie',
		data: studentPieData,
		options: studentPieOption
	});
	//added dataset into pie
	var studentPieData1 = studentPieData['datasets'].slice();
	
	$("#addPieDataSet").click(function(){
		count = studentPieData['datasets'].length;
		if(count < 3 && count >= 0)
		{
			studentPieData['datasets'].push(studentPieData1[count]);
			PieChart.update();
			
		}
		else
		{
			alert("No More Data Set To Add");
		}
		
	});
	
	//remover dataset into pie chart
	dataSetIndex = studentPieData['datasets'].length-1;	
	$("#removePieDataSet").click(function(){
		count = studentPieData['datasets'].length-1;
		if(count >= 0 && count <= dataSetIndex)
		{
			studentPieData['datasets'].splice(count);
			PieChart.update();
		}
		else
		{
			alert("NO More DataSet to Remove");	
		}
		
	});
	
	
	
	
		
	//	doughnut chart 
	var studentDoughnutData =new Array();
	var studentDoughnutData = studentPieData;	
	var doughnutChart = new Chart(studentDoughnutChart, {
		type: 'doughnut',
		data: studentDoughnutData,
		options: studentPieOption
	});	
		
	//add datasetin to doughnut 
	var studentDoughnutData1 = studentDoughnutData['datasets'].slice();
	$("#addDouughnutDataSet").click(function(){
		count = studentDoughnutData['datasets'].length;
		if(count < 3 && count >= 0)
		{
			studentDoughnutData['datasets'].push(studentDoughnutData1[count]);
			doughnutChart.update();
			
		}
		else
		{
			alert("No More Data Set To Add");
		}
		
	});
	//remover datast from doughnut
	dataSetIndex = studentDoughnutData['datasets'].length-1;
	$("#removeDouughnutDataSet").click(function(){
		count = studentDoughnutData['datasets'].length-1;
		if(count >= 0 && count <= dataSetIndex)
		{
			studentDoughnutData['datasets'].splice(count);
			doughnutChart.update();
		}
		else
		{
			alert("NO More DataSet to Remove");	
		}
	});
	
	
	
	
	
	
	
	// polar chart
	var polarChart = new Chart(studentPolarChart,{
		type: 'polarArea',
		data: studentPieData,
		options: studentPieOption
	});	
		
	
	var radarChart = new Chart(studentRadarChart,{
		type: 'radar',
		data: studentBarData,
		options: studentPieOption
	});	
		
	//mixed chart
	
	var mixedChart = new Chart(studentMixedChart,{
		type: 'bar',
		data: mixedData,
		options: barChartOption
	});	
		
		
		
		
		
		
		
</script>
</html>