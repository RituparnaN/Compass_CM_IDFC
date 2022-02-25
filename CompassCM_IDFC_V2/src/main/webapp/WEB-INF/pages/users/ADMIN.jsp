<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){		
		$.fn.dataTableExt.sErrMode = 'throw';
		$("#placeholder").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center><br/>");
		var data = [], totalPoints = 300;
		var options = {
		    series: {
		    	valueLabels: {
		    		show: true,
		            showAsHtml: false,
		            align: "center"
		        }
		    },
		    yaxis: { min: 0, max: 100 },
		    xaxis: { show: false },
		    legend: { position: 'sw' },
		    colors: [ 'orange', '#00C07F', '#1CB0F6']
		};
		
		function ramUtilization() {
	        var res = [];
	        for (var i = 0; i < totalPoints; ++i){
	        	var value = $("#memoryUtilization").val();
	            res.push([i, value])
	        }
	        return res;
	    }
		
		function swapUtilization() {
	        var res1 = [];
	        for (var i = 0; i < totalPoints; ++i){
	        	var value = $("#swapUtilization").val();
	            res1.push([i, value]);
	        }
	        return res1;
	    }
		
		function cpuUtilization() {
	        var res1 = [];
	        for (var i = 0; i < totalPoints; ++i){
	        	var value = $("#cpuUtilization").val();
	            res1.push([i, value]);
	        }
	        return res1;
	    }
		
		getSeriesObj = function() {
	 	   return [
	 	    {
	 	      data: ramUtilization(),
	 	      lines: { show: true, fill: false },
	 	      label : "RAM Usage : "+$("#memoryUtilization").val()+"%"
	 	    }, {
	 	      data: swapUtilization(),
	 	      lines: { show: true, fill: false },
	 	      label : "SWAP Usage : "+$("#swapUtilization").val()+"%"
	 	    },
	 	    {
	 	      data: cpuUtilization(),
	   	      lines: { show: true, fill: false },
	   	      label : "CPU Usage : "+$("#cpuUtilization").val()+"%"
	 	    }
	 	  ];
	 	}
		
		var loggedInUserTable = $("#loggedUserDatatable").DataTable({
			dom : '<"tableTools"<"row"<"col-xs-4"l><"col-xs-4"f><"col-xs-4 loggedUserDatatableCols">><"row"<"col-xs-8 compassDataTableInfo"i><"col-xs-4"p>>><"compassDataTable"t><"clear">',
			"processing": true,
			"ajax": {
	            "url": "getAllLoggedInUser",
	            "type" : "POST"
	        },
	        "columns": [
	            { "data": "USERCODE" },
	            { "data": "NAME" },
	            { "data": "ROLE" },
	            { "data": "CREATIONDATE" },
	            { "data": "LASTACCESSED" },
	            { "data": "TERMINAL" },
	            { "data": "SESSIONID" }
	        ]
			
		});
		
		function update() {
	    	$.plot($("#placeholder"), getSeriesObj(), options);
	    	// getSystemInfo();
	    	loggedInUserTable.ajax.reload();
	    }
		
		setInterval(update, 1500);
		
		
	});
</script>
<style>
.dashBoardTables tr th{
	border-collapse: collapse;
	padding: 0 10px;
	min-width: 175px;
}
.activeUserTable{
	overflow: auto;
}
.dashBoardTables{
	margin-bottom: 0px;
}

.activeUserTable{
	height: 200px;
}
</style>
<script type="text/javascript">
	function dismissSession(id){
		if(confirm("Do you want dismiss this session?")){
			$.ajax({
	    		url : 'removeSessionForContext?SESSIONID='+id,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			alert(resData);
	    		}
			});
		}
	}
	
	function getSystemInfo(){
		$.ajax({
    		url : 'getSystemInfo',
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$("#pid").html("PID : "+resData.PID);
    			$("#memoryUtilization").val(resData.MOMORYUTILIZATION);
    			$("#swapUtilization").val(resData.SWAPUTILIZATION);
    			$("#cpuUtilization").val(resData.CPUUTILIZATION);
    			$("#systemInfoLoading").hide();
    			$("#osName").html(resData.OSNAME);
    			$("#osVersion").html(resData.OSVERSION);
    			$("#osArch").html(resData.OSARCH);
    			$("#cpuUpTime").html(resData.CPUUPTIME);
    			$("#totalHardDisk").html(resData.TOTALHARDDISKSPACE);
    			$("#freeHardDisk").html(resData.FREEHARDDISKSPACE);
    			$("#processorCore").html(resData.CPUCORE);
    			$("#totalRAM").html(resData.TOTALPRIMARYMEMORY);
    			$("#freeRAM").html(resData.FREEPRIMARYMEMORY);
    			$("#totalSWAP").html(resData.TOTALSSWAPMEMORY);
    			$("#freeSWAP").html(resData.FREESWAPMEMORY);
    			$("#heapMAX").html(resData.MAXJVMSIZE);
    			$("#heapUSED").html(resData.USEDJVMSIZE); 
    			$("#heapCommitted").html(resData.COMMITTEDJVMSIZE);
    			$("#ServerInfo").show();
    		},
    		error : function(){
    			$(".loggedInUsers").html("Something went wrong");
    		}
    	});	
	}
