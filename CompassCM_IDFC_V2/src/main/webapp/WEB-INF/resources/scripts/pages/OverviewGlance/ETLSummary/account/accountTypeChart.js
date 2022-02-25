
accountTypeChart = new Chart(accountTypeChartCanvas, {
	type: 'pie',
	data: {
		labels: ["ODA", "LAA", "SBA", "TDA", "CAA"],
		datasets: [{
			label: "Account",
			backgroundColor: ["#8c2020", "#d8c409", "#126b3a", "#e8c3b9", "#c45850"],
			data: [accountTypeStatusColumnSum["ODA"],
			 		accountTypeStatusColumnSum["LAA"], accountTypeStatusColumnSum["SBA"],
					accountTypeStatusColumnSum["TDA"], accountTypeStatusColumnSum["CAA"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Account Type',
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

accountTypeChartCanvas.onclick = function(evt) {
	var activePoints = accountTypeChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var type = accountTypeChart['data']['labels'][activePoints[0]['_index']];
		let title = "Accounts from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having " + type + " Type";
		getETLSummaryReportData("ACCOUNTTYPE", type, title);
	}
};