<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
Map<String, Object> dashBoardMap = (Map<String, Object>) request.getAttribute("DashBoardData");
String headerName = ""; 
%>
<script type="text/javascript">
	var id = '${UNQID}';
	$(document).ready(function() {
		var tableClass = 'searchResultGenericTable${UNQID}';
		var dataObj = {};
		dataObj['headers'] = []; 
		compassDatatable.construct(tableClass, "searchResultGenericTable", true);
		
		// Only for Graphs tooltip
		$(".paragraphText"+id).tooltip('toggle');
		$("#showTable"+id).on("click", function(){
			$("#tableDiv"+id).toggle();
			if($("#showTable"+id).val() == "Show Table"){
				$("#showTable"+id).val("Hide Table");
			}else if($("#showTable"+id).val() == "Hide Table"){
				$("#showTable"+id).val("Show Table");
			}
		});
	});
	
	var myTray = {}; 
	myTray['value'] = [];
	myTray['name'] = [];
	
	<c:forEach var="myTrayDoughnutGraphHeader" items="${DashBoardData['MyTray']['listResultHeader'][0]}">
		myTray['name'].push("${f:substring(myTrayDoughnutGraphHeader,11,myTrayDoughnutGraphHeader.length())}");
	</c:forEach>
	<c:forEach var="myTrayDoughnutGraphData" items="${DashBoardData['MyTray']['listResultData'][0]}">
		myTray['value'].push("${myTrayDoughnutGraphData}");
	</c:forEach>
	
	//Modified the array to remove totalAssigned Element
	myTray['name'].shift();
	myTray['value'].shift();
	
	var myTrayArray = [myTray['name'], myTray['value']];
//console.log(myTray['name'],myTray['value']);

var barChartBGColor = ["#00CED1", "#A9C54D", "#87CEFA", "#FA8072", "#8A2BE2", "#FF6347", "#B0E0E6", "#FF69B4", "#A52A2A", "#D2B48C", "#90EE90", "#E6E6FA", "#008B8B", "#E05958"];
	//headers for aml user wise data
	var amlUserWiseSummaryHeader = [];
	var amlUserWiserDataForCSV = [];
	var amlUserSubGraphDataForCsv = [];
	<c:forEach var = "amlUserWiseSummaryHeaders" items = "${DashBoardData['AMLUserWiseSummary']['listResultHeader']}"  >
		<c:forEach items = "${amlUserWiseSummaryHeaders}" var = "summaryHeader" begin = "3">
			amlUserWiseSummaryHeader.push("${f:substringAfter(summaryHeader,'app.common.COUNT_')}");
		</c:forEach>
		let arr = [];
		<c:forEach items = "${amlUserWiseSummaryHeaders}" var = "summaryHeader">
			arr.push("${f:substringAfter(summaryHeader,'app.common.')}");
		</c:forEach>
		amlUserWiserDataForCSV.push(arr);
	</c:forEach>
	
	<c:set var  = "amlUserSummaryList" value = "${DashBoardData['AMLUserWiseSummary']['listResultData']}"></c:set>
	<c:forEach items = "${amlUserSummaryList}" var = "listElms" >
	//generating data for csv
		var dataArr = [];
		<c:forEach items = "${listElms}" var = "bucketChunks" >
			dataArr.push("${bucketChunks}");
		</c:forEach>
		amlUserWiserDataForCSV.push(dataArr);
	</c:forEach>
	
