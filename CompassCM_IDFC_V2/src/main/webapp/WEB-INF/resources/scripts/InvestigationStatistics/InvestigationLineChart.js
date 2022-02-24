/**
 * all operation for line chart
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
	    text = "<table class = ' no_border'  >";
	    var k=0;
	    var remainsItem = chart.data.datasets.length%6;
	    var rows = chart.data.datasets.length%6 == 0?chart.data.datasets.length/6:parseInt(chart.data.datasets.length/6+1);
	    console.log("data set length = "+chart.data.datasets.length%6+ "rows = "+parseInt(chart.data.datasets.length/6+1) + "rows="+rows);
	    for (var i=0; i<rows; i++) {
		    text += '<tr>';
		    for(var j=0;j<legendsColumn;j++)
		    {
		    	if(remainsItem != 0 && (j == remainsItem) && i == rows-1)
		    	{console.log("here stop "+remainsItem + "  j = "+j+ " i= "+i);
		    		break;}
		          text += '<td class="chart-legend-label-text " id="lineChartTd_'+chart.legend.legendItems[k].datasetIndex+'" onclick="updateLineChartLegend(event, ' + '\'' + chart.legend.legendItems[k].datasetIndex + '\'' + ')">';
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



//for line chart
	var lineChart = new Chart(dummyLineChart, {
		  type: 'line',
		  data: lineChartData,
		  options:chartOption 	  
	});
	
	var lineLegendContainer = document.getElementById("lineChartLegends");
	 lineLegendContainer.innerHTML = lineChart.generateLegend();
	 updateLineChartLegend = function(e, datasetIndex) {
			var index = datasetIndex;
		    var ci = this.lineChart;
		    var meta = ci.getDatasetMeta(index);
			meta.hidden = meta.hidden === null? !ci.data.datasets[index].hidden : null;
			$("#lineChartTd_"+datasetIndex).toggleClass('stroked')
			
			ci.update();
		};
		
		
//individual adding/removing data to/from linechart
$(".lineChartCheckBox").click(function(){
var insertionPopsition;
var userName =  $(this).val();
	if($(this).is(':checked') === false){
		removeDataSetsOfLineChart(userName);
	}
	else{
		addDataSetsOfLineChart(userName);
	}
});


//for toggle data of line chart
$("#lineChartDataToggle").click(function(){
	$("#lineChartData").find("input:checkbox").each(function (i, item) { 
		var userName = $(item).val();
		if($(item).prop("checked") == true){
			$(item).prop("checked",false);
			removeDataSetsOfLineChart(userName)
		}
        else if($(item).prop("checked") == false){
        	$(item).prop("checked",true);
      	   addDataSetsOfLineChart(userName)
        }
	});
});

//for adding data sets in line chart
removeDataSetsOfLineChart = function( userName){
	var removingPosition = user.indexOf(userName);
	lineChartData['labels'].splice(removingPosition, 1);
	$.each(lineChartData['datasets'], function (index, value) {
		lineChartData['datasets'][index]['data'].splice(removingPosition,1);
	})
    amlUser[userName] = false;
	user.splice(removingPosition,1);
	lineChart.update();
}
//for removing data set of line chart		 
addDataSetsOfLineChart = function(userName){
	var count = 0;
	var i,key;
	var checkedItemPosition = Object.keys(amlUser).indexOf(userName);
	for( i = checkedItemPosition-1;i >= 0; i--)
	{
		key = Object.keys(amlUser)[i];
		if(amlUser[key])
		{
			key = Object.keys(amlUser)[i];
			break;
		}
	}
	var addPosition = user.indexOf(key)+1;
	//alert("position = "+addPosition);
	lineChartData['labels'].splice(addPosition,0,mainLabel[checkedItemPosition]);
	$.each(lineChartData['datasets'], function (index, value) {
		lineChartData['datasets'][index]['data'].splice(addPosition,0,mainChartData['datasets'][index]['data'][checkedItemPosition]);
	})
	amlUser[userName] = true;
	user.splice(addPosition,0,userName);
	lineChart.update();
};

//function for toggle all legnds of line chart
$("#lineChartLegendToggle").click(function(){
	var i=0;
	console.log(chartData.length);
	for(i=0;i<chartData.length;i++){
		updateLineChartLegend("event",i);
	}
});
		 
		 
		
	