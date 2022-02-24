<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<style>

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


</style>
<div class="row">
	<div class="chart-container col-sm-offset-2 col-sm-8 shadow" id="currencyGraphDiv" style="height: 380px;margin-top:40px;margin-bottom:40px;">
		<canvas id="peer1${UNQID}"></canvas>
	</div>
	<div class="col-sm-1" onmouseleave="downloadButtonLeaved(this)"
		style="padding: 0px;">
		<button type="button" class="btn btn-sm dropdownBtn"
			data-toggle="dropdown" aria-expanded="false"
			onmouseenter="downloadButtonHovered(this, 'peer1${UNQID}', 'columnData', 'Customer Peer Group')">
			<i class="fa fa-download"></i>
		</button>
	</div>
</div>

<script>
	var id = '${UNQID}',
	moduleCode = '${moduleType}',
	comparisionData = [],
	xAxis = "${x_axis}", 
	yAxix = "${y_axis}",
	chartTitle = "${chartTitle}",
	previousData = "",
	columnName = [],
	columnData = [];
	colorArray1 = 	["#185670", "#B0282B", "#77BCC8", "#22B399", "#4077BC", "#4C2D7D", "#3D3F42", "#2E3386"," #BDD632", "#2CA7DF", "#FFC544", "#E62E28", "#00B2BF", "#841619", "#9A3B96", "#e6cf25", "#ae25e6", "#e62e25", "#bde625", "#25e64e", "#dde625", "#4e25e6", "#ae25e6"];
	
	//for couln name 
	
	<c:forEach items="${columnName}" var = "name">
		columnName.push("${name}");
	</c:forEach>
	columnData.push(columnName);
	//FOR  previous data..
	 <c:forEach items="${paramMap}" var ="CustParameter" varStatus = "status">
	 	<c:choose>
		  <c:when test="${status.first}">
		  	previousData += "${CustParameter.key}=${CustParameter.value}";
		  </c:when>
		  <c:otherwise>
		 	previousData += "&${CustParameter.key}=${CustParameter.value}";
		  </c:otherwise>
		</c:choose>
 	</c:forEach>
 	previousData += "&moduleType=${moduleType}"; 
	 
	<c:forEach items = "${DATA}" var ="data" varStatus="status1">
		var outerObj = {};
		outerObj.label = "${data.key}";
		outerObj.borderColor = colorArray1[${status1.count}];
		outerObj.backgroundColor = "transparent";
			var data = [];
		<c:forEach items="${data.value}" var = "row">
			var rowValue = [];
			var innerObj = {};
			<c:forEach items = "${row}" var = "elm">
				rowValue.push("${elm.value}");
				<c:choose>
				  <c:when test="${elm.key == 'X'}">
				  	innerObj["x"] =  moment("${elm.value}").format("DD/MM/YY");
				  </c:when>
				  <c:when test="${elm.key == 'Y'}">
				  	innerObj["y"] = "${elm.value}";
				  </c:when>
				  <c:otherwise>
				  	innerObj["${elm.key}"] =  "${elm.value}";
				  </c:otherwise>
				</c:choose>
			</c:forEach>
			columnData.push(rowValue);
			data.push(innerObj);
		</c:forEach>
		outerObj.data = data;
		comparisionData.push(outerObj);
	</c:forEach>
	
	console.log(comparisionData);
	
	
	var peer1ChartCanvas = document.getElementById("peer1"+id);

	 var peer1Chart = new Chart(peer1ChartCanvas,{
		type: 'line',
		  data: {
			  datasets:comparisionData//dataArray,
		  },
		  options: {
			  responsive: true,
		   	  maintainAspectRatio: false,
		   	  animating:true,
			  title: {
		        display: true,
		        text: chartTitle,
		        fontSize:16
			  },
			  scales:{
					xAxes:[{
						type:"time",
						distribution: "series",
						time: {
		                    unit: 'month',
		                    	displayFormats: {
		                            quarter: 'MMM YYYY'
		                        }
		                }
					}]
			  },
		      tooltips: {
		      callbacks: {
		    	title: function(tooltipItem, data) {
		    		let dataSetIndex = tooltipItem[0]['datasetIndex'];
		    		let index = tooltipItem[0]['index'];
		    		var gTitle = [];
		    		gTitle.push(data.datasets[dataSetIndex].data[index].x);
		    		gTitle.push(data.datasets[dataSetIndex].data[index].CUSTOMERID);
		    		return gTitle;
		        }
		       }
		    }
		  }
	}); 
	 
	 peer1ChartCanvas.onclick = function(evt){
	        var activePoints = peer1Chart.getElementAtEvent(evt);
	        if (activePoints && activePoints.length) {
	        	let datasetIndex = activePoints[0]["_datasetIndex"];
	        	let index = activePoints[0]["_index"];
	        	let chartData = "";
	        	 $.each(comparisionData[datasetIndex].data[index],function(k,v){
	        		 chartData +="&"+k+"="+v;
	        	 });
	        	 //previousData += chartData;
	        	 console.log(previousData+""+chartData);
	        	 $.ajax({
	 				url: "${pageContext.request.contextPath}/common/getCustomerPeerGroupDetail",
	 				cache: false,
	 				type: "POST",
	 				data: previousData.concat(chartData),
	 				success: function(res) {
	 					$("#compassCaseWorkFlowGenericModal").modal("show");
	 					$("#compassCaseWorkFlowGenericModal-title").html("Data");
	 					$("#compassCaseWorkFlowGenericModal-body").html(res);
	 					
	 				},
	 				error: function(a,b,c) {
	 					console.log();
	 				}
	 			});
	        }
		};
</script>