//for constructing data set for amluser wise buckets
	function constructDataForAmlUserWiseSummary(){
		let bucketData = {};
		let bucketDataDimensionWise = {};
		<c:set var = "amlUserWIseSummaryLength" value = "${(DashBoardData['AMLUserWiseSummary']['listResultData']).size()}"></c:set>
		<c:forEach var="i" begin="1" end="${amlUserWIseSummaryLength}" step="1">
			<c:set var  = "amlUserSummary" value = "${DashBoardData['AMLUserWiseSummary']['listResultData'][amlUserWIseSummaryLength-i]}"></c:set>
			<c:choose>
				<c:when test = "${amlUserSummary[1] != ' ' }">
					var arr = [];
					<c:forEach items = "${amlUserSummary}" var = "bucketChunks" begin = "3">
						arr.push(${bucketChunks});
					</c:forEach>
					bucketDataDimensionWise["${amlUserSummary[1]}"] = {};
					bucketDataDimensionWise["${amlUserSummary[1]}"]['distributedAmong'] = arr;
					bucketDataDimensionWise["${amlUserSummary[1]}"]['totalCountAssigned'] = ${amlUserSummary[2]};
				</c:when>
				<c:otherwise>
					bucketData["${amlUserSummary[0]}"] = bucketDataDimensionWise;
					bucketDataDimensionWise = {};
				</c:otherwise>
			</c:choose>
		</c:forEach>
		
		return bucketData;
	}

	//data for download
	
	function csvDataForAmlUserWiseRecordStats(){
		let header = [];
		let data = [];
		
		header.push("UserCode");
		<c:forEach var="usersDetails" items="${TotalAmluserWiseRecordStats}">
			<c:forEach var="bucketDetails" items="${usersDetails}" begin="0" end="0">
				<c:forEach var="bucketElement" items="${bucketDetails.value}" >
					header.push("${bucketElement.key}");
				</c:forEach>
			</c:forEach>
			
			<c:forEach var="bucketDetails" items="${usersDetails}" >
				var innerArray = [];
				innerArray.push("${bucketDetails.key}");
				<c:forEach var="bucketElement" items="${bucketDetails.value}" >
					innerArray.push("${bucketElement.value}");
				</c:forEach>
				data.push(innerArray);
			</c:forEach>
		</c:forEach>
		data.unshift(header);
		return data;
		
	}
	
	//data for graph
	function constructDataForAmlUserWiseRecordStats(){
		let wholeAmluserList = {};
		
		<c:forEach var="usersDetails" items="${TotalAmluserWiseRecordStats}">
			let eachUser = {};
			<c:forEach var="bucketDetails" items="${usersDetails}">
				var records = {};
				<c:forEach var="bucketElement" items="${bucketDetails.value}">
					records["${bucketElement.key}"] = "${bucketElement.value}";
				</c:forEach>
				eachUser['${bucketDetails.key}'] = records;
			</c:forEach>
			wholeAmluserList = eachUser;
		</c:forEach>
		//console.log(wholeAmluserList);
		return wholeAmluserList;
	}

	$.each(constructDataForAmlUserWiseRecordStats(), function(key,value) {
		  var pendingPercentage = value['TOTAL_PENDING']/value['TOTAL_ASSIGNED']*100;
		  var closedPercentage = value['TOTAL_CLOSED']/value['TOTAL_ASSIGNED']*100;
		  
		  let progressBarSets = "";
		  
		  progressBarSets += "<tr width='100%'>";
		  progressBarSets += "<td width='100%'>";
		  progressBarSets += "<div>";
		  progressBarSets += "<h6 style='margin: 3px;'>"+key+"</h6>";
		  progressBarSets += "<div class='progress' style='border-radius: 10px; height: 10px; margin: 3px;'>";
		  progressBarSets += "<div class='progress-bar progress-bar-striped' role='progressbar' style='background-color: #ed1c24; width: "+pendingPercentage+"%' aria-valuenow='"+pendingPercentage+"' aria-valuemin='0' aria-valuemax='100'><p class='paragraphText${UNQID}' style='color: transparent;' data-toggle='tooltip' data-placement='top' title='"+value['TOTAL_PENDING']+"'>.</p></div>";
		  progressBarSets += "<div class='progress-bar progress-bar-striped' role='progressbar' style='background-color: #00ced1; width: "+closedPercentage+"%' aria-valuenow='"+closedPercentage+"' aria-valuemin='0' aria-valuemax='100'><p class='paragraphText${UNQID}' style='color: transparent;' data-toggle='tooltip' data-placement='top' title='"+value['TOTAL_CLOSED']+"'>.</p></div>";
		  progressBarSets += "</div>";
		  progressBarSets += "<h6 style='margin: 3px; text-align: right;'>"+value['TOTAL_ASSIGNED']+"</h6>";
		  progressBarSets += "</div>";
		  /* progressBarSets += "<progress id="+i+" max="+value.totalCountAssigned+" value="
			+value.distributedAmong[0]+"></progress>"; */
		  progressBarSets += "</td>";
		  progressBarSets += "</tr>";
		  
		  $('#graphsTable'+id).append(progressBarSets); 
		});
	
		let labelString = "";
		
		labelString += "<tr><td>&nbsp;</td></tr>";
		labelString += "<tr>";
		labelString += "<td>";
		labelString += "<div class='col-sm-12' style='padding: 0;'>";
		labelString += "  <div class='col-sm-4 labelDivs'><p>&nbsp;Pending Cases</p></div>";
		labelString += "  <div class='col-sm-1 progress' style='border-radius: 10px; height: 10px; margin: 3px; padding: 0;'>";
		labelString += "	<div class='col-sm-12 progress-bar progress-bar-striped' role='progressbar' style='background-color: #ed1c24; width: 100%' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div>";
		labelString += "  </div>";
		labelString += "  <div class='col-sm-1 labelDivs'>&nbsp;</div>";
		labelString += "  <div class='col-sm-4 labelDivs'><p>Closed Cases</p></div>";
		labelString += "  <div class='col-sm-1 progress' style='border-radius: 10px; height: 10px; margin: 3px; padding: 0;'>";
		labelString += "	<div class='progress-bar progress-bar-striped' role='progressbar' style='background-color: #00ced1; width: 100%' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100'></div>";
		labelString += "  </div>";
		labelString += "</div>";
		labelString += "</td>";
		labelString += "</tr>";
		
		$('#graphsTable'+id).append(labelString);
	
	/* $.each(constructDataForAmlUserWiseSummary(), function(i) {
	  //console.log(i);		// 'i' here is the key of each of the value iterated of bucketData JS object. 
	  var key = Object.keys(this)[0];
	  var value = this[key];
	  //console.log(value.distributedAmong[0]);
	  //console.log(value.totalCountAssigned);
	  
	  let progressBarSets = "";
	   
	  progressBarSets += "<progress id="+i+" max="+value.totalCountAssigned+" value="
	  						+value.distributedAmong[0]+"></progress>";
	  progressBarSets += "<h6 style='margin: 2px; text-align: right;'>"+value.totalCountAssigned+"</h6>";
	  progressBarSets += "</div>";
	  progressBarSets += "</td>";
	  progressBarSets += "</tr>";
	  
	  $('#graphsTable').append(progressBarSets); 
	}); */
	
