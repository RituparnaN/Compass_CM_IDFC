pendencyCountAmloChart = new Chart(pendencyCountAmloChartCanvas, {
	type: 'line',
	data: {
		labels: labelsAMLO,
		datasets: dataSetsAMLO
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'AMLO',
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

pendencyCountAmloChartCanvas.onclick = function(evt) {
	var activePoints = pendencyCountAmloChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let user =  pendencyCountAmloChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let tray = pendencyCountAmloChart['data']['labels'][activePoints[0]['_index']];
		let title = "Cases of "+user+" in "+tray+" Tray";
		//console.log(" user_tray = "+user+"_"+tray);
		getETLAlertData("AMLOSYSTEM", user+"_"+tray, title);
	}
};