userRoleChart = new Chart(userRoleChartCanvas, {
	type: 'bar',
	data: {
		labels: ["CLOSED_CASES", "RAISED_TO_BRANCHES", "NO_ACTION_TAKEN", "PENDING_USER", "PENDING_AMLUSER",
				 "PENDING_AMLO", "PENDING_MLRO", "PENDING_46_60", "PENDING_MORETHAN_60"],
		datasets: [{
			label: "Cases",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", 
								"#c45850", "#d8c409", "#80620f", "#126b3a", "#421009"],
			barPercentage: 0.2,
			data: [userRoleColumnSum["CLOSED_CASES"], userRoleColumnSum["RAISED_TO_BRANCHES"],
					userRoleColumnSum["NO_ACTION_TAKEN"],
					userRoleColumnSum["PENDING_USER"], userRoleColumnSum["PENDING_AMLUSER"],
					userRoleColumnSum["PENDING_AMLO"], userRoleColumnSum["PENDING_MLRO"],
					userRoleColumnSum["PENDING_46_60"], userRoleColumnSum["PENDING_T61"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Case Workflow Summary',
			fontFamily: "Helvetica"
		},
		scales: {
			yAxes: [{
				//type: 'logarithmic',
				gridLines: {
					display: true,
					//color: "rgba(0,255,0,0.3)"
					color: "#d4d4d4"
				},
				scaleLabel: {
					display: true,
					labelString: "No of Cases"
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
					return "Cases: "+data['datasets'][tooltipItem.datasetIndex]['data'][tooltipItem['index']].toLocaleString("en-US");
				}
			},
		}
	}
});

userRoleChartCanvas.onclick = function(evt) {
	var activePoints = userRoleChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let reportValue = activePoints[0]['_view']['label'];
		let title = "Cases from " + convertDateToString(minDate) + " to " 
					+ convertDateToString(maxDate) + " for "+reportValue;
		//console.log(reportValue);
		getETLAlertData("USERROLESYSTEM", reportValue, title);
	}
};