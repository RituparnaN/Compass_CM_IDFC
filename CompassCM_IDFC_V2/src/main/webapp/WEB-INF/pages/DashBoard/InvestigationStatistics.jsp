<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<html>
<head>

<style>
shadow{
	border-radius:10px;
 	background: #fff;
}
.shadow:hover{
	box-shadow: 0 0 100px rgba(33,33,33,.2);
	transform: translateX(-3px);
	transition:  1000ms linear;				
}
canvas{
	 height:400px !important;
	-moz-user-select: none;
	-webkit-user-select: none;
	-ms-user-select: none;
}
.checkToggleButton {
	display: inline-block;
	padding: 5px 5px;
	cursor: pointer;
	text-align: center;
	outline: none;
	color: #fff;
	background-color: #4CAF50;
	border: none;
	border-radius: 15px;
	box-shadow: 0 9px #999;
	border-radius: 50%;
}

.checkToggleButton:hover {
	background-color: #3e8e41
}

.checkToggleButton:active {
  background-color: #3e8e41;
  box-shadow: 0 0 #666;
  transform: translateY(4px);
}


.no_border{
	width:100%;
	margin-left:25px;
	margin-bottom:15px;
}
.no_border th,.no_border td{
	 cursor: pointer;
	cellpadding:0px;
	 		
}
.dot{
	height: 10px;
	width: 10px;
	border-radius: 50%;
	display:inline-block;
	margin-right:5px;
}
.stroked{
	text-decoration: line-through; 
 }
		
		

</style>
		
<script>
$("#openModalInTab").click(function(){
	var moduleCode = '${moduleCode}';
	var moduleHeader = '${moduleHeader}';
	var moduleValue = '${moduleValue}';
	var detailPage ='${detailPage}';
	if(moduleValue != undefined)
		openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
});

$("#openModalInWindow").click(function(){
	var moduleCode = '${moduleCode}';
	var moduleHeader = '${moduleHeader}';
	var moduleValue = '${moduleValue}';
	var detailPage ='${detailPage}';
	if(moduleValue != undefined)
		openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
});
		var amlUser = {};
		var amlUserForBarChart = {};
</script>
</head>
<body>
	<!-- Line and bar graphs div start -->
	<div class="col-sm-12" style="padding:3px;">
		<ul class="nav nav-pills" >
			<li class="active"><a data-toggle="pill" href="#line-chart-div" class="nav-link fa fa-line-chart" style="font-size:16px"> Line Chart</a></li>
 			<li><a data-toggle="pill" href="#bar-chart-div"  class="nav-link fa fa-bar-chart" style="font-size:16px"> Bar Chart</a></li>
		</ul>
		<div class="tab-content">
			<div id="line-chart-div" class="tab-pane fade in active ">
				<div class="chart-container shadow col-sm-10" >
					<div class="col-sm-1" align = "right" style=" margin-top:10px;">
						<button class="checkToggleButton" id="lineChartLegendToggle">T</button>
					</div>
					<div id="lineChartLegends" class="col-sm-11 ChartLegends"></div>
					<canvas id="LineChartCanvas"></canvas>
				</div>
				<div class="col-sm-2 x-axis text-center">
					<p><b>AML USERS</b> &nbsp;<button class="checkToggleButton" id="lineChartDataToggle">T</button></p>
					<div class="checkbox " id="lineChartData" >
						<c:forEach items="${DATA}"  varStatus="status" >
							<script>
								amlUser["${DATA[status.index]['AMLUSERCODE']}"] = true;
							</script>
							<label style="margin-top:25px;"><input type="checkbox" class="lineChartCheckBox" value="${DATA[status.index]['AMLUSERCODE']}" rel="lineChart"   checked="checked" />${DATA[status.index]['AMLUSERCODE']}</label><br>
						</c:forEach>
					</div>
				</div>
			</div>
			
			<div id="bar-chart-div" class="tab-pane fade  ">
				
				<div class="chart-container shadow col-sm-10">
					<div class="col-sm-1" align = "right" style=" margin-top:10px;">
						<button class="checkToggleButton" id="barChartLegendToggle">T</button>
					</div>
					<div id="barChartLegends" class="col-sm-11"></div>
					<canvas id="BarChartCanvas" ></canvas>
				</div>
				<div class="col-sm-2 x-axis text-center" id="barChartData">
					<p><b>AML USERS</b>&nbsp;<button class="checkToggleButton" id="barChartDataToggle">T</button></p>
					<div class="checkbox " id="barChartData">
						<c:forEach items="${DATA}"  varStatus="status" >
							<script>
								amlUserForBarChart["${DATA[status.index]['AMLUSERCODE']}"] = true;
							</script>
							<label style="margin-top:25px;"><input type="checkbox" class="barChartCheckBox" value="${DATA[status.index]['AMLUSERCODE']}" rel="barChart" checked="checked"/>${DATA[status.index]['AMLUSERCODE']}</label><br>
						</c:forEach>
					</div>
				</div>
				
				
			</div>
			

		</div>
	</div>
