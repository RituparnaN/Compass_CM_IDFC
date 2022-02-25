pendencyCountUserChart = new Chart(pendencyCountUserChartCanvas, {
	type: 'line',
	data: {
		labels: labelsUSER,
		datasets: dataSetsUSER
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'USER',
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

pendencyCountUserChartCanvas.onclick = function(evt) {
	var activePoints = pendencyCountUserChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let user =  pendencyCountUserChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let tray = pendencyCountUserChart['data']['labels'][activePoints[0]['_index']];
		let title = "Cases of "+user+" in "+tray+" Tray";
		//console.log(" user_tray = "+user+"_"+tray);
		getETLAlertData("USERSYSTEM", user+"_"+tray, title);
	}
};