</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/DashboardGraph/AMLUserWiseSummaryGraph.js"></script>

<style type="text/css">
.modalNav li a{
	font-size: 12px;
	padding: 5px 10px;
}

.graphDiv{
	margin:5px 5px 10px 0;
	padding: 10px;
	border-radius: 10px;
	box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 0 0 1px rgba(0,0,0,0.08);
	width: 49%;
}

.canvasDiv{
	height:260px !important;
}
.dropdownBtn{
	background-color: transparent;
}

.graph-dropdown-content {
    display: none;
    position: absolute;
    background-color: #666666;
    min-width: 48px;;
    z-index: 1;
}

.graph-dropdown-content a {
    color: white;
    padding: 6px 6px;
    text-decoration: none;
    display: block;
    font-size: 13px;
}

.graph-dropdown-content a:hover {
	background-color: #ccc;
	color: black;
}

.labelDivs{
	padding: 0;
	height: 17px;
}


/* progress{
	-webkit-appearance: inherit;
	height: 15px;
    width: -webkit-fill-available;
    background: #FFF;
    box-shadow: none;
}

progress[value]{
  -webkit-appearance: none;
     -moz-appearance: none;
          appearance: none;
  
  border: none;
}

progress[value]::-webkit-progress-bar{
  background-color: #eee;
  border-radius: 12px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.25) inset;
}

progress[value]::-webkit-progress-value {
  background-image:
	   -webkit-linear-gradient(-45deg, 
	                           transparent 33%, rgba(0, 0, 0, .1) 33%, 
	                           rgba(0,0, 0, .1) 66%, transparent 66%),
	   -webkit-linear-gradient(top, 
	                           rgba(255, 255, 255, .25), 
	                           rgba(0, 0, 0, .25)),
	   -webkit-linear-gradient(left, #09c, #f44);

    border-radius: 12px;
    background-size: 35px 20px, 100% 100%, 100% 100%;
}

progress[value]::-webkit-progress-value::before {
  content: '80%';
  position: absolute;
  right: 0;
  top: -125%;
}

progress:hover:before {
  text-align: center;
  color: white;
  display: inline-block;
  content: attr(value);
  position: absolute;
  left: 0;
  right: 0;
  top: 4;
} */
</style>

