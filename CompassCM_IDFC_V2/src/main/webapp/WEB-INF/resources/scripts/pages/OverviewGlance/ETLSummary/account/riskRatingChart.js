
accountRiskratingChart = new Chart(accountRiskratingCanvas, {
	type: 'pie',
	data: {
		labels: ["High", "Medium", "Low"],
		datasets: [{
			label: "Account",
			backgroundColor: ["#8c2020", "#d8c409", "#126b3a", "#e8c3b9", "#c45850"],
			data: [columnSum["ACCOUNT_HIGHRISK"], columnSum["ACCOUNT_MEDIUMRISK"], columnSum["ACCOUNT_LOWRISK"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Account Risk',
			fontFamily: "Helvetica"
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
				}/*,
				afterLabel: function(tooltipItem, data) {
					
				}*/
			},
		}
	}
});

accountRiskratingCanvas.onclick = function(evt) {
	var activePoints = accountRiskratingChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var risk = accountRiskratingChart['data']['labels'][activePoints[0]['_index']];
		let title = "Accounts from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having " + risk + " Risk";
		getETLSummaryReportData("ACCOUNTRISKRATING", risk, title);
	}
};