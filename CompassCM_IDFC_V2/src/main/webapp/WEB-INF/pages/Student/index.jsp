<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
	<title>Student Report</title>
	
	<style>
		.gap { 
			margin-top:40px; 
		}
		
		.shadow{
			transition: box-shadow .3s;
 			border-radius:10px;
  			
 			 background: #fff;
 
				
		}
		.shadow:hover{
				box-shadow: 0 0 30px rgba(33,33,33,.2);
				 transform: translateX(-3px);
		}

		</style>
</head>

<body>

<!-- <div class="row">
	<div class="col-sm-3">
	<table class="table bordered" >
		<thead>
			<tr>
				<th>Student Name</th>
				<th>Student Age</th>
				<th>Student Class</th>
			</tr>
		</thead>
		<c:forEach items="${DATA}" var="student">

			<tr>
				<td>${student.NAME}</td>
				<td>${student['AGE']}</td>
				<td>${student['CLASS']}</td>
			</tr>


		</c:forEach>
	</table>
	</div>
</div> -->


<div class="row ">
		<div class="chart-container  col-sm-offset-1 col-sm-5 shadow "  >
			<canvas id="studentChart" ></canvas>
			<button class="btn" id="lineAdd"> Add Data Set</button>
			<button class="btn btn-danger" id="lineRemove"> Remove Dats Set</button>
		</div>
		<div class="chart-container col-sm-offset-1 col-sm-5  shadow"  >
			<canvas id="studentClass" ></canvas>
		</div>
</div>


<div class="row gap">
		<div class="chart-container col-sm-offset-1 col-sm-5 shadow " >
			<canvas id="studentBarChart" ></canvas>
		</div>
		
		<div class="chart-container col-sm-offset-1 col-sm-5 shadow " >
			<canvas id="studentPieChart" ></canvas>
		</div>
</div>


<div class="row gap">
		<div class="chart-container col-sm-offset-1 col-sm-5 shadow " >
			<canvas id="studentPolarChart" ></canvas>
		</div>
		<div class="chart-container col-sm-offset-1 col-sm-5 shadow " >
			<canvas id="studentScatterChart" ></canvas>
		</div>
</div>





<script>
var studentName = new Array();
var studentAge = new Array();
var studentClass = new Array();
var pieColor = new Array();
var scatterData = new Array();
<c:forEach items="${DATA}" var="student">
	
   studentName.push('${student.NAME}');
   studentAge.push('${student.AGE}');
   studentClass.push('${student.CLASS}');
   //scatterData.push('{x : ${student.AGE},y:${student.CLASS}}');

</c:forEach>

	
	var studentChart = document.getElementById("studentChart").getContext("2d");
//speedChartPie
	var studentClassChart = document.getElementById("studentClass");//
	var studentBarChart = document.getElementById("studentBarChart");
	var studentPieChart = document.getElementById("studentPieChart");
	var studentPolarChart = document.getElementById("studentPolarChart");
	var studentScatterChart = document.getElementById("studentScatterChart");
	
	
	
	
	
//first line chart for age
	var studentData = {
		labels: studentName,
		datasets: [{
			label: "Age",
			fill: true,//false
			backgroundColor: "yellow",
			borderColor: "rgba(255,99,132,1)",
			borderWidth: 2,
			lineTension: 0.4,
			borderCapStyle: 'butt',
			data: studentAge,
		}]
	};

	var chartOptions = {
		responsive: true,
		datasetFill : true,
		pointDotRadius: 20,
		title:{
				display:true,
				text:'Student Age Graphs',
				fontcolor:'blue',
				fontSize:20
        },
		
		scales: {
			yAxes: [{
				//stacked: true,
				gridLines: {
					display: true,
					color: "rgba(255,99,132,0.2)"
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
				animation: true,
				duration: 10000,
				animationSteps : 50,
				easing: 'easeOutBounce'
				}
		}
	};
	 
	var lineChart = new Chart(studentChart, {
		type: 'line',
		data: studentData,
		options: chartOptions
	});
	
	
// second line chart for  class graph
	
	
	var studentClassData = {
			labels: studentName,
			datasets: [{
				label: "Class",
				fill: false,
				backgroundColor: "yellow",
				borderColor: "rgba(255,99,132,1)",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: studentClass,
			}]
		};

	
	var studentClassOption={
			responsive: true,
			title:{
					display:true,
					text:'Student Class Graphs',
					fontcolor:'blue',
					fontSize:20
	        },
			
			scales: {
				yAxes: [{
					stacked: true,
					gridLines: {
						display: true,
						color: "rgba(255,99,132,0.2)"
					},
					scaleLabel: {
						display: true,
						labelString: 'Class'
					}
				}],
				xAxes: [{
					gridLines: {
						display: false
					},
					scaleLabel: {
						display: true,
						labelString: 'Student Name'
					}
				}],
				animation: {
					duration: 1000,
					easing: 'easeOutQuart'
					
		            }
			}
		};
		
	
	var lineChart = new Chart(studentClassChart, {
		type: 'line',
		data: studentClassData,
		options: studentClassOption
	});
	
	
	
	// third bar chart for age
	var studentBarData = {
			labels: studentName,
			datasets: [{
				label: "Age",
				fill: true,//false
				
				backgroundColor: "cyan",
				borderColor: "rgba(255,99,132,1)",
				borderWidth: 2,
				lineTension: 0.4,
				borderCapStyle: 'butt',
				data: studentAge,
			}]	
	};
	 var studentBarOption = {
			 responsive: true,
				datasetFill : true,
				pointDotRadius: 10,
				title:{
						display:true,
						text:'Student Age Graphs(Bar)',
						fontcolor:'red',
						fontSize:20
		        },
				
				scales: {
					yAxes: [{
						//stacked: true,
						gridLines: {
							display: true,
							color: "rgba(255,99,132,0.2)"
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
						animation: true,
						duration: 10000,
						animationSteps : 50,
						easing: 'easeOutBounce'
						}
				}
			 
	 };
	
	
	 var BarChart = new Chart(studentBarChart, {
			type: 'bar',
			data: studentBarData,
			options: studentBarOption
		});
		
	
	
	//Pie chart for Age
	
	
	var studentPieData = {
			datasets: [{
				label: 'Age',
		        data: studentAge,
		        backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001f3f", "#39CCCC", "#01FF70", "#85144b", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
		    }],
		    backgroundColor:pieColor,
		    labels:studentName
	};
	
	var studentPieOption = {
			title: {
		        display: true,
		        text: 'Student Age Chart(Pie)',
		        fontSize:20
		      },
		animateScale : true
			
	};
	
	

	var PieChart = new Chart(studentPieChart, {
		type: 'pie',
		data: studentPieData,
		options: studentPieOption
	});
	
	
	//Polar  Chart
	
	studentPieOption['title']['text'] = "Student Age Chart(Polar)";
	
	var polarChart = new Chart(studentPolarChart,{
		type: 'polarArea',
		data: studentPieData,
		options: studentPieOption
	});
	
	
	
	// Scatter Chart for age
	var studentScatterData = {
			datasets:scatterData
	};
	
	var scatterChart = new Chart(studentScatterChart,{
		type: 'scatter',
		data: studentScatterData,
		options: {
	        scales: {
	            xAxes: [{
	                type: 'linear',
	                position: 'bottom'
	            }]
	        }
	    }
	});
	
	</script>
	
	
	
	

</body>
</html>