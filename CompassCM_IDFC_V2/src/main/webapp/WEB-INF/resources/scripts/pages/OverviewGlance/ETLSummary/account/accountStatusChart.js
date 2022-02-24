
accountStatusChart = new Chart(accountStatusChartCanvas, {
	type: 'pie',
	data: {
		labels: ["ACTIVE", "INACTIVE", "DORMANT", "CLOSED"],
		datasets: [{
			label: "Account",
			backgroundColor: ["#8c2020", "#d8c409", "#126b3a", "#e8c3b9", "#c45850"],
			data: [accountTypeStatusColumnSum["ACTIVE"], accountTypeStatusColumnSum["INACTIVE"], 
					accountTypeStatusColumnSum["DORMANT"], accountTypeStatusColumnSum["CLOSED"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Account Status',
			fontFamily: "Helvetica"
		},
		tooltips: {
			callbacks: {
				title: function(tooltipItem, data) {
					return data['labels'][tooltipItem[0]['index']];
				},
				label: function(tooltipItem, data) {
					let sliceCount = data['datasets'][0]['data'][tooltipItem['index']];
					let perCesntage = (sliceCount * 100) / accountTypeStatusColumnSum['TOTALACCOUNTCOUNT'];
					return sliceCount.toLocaleString("en-US") + " ( " + perCesntage.toFixed(2) + " % )";
				}/*,
				afterLabel: function(tooltipItem, data) {
					
				}*/
			},
		}
	}
});

accountStatusChartCanvas.onclick = function(evt) {
	var activePoints = accountStatusChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var status = accountStatusChart['data']['labels'][activePoints[0]['_index']];
		let title = "Accounts from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having " + status + " Status";
		getETLSummaryReportData("ACCOUNTSTATUS", status, title);
	}
};
