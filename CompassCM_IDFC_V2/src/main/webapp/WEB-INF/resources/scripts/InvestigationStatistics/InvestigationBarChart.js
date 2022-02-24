/**
 * all operation for bar chart
 */
var legendsColumn = 6;
var chartOption = {
	responsive: true,
	maintainAspectRatio: false,
	datasetFill : true,
	pointDotRadius: 10,
	/* title:{
			display:true,
			text:'statistic',
			fontcolor:'red',
			fontSize:20
		}, */
	legend: {
	     position: "top",
	     display:false,
	     labels: {
	          padding: 15,
	          usePointStyle: true
	     } 
	}, 
	legendCallback: function(chart) {
	    var text;
	    text = "<table class = ' no_border' >";
	    var k=0;
	    var remainsItem = chart.data.datasets.length%6;
	    var rows = chart.data.datasets.length%6 == 0?chart.data.datasets.length/6:parseInt(chart.data.datasets.length/6+1);
	    for (var i=0; i<rows; i++) {
		    text += '<tr>';
		    for(var j=0;j<legendsColumn;j++)
		    {
		    	if(remainsItem != 0 && (j == remainsItem) && i == rows-1)
		    	{break;}
		          text += '<td class="chart-legend-label-text " id="barChartTd_'+chart.legend.legendItems[k].datasetIndex+'" onclick="updateBarChartLegend(event, ' + '\'' + chart.legend.legendItems[k].datasetIndex + '\'' + ')">';
		          text += " <span class='dot' style='background-color:"+ chart.data.datasets[k].borderColor +";'></span>"; if(chart.data.datasets[k].label == 'STRS' ){text += 'STRs'; }else{text += chart.data.datasets[k].label } +"</td>" ;
		          k++;
		    }
		   text += '</tr>';
	               
	   }
	   text += '</table>';
	   return text;
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
				labelString: yAxisName,
				fontcolor:'red',
			},
			ticks: {
				beginAtZero:true
			}
		}],
		xAxes: [{
			gridLines: {
				display: true
			},
			scaleLabel: {
				display: true,
				labelString: xAxisName
			},
			ticks: {
						
			}
		}],
		animation: {
			duration: 30000,
			easing: 'easeInQuint'
		}
	}
};





//for bar chart

var barChart = new Chart(dummyBarChart,{
	type:'bar',
	data: barChartData,
	options: chartOption
});

var barLegendContainer = document.getElementById("barChartLegends");
barLegendContainer.innerHTML = barChart.generateLegend();
updateBarChartLegend = function(e, datasetIndex) {
		var index = datasetIndex;
	    var ci = this.barChart;
	    var meta = ci.getDatasetMeta(index);
		meta.hidden = meta.hidden === null? !ci.data.datasets[index].hidden : null;
		$("#barChartTd_"+datasetIndex).toggleClass('stroked')
		
		ci.update();
	};

//individual adding/removing data to/from bar chart
$(".barChartCheckBox").click(function(){
	var userName =  $(this).val();
	if($(this).is(':checked') === false)
	{
		removeDataSetsOfBarChart(userName);
	}
	else
	{
		addDataSetsOfBarChart(userName);
	} 
});

//for toggle data of bar chart
$("#barChartDataToggle").click(function(){
	$("#barChartData").find("input:checkbox").each(function (i, item) { 
		var userName = $(item).val();
		if($(item).prop("checked") == true){
			$(item).prop("checked",false);
			removeDataSetsOfBarChart(userName)
		}
       else if($(item).prop("checked") == false){
       	//$(".barChartCheckBox").click();
    	   $(item).prop("checked",true);
    	   addDataSetsOfBarChart(userName)  
       }
		
	});
});

//function for removing data 
removeDataSetsOfBarChart = function(userName){
	var removingPosition = userBarChart.indexOf(userName);
	/* console.log("Need to remove = "+userName+ " from position= "+removingPosition); */
	barChartData['labels'].splice(removingPosition, 1);
	$.each(barChartData['datasets'], function (index, value) {
		barChartData['datasets'][index]['data'].splice(removingPosition,1);
	})
	amlUserForBarChart[userName] = false;
	userBarChart.splice(removingPosition,1);
	barChart.update();
};

//function for adding data 
addDataSetsOfBarChart = function(userName){
	var count = 0;
	var i,key;
	var checkedItemPosition = Object.keys(amlUserForBarChart).indexOf(userName);
	for( i = checkedItemPosition-1;i >= 0; i--)
	{
		key = Object.keys(amlUserForBarChart)[i];
		if(amlUserForBarChart[key])
		{
			key = Object.keys(amlUserForBarChart)[i];
			break;
		}
	}
	var addPosition = userBarChart.indexOf(key)+1;
	//alert("position = "+addPosition);
	barChartData['labels'].splice(addPosition,0,mainLabel[checkedItemPosition]);
	$.each(barChartData['datasets'], function (index, value) {
		barChartData['datasets'][index]['data'].splice(addPosition,0,mainChartData['datasets'][index]['data'][checkedItemPosition]);
	})
	amlUserForBarChart[userName] = true;
	userBarChart.splice(addPosition,0,userName);
	barChart.update();
};

//function for toggle all legnds of line chart
$("#barChartLegendToggle").click(function(){
	var i=0;
	console.log(chartData.length);
	for(i=0;i<chartData.length;i++){
		updateBarChartLegend("event",i);
	}
});




