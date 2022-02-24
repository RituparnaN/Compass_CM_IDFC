/*
 * 
 *data constructions
 *for amluser wise
 *summary chart
 */

	//for generating data structure as graph needed
	let mainBucketData = constructDataForAmlUserWiseSummary();
	function constructDataForAmlUserWiseSummaryMainChart(){
		let mainChartData = {};
		if(Object.keys(mainBucketData).length > 0){
		let userCodes = Object.keys(mainBucketData);
		let bucketNamesforAMLUsers = Object.keys(mainBucketData[userCodes[0]]);
		let data = [];
		let bucketDataSetsForChart = {};
		$.each(bucketNamesforAMLUsers,function(bucketIndex,bucketName){
			bucketDataSetsForChart = {};
			bucketDataSetsForChart['label'] = bucketName;
			bucketDataSetsForChart['backgroundColor'] = barChartBGColor[bucketIndex];
			//bucketDataSetsForChart['borderColor'] = 'CDCDCE';
			//bucketDataSetsForChart['borderWidth'] = 1;
			//bucketDataSetsForChart['hoverBorderWidth'] = 2;
			let currentBucketValue = [];
			$.each(mainBucketData,function(userCode,bukcetDetails){
				//console.log(bucketName+"  "+bukcetDetails[bucketName]['totalCountAssigned']);
				currentBucketValue.push(bukcetDetails[bucketName]['totalCountAssigned']);	
			});
			bucketDataSetsForChart['data'] = currentBucketValue;
			data.push(bucketDataSetsForChart);
		});
		mainChartData['labels'] = userCodes;
		mainChartData['datasets'] = data;
		}
		
		return mainChartData;
		//console.log(mainChartData);
	}
	
	//for generating data structure as sub graph needed
	function constructDataForAmlUserWiseSummarySubChart(userCode,bucketName,colorCode){
		let data = {};
		let dataset = {};
		dataset['label'] = bucketName;
		dataset['data'] = mainBucketData[userCode][bucketName]['distributedAmong'];
		//dataset['backgroundColor'] = barChartBGColor;
		dataset['backgroundColor'] = colorCode;
		data['labels'] = amlUserWiseSummaryHeader;
		data['datasets'] = [];
		data['datasets'].push(dataset);
		amlUserSubGraphDataForCsv = [];
		amlUserSubGraphDataForCsv.push(amlUserWiseSummaryHeader);
		amlUserSubGraphDataForCsv.push(mainBucketData[userCode][bucketName]['distributedAmong']);
		return data;
	}
	
	
		