<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<style>

.reportGroup${UNQID}{
	box-shadow: 0 3px 3px 0 rgba(0,0,0,0.16), 0 0 0 3px rgba(0,0,0,0.08);
	margin-top:30px;
	padding:15px;
}

.graphsHeaderPanel{
	text-align: center;
	font-family: Helvetica;
	/* padding-left: 30px; */
	padding-bottom: 10px
}

.datesToggle{
	cursor: pointer; 
	font-weight: bold; 
	text-align: center;
}

</style>

<script type="text/javascript">
	$(document).ready(function(){
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		});
		
		$(".datesToggle").click(function(){
			$(".dateRange").toggle();
			$(".dateField").toggle();
		});
		
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary " >
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">New Dashboard</h6>
			</div>
		
		<div class="card-body">
		
			<div class="col-sm-12 reportGroup${UNQID}" style="margin-bottom: 40px; margin-top: 0px;">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Case Summary</b>
					<br>
					Total Cases are <b id="totalPendingCasesCount${UNQID}" class="text-primary"></b>
				</p>
				<div class="col-sm-12 userRoleGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="userRoleChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">User Productivity</b>
				</p>
				<div class="col-sm-12 workflowGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="pendencyCountUserChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<div class="col-sm-12 workflowGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="pendencyCountAmluserChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<div class="col-sm-12 workflowGraphs${UNQID}">
				<div style="display: flex;">
					<div class="col-sm-6 graphShadow">
						<canvas id ="pendencyCountAmloChartCanvas${UNQID}"></canvas>
					</div>
					<div class="col-sm-6 graphShadow">
						<canvas id ="pendencyCountMlroChartCanvas${UNQID}"></canvas>
					</div>
				</div>
				</div>
			</div>
			
			<!--  BELOW GRAPHS ARE DATE RANGE AFFECTED -->
			<div class="col-sm-12" style="margin-top: 15px;">
				<p class="datesToggle">
					Date Range <img src='${pageContext.request.contextPath}/includes/images/calendar.png' alt='calendar'/>
				</p>
			</div>
			<div class="col-sm-12 dateRange">
				<div class="col-sm-12" id="dateRangeSlider${UNQID}"></div>
			</div>
			<div class="col-sm-12 dateField" style="display: none;">
				<table class="table" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">From Date</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="1_FROMDATE" id="fromDateField${UNQID}"></input>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">To Date</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="2_TODATE" id="toDateField${UNQID}"></input>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="col-sm-12 reportGroup${UNQID}" >
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Customer Master</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total customers are <b id="totalCustomerCount${UNQID}" class="text-primary"></b> 
				</p>
				<div style="display: flex;">
				<div class="col-sm-6 customerGraphs${UNQID}">
					<div class="col-sm-12 graphShadow" >
						<canvas id ="customerRiskratingCanvas${UNQID}"></canvas>
					</div>
				</div>
				<div class="col-sm-6 customerGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="customerSourceSystemCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Customer Type</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total customers are <b id="totalCustomerTypeCount${UNQID}" class="text-primary"></b>
				</p>
				<div class="col-sm-12 customerGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="customerTypeChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Accounts Master</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total accounts are <b id="totalAccountCount${UNQID}" class="text-primary"></b>
				</p>
				<div style="display: flex;">
				<div class="col-sm-6 accountGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="accountRiskratingCanvas${UNQID}"></canvas>
					</div>
				</div>
				<div class="col-sm-6 " class="accountGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="accountSourceSystemCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Accounts Type Status</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total accounts are <b id="totalAccountTypeStatusCount${UNQID}" class="text-primary"></b>
				</p>
				<div style="display: flex;">
				<div class="col-sm-6 accountGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="accountTypeChartCanvas${UNQID}"></canvas>
					</div>
				</div>
				<div class="col-sm-6" class="accountGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="accountStatusChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Transactions Summary</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total transactions are <b id="totalTransactionCount${UNQID}" class="text-primary"></b>
				</p>
				<div style="display: flex;">
				<div class ="col-sm-6 transactionGraphs${UNQID}">
					<div class ="col-sm-12 graphShadow">
						<canvas id ="transactionSourceSystemCanvas${UNQID}"></canvas>
					</div>
				</div>
				<div class ="col-sm-6 transactionGraphs${UNQID}">
					<div class ="col-sm-12 graphShadow">
						<canvas id ="transactionChannelCountCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
			<%-- <p>From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b>  total transaction are <b id="totalTransactionCount${UNQID}" class="text-primary"></b>  </p> --%>
				<div style="display: flex;">
				<div class ="col-sm-6 transactionGraphs${UNQID}">
					<div class ="col-sm-12 graphShadow">
						<canvas id ="txnBillRemiContCanvas${UNQID}"></canvas>
					</div>
				</div>
				<div class ="col-sm-6 transactionGraphs${UNQID}">
					<div class ="col-sm-12 graphShadow">
						<canvas id ="txnBillRemiAmountCanvas${UNQID}"></canvas>
					</div>
				</div>
			
			</div>
			
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Scenario-wise Summary</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b>
				</p>
				<div class="col-sm-12 alertGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="alertChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Regulatory Reports</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b>
				</p>
				<div class="col-sm-12 reportGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="regReportsChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
			
			<div class="col-sm-12 reportGroup${UNQID}">
				<p class="graphsHeaderPanel">
					<b style="text-align: center;">Case Status Summary</b>
					<br>
					From <b class="fromDate${UNQID}"></b> to <b class="toDate${UNQID}"></b> total cases are <b id="totalCasesCount${UNQID}" class="text-primary"></b>
				</p>
				<div class="col-sm-12 workflowGraphs${UNQID}">
					<div class="col-sm-12 graphShadow">
						<canvas id ="workflowChartCanvas${UNQID}"></canvas>
					</div>
				</div>
			</div>
		</div>
		</div>
		</div>
	</div>
	<div class="blurDivDuringLoading" id = "blurDivDuringLoading${UNQID}">
	   <div class="loadingImageDuringContentLoadings" id="loadingImageDuringContentLoadings${UNQID}"></div>
	</div>
