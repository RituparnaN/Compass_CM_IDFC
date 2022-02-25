<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();

	List<Map<String, String>> fatchLog = (List<Map<String, String>>) request.getAttribute("FETCHLOG");
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<!--[if lt IE 9]>
                <script src="<%=contextPath%>/scripts/html5shiv.js"></script>
                <script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
                <script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="<%=contextPath%>/scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>

<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/dataTables.bootstrap.css" />
<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css">
<style type="text/css">
.datepicker{
	background-image:url("<%=contextPath%>/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
}
</style>
<script type="text/javascript">
	var timer;

	$(document).ready(function(){
		$("#aofFetchLogTable").DataTable({
			"bSort" : false
		});
		
		startFetchingStatus();

		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });

		$("#fetchAOF").click(function(){
			$("#fetchAOF").attr("disabled", "disabled");
			$("#fetchAOF").attr("value","Starting...");
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/fetchAccountOpeningMandateFiles",
				cache : false,
				success : function(response){
					alert(response);
					startFetchingStatus();
				},
				error : function(a,b,c){
					alert("Could not process the request");
				}
			});
		});
	});

	function startFetchingStatus(){
		timer = setInterval(function(){ 
			fetchStatus();
		}, 2000);
	}

	function stopFetching(){
		clearInterval(timer);
	}

	function fetchStatus(){
		$.ajax({
			type : "POST",
			url : "<%=contextPath%>/getAccountOpeningMandateFetchStatus",
			cache : false,
			success : function(response){
				if(response.STATUS != 1){
					stopFetching();
				}
				if(response.STATUS != 0){
					$("#logTable").show();
				}
				$("#fetchAOF").attr("value","Start Fetching");
				if(response.STATUS == 1){
					$("#fetchAOF").attr("disabled", "disabled");
					$("#status").html("Running");
					$("#startTime").html(response.STARTTIME);
					$("#endTime").html(response.ENDTIME);
					$("#pathCount").html(response.PATHCOUNT);
					$("#count").html(response.COUNT);
				}else{
					$("#fetchAOF").removeAttr("disabled");
					$("#status").html("Completed");
					$("#startTime").html(response.STARTTIME);
					$("#endTime").html(response.ENDTIME);
					$("#pathCount").html(response.PATHCOUNT);
					$("#count").html(response.COUNT);
				}
			},
			error : function(a,b,c){
				alert("Could not process the request");
			}
		});
	}
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">Fetch Account Opening Mandate</div>
				</br><br/>
				<center>
					<input type="button" class="btn btn-success btn-small" id="fetchAOF" value="Start Fetching"/>
				</center>
				</br>
				</br>
				<table class="table table-bordered" style="display:none;" id="logTable">
					<tr>
						<td colspan="2">
							Status : <strong id="status"></strong>
						</td>
					</tr>
					<tr>
						<td>
							Start Time : <strong id="startTime"></strong>
						</td>
						<td>
							End Time : <strong id="endTime"></strong>
						</td>
					</tr>
					<tr>
						<td>
							Remaining Paths : <strong id="pathCount"></strong>
						</td>
						<td>
							Complete Count : <strong id="count"></strong>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<%
	if(fatchLog != null && fatchLog.size() > 0){
	%>
		<table class="table table-bordered table-stripped" id="aofFetchLogTable">
			<thead>
				<tr>
					<th>Start Time</th>
					<th>End Time</th>
					<th>Parent Path</th>
					<th>Total Fetched</th>
					<th>Fetched By</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(int i = 0; i < fatchLog.size(); i++){
						Map<String, String> fetch = fatchLog.get(i);
						%>
						<tr>
							<td><%= fetch.get("STARTDATE") != null ? fetch.get("STARTDATE") : "" %></td>
							<td><%= fetch.get("ENDDATE") != null ? fetch.get("ENDDATE") : "" %></td>
							<td><%= fetch.get("PARENTPATH") != null ? fetch.get("PARENTPATH") : "" %></td>
							<td><%= fetch.get("MANDATECOUNT") != null ? fetch.get("MANDATECOUNT") : "" %></td>
							<td><%= fetch.get("UPDATEDBY") != null ? fetch.get("UPDATEDBY") : "" %></td>
						</tr>
						<%
					}
				%>
			</tbody>
		</table>
	<%}%>
</div>
</body>
</html>