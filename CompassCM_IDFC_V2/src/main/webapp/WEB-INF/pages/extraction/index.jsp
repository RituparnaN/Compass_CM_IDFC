<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<div class="row">
	<div class="col-sm-12">
		<div class="modal fade bs-example-modal-lg" id="extractionDMMessageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  			<div class="modal-dialog modal-lg">
  				<div class="modal-content">
  					<div class="modal-header">
  						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				        <h4 class="modal-title" id="myModalLabel">Extraction Message</h4>
				    </div>
				    <div class="modal-body" style="max-height: 550px; overflow: auto;">
				        <table id="extractionMessageModal" class="row-xs-height table table-striped table-bordered" cellspacing="0" width="100%" style="font-size: 12px;">
							<thead>
							<tr>
								<th>TIMESTAMP</th>
								<th>PROCESSNAME</th>
								<th>PROCESSMESSAGE</th>
							</tr>
							</thead>
						</table>
				    </div>
  				</div>
  			</div>
  		</div>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function(){
	$.fn.dataTableExt.sErrMode = 'throw';
	var timer;
	var extractionRunningStatus = '${EXTRACTION}';
	
	$("#extractionFromDate").datepicker({
		defaultDate: "+1w",
		numberOfMonths: 1,
		changeMonth: true,
	    dateFormat:'dd/mm/yy',
	    onClose: function(selecteddate){
	    	$("#extractionToDate").datepicker("option", "minDate", selecteddate);
	    }
	});
	
	$("#extractionToDate").datepicker({
		changeMonth: true,
		defaultDate: "+1w",
		numberOfMonths: 1,
	    dateFormat:'dd/mm/yy',
	    onClose: function(selecteddate){
	    	$("#extractionFromDate").datepicker("option", "maxDate", selecteddate);
	    }
	});
	
	if(extractionRunningStatus == 0){
		$("#lastExtraction").html("<center><button class='btn btn-sm btn-success' id='viewFullLog1'>View Full Log</button></center>");
	}else if(extractionRunningStatus == 1){
		$("#lastExtraction").html("Extraction is currently running. Loading status...");
		runExtractionStatus();
	}else{
		$("#lastExtraction").html("Loading last extraction status...");
		extractionStatus();
	};
	
	$("#startExtraction").click(function(){
		var button = $(this);
		var fromDate = $("#extractionFromDate").val();
		var toDate = $("#extractionToDate").val();
		$.ajax({
			url : '<c:url value="checkExtractionDates"/>',
			type : 'POST',
			cache : false,
			data : 'fromDate='+fromDate+'&toDate='+toDate,
			success : function(res){
				if(res.STATUS == 1){
					if(confirm("Are you sure you want to start extraction?")){
						$(button).attr("disabled","disabled");
						$(button).html("Starting...");
						$("#bottomFrame").hide();
						$.ajax({
							url : '<c:url value="startExtraction"/>',
							type : 'POST',
							cache : false,
							data : 'fromDate='+fromDate+'&toDate='+toDate,
							success : function(response){
								$(button).html("Started");
								runExtractionStatus();
								if(response != ""){
									$("#lastExtraction").html("Please wait while system is loading extraction status");
									alert(response);
								}else{
									$("#lastExtraction").html("Extraction started. Loading status...");
								}
							},
							error : function(d,e,f){
								$(this).removeAttr("disabled");
								$(this).html("Start");
								$("#lastExtraction").html("Error while fetching extraction status. \n"+a+"\n"+b+"\n"+c);
							}
						});	
					}
				}else{
					alert(res.MESSAGE);
				}
			}
		});
	});
	
	$("#cancelExtraction").click(function(){
		if(confirm("Are you sure you want to terminate extraction process?")){
			$.ajax({
				url : '<c:url value="cancelExtraction"/>',
				type : 'POST',
				cache : false,
				success : function(res){
					alert(res);
				}
			});
		}
	});
		
	
	$("#viewFullLog, #viewFullLog1").click(function(){
		$("#extractionDMMessageModal").modal('show');
		var table = $("#extractionMessageModal").dataTable({
			processing : true,
			destroy: true,
			ajax : {
				'url' : '<c:url value="getExtractionProcessMessage"/>',
				'type': 'POST'
			},
			columns : [ {
				'data' : 'TIMESTAMP'
			}, {
				'data' : 'PROCESSNAME'
			}, {
				'data' : 'PROCESSMESSAGE'
			} ],
			error : function() {
				alert("Error occured while retriving data...");
			}
		});
	});
});

