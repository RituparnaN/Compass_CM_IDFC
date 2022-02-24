/* 03112020 - CONSULT WITH ME BEFORE EDITING*/
alertChart = new Chart(alertChartCanvas, {
	type: "treemap",
	data: {
		datasets: [
			{
				label: "Alert Data",
				tree: alertFilteredData,
				key: "value",
				groups: ['title'],
				fontColor: 'transparent',
				backgroundColor: function(ctx) {
					workflowContextUpdated = ctx;
					var dataValue = ctx.dataset.data[ctx.dataIndex];
					if(dataValue !== undefined){
						//console.log(" = "+dataValue.v);
						return colorFromValue(dataValue.v);
					}
				},
				borderColor: function(ctx) {
					var dataValue = ctx.dataset.data[ctx.dataIndex];
					if(dataValue !== undefined){
						//console.log(dataValue.v);
						return colorFromValue(dataValue.v, true)
					}
				},
				//spacing: 0.1,
				spacing: 0.2,
				borderWidth: 2,
				borderColor: "rgba(180,180,180, 0.15)"
			}
		]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: "Alert Details",
			fontFamily: "Helvetica"
		},
		legend: {
			display: false
		},
		tooltips: {
			callbacks: {
				title: function(item, data) {
					//console.log(data.datasets[0].data[item[0].index].g);
					return data.datasets[0].data[item[0].index].g;
				},
				label: function(item, data) {
					var dataset = data.datasets[item.datasetIndex];
					var dataItem = dataset.data[item.index];
					return dataItem.v.toLocaleString("en-US");
				}
			}
		}
	}
});

var alertContextUpdated;

function colorFromValue(value, border) {
	var alpha = (Math.log(value)) / 10;
	//console.log(alpha);
	//var color = "#0000ff";
	var color = "#337ab7";
	if (border) {
		alpha += 0.1;
	}
	return Chart.helpers.color(color)
		.alpha(alpha)
		.rgbString();
}

alertChartCanvas.onclick = function(evt) {
	var activePoints = alertChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		//console.log(" = "+workflowChart['data'].datasets[0].data[activePoints[0]['_index']].g);
		var type = alertChart['data'].datasets[0].data[activePoints[0]['_index']].g;
		let title = "Alert Details from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having " + type +" Type";
		getETLAlertData("ALERTSYSTEM", type, title);
	}
};