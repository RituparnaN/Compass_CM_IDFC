txnBillRemiContChart = new Chart(txnBillRemiContCanvas, {
	type: 'bar',
	data: {
		labels: ["OUTWARDCOUNT", "INWARDCOUNT"],
		datasets: [{
			label: "Remittance",
			//borderColor: "#ffc90a",
			backgroundColor: '#d4d4d4',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["REMITTANCE_TOTALOUTWARDCOUNT"], columnSum["REMITTANCE_TOTALINWARDCOUNT"]]
		},
		{
			label: "Bill",
			//borderColor: "blue",
			backgroundColor: '#d8c409',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["BILL_TOTALOUTWARDCOUNT"], columnSum["BILL_TOTALINWARDCOUNT"]]
		},
		{
			label: "Transaction",
			//borderColor: "green",
			backgroundColor: '#8c2020',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["TRANSACTION_TOTALOUTWARDCOUNT"], columnSum["TRANSACTION_TOTALINWARDCOUNT"]]
		}
	]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Transaction Count',
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
					labelString: "No Of Customer"
				},
				ticks: {
					min: 0,
					callback: function(value, index, values) {
						//return value.toLocaleString("en-US");
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

txnBillRemiContCanvas.onclick = function(evt) {
	var activePoints = txnBillRemiContChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var reportType = txnBillRemiContChart['data']['labels'][activePoints[0]['_index']];
		let reportValue =  txnBillRemiContChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let title = "Transactions count from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having "+reportValue+" "+reportType  ;
		//console.log(reportType+"---"+reportValue);
		getETLSummaryReportData(reportType, reportValue, title);
	}
};