<div class="col-sm-12" style="margin-top:10px; padding: 0 0;">
	<div class="col-sm-12" id="graphPanelDiv">
		<div class="col-sm-6 myTrayGraphDiv graphDiv" style="float: left;">
			<div class="col-sm-11" >
				<canvas class="canvasDiv" id ="myTrayDoughnutGraph"></canvas>
			</div>
			<div class="col-sm-1 " onmouseleave="downloadButtonLeaved(this)" style="padding:0px;">
				<button type="button" class="btn btn-sm dropdownBtn" data-toggle="dropdown" aria-expanded="false" 
						onmouseenter="downloadButtonHovered(this, 'myTrayDoughnutGraph', 'myTrayArray', 'My Tray')">
					<i class="fa fa-download"></i>
				</button>
			</div>
		</div>
		<div class="col-sm-6 userwiseGraphDiv graphDiv" style="float: right; height: 280px; overflow-y: auto;" >
			<div class="col-sm-11" id="progressBarDiv${UNQID}" >
				<table id="graphsTable${UNQID}" width="100%">
					<tr>
						<td>
							<h5 style="text-align: center; color: #6F6C6D;">AMLUser Wise Summary Result</h5>
						</td>
					</tr>
				</table>
			</div>
			<div class="col-sm-1 " onmouseleave="downloadButtonLeaved(this)" style="padding:0px;">
				<button type="button" class="btn btn-sm dropdownBtn" data-toggle="dropdown" aria-expanded="false" 
						onmouseenter="downloadButtonHovered(this, 'progressBarDiv${UNQID}', 'csvDataForAmlUserWiseRecordStats()', 'AMLUser Summary')">
					<i class="fa fa-download"></i>
				</button>
			</div>
		</div>
	</div>
	<div class="col-sm-12" id="graphPanelDiv2">
		<div class="col-sm-6 amlUserSummaryBarGraphDiv graphDiv" style="float: left: ">
			<div class="col-sm-11" >
				<canvas class="canvasDiv" id="amlUserSummaryBarGraph"></canvas>
			</div>
			<div class="col-sm-1 " onmouseleave="downloadButtonLeaved(this)" style="padding:0px;">
				<button type="button" class="btn btn-sm dropdownBtn" data-toggle="dropdown" aria-expanded="false" 
						onmouseenter="downloadButtonHovered(this, 'amlUserSummaryBarGraph', 'amlUserWiserDataForCSV', 'AMLUser Buckets Details')">
					<i class="fa fa-download"></i>
				</button>
			</div>
		</div>
		<div class="col-sm-6 amlUserSummarySubBarGraphDiv graphDiv" style="float: right;">
			<div class="col-sm-12" id="textDiv" style="text-align: center; font-family: Helvetica;">
				<h5>Click on a bucket range to view bucket details</h5>
			</div>
			<div class="col-sm-11">
				<div class="col-sm-11" id="amlUserSummarySubGraphDiv" style="display: none;">
					<canvas class="canvasDiv" id="amlUserSummarySubBarGraph"></canvas>
				</div>
			</div>
			<div class="col-sm-1" id="downloadBtnDiv" onmouseleave="downloadButtonLeaved(this)" style="padding:0px; display: none;">
				<button type="button" class="btn btn-sm dropdownBtn" data-toggle="dropdown" aria-expanded="false" 
						onmouseenter="downloadButtonHovered(this, 'amlUserSummarySubBarGraph', 'amlUserSubGraphDataForCsv', 'Bucket Details')">
					<i class="fa fa-download"></i>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Tabular Represntation -->
<div class="col-sm-12" style="margin-top:10px; padding: 0;">
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<input type="button" class="btn btn-primary btn-sm" id="showTable${UNQID}" name="ShowTable" value="Tabular Represenation"/>
		</div>
	</div>
