
customerSourceSysteChart = new Chart(customerSourceSystemCanvas, {
	type: 'bar',
	data: {
		labels: ["MDM", "NOVOPAY", "FINNONE", "PRIME", "FPL"],
		datasets: [{
			label: "Customer",
			barPercentage: 0.4,
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			//barThickness: 3,
			//borderColor: "#ffc90a",
			//hoverBorderColor: "black",
			//borderWidth: 2,
			data: [columnSum["CUSTOMER_MDM"], columnSum["CUSTOMER_NOVOPAY"],
			columnSum["CUSTOMER_FINNONE"], columnSum["CUSTOMER_PRIME"], columnSum["CUSTOMER_FPL"]]
		}]
	},
	options: {
		datasetFill: false,
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Customer Source System',
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
					labelString: "No of Customers",
					lineHeight: 0.5
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
					let perCesntage = (sliceCount * 100) / columnSum['TOTALCUSTOMERCOUNT'];
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


customerSourceSystemCanvas.onclick = function(evt) {
	var activePoints = customerSourceSysteChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		var sourceSystemName = activePoints[0]['_view']['label'];
		let title = "Customers from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) + " having "+sourceSystemName+" Source System";

		getETLSummaryReportData("CUSTOMERSOURCESYSTEM", sourceSystemName, title);
	}
};