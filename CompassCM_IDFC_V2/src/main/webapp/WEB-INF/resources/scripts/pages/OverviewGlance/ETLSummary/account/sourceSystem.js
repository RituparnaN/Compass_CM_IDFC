accountSourceSysteChart = new Chart(accountSourceSystemCanvas, {
	type: 'bar',
	data: {
		labels: ["CBS", "NOVOPAY", "FINNONE", "PRIME", "FPL"],
		datasets: [{
			label: "Account",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			barPercentage: 0.4,
			data: [columnSum["ACCOUNT_CBS"], columnSum["ACCOUNT_NOVOPAY"],
			columnSum["ACCOUNT_FINNONE"], columnSum["ACCOUNT_PRIME"], columnSum["ACCOUNT_FPL"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Account Source System',
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
					labelString: "No of Accounts"
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
					let sliceCount = data['datasets'][0]['data'][tooltipItem['index']];
					let perCesntage = (sliceCount * 100) / columnSum['TOTALACCOUNTNOCOUNT'];
					return sliceCount.toLocaleString("en-US") + " ( " + perCesntage.toFixed(2) + " % )";
				}
			},
		},
		animation: {
			duration: 1000,
			easing: 'easeInQuint'
		}
	}
});

accountSourceSystemCanvas.onclick = function(evt) {
	var activePoints = accountSourceSysteChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var sourceSystemName = activePoints[0]['_view']['label'];
		let title = "Accounts from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having "+sourceSystemName+" Source System";

		getETLSummaryReportData("ACCOUNTSOURCESYSTEM", sourceSystemName, title);
	}
};