</script>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<div>
				<ul class="nav nav-tabs compass-nav-tabs" role="tablist" id="compassTab">
					<li class="active litabdashboard">
						<a class="nav-link active" href="#dashboard" data-toggle="tab">Dash Board</a>
					</li>
				</ul>
				<div class="tab-content compass-tab-content">
					<div class="tab-pane active" id="dashboard">
						<div class="row">
							<div class="col-sm-12">
								<div class="card card-primary">
									<div class="card-header clearfix">
										<h6 class="card-title pull-left"><spring:message code="app.admin.loggedInUser"/></h6>
									</div>
									<!--  <div id="loggedInUsers" style="max-height: 300px; overflow: auto;"> -->
									<div id="loggedInUsers" style="max-height: 700px; overflow: auto;">
										<table style="width: 100%" class='table table-striped searchResultGenericTable' id='loggedUserDatatable'>
	    									<thead>
	    										<tr>
	    											<th><spring:message code="app.common.USERCODE"/></th>
	    											<th><spring:message code="app.common.USERNAME"/></th>
	    											<th><spring:message code="app.common.ROLE"/></th>
	    											<th><spring:message code="app.common.LOGGEDON"/></th>
	    											<th><spring:message code="app.common.LASTACCESS"/></th>
	    											<th><spring:message code="app.common.IPADDRESS"/></th>
	    											<th><spring:message code="app.common.ACTION"/></th>
	    										</tr>
	    									</thead>
	    								</table>
									</div>
								</div>
							</div>
						</div>
						<%-- <div class="row">
							<div class="col-sm-6">
								<div class="card card-primary">
									<div class="card-header clearfix">
										<h6 class="card-title pull-${dirL}"><spring:message code="app.admin.serverInformation"/></h6>
									</div>
									<div id="systemInfoLoading">
										<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center><br/></td>
									</div>
									<div id="ServerInfo" style="display: none; height: 310px; overflow: auto;">
										<table class="table table-striped dashBoardTables">
											<tbody>
												<tr>
													<td style="width:35%">JVM Maximum Size</td>
													<td style="width:65%" id="heapMAX"></td>
												</tr>
												<tr>
													<td>JVM Committed</td>
													<td id="heapCommitted"></td>
												</tr>
												<tr>
													<td>JVM Used Size</td>
													<td id="heapUSED"></td>
												</tr>
												<tr>
													<td>Total RAM</td>
													<td id="totalRAM"></td>
												</tr>
												<tr>
													<td>Free RAM</td>
													<td id="freeRAM"></td>
												</tr>
												<tr>
													<td>Total SWAP</td>
													<td id="totalSWAP"></td>
												</tr>
												<tr>
													<td>FREE SWAP</td>
													<td id="freeSWAP"></td>
												</tr>
												<tr>
													<td>Processor</td>
													<td id="processorCore"></td>
												</tr>
												<tr>
													<td>CPU UP Time</td>
													<td id="cpuUpTime"></td>
												</tr>
												<tr>
													<td>Total Harddisk Size</td>
													<td id="totalHardDisk"></td>
												</tr>
												<tr>
													<td>Free Harddisk Size</td>
													<td id="freeHardDisk"></td>
												</tr>
												<tr>
													<td>Operating System</td>
													<td id="osName"></td>
												</tr>
												<tr>
													<td>Version</td>
													<td id="osVersion"></td>
												</tr>
												<tr>
													<td>Architecture</td>
													<td id="osArch"></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<input type="hidden" id="memoryUtilization" value="0"/>
								<input type="hidden" id="swapUtilization" value="0"/>
								<input type="hidden" id="cpuUtilization" value="0"/>
								<div class="card card-primary">
									<div class="card-header clearfix">
										<div class="pull-${dirL}">
											<h6 class="card-title"><spring:message code="app.admin.serverUtilization"/></h6>
										</div>
										<div class="pull-${dirR}" id="pid"></div>
									</div>
									<div class="card-body">
										<div class="col-sm-12" id="placeholder" style="height:275px;"></div>
									</div>
								</div>
							</div>
						</div> --%>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>