</div>
<div class="card card-primary">
<div class="col-sm-12 card-body" id="tableDiv${UNQID}" style="margin-top:10px; padding: 0; display: none;">
	<%
		if(dashBoardMap != null && dashBoardMap.size() > 0){
			Iterator<String> tabNameItr = dashBoardMap.keySet().iterator();
	%>
				<div role="tabpanel">
					<ul class="nav nav-pills modalNav" role="tablist" id="dashBoardTab">
						<%
						int tabIndex = 1;
						while(tabNameItr.hasNext()){
						%>
							<li role="presentation" class='<%=tabIndex == 1 ? "active" : ""%>'>
								<a class="subTab" href="#dashBoardTab<%=tabIndex%>" aria-controls="dashBoardTab<%=tabIndex%>" role="tab" data-toggle="tab"><%=tabNameItr.next()%></a>
							</li>
						<%
							tabIndex++;
						}
						%>
					</ul>
				    <div class="tab-content">
						<%
						tabIndex = 1;
						tabNameItr = dashBoardMap.keySet().iterator();
						while(tabNameItr.hasNext()){
							String tabName = tabNameItr.next();
							HashMap<String, ArrayList<ArrayList<String>>> tabDetailsMap = (HashMap<String, ArrayList<ArrayList<String>>>) dashBoardMap.get(tabName);
	
							ArrayList<ArrayList<String>> headerList = tabDetailsMap.get("listResultHeader");
							ArrayList<ArrayList<String>> dataList = tabDetailsMap.get("listResultData");
						%>
							<div role="tabpanel" class="tab-pane <%=tabIndex == 1 ? "active" : ""%>" id="dashBoardTab<%=tabIndex%>">
								<% if(dataList.size() == 0){%>
									<br/><center>No Record Found</center><br/>
								<%}else{%>
									<table class="table table-striped table-bordered searchResultGenericTable${UNQID}" id="dashBoardTable<%=tabIndex%>" >
										<thead>
											<tr>
											<%
												for(int headMainIndex = 0; headMainIndex < headerList.size(); headMainIndex++){
													ArrayList<String> headerListSub = headerList.get(headMainIndex);
													%>
														<th width='6px'><spring:message code="app.common.SONO"/></th>
	                                                      <%   
													for(int headSubIndex = 0; headSubIndex < headerListSub.size(); headSubIndex++){
														headerName = headerListSub.get(headSubIndex);
														%>
														<th><spring:message code="<%=headerName%>"/></th>
											<%}		}%>
											</tr>
										<thead>
	
										<tbody>
											<%
												for(int rowIndex = 0; rowIndex < dataList.size(); rowIndex++){
												ArrayList<String> rowList = dataList.get(rowIndex);
											%>
													<tr>
													<td><%=rowIndex+1%></td>
														<%
															for(int colIndex = 0; colIndex < rowList.size(); colIndex++){
															 if(colIndex == 0) {
														%>
															<td style="font-weight:bold;font-size:12px;color:black"><%=rowList.get(colIndex)%></td>
	                                                          <%} else { %>
															<td><%=rowList.get(colIndex) != null ? rowList.get(colIndex) : "-"%></td>
	                                                       <%}%>
														<%}%>
													</tr>
											<%}%>
										</tbody>
									</table>
								<%}%>
							</div>
						<%
							tabIndex++;
						}
						%>
				    </div>
			</div>
	
	<%}%>
</div>
</div>
<script>
var myTrayDoughnutGraph = document.getElementById("myTrayDoughnutGraph");
var amlUserSummaryBarGraphCanvas = document.getElementById("amlUserSummaryBarGraph");
var amlUserSummarySubBarGraphCanvas = document.getElementById("amlUserSummarySubBarGraph").getContext("2d");

//My Tray starts
var myTrayDoughnutChart = new Chart(myTrayDoughnutGraph, {
		type: 'doughnut',
	    data: {
	      labels: myTray['name'],
	      datasets: [{
	        label: "Value",
	        labelColor : 'yellow',
	        backgroundColor: ["#FA8072", "#A9C54D", "#87CEFA", "#00CED1", "#8A2BE2", "#FF6347", "#B0E0E6", "#FF69B4", "#A52A2A", "#D2B48C", "#90EE90", "#E6E6FA", "#008B8B", "#E05958"],
	        data: myTray['value']
	      }]
	    },
	    options: {
	      responsive: true,
	   	  maintainAspectRatio: false,
	      title: {
	        display: true,
	        text: 'My Tray',
	        fontColor: '#6F6C6D',
	        fontSize: 14,
	        fontStyle : 'normal',
	        fontFamily : 'Helvetica'
	      },
	     cutoutPercentage : 60, 
	     legend: {
	        display: true,
	       	usePointStyle: true,
	        position: 'right',
	       	labels: {
	          fontColor: "#6F6C6D",
	          fontSize: 10,
	          usePointStyle: true
	        }
	      },
	      pieceLabel: {
		    	 render: function (args) {
		    	      return args.value;
		    	    },
		       	fontColor: '#111',
		       	fontSize: 10,
		       	arc: false
		 }
	   } 	  
});

