transactionSourceSystemChart = new Chart(transactionSourceSystemCanvas, {
	type: 'bar',
	data: {
		labels: ["CBS", "NOVOPAY", "FINNONE", "PRIME", "FPL"],
		datasets: [{
			label: "Transactions",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			barPercentage: 0.4,
			data: [columnSum["TRANSACTION_CBS"], columnSum["TRANSACTION_NOVOPAY"],
			columnSum["TRANSACTION_FINNONE"], columnSum["TRANSACTION_PRIME"], columnSum["TRANSACTION_FPL"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Transaction Source System',
			fontFamily: "Helvetica"
		},
		scales: {
			yAxes: [{
				type: 'logarithmic',
				gridLines: {
					display: true,
					//color: "rgba(0,255,0,0.3)"
					color: "#d4d4d4"
				},
				scaleLabel: {
					display: true,
					labelString: "No of Transactions"
				},
				ticks: {
					min: 0,
					callback: function(value, index, values) {
						return customMetricAxisValue(value);
					}
				}
			}],
			xAxes: [{
				gridLines: {
					display: true
				}

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
	}
});

transactionSourceSystemCanvas.onclick = function(evt) {
	var activePoints = transactionSourceSystemChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let sourceSystemName = activePoints[0]['_view']['label'];
		let title = "Transactions from " + convertDateToString(minDate) + " to " 
					+ convertDateToString(maxDate) + " having "+sourceSystemName+" Source System";
		getETLSummaryReportData("TRANSACTIONSOURCESYSTEM", sourceSystemName, title);
	}
};