</div>
<script>
	console.log("${ETLREGREPORTDATA}");
	//console.log("${ETLALERTDATA}");
	var id = "${UNQID}";
	
	var colorArray = ["#185670", "#B0282B", "#77BCC8", "#22B399", "#4077BC", "#4C2D7D",
		"#3D3F42", "#2E3386"," #BDD632", "#2CA7DF", "#FFC544", "#E62E28", "#00B2BF", "#841619"];
	
	
	var customerRiskratingChart,customerSourceSysteChart,accountRiskratingChart,
	accountSourceSysteChart,transactionSourceSystemChart,transactionChannelCountChart,
	txnBillRemiContChart,txnBillRemiAmountChart, workflowChart, alertChart, regReportsChart, 
	userRoleChartCanvas, accountTypeChartCanvas, accountStatusChartCanvas, customerTypeChartCanvas, 
	pendencyCountUserChartCanvas, pendencyCountAmluserChartCanvas, pendencyCountAmloChartCanvas, 
	pendencyCountMlroChartCanvas;
	
	var customerRiskratingCanvas = document.getElementById("customerRiskratingCanvas" + id);
	var customerSourceSystemCanvas = document.getElementById("customerSourceSystemCanvas" + id);
	var accountRiskratingCanvas = document.getElementById("accountRiskratingCanvas" + id);
	var accountSourceSystemCanvas = document.getElementById("accountSourceSystemCanvas" + id);
	var transactionSourceSystemCanvas = document.getElementById("transactionSourceSystemCanvas"+id);
	var transactionChannelCountCanvas = document.getElementById("transactionChannelCountCanvas"+id);
	var txnBillRemiContCanvas = document.getElementById("txnBillRemiContCanvas"+id);
	var txnBillRemiAmountCanvas = document.getElementById("txnBillRemiAmountCanvas"+id);
	
	var workflowChartCanvas = document.getElementById("workflowChartCanvas"+id);
	var alertChartCanvas = document.getElementById("alertChartCanvas"+id);
	var regReportsChartCanvas = document.getElementById("regReportsChartCanvas"+id);
	var userRoleChartCanvas = document.getElementById("userRoleChartCanvas"+id);
	var accountTypeChartCanvas = document.getElementById("accountTypeChartCanvas"+id);
	var accountStatusChartCanvas = document.getElementById("accountStatusChartCanvas"+id);
	var customerTypeChartCanvas = document.getElementById("customerTypeChartCanvas"+id);
	var pendencyCountUserChartCanvas = document.getElementById("pendencyCountUserChartCanvas"+id);
	var pendencyCountAmluserChartCanvas = document.getElementById("pendencyCountAmluserChartCanvas"+id);
	var pendencyCountAmloChartCanvas = document.getElementById("pendencyCountAmloChartCanvas"+id);
	var pendencyCountMlroChartCanvas = document.getElementById("pendencyCountMlroChartCanvas"+id);
	
	///////////////////////////////////////////////////
	
	//ETL-SUMMARY
	
	var columns = [];
	var columnSum = {};
	var columnSumCopy = {};
	<c:forEach items = "${ETLSUMMARYDATA['COLUMNS']}" var = "colName">
		console.log("${colName}");
		columns.push("${colName}");
		columnSum["${colName}"] = 0;
		columnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLSummaryTableData = [];
	<c:forEach items="${ETLSUMMARYDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLSummaryTableData.push(obj);
	</c:forEach>

	ETLSummaryTableData.forEach(function(row){
		columns.forEach(function(col){
			if(col != "ETLDATETIME"){
				columnSum[col] += row[col];
			}
		});
	}); 
	
	//console.log(ETLSummaryTableData);
	
	///////////////////////////////////////////////////
	
	//ETL-WORKFLOW
	
	var workflowColumns = [];
	var workflowColumnSum = {};
	var workflowColumnSumCopy = {};
	<c:forEach items = "${ETLWORKFLOWDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		workflowColumns.push("${colName}");
		workflowColumnSum["${colName}"] = 0;
		workflowColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLWorkflowTableData = [];
	<c:forEach items="${ETLWORKFLOWDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLWorkflowTableData.push(obj);
	</c:forEach>

	ETLWorkflowTableData.forEach(function(row){
		workflowColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				workflowColumnSum[col] += row[col];
			}
		});
	}); 
	
	var workflowFilteredColumns = workflowColumns.filter(function(col) { 
		//console.log(col);
		return (col !== "ETLDATETIME" && col !== "TOTALCOUNT");
	});
	
	var workflowFilteredData = workflowFilteredColumns.map(function(col) { 
		//console.log(col+"---"+workflowColumnSum[col]);
		return {value: workflowColumnSum[col], title: col};
	});
	//console.log(workflowFilteredData);
	
	
	///////////////////////////////////////////////////
	
	//ETL-ALERT
	
	var alertColumns = [];
	var alertColumnSum = {};
	var alertColumnSumCopy = {};
	<c:forEach items = "${ETLALERTDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		alertColumns.push("${colName}");
		alertColumnSum["${colName}"] = 0;
		alertColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLAlertTableData = [];
	<c:forEach items="${ETLALERTDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLAlertTableData.push(obj);
	</c:forEach>

	ETLAlertTableData.forEach(function(row){
		alertColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				alertColumnSum[col] += row[col];
			}
		});
	}); 
	
	var alertFilteredColumns = alertColumns.filter(function(col) { 
		//console.log(col);
		return (col !== "ETLDATETIME");
	});
	
	var alertFilteredData = alertFilteredColumns.map(function(col) { 
		//console.log(col+"---"+alertColumnSum[col]);
		return {value: alertColumnSum[col], title: col};
	});
	//console.log(alertFilteredData);
	
	//////////////////
	
	//ETL-REGREPORTS
	
	var regReportsColumns = [];
	var regReportsColumnSum = {};
	var regReportsColumnSumCopy = {};
	<c:forEach items = "${ETLREGREPORTDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		regReportsColumns.push("${colName}");
		regReportsColumnSum["${colName}"] = 0;
		regReportsColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLRegReportsTableData = [];
	<c:forEach items="${ETLREGREPORTDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLRegReportsTableData.push(obj);
	</c:forEach>

	ETLRegReportsTableData.forEach(function(row){
		regReportsColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				regReportsColumnSum[col] += row[col];
			}
		});
	}); 
	
	//console.log(regReportsColumnSum);
	
	//////////////////
	
	//ETL-USERROLE
	
	var userRoleColumns = [];
	var userRoleColumnSum = {};
	var userRoleColumnSumCopy = {};
	<c:forEach items = "${ETLUSERROLEDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		userRoleColumns.push("${colName}");
		userRoleColumnSum["${colName}"] = 0;
		userRoleColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLUserRoleTableData = [];
	<c:forEach items="${ETLUSERROLEDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLUserRoleTableData.push(obj);
	</c:forEach>

	ETLUserRoleTableData.forEach(function(row){
		userRoleColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				userRoleColumnSum[col] += row[col];
			}
		});
	}); 
	
	//console.log(userRoleColumnSum);
	
	//////////////////
	
	//ETL-ACCOUNTTYPE_STATUS
	
	var accountTypeStatusColumns = [];
	var accountTypeStatusColumnSum = {};
	var accountTypeStatusColumnSumCopy = {};
	<c:forEach items = "${ETLACCOUNTTYPESTATUSDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		accountTypeStatusColumns.push("${colName}");
		accountTypeStatusColumnSum["${colName}"] = 0;
		accountTypeStatusColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLAccountTypeStatusTableData = [];
	<c:forEach items="${ETLACCOUNTTYPESTATUSDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLAccountTypeStatusTableData.push(obj);
	</c:forEach>

	ETLAccountTypeStatusTableData.forEach(function(row){
		accountTypeStatusColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				accountTypeStatusColumnSum[col] += row[col];
			}
		});
	}); 
	
	//console.log(accountTypeStatusColumnSum);
	
	//////////////////
	
	//ETL-CUSTOMERTYPE
	
	var customerTypeColumns = [];
	var customerTypeColumnSum = {};
	var customerTypeColumnSumCopy = {};
	<c:forEach items = "${ETLCUSTOMERTYPEDATA['COLUMNS']}" var = "colName">
		//console.log("${colName}");
		customerTypeColumns.push("${colName}");
		customerTypeColumnSum["${colName}"] = 0;
		customerTypeColumnSumCopy["${colName}"] = 0;
	</c:forEach>
	var ETLCustomerTypeTableData = [];
	<c:forEach items="${ETLCUSTOMERTYPEDATA['DATA']}" var = "record">
		var obj = {};
		<c:forEach items = "${record}" var ="row">
		<c:choose>
			<c:when test="${row.key == 'ETLDATETIME'}">
				obj.${row.key} = new Date("${row.value}");
			</c:when>
			<c:otherwise>
				obj.${row.key} = ${row.value};
			</c:otherwise>
		</c:choose>
		</c:forEach>
		ETLCustomerTypeTableData.push(obj);
	</c:forEach>

	ETLCustomerTypeTableData.forEach(function(row){
		customerTypeColumns.forEach(function(col){
			if(col != "ETLDATETIME"){
				customerTypeColumnSum[col] += row[col];
			}
		});
	}); 
	
	//console.log(customerTypeColumnSum);
	
	//////////////////
	
	//ETL-CASEPRODUCTIVITY
	
	//console.log('${ETLCASEPRODUCTIVITYDATA["USER"]}');
	
	var colorCodes = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", 
		"#c45850", "#d8c409", "#80620f", "#126b3a", "#421009"];
	
	//USER
	var labelsUSER = ["ASSIGN", "PENDING", "DESKTOPCLOSURE", "ESCALATED", "RAISEDTOBRANCHES", "CLOSEDWITHSTR"];
	//console.log('${ETLCASEPRODUCTIVITYDATA["USER"]}');
	var dataSetsUSER = [];
	<c:forEach var='each' items='${ETLCASEPRODUCTIVITYDATA["USER"]}'>
	    //console.log('${each}');
	    <c:forEach var="result" items="${each}" varStatus="loop">
	    	//console.log('${result.value}');
	    	var dataSet = {};
	    	dataSet.label = '${result.key}';
	    	dataSet.lineTension = 0.4;
	    	dataSet.borderColor = colorCodes['${loop.index}'];
	    	dataSet.fill = false;
	    	dataSet.data = ['${result.value["ASSIGN"]}', '${result.value["PENDING"]}', '${result.value["DESKTOPCLOSURE"]}', 
	    		'${result.value["ESCALATED"]}', '${result.value["RAISEDTOBRANCHES"]}', '${result.value["CLOSEDWITHSTR"]}'];
	    	dataSetsUSER.push(dataSet);
	    </c:forEach>
	</c:forEach>
	
	//AMLUSER
	var labelsAMLUSER = ["ASSIGN", "PENDING", "CLOSEDWITHOUTSTR", "ESCALATED", "DESKTOPCLOSURE", "WITHHINDSIGHTING",
		 "WITHOUTHINDSIGHTING", "RAISEDTOBRANCHES"];
	var dataSetsAMLUSER = [];
	<c:forEach var='each' items='${ETLCASEPRODUCTIVITYDATA["AMLUSER"]}'>
	    //console.log('${each}');
	    <c:forEach var="result" items="${each}" varStatus="loop">
	    	//console.log('${result.value}');
	    	var dataSet = {};
	    	dataSet.label = '${result.key}';
	    	dataSet.lineTension = 0.4;
	    	dataSet.borderColor = colorCodes['${loop.index}'];
	    	dataSet.fill = false;
	    	dataSet.data = ['${result.value["ASSIGN"]}', '${result.value["PENDING"]}', '${result.value["CLOSEDWITHOUTSTR"]}', 
	    		'${result.value["ESCALATED"]}', '${result.value["DESKTOPCLOSURE"]}', '${result.value["WITHHINDSIGHTING"]}', 
	    		'${result.value["WITHOUTHINDSIGHTING"]}', '${result.value["RAISEDTOBRANCHES"]}'];
	    	dataSetsAMLUSER.push(dataSet);
	    </c:forEach>
	</c:forEach>
	
	//AMLO
	var labelsAMLO = ["ASSIGN", "PENDING", "REJECTEDANDCLOSED", "ESCALATED", "WITHHINDSIGHTING",
		 "WITHOUTHINDSIGHTING"];
	var dataSetsAMLO = [];
	<c:forEach var='each' items='${ETLCASEPRODUCTIVITYDATA["AMLO"]}'>
	    //console.log('${each}');
	    <c:forEach var="result" items="${each}" varStatus="loop">
	    	//console.log('${result.value}');
	    	var dataSet = {};
	    	dataSet.label = '${result.key}';
	    	dataSet.lineTension = 0.4;
	    	dataSet.borderColor = colorCodes['${loop.index}'];
	    	dataSet.fill = false;
	    	dataSet.data = ['${result.value["ASSIGN"]}', '${result.value["PENDING"]}', 
	    		'${result.value["REJECTEDANDCLOSED"]}', '${result.value["ESCALATED"]}', 
	    		'${result.value["WITHHINDSIGHTING"]}', '${result.value["WITHOUTHINDSIGHTING"]}'];
	    	dataSetsAMLO.push(dataSet);
	    </c:forEach>
	</c:forEach>
	
	//MLRO
	var labelsMLRO = ["ASSIGN", "PENDING", "REJECTEDANDCLOSED", "CLOSED", "WITHHINDSIGHTING",
		 "WITHOUTHINDSIGHTING", "REGENERATEDNEWCASE"];
	var dataSetsMLRO = [];
	<c:forEach var='each' items='${ETLCASEPRODUCTIVITYDATA["MLRO"]}'>
	    //console.log('${each}');
	    <c:forEach var="result" items="${each}" varStatus="loop">
	    	//console.log('${result.value}');
	    	var dataSet = {};
	    	dataSet.label = '${result.key}';
	    	dataSet.lineTension = 0.4;
	    	dataSet.borderColor = colorCodes['${loop.index}'];
	    	dataSet.fill = false;
	    	dataSet.data = ['${result.value["ASSIGN"]}', '${result.value["PENDING"]}', 
	    		'${result.value["REJECTEDANDCLOSED"]}', '${result.value["CLOSED"]}', 
	    		'${result.value["WITHHINDSIGHTING"]}', '${result.value["WITHOUTHINDSIGHTING"]}', 
	    		'${result.value["REGENERATEDNEWCASE"]}'];
	    	dataSetsMLRO.push(dataSet);
	    </c:forEach>
	</c:forEach>
	
	
	//////////////////
	
	
	function convertDateToString(date){
		return date.getDate()+"/"+(date.getUTCMonth() + 1)+"/"+date.getUTCFullYear();
	};
	
	var minDate = new Date(2010, 1, 10) ;
	var maxDate = new Date(2020, 11, 31) ;
	
	$("#dateRangeSlider"+id).dateRangeSlider({
		bounds: {min: new Date(2009, 0, 1), max: new Date(2021, 11, 31)},
		defaultValues: {min: new Date(2010, 1, 10), max: new Date(2020, 11, 31)},
		step: {days: 1},
		range: {min: {days: 1}}
	});  
	
	function updateTotalCountAndDate(){
		$("#fromDateField"+id).datepicker("setDate", minDate);
		$("#toDateField"+id).datepicker("setDate", maxDate);
		
		//$("#dateRangeSlider"+id).dateRangeSlider("values", minDate, maxDate);
		
		$(".fromDate"+id).text(convertDateToString(minDate));
		$(".toDate"+id).text(convertDateToString(maxDate));
		
		$("#totalCustomerCount"+id).html(columnSum['TOTALCUSTOMERCOUNT'].toLocaleString("en-US"));
		$("#totalAccountCount"+id).text(columnSum['TOTALACCOUNTNOCOUNT'].toLocaleString("en-US"));
		$("#totalTransactionCount"+id).text(columnSum['TOTALTRANSACTIONNOCOUNT'].toLocaleString("en-US"));
		$("#totalCasesCount"+id).text(workflowColumnSum['TOTALCOUNT'].toLocaleString("en-US"));
		$("#totalPendingCasesCount"+id).text(userRoleColumnSum['TOTALCASES'].toLocaleString("en-US"));
		$("#totalAccountTypeStatusCount"+id).text(accountTypeStatusColumnSum['TOTALACCOUNTCOUNT'].toLocaleString("en-US"));
		$("#totalCustomerTypeCount"+id).text(customerTypeColumnSum['TOTALCUSTOMERCOUNT'].toLocaleString("en-US"));
	};
	
	function customMetricAxisValue(value){
		var number = parseInt(value);
		if (number >= 1000000) {
			return (number/1000000).toLocaleString("en-US")+" M";
		} else if (number >= 1000) {
			return (number/1000).toLocaleString("en-US")+" K";
		} else {
			return number.toLocaleString("en-US");
		}
	};
	
	updateTotalCountAndDate();
	
	/*  dateWiseDataUpdate */
	dateWiseDataUpdate = function(minDate, maxDate){
		//console.log(" min and max dates - "+minDate+"---"+maxDate);
		///////////////////////////////////////////////////////////////
		
		//ETLSUMMARY UPDATE
		columnSum =  { ...columnSumCopy };
		ETLSummaryTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				columns.forEach(function(col){
					if(col != "ETLDATETIME"){
						columnSum[col] += row[col];
					}
				});
			}
		});
		
		//console.log(columnSum);
		//for customer risk update
		customerRiskratingChart['data']['datasets'][0]['data'] = [columnSum["CUSTOMER_HIGHRISK"],columnSum["CUSTOMER_MEDIUMRISK"],columnSum["CUSTOMER_LOWRISK"]];
		customerRiskratingChart.update();
		
		//for customer source system update
		customerSourceSysteChart['data']['datasets'][0]['data'] = [columnSum["CUSTOMER_MDM"],columnSum["CUSTOMER_NOVOPAY"],
			columnSum["CUSTOMER_FINNONE"],columnSum["CUSTOMER_PRIME"],columnSum["CUSTOMER_FPL"]];
		customerSourceSysteChart.update();
		
		//for account risk update
		accountRiskratingChart['data']['datasets'][0]['data'] = [columnSum["ACCOUNT_HIGHRISK"],columnSum["ACCOUNT_MEDIUMRISK"],columnSum["ACCOUNT_LOWRISK"]];
		accountRiskratingChart.update();
		
		//for account source systeam count update
		accountSourceSysteChart['data']['datasets'][0]['data'] = [columnSum["ACCOUNT_CBS"],columnSum["ACCOUNT_NOVOPAY"],
			columnSum["ACCOUNT_FINNONE"],columnSum["ACCOUNT_PRIME"],columnSum["ACCOUNT_FPL"]];
		accountSourceSysteChart.update();
		
		//for transaction source system count update
		transactionSourceSystemChart['data']['datasets'][0]['data'] = [columnSum["TRANSACTION_CBS"],columnSum["TRANSACTION_NOVOPAY"],
			columnSum["TRANSACTION_FINNONE"],columnSum["TRANSACTION_PRIME"],columnSum["TRANSACTION_FPL"]];
		transactionSourceSystemChart.update();
		
		//for transaction channel count   
		 transactionChannelCountChart['data']['datasets'][0]['data'] =  [columnSum["TXN_NEFT_CBS"], columnSum["TXN_RTGS_CBS"],
				columnSum["TXN_UPI_CBS"], columnSum["TXN_IMPS_CBS"], columnSum["TXN_REM_CBS"],
				columnSum["TXN_PCT_CBS"], columnSum["TXN_ATM_CBS"], columnSum["TXN_CASH_CBS"], 
				columnSum["TXN_CLEARING_CBS"], columnSum["TXN_OTH_CBS"]];
		
		 transactionChannelCountChart['data']['datasets'][1]['data'] = [columnSum["TXN_NEFT_NOVOPAY"], columnSum["TXN_RTGS_NOVOPAY"],
				columnSum["TXN_UPI_NOVOPAY"], columnSum["TXN_IMPS_NOVOPAY"], columnSum["TXN_REM_NOVOPAY"],
				columnSum["TXN_PCT_NOVOPAY"], columnSum["TXN_ATM_NOVOPAY"], columnSum["TXN_CASH_NOVOPAY"], 
				columnSum["TXN_CLEARING_NOVOPAY"], columnSum["TXN_OTH_NOVOPAY"]];
		 
		 transactionChannelCountChart['data']['datasets'][2]['data'] = [columnSum["TXN_NEFT_FINNONE"], columnSum["TXN_RTGS_FINNONE"],
				columnSum["TXN_UPI_FINNONE"], columnSum["TXN_IMPS_FINNONE"], columnSum["TXN_REM_FINNONE"],
				columnSum["TXN_PCT_FINNONE"], columnSum["TXN_ATM_FINNONE"], columnSum["TXN_CASH_FINNONE"], 
				columnSum["TXN_CLEARING_FINNONE"], columnSum["TXN_OTH_FINNONE"]];
		 
		 transactionChannelCountChart['data']['datasets'][3]['data'] = [columnSum["TXN_NEFT_PRIME"], columnSum["TXN_RTGS_PRIME"],
				columnSum["TXN_UPI_PRIME"], columnSum["TXN_IMPS_PRIME"], columnSum["TXN_REM_PRIME"],
				columnSum["TXN_PCT_PRIME"], columnSum["TXN_ATM_PRIME"], columnSum["TXN_CASH_PRIME"], 
				columnSum["TXN_CLEARING_PRIME"], columnSum["TXN_OTH_PRIME"]];
		 
	     transactionChannelCountChart['data']['datasets'][4]['data'] =  [columnSum["TXN_NEFT_FPL"], columnSum["TXN_RTGS_FPL"],
				columnSum["TXN_UPI_FPL"], columnSum["TXN_IMPS_FPL"], columnSum["TXN_REM_FPL"],
				columnSum["TXN_PCT_FPL"], columnSum["TXN_ATM_FPL"], columnSum["TXN_CASH_FPL"], 
				columnSum["TXN_CLEARING_FPL"], columnSum["TXN_OTH_FPL"]];
		 
		transactionChannelCountChart.update();
		
		
		//for transaction, remittance,bill count update
		txnBillRemiContChart['data']['datasets'][0]['data'] = [columnSum["REMITTANCE_TOTALOUTWARDCOUNT"], columnSum["REMITTANCE_TOTALINWARDCOUNT"]];
		txnBillRemiContChart['data']['datasets'][1]['data'] = [columnSum["BILL_TOTALOUTWARDCOUNT"], columnSum["BILL_TOTALINWARDCOUNT"]];
		txnBillRemiContChart['data']['datasets'][2]['data'] = [columnSum["TRANSACTION_TOTALOUTWARDCOUNT"], columnSum["TRANSACTION_TOTALINWARDCOUNT"]];
		txnBillRemiContChart.update();
		
		//for transaction, remittance,bill amount update
		txnBillRemiAmountChart['data']['datasets'][0]['data'] =  [columnSum["REMITTANCE_TOTALOUTWARDAMOUNT"], columnSum["REMITTANCE_TOTALINWARDAMOUNT"]];
		txnBillRemiAmountChart['data']['datasets'][1]['data'] =  [columnSum["BILL_TOTALOUTWARDAMOUNT"], columnSum["BILL_TOTALINWARDAMOUNT"]];
		txnBillRemiAmountChart['data']['datasets'][2]['data'] =  [columnSum["TRANSACTION_TOTALOUTWARDAMOUNT"], columnSum["TRANSACTION_TOTALINWARDAMOUNT"]];
		txnBillRemiAmountChart.update();
		
		///////////////////////////////////////////////////////////////
		
		//ETLWORKFLOW UPDATE
		workflowColumnSum =  { ...workflowColumnSumCopy };
		ETLWorkflowTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				workflowColumns.forEach(function(col){
					if(col != "ETLDATETIME"){
						workflowColumnSum[col] += row[col];
					}
				});
			}
		});
		workflowFilteredData = workflowFilteredColumns.map(function(col) { 
			//console.log(col+"---"+workflowColumnSum[col]);
			return {value: workflowColumnSum[col], title: col};
		});
		workflowChart['data']['datasets'][0]['tree'] = workflowFilteredData;
		workflowChart['data']['datasets'][0]['backgroundColor'] = function(workflowContextUpdated) {
			var dataValue = workflowContextUpdated.dataset.data[workflowContextUpdated.dataIndex];
			if(dataValue !== undefined){
				//console.log(" = "+dataValue.v);
				return backgroundColorUpdater(dataValue.v);
			}
		};
		workflowChart.update();
		
		///////////////////////////////////////////////////////////////
		
		//ETLALERT UPDATE
		alertColumnSum =  { ...alertColumnSumCopy };
		ETLAlertTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				alertColumns.forEach(function(col){
					if(col != "ETLDATETIME"){
						alertColumnSum[col] += row[col];
					}
				});
			}
		});
		
		alertFilteredData = alertFilteredColumns.map(function(col) { 
			//console.log(col+"---"+alertColumnSum[col]);
			return {value: alertColumnSum[col], title: col};
		});
		
		alertChart['data']['datasets'][0]['tree'] = alertFilteredData;
		alertChart['data']['datasets'][0]['backgroundColor'] = function(alertContextUpdated) {
			var dataValue = alertContextUpdated.dataset.data[alertContextUpdated.dataIndex];
			if(dataValue !== undefined){
				//console.log(" = "+dataValue.v);
				return backgroundColorUpdater(dataValue.v);
			}
		};
		alertChart.update();
		
		///////////////////////////////////////////////////////////////
		
		//ETLREGREPORTS UPDATE
		regReportsColumnSum =  { ...regReportsColumnSumCopy };
		ETLRegReportsTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				regReportsColumns.forEach(function(col){
					if(col != "ETLDATETIME"){
						regReportsColumnSum[col] += row[col];
					}
				});
			}
		});
		
		regReportsChart['data']['datasets'][0]['data'] = [regReportsColumnSum["TOTALNTRCOUNT"], regReportsColumnSum["TOTALCTRCOUNT"],
								regReportsColumnSum["TOTALCBWTCOUNT"], regReportsColumnSum["TOTALSTRCOUNT"]]
		regReportsChart.update();
		
		///////////////////////////////////////////////////////////////
		
		//ETLACCOUNTTYPE_STATUS UPDATE
		accountTypeStatusColumnSum =  { ...accountTypeStatusColumnSumCopy };
		ETLAccountTypeStatusTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				accountTypeStatusColumns.forEach(function(col){
					if(col != "ETLDATETIME"){
						accountTypeStatusColumnSum[col] += row[col];
					}
				});
			}
		});
		
		accountTypeChart['data']['datasets'][0]['data'] = [accountTypeStatusColumnSum["ODA"],
	 		accountTypeStatusColumnSum["LAA"], accountTypeStatusColumnSum["SBA"],
			accountTypeStatusColumnSum["TDA"], accountTypeStatusColumnSum["CAA"]]
		accountTypeChart.update();
		
		accountStatusChart['data']['datasets'][0]['data'] = [accountTypeStatusColumnSum["ACTIVE"], accountTypeStatusColumnSum["INACTIVE"], 
			accountTypeStatusColumnSum["DORMANT"], accountTypeStatusColumnSum["CLOSED"]]
		accountStatusChart.update();
		
		///////////////////////////////////////////////////////////////
		
		//ETLCUSTOMERTYPE UPDATE
		customerTypeColumnSum =  { ...customerTypeColumnSumCopy };
		ETLCustomerTypeTableData.forEach(function(row){
			if(row["ETLDATETIME"] >= minDate && row["ETLDATETIME"] <= maxDate){
				customerTypeColumns.forEach(function(col){
					if(col != "ETLDATETIME"){
						customerTypeColumnSum[col] += row[col];
					}
				});
			}
		});
		
		customerTypeChart['data']['datasets'][0]['data'] = 
			[customerTypeColumnSum["BHARAT_INDIVIDUAL"], customerTypeColumnSum["CONSUMER_INDIVIDUAL"],
				customerTypeColumnSum["WHOLESALE_INDIVIDUAL"], customerTypeColumnSum["BUSINESS_INDIVIDUAL"],
				customerTypeColumnSum["NOTCLASSIFIED_INDIVIDUAL"]]
		customerTypeChart['data']['datasets'][1]['data'] = 
			[customerTypeColumnSum["BHARAT_CORPORATE"], customerTypeColumnSum["CONSUMER_CORPORATE"],
				customerTypeColumnSum["WHOLESALE_CORPORATE"], customerTypeColumnSum["BUSINESS_CORPORATE"],
				customerTypeColumnSum["NOTCLASSIFIED_CORPORATE"]]
		
		customerTypeChart.update();
		
		///////////////////////////////////////////////////////////////
		
		updateTotalCountAndDate();
	}
	
	/*  dates update function */
	$("#dateRangeSlider"+id).bind("valuesChanged", function(e, data){
		minDate = data.values.min;
		maxDate = data.values.max;
		
		dateWiseDataUpdate(minDate, maxDate);
 	});
	
	$( "#fromDateField"+id+", #toDateField"+id ).change(function() {
		minDate = $("#fromDateField"+id).datepicker('getDate');
		maxDate = $("#toDateField"+id).datepicker('getDate');
		
		if(minDate > maxDate){
			minDate = $("#toDateField"+id).datepicker('getDate');
			maxDate = $("#toDateField"+id).datepicker('getDate');
		}
		//console.log(minDate+"---"+maxDate);
		
		dateWiseDataUpdate(minDate, maxDate);
	});
	/////////////////

	function backgroundColorUpdater(value, border) {
		var alpha = (Math.log(value)) / 10;
		//console.log(alpha);
		var color = "#337ab7";
		if (border) {
			alpha += 0.1;
		}
		return Chart.helpers.color(color)
			.alpha(alpha)
			.rgbString();
	}
	
	function getETLSummaryReportData(reportType,selectedColumnName,title){
		$.ajax({
			url :"${pageContext.request.contextPath}/common/searchGenericMaster",
			cache : false,
			type : "POST",
			data : {
				"moduleType":"${MODULETYPE}",
				"1_fromDate":convertDateToString(minDate),
				"2_toDate":convertDateToString(maxDate),
				"3_reportType":reportType,
				"4_reportValue":selectedColumnName,
				"bottomPageUrl":"OverviewGlance/TableData"
			},
			success : function(result) {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html(title);
				$("#compassCaseWorkFlowGenericModal-body").html(result);
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			error:function (err){
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			complete:function(err){
				//$("#blurDivDuringLoading"+unqId).hide();
			}
		});
	};
	
	function getETLAlertData(reportType,selectedColumnName,title){
		$.ajax({
			url :"${pageContext.request.contextPath}/common/overview/getETLAlertData",
			cache : false,
			type : "POST",
			data : {
				"moduleType":reportType,
				"fromDate":convertDateToString(minDate),
				"toDate":convertDateToString(maxDate),
				"reportType":reportType,
				"reportValue":selectedColumnName,
				"bottomPageUrl":"OverviewGlance/TableData"
			},
			success : function(result) {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html(title);
				$("#compassCaseWorkFlowGenericModal-body").html(result);
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			error:function (err){
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			complete:function(err){
				//$("#blurDivDuringLoading"+unqId).hide();
			}
		});
	};
	
	function getETLRegulatoryReportData(reportType,selectedColumnName,title){
		$.ajax({
			url :"${pageContext.request.contextPath}/common/overview/getETLRegulatoryReportData",
			cache : false,
			type : "POST",
			data : {
				"moduleType":reportType,
				"fromDate":convertDateToString(minDate),
				"toDate":convertDateToString(maxDate),
				"reportType":reportType,
				"reportValue":selectedColumnName,
				"bottomPageUrl":"OverviewGlance/TableData"
			},
			success : function(result) {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html(title);
				$("#compassCaseWorkFlowGenericModal-body").html(result);
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			error:function (err){
				//$("#blurDivDuringLoading"+unqId).hide();
			},
			complete:function(err){
				//$("#blurDivDuringLoading"+unqId).hide();
			}
		});
	};
	
	/*  30.11.2020 - LOADING THE GRAPH JS FILES */

	/* var customerRiskRatingChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/riskRatingChart.js";
	$.getScript(customerRiskRatingChartURL);
	
	var customerSourceSystemURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/sourceSystem.js";
	$.getScript(customerSourceSystemURL);
	
	var accountRiskRatingChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/riskRatingChart.js";
	$.getScript(accountRiskRatingChartURL);
	
	var accountSourceSystemURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/sourceSystem.js";
	$.getScript(accountSourceSystemURL);
	
	var transactionSourceSystemURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/sourceSystem.js";
	$.getScript(transactionSourceSystemURL);
	
	var transactionChannelCountURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/channelCount.js";
	$.getScript(transactionChannelCountURL);
	
	var transactionTxnBillRemiCountURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/txnBillRemiCount.js";
	$.getScript(transactionTxnBillRemiCountURL);

	var transactionTxnBillRemiAmountURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/txnBillRemiAmount.js";
	$.getScript(transactionTxnBillRemiAmountURL);

	var workflowChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/workflowChart.js";
	$.getScript(workflowChartURL);

	var alertChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/alert/alertChart.js";
	$.getScript(alertChartURL);

	var regReportsChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/reports/regReportsChart.js";
	$.getScript(regReportsChartURL);

	var userRoleChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/userRole/userRoleChart.js";
	$.getScript(userRoleChartURL);

	var accountTypeChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/accountTypeChart.js";
	$.getScript(accountTypeChartURL);

	var accountStatusChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/accountStatusChart.js";
	$.getScript(accountStatusChartURL);

	var customerTypeChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/customerTypeChart.js";
	$.getScript(customerTypeChartURL);

	var pendencyCountUserChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountUserChart.js";
	$.getScript(pendencyCountUserChartURL);

	var pendencyCountAmluserChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountAmluserChart.js";
	$.getScript(pendencyCountAmluserChartURL);

	var pendencyCountAmloChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountAmloChart.js";
	$.getScript(pendencyCountAmloChartURL);

	var pendencyCountMlroChartURL = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountMlroChart.js";
	$.getScript(pendencyCountMlroChartURL); */
	
</script>

<!-- 30.11.2020 -LOADING THESE JUST ABOVE USING JQUERY -->
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/riskRatingChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/sourceSystem.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/riskRatingChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/sourceSystem.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/sourceSystem.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/channelCount.js"></script>

<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/txnBillRemiCount.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/transaction/txnBillRemiAmount.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/workflowChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/alert/alertChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/reports/regReportsChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/userRole/userRoleChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/accountTypeChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/account/accountStatusChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/customer/customerTypeChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountUserChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountAmluserChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountAmloChart.js"></script>
<script type="text/javascript" defer src = "${pageContext.request.contextPath}/includes/scripts/pages/OverviewGlance/ETLSummary/workflow/pendencyCountMlroChart.js"></script> 

