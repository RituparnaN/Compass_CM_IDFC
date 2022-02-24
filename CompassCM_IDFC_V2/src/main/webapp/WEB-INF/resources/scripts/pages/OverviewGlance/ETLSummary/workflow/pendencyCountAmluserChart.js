pendencyCountAmluserChart = new Chart(pendencyCountAmluserChartCanvas, {
	type: 'line',
	data: {
		labels: labelsAMLUSER,
		datasets: dataSetsAMLUSER
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'AMLUSER',
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

pendencyCountAmluserChartCanvas.onclick = function(evt) {
	var activePoints = pendencyCountAmluserChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let user =  pendencyCountAmluserChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let tray = pendencyCountAmluserChart['data']['labels'][activePoints[0]['_index']];
		let title = "Cases of "+user+" in "+tray+" Tray";
		//console.log(" user_tray = "+user+"_"+tray);
		getETLAlertData("AMLUSERSYSTEM", user+"_"+tray, title);
	}
};