<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<HTML><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<head>
<title>Report Scheduler</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/html5shiv.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/html5shiv.min.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css"/>
<script type="text/javascript">
	function displayReportDetails(reportGroup){
		var targetUrl = "${pageContext.request.contextPath}/admin/getReportNameList?group="+reportGroup;
		$.ajax({
			url : targetUrl,
			type : "GET",
			cache : false,
			success : function(res){
				$("#reportName").val("");
				$("#extReport").show('fadeIn');
				$("#reportDetails").html(res);
			}
		});
	}
	function extractReportName(elm){
		var text = elm.options[elm.selectedIndex].text;
		$("#reportName").val(text);
	}

	function downloadReport(){
		var mywin = window.open('${pageContext.request.contextPath}/getScheduledReport?path=root','DownloadScheduleReport','height=600,width=1100,resizable=yes, scrollbars=Yes');
		mywin.moveTo(10,02);
	}
</script>
</head>
<body>
	<div class="card-body">
		<div class="row">
			<div class="col-lg-12">
				<div class="card card-default">
					<div class="card-header">
						<i class="fa fa-bar-chart-o fa-fw"></i>Search Report
						<span style="margin-left: 60%">
							<button type="button" class="btn btn-primary" onclick="downloadReport()">
								Download Scheduled Reports
							</button>
						</span>
					</div>					
					<form action="${pageContext.request.contextPath}/admin/searchAllReportForScheduling" target="searchResultFrame" method="GET">
							<div class="form-group">
								<label class="col-sm-4 control-label">Report Type</label>
								<div class="col-sm-4">
									<select class="form-control input-sm" onchange="displayReportDetails(this.value)">
										<option value="">Select One</option>
										<option value="TRANSACTIONREPORTS">Transaction Based Reports</option>
										<option value="MISCELLANEOUSREPORTS">Miscellaneous Reports</option>
									</select>
								</div>
							</div>
							<div id="extReport" style="display: none;">
							<div class="form-group">
								<label class="col-sm-4 control-label">Report Name</label>
								<div class="col-sm-4" id="reportDetails">
								</div>
							</div>
							<input type="hidden" name="reportName" id="reportName"/>
							<center>
							<div class="form-group">
								<div class="col-sm-4">
									<button type="submit" class="btn btn-primary">Get Reports</button>
								</div>
							</div>
							</center>							
							</div>	
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>