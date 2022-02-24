/*
 * 
 *data constructions
 *for aml user wise
 *summary cahrt
 */


	//for generating data structure as graph needed
	let mainBucketData = constructDataForAmlUserWiseSummary();
	function constructDataForAmlUserWiseSummaryMainChart(){
		let mianChartData = {};
		let userCodes = Object.keys(mainBucketData);
		let bucketNamesforAMLUsers = Object.keys(mainBucketData[userCodes[0]]);
		let data = [];
		let bucketDataSetsForChart = {};
		$.each(bucketNamesforAMLUsers,function(bucketIndex,bucketName){
			bucketDataSetsForChart = {};
			bucketDataSetsForChart['label'] = bucketName;
			bucketDataSetsForChart['backgroundColor'] = barChartBGColor[bucketIndex];
			let currentBucketValue = [];
			$.each(mainBucketData,function(userCode,bukcetDetails){
				//console.log(bucketName+"  "+bukcetDetails[bucketName]['totalCountAssigned']);
				currentBucketValue.push(bukcetDetails[bucketName]['totalCountAssigned']);
				
			});
			bucketDataSetsForChart['data'] = currentBucketValue;
			data.push(bucketDataSetsForChart);
		});
		mianChartData['labels'] = userCodes;
		mianChartData['datasets'] = data;
		
		return mianChartData;
		//console.log(mianChartData);
	}
	
	//for generating data struture as sub graph needed
	function constructDataForAmlUserWiseSummarySubChart(userCode,bucketName){
		let data = {};
		let dataset = {};
		dataset['label'] = bucketName;
		dataset['data'] = mainBucketData[userCode][bucketName]['distributedAmong'];
		dataset['backgroundColor'] = barChartBGColor;
		data['labels'] = amlUserWiseSummaryHeader;
		data['datasets'] = [];
		data['datasets'].push(dataset);
		return data;
	}
	
	
		