function runExtractionStatus(){
	timer = setInterval(function() {
		extractionStatus();
	}, 5000);
}

function clearIndexInterval() {
	clearInterval(timer);
}

function extractionStatus(){
	$.ajax({
		url : '<c:url value="getExtractionStatus"/>',
		type : 'POST',
		cache : false,
		success : function(res){
			$("#lastExtraction").html("");
			$("#bottomFrame").fadeIn('slow');
			$("#strProcessStartDate").html(res.strProcessStartDate);
			$("#strProcessEndDate").html(res.strProcessEndDate);
			$("#startTime").html(res.strStartDate);

			$("#timeMessage").html(res.strEndDateMessage);
			$("#timeMessageValue").html(res.strEndDateValue);
			
			$("#timeMessage1").html(res.timeMessage);
			$("#timeMessageValue2").html(res.timeValue);

			var tab1 = "<table class='table table-bordered' style='font-size:11px;'><tbody><tr>"+
			"<th width='20%'>Timestamp</th> "+
			"<th width='25%'>Process Name</th> "+
			"<th width='55%'>Message</th> "+
			"</tr>";
			if(res.extractionDBMessageList != null && res.extractionDBMessageList != "null"){
				$.each(res.extractionDBMessageList, function (key, data) {
					if(data.rowNum == "-1")
						tab1 = tab1 + "<tr style='color : red;'>";
					else
						tab1 = tab1 + "<tr>";
			    	tab1 = tab1 + "<td width='25%'>"+data.dateTime+"</td>";
			    	tab1 = tab1 + "<td width='25%'>"+data.processName+"</td>";
			    	tab1 = tab1 + "<td width='50%'>"+data.statusMessage+"</td>";
			    	tab1 = tab1 + "</tr>";
				});
			}
			tab1 = tab1 + "</tbody></table>";
			$("#extractionMessageDetails").html(tab1);
			
			
			var tab2 = "<table class='table table-striped table-bordered' style='font-size:11px;'><tbody><tr>"+
						"<th width='15%'>Process Name</th> "+
						"<th width='22%'>Start Time</th> "+
						"<th width='23%'>End Time</th> "+
						"<th width='15%'>Status</th> "+
						"<th width='25%'>Time taken</th>"+
						"</tr>";
			if(res.runningProc != null && res.runningProc != "null"){
				$.each(res.runningProc, function (key, data) {
				    tab2 = tab2 + "<tr><td style='color : green; text-align : center; font-size:18px; font-family : Segoe UI Semibold;' colspan='5'><b>Group : "+key+"</b></td></tr>";
				    $.each(data, function (index, data) {
					    if(data.status == "Interrupted"){
					    	tab2 = tab2 + "<tr style='color : red;'>";
						}else if(data.status == "Skipped"){
					    	tab2 = tab2 + "<tr style='color : blue;'>";
						}else{
							tab2 = tab2 + "<tr>";
					    } 
				    	
				    	tab2 = tab2 + "<td>"+index+"</td>";
				    	tab2 = tab2 + "<td>"+data.startDate+"</td>";
				    	tab2 = tab2 + "<td>"+data.endDate+"</td>";
				    	tab2 = tab2 + "<td>"+data.status+"</td>";
				    	tab2 = tab2 + "<td>"+data.completeTime+"</td>";
				    	tab2 = tab2 + "</tr>";
				    });
				    
				})
			}
			tab2 = tab2 + "</tbody></table>";
			
			$("#groupStatus").html(tab2);
			
			if(res.status != 1)
				$("#startExtractionButton").removeAttr("disabled");
			
			if(res.status == 1 && res.percentage < 100){
				$(".progress-bar").removeClass('progress-bar-success');
				$(".progress-bar").removeClass('progress-bar-danger');
				$(".progress-bar").addClass('active');
				$(".progress-bar").addClass('progress-bar-striped');
				$(".progress-bar").attr("aria-valuenow", res.percentage);
				$(".progress-bar").css("width",res.percentage+"%");
				$(".progress-bar").html(res.percentage+"%");
			}
			if(res.status == 2 && res.percentage == 100){
				$(".progress-bar").removeClass('active');
				$(".progress-bar").removeClass('progress-bar-striped');
				$(".progress-bar").removeClass('progress-bar-danger');
				$(".progress-bar").addClass('progress-bar-success');
				$(".progress-bar").attr("aria-valuenow","100");
				$(".progress-bar").css("width","100%");
				$(".progress-bar").html("100%");
				$("#startExtraction").removeAttr("disabled");
				$("#startExtraction").html("Start");
				clearIndexInterval();
			}
			if((res.status == 3 || res.status == 4) && res.percentage < 100){
				$(".progress-bar").removeClass('active');
				$(".progress-bar").removeClass('progress-bar-striped');
				$(".progress-bar").removeClass('progress-bar-success');
				$(".progress-bar").addClass('progress-bar-danger');
				$(".progress-bar").attr("aria-valuenow", res.percentage);
				$(".progress-bar").css("width",res.percentage+"%");
				$(".progress-bar").html(res.percentage+"%");
				$("#startExtraction").removeAttr("disabled");
				$("#startExtraction").html("Start");
				clearIndexInterval();
			}
		},
		error : function(a,b,c){
			$("#lastExtraction").html("Error while fetching extraction status. \n"+a+"\n"+b+"\n"+c);
		}
	});
}
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header extractionStartPanel clearfix">
				<h6 class="card-title pull-${dirL}">Start Extraction</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable">
					<tbody>
						<tr>
							<td width="30%">Date Range</td>
							<td width="70%">
								<div class="input-daterange input-group">
									<span class="input-group-addon">FROM</span>
									<input type="text" class="form-control" id="extractionFromDate" value="${FROMDATE}"/>
									<span class="input-group-addon">TO</span>
									<input type="text" class="form-control" id="extractionToDate" value="${TODATE}"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="startExtraction" class="btn btn-info btn-sm"
					<c:if test="${EXTRACTION == 1}">disabled="disabled"</c:if>
					>Start</a>
					<a href="javascript:void(0)" id="cancelExtraction" class="btn btn-warning btn-sm">Cancel</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="lastExtraction"></div>
