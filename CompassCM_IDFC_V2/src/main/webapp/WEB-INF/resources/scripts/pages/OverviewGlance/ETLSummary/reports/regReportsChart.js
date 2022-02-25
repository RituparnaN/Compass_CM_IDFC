regReportsChart = new Chart(regReportsChartCanvas, {
	type: 'bar',
	data: {
		labels: ["NTR", "CTR", "CBWT", "STR"],
		datasets: [{
			label: "Reports",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			barPercentage: 0.2,
			data: [regReportsColumnSum["TOTALNTRCOUNT"], regReportsColumnSum["TOTALCTRCOUNT"],
			regReportsColumnSum["TOTALCBWTCOUNT"], regReportsColumnSum["TOTALSTRCOUNT"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Regulatory Reports',
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
					labelString: "No of Reports"
				},
				ticks: {
					min: 0,
					callback: function(value, index, values) {
						return customMetricAxisValue(value.toLocaleString("en-US"));
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

regReportsChartCanvas.onclick = function(evt) {
	var activePoints = regReportsChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let reportValue = activePoints[0]['_view']['label'];
		let title = "Regulatory Reports from " + convertDateToString(minDate) + " to " 
					+ convertDateToString(maxDate) + " having "+reportValue+" Report Type";
		getETLRegulatoryReportData("REGREPORTING", reportValue, title);
	}
};