myTrayDoughnutGraph.onclick = function(evt){
    var activePoints = myTrayDoughnutChart.getElementAtEvent(evt);
    if (activePoints && activePoints.length) {
    	var title = "Details for My Tray = "+ myTray['name'][activePoints[0]["_index"]];
		searchInputParam["columnName"] = "MYTRAY" ;
		searchInputParam["columnValue"] = myTray['name'][activePoints[0]["_index"]];
		searchInputParam["moduleType"] = "dynamicResult";
		getGenericGraphDetails(title,searchInputParam); 
    }
};
//MyTray ends


//amluser summary graph
var amlUserSummaryGraph = new Chart(amlUserSummaryBarGraphCanvas, {
	type: 'bar',
    data: constructDataForAmlUserWiseSummaryMainChart(),
    options: {
      responsive: true,
	  maintainAspectRatio: false,
      title: {
        display: true,
        text: 'AML User Buckets Details',
        fontSize : 14,
        fontStyle : 'normal',
        fontFamily : 'Helvetica'
      },
      scales: {
    	  xAxes: [{
    	      barPercentage: 0.9,
    	      categoryPercentage: 0.6,
    	      ticks: {
    	    	  fontColor: "#6F6C6D",
                  fontSize: 10,
                  fontStyle : "normal",
                  fontFamily : "Helvetica"
              }
    	  }],
         yAxes: [{
            ticks: {
                min: 0,
                stepSize: 50,
                fontColor: "#6F6C6D"
            }
        }] 
    },
    tooltips: {
	      callbacks: {
	    	title: function(tooltipItem, data) {
	    		return ["User Code: "+data.labels[tooltipItem[0]['index']],"Bucket"];
	        },
	        label: function(tooltipItem, data) {
	          let label = data.datasets[tooltipItem.datasetIndex].label;
	          let value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
	          return label + ': ' + value+" Cases";
	        } 
	      }
	 },
    plugins: {
		datalabels: {
			display:true,
			borderRadius: 5,
			color: '#6F6C6D',
			font: {
				weight: 'normal'
			},
			align: 'end',
			anchor: 'center',
			rotation:270,
            clamp:true
		}
	}
  }
});

//for sub graph on click operation
amlUserSummaryBarGraphCanvas.onclick = function(evt){
	let activePoints = amlUserSummaryGraph.getElementAtEvent(evt);
	if (activePoints && activePoints.length) {
		console.log(activePoints);
		let userCode = activePoints[0]['_model']['label'];
		let bucketName = activePoints[0]['_model']['datasetLabel'];
		let colorCode = activePoints[0]['_model']['backgroundColor'];
		let subChartData = constructDataForAmlUserWiseSummarySubChart(userCode,bucketName,colorCode);
		//console.log(subChartData);
		//createSubGraph(subChartData)
		if($("#amlUserSummarySubGraphDiv").is(':hidden')){
			$("#amlUserSummarySubGraphDiv").show();
			$("#downloadBtnDiv").show();
			$("#textDiv").hide();
		}
		amlUserSummarySubGraph.data = subChartData;
		amlUserSummarySubGraph.options.title.text = "Bucket Details of "+userCode;
		amlUserSummarySubGraph.update();
	}
	
};

var amlUserSummarySubGraph = new Chart(amlUserSummarySubBarGraphCanvas,{
		type: 'horizontalBar',
	    data:constructDataForAmlUserWiseSummaryMainChart() ,
	    options: {
	      responsive: true,
		  maintainAspectRatio: false,
	      title: {
	        display: true,
	        text: 'Bucket Detail',
	        fontSize:14,
	        fontStyle : 'normal',
            fontFamily : "Helvetica"
	      },
	      scales: {
	    	  xAxes: [{
	    	      barPercentage: 0.5,
	    	      categoryPercentage: 0.6,
	    	      ticks: {
	    	    	  fontColor: "#000080",
	                  fontSize: 10,
	                  fontStyle : 'normal',
	                  fontFamily : "Helvetica"
	              }
	    	  }]
	    },
	    plugins: {
			datalabels: {
				display:true,
				backgroundColor: function(context) {
					return context.dataset.borderColor;
				},
				borderRadius: 5,
				color: '#333',
				font: {
					weight: 'normal'
				},
				align: 'end',
				anchor: 'center',
                clamp:true
			}
		}
	  }
});


</script>