<div id="bottomFrame" style="display: none;">
	<div class="row">
		<div class="col-lg-12">
			<div class="progress" style="margin: 2px 10px;">
				<div class="progress-bar progress-bar-striped active" style="width: 0%" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">0%</div>
			</div>
		</div>
	</div>
			
	<br/>
		
	<div class="row">
		<div class="col-lg-4">
        	<div class="card card-primary">
        		<div class="card-header extractionStartPanel clearfix">
					<h6 class="card-title pull-${dirL}">Extraction Running Status</h6>
				</div>
				<table class="table table-striped table-bordered" style="width: 100%">
					<tbody>
						<tr>
							<th width="35%">From Date</th>
							<td width="65%"><span id="strProcessStartDate"></span></td>
						</tr>
						<tr>
							<th>To Date</th>
							<td><span id="strProcessEndDate"></span></td>
						</tr>
						<tr>
							<th>Started</th>
							<td><span id="startTime"></span></td>
						</tr>
						<tr>
							<th><span id="timeMessage"></span></th>
							<td><span id="timeMessageValue"></span></td>
						</tr>
						<tr>
							<th><span id="timeMessage1"></span></th>
							<td><span id="timeMessageValue2"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="col-lg-8">
			<div class="card card-primary">
				<div class="card-header clearfix">
					<h6 class="card-title pull-${dirL}">Extraction Details</h6>
				</div>
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active">
						<a class="nav-link active" href="#extractionMessage" role="tab" data-toggle="tab">Extraction Message</a>
					</li>
					<li role="presentation">
						<a class="nav-link" href="#groupStatus" role="tab" data-toggle="tab">Group Status</a>
					</li>
				</ul>
				
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="extractionMessage">
						<div id="extractionMessageDetails"  style="overflow-y: auto; max-height: 200px; "></div>
	                    <div class="card-footer"><center><button class="btn btn-sm btn-success" id="viewFullLog">View Full Log</button></center></div>
					</div>
					<div role="tabpanel" class="tab-pane" id="groupStatus" style="overflow-y: auto; max-height: 250px; font-size : 14px;"></div>
				</div>
			</div>
		</div>
	</div>
</div>