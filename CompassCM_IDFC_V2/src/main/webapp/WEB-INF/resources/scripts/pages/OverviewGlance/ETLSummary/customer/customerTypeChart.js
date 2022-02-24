customerTypeChart = new Chart(customerTypeChartCanvas, {
	type: 'bar',
	data: {
		labels: ["BHARAT", "CONSUMER", "WHOLESALE", "BUSINESS", "NOTCLASSIFIED"],
		datasets: [{
			label: "INDIVIDUAL",
			//borderColor: "#ffc90a",
			backgroundColor: '#c45850',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [customerTypeColumnSum["BHARAT_INDIVIDUAL"], customerTypeColumnSum["CONSUMER_INDIVIDUAL"],
					customerTypeColumnSum["WHOLESALE_INDIVIDUAL"], customerTypeColumnSum["BUSINESS_INDIVIDUAL"],
					customerTypeColumnSum["NOTCLASSIFIED_INDIVIDUAL"]]
		},
		{
			label: "CORPORATE",
			//borderColor: "blue",
			backgroundColor: '#d8c409',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [customerTypeColumnSum["BHARAT_CORPORATE"], customerTypeColumnSum["CONSUMER_CORPORATE"],
					customerTypeColumnSum["WHOLESALE_CORPORATE"], customerTypeColumnSum["BUSINESS_CORPORATE"],
					customerTypeColumnSum["NOTCLASSIFIED_CORPORATE"]]
		}
	]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Customer Type',
			fontFamily: "Helvetica"
		},
		scales: {
			yAxes: [{
				stacked: true,
				type: 'logarithmic',
				gridLines: {
					display: true,
					//color: "rgba(0,255,0,0.3)"
					color: "#d4d4d4"
				},
				scaleLabel: {
					display: false,
					labelString: "No Of Customers"
				},
				ticks: {
					min: 0,
					callback: function(value, index, values) {
						return customMetricAxisValue(value);
					}
				},
				afterBuildTicks: function(chart) {
					var maxTicks = 15;
					var maxLog = Math.log(chart.ticks[0]);
					var minLogDensity = maxLog / maxTicks;

					var ticks = [];
					var currLog = -Infinity;
					chart.ticks.reverse().forEach( function(tick) {
						var log = Math.max(0, Math.log(tick));
						if (log - currLog > minLogDensity) {
							ticks.push(tick);
							currLog = log;
						}
					});
					chart.ticks = ticks;
				}
			}],
			xAxes: [{
				stacked: true,
				gridLines: {
					display: false
				}
				/*scaleLabel: {
					display: true,
					labelString: "Source Systems"
				},*/
				
			}],
			scaleShowGridLines: true
		},
		tooltips: {
			callbacks: {
				title: function(tooltipItem, data) {
					return data['labels'][tooltipItem[0]['index']];
				},
				label: function(tooltipItem, data) {
					return data['datasets'][tooltipItem.datasetIndex].label+
					": "+data['datasets'][tooltipItem.datasetIndex]['data'][tooltipItem['index']].toLocaleString("en-US");
				}
			},
		},
		animation: {
			duration: 1000,
			easing: 'easeInQuint'
		}
	}
});

customerTypeChartCanvas.onclick = function(evt) {
	var activePoints = customerTypeChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var reportType = customerTypeChart['data']['labels'][activePoints[0]['_index']];
		let reportValue =  customerTypeChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let title = "Customers from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having "+reportType+" "+reportValue+" Type" ;
		//console.log(reportType+"---"+reportValue);
		getETLSummaryReportData("CUSTOMERTYPE", reportType+"_"+reportValue, title);
	}
};