</body>
<script>

// chart using 
	var i;

//for getting AMLUSERs
	var user = new Array();
	var dataSets = new Array();
	var count =0 ;	
	var xAxisName = "Aml Users";
	var yAxisName  = "No Of Cases";
	
	//var user = jQuery.extend(true, {}, amlUser);
	var user = [];
	var userBarChart = [];
	for(var key in amlUser)
	{
		user.push(key);
		userBarChart.push(key);
		
	}
//var color = 	["#E03E3E", "#FB6F3D", "#F0A202","#000099", "#ADEA38", "#0080ff", "#4B0082", "#232531"," #25e64e", "#bde625", "#e64e25", "#e6ae25", "#e62e25", "#25e6ae", "#253ce6", "#e6cf25", "#ae25e6", "#e62e25", "#bde625", "#25e64e", "#dde625", "#4e25e6", "#ae25e6"];
var color = 	["#F3640", "#C0812B", "#2E3386","#78943C", "#4077BC", "#4C2D7D", "#3D3F42", "#2E3386"," #BDD632", "#2CA7DF", "#FFC544", "#E62E28", "#00B2BF", "#841619", "#9A3B96", "#e6cf25", "#ae25e6", "#e62e25", "#bde625", "#25e64e", "#dde625", "#4e25e6", "#ae25e6"];
	
/* Chart.defaults.global.legend.labels.usePointStyle = true; */
/* for creating data set like 
	
	data[0]['NAME']  =  AMLUSERCODE
	data[0]['data'] = ["USER 3", "USER 4", "USER 1", "USER 2", "USER 5", "USER 6", "USER 7"]
	and so on.....
	
*/
	<c:forEach items="${COLUMNNAME}" var="sets" varStatus="status1" >
		<c:set var="setName" value="${sets}" />
		dataSets[count] = new Array();
		dataSets[count]['NAME'] = '${sets}';
		dataSets[count]['Data'] = new Array();
			<c:forEach items="${DATA}"  varStatus="status" >
				dataSets[count]['Data'].push('${DATA[status.index][setName]}');
			</c:forEach>
		
		count++;
	</c:forEach>
	
	//console.log(dataSets);
	
	//for adding data into chart
	
	var dummyLineChart = document.getElementById("LineChartCanvas").getContext("2d");
	var dummyBarChart = document.getElementById("BarChartCanvas").getContext("2d"); 
	var chartData = new Array();
	
	for(var i = 0;i<dataSets.length; i++)
	{
		var obj = {};
		if(dataSets[i]['NAME'] == "AMLUSERCODE")
		{
			var mainLabel = dataSets[i]['Data'];
		}
		else
		{
			obj.data = dataSets[i]['Data'];
			obj.label = dataSets[i]['NAME'] ;
			obj.lineTension=  0.4;
			obj.borderColor = color[i];//getRandomColor();
			obj.backgroundColor = color[i];
			obj.fill = false;
			chartData.push(obj);
		}
	}
	
	/*
			purpose of above loop ... 
			creating a array of object , need like :-  
			chartData = [
			             {
			            	 data: ["10", "15", "5", "6", "8", "10", "18"]
			                 label: "DAY",
			                 borderColor: "#3e95cd",
			                 fill: false
			             },
			            ]
	*/
	
	var mainChartData = {};
	mainChartData['labels'] = mainLabel;
	mainChartData['datasets'] = chartData;
	
	var lineChartData = {};
	lineChartData = jQuery.extend(true, {}, mainChartData)
	
	var barChartData = {};
	barChartData = jQuery.extend(true, {}, mainChartData)
	
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/InvestigationStatistics/InvestigationLineChart.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/InvestigationStatistics/InvestigationBarChart.js"></script>
</html>