

customerRiskratingChart = new Chart(customerRiskratingCanvas, {
	type: 'pie',
	data: {
		labels: ["High", "Medium", "Low"],
		datasets: [{
			backgroundColor: ["#8c2020", "#d8c409", "#126b3a", "#e8c3b9", "#c45850"],
			data: [columnSum["CUSTOMER_HIGHRISK"], columnSum["CUSTOMER_MEDIUMRISK"], columnSum["CUSTOMER_LOWRISK"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Customer Risk',
			fontFamily: "Helvetica"
		},
		tooltips: {
			callbacks: {
				title: function(tooltipItem, data) {
					return data['labels'][tooltipItem[0]['index']];
				},
				label: function(tooltipItem, data) {
					let sliceCount = data['datasets'][0]['data'][tooltipItem['index']];
					let perCesntage = (sliceCount*100)/columnSum['TOTALCUSTOMERCOUNT'];
					return sliceCount.toLocaleString("en-US") +" ( "+perCesntage.toFixed(2)+" % )";
				}
			},
		}
	}
});

customerRiskratingCanvas.onclick = function(evt) {
	var activePoints = customerRiskratingChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var risk = customerRiskratingChart['data']['labels'][activePoints[0]['_index']];
		let title = "Customers from "+convertDateToString(minDate)+" to "+convertDateToString(maxDate)+" having "+risk+" Risk" ;
		getETLSummaryReportData("CUSTOMERRISKRATING", risk,title);
	}
};