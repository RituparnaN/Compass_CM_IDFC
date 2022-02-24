transactionChannelCountChart = new Chart(transactionChannelCountCanvas, {
	type: 'line',
	data: {
		labels: ["NEFT", "RTGS", "UPI", "IMPS", "REM", "PCT", "ATM", "CASH", "CLEARING", "OTH"],
		datasets: [/*{
			label: "Transactions",
			backgroundColor: ["#3e95cd"],
			lineTension: 0.1,
			fill: false,
			data: [columnSum["TRANSACTION_NEFT"], columnSum["TRANSACTION_RTGS"],
			columnSum["TRANSACTION_UPI"], columnSum["TRANSACTION_IMPS"], columnSum["TRANSACTION_REM"],
			columnSum["TRANSACTION_PCT"], columnSum["TRANSACTION_ATM"], columnSum["TRANSACTION_OTH"]]
		}*/
		{
			label: "CBS",
			borderColor: "#3e95cd",
			lineTension: 0.1,
			fill: false,
			data: [columnSum["TXN_NEFT_CBS"], columnSum["TXN_RTGS_CBS"],
			columnSum["TXN_UPI_CBS"], columnSum["TXN_IMPS_CBS"], columnSum["TXN_REM_CBS"],
			columnSum["TXN_PCT_CBS"], columnSum["TXN_ATM_CBS"], columnSum["TXN_CASH_CBS"], 
			columnSum["TXN_CLEARING_CBS"], columnSum["TXN_OTH_CBS"]]
		},
		{
			label: "NOVOPAY",
			borderColor: "#8e5ea2",
			lineTension: 0.3,
			fill: false,
			data: [columnSum["TXN_NEFT_NOVOPAY"], columnSum["TXN_RTGS_NOVOPAY"],
			columnSum["TXN_UPI_NOVOPAY"], columnSum["TXN_IMPS_NOVOPAY"], columnSum["TXN_REM_NOVOPAY"],
			columnSum["TXN_PCT_NOVOPAY"], columnSum["TXN_ATM_NOVOPAY"], columnSum["TXN_CASH_NOVOPAY"], 
			columnSum["TXN_CLEARING_NOVOPAY"], columnSum["TXN_OTH_NOVOPAY"]]
		},
		{
			label: "FINNONE",
			borderColor: "#3cba9f",
			lineTension: 0.5,
			fill: false,
			data: [columnSum["TXN_NEFT_FINNONE"], columnSum["TXN_RTGS_FINNONE"],
			columnSum["TXN_UPI_FINNONE"], columnSum["TXN_IMPS_FINNONE"], columnSum["TXN_REM_FINNONE"],
			columnSum["TXN_PCT_FINNONE"], columnSum["TXN_ATM_FINNONE"], columnSum["TXN_CASH_FINNONE"], 
			columnSum["TXN_CLEARING_FINNONE"], columnSum["TXN_OTH_FINNONE"]]
		},
		{
			label: "PRIME",
			borderColor: "#e8c3b9",
			lineTension: 0.7,
			fill: false,
			data: [columnSum["TXN_NEFT_PRIME"], columnSum["TXN_RTGS_PRIME"],
			columnSum["TXN_UPI_PRIME"], columnSum["TXN_IMPS_PRIME"], columnSum["TXN_REM_PRIME"],
			columnSum["TXN_PCT_PRIME"], columnSum["TXN_ATM_PRIME"], columnSum["TXN_CASH_PRIME"], 
			columnSum["TXN_CLEARING_PRIME"], columnSum["TXN_OTH_PRIME"]]
		},
		{
			label: "FPL",
			borderColor: "#c45850",
			lineTension: 0.9,
			fill: false,
			data: [columnSum["TXN_NEFT_FPL"], columnSum["TXN_RTGS_FPL"],
			columnSum["TXN_UPI_FPL"], columnSum["TXN_IMPS_FPL"], columnSum["TXN_REM_FPL"],
			columnSum["TXN_PCT_FPL"], columnSum["TXN_ATM_FPL"], columnSum["TXN_CASH_FPL"], 
			columnSum["TXN_CLEARING_FPL"], columnSum["TXN_OTH_FPL"]]
		}]
	},
	options: {
		responsive: true,
		maintainAspectRatio: false,
		title: {
			display: true,
			text: 'Transaction Channel',
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
					labelString: "No of Transactions"
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

transactionChannelCountCanvas.onclick = function(evt) {
	var activePoints = transactionChannelCountChart.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		let reportValue =  transactionChannelCountChart['data']['datasets'][activePoints[0]['_datasetIndex']]['label'];
		let channelType = transactionChannelCountChart['data']['labels'][activePoints[0]['_index']];
		let title = "Transactions from " + convertDateToString(minDate) + " to " + convertDateToString(maxDate) 
					+ " having "+reportValue+" Source System and "+channelType+" Channel Type";
		//console.log(" reportValue_channelType = "+reportValue+"_"+channelType);
		getETLSummaryReportData("TRANSACTIONCHANNELTYPE", reportValue+"_"+channelType, title);
	}
};