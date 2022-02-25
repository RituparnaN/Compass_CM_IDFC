txnBillRemiAmountChart = new Chart(txnBillRemiAmountCanvas, {
	type: 'bar',
	data: {
		labels: ["OUTWARDAMOUNT ", "INWARDAMOUNT"],
		datasets: [{
			label: "Remittance",
			//borderColor: "#ffc90a",
			backgroundColor: '#d4d4d4',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["REMITTANCE_TOTALOUTWARDAMOUNT"], columnSum["REMITTANCE_TOTALINWARDAMOUNT"]]
		},
		{
			label: "Bill",
			//borderColor: "blue",
			backgroundColor: '#d8c409',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["BILL_TOTALOUTWARDAMOUNT"], columnSum["BILL_TOTALINWARDAMOUNT"]]
		},
		{
			label: "Transaction",
			//borderColor: "green",
			backgroundColor: '#8c2020',
			borderWidth: 2,
			barPercentage: 0.4,
			data: [columnSum["TRANSACTION_TOTALOUTWARDAMOUNT"], columnSum["TRANSACTION_TOTALINWARDAMOUNT"]]
		}
		]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Transaction Amount',
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
					labelString: "Number"
				},
				ticks: {
					min: 0,
					callback: function(value, index, values) {
						/*var number = parseInt(value);
						if (number >= 1000000) {
							return "₹ "+(number/1000000).toLocaleString("en-US")+" M";
						} else if (number >= 1000) {
							return "₹ "+(number/1000).toLocaleString("en-US")+" K";
						} else {
							return "₹ "+number.toLocaleString("en-US");
						}*/
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
					chart.ticks.reverse().forEach(function(tick) {
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
					return data['datasets'][tooltipItem.datasetIndex].label +": " + 
					data['datasets'][tooltipItem.datasetIndex]['data'][tooltipItem['index']].toLocaleString("en-US");
				}
			},
		},
		animation: {
			duration: 1000,
			easing: 'easeInQuint'
		}
	}
});

txnBillRemiAmountCanvas.onclick = function(evt) {
	var activePoints = txnBillRemiAmountChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var reportType = txnBillRemiAmountChart['data']['labels'][activePoints[0]['_index']];
		let reportValue = txnBillRemiAmountChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		if (reportType.includes("OUTWARD")) {
			reportType = "OUTWARDCOUNT";
		}
		if (reportType.includes("INWARD")) {
			reportType = "INWARDCOUNT";
		}
		let title = "Transactions count from " + convertDateToString(minDate) + " to "
			+ convertDateToString(maxDate) + " having " + reportValue + " " + reportType;
		//console.log(reportType+"---"+reportValue);
		getETLSummaryReportData(reportType, reportValue, title);
	}
};


